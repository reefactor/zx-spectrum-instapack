
#ifndef MAIN_INCLUDED
#define MAIN_INCLUDED

#define FileLen 0x40
#define LineSize 0x50

#include "emudata.h"
#include "messages.hpp"
#include "ver.hpp"

/* Опpеделение стандаpтных типов */
typedef unsigned long dword;
typedef unsigned short word;
typedef unsigned char byte;

// Структура для младшего и старшего
struct RegByt {
	byte l,h;
};

// Стpуктуpа для вызова пpеpываний pеального pежима
struct RegInt {
	union {dword edi;word di;};
	union {dword esi;word si;};
	union {dword ebp;word bp;};
	dword reserved;
	union {dword ebx;word bx;RegByt b;};
	union {dword edx;word dx;RegByt d;};
	union {dword ecx;word cx;RegByt c;};
	union {dword eax;word ax;RegByt a;};
	word flags;
	word es;
	word ds;
	word fs;
	word gs;
	word ip;
	word cs;
	word sp;
	word ss;
};

extern "C" struct EmuData EmuTable;

extern unsigned char KeyHelpPict[];

extern union REGS r;
extern "C" struct RegInt ri;

const int ScrWidth=25;
const int ScrHeight=80;

#define SBVolMin 0x00
#define SBVolMax 0x80
#define SpdCstMin 0x00
#define SpdCstMax 0xFFFFF
#define IntRatMin 0x14
#define IntRatMax 0x64
#define IntLenMin 0x01
#define IntLenMax 0x64
#define MRatMin 0x0A
#define MRatMax 0xC8
#define FrmLnMn 1
#define FrmLnMx 0x4000
#define AdLibWSMin 1
#define AdLibWSMax 0x24

extern "C" byte SpecRAM[0x100000];
extern "C" byte SpecROM[0x10000];
extern "C" dword TableScreen[];

extern const unsigned TableColor[];
#pragma aux TableColor "TableColor"
extern byte PortFE;
#pragma aux PortFE "PortFE"
extern dword TableScreen[];
#pragma aux TableScreen "TableScreen"
extern dword FlashDetect;
#pragma aux FlashDetect "FlashDetect"
extern dword FlashUse;
#pragma aux FlashUse "FlashUse"

extern "C" byte Keys[];

#define VideoMemGraph (byte*)0xA0000
#define VideoMemText (byte*)0xB8000
#define AllMem (byte*)0xB8000

extern "C" void (*TableOp)();

void MemCopyW(void *Dest,void *Src,int Size);
#pragma aux MemCopyW=\
	"	cld"\
	"	rep movsw"\
	parm [edi][esi][ecx] modify [ecx esi edi]

struct MemBl {
	unsigned Seg,Sel;
	char *Adr;
	unsigned Sz;
	void Alloc(const unsigned);
	void Free();
};

extern "C" struct MemBl RMInt;

extern "C" SetBorderColor();

extern "C" unsigned char SpeedTestDetect;

extern "C" void Flash();

extern "C" void IntRealMode(const unsigned);
#pragma aux IntRealMode parm [ebx]

extern "C" void MainCPU();

extern unsigned char TestExt(char*);

extern "C" volatile unsigned TimeCount;
extern "C" void Pause(const unsigned);
#pragma aux Pause parm [eax]

extern void Fatal(const char*,const char* =TxtNul);
extern "C" void SetModeText();
extern "C" void SetModeSpec();
extern "C" void SetModeSpecAdv();
extern "C" void SetModeHelp();
extern "C" void SetPage(unsigned char*);

extern void __pragma("TraceProc") TraceOff(unsigned Id);

extern "C" byte __pragma("ProcIn") PortIn(unsigned); // Чтение из порта
extern "C" void __pragma("ProcOut") PortOut(unsigned,byte); // Запись в порт

extern "C" void SoundAY(unsigned);
#pragma aux SoundAY parm [ebx]

extern "C" void SetMemory();
#pragma aux SetMemory modify [eax]

extern "C" void ResetCPU();
extern void IntRMProc();

#pragma aux IntRMProc "IntRMProc"
extern "C" void SpeedTest();
extern "C" void SpeedSet();
extern unsigned SpeedTable[5][3];

extern "C" unsigned IntDetect;
extern "C" unsigned DevDetect;
extern "C" byte TabKey;
extern "C" byte Port1F;
extern "C" dword DoubleKey;

extern "C" unsigned *PntTimeCount;
extern "C" unsigned *PntIntDetect;
extern "C" unsigned *PntDevDetect;
extern "C" byte *TabKeyPnt;
extern "C" byte *Port1FPnt;
extern "C" dword *DoubleKeyPnt;

extern "C" unsigned *ModifyPointRm;
extern "C" unsigned *ModifyPointRV;
extern "C" unsigned *ModifyPointTr;
extern "C" unsigned *ModifyPointTRm;
extern "C" unsigned *ModifyPointTRV;
extern "C" unsigned *ModifyPointTTr;

extern "C" void __pragma("VidByte") WritBytScr(unsigned);
extern "C" void __pragma("VidByte") WritBytScrAdv(unsigned);

extern "C" char MaskAll[];

extern "C" void DriveTypeInit();
extern "C" void VideoTable();
extern "C" void JoystickInit();
extern "C" void IncDecTblIni();

extern "C" byte EndRM;

extern "C" unsigned SlowData;
extern "C" unsigned SlowDataTR;
extern "C" unsigned SlowDataCanc;
extern "C" unsigned SlowVPix;
extern "C" unsigned SlowVAttr;

extern "C" char DskPth[FileLen];
extern "C" char ROMPth[FileLen];
extern "C" char AddPth[FileLen];
extern "C" char DiskA[FileLen];
extern "C" char DiskB[FileLen];
extern "C" char DiskC[FileLen];
extern "C" char DiskD[FileLen];
extern "C" char FileNameROM48[FileLen];
extern "C" char FileNameROM128[FileLen];
extern "C" char FileNameROMTR[FileLen];
extern "C" char FileNameROMUser[FileLen];
extern "C" unsigned Beeper;
extern "C" unsigned JoyKemp;
extern "C" unsigned JoySinc;
extern "C" unsigned MouseType;
extern "C" unsigned MouseRateX;
extern "C" unsigned MouseRateY;
extern "C" unsigned MouseKempXChng;
extern "C" unsigned MouseMoveLimit;
extern "C" unsigned Speed;
extern "C" unsigned SpeedMaxTR;
extern "C" unsigned IntRate;
extern "C" unsigned IntLen;
extern "C" unsigned ResetType;
extern "C" unsigned SoundCard;
extern "C" unsigned SoundDigital;
extern "C" unsigned AdLibWaitState;
extern "C" unsigned SBAdress;
extern "C" unsigned SBVolume;
extern "C" unsigned EnvelopeMul;
extern "C" unsigned AutoSave;
extern "C" unsigned GrayMode;
extern "C" unsigned DblKeyKemp;
extern unsigned ExitConf;
extern "C" unsigned char ExitIfInt;

extern char StPth[FileLen];

extern "C" unsigned IntSource;
extern "C" unsigned VideoIRQ; // IRQ Видеоадаптера
extern "C" unsigned VerRate;

extern void (__interrupt __far *IntTimerPrev)();
#pragma aux IntTimerPrev "_IntTimerPrev"
extern void (__interrupt __far *IntVideoPrev)();
#pragma aux IntVideoPrev "_IntVideoPrev"
extern void (__interrupt __far *IntSBPrev)();
#pragma aux IntSBPrev "_IntSBPrev"
extern "C" unsigned IntKeyPrev;
extern "C" unsigned IntVideoPrev16;

extern "C" void __interrupt __far IntTimer();
extern "C" void __interrupt __far IntVideo();
extern "C" void __interrupt __far IntSB();
extern "C" void IntKey();
extern "C" void IntVideo16();

extern "C" unsigned SampleRate;
extern "C" unsigned SndIRQ;
extern "C" struct MemBl MemSB;
extern "C" void *SetSBInt(int SzMn,int SzCh);
#pragma aux SetSBInt parm [eax][ebx] value [eax]
extern "C" void RestoreSBInt(void *pBuf);
#pragma aux RestoreSBInt parm [eax]

#endif
