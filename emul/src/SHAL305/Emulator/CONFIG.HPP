/**************************************************************************

Работа с конфигурацией

**************************************************************************/

#include "emudata.h"

extern struct CnTxt CgROMPth;
extern struct CnTxt CgROM48;
extern struct CnTxt CgROM128;
extern struct CnTxt CgROMTR;
extern struct CnTxt CgROMUser;
extern struct CnTxt CgDskPth;
extern struct CnTxt CgDiskA;
extern struct CnTxt CgDiskB;
extern struct CnTxt CgDiskC;
extern struct CnTxt CgDiskD;
extern struct CnTbl CgDrive;
extern struct CnTxt CgDskCopy;
extern struct CnTbl CgFormat;
extern struct CnTbl CgBeeper;
extern struct CnTbl CgSndC;
extern struct CnTbl CgDig;
extern struct CnNum CgAdLibWS;
extern struct CnTbl CgSBAdress;
extern struct CnNum CgSBVolume;
extern struct CnTbl CgEnvMul;
extern struct CnTbl CgJoyKemp;
extern struct CnTbl CgJoySinc;
extern struct CnTbl CgMouseType;
extern struct CnNum CgMouseRateX;
extern struct CnNum CgMouseRateY;
extern struct CnTbl CgMouseXC;
extern struct CnTbl CgMouseMovLim;
extern struct CnTbl CgSpeed;
extern struct CnNum CgSpeedCust;
extern struct CnNum CgSpeedCustP;
extern struct CnNum CgSpeedCustA;
extern struct CnTbl CgSpeedMaxTR;
extern struct CnNum CgIntRate;
extern struct CnNum CgIntLen;
extern struct CnTbl CgVerRate;
extern struct CnTbl CgIntSource;
extern struct CnTbl CgVideoIRQ;
extern struct CnTbl CgGrayMode;
extern struct CnNum CgFormatDatLen;
extern struct CnTbl CgReady;
extern struct CnTbl CgResetType;
extern struct CnTbl CgDblKeyKemp;
extern struct CnTbl CgExitConf;
extern struct CnTbl CgAutoSave;
extern struct CnTxt CgAddPth;

extern void ConfigureLoad();
extern unsigned char ConfigureSave();
