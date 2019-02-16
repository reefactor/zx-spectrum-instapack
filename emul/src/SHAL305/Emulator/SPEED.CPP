/**************************************************************************

Настройка на быстродействие

**************************************************************************/

//#include <iostream.h>///
#include <mem.h>
#include "emudata.h"
#include "main.hpp"

unsigned SlowData=0;
unsigned SlowDataCanc=0;
unsigned SlowDataTR=0;
unsigned SlowVPix=0;
unsigned SlowVAttr=0;

static unsigned SpdMain=0;
static unsigned SpdVPix=0;
static unsigned SpdVAttr=0;

unsigned Speed=0x0;
unsigned SpeedMaxTR=0x0;

unsigned SpeedTable[5][3]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

unsigned char SpeedTestDetect=0x00;

static const unsigned char SpeedProc[]={
	0x3E,0x00,		//		LD A,0x00
	0x01,0x00,0x00,//		LD BC,0x0000
	0x57,				//		LD D,A
	0x5F,				//		LD E,A
	0x02,				// CICLE: LD [BC],A
	0x37,				//		SCF
	0x2A,0x00,0x60,//		LD HL,[0x6000]
	0xED,0x5A,		//		ADC HL,DE
	0x22,0x00,0x60,//		LD [0x6000],HL
	0x2A,0x02,0x60,//		LD HL,[0x6002]
	0xED,0x5A,		//		ADC HL,DE
	0x22,0x02,0x60,//		LD [0x6002],HL
	0x0C,				//		INC C
	0x18,0xEB		//		JR CICLE
};

static const unsigned TblSpeed[]={0xFB,0xFFFFFFFF,0x11A,0xDB};

// Тестирование быстродействия при обращении по определенному адресу
static unsigned SpeedTestAdr(unsigned Adr) {
	*(word*)(SpecRAM+0x16007)=Adr;
	*(dword*)(SpecRAM+0x16000)=0x0;
	EmuTable.DataCPU.RegPC=0x6004;
	Pause(1);
	*PntIntDetect=0x0;
	MainCPU();
	return *(dword*)(SpecRAM+0x16000);
}

unsigned SpeedCalcPix(unsigned);
#pragma aux SpeedCalcPix=\
	"	mov edi,OFFSET TblSpeed"\
	"	mov eax,0xC51F0000"\
	"	mul dword [edi+ecx*4]"\
	"	div [edi]"\
	"	mul SpdMain"\
	"	mov ebx,edx"\
	"	sub edx,SpdVPix"\
	"	ja NumOk"\
	"	sub edx,edx"\
	"NumOk:"\
	"	sub eax,eax"\
	"	div ebx"\
	"	mov edx,0x0000010C"\
	"	mul edx"\
	"	add edx,0x00000010"\
	parm [ecx] value [edx] modify [eax ebx edx edi]

unsigned SpeedCalcAttr(unsigned);
#pragma aux SpeedCalcAttr=\
	"	mov edi,OFFSET TblSpeed"\
	"	mov eax,0x80000000"\
	"	mul dword [edi+ecx*4]"\
	"	div [edi]"\
	"	mul SpdMain"\
	"	mov ebx,edx"\
	"	sub edx,SpdVAttr"\
	"	ja NumOk"\
	"	sub edx,edx"\
	"NumOk:"\
	"	sub eax,eax"\
	"	div ebx"\
	"	mov edx,0x00000244"\
	"	mul edx"\
	"	add edx,0x00000012"\
	parm [ecx] value [edx] modify [eax ebx edx edi]

// Тестирование быстродействия
void SpeedTest() {
	SpeedTestDetect=0x01;
	memcpy(SpecRAM+0x16004,SpeedProc,sizeof(SpeedProc));
	ExitIfInt=0x01;
	unsigned SrcTemp=IntSource;
	IntSource=0x00;
	unsigned IntTemp=*PntIntDetect;
	unsigned char TraceTemp=EmuTable.Trace;
	EmuTable.Trace=0;
	SpdMain=SpeedTestAdr(0x5B00);
	SpdVPix=SpeedTestAdr(0x4000);
	SpdVAttr=SpeedTestAdr(0x5800);
	EmuTable.Trace=TraceTemp;
	*PntIntDetect=IntTemp;
	IntSource=SrcTemp;
	ExitIfInt=0x00;
	memset(SpecRAM+0x14000,0,0x4000);
	EmuTable.DataCPU.RegPC=0x0000;
	if (!SpdMain) return;
	for (int i=0;i<4;i++) if (i!=1) {
		int SlowTest=(SpdMain<<2)/TblSpeed[i]-0x1F;
		SpeedTable[i][0]=(SlowTest>=0)?SlowTest:0x0;
		SpeedTable[i][1]=SpeedCalcPix(i);
		SpeedTable[i][2]=SpeedCalcAttr(i);
	}
}

void SpeedSet() {
	SlowData=SpeedTable[Speed][0];
	SlowVPix=SpeedTable[Speed][1];
	SlowVAttr=SpeedTable[Speed][2];
	SlowDataCanc=0x0;
	SlowDataTR=(SpeedMaxTR)?0x0:SlowData;
}
