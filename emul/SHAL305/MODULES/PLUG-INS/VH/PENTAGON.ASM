;Модуль поддержки расширенной памяти Пентагона.

IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE '..\EMUDATA.INC'

DATASEG
LABEL _DSC BYTE ;Описание
                db 'Pentagon RAM Support ['
Preview         db '512K]',0

txtHelp         db 'Pentagon RAM emulation module v1.0',10,'(c) Hexman/BYTEX, 2:469/32.7@Fidonet',0

TblData         dd ? ;Адрес таблицы данных эмулятора
WinPnt          dd ? ;Адрес данных панели диалога
Mem             dd 2 ;Значение конфигурации
TblMem          db 0,8,24 ;Маски для старших битов порта

;Строки для конфигурации
TxtCfgMem       db 'PentagonRAM=',0
TxtCfg128       db '128K',0
TxtCfg256       db '256K',0
TxtCfg512       db '512K',0

;Данные о конфигурации
_CFG            CfgDat <OFFSET CfgTable,1>
CfgTable        CfgS <TTbl,OFFSET TxtCfgMem,OFFSET CfgMem>
CfgMem          CnTbl <OFFSET Mem,OFFSET TblTCMem,3>
TblTCMem        dd OFFSET TxtCfg128, OFFSET TxtCfg256, OFFSET TxtCfg512

;Строки для интерфейса
TxtTitle        db 'Pentagon RAM',0
TxtMem          db 'RAM ',1,'size:',0Ah,'128K',0Ah,'256K',0Ah,'512K',0
TxtOk           db 1,'OK',0
TxtCancel       db 1,'Cancel',0

CODESEG


;Инициализация (сохранение адреса данных эмулятора)
PROC _INI
        mov     [TblData],eax
        ret

;Установка сегментов памяти
_MEM:   mov     ebx,[TblData]
        mov     eax,[Mem]
        mov     ah,[TblMem+eax]
        mov     al,[ebx+EmuData.Port7FFD]
        shr     al,3
        and     al,ah
        mov     ah,[ebx+EmuData.Port7FFD]
        and     ah,007h
        or      al,ah
        xor     ah,ah
        shl     eax,0Eh
        add     eax,[ebx+EmuData.SpecRAM]
        mov     [(ebx+EmuData.SpecSeg)+0Ch],eax
        mov     ah,1
        ret

;Конфигурирование
_SET:   push    ebp

        ;Создание окна
        mov ebp,[TblData]
        MWinCreate ebp,01Ah,008h,01Bh,008h,01Fh
        mov [WinPnt],eax

        ;Заголовок
        MWinTitle ebp,eax,<OFFSET TxtTitle>,0F0h

        ;"Cancel"
        MSetButton ebp,[WinPnt],00Dh,005h,00Ah,<OFFSET TxtCancel>,0

        ;"OK"
        MSetButton ebp,[WinPnt],00Dh,003h,00Ah,<OFFSET TxtOk>,001h

        ;"RAM size"
        MSetRadio ebp,[WinPnt],3,002h,<OFFSET TxtMem>,<OFFSET CfgMem>

        ;Подсказка
        MWinHelp ebp,[WinPnt],44,6,<OFFSET txtHelp>

        ;Обработка окна
        MWinExe ebp,[WinPnt]

        ;Проверка результата окна
        test    eax,eax
        jz      @@Exit

        ;Сохранение результата
        MWinResult ebp,[WinPnt]

        ;Удаление окна
@@Exit: MWinRemove ebp,[WinPnt]
        pop ebp
        ret

;Установка объёма памяти в названии модуля
_INS:   mov     eax,[Mem]
        mov     ebx,eax
        add     eax,eax
        add     eax,eax
        add     eax,ebx ;eax=[Mem]*5
        mov     ebx,eax
        mov     cx,3
        xor     eax,eax
        mov     eax,0
@@Loop: mov     dl,[(TxtCfg128+ebx)+eax]
        mov     [Preview+eax],dl
        inc     eax
        dec     cx
        jnz     @@Loop
        ret
ENDP
END
