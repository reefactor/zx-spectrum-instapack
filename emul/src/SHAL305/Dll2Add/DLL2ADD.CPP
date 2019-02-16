
typedef unsigned long dword;
typedef unsigned short word;
typedef unsigned char byte;

const FileLen=0x40;

#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream.h>
#include "ver.hpp"
#include "addition.hpp"

// Определения для работы с файлами
const char rb[]="rb";
const char wb[]="wb";

const char AddExt[]=".ADD";
const char DllExt[]=".DLL";

char FileNameDll[FileLen];
char FileNameAdd[FileLen];

char TxtNul[]="";

#ifdef Rus

const char TxtTitle[]="\nКонвертор модулей для Эмулятора ZX-Spectrum  "
		Ver "\n(c) 1997-1999 Николай Шалаев\n\n";
const char TxtHelp[]="Использование: DLL2ADD <DLL> [<ADD>]\n"
		" DLL - имя файла DOS/4G Dynamic Link Library\n"
		" ADD - имя файла модуля к эмулятору\n"
		"Пример: DLL2ADD ADDITION.DLL ADDITION.ADD\n";
const char TxtRead[]="Чтение файла: ";
const char TxtWrite[]="Запись файла: ";
const char TxtErOpen[]="Ошибка при открытии файла: ";
const char TxtErRead[]="Ошибка при чтении файла: ";
const char TxtErWrite[]="Ошибка при записи файла: ";
const char TxtErMem[]="Недостаточно памяти";
const char TxtErFix[]="Недопустимый тип настройки адреса";
const char TxtErFixFlag[]="Недопустимый флаг настройки адреса";
const char TxtErNotExe[]="Файл не DOS/4G DLL";
const char TxtErEntryPass[]="Неподдерживаемый тип идентификатора";
const char TxtErEntryCorr[]="Некорректный тип идентификатора: ";
const char TxtFoundIdent[]="Найден идентификатор: ";
const char TxtOffset[]="  Смещение: ";

#else

const char TxtTitle[]="\nConverter of modules for ZX-Spectrum Emulator  "
		Ver "\n(c) 1997-1999 Nikolay Shalaev\n\n";
const char TxtHelp[]="Usage: DLL2ADD <DLL> [<ADD>]\n"
		" DLL - filename of DOS/4G Dynamic Link Library\n"
		" ADD - filename of module for emulator\n"
		"Example: DLL2ADD ADDITION.DLL ADDITION.ADD\n";
const char TxtRead[]="Reading file: ";
const char TxtWrite[]="Writing file: ";
const char TxtErOpen[]="Can't open file: ";
const char TxtErRead[]="Can't read file: ";
const char TxtErWrite[]="Can't write file: ";
const char TxtErMem[]="Not enough memory";
const char TxtErFix[]="Bad fixup type";
const char TxtErFixFlag[]="Bad fixup flag";
const char TxtErNotExe[]="File is not DOS/4G DLL";
const char TxtErEntryPass[]="Not supported identificator type";
const char TxtErEntryCorr[]="Not correct identificator type: ";
const char TxtFoundIdent[]="Found identificator: ";
const char TxtOffset[]="  Offset: ";

#endif

struct ProcAdd {
	union {char Name[5];dword NameA;};
	dword AdrProc;
	unsigned char Present;
} ProcA[]={
	"_DSC",0,0,
	"_CFG",0,0,
	"_SET",0,0,
	"_INI",0,0,
	"_UNI",0,0,
	"_ON_",0,0,
	"_OFF",0,0,
	"_RES",0,0,
	"_CPU",0,0,
	"_INT",0,0,
	"_ITP",0,0,
	"_IN_",0,0,
	"_INP",0,0,
	"_OUT",0,0,
	"_OUP",0,0,
	"_MEM",0,0,
	"_AY_",0,0,
	"_VG_",0,0,
	"_VGP",0,0,
	"_F7_",0,0,
	"_F8_",0,0,
	"_F9_",0,0,
	"_F10",0,0,
	"_F11",0,0,
	"_F12",0,0,
	"_INS",0,0,
};

const NumProc=sizeof(ProcA)/sizeof(ProcAdd);

struct AddHeader AddH={{'A','d','d',},0,};

struct Obj {
	unsigned StDll;
	unsigned SzDll;
	unsigned StAdd;
	unsigned SzAdd;
};

struct FixS {
	dword Offs;
	FixS *Next;
} *FixFirst=(FixS*)0, *FixPoint=(FixS*)0;

FILE *Str;

void Fatal(const char *Txt0,const char *Txt1=TxtNul) {
	cout<<Txt0<<Txt1<<'\n';
	exit(1);
}

void AddWrite(void *Buf,unsigned Len) {
	if (!fwrite(Buf,Len,1,Str)) {
		fclose(Str);
		Fatal(TxtErWrite,FileNameAdd);
	}
}

void TxtCopy(char *Src,char *Dest,int Max,const char *Add) {
	unsigned char R=0;
	while (Max&&(*Dest=*Src++)) {
		if (*Dest=='\\') R=0;
		if (*Dest=='.') R=1;
		Dest++;
		Max--;
	}
	if (!R) while (Max--&&(*Dest++=*Add++));
}

inline void TxtCopyE(char *Src,char *Dest,int Max,const char *Add) {
	unsigned char R=0;
	while (Max&&(*Dest=*Src++)) {
		if (*Dest=='\\') R=0;
		if (*Dest=='.') R=1;
		Dest++;
		Max--;
	}
	if (R) while (*Dest!='.') Dest--;
	while (Max--&&(*Dest++=*Add++));
}

void main(int argc,char *argv[]) {
	cout<<TxtTitle;
	switch (argc) {
	 case 3:
		TxtCopy(argv[2],FileNameAdd,FileLen,AddExt);
		break;
	 case 2:
		TxtCopyE(argv[1],FileNameAdd,FileLen,AddExt);
		break;
	 default:
		cout<<TxtHelp;
		return;
	}
	TxtCopy(argv[1],FileNameDll,FileLen,DllExt);
	struct find_t FindT;
	if (_dos_findfirst(FileNameDll,_A_NORMAL,&FindT))
		Fatal(TxtErOpen,FileNameDll);
	if (!(Str=fopen(FileNameDll,rb))) Fatal(TxtErOpen,FileNameDll);
	unsigned long LenDll=FindT.size;
	byte *BufDll=new byte[LenDll];
	if (!BufDll) Fatal(TxtErMem);
	cout<<TxtRead<<FileNameDll<<'\n';
	if (!fread(BufDll,LenDll,1,Str)) {
		fclose(Str);
		Fatal(TxtErRead,FileNameDll);
	}
	fclose(Str);
	if (*(word*)BufDll!=0x5A4D) Fatal(TxtErNotExe);
	byte *LE=BufDll+*(dword*)(BufDll+0x3C);		///////
	if (*(word*)(LE)!=0x454C) Fatal(TxtErNotExe);
	dword DatOff=*(dword*)(LE+0x80);

// Создание таблиц начал объектов и страниц
	dword PageSize=*(dword*)(LE+0x28);
	dword PageNum=*(dword*)(LE+0x14);
	dword ObjNum=*(dword*)(LE+0x44);
	dword ObjOff=*(dword*)(LE+0x40);
	dword *PageStAdd=new dword[PageNum];
	Obj *ObjP=new Obj[ObjNum];
	ObjP[0].StAdd=ObjP[0].StDll=0;
	for (int d=0;d<ObjNum;d++) {
		ObjP[d].SzAdd=((*(dword*)(LE+ObjOff+(d)*0x18))+0x3)&(0x3^-1);
		ObjP[d].SzDll=(ObjP[d].SzAdd+PageSize-1)&((PageSize-1)^-1);
		if (d) {
			ObjP[d].StDll=ObjP[d-1].StDll+ObjP[d-1].SzDll;
			ObjP[d].StAdd=ObjP[d-1].StAdd+ObjP[d-1].SzAdd;
		}
		for (int h=0;h<ObjP[d].SzDll/PageSize;h++)
			PageStAdd[ObjP[d].StDll/PageSize+h]=ObjP[d].StAdd+PageSize*h;
	}

// Создание таблицы идентификаторов
	byte *Names=LE+*(dword*)(LE+0x58);
	unsigned NumProcReal=0;
	while (*Names) {
		if (*Names==4) {
			byte *Entry=LE+*(dword*)(LE+0x5C);
			dword TxtTmp=*(dword*)(Names+1);
			for (int i=0;i<NumProc;i++) if (TxtTmp==ProcA[i].NameA) {
				AddH.Mask|=1<<i;
				NumProcReal++;
				unsigned IdNo=*(word*)(Names+5);
				while (IdNo>*Entry) {
					IdNo-=*Entry;
					switch (*(Entry+1)) {
					 case 0x00:
						Entry+=2;
						break;
					 case 0x01:
						Entry+=*Entry*3+4;
						break;
					 case 0x02:
					 case 0x03:
						Entry+=*Entry*5+4;
						break;
					 case 0x04:
						Entry+=*Entry*7+4;
						break;
					 default:
						Fatal(TxtErEntryPass);
					}
				}
				if (*(Entry+1)!=0x03) Fatal(TxtErEntryCorr,ProcA[i].Name);
				ProcA[i].AdrProc=
					*(dword*)(Entry+IdNo*5)+ObjP[*(word*)(Entry+2)-1].StAdd;
				cout<<TxtFoundIdent<<ProcA[i].Name<<TxtOffset
						<<ProcA[i].AdrProc<<'\n';
				break;
			}
		}
		Names+=((unsigned)*Names)+3;
	}

// Создание списка Fixup
	dword *FixPage=(dword*)(LE+*(dword*)(LE+0x68));	////If == 0
	byte *FixRec=(byte*)(LE+*(dword*)(LE+0x6C));
	for (int j=0;j<PageNum;j++) {
		dword FixB=FixPage[j];
		dword FixE=FixPage[j+1];
		while (FixB<FixE) {
			unsigned AddNext=7;
			if (FixRec[FixB]!=0x07) Fatal(TxtErFix);
			if (FixRec[FixB+1]&0xEF!=0x00) Fatal(TxtErFixFlag);
			if (FixRec[FixB+1]==0x10) AddNext=9;
			FixS *FixTmp=new FixS;
			if (FixPoint) FixPoint->Next=FixTmp;
			else FixFirst=FixTmp;
			FixPoint=FixTmp;
			int ObjOffs=*(short*)(FixRec+FixB+2);
			FixPoint->Offs=PageStAdd[j]+ObjOffs;
			*(dword*)(BufDll+DatOff+j*PageSize+ObjOffs)+=ObjP[FixRec[FixB+4]-1].StAdd;////
			FixPoint->Next=(FixS*)0;
			FixB+=AddNext;
			AddH.FixNum++;
		}
	}

	for (int b=0;b<ObjNum;b++) AddH.DataAll+=ObjP[b].SzAdd;
	AddH.ProcOffs=sizeof(AddHeader);
	AddH.FixOffs=AddH.ProcOffs+NumProcReal*4;
	AddH.DataOffs=AddH.FixOffs+AddH.FixNum*4;
	if (!(Str=fopen(FileNameAdd,wb))) Fatal(TxtErOpen,FileNameAdd);
	cout<<TxtWrite<<FileNameAdd<<'\n';
	unsigned DataLen=PageSize*(PageNum-1)+*(dword*)(LE+0x2C);
	AddH.DataLen=0;
	for (int x=0;x<ObjNum;x++) if (ObjP[x].StDll<DataLen) {
		unsigned Size=ObjP[x].SzAdd;
		if (DataLen-ObjP[x].StDll<ObjP[x].SzAdd) Size=DataLen-ObjP[x].StDll;
		AddH.DataLen+=Size;
	}
	AddWrite(&AddH,sizeof AddH);
	for (int a=0;a<NumProc;a++)
		if (AddH.Mask&(1<<a)) AddWrite(&ProcA[a].AdrProc,4);
	FixS *FixTmp=FixFirst;
	while (FixTmp) {
		AddWrite(&FixTmp->Offs,4);
		FixTmp=FixTmp->Next;
	}

	for (int z=0;z<ObjNum;z++) if (ObjP[z].StDll<DataLen) {
		unsigned Size=ObjP[z].SzAdd;
		if (DataLen-ObjP[z].StDll<ObjP[z].SzAdd) Size=DataLen-ObjP[z].StDll;
		AddWrite(BufDll+DatOff+ObjP[z].StDll,Size);
	}

	fclose(Str);

	delete[] ObjP;
	delete[] PageStAdd;
	delete[] BufDll;
}
