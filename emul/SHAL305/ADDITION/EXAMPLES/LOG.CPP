/**************************************************************************

Логический протокол работы

**************************************************************************/

#include "emudata.h"

EmuData *TblData;
unsigned Id;

char _DSC[]="Логический протокол работы (F7) "; // Описание

// Строки для интерфейса
char TxtTitle[]="Логический протокол работы";
char TxtOk[]="\001OK";
char TxtCancel[]="О\001тмена";
char TxtKey[]="\001Клавиша\nF7\nF8\nF9\nF10\nF11\nF12";
char TxtOn[]="Трассировка \001включена";
char TxtOut[]="Трассировка \001записи в порт";
char TxtIn[]="Трассировка \001чтения из порта";
char TxtAY[]="Трассировка \001AY";
char TxtVG[]="Трассировка контроллера \001дисковода";
char TxtCPU[]="Трассировка \001CPU";

// Текущие установки
unsigned TraceCPU=0x0;
unsigned TraceVG=0x0;
unsigned TraceAY=0x0;
unsigned TraceIn=0x0;
unsigned TraceOut=0x0;

unsigned TraceAll=0x0;

unsigned Key=0x0;

// Строки для конфигурации
static const char *COffOn[]={"Off","On"};
static const char *CKey[]={"F7","F8","F9","F10","F11","F12"};

// Данные конфигурации
struct CnTbl CgTraceCPU={&TraceCPU,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgTraceVG={&TraceVG,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgTraceAY={&TraceAY,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgTraceIn={&TraceIn,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgTraceOut={&TraceOut,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgTraceAll={&TraceAll,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgKey={&Key,CKey,sizeof CKey/sizeof(char*)};

static struct CfgS Cfg[]={
	TTbl,"TraceCPU=",&CgTraceCPU,
	TTbl,"TraceVG=",&CgTraceVG,
	TTbl,"TraceAY=",&CgTraceAY,
	TTbl,"TraceIn=",&CgTraceIn,
	TTbl,"TraceOut=",&CgTraceOut,
	TTbl,"Key=",&CgKey,
};

struct CfgDat _CFG={Cfg,sizeof Cfg/sizeof(CfgS)};

// Номер файла
unsigned Handle;

// Символы для печати шестнадцатиричных значений
static const char SymHex[]={
	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
};

// Перевод значения в строку
static void HexToStr(unsigned Val,char *Txt,int Num) {
	Txt+=Num-1;
	while (Num--) {
		*Txt--=SymHex[Val&0xF];
		Val>>=4;
	}
};

// Создание файла
unsigned FileCreate(char *Name);
#pragma aux FileCreate=\
	"	mov ah,0x3C"\
	"	xor ecx,ecx"\
	"	int 0x21"\
	modify [eax ecx] parm [edx] value [eax]

// Запись файла
void FileSave(void *Buf,unsigned Size,unsigned Handle);
#pragma aux FileSave=\
	"	mov ah,0x40"\
	"	int 0x21"\
	modify [eax] parm [edx][ecx][ebx]

// Закрытие файла
void FileClose(unsigned Handle);
#pragma aux FileClose=\
	"	mov ah,0x3E"\
	"	int 0x21"\
	modify [eax] parm [ebx]

// Строки для протокола работы
char LineCPU[]="PC=0000 00 00 00 SP=0000 AF=0000 BC=0000 DE=0000 HL=0000 IX=0000 IY=0000\r\n";
char LineVG[]="Com=00 St=00 RDt=00 Sys=00 Opr=00 Dat=00 Trk=00 Sec=00\r\n";
char LineIn[]="In Port: 0000 Value: 00\r\n";
char LineOut[]="Out Port: 0000 Value: 00\r\n";
char LineAY[]="AY W:00 0=00 1=00 2=00 3=00 4=00 5=00 6=00 7=00 8=00 9=00 A=00 B=00 C=00 D=00\r\n";
char LineInt[]="Interrupt: Mode 0, ";
char LineIntD[]="Disabled\r\n";
char LineIntE[]="Enabled\r\n";

// Включение трассировки
void _ON_() {if (TraceAll&&TraceCPU) TblData->CPUTraceOn(Id);}

// Выключение трассировки
void _OFF() {if (TraceAll&&TraceCPU) TblData->CPUTraceOff(Id);}

// Инициализация (сохранение указателя на данные, номера и создание файла)
void _INI(EmuData *Pnt,unsigned IdN) {
	TblData=Pnt;
	Id=IdN;
	Handle=FileCreate("SPECTRUM.LOG");
}

// Деинициализация (закрытие файла)
void _UNI() {FileClose(Handle);}

void _INS() {
	char *TxtD=_DSC+28;
	const char *TxtS=CKey[Key];
	while (*TxtS) *TxtD++=*TxtS++;
	*TxtD++=')';
	*TxtD=0;
}

// Трассировка процессора
unsigned RegEDI();
#pragma aux RegEDI="" value [edi]

unsigned RegESI();
#pragma aux RegESI="" value [esi]

unsigned RegEDX();
#pragma aux RegEDX="" value [edx]

unsigned RegECX();
#pragma aux RegECX="" value [ecx]

unsigned _CPU(unsigned Code) {
	unsigned RegPCr,RegSPr,RegAFr,RegFRr;
	RegPCr=RegEDI();
	RegSPr=RegESI();
	RegAFr=RegEDX();
	RegFRr=RegECX();
	if (TraceAll&&TraceCPU) {
		HexToStr(RegPCr,LineCPU+3,4);
		HexToStr((TblData->SpecSeg[RegPCr>>0xE])[RegPCr&0x3FFF],LineCPU+8,2);
		HexToStr((TblData->SpecSeg[((RegPCr+1)>>0xE)&0x3])[(RegPCr+1)&0x3FFF],LineCPU+11,2);
		HexToStr((TblData->SpecSeg[((RegPCr+2)>>0xE)&0x3])[(RegPCr+2)&0x3FFF],LineCPU+14,2);
		HexToStr(RegSPr,LineCPU+20,4);
		HexToStr((RegAFr&0xFFD7)|((RegFRr>>8)&0x28),LineCPU+28,4);
		HexToStr(TblData->DataCPU.RegBC,LineCPU+36,4);
		HexToStr(TblData->DataCPU.RegDE,LineCPU+44,4);
		HexToStr(TblData->DataCPU.RegHL,LineCPU+52,4);
		HexToStr(TblData->DataCPU.RegIX,LineCPU+60,4);
		HexToStr(TblData->DataCPU.RegIY,LineCPU+68,4);
		FileSave(LineCPU,sizeof LineCPU-1,Handle);
	}
	return Code;
}

// Прерывания
void _ITP(unsigned RegPC,unsigned RegSP,unsigned RegAF,unsigned RegFR) {
	if (!TraceAll||!TraceCPU) return;
	LineInt[16]=((TblData->DataCPU.IM)+'0');
	FileSave(LineInt,sizeof LineInt-1,Handle);
	if (TblData->DataCPU.IFF1) FileSave(LineIntE,sizeof LineIntE-1,Handle);
	else FileSave(LineIntD,sizeof LineIntD-1,Handle);
}

// Чтение из порта
unsigned char _INP(word Port,byte Val) {
	if (TraceAll&&TraceIn) {
		HexToStr(Port,LineIn+9,4);
		HexToStr(Val,LineIn+21,2);
		FileSave(LineIn,sizeof LineIn-1,Handle);
	}
	return Val;
}

// Запись в порт
void _OUP(word Port,byte Val) {
	if (TraceAll&&TraceOut) {
		HexToStr(Port,LineOut+10,4);
		HexToStr(Val,LineOut+22,2);
		FileSave(LineOut,sizeof LineOut-1,Handle);
	}
}

// Трассировка контроллера дисковода
void _VGP() {
	if (!TraceAll||!TraceVG) return;
	HexToStr(TblData->VG.RegCom,LineVG+4,2);
	HexToStr(TblData->VG.RegStatus,LineVG+10,2);
	HexToStr(TblData->VG.RegData,LineVG+17,2);
	HexToStr(TblData->VG.System,LineVG+24,2);
	HexToStr(TblData->VG.OperIO,LineVG+31,2);
	HexToStr(TblData->VG.DataIO,LineVG+38,2);
	HexToStr(TblData->VG.RegTrack,LineVG+45,2);
	HexToStr(TblData->VG.RegSect,LineVG+52,2);
	FileSave(LineVG,sizeof LineVG-1,Handle);
}

// Трассировка музыкального синтезатора
unsigned char _AY_(unsigned Reg,unsigned char) {
	if (!TraceAll||!TraceAY||Reg>0xD) return 0;
	HexToStr(Reg,LineAY+5,2);
	for (int i=0;i<0xE;i++) HexToStr(TblData->AY.RegData[i],LineAY+10+i*5,2);
	FileSave(LineAY,sizeof LineAY-1,Handle);
	return 0;
}

// Установка конфигурации
void _SET() {
	void *Pnt=TblData->WinCreate(13,4,54,14,0x1F);
	TblData->WinTitle(Pnt,TxtTitle,0xF0);
	TblData->SetRadio(Pnt,43,2,TxtKey,&CgKey);
	TblData->SetCheckBox(Pnt,4,8,TxtOn,&TraceAll);
	TblData->SetCheckBox(Pnt,4,6,TxtOut,&TraceOut);
	TblData->SetCheckBox(Pnt,4,5,TxtIn,&TraceIn);
	TblData->SetCheckBox(Pnt,4,4,TxtAY,&TraceAY);
	TblData->SetCheckBox(Pnt,4,3,TxtVG,&TraceVG);
	TblData->SetCheckBox(Pnt,4,2,TxtCPU,&TraceCPU);
	TblData->SetButton(Pnt,29,11,TxtCancel,12,0);
	TblData->SetButton(Pnt,13,11,TxtOk,12,1);
	if (TblData->WinExe(Pnt)) TblData->WinResult(Pnt);
	TblData->WinRemove(Pnt);
}

// Панель диалога, которая активизируется по горячей клавише
static void WorkMenu() {
	TblData->TextMode();
	void *Pnt=TblData->WinCreate(17,5,45,14,0x1F);
	TblData->WinTitle(Pnt,TxtTitle,0xF0);
	TblData->SetCheckBox(Pnt,4,8,TxtOn,&TraceAll);
	TblData->SetCheckBox(Pnt,4,6,TxtOut,&TraceOut);
	TblData->SetCheckBox(Pnt,4,5,TxtIn,&TraceIn);
	TblData->SetCheckBox(Pnt,4,4,TxtAY,&TraceAY);
	TblData->SetCheckBox(Pnt,4,3,TxtVG,&TraceVG);
	TblData->SetCheckBox(Pnt,4,2,TxtCPU,&TraceCPU);
	TblData->SetButton(Pnt,24,11,TxtCancel,12,0);
	TblData->SetButton(Pnt,9,11,TxtOk,12,1);
	if (TblData->WinExe(Pnt)) TblData->WinResult(Pnt);
	TblData->WinRemove(Pnt);
	TblData->SetSpec();
}

void _F7_() {if (Key==0) WorkMenu();}
void _F8_() {if (Key==1) WorkMenu();}
void _F9_() {if (Key==2) WorkMenu();}
void _F10() {if (Key==3) WorkMenu();}
void _F11() {if (Key==4) WorkMenu();}
void _F12() {if (Key==5) WorkMenu();}
