;Данный модуль - поддержка расширенной памяти Pentagon 512.

IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE "EMUDATA.INC"

DATASEG
Mem             DD 002h

TblMem          DB 00h,01h,03h

LABEL _DSC BYTE ;Описание
        DB "Pentagon 512 by Lazy/ETC/RUSH",0

;Строки для конфигурации
TxtCfgMem       DB "Memory=",0
TxtCfg128       DB "128k",0
TxtCfg256       DB "256k",0
TxtCfg512       DB "512k",0

;Данные конфигурации
TblTCMem        DD OFFSET TxtCfg128,OFFSET TxtCfg256
                DD OFFSET TxtCfg512

CfgMem          CnTbl <OFFSET Mem,OFFSET TblTCMem,3>

;Таблица конфигурации
CfgTable        CfgS <TTbl,OFFSET TxtCfgMem,OFFSET CfgMem>

;Данные о конфигурации
_CFG            CfgDat <OFFSET CfgTable,1>

;Строки для интерфейса
TxtTitle        DB 1,"Память Pentagon'a",0
TxtMem          DB "О",1,"бъем",0Ah,"128k",0Ah,"256k",0Ah,"512k",0
TxtOk           DB 1,"OK",0
TxtCancel       DB "О",1,"тмена",0

UDATASEG
TblData         DD ? ;Адрес таблицы данных эмулятора

CODESEG

;Инициализация (сохранение адреса данных эмулятора)
PROC _INI
        mov     [TblData],eax
        ret
ENDP

;Reset (установка нулевого значения порта)
PROC _RES
        ret
ENDP

;Установка сегментов памяти
_MEM:   mov     eax,[Mem]
        mov     ah,[TblMem+eax]
        mov     ebx,[TblData]
        mov     al,[ebx+EmuData.Port7FFD]
        shr al,6
        and     al,ah
        mov     ah,[ebx+EmuData.Port7FFD]
        and     ah,007h
        shl     al,03h
        or      al,ah
        xor     ah,ah
        shl     eax,0Eh
        add     eax,[ebx+EmuData.SpecRAM]
        mov     [(ebx+EmuData.SpecSeg)+0Ch],eax
        mov     ah,001h
@@Ret:  ret
ENDP

;Конфигурирование
UDATASEG
WinPnt          DD ? ;Адрес данных панели диалога
CODESEG

PROC _SET
        push    ebp

;Создание окна
        mov     ebp,[TblData]
        MWinCreate ebp,016h,005h,01Fh,00Bh,01Fh
        mov     [WinPnt],eax

;Установка заголовка окна
        MWinTitle ebp,eax,<OFFSET TxtTitle>,0F0h

;Установка переключателя "Объем"
        MSetRadio ebp,[WinPnt],006h,002h,<OFFSET TxtMem>,<OFFSET CfgMem>

;Установка кнопки "Отмена"
        MSetButton ebp,[WinPnt],011h,008h,00Ah,<OFFSET TxtCancel>,0

;Установка кнопки "OK"
        MSetButton ebp,[WinPnt],004h,008h,00Ah,<OFFSET TxtOk>,1

;Обработка окна
        MWinExe ebp,[WinPnt]

;Проверка результата окна
        test    eax,eax
        jz      @@Exit

;Сохранение установок окна
        MWinResult ebp,[WinPnt]

;Удаление окна
@@Exit: MWinRemove ebp,[WinPnt]

        pop     ebp
        ret

ENDP

END
