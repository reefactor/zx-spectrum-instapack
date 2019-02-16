IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE "EMUDATA.INC"

DATASEG

LABEL _DSC BYTE ;Описание
        DB "Работа с лентой",0

;Строки для интерфейса

TxtTitle        DB "Работа с лентой",0
TxtCfgKey       DB "Key=",0
TxtCfgF7        DB "F7",0
TxtCfgF8        DB "F8",0
TxtCfgF9        DB "F9",0
TxtCfgF10       DB "F10",0
TxtCfgF11       DB "F11",0
TxtCfgF12       DB "F12",0

;Данные конфигурации
TblTCKey        DD OFFSET TxtCfgF7,OFFSET TxtCfgF8,OFFSET TxtCfgF9
                DD OFFSET TxtCfgF10,OFFSET TxtCfgF11,OFFSET TxtCfgF12

CfgKey          CnTbl <OFFSET Key,OFFSET TblTCKey,6>

;Таблица конфигурации
CfgTable        CfgS <TTbl,OFFSET TxtCfgKey,OFFSET CfgKey>

;Данные о конфигурации
_CFG            CfgDat <OFFSET CfgTable,1>

;Строки для интерфейса
TxtKey          DB "Клавиша",0Ah,"F7",0Ah,"F8",0Ah,"F9",0Ah
                DB "F10",0Ah,"F11",0Ah,"F12",0

TxtTimeNum      DB "Частота",0
TxtOk           DB "OK",0
TxtCancel       DB "Отмена",0
CfgTimeNum      CnNum <OFFSET TimeNum,400h,1000h>
TimeNum         DD 850h ;Количество тактов
UDATASEG
TblData         DD ? ;Адрес таблицы данных эмулятора


CODESEG
;Инициализация (сохранение адреса данных эмулятора)
PROC _INI
        mov     [TblData],eax
        ret
ENDP


;Конфигурирование
CODESEG

PROC _INP
        cmp bx,7ffeh
        je P7FFE
        ret
P7FFE:  push ax
        mov dx,224h  ;Read LineIn
        mov al,3dh
        out dx,al
        inc dx
        mov al,10000b
        out dx,al

        mov ecx,[TimeNum] ;Freq
PauseF: loop PauseF

        mov dx,22ch  ;Read
        mov al,20h
        out dx,al
        mov dx,22ah
        in al,dx     ; to al
        test al,80h
        jz P7FFE_1
        pop ax
        and al,10111111b
        jmp P7FFE_2
P7FFE_1:pop ax
        or al,01000000b
P7FFE_2:ret
ENDP
;Конфигурирование
UDATASEG
WinPnt          DD ? ;Адрес данных панели диалога
Key             DD ? ;Рабочая клавиша
CODESEG

PROC _SET
        push    ebp

;Создание окна
        mov     ebp,[TblData]
        mov     eax,016h
        mov     ebx,005h
        mov     ecx,01Fh
        mov     edx,00Dh
        mov     esi,01Fh
        call    [ebp+EmuData.WinCreate]
        mov     [WinPnt],eax ;Сохранение адреса данных окна

;Установка заголовка окна
        mov     ebx,OFFSET TxtTitle
        mov     ecx,0F0h
        call    [ebp+EmuData.WinTitle]

;Установка переключателя "Клавиша"
        mov     eax,[WinPnt]
        mov     ebx,006h
        mov     ecx,002h
        mov     edx,OFFSET TxtKey
        mov     edi,OFFSET CfgKey
        call    [ebp+EmuData.SetRadio]

;Установка кнопки "Отмена"
        mov     eax,[WinPnt]
        mov     ebx,011h
        mov     ecx,00Ah
        mov     edx,OFFSET TxtCancel
        mov     esi,00Ah
        xor     edi,edi
        call    [ebp+EmuData.SetButton]

;Установка кнопки "OK"
        mov     eax,[WinPnt]
        mov     ebx,004h
        mov     ecx,00Ah
        mov     edx,OFFSET TxtOk
        mov     esi,00Ah
        mov     edi,001h
        call    [ebp+EmuData.SetButton]

;Обработка окна
        mov     eax,[WinPnt]
        call    [ebp+EmuData.WinExe]

;Проверка результата окна
        test    eax,eax
        jz      @@Exit

;Сохранение результата окна
        mov     eax,[WinPnt]
        call    [ebp+EmuData.WinResult]

;Удаление окна
@@Exit: mov     eax,[WinPnt]
        call    [ebp+EmuData.WinRemove]

        pop     ebp
        ret
ENDP
;Обработка клавиш
MACRO KeyProc KeyP,Num
PROC KeyP
        cmp     [Key],Num ;Проверка: эта ли клавиша выбрана ?
        jz      Refresh
        ret
ENDP
ENDM

        KeyProc _F7_,000h
        KeyProc _F8_,001h
        KeyProc _F9_,002h
        KeyProc _F10,003h
        KeyProc _F11,004h
        KeyProc _F12,005h

PROC Refresh
        push    ebp


        mov     ebp,[TblData]
        call [ebp+EmuData.TextMode]

;Создание окна
        mov     eax,016h
        mov     ebx,007h
        mov     ecx,023h
        mov     edx,009h
        mov     esi,01Fh
        call    [ebp+EmuData.WinCreate]
        mov     [WinPnt],eax ;Сохранение адреса данных окна

;Установка заголовка окна
        mov     ebx,OFFSET TxtTitle
        mov     ecx,0F0h
        call    [ebp+EmuData.WinTitle]


;Установка строки ввода цифры "Количество прерываний"
        mov     eax,[WinPnt]
        mov     ebx,00ch
        mov     ecx,003h
        mov     edx,OFFSET TxtTimeNum
        mov     edi,OFFSET CfgTimeNum
        call    [ebp+EmuData.SetInputNum]

;Установка кнопки "Отмена"
        mov     eax,[WinPnt]
        mov     ebx,013h
        mov     ecx,006h
        mov     edx,OFFSET TxtCancel
        mov     esi,00Ch
        xor     edi,edi
        call    [ebp+EmuData.SetButton]

;Установка кнопки "OK"
        mov     eax,[WinPnt]
        mov     ebx,004h
        mov     ecx,006h
        mov     edx,OFFSET TxtOk
        mov     esi,00Ch
        mov     edi,001h
        call    [ebp+EmuData.SetButton]

;Обработка окна
        mov     eax,[WinPnt]
        call    [ebp+EmuData.WinExe]

;Проверка результата окна
        test    eax,eax
        jz      @@Exit

;Сохранение результата окна
        mov     eax,[WinPnt]
        call    [ebp+EmuData.WinResult]

;Удаление окна
@@Exit: mov     eax,[WinPnt]
        call    [ebp+EmuData.WinRemove]
        mov eax,ebp
        pop     ebp
        jmp     [eax+EmuData.SpecMode]



ENDP

END
