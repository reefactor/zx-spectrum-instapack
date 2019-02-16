/**************************************************************************

Обьявления для модулей эмулятора ZX-Spectrum

**************************************************************************/

#ifndef EMUDATA_INCLUDED
#define EMUDATA_INCLUDED

/* Опpеделение стандаpтных типов */
typedef unsigned long dword;
typedef unsigned short word;
typedef unsigned char byte;

/* Определения констант */
enum {
	AY_REG0,AY_REG1,AY_REG2,AY_REG3,AY_REG4,AY_REG5,AY_REG6,AY_REG7,
	AY_REG8,AY_REG9,AY_REGA,AY_REGB,AY_REGC,AY_REGD,
	AY_ON,AY_OFF,AY_RESET,AY_INIT,AY_ENVELOPE
};

enum {
	DC_READSTATUS,DC_WRITECOMMAND,DC_READTRACK,DC_WRITETRACK,
	DC_READSECTOR,DC_WRITESECTOR,DC_READDATA,DC_WRITEDATA,
	DC_READDRQINTRQ,DC_WRITESYSTEM,DC_INIT,DC_UNINIT,DC_RESET
};

enum Typ {TTxt,TTbl,TNum,TAdd,TAdO};

/* Данные конфигурации */
struct CnTxt {
	char *Dst; // Адрес строки
	unsigned Siz; // Максимальная длина строки
};

struct CnTbl {
	unsigned *Dst; // Адрес значения
	const char **Val; // Адрес таблицы, содержащий адреса текстовых значений
	unsigned ValN; // Количество значений
};

struct CnNum {
	unsigned *Dst; // Адрес значения
	unsigned Min; // Минимальное значение
	unsigned Max; // Максимальное значение
};

struct CfgS {
	unsigned char Type; // Тип элемента конфигурации
	const char *Txt; // Адрес строки для опции
	union {
		void *C;
		CnTxt *CTxt; // Адрес таблицы данных для строки
		CnTbl *CTbl; // Адрес таблицы данных для переключателя
		CnNum *CNum; // Адрес таблицы данных для числа
	};
};

struct CfgDat {
	CfgS *Cfg; // Адрес таблицы данных конфигурации
	unsigned Num; // Количество элементов
};

/* Данные процессора */
struct DatCPU {
	dword RegPC; // Регистр PC
	dword RegSP; // Регистр SP
	dword RegIX; // Регистр IX
	dword RegIY; // Регистр IY
	union {dword RegAF;struct {byte RegF;byte RegA;};}; // Регистры AF
	union {dword RegBC;struct {byte RegC;byte RegB;};}; // Регистры BC
	union {dword RegDE;struct {byte RegE;byte RegD;};}; // Регистры DE
	union {dword RegHL;struct {byte RegL;byte RegH;};}; // Регистры HL
	union {dword RegAFa;struct {byte RegFa;byte RegAa;};}; // Регистры AF'
	union {dword RegBCa;struct {byte RegCa;byte RegBa;};}; // Регистры BC'
	union {dword RegDEa;struct {byte RegEa;byte RegDa;};}; // Регистры DE'
	union {dword RegHLa;struct {byte RegLa;byte RegHa;};}; // Регистры HL'
	byte RegR; // Регистр R
	byte RegI; // Регистр I
	word Halt; // Флаг команды HALT: 000h - нет; 001h - есть
	union {dword IFF;struct {byte IFF2;byte IFF1;};}; // Триггеры прерываний
	byte IM; // Режим прерываний
	byte reserved[3];
};

/* Данные AY */
struct DatAY {
	byte RegData[0x10]; // Регистры AY
	dword RegIndex; // Выбранный регистр AY
	dword EnvCurrent; // Текущее значение огибающей
	int EnvDelta; // Изменение значения огибающей между прерываниями
	byte EnvStatus; // Огибающая: 0-неизменно, 1-возрастание, 2-убывание
	byte reserved[3];
};

/* Данные контроллера дисковода */
struct DatVG {
	byte DataIO; // Значение, которое передается через порт
	byte OperIO; // Операция ВГ
	byte RegStatus; // Регистр состояния ВГ
	byte RegCom; // Регистр команд
	signed char RegTrack; // Регистр дорожки
	byte RegSect; // Регистр сектора
	byte RegData; // Регистр данных
	byte System; // Системный регистр контроллера дисковода
	signed char StepDirect; // Направление шага: -01 - назад; 01 - вперед
	byte TrackReal[4]; // Положение головок дисководов
	byte reserved[3];
};

/* Данные эмулятора */
#pragma aux _new parm [eax] value [eax]
#pragma aux _del parm [eax]
#pragma aux TraceProc parm [ebx]
#pragma aux WinCreate parm [eax][ebx][ecx][edx][esi] value [eax]
#pragma aux WinRemove parm [eax]
#pragma aux WinTitle parm [eax][ebx][ecx]
#pragma aux WinHelp parm [eax][ebx][ecx][edx]
#pragma aux WinText parm [eax][ebx][ecx][edx]
#pragma aux WinExe parm [eax] value [eax]
#pragma aux WinResult parm [eax]
#pragma aux SetButton parm [eax][ebx][ecx][edx][esi][edi] value [eax]
#pragma aux SetCheckBox parm [eax][ebx][ecx][edx][edi] value [eax]
#pragma aux SetRadio parm [eax][ebx][ecx][edx][edi] value [eax]
#pragma aux SetInputTxt parm [eax][ebx][ecx][esi][edx][edi] value [eax]
#pragma aux SetInputNum parm [eax][ebx][ecx][edx][edi] value [eax]
#pragma aux FileBox parm [eax][ebx][ecx]
#pragma aux MesBox parm [eax][ebx][edx]
#pragma aux VidByte parm [ebx] modify [eax ebx ebp]
#pragma aux ProcVG parm [ebx]
#pragma aux ProcIn parm [ebx] value [eax] modify [ebx]
#pragma aux ProcOut parm [ebx][eax] modify [eax ebx]

struct EmuData {
	DatCPU DataCPU; // Таблица данных CPU
	DatAY AY; // Таблица данных AY
	DatVG VG; // Таблица данных контроллера дисковода
	byte *SpecRAM; // RAM Spectrum
	byte *SpecROM; // ROM Spectrum
	byte *SpecSeg[0x4]; // Таблица сегментов Spectrum
	dword TimerRate; // Значение счетчика таймера
	void (**OpCPU)(); // Адреса подпрограмм обработки команд процессора
	void *(__pragma("_new") *MemAlloc)(unsigned); // Выделение памяти
	void (__pragma("_del") *MemFree)(void*); // Освобождение памяти
	void (*TextMode)(); // Включение текстового видеорежима
	void (*SpecMode)(); // Включение видеорежима Spectrum
	void (*SetSpec)(); // Включение эмуляции Spectrum
	void (__pragma("TraceProc") *CPUTraceOn)(unsigned Id); // Включение трассировки процессора
	void (__pragma("TraceProc") *CPUTraceOff)(unsigned Id); // Выключение трассировки процессора
	void *(__pragma("WinCreate") *WinCreate)(int X,int Y,int dX,int dY,unsigned char C); // Создание окна
	void (__pragma("WinRemove") *WinRemove)(void *Pnt); // Удаление окна
	void (__pragma("WinTitle") *WinTitle)(void *Pnt,char *Txt,unsigned char C); // Создание заголовка окна
	void (__pragma("WinHelp") *WinHelp)(void *Pnt,int dX,int dY,char *Txt); // Установка помощи для окна
	void (__pragma("WinText") *WinText)(void *Pnt,int X,int Y,char *Txt); // Печать текста в окно
	int (__pragma("WinExe") *WinExe)(void *Pnt); // Запуск интерфейса
	void (__pragma("WinResult") *WinResult)(void *Pnt); // Установка результатов
	void *(__pragma("SetButton") *SetButton)(void *Pnt,int X,int Y,char *Txt,int dX,int Id); // Кнопка
	void *(__pragma("SetCheckBox") *SetCheckBox)(void *Pnt,int X,int Y,char *Txt,unsigned *Dst); // Флажок
	void *(__pragma("SetRadio") *SetRadio)(void *Pnt,int X,int Y,char *Txt,CnTbl *Dst); // Переключатель
	void *(__pragma("SetInputTxt") *SetInputTxt)(void *Pnt,int X,int Y,int dX,char *Txt,CnTxt *Dst); // Строка ввода
	void *(__pragma("SetInputNum") *SetInputNum)(void *Pnt,int X,int Y,char *Txt,CnNum *Dst); // Строка для числа
	void (__pragma("FileBox") *FileBox)(void *Pnt,char *Mask,char *Path); // Выбор файла в строку ввода
	void (__pragma("MesBox") *MessageBox)(const unsigned char C,const char *Txt0,const char *Txt1); // Сообщение
	void (__pragma("VidByte") *VidByte)(unsigned Adr); // Запись в видеопамять ZX-Spectrum
	byte *Keys; // Положение клавиш
	byte Port7FFD; // Значение порта 7FFD
	unsigned IntWait:0x1; // Ожидание прерывания
	unsigned Trace:0x1; // Трассировка
	unsigned IntLast:0x1; // Последний вызов _INT в этом прерывании
	unsigned Lang:0x1; // Язык
	byte PortFE; // Значение порта FE
	byte VerMinor; // Подверсия эмулятора
	byte VerMajor; // Версия эмулятора
	void (__pragma("ProcVG") *ProcVG)(byte); // Вызов эмуляции контроллера дисковода
	char *Disks[4]; // Указатели на имена файлов образа диска
	int ArgC; // Количество параметров командной строки
	char **ArgV; // Адрес массива указателей на параметры командной строки
	byte (__pragma("ProcIn") *PortIn)(unsigned); // Чтение из порта
	void (__pragma("ProcOut") *PortOut)(unsigned,byte); // Запись в порт
	void (__pragma("VidByte") *VidByteAdv)(unsigned Adr); // Запись в видеопамять ZX-Spectrum с проверкой попадания
};

/* Определение подпрограмм, вызываемых эмулятором */
#pragma aux ProgIni parm [eax][ebx] modify [eax ebx ecx edx esi edi]
#pragma aux ProgVG value [ah] modify [eax ebx ecx edx esi edi]
#pragma aux Progs modify [eax ebx ecx edx esi edi]

extern char _DSC[];
#pragma aux _DSC "_DSC"
extern struct CfgDat _CFG;
#pragma aux _CFG "_CFG"
extern void _SET();
#pragma aux (Progs) _SET "_SET"
extern void _INI(EmuData*,unsigned);
#pragma aux (ProgIni) _INI "_INI"
extern void _UNI();
#pragma aux (Progs) _UNI "_UNI"
extern void _ON_();
#pragma aux (Progs) _ON_ "_ON_"
extern void _OFF();
#pragma aux (Progs) _OFF "_OFF"
extern void _RES();
#pragma aux (Progs) _RES "_RES"
extern unsigned _CPU(unsigned);
#pragma aux _CPU "_CPU" parm [eax] value [eax]
extern unsigned char _INT(unsigned,unsigned,unsigned,unsigned);
#pragma aux _INT "_INT" parm [edi][esi][edx][ecx] value [ah]
extern void _ITP(unsigned,unsigned,unsigned,unsigned);
#pragma aux _ITP "_ITP" parm [edi][esi][edx][ecx]
extern unsigned _IN_(word);
#pragma aux _IN_ "_IN_" parm [ebx] value [eax] modify [ebx ecx edx esi edi]
extern unsigned char _INP(word,byte);
#pragma aux _INP "_INP" parm [ebx][eax] value [al] modify [ebx ecx edx esi edi]
extern unsigned char _OUT(word,byte);
#pragma aux _OUT "_OUT" parm [ebx][eax] value [ah] modify [eax ebx ecx edx esi edi]
extern void _OUP(word,byte);
#pragma aux _OUP "_OUP" parm [ebx][eax] modify [eax ebx ecx edx esi edi]
extern void _MEM();
#pragma aux (Progs) _MEM "_MEM"
extern unsigned char _AY_(unsigned,unsigned char);
#pragma aux _AY_ "_AY_" parm [ebx][eax] value [ah] modify [eax ebx ecx edx esi edi]
extern unsigned char _VG_();
#pragma aux (ProgVG) _VG_ "_VG_"
extern void _VGP();
#pragma aux (Progs) _VGP "_VGP"
extern void _F7_();
#pragma aux (Progs) _F7_ "_F7_"
extern void _F8_();
#pragma aux (Progs) _F8_ "_F8_"
extern void _F9_();
#pragma aux (Progs) _F9_ "_F9_"
extern void _F10();
#pragma aux (Progs) _F10 "_F10"
extern void _F11();
#pragma aux (Progs) _F11 "_F11"
extern void _F12();
#pragma aux (Progs) _F12 "_F12"
extern void _INS();
#pragma aux (Progs) _INS "_INS"

#endif
