/**************************************************************************

Дисковые утилиты

**************************************************************************/

#include <mem.h>
#include "main.hpp"
#include "file.hpp"
#include "diskutil.hpp"
#include "interfac.hpp"
#include "mouse.hpp"

// Номер дисковода для дисковых утилит
unsigned Drive=0x0;

// Имя файла образа диска для копирования
char FileNameCopy[FileLen]="SPECTRUM.TRD";

// Форматирование
unsigned Format=0x01;

// Операция: 0 - Disk to file; 1 - File to disk.
static unsigned char Op;

// Данные блока памяти для дисковых утилит
static struct MemBl DskUtil;

// Тип дисководов: 093h - 720k, 053h - 1.2M и выше
unsigned char FloppyDriveTyp[2];

// Данные для команды форматирования
static char FormatData[]={
	0,0,1,1,0,0,2,1,0,0,3,1,0,0,4,1,0,0,5,1,0,0,6,1,0,0,7,1,0,0,8,1,0,
	0,9,1,0,0,10,1,0,0,11,1,0,0,12,1,0,0,13,1,0,0,14,1,0,0,15,1,0,0,16,1
};

unsigned Track;

static FILE *Str;

void DiskDataOutC(unsigned char);
#pragma aux DiskDataOutC=\
	"	call DiskDataOut"\
	parm [ah] modify [eax]

void ProgDMA(void*);
#pragma aux ProgDMA=\
	"	cli"\
	"	mov al,006h"\
	"	out 00Ah,al"\
	"	mov al,046h"\
	"	cmp Op,000h"\
	"	jz OperOk"\
	"	mov al,04Ah"\
	"OperOk:"\
	"	out 00Ch,al"\
	"	out 00Bh,al"\
	"	pop eax"\
	"	add eax,01000h"\
	"	out 004h,al"\
	"	shr eax,08h"\
	"	out 004h,al"\
	"	mov al,ah"\
	"	out 081h,al"\
	"	mov al,0FFh"\
	"	out 005h,al"\
	"	mov al,00Fh"\
	"	out 005h,al"\
	"	mov al,002h"\
	"	out 00Ah,al"\
	"	sti"\
	parm [] modify [eax]

int CopyProg() {
	if (Op) if (!fread(DskUtil.Adr,0x2000,1,Str)) {
		MouseOff();
		MessageBox(0x4F,TxtErFRead,FileNameCopy);
		MouseOn();
		return 1;
	}
	unsigned char InB;
	Start:
	if (Op&Format) {
		for (int i=0;i<0x10;i++) *((char*)DskUtil.Adr+0x2000+i*4)=Track;
		ri.es=DskUtil.Seg;
		ri.ebx=0x2000;
		ri.edx=Drive;
		ri.c.h=Track;
		ri.a.h=0x05;
		if (IntFloppyDisk()) goto Error;
	}
	ri.es=DskUtil.Seg;
	ri.ebx=0;
	ri.edx=Drive;
	ri.c.l=0x01;
	ri.c.h=Track;
	ri.eax=0x0210;
	if (Op) ri.a.h=0x03;
	if (IntFloppyDisk()) goto Error;
	if (Op&Format) {
		ri.es=DskUtil.Seg;
		ri.ebx=0x2000;
		ri.d.l=Drive;
		ri.d.h=0x01;
		ri.c.h=Track;
		ri.a.h=0x05;
		if (IntFloppyDisk()) goto Error;
	}
	ProgDMA(DskUtil.Adr);
	{unsigned char Command=0x66;
	if (Op) Command=0x65;
	DiskDataOutC(Command);}///45,46
	DiskDataOutC(Drive|0x04);
	DiskDataOutC(Track);
	DiskDataOutC(0x00);
	DiskDataOutC(0x01);
	DiskDataOutC(0x01);
	DiskDataOutC(0x10);
	DiskDataOutC(0x2A);
	DiskDataOutC(0xFF);
	if (DiskIntWait()) goto Error;
	InB=DiskDataIn();
	{for (int i=6;i;i--) DiskDataIn();}
	if (InB&0xD8) {
		Error:
		int Code;
		MouseOff();
		{Win WE(20,54,10,7,0x4F);
		WE.TxtOut(21,2,TxtErDisk);
		ObjButton(&WE,36,4,14,TxtIgnore,2);
		ObjButton(&WE,20,4,14,TxtAbort,1);
		ObjButton(&WE,4,4,14,TxtRetry,3);
		Code=WE.Exe();}
		MouseOn();
		switch (Code) {
		 case 0:
			return 1;
		 case 2:
			DiskInit();
			goto Start;
		}
		DiskInit();
	}
	if (!Op) if (!fwrite(DskUtil.Adr,0x2000,1,Str)) {
		MouseOff();
		MessageBox(0x4F,TxtErFSave,FileNameCopy);
		MouseOn();
		return 1;
	}
	Track++;
	MouseOff();
	ProgressView();
	MouseOn();
	if (Track==0x50) {
		MouseOff();
		MessageBox(0x1F,TxtOpSuc);
		MouseOn();
		return 1;
	}
	return 0;
}

void DskUtilDiskToFile() {
	Op=0;
	Win W(11,56,7,8);
	W.SetTitle(TxtUtilDiskToFile);
	ObjButton BECanc(&W,22,5,12,ButtCanc,1);
	W.SetProg(&CopyProg);
	Track=0;
	ProgressView();
	if (!(Str=fopen(FileNameCopy,wb))) {
		MessageBox(0x4F,TxtErFOpen,FileNameCopy);
		return;
	}
	DskUtil.Alloc(0x200);
	DiskInit();
	W.Exe();
	fclose(Str);
	DskUtil.Free();
}

void DskUtilFileToDisk() {
	Op=1;
	Win W(11,56,7,8);
	W.SetTitle(TxtUtilFileToDisk);
	ObjButton BECanc(&W,22,5,12,ButtCanc,1);
	W.SetProg(&CopyProg);
	Track=0;
	ProgressView();
	if (!(Str=fopen(FileNameCopy,rb))) {
		MessageBox(0x4F,TxtErFOpen,FileNameCopy);
		return;
	}
	DskUtil.Alloc(0x200+sizeof(FormatData)/0x10);
	memcpy(DskUtil.Adr+0x2000,FormatData,sizeof(FormatData));
	DiskInit();
	W.Exe();
	fclose(Str);
	DskUtil.Free();
}
