/**************************************************************************

Запуск и инициализация

**************************************************************************/

#include <dos.h>
#include <i86.h>
#include <iostream.h>
#include <conio.h>
#include <stdlib.h>
#include "messages.hpp"
#include "main.hpp"
#include "emudata.h"
#include "text.hpp"
#include "file.hpp"
#include "interfac.hpp"
#include "diskutil.hpp"
#include "mouse.hpp"
#include "addition.hpp"
#include "vg.hpp"

void __pragma("_new") *MemAlloc(unsigned s) {
	if (!s) return 0;
	void *Pnt=new char[s];
	if (Pnt) memset(Pnt,0,s);
	return Pnt;
}

void __pragma("_del") MemFree(void *Pnt) {if	(Pnt) delete[] Pnt;}

static unsigned TraceCount;

void __pragma("TraceProc") TraceOn(unsigned Id) {
	((Add*)Id)->Trace=1;
	EmuTable.Trace=1;
}

void __pragma("TraceProc") TraceOff(unsigned Id) {
	((Add*)Id)->Trace=0;
	Add *Pnt=AddFirst;
	while (Pnt) {
		if (Pnt->Trace) {
			((Add*)Id)->Trace=1;
			return;
		}
		Pnt=Pnt->Next;
	}
}

/* Таблица данных ZX-Spectrum */
struct EmuData EmuTable={
	{0},{0},{0},
	SpecRAM,SpecROM,0,SpecRAM+0x14000,SpecRAM+0x8000,0,0,
	&TableOp,
	MemAlloc,MemFree,
	SetModeText,SetModeSpec,SetModeSpecAdv,
	TraceOn,TraceOff,
	WinCreate,WinRemove,WinTitle,WinHelp,WinText,WinExe,WinResult,
	SetButton,SetCheckBox,SetRadio,SetInputTxt,SetInputNum,FileBox,MessageBox,
	WritBytScr,
	0,0,0,0,0,
#ifdef Rus
	0,
#else
	1,
#endif
	0,
	VerMi,VerMj,
	DiskVG,
	{DiskA,DiskB,DiskC,DiskD},
	0,0,
	PortIn,PortOut,
	WritBytScrAdv
};

/* Память ZX-Spectrum (порядок обязателен) */
byte SpecRAM[0x100000];
byte SpecROM[0x10000];

dword TableScreen[0x6C00];

union REGS r;

unsigned *PntIntDetect;
byte *TabKeyPnt;
byte *Port1FPnt;
dword *DoubleKeyPnt;

unsigned char DetectOptionS=0;
unsigned char DetectOptionCRT=0;

static unsigned IntContr; // Маска контроллеров прерываний

unsigned VideoIRQ=0x0; // IRQ Видеоадаптера (0-2/9, 1-10, 2-11, 3-12)

void (__interrupt __far *IntTimerPrev)();
void (__interrupt __far *IntVideoPrev)();
void (__interrupt __far *IntSBPrev)();

volatile unsigned TimeCount;

unsigned ResetType=0x0;
unsigned ExitConf=0x1;
unsigned AutoSave=0x1;

char MaskROM[]="*.ROM";
char MaskDsk[]="*.TRD";
char MaskAdd[]="*.ADD";
char MaskAll[]="*.*";

// Имена файлов образа диска
char DskPth[FileLen]=".";
char DiskA[FileLen]="SPECTRUM.TRD";
char DiskB[FileLen]="SPECTRUM.TRD";
char DiskC[FileLen]="SPECTRUM.TRD";
char DiskD[FileLen]="SPECTRUM.TRD";

// Имена файлов ROMов
char ROMPth[FileLen]=".";
char FileNameROM48[FileLen]="48*.ROM";
char FileNameROM128[FileLen]="128*.ROM";
char FileNameROMTR[FileLen]="TR*.ROM";
char FileNameROMUser[FileLen]="";

// Путь к файлам добавлений
char AddPth[FileLen]=".";

// Путь, из которого запущен эмулятор
char StPth[FileLen];

const unsigned TableColor[]={
	0x0000,0x0100,0x0200,0x0300,0x0400,0x0500,0x0600,0x0700,
	0x0001,0x0101,0x0201,0x0301,0x0401,0x0501,0x0601,0x0701,
	0x0002,0x0102,0x0202,0x0302,0x0402,0x0502,0x0602,0x0702,
	0x0003,0x0103,0x0203,0x0303,0x0403,0x0503,0x0603,0x0703,
	0x0004,0x0104,0x0204,0x0304,0x0404,0x0504,0x0604,0x0704,
	0x0005,0x0105,0x0205,0x0305,0x0405,0x0505,0x0605,0x0705,
	0x0006,0x0106,0x0206,0x0306,0x0406,0x0506,0x0606,0x0706,
	0x0007,0x0107,0x0207,0x0307,0x0407,0x0507,0x0607,0x0707,
	0x0000,0x0800,0x0900,0x0A00,0x0B00,0x0C00,0x0D00,0x0E00,
	0x0008,0x0808,0x0908,0x0A08,0x0B08,0x0C08,0x0D08,0x0E08,
	0x0009,0x0809,0x0909,0x0A09,0x0B09,0x0C09,0x0D09,0x0E09,
	0x000A,0x080A,0x090A,0x0A0A,0x0B0A,0x0C0A,0x0D0A,0x0E0A,
	0x000B,0x080B,0x090B,0x0A0B,0x0B0B,0x0C0B,0x0D0B,0x0E0B,
	0x000C,0x080C,0x090C,0x0A0C,0x0B0C,0x0C0C,0x0D0C,0x0E0C,
	0x000D,0x080D,0x090D,0x0A0D,0x0B0D,0x0C0D,0x0D0D,0x0E0D,
	0x000E,0x080E,0x090E,0x0A0E,0x0B0E,0x0C0E,0x0D0E,0x0E0E
};

static char CRT[]="CRT";

/* Номера перехватываемых прерываний */
#define IntNTim 0x08
#define IntNKey 0x15

/* Получение блока памяти в 1-ом Mb */
void MemBl::Alloc(const unsigned Mem) {
	r.w.ax=0x0100;
	Sz=(r.x.ebx=Mem)<<4;
	Seg=int386(0x31,&r,&r);
	if (r.w.cflag) Fatal(TxtErAllocMem);
	Sel=r.w.dx;
	Adr=(char*)(Seg<<4);
	if (!((((int)Adr&0xFFFF)+Mem)&0x10000)) return;
	unsigned SelTmp=Sel;
	this->Alloc(Mem);
	r.w.ax=0x0101;
	r.x.edx=SelTmp;
	int386(0x31,&r,&r);
	if (r.w.cflag) Fatal(TxtErFreeMem);
}

/* Освобождение блока памяти */
void MemBl::Free() {
	if (!Sel) return;
	r.w.ax=0x0101;
	r.x.edx=Sel;
	int386(0x31,&r,&r);
	if (r.w.cflag) Fatal(TxtErFreeMem);
	Sel=0x0;
}

/* Пауза */
unsigned KeyInput();
#pragma aux KeyInput=\
	"mov	ah,000h"\
	"int	016h"\
	value [eax] modify [eax]

void Pause(const unsigned Time) {
	if (Time) {
		unsigned Start=TimeCount;
		while (Start+Time>TimeCount);
	} else KeyInput();
}

struct MemBl RMInt;

static unsigned GetRMVect(const unsigned IntNum) {
	r.w.ax=0x0200;
	r.x.ebx=IntNum;
	int386(0x31,&r,&r);
	return((r.w.cx<<0x10)|r.w.dx);
}

static void SetRMVect(const unsigned IntNum,const unsigned Vect) {
	r.w.ax=0x0201;
	r.x.ebx=IntNum;
	r.w.cx=Vect>>0x10;
	r.w.dx=Vect;
	int386(0x31,&r,&r);
}

/*struct MemBl MemSB;

void *SetSBInt(int SzMn,int SzCh) {
	IntSBPrev=_dos_getvect(SndIRQ+8);
	_dos_setvect(SndIRQ+8,IntSB);
	MemSB.Alloc((SzMn+0xF)>>4);
	return new char[SzCh];
}

void RestoreSBInt(void *pBuf) {
	delete[] pBuf;
	MemSB.Free();
	_dos_setvect(SndIRQ+8,IntSBPrev);
}*/

static char *LoadROM(void *Buf,char *FileName) {
	struct find_t Find;
	if (_dos_findfirst(FileName,_A_NORMAL,&Find)) return TxtErNoFile;
	FILE *Stream;
	if (!(Stream=fopen(Find.name,rb))) return TxtErFOpen;
	unsigned Code=fread(Buf,0x4000,1,Stream);
	fclose(Stream);
	if (!Code) return TxtErFRead;
	return 0;
}

inline unsigned char LoadROMs() {
	if (ChDir(ROMPth)) MessageBox(0x4F,TxtErPth,ROMPth);
	char *TxtEr,*TxtFN;
	unsigned char Code=0;
	if (TxtEr=LoadROM(SpecROM,TxtFN=FileNameROM128)) goto Exit;
	if (TxtEr=LoadROM(SpecROM+0x4000,TxtFN=FileNameROM48)) goto Exit;
	if (TxtEr=LoadROM(SpecROM+0x8000,TxtFN=FileNameROMTR)) goto Exit;
	if (*FileNameROMUser) if (TxtEr=LoadROM(SpecROM+0xC000,TxtFN=FileNameROMUser)) {
		Exit:Code=1;
		MessageBox(0x4F,TxtEr,TxtFN);
	}
	ChDir(StPth);
	return Code;
}

void DeCode(char*);
#pragma aux DeCode=\
	"	mov ah,07Fh"\
	"Cicle:"\
	"	inc edi"\
	"	inc ah"\
	"	xor [edi],ah"\
	"	jnz Cicle"\
	parm [edi] modify [eax edi]

static inline void CopyrightTest() {
	if (DetectOptionCRT) {
#ifdef Rus
		char Txt[]={'('^0x80,'c'^0x81,')'^0x82,' '^0x83,'Н'^0x84,'и'^0x85,'к'^0x86,'о'^0x87,'л'^0x88,'а'^0x89,'й'^0x8A,' '^0x8B,'Ш'^0x8C,'а'^0x8D,'л'^0x8E,'а'^0x8F,'е'^0x90,'в'^0x91,0x92};
#else
		char Txt[]={'('^0x80,'c'^0x81,')'^0x82,' '^0x83,'N'^0x84,'i'^0x85,'k'^0x86,'o'^0x87,'l'^0x88,'a'^0x89,'y'^0x8A,' '^0x8B,'S'^0x8C,'h'^0x8D,'a'^0x8E,'l'^0x8F,'a'^0x90,'e'^0x91,'v'^0x92,0x93};
#endif
		DeCode(Txt-1);
		MessageBox(0xA0,Txt);
	}
}

static inline void BoxAdvanced() {
	Win W(8,62,1,23);
	W.SetTitle(TxtAdv);
	W.SetHelp(74,22,TxtHlpAdv);
	ObjCheckBox ChEC(&W,4,18,TxtExitConf,&ExitConf);
	ObjCheckBox ChDK(&W,4,17,TxtDblKeyKemp,&DblKeyKemp);
	ObjCheckBox ChAS(&W,4,16,TxtAutSave,&AutoSave);
	ObjCheckBox ChGM(&W,4,15,TxtGrayMode,&GrayMode);
	ObjCheckBox ChR(&W,4,14,TxtReady,&Ready);
	ObjCheckBox ChI(&W,4,13,TxtReadIndTr,&ReadIndexTrack);
	ObjRadio RV(&W,43,8,TxtVerR,&CgVerRate);
	ObjRadio RS(&W,20,8,TxtIntS,&CgIntSource);
	ObjRadio RT(&W,4,8,TxtResT,&CgResetType);
	ObjRadio RI(&W,44,2,TxtVidIRQ,&CgVideoIRQ);
	ObjInputNum FDL(&W,4,6,TxtFormLen,&CgFormatDatLen);
	ObjInputNum IL(&W,4,4,TxtIntLen,&CgIntLen);
	ObjInputNum FI(&W,4,2,TxtFrInt,&CgIntRate);
	ObjButton BECanc(&W,33,20,14,ButtCanc,1);
	ObjButton BEOK(&W,15,20,14,ButtOK,2);
	if (W.Exe()) W.SetResult();
}

static inline void BoxSpeed() {
	if (!SpeedTestDetect) {
		void *Pnt=ScrSave();
		SetModeSpec();
		SpeedTest();
		SetModeText();
		CursorOff();
		ScrLoad(Pnt);
	}
	Win W(6,55,4,15);
	W.SetTitle(TxtSpd);
	W.SetHelp(56,23,TxtHlpSpeed);
	W.TxtOut(22,2,TxtSpdPar);
	ObjCheckBox ChM(&W,4,10,TxtSpdMaxTR,&SpeedMaxTR);
	for (int i=0;i<4;i++) for (int j=0;j<3;j++) W.PrintNum(j*10+22,i+4,SpeedTable[i][j]);
	ObjInputNum SA(&W,42,8,TxtNul,&CgSpeedCustA);
	ObjInputNum SP(&W,32,8,TxtNul,&CgSpeedCustP);
	ObjInputNum SC(&W,22,8,TxtNul,&CgSpeedCust);
	ObjRadio SF(&W,4,3,TxtSpdCfg,&CgSpeed);
	ObjButton BECanc(&W,28,12,14,ButtCanc,1);
	ObjButton BEOK(&W,11,12,14,ButtOK,2);
	if (W.Exe()) W.SetResult();
}

static inline void BoxControl() {
	Win W(26,40,4,19);
	W.SetTitle(TxtInput);
	W.SetHelp(60,17,TxtHlpInput);
	ObjCheckBox MML(&W,4,14,TxtMLim,&MouseMoveLimit);
	ObjCheckBox MXC(&W,4,13,TxtMXChg,&MouseKempXChng);
	ObjInputNum MY(&W,4,11,TxtMRatY,&CgMouseRateY);
	ObjInputNum MX(&W,4,9,TxtMRatX,&CgMouseRateX);
	ObjRadio MT(&W,4,5,TxtMTyp,&CgMouseType);
	ObjCheckBox ChS(&W,4,3,TxtJoyS,&JoySinc);
	ObjCheckBox ChK(&W,4,2,TxtJoyK,&JoyKemp);
	ObjButton BECanc(&W,22,16,10,ButtCanc,1);
	ObjButton BEOK(&W,8,16,10,ButtOK,2);
	if (W.Exe()) W.SetResult();
}

static inline void BoxSound() {
	Win W(12,52,5,18);
	W.SetTitle(TxtSound);
	W.SetHelp(61,23,TxtHlpSound);
	ObjRadio(&W,38,2,TxtEnvMul,&CgEnvMul);
	ObjRadio(&W,27,2,TxtSBAdr,&CgSBAdress);
	ObjInputNum(&W,4,12,TxtAdLibWS,&CgAdLibWS);
	ObjInputNum(&W,4,10,TxtSBVol,&CgSBVolume);
	ObjRadio(&W,4,5,TxtSndC,&CgSndC);
	ObjCheckBox(&W,4,3,TxtSndDg,&SoundDigital);
	ObjCheckBox(&W,4,2,TxtBeep,&Beeper);
	ObjButton(&W,27,15,14,ButtCanc,1);
	ObjButton(&W,10,15,14,ButtOK,2);
	if (W.Exe()) W.SetResult();
}

static inline void BoxROM() {
	Win WE(8,51,5,18);
	WE.SetTitle(TxtROM);
	WE.SetHelp(50,11,TxtHlpROM);
	ObjButton BEBrU(&WE,35,12,12,TxtBr,6);
	ObjInputTxt EdRU(&WE,4,11,29,TxtROMU,&CgROMUser);
	ObjButton BEBrT(&WE,35,9,12,TxtBr,5);
	ObjInputTxt EdRT(&WE,4,8,29,TxtROMT,&CgROMTR);
	ObjButton BEBr2(&WE,35,6,12,TxtBr,4);
	ObjInputTxt EdR2(&WE,4,5,29,TxtROM2,&CgROM128);
	ObjButton BEBr4(&WE,35,3,12,TxtBr,3);
	ObjInputTxt EdR4(&WE,4,2,29,TxtROM4,&CgROM48);
	ObjButton BECanc(&WE,27,15,14,ButtCanc,1);
	ObjButton BEOK(&WE,8,15,14,ButtOK,2);
	while (1) switch (WE.Exe()) {
	 case 1:
		WE.SetResult();
		return;
	 case 2:
		EdR4.FileBox(MaskROM,ROMPth);
		break;
	 case 3:
		EdR2.FileBox(MaskROM,ROMPth);
		break;
	 case 4:
		EdRT.FileBox(MaskROM,ROMPth);
		break;
	 case 5:
		EdRU.FileBox(MaskROM,ROMPth);
		break;
	 default:
		return;
	}
}

static inline void BoxPaths() {
	Win W(8,51,4,15);
	W.SetTitle(TxtPath);
	W.SetHelp(50,12,TxtHlpPath);
	ObjInputTxt EdRA(&W,4,8,43,TxtAddPath,&CgAddPth);
	ObjInputTxt EdRD(&W,4,5,43,TxtDskPath,&CgDskPth);
	ObjInputTxt EdRP(&W,4,2,43,TxtROMPath,&CgROMPth);
	ObjButton BECanc(&W,27,12,14,ButtCanc,1);
	ObjButton BEOK(&W,8,12,14,ButtOK,2);
	if (W.Exe()) W.SetResult();
}

static inline void BoxUtil() {
	if (ChDir(DskPth)) MessageBox(0x4F,TxtErPth,DskPth);
	Win W(12,51,5,15);
	W.SetTitle(TxtUtil);
	W.SetHelp(62,18,TxtHlpUtil);
	ObjCheckBox ChF(&W,4,9,TxtFormat,&Format);
	ObjRadio Dr(&W,4,5,TxtDrv,&CgDrive);
	ObjButton BEBr(&W,35,3,12,TxtBr,4);
	ObjInputTxt Ed(&W,4,2,29,TxtDskCpy,&CgDskCopy);
	ObjButton BEEx(&W,18,12,14,TxtExit,1);
	ObjButton BEDtF(&W,31,8,16,TxtFilToDsk,3);
	ObjButton BEFtD(&W,31,6,16,TxtDskToFil,2);
	while (1) {
		int Code=W.Exe();
		W.SetResult();
		switch (Code) {
		 case 1:
			DskUtilDiskToFile();
			break;
		 case 2:
			DskUtilFileToDisk();
			break;
		 case 3:
			Ed.FileBox(MaskDsk,".");
			break;
		 default:
			return;
		}
	}
	ChDir(StPth);
}

static inline void BoxAddAdd() {
	struct CnTxt CgFN={TxtNul,FileLen};
	Win W(8,51,10,9);
	W.SetTitle(TxtAdd);
	ObjButton BBr(&W,35,3,12,TxtBr,3);
	ObjInputTxt Ed(&W,4,2,29,TxtFileName,&CgFN);
	ObjButton BCanc(&W,26,6,14,ButtCanc,1);
	ObjButton BOK(&W,9,6,14,ButtOK,2);
	while (1) switch (W.Exe()) {
	 case 1: {
		Add *AddC=NewAdd(Ed.Ed);
		if (AddC) if (AddC->PrLoc[P_INS])
			((void(__pragma("Progs")*)())AddC->PrLoc[P_INS]->Pr)();
	 }
	 default:
		return;
	 case 2:
		Ed.FileBox(MaskAdd,AddPth);
		break;
	}
}

static inline void BoxAdd() {
	Win W(5,70,2,21);
	W.SetTitle(TxtAddition);
	ObjAListBox L(&W,4,2);
	ObjButton ButEx(&W,52,18,14,TxtExit,1);
	ObjButton ButSt(&W,36,18,14,TxtCfg,2);
	ObjButton ButRm(&W,20,18,14,TxtRemove,3);
	ObjButton ButAd(&W,4,18,14,TxtAdd,4);
	while (1) {
		switch (W.Exe()) {
		 case 1: {
			Add *AddC=L.Sel();
			if (AddC) {
				if (AddC->PrLoc[P_SET])
					((void(__pragma("Progs")*)())AddC->PrLoc[P_SET]->Pr)();
				if (AddC->PrLoc[P_INS])
					((void(__pragma("Progs")*)())AddC->PrLoc[P_INS]->Pr)();
			}
			break;
		 }
		 case 2: {
			Add *AddC=L.Sel();
			if (AddC) delete AddC;
			break;
		 }
		 case 3:
			BoxAddAdd();
			break;
		 default:
			return;
		}
		L.CreateAList();
	}
}

static inline void BoxConfigure() {
	Win WE(4,72,2,20);
	WE.SetTitle(TxtConfig);
	WE.SetHelp(64,22,TxtHlpCfg);
	ObjButton BEAdv(&WE,52,13,16,TxtAdv,12);
	ObjButton BESpd(&WE,52,11,16,TxtSpd,11);
	ObjButton BEJoyst(&WE,52,9,16,TxtInput,10);
	ObjButton BESound(&WE,52,7,16,TxtSound,9);
	ObjButton BEROM(&WE,52,5,16,TxtROM,8);
	ObjButton BEPth(&WE,52,3,16,TxtPath,13);
	ObjButton BEBrD(&WE,35,13,12,TxtBr,7);
	ObjInputTxt EdDD(&WE,4,12,29,TxtDskD,&CgDiskD);
	ObjButton BEBrC(&WE,35,10,12,TxtBr,6);
	ObjInputTxt EdDC(&WE,4,9,29,TxtDskC,&CgDiskC);
	ObjButton BEBrB(&WE,35,7,12,TxtBr,5);
	ObjInputTxt EdDB(&WE,4,6,29,TxtDskB,&CgDiskB);
	ObjButton BEBrA(&WE,35,4,12,TxtBr,4);
	ObjInputTxt EdDA(&WE,4,3,29,TxtDskA,&CgDiskA);
	ObjButton BESave(&WE,47,17,14,TxtSave,3);
	ObjButton BECanc(&WE,29,17,14,ButtCanc,1);
	ObjButton BEOK(&WE,11,17,14,ButtOK,2);
	while (1) switch (WE.Exe()) {
	 case 1:
		WE.SetResult();
		return;
	 case 2:
		WE.SetResult();
		if (ConfigureSave()) MessageBox(0x4F,TxtErSaveCfg);
		return;
	 case 3:
		EdDA.FileBox(MaskDsk,DskPth);
		break;
	 case 4:
		EdDB.FileBox(MaskDsk,DskPth);
		break;
	 case 5:
		EdDC.FileBox(MaskDsk,DskPth);
		break;
	 case 6:
		EdDD.FileBox(MaskDsk,DskPth);
		break;
	 case 7:
		BoxROM();
		break;
	 case 8:
		BoxSound();
		break;
	 case 9:
		BoxControl();
		break;
	 case 10:
		BoxSpeed();
		break;
	 case 11:
		BoxAdvanced();
		break;
	 case 12:
		BoxPaths();
		break;
	 default:
		return;
	}
}

static void ResetAll(unsigned char Seg) {
	EmuTable.Port7FFD=Seg;
	SetMemory();
	SetPage(0);
	ResetCPU();
	SoundAY(0x10);
	DiskVG(0x0C);
	if (Beeper) outp(0x61,inp(0x61)&0xFC);
	EmuTable.PortFE=0x07;
	SetBorderColor();
	CallAddition(PrFirst[P_RES]);
}

/* Помощь по клавиатуре */
static inline void KeyHelp() {
	SetModeHelp();
	MemCopyW(VideoMemGraph+((480-250)*40),KeyHelpPict,10000);
	Pause(0);
	SetModeSpecAdv();
}

static inline void EmuDisks() {
	unsigned TestDet[2][4]={0,0,0,0,0,0,0,0};
	for (int i=0;i<4;i++) {
		unsigned Attr=GetFileAttr(EmuTable.Disks[i]);
		if (Attr!=-1) {
			TestDet[0][i]=Attr&0x1;
			TestDet[1][i]=Attr&0x1;
		}
	}
	Win W(7,66,3,18);
	W.SetTitle(TxtDisks);
	W.SetHelp(58,19,TxtHlpDisks);
	W.TxtOut(49,2,TxtWrPr);
	ObjCheckBox ChD(&W,50,12,TxtDskWrD,&TestDet[0][3]);
	ObjButton BEBrD(&W,35,12,12,TxtBr,6);
	ObjInputTxt EdDD(&W,4,11,29,TxtDskD,&CgDiskD);
	ObjCheckBox ChC(&W,50,9,TxtDskWrC,&TestDet[0][2]);
	ObjButton BEBrC(&W,35,9,12,TxtBr,5);
	ObjInputTxt EdDC(&W,4,8,29,TxtDskC,&CgDiskC);
	ObjCheckBox ChB(&W,50,6,TxtDskWrB,&TestDet[0][1]);
	ObjButton BEBrB(&W,35,6,12,TxtBr,4);
	ObjInputTxt EdDB(&W,4,5,29,TxtDskB,&CgDiskB);
	ObjCheckBox ChA(&W,50,3,TxtDskWrA,&TestDet[0][0]);
	ObjButton BEBrA(&W,35,3,12,TxtBr,3);
	ObjInputTxt EdDA(&W,4,2,29,TxtDskA,&CgDiskA);
	ObjButton BECanc(&W,35,15,14,ButtCanc,1);
	ObjButton BEOK(&W,17,15,14,ButtOK,2);
	while (1) switch (W.Exe()) {
	 case 1: {
		W.SetResult();
		for (int j=0;j<4;j++) {
			if (TestDet[0][j]!=TestDet[1][j]) {
				unsigned Attr=GetFileAttr(EmuTable.Disks[j]);
				if (Attr!=-1) SetFileAttr((Attr&0xFFFFFFFE)|TestDet[0][j],EmuTable.Disks[j]);
			}
		}
		return;
	 }
	 case 2:
		EdDA.FileBox(MaskDsk,DskPth);
		break;
	 case 3:
		EdDB.FileBox(MaskDsk,DskPth);
		break;
	 case 4:
		EdDC.FileBox(MaskDsk,DskPth);
		break;
	 case 5:
		EdDD.FileBox(MaskDsk,DskPth);
		break;
	 default:
		return;
	}
}

static void DisksPrint(Win &W) {
	W.LineOut(4,3,DiskA,36,0x9F);
	W.LineOut(4,6,DiskB,36,0x9F);
	W.LineOut(4,9,DiskC,36,0x9F);
	W.LineOut(4,12,DiskD,36,0x9F);
}

static inline void BoxMain() {
	Win WM(9,62,3,18,0x1F);
	WM.SetTitle(ProgName);
	WM.SetHelp(72,22,TxtHlpMain);
	WM.TxtOut(4,2,TxtDskWrA);
	WM.TxtOut(4,5,TxtDskWrB);
	WM.TxtOut(4,8,TxtDskWrC);
	WM.TxtOut(4,11,TxtDskWrD);
	ObjButton ButInf(&WM,43,12,15,TxtInfo,6);
	ObjButton ButAdd(&WM,43,9,15,TxtAddition,7);
	ObjButton ButDsk(&WM,43,6,15,TxtUtil,5);
	ObjButton ButSet(&WM,43,3,15,TxtConfig,4);
	ObjButton ButCnc(&WM,42,15,14,TxtExit,1);
	ObjButton ButStr(&WM,24,15,14,ButtStart,2);
	ObjButton *ButCont=(ObjButton*)0;
	DisksPrint(WM);
	unsigned StCod=0x0;
	if (DetectOptionS) goto Start;
	while (1) {
		DisksPrint(WM);
		switch (WM.Exe()) {
		 case 1: {
			StCod=0x0;
			Start:
			Mouse();
			unsigned MsX=MouseX;
			unsigned MsY=MouseY;
			void *Pnt=ScrSave();
			if (LoadROMs()) break;
			SoundAY(0x11);

// Установка обработчика прерывания видеоадаптера
			unsigned IntNVid=0x71+VideoIRQ;
			if (IntSource==1) {
//			if (!VideoIRQ) IntNVid=0x0A;///?
				IntTimerPrev=_dos_getvect(IntNVid);
				_dos_setvect(IntNVid,IntVideo);
				*(unsigned*)(RMInt.Adr+(int)&IntVideoPrev16-(int)&IntRMProc)=
						GetRMVect(IntNVid);
				SetRMVect(IntNVid,(RMInt.Seg<<0x10)|((int)&IntVideo16-(int)&IntRMProc));
			}

// Включение режима ZX-Spectrum
			SetModeSpecAdv();
			if (!StCod) {
				memset(SpecRAM,0,sizeof(SpecRAM)); // Очистка памяти Spectrum
				switch (ResetType) {
				 case 0:
					ResetAll(0x00);
					break;
				 case 1:
					ResetAll(0x10);
					break;
				 case 2:
					ResetAll(0x10);
					EmuTable.SpecSeg[0]=SpecROM+0x8000;
					break;
				}
			}
			while (1) {
				MainCPU();
				if (*PntIntDetect&0x00000001) break;
				if (*PntIntDetect&0x00000020) {
					SetModeText();
					MouseInit();
					EmuDisks();
					SetModeSpecAdv();
				}
				if (*PntIntDetect&0x00000002) KeyHelp();
				if (*PntIntDetect&0x10000000) {
					ResetAll(0x10);
					EmuTable.SpecSeg[0]=SpecROM+0x8000;
				}
				if (*PntIntDetect&0x08000000) ResetAll(0x10);
				if (*PntIntDetect&0x04000000) ResetAll(0x00);
				if (*PntIntDetect&0x00100000) CallAddition(PrFirst[P_F7_]);
				if (*PntIntDetect&0x00200000) CallAddition(PrFirst[P_F8_]);
				if (*PntIntDetect&0x00010000) CallAddition(PrFirst[P_F9_]);
				if (*PntIntDetect&0x00020000) CallAddition(PrFirst[P_F10]);
				if (*PntIntDetect&0x00040000) CallAddition(PrFirst[P_F11]);
				if (*PntIntDetect&0x00080000) CallAddition(PrFirst[P_F12]);
			}
			SetModeText();
			if (IntSource==1) {
				SetRMVect(IntNVid,
						*(unsigned*)(RMInt.Adr+(int)&IntVideoPrev16-(int)&IntRMProc));
				_dos_setvect(IntNVid,IntVideoPrev);
			}
			CursorOff();
			ScrLoad(Pnt);
			MouseInit();
			MouseSet(MsX,MsY);
			if (!ButCont) {
				ButCont=new ObjButton(&WM,6,15,14,TxtCont,3);
				ButStr.TurnPrev();
			}
			break;
		 }
		 case 2:
			StCod=0x1;
			goto Start;
		 case 3:
			BoxConfigure();
			break;
		 case 4: {
			BoxUtil();
			break;
		 }
		 case 5: {
			Win WI(15,53,6,16);
			WI.SetTitle(TxtInfo);
			WI.TxtOut(4,2,PrMes);
			WI.TxtOut(4,5,TxtThanks);
			ObjButton ButOK(&WI,20,13,12,ButtOK,1);
			WI.Exe();
			break;
		 }
		 case 6:
			BoxAdd();
			break;
		 default: {
			if (ExitConf) {
				Win WEx(30,33,15,7);
				WEx.SetTitle(TxtExit);
				WEx.TxtOut(10,2,TxtSure);
				ObjButton ButNo(&WEx,18,4,10,ButtNo,1);
				ObjButton ButYes(&WEx,5,4,10,ButtYes,2);
				if (!WEx.Exe()) break;
			}
			if (ButCont) delete ButCont;
			return;
		 }
		}
	}
}

unsigned InIntContr();
#pragma aux InIntContr=\
	"	in al,0x21"\
	"	mov ah,al"\
	"	in al,0xA1"\
	value [eax]

void OutIntContr(unsigned);
#pragma aux OutIntContr=\
	"	out 0xA1,al"\
	"	mov al,ah"\
	"	out 0x21,al"\
	parm [eax]

static void DeInit() {
	while (AddLast) delete AddLast;
	SetModeText();
	ScreenClear();

// Запись маски контроллеров прерываний
	OutIntContr(IntContr);
	if (*(unsigned*)(RMInt.Adr+(int)&IntKeyPrev-(int)&IntRMProc)) {
		SetRMVect(IntNKey,
				*(unsigned*)(RMInt.Adr+(int)&IntKeyPrev-(int)&IntRMProc));
		_dos_setvect(IntNTim,IntTimerPrev);
	}
	RMInt.Free();
}

int TextCalc(char *Txt);
#pragma aux TextCalc=\
	"	cld"\
	"	xor ebx,ebx"\
	"Cicle:"\
	"	lodsb"\
	"	add bl,al"\
	"	xor bh,al"\
	"	rol ebx,1"\
	"	test al,al"\
	"	jnz Cicle"\
	parm [esi] value [ebx] modify [eax ebx esi]

void FileDelete(char *Name);
#pragma aux FileDelete=\
	"	mov ah,0x41"\
	"	int 0x21"\
	parm [edx] modify [eax]

void main(int argc,char *argv[]) {

// Проверка наличия VGA
	ri.ax=0x1A00;
	IntRealMode(0x10);
	if (ri.a.l!=0x1A||ri.b.l<0x05) Fatal(TxtErVGA);////7,8,b,c

// Установка обработчиков прерываний реального режима
	RMInt.Alloc(((int)&EndRM-(int)&IntRMProc+0xF)>>4);
	memcpy(RMInt.Adr,IntRMProc,(int)&EndRM-(int)&IntRMProc);
	PntIntDetect=(unsigned*)(RMInt.Adr+(int)&IntDetect-(int)&IntRMProc);
	TabKeyPnt=(byte*)(RMInt.Adr+(int)&TabKey-(int)&IntRMProc);
	Port1FPnt=(byte*)(RMInt.Adr+(int)&Port1F-(int)&IntRMProc);
	DoubleKeyPnt=(dword*)(RMInt.Adr+(int)&DoubleKey-(int)&IntRMProc);
	EmuTable.Keys=(byte*)(RMInt.Adr+(int)&Keys-(int)&IntRMProc);
	ModifyPointTr=ModifyPointRV=ModifyPointRm=
	ModifyPointTTr=ModifyPointTRV=ModifyPointTRm=PntIntDetect;

// Установка обработчика прерывания таймера
	IntTimerPrev=_dos_getvect(IntNTim);
	_dos_setvect(IntNTim,IntTimer);

// Установка обработчика прерывания клавиатуры
	*(unsigned*)(RMInt.Adr+(int)&IntKeyPrev-(int)&IntRMProc)=
			GetRMVect(IntNKey);
	SetRMVect(IntNKey,(RMInt.Seg<<0x10)|((int)&IntKey-(int)&IntRMProc));

// Чтение маски контроллеров прерываний
	IntContr=InIntContr();

// Чтение стартового пути
	GetDir(StPth);

	DriveTypeInit();
	VideoTable();
	IncDecTblIni();
	JoystickInit();

// Установка текстового видеорежима заполнение экрана
	SetModeText();

// Инициализация мыши
	MouseInit();

// Параметры командной строки
	EmuTable.ArgC=argc;
	EmuTable.ArgV=argv;

// Загрузка конфигурации
	ConfigureLoad();

// Анализ параметров командной строки
	char *TxtExitEnd=TxtNul;
	int DskNum=0;
	for (int i=1;i<argc;i++) {
		const char *Arg=argv[i];
		if (*Arg=='/'||*Arg=='-') {
			++Arg;
			if (TxtCmpReg(Arg,"H")||TxtCmpReg(Arg,"?")) {
				TxtExitEnd=TxtHlpSw;
				goto Exit;
			}
			if (TxtCmpReg(Arg,"S")) DetectOptionS=1;
			if (TxtCmpReg(Arg,CRT)) DetectOptionCRT=1;
		} else if (DskNum<4) TxtCopy(EmuTable.Disks[DskNum++],Arg,FileLen,MaskDsk+1);
	}

// Проверка опций
	CopyrightTest();

// Вызов настройки
	CallAddition(PrFirst[P_INS]);

// Запуск основной подпрограммы (интерфейс)
	BoxMain();
	if (AutoSave) ConfigureSave();
	Exit:DeInit();
	cout<<PrMes<<TxtExitEnd;
}

/* Фатальная ошибка */
void Fatal(const char *Mes0,const char *Mes1) {
	DeInit();
	cout<<Mes0<<Mes1<<'\n';
	exit(1);
}
