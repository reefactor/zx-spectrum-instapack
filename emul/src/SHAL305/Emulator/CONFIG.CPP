/**************************************************************************

Чтение и запись конфигурации

**************************************************************************/

#include <fstream.h>
#include "main.hpp"
#include "text.hpp"
#include "addition.hpp"
#include "interfac.hpp"
#include "diskutil.hpp"
#include "vg.hpp"

static const char CTNone[]="None";

static const char *CDrv[]={"A","B"};
static const char *COffOn[]={"Off","On"};
static const char *CSndC[]={CTNone,"AdLib","SoundBlaster"};
static const char *CSbAdr[]={"210","220","230","240","250","260","280"};
static const char *CEnvMul[]={
	"x1","x2","x4","x8","x16","x32","x64","x128","x256","x512"
};
static const char *CSpd[]={"Normal","Max","Fast","Slow","Custom"};
static const char *CResM[]={"128","48","TRDOS"};
static const char *CIntSrc[]={"Timer","Video","Retrace"};
static const char *CVerRat[]={"50","55","60","75"};
static const char *CVidIRQ[]={"9","10","11","12"};
static const char *CMous[]={CTNone,"Kempston"};

struct CnTxt CgROMPth={ROMPth,sizeof ROMPth};
struct CnTxt CgROM48={FileNameROM48,sizeof FileNameROM48};
struct CnTxt CgROM128={FileNameROM128,sizeof FileNameROM128};
struct CnTxt CgROMTR={FileNameROMTR,sizeof FileNameROMTR};
struct CnTxt CgROMUser={FileNameROMUser,sizeof FileNameROMUser};
struct CnTxt CgDskPth={DskPth,sizeof DskPth};
struct CnTxt CgDiskA={DiskA,sizeof DiskA};
struct CnTxt CgDiskB={DiskB,sizeof DiskB};
struct CnTxt CgDiskC={DiskC,sizeof DiskC};
struct CnTxt CgDiskD={DiskD,sizeof DiskD};
struct CnTbl CgDrive={&Drive,CDrv,sizeof CDrv/sizeof(char*)};
struct CnTxt CgDskCopy={FileNameCopy,sizeof FileNameCopy};
struct CnTbl CgFormat={&Format,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgBeeper={&Beeper,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgSndC={&SoundCard,CSndC,sizeof CSndC/sizeof(char*)};
struct CnTbl CgDig={&SoundDigital,COffOn,sizeof COffOn/sizeof(char*)};
struct CnNum CgAdLibWS={&AdLibWaitState,AdLibWSMin,AdLibWSMax};
struct CnTbl CgSBAdress={&SBAdress,CSbAdr,sizeof CSbAdr/sizeof(char*)};
struct CnNum CgSBVolume={&SBVolume,SBVolMin,SBVolMax};
struct CnTbl CgEnvMul={&EnvelopeMul,CEnvMul,sizeof CEnvMul/sizeof(char*)};
struct CnTbl CgJoyKemp={&JoyKemp,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgJoySinc={&JoySinc,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgMouseType={&MouseType,CMous,sizeof CMous/sizeof(char*)};
struct CnNum CgMouseRateX={&MouseRateX,MRatMin,MRatMax};
struct CnNum CgMouseRateY={&MouseRateY,MRatMin,MRatMax};
struct CnTbl CgMouseXC={&MouseKempXChng,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgMouseMovLim={&MouseMoveLimit,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgSpeed={&Speed,CSpd,sizeof CSpd/sizeof(char*)};
struct CnNum CgSpeedCust={&SpeedTable[4][0],SpdCstMin,SpdCstMax};
struct CnNum CgSpeedCustP={&SpeedTable[4][1],SpdCstMin,SpdCstMax};
struct CnNum CgSpeedCustA={&SpeedTable[4][2],SpdCstMin,SpdCstMax};
struct CnTbl CgSpeedMaxTR={&SpeedMaxTR,COffOn,sizeof COffOn/sizeof(char*)};
struct CnNum CgIntRate={&IntRate,IntRatMin,IntRatMax};
struct CnNum CgIntLen={&IntLen,IntLenMin,IntLenMax};
struct CnTbl CgVerRate={&VerRate,CVerRat,sizeof CVerRat/sizeof(char*)};
struct CnTbl CgIntSource={&IntSource,CIntSrc,sizeof CIntSrc/sizeof(char*)};
struct CnTbl CgVideoIRQ={&VideoIRQ,CVidIRQ,sizeof CVidIRQ/sizeof(char*)};
struct CnTbl CgGrayMode={&GrayMode,COffOn,sizeof COffOn/sizeof(char*)};
struct CnNum CgFormatDatLen={&FormatDatLen,FrmLnMn,FrmLnMx};
struct CnTbl CgReady={&Ready,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgReadIndTr={&ReadIndexTrack,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgResetType={&ResetType,CResM,sizeof CResM/sizeof(char*)};
struct CnTbl CgDblKeyKemp={&DblKeyKemp,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgExitConf={&ExitConf,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTbl CgAutoSave={&AutoSave,COffOn,sizeof COffOn/sizeof(char*)};
struct CnTxt CgAddPth={AddPth,sizeof AddPth};

static const char TxtCfgAdd[]="Add:";

static struct CfgS Cfg[]={
	TTxt,"ROMPath=",&CgROMPth,
	TTxt,"ROM48=",&CgROM48,
	TTxt,"ROM128=",&CgROM128,
	TTxt,"ROMTR=",&CgROMTR,
	TTxt,"ROMUser=",&CgROMUser,
	TTxt,"DiskPath=",&CgDskPth,
	TTxt,"DiskA=",&CgDiskA,
	TTxt,"DiskB=",&CgDiskB,
	TTxt,"DiskC=",&CgDiskC,
	TTxt,"DiskD=",&CgDiskD,
	TTbl,"DiskUtilityDrive=",&CgDrive,
	TTxt,"DiskUtilityFilename=",&CgDskCopy,
	TTbl,"DiskUtilityFormat=",&CgFormat,
	TTbl,"Beeper=",&CgBeeper,
	TTbl,"SoundCard=",&CgSndC,
	TTbl,"SoundDigital=",&CgDig,
	TNum,"SoundAdLibWaitState=",&CgAdLibWS,
	TTbl,"SoundBlasterAdress=",&CgSBAdress,
	TNum,"SoundBlasterVolume=",&CgSBVolume,
	TTbl,"SoundEnvelopeMulti=",&CgEnvMul,
	TTbl,"JoystickKempston=",&CgJoyKemp,
	TTbl,"JoystickSinclair=",&CgJoySinc,
	TTbl,"MouseType=",&CgMouseType,
	TNum,"MouseRateX=",&CgMouseRateX,
	TNum,"MouseRateY=",&CgMouseRateY,
	TTbl,"MouseKempButtonXChange=",&CgMouseXC,
	TTbl,"MouseKempMoveLimit=",&CgMouseMovLim,
	TTbl,"Speed=",&CgSpeed,
	TNum,"SpeedCustom=",&CgSpeedCust,
	TNum,"SpeedCustomPixel=",&CgSpeedCustP,
	TNum,"SpeedCustomAttr=",&CgSpeedCustA,
	TTbl,"SpeedMaxTR=",&CgSpeedMaxTR,
	TNum,"FrequencyInt(Hz)=",&CgIntRate,
	TNum,"InterruptLenght(Command)=",&CgIntLen,
	TTbl,"VerticalRate(Hz)=",&CgVerRate,
	TTbl,"IntSource=",&CgIntSource,
	TTbl,"VideoIRQ=",&CgVideoIRQ,
	TTbl,"GrayMode=",&CgGrayMode,
	TNum,"FormatDataLen=",&CgFormatDatLen,
	TTbl,"DiskReadyAnytime=",&CgReady,
	TTbl,"DiskReadIndexTrack=",&CgReadIndTr,
	TTbl,"ResetType=",&CgResetType,
	TTbl,"DoubleKeyAndKempston=",&CgDblKeyKemp,
	TTbl,"ExitConfirm=",&CgExitConf,
	TTbl,"AutoSaveConfig=",&CgAutoSave,
	TTxt,"AddPath=",&CgAddPth,
	TAdd,"Addition=",0,
	TAdO,TxtCfgAdd,0,
};

struct CfgDat CfgData={Cfg,sizeof Cfg/sizeof(CfgS)};

static const char FileNameCfg[]="SPECTRUM.INI";

static struct CfgDat *CfgAdd;

/* Чтение конфигуpации */
static char *SetOption(CfgDat *CfgD,const char *TxtOpt) {
// Поиск опции и установка значения
	CfgS *Cfg=CfgD->Cfg;
	for (int i=0;i<CfgD->Num;i++) {
		const char *TxtL=TxtOpt,*TxtO=Cfg[i].Txt;
		while (*TxtL&&*TxtL==*TxtO++) {
			char Ch=*TxtL++;
				if (Ch=='='||Ch==':') {
				switch (Cfg[i].Type) {
				 case TTxt:
					if (TextCopy(Cfg[i].CTxt->Dst,TxtL,Cfg[i].CTxt->Siz)) return 0;
					return TxtErValMuch;
				 case TTbl: {
					struct CnTbl *CTbl=Cfg[i].CTbl;
					for (int a=0;a<CTbl->ValN;a++) if (TxtCmp(TxtL,CTbl->Val[a])) {
						*CTbl->Dst=a;
						return 0;
					}
					return TxtErUnknownVal;
				 }
				 case TNum: {
					struct CnNum *CNum=Cfg[i].CNum;
					unsigned Val=0;
					while (*TxtL) Val=Val*0xA+*TxtL++-'0';
					if (Val<CNum->Min) {
						*CNum->Dst=CNum->Min;
						return TxtErValSmall;
					}
					if (Val>CNum->Max) {
						*CNum->Dst=CNum->Max;
						return TxtErValLarge;
					}
					*CNum->Dst=Val;
					break;
				 }
				 case TAdd: {
					Add *Pnt=NewAdd(TxtL);
					CfgAdd=0;
					if (Pnt) CfgAdd=(CfgDat*)Pnt->PrLoc[P_CFG]->Pr;
					break;
				 }
				 case TAdO:
					if (!CfgAdd) return TxtErNoAdd;
					SetOption(CfgAdd,TxtL);
					break;
				}
				return 0;
			}
		}
	}
	return TxtErUnknownOpt;
}

void ConfigureLoad() {
	ifstream Str(FileNameCfg);
	char Line[LineSize];
	if (!Str) return;
	do {
		Str.get(Line,sizeof Line,'\n');
		char ch;
		if (Str.get(ch)&&ch!='\n') {
			MessageBox(0x4F,TxtErLineMuch,Line);
			while (Str.get(ch)&&ch!='\n');
		}

// Удаление пробелов, комментария и кавычек
		char *Src=Line,*Dst=Line;
		unsigned char Sym=0x00;
		while (*Src&&*Src!=';') {
			if (*Src=='"') Sym^=0x01;
			else if (Sym||*Src>' ') *Dst++=*Src;
			Src++;
		}

// Поиск опции и установка значения
		if (Dst!=Line) {
			*Dst=0;
			char *TxtEr=SetOption(&CfgData,Line);
			if (TxtEr) MessageBox(0x4F,TxtEr,Line);
		}

	} while (!Str.eof());
}

static char EndL[]="\"\n";

static void CfgSave(ofstream &Str,CfgDat *CfgD,const char *Lin) {
	CfgS *Cfg=CfgD->Cfg;
	for (int i=0;i<CfgD->Num;i++) {
		Str<<Lin;
		switch (Cfg[i].Type) {
		 case TTxt:
			Str<<Cfg[i].Txt<<'"'<<Cfg[i].CTxt->Dst<<EndL;
			break;
		 case TTbl:
			Str<<Cfg[i].Txt<<Cfg[i].CTbl->Val[*Cfg[i].CTbl->Dst]<<'\n';
			break;
		 case TNum:
			Str<<Cfg[i].Txt<<*Cfg[i].CNum->Dst<<'\n';
			break;
		 case TAdd:
			if (AddFirst) {
				class Add *APnt=AddFirst;
				do {
					Str<<Cfg[i].Txt<<'"'<<APnt->Name<<EndL;
					Proc *CfgDSav=APnt->PrLoc[P_CFG];
					if (CfgDSav) CfgSave(Str,(CfgDat*)CfgDSav->Pr,TxtCfgAdd);
				}
				while (APnt=APnt->Next);
			}
			break;
		}
	}
}

/* Запись конфигурации */
unsigned char ConfigureSave() {
	ofstream Str(FileNameCfg);
	if (!Str) return 1;
	CfgSave(Str,&CfgData,TxtNul);
	return 0;
}
