;**************************************************************************
;
;Обьявления для модулей эмулятора ZX-Spectrum
;
;**************************************************************************

;Определение констант
AY_REG0=00h
AY_REG1=01h
AY_REG2=02h
AY_REG3=03h
AY_REG4=04h
AY_REG5=05h
AY_REG6=06h
AY_REG7=07h
AY_REG8=08h
AY_REG9=09h
AY_REGA=0Ah
AY_REGB=0Bh
AY_REGC=0Ch
AY_REGD=0Dh
AY_ON=0Eh
AY_OFF=0Fh
AY_RESET=10h
AY_INIT=11h
AY_ENVELOPE=12h

DC_READSTATUS=00h
DC_WRITECOMMAND=01h
DC_READTRACK=02h
DC_WRITETRACK=03h
DC_READSECTOR=04h
DC_WRITESECTOR=05h
DC_READDATA=06h
DC_WRITEDATA=07h
DC_READDRQINTRQ=08h
DC_WRITESYSTEM=09h
DC_INIT=0Ah
DC_UNINIT=0Bh
DC_RESET=0Ch

TTxt=0
TTbl=1
TNum=2

;Данные конфигурации
STRUC CnTxt
Dst		DD ? ;Адрес строки
Siz		DD ? ;Максимальная длина строки
ENDS

STRUC CnTbl
Dst		DD ? ;Адрес значения
Val		DD ? ;Адрес таблицы, содержащий адреса текстовых значений
ValN		DD ? ;Количество значений
ENDS

STRUC CnNum
Dst		DD ? ;Адрес значения
Min		DD ? ;Минимальное значение
Max		DD ? ;Максимальное значение
ENDS

STRUC CfgS
Type		DB ? ;Тип элемента конфигурации
Txt		DD ? ;Адрес строки для опции
C		DD ? ;Адрес таблицы данных
ENDS

STRUC CfgDat
Cfg		DD ? ;Адрес таблицы данных конфигурации
Num		DD ? ;Количество элементов
ENDS

;Данные процессора
STRUC DatCPU
RegPC		DD ? ;Регистр PC
RegSP		DD ? ;Регистр SP
RegIX		DD ? ;Регистр IX
RegIY		DD ? ;Регистр IY
UNION
 RegAF		DD ? ;Регистры AF
 STRUC
  RegF		DB ? ;Регистр F
  RegA		DB ? ;Регистр A
 ENDS
ENDS
UNION
 RegBC		DD ? ;Регистры BC
 STRUC
  RegC		DB ? ;Регистр C
  RegB		DB ? ;Регистр B
 ENDS
ENDS
UNION
 RegDE		DD ? ;Регистры DE
 STRUC
  RegE		DB ? ;Регистр E
  RegD		DB ? ;Регистр D
 ENDS
ENDS
UNION
 RegHL		DD ? ;Регистры HL
 STRUC
  RegL		DB ? ;Регистр L
  RegH		DB ? ;Регистр H
 ENDS
ENDS
UNION
 RegAFa		DD ? ;Регистры AF'
 RegAFAlt	DD ? ;Регистры AF' (оставлено для совместимости)
 STRUC
  RegFa		DB ? ;Регистр F'
  RegAa		DB ? ;Регистр A'
 ENDS
ENDS
UNION
 RegBCa		DD ? ;Регистры BC'
 RegBCAlt	DD ? ;Регистры BC' (оставлено для совместимости)
 STRUC
  RegCa		DB ? ;Регистр C'
  RegBa		DB ? ;Регистр B'
 ENDS
ENDS
UNION
 RegDEa		DD ? ;Регистры DE'
 RegDEAlt	DD ? ;Регистры DE' (оставлено для совместимости)
 STRUC
  RegEa		DB ? ;Регистр E'
  RegDa		DB ? ;Регистр D'
 ENDS
ENDS
UNION
 RegHLa		DD ? ;Регистры HL'
 RegHLAlt	DD ? ;Регистры HL' (оставлено для совместимости)
 STRUC
  RegLa		DB ? ;Регистр L'
  RegHa		DB ? ;Регистр H'
 ENDS
ENDS
RegR		DB ? ;Регистр R
RegI		DB ? ;Регистр I
Halt		DW ? ;Флаг команды HALT: 000h - нет; 001h - есть
UNION
 IFF		DD ? ;Триггеры прерываний: 00h - запрещены; 04h - разрешены
 STRUC
  IFF2		DB ? ;Триггер прерываний IFF2
  IFF1		DB ? ;Триггер прерываний IFF1
 ENDS
ENDS
IM		DB ? ;Режим обработки прерываний
		DB ?,?,?
ENDS

;Данные AY
STRUC DatAY
RegData		DB 010h DUP (?) ;Значения регистров AY
RegIndex	DD ? ;Выбранный регистр AY
EnvCurrent	DD ? ;Текущее значение огибающей
EnvDelta	DD ? ;Изменение значения огибающей между прерываниями
EnvStatus	DB ? ;0-неизменно, 1-возрастание, 2-убывание
		DB ?,?,?
ENDS

;Данные контроллера дисковода
STRUC DatVG
DataIO		DB ? ;Значение, которое передается через порт
OperIO		DB ? ;Операция ВГ
RegStatus	DB ? ;Регистр состояния ВГ
RegCom		DB ? ;Регистр команды ВГ
RegTrack	DB ? ;Регистр дорожки ВГ
RegSect		DB ? ;Регистр сектора ВГ
RegData		DB ? ;Регистр данных ВГ
System		DB ? ;Системный регистр контроллера дисковода
StepDirect	DB ? ;Направление шага: -01 - назад; 01 - вперед
TrackReal	DB 4 DUP (?) ;Положение головок дисководов
		DB ?,?,?
ENDS

;Данные эмулятора
RECORD EMUFLAGS Lang:1,IntLast:1,Trace:1,IntWait:1

STRUC EmuData
DataCPU		DatCPU <> ;Таблица данных CPU
AY		DatAY <> ;Таблица данных AY
VG		DatVG <> ;Таблица данных контроллера дисковода
SpecRAM		DD ? ;RAM Spectrum
SpecROM		DD ? ;ROM Spectrum
SpecSeg		DD ?,?,?,? ;Таблица сегментов Spectrum
TimerRate	DD ? ;Значение счетчика таймера
OpCPU		DD ? ;Адреса подпрограмм обработки команд процессора
MemAlloc	DD ? ;Выделение памяти
MemFree		DD ? ;Освобождение памяти
TextMode	DD ? ;Включение текстового видеорежима
SpecMode	DD ? ;Включение видеорежима Spectrum
SetSpec		DD ? ;Включение эмуляции Spectrum
CPUTraceOn	DD ? ;Включение трассировки процессора
CPUTraceOff	DD ? ;Выключение трассировки процессора
WinCreate	DD ? ;Создание окна
WinRemove	DD ? ;Удаление окна
WinTitle	DD ? ;Создание заголовка окна
WinHelp		DD ? ;Установка помощи для окна
WinText		DD ? ;Печать текста в окно
WinExe		DD ? ;Запуск интерфейса
WinResult	DD ? ;Установка результатов
SetButton	DD ? ;Кнопка
SetCheckBox	DD ? ;Флажок
SetRadio	DD ? ;Переключатель
SetInputTxt	DD ? ;Строка ввода
SetInputNum	DD ? ;Строка для числа
FileBox		DD ? ;Выбор файла в строку ввода
MessageBox	DD ? ;Сообщение
VidByte		DD ? ;Запись в видеопамять ZX-Spectrum
Keys		DD ? ;Адрес таблицы положения клавиш
Port7FFD	DB ? ;Значение порта 7FFD
Flags		EMUFLAGS <> ;Флаги эмулятора
		DB 3 DUP (?)
PortFE		DB ? ;Значение порта FE (запись)
VerMinor	DB ? ;Подверсия эмулятора
VerMajor	DB ? ;Версия эмулятора
ProcVG		DD ? ;Вызов эмуляции контроллера дисковода
Disks		DD 4 DUP (?) ;Указатели на имена файлов образа диска
ArgC		DD ? ;Количество параметров командной строки
ArgV		DD ? ;Адрес массива указателей на параметры командной строки
PortIn		DD ? ;Чтение из порта
PortOut		DD ? ;Запись в порт
VidByteAdv	DD ? ;Запись в видеопамять ZX-Spectrum с проверкой попадания
ENDS

;Макросы для использования интерфейса

MACRO MWinCreate Reg,X,Y,dX,dY,C
	mov	eax,X
	mov	ebx,Y
	mov	ecx,dX
	mov	edx,dY
	mov	esi,C
	call	[Reg+EmuData.WinCreate]
ENDM

MACRO MWinRemove Reg,Pnt
	mov	eax,Pnt
	call	[Reg+EmuData.WinRemove]
ENDM

MACRO MWinTitle Reg,Pnt,Txt,C
IFDIF <Pnt>,<eax>
	mov	eax,Pnt
ENDIF
	mov	ebx,Txt
	mov	ecx,C
	call	[Reg+EmuData.WinTitle]
ENDM

MACRO MWinHelp Reg,Pnt,dX,dY,Txt
	mov	eax,Pnt
	mov	ebx,dX
	mov	ecx,dY
	mov	edx,Txt
	call	[Reg+EmuData.WinHelp]
ENDM

MACRO MWinText Reg,Pnt,X,Y,Txt
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	call	[Reg+EmuData.WinText]
ENDM

MACRO MWinExe Reg,Pnt
	mov	eax,Pnt
	call	[Reg+EmuData.WinExe]
ENDM

MACRO MWinResult Reg,Pnt
	mov	eax,Pnt
	call	[Reg+EmuData.WinResult]
ENDM

MACRO MSetButton Reg,Pnt,X,Y,dX,Txt,Id
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	mov	esi,dX
IFIDN <Id>,<0>
	xor	edi,edi
ELSE
	mov	edi,Id
ENDIF
	call	[Reg+EmuData.SetButton]
ENDM

MACRO MSetCheckBox Reg,Pnt,X,Y,Txt,Dst
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	mov	edi,Dst
	call	[Reg+EmuData.SetCheckBox]
ENDM

MACRO MSetRadio Reg,Pnt,X,Y,Txt,Dst
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	mov	edi,Dst
	call	[Reg+EmuData.SetRadio]
ENDM

MACRO MSetInputTxt Reg,Pnt,X,Y,dX,Txt,Dst
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	mov	esi,dX
	mov	edi,Dst
	call	[Reg+EmuData.SetInputTxt]
ENDM

MACRO MSetInputNum Reg,Pnt,X,Y,Txt,Dst
	mov	eax,Pnt
	mov	ebx,X
	mov	ecx,Y
	mov	edx,Txt
	mov	edi,Dst
	call	[Reg+EmuData.SetInputNum]
ENDM

MACRO MFileBox Reg,Pnt,Mask,Path
	mov	eax,Pnt
	mov	ebx,Mask
	mov	ecx,Path
	call	[Reg+EmuData.FileBox]
ENDM

MACRO MMessageBox Reg,C,Txt0,Txt1
	mov	eax,C
	mov	ebx,Txt0
	mov	edx,Txt1
	call	[Reg+EmuData.MessageBox]
ENDM

;Определение подпрограмм, вызываемых эмулятором
GLOBAL _DSC:BYTE,_CFG:CfgDat,_SET:NEAR,_INI:NEAR,_UNI:NEAR
GLOBAL _ON_:NEAR,_OFF:NEAR,_RES:NEAR,_CPU:NEAR,_INT:NEAR,_ITP:NEAR
GLOBAL _IN_:NEAR,_INP:NEAR,_OUT:NEAR,_OUP:NEAR,_MEM:NEAR
GLOBAL _AY_:NEAR,_VG_:NEAR,_VGP:NEAR,_INS:NEAR
GLOBAL _F7_:NEAR,_F8_:NEAR,_F9_:NEAR,_F10:NEAR,_F11:NEAR,_F12:NEAR
