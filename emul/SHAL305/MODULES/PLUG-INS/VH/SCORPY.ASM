;*********************************************************************
;
; Поддержка расширенной памяти Скорпиона.
;
;*********************************************************************

IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE "..\EMUDATA.INC"

DATASEG
LABEL _DSC BYTE
                db "Scorpion Support",0
hlpText         db "Scorpion Support Addition",10
                db "(c) Hexman/BYTEX, 2:469/32.7@Fidonet.",0

Mem             dd 1                        ;значение конфигурации
Installed       db 0

TblMem          db 00h,10h,10h              ;маски для старших битов порта

;Строки для конфигурации
TxtCfgMem       db "ScorpRAM=",0
TxtCfgPrn       db "ScorpPRN=",0
TxtCfgUse       db "ScorpUsePRN=",0
TxtCfg128       db "128K",0
TxtCfg256       db "256K",0
TxtCfg1024      db "1024K",0
TxtCfgUse0      db "0",0
TxtCfgUse1      db "1",0

PrntLog         db "scorpion.prn",0             ;"принтер"
                db 8 dup (0)


;Данные о конфигурации
_CFG            CfgDat <OFFSET CfgTable,3> ;адрес таблицы, к-во элементов

;Таблица конфигурации
CfgTable        CfgS <TTbl,OFFSET TxtCfgMem,OFFSET CfgMem> ;тип, адрес подписи, адрес таблицы данных
                CfgS <TTxt,OFFSET TxtCfgPrn,OFFSET CfgPrn>
                CfgS <TNum,OFFSET TxtCfgUse,OFFSET CfgUse>

CfgMem          CnTbl <OFFSET Mem,OFFSET TblTCMem,3>
CfgPrn          CnTxt <OFFSET PrntLog, 20>
CfgUse          CnNum <OFFSET UsePrinter, 0, 1>

TblTCMem        dd OFFSET TxtCfg128, OFFSET TxtCfg256, OFFSET TxtCfg1024

;Строки для интерфейса
TxtTitle        db "Scorpion Support",0
TxtMem          db "RAM ",1,"size",0Ah,"128K",0Ah,"256K",0Ah,"1024K",0
TxtUse          db 1,"Use printer",0
TxtPrn          db 1,"Printer output:",0
TxtOk           db 1,"OK",0
TxtCancel       db 1,"Cancel",0

UDATASEG
TblData         dd ? ;адрес таблицы данных эмулятора
PortSCORPION    db ? ;копия порта 1FFD
PrntData        db ? ;байт, записаный в принтер
FileHandle      dw ?
strPrinter      dd ?
UsePrinter      dd ?

CODESEG

;Инициализация файла принтера
PROC _INS
        mov     al,[Installed]
        test    al,al
        jnz     @@IRet
        mov     al,1
        mov     [Installed],al

        ;открытие файла
        mov     ah,3dh
        mov     al,1 ;write
        mov     edx,OFFSET PrntLog
        int     21h
        mov     [FileHandle],ax
        jc      @@ICrt

        mov     bx,ax
        mov     al,2
        mov     ah,42h
        mov     cx,0
        mov     dx,0
        int     21h ;переход в конец файла

        jmp     @@IRet

@@ICrt: mov     ah,3ch
        mov     cx,00
        mov     edx,OFFSET PrntLog
        int     21h
        mov     [FileHandle],ax

        ;mov     ah,6ch
        ;mov     bx,1
        ;mov     cx,0   ;file attrs
        ;mov     dx,11h ;action
        ;mov     esi,OFFSET PrntLog


@@IRet: ret
ENDP

;Reset (установка нулевого значения порта)
PROC _RES
        mov     [PortSCORPION],000h
        ret
ENDP


;Чтение из порта BX
;Выход: AH=0 - порт не обработан. AH<>0 - порт обработан, AL=значение

PROC _IN_
        cmp     bx,0FFFEh                       ;адрес скорповского порта
        jnz     @@Ret1
        push    ebx
        mov     ebx,[UsePrinter]
        test    ebx,ebx
        pop     ebx
        jz      @@Ret1
        mov     ah,0ffh                         ;<>0 - порт обработан
        mov     al,000h                         ;считаное значение
@@Ret1: ret
ENDP


;Запись в порт
PROC _OUT
        cmp     bx,0FFDDh                       ;адрес скорповского порта
        jnz     _OUTM

        ;проверка флажка 'Принтер..'
        push    ebx
        mov     ebx,[UsePrinter]
        test    ebx,ebx
        pop     ebx
        jz      _OUTM

        mov     [PrntData],al
        push    ebp
        mov     edx,OFFSET PrntData             ;adr
        mov     ecx,1                           ;len
        mov     bx,[FileHandle]                 ;handle
        mov     ah,40h
        int     21h
        pop     ebp
        mov     ah,1 ;порт обработан
        jp      @@Ret

_OUTM:  cmp     bx,01FFDh
        jnz     @@Ret
        mov     [PortSCORPION],al

;Установка сегментов памяти
_MEM:   push    ecx
        push    ebp
        push    ebx
        mov     ebx,[TblData]                   ;адрес данных эмулятора
        mov     eax,[Mem]                       ;значение конфигурации

        ;скорповская память
        mov     ah,[TblMem+eax]
        mov     al,[PortSCORPION]
        and     al,ah
        shr     al,1
        push    eax

        mov     eax,[Mem]
        cmp     eax,2
        jnz     @@Just

        ;пентагоновская память
        pop     eax
        mov     ah,[ebx+EmuData.Port7FFD]
        shr     ah,3
        and     ah,24
        or      al,ah
        push    eax

@@Just: pop     eax
        mov     ah,[ebx+EmuData.Port7FFD]       ;чтение содержимого порта
        and     ah,007h                         ;выделение младших битов
        or      al,ah
        xor     ah,ah
        shl     eax,0Eh                         ;рассчет адреса страницы
        add     eax,[ebx+EmuData.SpecRAM]
        mov     [(ebx+EmuData.SpecSeg)+0Ch],eax ;установка страницы памяти


;Смещение +0000h - ROM 128,
;Смещение +4000h - ROM 48,
;Смещение +8000h - ROM TR-DOS,
;Смещение +C000h - Любое пользовательское ПЗУ.

        ;установка ПЗУшки
        mov     ecx,[ebx+EmuData.SpecROM]

        mov     al,[PortSCORPION]
        and     al,2                ;бит 1 установлен
        jz      @@Real
        add     ecx,0C000h
        jmp     @@Rom

@@Real: mov     ah,[ebx+EmuData.Port7FFD]
        and     ah,16
        cmp     ah,0
        jz      @@Rom
        add     ecx,04000h

@@Rom:  mov     [ebx+EmuData.SpecSeg],ecx

        mov     al,[PortSCORPION]
        and     al,1
        jz      @@Fin
        mov     eax,[ebx+EmuData.SpecRAM]
        mov     [ebx+EmuData.SpecSeg],eax

@@Fin:  pop     ebx
        pop     ebp
        pop     ecx
        mov     ah,001h
@@Ret:  ret
ENDP

;┌─────────────────────────┐
;│ Конфигурирование модуля │
;└─────────────────────────┘

UDATASEG
WinPnt          DD ? ;Адрес данных панели диалога
CODESEG

PROC _INI
        mov     [TblData],eax
        ret

_UNI:   mov     al,2
        mov     cx,0
        mov     dx,0
        mov     bx,[FileHandle]
        mov     ah,42h
        int     21h ;to the end of file
        jc      @@UniX
        or      ax,dx ;AX:DX = file size
        test    ax,ax
        jnz     @@UniX

        mov     ah,41h
        mov     edx,OFFSET PrntLog
        int     21h ;delete file

@@UniX: mov     ah,3eh
        mov     bx,[FileHandle]
        int     21h ;close file
        ret

_SET:   push    ebp

        ;Создание окна
        mov ebp,[TblData]
        MWinCreate ebp,24,7,31,10,01Fh
        mov [WinPnt],eax

        ;Установка заголовка окна
        MWinTitle ebp,eax,<OFFSET TxtTitle>,0F0h

        ;Установка помощи
        MWinHelp ebp,[WinPnt],48,6,<OFFSET hlpText>

        ;Установка кнопки "Отмена"
        MSetButton ebp,[WinPnt],17,7,00Ah,<OFFSET TxtCancel>,0

        ;Установка кнопки "OK"
        MSetButton ebp,[WinPnt],4,7,00Ah,<OFFSET TxtOk>,1

        ;Установка строки "Принтер"
        MSetInputTxt ebp,[WinPnt],14,4,15,<OFFSET TxtPrn>,<OFFSET CfgPrn>
        mov [strPrinter],eax

        ;Установка флажка 'Принтер'
        MSetCheckBox ebp,[WinPnt],14,2,<OFFSET TxtUse>,<OFFSET UsePrinter>

        ;Установка переключателя "Объем"
        MSetRadio ebp,[WinPnt],2,2,<OFFSET TxtMem>,<OFFSET CfgMem>


        MWinExe ebp,[WinPnt]            ;Обработка окна
        test    eax,eax                 ;Проверка результата окна
        jz      @@Exit                  ;
        MWinResult ebp,[WinPnt]         ;Сохранение результата окна

;Удаление окна
@@Exit: mov     eax,[WinPnt]
        call    [ebp+EmuData.WinRemove]
        pop     ebp
        ret

ENDP

END
