;----------------------------------------------------------------------------
; Модуль эмуляции CMOS и RTC для эмулятора Н.Шалаева v3.0 или выше
;----------------------------------------------------------------------------

                ideal
                p386
                model use32 small
                assume cs:@code, ds:@data, es:@data
                include "..\emudata.inc"

;----------------------------------------------------------------------------
; Данные
;----------------------------------------------------------------------------

DATASEG

LABEL _DSC BYTE
                db "CMOS emulator"      ;заголовок модуля в эмуляторе
Preview         db " [direct]",0        ;в начало строки будем вставлять 0
TxtHelp         db "CMOS emulation module",10,"(c) Hexman/BYTEX, 2:469/32.7@Fidonet",0

;Строки для конфигурации
TxtCfgFile      db "CmosFileName=",0    ;имя файла-cmos'а
TxtCfgRead      db "CmosWrite=",0       ;разрешать запись?

;Данные о конфигурации
_CFG            CfgDat <OFFSET CfgTable,2>;по адресу CfgTable лежат 2 структ.

CfgTable        CfgS <TTxt, OFFSET TxtCfgFile, OFFSET CfgFile>
                CfgS <TNum, OFFSET TxtCfgRead, OFFSET CfgRead>

CfgFile         CnTxt <OFFSET CmosFile, 20>
CfgRead         CnNum <OFFSET ReadOnly, 0, 1>

InpHelp         db 1,"CMOS file:",0
CmosFile        db "cmos.dat", 13 dup (0)

TxtTitle        db "CMOS Emulator",0            ;заголовок окна
TxtRead         db 1,"Direct to 00h..0dh",0
TxtOk           db 1,"OK",0
TxtCancel       db 1,"Cancel",0

FileHandle      dw 0
ReadOnly        dd 0 ;1=запрет записи в 00...0d
InpAdr          dd 0 ;адрес данных о строке ввода
TblData         dd 0 ;Адрес таблицы данных эмулятора
PortPENT        db 0
WinPnt          dd 0 ;Адрес данных панели диалога

;содержимое портов
PortEFF7        db 0
PortDFF7        db 0
PortBFF7        db 0

CODESEG



;----------------------------------------------------------------------------
; Загрузка и инициализация модуля
;----------------------------------------------------------------------------

_INI:           mov     [TblData],eax   ;адрес таблицы данных эмулятора
                ret

;Инсталляция модуля

_INS:           mov     eax,[ReadOnly]  ;запрет записи..
                test    eax,eax         ;установлен?
                mov     al," "          ;если нет - al = пробел,
                jnz     ins_01
                xor     al,al           ;al = конец строки
ins_01:         mov     [Preview],al    ;изменение заголовка

                mov     ax,3d02h        ;0=read,1=write,2=both
                mov     edx,offset CmosFile
                int     21h             ;открываем файл на запись
                mov     [FileHandle],ax
                jc      ins_02          ;ошибка! надо создать файл
                ret                     ;выходим из процедуры

ins_02:         mov     ah,3ch
                xor     cx,cx
                mov     edx,offset CmosFile
                int     21h             ;создаём файл
                mov     [FileHandle],ax

                mov     bx,ax
                xor     al,al
ins_03:         pusha
                mov     edx,OFFSET PortBFF7
                mov     ecx,1
                mov     ah,40h
                int     21h             ;записываем 256 байт
                popa
                dec     al
                jnz     ins_03
                ret

_UNI:           mov     ah,3eh
                mov     bx,[FileHandle]
                int     21h             ;закрываем файл
                ret


;----------------------------------------------------------------------------
; Запись в порт
;----------------------------------------------------------------------------

_OUT:           cmp     bx,0EFF7h
                jnz     out_01
                mov     [PortEFF7],al   ;сохранение значения порта
                mov     ah,1
                jmp     out_xx

out_01:         cmp     bx,0dff7h
                jnz     out_02
                xor     ah,ah
                mov     bl,al
                mov     al,[PortEFF7]
                and     al,80h
                jz      out_xx
                mov     [PortDFF7],bl   ;сохранение значения порта
                mov     ah,1
                jmp     out_xx

out_02:         cmp     bx,0BFF7h
                jnz     out_xx
                xor     ah,ah
                mov     bl,al
                mov     al,[PortEFF7]
                and     al,80h
                jz      out_xx
                mov     [PortBFF7],bl           ;сохранение значения порта

                mov     al,[PortDFF7]
                cmp     al,0eh
                jnc     out_03
                mov     ebx,[ReadOnly]
                test    ebx,ebx
                jz      out_03

                out     70h,al  ;адрес в CMOS
                mov     al,[PortBFF7]
                out     71h,al  ;считали значение
;               mov     ah,1

out_03:         mov     dl,[PortDFF7]
                call    MovPtr

                mov     edx,OFFSET PortBFF7
                mov     ecx,1
                mov     bx,[FileHandle]
                mov     ah,40h
                int     21h             ;записываем 1 байт

                mov     ah,1

out_xx:         ret



;----------------------------------------------------------------------------
; Чтение из порта
;----------------------------------------------------------------------------

_IN_:           cmp     bx,0eff7h
                jnz     _IN_1
                mov     al,[PortEFF7]
                mov     ah,1
                ret

_IN_1:          cmp     bx,0dff7h
                jnz     _IN_2
                mov     al,[PortDFF7]
                mov     ah,1
                ret

_IN_2:          mov     ah,0
                cmp     bx,0bff7h
                jnz     out_xx
                mov     al,[PortEFF7]
                and     al,80h
                jz      out_xx

                mov     al,[PortDFF7]
                cmp     al,0eh
                jnc     _IN_21

                out     70h,al  ;адрес в CMOS
                jmp     $+2     ;пауза
                in      al,71h  ;считали значение
                mov     ah,1
                ret

_IN_21:         mov     dl,[PortDFF7]
                call    MovPtr                  ;нужное смещение
                mov     edx,OFFSET PortBFF7
                mov     ecx,1
                mov     bx,[FileHandle]
                mov     ah,3fh
                int     21h                     ;считываем 1 байт

                jnc     _IN_22
                xor     ah,ah
                ret

_IN_22:         mov     al,[PortBFF7]
                mov     ah,1
                mov     bx,0BFF7h
                ret


;dl=position
MovPtr: mov     bx,[FileHandle]
        xor     cx,cx
        xor     dh,dh
        mov     ax,4200h
        int     21h
        ret

;┌──────────────────────────╖
;│ Конфигурирование модуля  ║
;╘══════════════════════════╝

_SET:
        push    ebp

        ;Создание окна
        mov ebp,[TblData]
        MWinCreate ebp,27,7,26,10,31 ;Reg,X,Y,dX,dY,C
        mov [WinPnt],eax

        ;Установка заголовка окна
        MWinTitle  ebp,eax,<OFFSET TxtTitle>,0F0h

        MWinHelp ebp,[WinPnt],48,7,<OFFSET TxtHelp>

        ;Установка кнопки "Отмена"
        mov eax,[WinPnt]
        MSetButton ebp,eax,14,7,10,<OFFSET TxtCancel>,0

        ;Установка кнопки "OK"
        mov eax,[WinPnt]
        MSetButton ebp,eax,2,7,10,<OFFSET TxtOk>,1

        ;Установка флажка 'Read Only'
        MSetCheckBox ebp,[WinPnt],2,5,<OFFSET TxtRead>,<OFFSET ReadOnly>

        ;установка строки input
        MSetInputTxt ebp,[WinPnt],2,2,22,<OFFSET InpHelp>,<OFFSET CfgFile>
        mov [InpAdr],eax

        ;Обработка окна
        MWinExe ebp,[WinPnt]

        ;Проверка результата окна
        test    eax,eax
        jz      @@Sxt

        ;Сохранение результата окна
        MWinResult ebp,[WinPnt]
@@Sxt:  mov eax,[WinPnt]
        call [ebp+EmuData.WinRemove]
        pop ebp
        ret

END
