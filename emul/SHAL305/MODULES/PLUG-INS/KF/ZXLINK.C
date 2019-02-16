/*****************************************************************************
 * *MAS* PC<->ZX Link emulation module for ZX-Spectrum emulator by N.Shalaev *
 * (C) 10-Jul-2001 Kirill Frolov <Kirill.Frolov@z2.n5030.f827.p2.fidonet.org>*
 *                                                                           *
 * This program is free software. You can redistribute it and/or modify      *
 * it under the terms of the GNU General Public License as published by      *
 * the Free Software Foundation; either version 2 of the License, or         *
 * any later version. See LICENSE file for more information.                 *
 *									     */
#define VERSION "0.4 beta  15-07-2002"
/*                                                                           *
 *****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void main()
{
}

/*
int strlen(char *s)
{
	return 0;
}

void sprintf(char *s, char *f, ...)
{

}
*/

/* inp, outp */
#include <conio.h>

#include "emudata.h"

#ifndef uchar
typedef unsigned char uchar;
#endif
#ifndef ushort
typedef unsigned short ushort;
#endif

#define MAX_LPT_PORTS 8
#define MAX_BIOS_LPT_PORTS 4


EmuData *TblData;
unsigned int Id;

static ushort LptHwAddr[MAX_LPT_PORTS];

int LptPortNum;
int ModelType;
#define MdlScorpion 0
#define MdlPentagon 1
ushort LptBase;

/*
 *MAS* interface:
  PC     <------------>     ZX
  Data 0      d0>	    Kempston 0	
  Data 1      d1>          Kempston 1
  Error       d0<          Centronics 0
  PaperEnd    d1<          Centronics 1
*/

#define PC_OUT_DATA	0x01
#define PC_OUT_STROBE	0x02
#define PC_IN_DATA	0x08
#define PC_IN_STROBE	0x20

#define ZX_OUT_DATA	0x01
#define ZX_OUT_STROBE	0x02
#define ZX_IN_DATA	0x01
#define ZX_IN_STROBE	0x02

struct plink {
	char data;
	char strobe;
};

/*
 ZXLPrint interface:
 		Scorpion	Pentagon
 port address  0xdd         	0xfb
 port mask	xx0xxx01	xxxxx0xx

 Kempston Joystick interface:
		Scorpion	Pentagon
 port address  0x1f		0x1f
 port mask	xx0xxx11	000xxxx1
*/

#define SCORP_LPR_0	0x22
#define SCORP_LPR_1	0x01
#define SCORP_KEMPST_0	0x20  /* #1F in basic */
#define SCORP_KEMPST_1	0x03
#define SCORP_TRKEMP_0	0x00  /* #FF in tr-dos */
#define SCORP_TRKEMP_1	0x83

#define PENT_LPR_0	0x04
#define PENT_LPR_1	0x00
#define PENT_KEMPST_0	0xe0
#define PENT_KEMPST_1	0x01


char _DSC[]="PC<->ZX Link";

#pragma pack(push, 1)

static const char *LptPortScope[] = {
	"LPT1", 
	"LPT2",
	"LPT3",
	"LPT4",
	"LPT5", 
	"LPT6",
	"LPT7",
	"LPT8"
};

struct CnTbl CfgPort = {
  	&LptPortNum,
	LptPortScope,
	MAX_LPT_PORTS
};


static const char *ModelScope[] = {
  	"Scorpion",
	"Pentagon"
};

struct CnTbl CfgModel = {
	&ModelType,
	ModelScope,
	sizeof(ModelScope)/sizeof(ModelScope[0])
};

static struct CfgS CfgTable[] = {
	{ TTbl, "PCLptPort=", &CfgPort },
	{ TTbl, "ZXLprintModel=", &CfgModel }
};

struct CfgDat _CFG = {
	CfgTable,
	sizeof(CfgTable)/sizeof(CfgTable[0])
};

#pragma pack(pop)
                

void _INS()
{
	if (LptPortNum<MAX_LPT_PORTS)
		LptBase=LptHwAddr[LptPortNum];
	else 
		LptBase=0;

}

          
void _INI(EmuData *emu_p, unsigned id)
{
int x;

 	TblData=emu_p;
	Id=id;

	for(x=0; x<MAX_LPT_PORTS; x++) {
		if (x<MAX_BIOS_LPT_PORTS) LptHwAddr[x]=*(ushort*)(0x408+x*sizeof(ushort));
			else LptHwAddr[x]=0;  // TODO get IO addr from OS
	}

	LptBase=0;
}

void _UNI()
{
	LptBase=0;
}


struct plink inputlink()
{
uchar p;
struct plink r;
 	if (LptBase) p=inp(LptBase+1);
		 else p=0;
	r.data=((p&PC_IN_DATA)!=0);
	r.strobe=((p&PC_IN_STROBE)!=0);
	return r;	
}

void outputlink(struct plink r)
{
uchar p;
	p=0;
	if (r.data) p|=PC_OUT_DATA;
	if (r.strobe) p|=PC_OUT_STROBE;
	if (LptBase) outp(LptBase, p);
}


int istrdos()
{
	return (((TblData->SpecROM)+0x8000)==(TblData->SpecSeg[0]));
}


uchar _INP(ushort port, uchar data)
{
struct plink p;

 	switch(ModelType) {

		case MdlScorpion:
			if (!istrdos()) {
				if ( (port&SCORP_KEMPST_0) 
					|| ((port&SCORP_KEMPST_1)!=SCORP_KEMPST_1) )
						return data;
			}
			else {
				if ( (port&SCORP_TRKEMP_0) 
					|| ((port&SCORP_TRKEMP_1)!=SCORP_TRKEMP_1) )
						return data;
			}
			break;

		case MdlPentagon:
			if ( (port&PENT_KEMPST_0) 
				|| ((port&PENT_KEMPST_1)!=PENT_KEMPST_1) )
					return data;
			if (istrdos()) return data;
			break;
	}

	p=inputlink();
	if (p.data) data|=ZX_IN_DATA;
		else data&=~ZX_IN_DATA;
	if (p.strobe) data|=ZX_IN_STROBE;
		else data&=~ZX_IN_STROBE;

	return data;
}


unsigned char _OUT(ushort port, uchar data)
{
struct plink p;

 	switch(ModelType) {

		case MdlScorpion:
 			if ( (port&SCORP_LPR_0)
				|| ((port&SCORP_LPR_1)!=SCORP_LPR_1) )
					return 0;
			break;
				
		case MdlPentagon:
			if ( (port&PENT_LPR_0)
				|| ((port&PENT_LPR_1)!=PENT_LPR_1) )
					return 0;
			break;
	}

	p.data=((data&ZX_OUT_DATA)!=0);
	p.strobe=((data&ZX_OUT_STROBE)!=0);
	outputlink(p);
	return 1;
}

void _SET()
{
void *w;
char tcfgport[256];
int x, y, ports;
int fakelpt[MAX_LPT_PORTS];

	w=TblData->WinCreate(16, 7, 50, 15, 0x1f);
	TblData->WinTitle(w, "PC<->ZX Link configuration", 0xf0);

	TblData->WinHelp(w, 52, 7, \
		"*MAS* ZX-Link emulation module\n" \
		"Version " VERSION \
		"\n\n(C) Kirill Frolov 500:812/1.507@zxnet");

	sprintf(tcfgport, "\001PC Printer port:\n");
	ports=0; y=0;
	for(x=0; x<MAX_LPT_PORTS; x++) {
	 	if (LptHwAddr[x]) {
			fakelpt[ports]=x;
			if (x==*CfgPort.Dst) y=ports;
			ports++;
			sprintf(tcfgport+strlen(tcfgport), "LPT%d (addr 0x%4.4hx)\n", x+1, LptHwAddr[x]);
		}
	}

	if (!ports) {
		TblData->WinText(w, 2, 2, \
			"You have no one parallel port\n" \
			"installed in your PC,\n" \
			"so virtual PC<->ZX Link interface\n" \
			"will be disabled");
		TblData->SetButton(w, 2, 12, "\001Ok", 12, 0);
		TblData->WinExe(w);
		LptBase=0;
	}
	else {
		*CfgPort.Dst=y;
		CfgPort.ValN=ports;
		TblData->SetRadio(w, 2, 2, tcfgport, &CfgPort);

		TblData->SetRadio(w, 25, 2, \
			"\001ZX Printer port:\n" \
			"Scorpion (addr #DD)\n" \
			"Pentagon (addr #FB)\n", \
				&CfgModel);

		TblData->SetButton(w, 2, 12, "\001Ok", 12, 1);
		TblData->SetButton(w, 16, 12, "\001Cancel", 12, 0);

		if (TblData->WinExe(w)==1) {
			TblData->WinResult(w);
                        *CfgPort.Dst=fakelpt[*CfgPort.Dst];
		}
		CfgPort.ValN=MAX_LPT_PORTS;

	}

	TblData->WinRemove(w);
}

