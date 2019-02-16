
#include <mem.h>
#include <stdio.h>
#include "file.hpp"
#include "main.hpp"
#include "ver.hpp"
#include "text.hpp"
#include "interfac.hpp"
#include "messages.hpp"
#include "addition.hpp"
#include "emudata.h"

Proc *PrFirst[P_Num],*PrLast[P_Num];

Proc::Proc(void *Adr,unsigned Num,Add *AddPnt) {
	Pr=Adr;
	NumP=Num;
	AddP=AddPnt;
	Prev=PrLast[Num];
	Next=0;
	PrLast[Num]=this;
	if (Prev) Prev->Next=this;
	else PrFirst[Num]=this;
}

Proc::~Proc() {
	if (Prev) Prev->Next=Next;
	else PrFirst[NumP]=Next;
	if (Next) Next->Prev=Prev;
	else PrLast[NumP]=Prev;
}

struct AddHeader AddH;

class Add *AddFirst=0,*AddLast=0;

Add::Add(const char *FileName) {
	TextCopy(Name,FileName,sizeof Name);
	Prev=AddLast;
	Next=0;
	AddLast=this;
	if (Prev) Prev->Next=this;
	else AddFirst=this;
	for (unsigned i=0;i<P_Num;i++) PrLoc[i]=0;
	Trace=0;
}

Add::~Add() {
	TraceOff((unsigned)this);
	if (Prev) Prev->Next=Next;
	else AddFirst=Next;
	if (Next) Next->Prev=Prev;
	else AddLast=Prev;
	if (PrLoc[P_UNI]) ((void(__pragma("Progs")*)())PrLoc[P_UNI]->Pr)();
	for (int i=0;i<P_Num;i++) if (PrLoc[i]) delete PrLoc[i];
	delete[] DataPnt;
}

Add *NewAdd(const char *Name) {
	if (ChDir(AddPth)) MessageBox(0x4F,TxtErPth,AddPth);
	Add *Pnt=new Add(Name);
	const char *Txt=Pnt->LoadAdd();
	ChDir(StPth);
	if (Txt) {
		MessageBox(0x4F,Txt,Pnt->Name);
		delete Pnt;
		return 0;
	}
	if (Pnt->PrLoc[P_INI])
		((void(__pragma("ProgIni")*)(EmuData*,unsigned))Pnt->
			PrLoc[P_INI]->Pr)(&EmuTable,(unsigned)Pnt);
	return Pnt;
}

/* Загрузка дополнительного модуля */
// Выход: 0 - успешное завершение
//			 1 - ошибка
const char *Add::LoadAdd() {
// Открытие файла
	FILE *Str;
	if (!(Str=fopen(Name,rb))) return TxtErFOpen;

// Загрузка заголовка файла
	if (FileLoad(&AddH,Name,sizeof(AddHeader),Str)) return TxtErFRead;

// Проверка сигнатуры "Add"
	if ((*(dword*)AddH.Signature&0xFFFFFF)!=0x646441) {
		fclose(Str);
		return TxtErNotCorF;
	}

// Проверка версии
	if (AddH.Version>0x00) {
		fclose(Str);
		return TxtErBadVer;
	}

// Выделение памяти для блока
	if (!(DataPnt=new byte[AddH.DataAll])) {
		fclose(Str);
		return TxtErNoMem;
	}

// Освобождение памяти
	memset(DataPnt,0,AddH.DataAll);

// Загрузка данных
	fseek(Str,AddH.DataOffs,SEEK_SET);
	if (FileLoad(DataPnt,Name,AddH.DataLen,Str)) return TxtErFRead;

// Выделение памяти для Fixup
	dword *FixPnt;
	if (!(FixPnt=new dword[AddH.FixNum])) {
		fclose(Str);
		return TxtErNoMem;
	}

// Загрузка Fixup
	fseek(Str,AddH.FixOffs,SEEK_SET);
	if (FileLoad(FixPnt,Name,AddH.FixNum*sizeof(dword),Str)) return TxtErFRead;///

// Настройка адресов
	for (int i=0;i<AddH.FixNum;i++)
		*(dword*)(DataPnt+FixPnt[i])+=(dword)DataPnt;

// Освобождение памяти, занятой Fixup
	delete[] FixPnt;

// Загрузка таблицы точек входа
	dword PrBuf[P_Num];
	fseek(Str,AddH.ProcOffs,SEEK_SET);
	if (FileLoad(PrBuf,Name,AddH.FixOffs-AddH.ProcOffs,Str)) return TxtErFRead;

// Установка адресов идентификаторов
	unsigned PCount=0;
	for (int j=0;j<P_Num;j++) if (AddH.Mask&(1<<j))
		PrLoc[j]=new Proc(DataPnt+PrBuf[PCount++],j,this);

// Закрытие файла
	fclose(Str);

// Установка состояния и выход (успешное завершение)
	return 0;
}

void CallAddition(Proc *Pnt) {
	if (!Pnt) return;
	do ((void(__pragma("Progs")*)())Pnt->Pr)();
	while (Pnt=Pnt->Next);
}
