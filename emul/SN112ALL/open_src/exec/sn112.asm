; Loader для ZX Spectrum Navigator [SN.PRG]   BETA-версия  ! ВАРИАНТ 2 !
;                                             v0.12.2 (16-12-98 17:00)

; Loader (f)98 Mihal Soft°  Орехов Михаил  (2:5093/6.1 aka /9.1)
; ZX Spectrum Navigator v1.10 Copyright (c) 1997-98 RomanRoms Software Co.

;█ Кроме первого "служебного" параметра SN.COM подает в SN.PRG
;█ свою командную строку. При первом запуске SN.PRG служебный параметр
;█ это 6 символов "ЧЧММСС" (как раньше), при втором и далее запусках
;█ первый параметр в командной строке подаваемой в SN.PRG это СЕМЬ
;█ символов "ЧЧММССE" где "E" - большая латинская буква "E"
;█ (признак уже не первого запуска SN.PRG загрузчиком)
;█ Вторым и далее параметрами командной строки в SN.PRG подаются
;█ параметры, которые были набраны в командной строке загрузчика SN.COM

; Это значение проставляется РУКАМИ !!!  При этом надо думать ГОЛОВОЙ !!!
; Это размер "резидентной" части LOADER'а и вычисляется он из смещения
; End_Of_Resident_Part плюс стек и округлено до 10h в большую сторону !!!

End_Of_Memory_Block EQU 310h

.8086  ;Люблю антиквариат
;=========================================================
SN_Run segment byte public 'CODE'
       assume cs:SN_Run, es:SN_Run, ds:SN_Run

        ORG    2Ch
EnvSeg  DW     ?

        ORG    100h

Start:  JMP Short Init
        DB '(f)Mihal Soft°' ;Это нигде не выдается, но в теле SN.COM есть
COMMAND_ComStr  DB 0        ;Длина командной строки для COMMAND.COM
                DB ' /c'

StrLen  LABEL BYTE
SWPFile LABEL WORD

;Когда инициализационный код (отсюда до метки NextRun) отработает,
;он будет уже не нужен и будет использоваться под буфер чтения из
;SWP-файла (128 байт) поэтому аккратней, до метки NextRun
;должно быть не менее 128 байт !

Init:
        mov     ah, 9
        mov     dx, offset Copyrt_Roman
        int     21h            ;Выдаем копирайтное сообщение

        std                    ;Поиск/перенос назад
        mov     si, 255-8      ;Сдвигаем командную строку поданую в SN.COM
        mov     di, 255        ;на 8 символов, чтоб вписать в начало
        mov     cx, 128-8      ;параметр 'ЧЧММССx ' для SN.PRG
        REP movsb              ;используемый для создания имен врем.файлов
        mov     ax, '  '       ;заносим два пробела между старой ком строкой
        stosw                  ;и служебным параметром для SN.PRG
        mov     ax, '00'       ;заносим служебный параметр, пока = '000000'
        stosw
        stosw
        stosw
        add BYTE PTR DS:[80h], 8  ;Длина командной строки увеличитась на 8
        cmp BYTE PTR DS:[80h], 128;Не перевалила ли длина разумные пределы?
        jl  Len_OK
        mov BYTE PTR DS:[80h], 127;"Усекаем" командную строку
Len_OK:
        cld                    ;А теперь поиск вперед

        mov     ax, CS         ;Вычисляем размер окружения DOS
        sub     ax, EnvSeg     ;чтобы при поиске строк в Environment
        mov     cl, 4          ;не переваливать за пределы Environment'а
        shl     ax, cl
        mov     ENV_Size, ax   ;Размер = (НашСегмент-СегментОкружения)*16

        mov     ah, 2ch         ;Начинаем генерить имя SWP-файла...
        int     21h             ;Узнаем текущее время (CH:CL:DH = ЧЧ:ММ:СС)
        mov     dl, 10          ;Мы привыкли к десятичной системе
        xor     ax, ax          ;Чтоб делилось
        mov     al, CH          ;Часы
        div     dl              ;al := часы DIV 10 ;   ah := часы MOD 10
        add WORD PTR DS:[81h], ax  ;Превращаем в 2 символа
        xor     ax, ax
        mov     al, CL          ;Минуты аналогично
        div     dl
        add WORD PTR DS:[81h+2], ax
        xor     ax, ax
        mov     al, DH          ;Секунды аналогично
        div     dl
        add WORD PTR DS:[81h+4], ax

        mov     ComStr_Seg, cs ; Создаем Блок параметров EXEC
        mov     FCB1_Seg, cs   ; (EPB - EXEC Parameter Block)
        mov     FCB2_Seg, cs   ; Для функции DOS 4Bh - запуск программ

        mov     ah, 4Ah     ; Уменьшаем размер выделенной программе памяти
        mov     bx, End_Of_Memory_Block / 10h   ;Кол-во параграфов
        mov     sp, End_Of_Memory_Block - 2     ;Наш новый стек
        int     21h

        mov     cx, ENV_Size   ;CX := Размер Окржения DOS
        mov     ds, EnvSeg     ;DS := Сегмент Окружения DOS
        xor     ax, ax         ;ищем 0
        mov     si, ax         ;начиная с DS:0

Find_EXEC:                     ;Ищем в Окружении путь запуска Loader'а
        lodsb
        or      al, [si]       ;Попались два нулевых байта подряд?
        loopne  Find_EXEC

        add     si, 3           ;пропускаем DW 1 перед путем запуска
                                ;итак путь запуска  Loader'а найден.
        mov     CS:ExPathDX, si ;прячем смещение пути запуска  Loader'а

Find_EXEC_end:
        lodsb
        or      al, al
        loopne  Find_EXEC_end   ;Ищем конец пути запуска

        mov WORD PTR [si-4], 'RP'   ;И заменяем в пути
        mov BYTE PTR [si-2], 'G'    ;расщирение '.COM' на '.PRG'

        mov     di, OFFSET ENV_COMSPEC
        mov     dx, 8+1         ;Длина строки 'COMSPEC=' плюс единица
        call    Get_ENV_Str     ;Находим переменную окружения COMSPEC

        push    CS
        pop     DS

        mov     COMSPEC_Adr, si ;и запоминаем ее адрес в окружении

NextRun:
        mov     ComStr_Ofs, 80h ;Адрес командной строки
        mov     dx, ExPathDX    ;DS:DX указывает на строку с именем программы
        CALL    RunProgram      ;Запускаем SN.PRG
        jc      WasErr          ;Была ошибка при запуске ?

        mov BYTE PTR DS:[87h], 'E' ;"добавляем" в командную строку 'E'
                                ;т.е. преврашаем "ччммсс" в "ччммссE"

        mov     ah, 4Dh         ;Узнаем ERRORLEVEL
        int     21h             ;последней завершившейся программы (SN.PRG)
        or      al, al
        jz      Quit            ;Если ERRORLEVEL=0 значит совсе выходим из SN

        CLD                     ;Поиск вперед
        CALL    Get_SWP_Name    ;Находим путь к имени SWP-файла, конкатенируем
                                ;его с именем SWP-файла в строку SWPFile
        mov     ax, 3D00H       ;Открыть файл на чтение
        mov     dx, OFFSET SWPFile ;Адрес строки с путем/именем SWP-файла
        int     21H
        jc      NextRun         ;если ошибка открытия SWP - возврат в SN
        mov     bx,ax           ;сохраняем handle открытого файла

        mov     ax, 4200h       ;Установить указатель в файле (SEEK)
        xor     cx, cx          ;указатель в CX:DX (в нашем случае CX=0
        mov     dx, 766         ;в DX смещение в SWP-файле строки
        int     21H             ;с именем запускаемой программы
                                ;(для версий до SN1.022 включительно = 0)
                                ;(для SN1.10 = 766)

        mov     ah, 3Fh         ;Читать файл
        mov     dx, OFFSET StrLen ;в буфер, который см.выше
        mov     cx, 128         ;Сразу по максимуму читаем - 128 байт
        int     21H

        mov     ah, 3Eh         ;Закрыть файл
        int     21H

        mov     bl, StrLen      ;Бере длин считаной паскалевской строки
        add     bl, 4           ;увеличиваем на 4 (' /c ' + ...)
        mov     COMMAND_ComStr, bl ;и заносим суммарную длин куда следует

;Запускаем программу...

        mov     ComStr_Ofs, OFFSET COMMAND_ComStr ;ком.строка для COMMAND.COM
        mov     StrLen, ' '                       ;склеиваем ' /c' и строку
        mov     dx, COMSPEC_Adr                   ;Путь/имя COMMAND.COM
        CALL    RunProgram      ;Запускаем COMMAND.COM /c <что_приказали>

        jmp     NextRun         ;Идем снова запускать SN.PRG

WasErr:
        mov     ah, 9           ;Если была, ошибка (SN.PRG не запустился)...
        mov     dx, OFFSET ErrMess
        int     21h             ;Выдаем сообщение
Quit:
        int     20h             ;Завершение программы SN.COM

;---------------------------------------------------------
; Процедура запуска внешней програмы
; DS:DX - указывает на строку 'путь/имя' запускаемой проги
; ES:BX - указывает на EPB (см. например TechHelp)

RunProgram PROC NEAR
        mov     ds, CS:EnvSeg   ;DS := сегмент Окружения DOS
        mov     bx, offset EPB  ;ES:BX - указатель на EPB
        mov     CS:Old_SP, sp   ;Сохраняем указатель на стек
        mov     ax, 4B00h       ;Запустить программу (EXEC)
        int     21h             ;DS:DX -> ASCIZ имя запускаемого файла
                                ;ES:BX -> EPB
        mov     ax, CS          ;восстанавливаем стек
        push    cs
        mov     DS, ax          ;восстановим испорченный DS
        mov     ES, ax          ;восстановим испорченный ES
        cli
        mov     SS, ax          ;восстановим испорченный SS
        mov     sp, Old_SP      ;а заодно и SP
        sti
        retn                    ;выходим
RunProgram endp

;---------------------------------------------------------
; Процедура поиска строки в окружении DOS
; На входе : ES:DI - указывает на строку с именем переменной окружения
;                    которую мы столь настойчиво ищем
;              DX  - длина имени переменной (считая и знак "=")
; На выходе: Флаг CF=1 - переменная не найдена
;            Флаг CF=0 - переменная найдена и тогда:
;            DS:SI - указывает на начало строки со значением
;                    искомой переменой в Окружении DOS

Get_ENV_Str PROC NEAR

        mov     ds, CS:EnvSeg   ;DS := Сегмент Окружения DOS
        xor     si, si          ;DS:SI -> начало Окружения DOS

FindVAR_Loop:
        mov     cx, dx          ;Заносим длину имени искомой переменной в CX
        push    si
        push    di
        REPE cmpsb              ;Сравнить строки начинающиеся с DS:DI и ES:DI
        pop     di
        jcxz    Found_VAR       ;Если CX=0 (строки совпали по всей длине)
        pop     si              ;Если не нашли...
        inc     si              ;преходим к следующему байту Окружения
        cmp     si, CS:ENV_Size ;Дожли до конца Окружения?
        jne     FindVAR_Loop    ;Если не дошли - продолжим поиски
        stc                     ;Не нашли переменню окружения, установим флаг
        retn                    ;Выход

Found_VAR:                      ;Переменная найдена!
        pop     ax              ;Чистим стек (там было SI)
        dec     si              ;DS:SI сейчас указывает на начало строки
                                ;со значением искомой переменной
        clc                     ;Флаг "переменная найдена"
        retn                    ;Выходим

Get_ENV_Str endp

;---------------------------------------------------------
; Процедура нахождения имени временного файла
; Находит путь к временному каталогу, дописывает к нему имя SWP-файла
; и помещает строку-результат в SWPFile

Get_SWP_Name PROC NEAR

        mov     di, OFFSET ENV_TEMP
        mov     dx, 5+1         ;Длина троки 'TEMP=' плюс единица
        call    Get_ENV_Str     ;Ищем переменную Окружения 'TEMP'
        jnc     TMP_OK          ;Если нашли

        mov     di, OFFSET ENV_TMP
        mov     dx, 4+1         ;Длина троки 'TMP=' плюс единица
        call    Get_ENV_Str     ;то ищем переменную Окружения 'TMP'
        jnc     TMP_OK

        mov     SWPFile, ':C'   ;Если переменные окружения TEMP и TMP
                                ;не найдены, то временый каталог = C:\
        mov     di, (OFFSET SWPFile) + 3
        jmp short IS_Slash

TMP_OK:                         ;DS:SI указывает на переменную окружения
        mov     di, OFFSET SWPFile   ;ES:DI - куда копировать
CopyVAR:                        ;Копируем переменную окружения
        lodsb                   ;(TEMP или TMP) в буфер имени SWP-файла
        stosb
        or      al, al          ;конец строки?   (ASCIIZ)
        jnz     CopyVAR

IS_Slash:
        push    CS
        pop     DS
        cmp byte PTR [di-2], '\';Есть ли в конце строки с путем слэш?
        je      NoSlash         ;Если есть - отлично
        mov byte PTR [di-1], '\';Если нет - добавим
        inc     di
NoSlash:
        dec     di
        mov     ax, 'NS'        ;Добавляем имя SWP-файла (SNччммсс.SWP)
        stosw
        mov     si, 81h         ;Адрес 6-символьной строки с временем
        movsw                   ;запуска Loader'а (наш идентификатор)
        movsw
        movsw
        mov     ax, 'S.'        ;Ну и напоследок - расширение
        stosw
        mov     ax, 'PW'
        stosw
        xor     ax, ax          ;ASCIIZ, а как же иначе
        stosb

        retn

Get_SWP_Name endp
;---------------------------------------------------------
ErrMess         DB 0Ah,0Dh,'Can`t run SN.PRG$'
ENV_TEMP        DB 'TEMP='     ;Имена переменных окружения для поиска
ENV_TMP         DB 'TMP='      ;пути к временному файлу
ENV_Size        DW ?           ;Размер окружения DOS
COMSPEC_Adr     DW ?           ;Адрес строки COMSPEC в Окружении DOS
ExPathDX        DW ?           ;Адрес пути загрузки SN.COM в Окружении DOS
Old_SP          DW ?           ;Для временного хранения SP при вызове 4B00
;---------------------------------------------------------

EPB:            ; Блок параметров EXEC
DescEnvSeg      DW 0     ;0 - использовать копию с текущего ОКРУЖЕНИЯ
ComStr_Ofs      DW 0     ;Адрес командной строки (смещение)
ComStr_Seg      DW 0     ;Адрес командной строки (сегмент)
FCB1_Ofs        DW 5Ch   ;Адрес первого FCB (смещение)  !используем наш!
FCB1_Seg        DW 0     ;Адрес первого FCB (сегмент)
FCB2_Ofs        DW 6Ch   ;Адрес первого FCB (смещение)
FCB2_Seg        DW 0     ;Адрес первого FCB (сегмент)
;---------------------------------------------------------

End_Of_Resident_Part:

ENV_COMSPEC     DB 'COMSPEC=' ;Имя переменной для поиска командного интерпр.
Copyrt_Roman    DB 'ZX Spectrum Navigator  Version 1.12';Ну как же без этого!
                DB '  Copyright (c) 1999 RomanRoms Software Co.',0Ah,0Dh,'$'

SN_Run        ends
              end    Start
