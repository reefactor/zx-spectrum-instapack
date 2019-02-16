/**************************************************************************

Interface

**************************************************************************/

#include <dos.h>
#include "messages.hpp"
#include "config.hpp"
#include "addition.hpp"
#include "emudata.h"

#ifndef INTERFAC_INCLUDED
#define INTERFAC_INCLUDED

struct FLst {
	char Name[0xE];
	unsigned char Typ;
	FLst *Next;
};

class Win;

class Obj {
 private:
	Obj *Prev,*Next;
 protected:
	int PosX,PosY,LimL,LimR,LimU,LimD,LenX,LenY;
	unsigned char *Vid;
	Win *WinP;
	unsigned char Ac;
	void ReadHotKey();
	void SetHotKey();
 public:
	static unsigned char Insert;
	unsigned char HKey,*HKeyP;
	Obj(Win*,int,int,int,int);
	Obj *GetPrev() {return Prev;};
	Obj *GetNext() {return Next;};
	void TurnPrev();
	void TurnNext();
	int ObjPlace(int X,int Y) {return X>=LimL&&X<LimR&&Y>=LimU&&Y<LimD;};
	virtual int Key(unsigned)=0;
	virtual int MouseDown(int,int)=0;
	virtual void Active() {
		Ac=1;
		Refresh();
	};
	virtual void DeActive() {
		Ac=0;
		Refresh();
	};
	virtual int HotKey() {return 0;};///////
	virtual void SetResult()=0;
	virtual void Refresh()=0;
};

class ObjButton:public Obj {
 private:
	int Id;
 public:
	ObjButton(Win*,int,int,int,char*,int);
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult() {};
	void Refresh();
	int HotKey();
};

class ObjCheckBox:public Obj {
 private:
	unsigned Dat,*DatL;
 public:
	ObjCheckBox(Win*,int,int,char*,unsigned*);
	void Refresh();
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult();
	int HotKey();
};

class ObjRadio:public Obj {
 private:
	unsigned Dat,*DatL;
 public:
	ObjRadio(Win*,int,int,char*,CnTbl*);
	void Refresh();
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult();
	int HotKey();
};

class ObjInputTxt:public Obj {
 private:
	int EdPos,VwPos,EdLen;
	char *TxtRes;
 public:
	char *Ed;
	ObjInputTxt(Win*,int,int,int,char*,CnTxt*);
	~ObjInputTxt();
	int Key(unsigned);
	int MouseDown(int,int);
	void Active();
	void SetResult();
	void Refresh();
	void FileBox(char*,char*);
};

const unsigned NumL=5;

class ObjInputNum:public Obj {
 private:
	unsigned *Res;
	char Ed[NumL+1];
	unsigned EdPos,Min,Max;
	void TestLimit();
	void NumUp();
	void NumDown();
 public:
	ObjInputNum(Win*,int,int,char*,CnNum*);
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult();
	void Refresh();
	void Active();
	void DeActive();
};

class ObjFListBox:public Obj {
 private:
	FLst **FPnt;
	int Num,CurPos,VwPos,VwNum;
	char Ed[0x40],BegPath[0x40];
	char *Res,*Msk;
 public:
	ObjFListBox(Win*,int,int,int,char*,char*);
	~ObjFListBox();
	void Refresh();
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult();
	void AddFList(FLst*&,find_t&,unsigned char);
	void CreateFList(char*);
	void DeleteFList();
	void Select();
};

class ObjAListBox:public Obj {
 private:
	Add **APnt;
	int Num,CurPos,VwPos;
	char Ed[0x40],BegPath[0x40];
	char *Res,*Msk;
 public:
	ObjAListBox(Win*,int,int);
	~ObjAListBox() {DeleteAList();};
	void Refresh();
	int Key(unsigned);
	int MouseDown(int,int);
	void SetResult() {};
	void CreateAList();
	void DeleteAList() {if (APnt) delete[] APnt;};
	Add *Sel() {return APnt[CurPos];};
};

class Win {
 private:
	int LimL,LimR,LimU,LimD,LenX;
	unsigned char *Vid;
	void *KeepArea;
	int HdX,HdY;
	char *HlpTxt;
	inline void Hlp();
	void Help();
	int (*Prog)();
 public:
	Obj *ObjPoint,*ObjActive;
	Win(int,int,int,int,unsigned char=0x1F);
	~Win();
	void SetTitle(char*,unsigned char=0xF0);
	void SetHelp(int,int,char*);
	void SetProg(int(*)());
	void LineOut(int,int,char*,int,unsigned char);
	void TxtOut(int,int,char*);
	void PrintNum(int,int,unsigned);
	int AbsX(int X) {return LimL+X;};
	int AbsY(int Y) {return LimU+Y;};
	int dX() {return LenX;};
	int Exe();
	void SetResult();
};

// Установка курсора
void SetCursor(int,int);
// Выключение курсора
void CursorOff();
// Очистка экрана
extern void ScreenClear();
// Заполнение экрана
extern "C" void ScreenFill();
// Сохранение экрана
extern void *ScrSave();
// Восстановление экрана
extern void ScrLoad(void*);

// Сообщение
extern "C" void __pragma("MesBox") MessageBox(const unsigned char,const char*,const char* =TxtNul);

// Изменение текущей директории
extern "C" int ChDir(char*);
// Получение текущей директории
extern "C" void GetDir(char*);

void NumToStr(int Num,char *Txt);

int StrToNum(char *Txt);

extern void* __pragma("WinCreate") WinCreate(int X,int Y,int dX,int dY,unsigned char C=0x1F);
extern void __pragma("WinRemove") WinRemove(void *Pnt);
extern void __pragma("WinTitle") WinTitle(void *Pnt,char *Txt,unsigned char C=0xF0);
extern void __pragma("WinHelp") WinHelp(void *Pnt,int dX,int dY,char *Txt);
extern void __pragma("WinText") WinText(void *Pnt,int X,int Y,char *Txt);
extern int __pragma("WinExe") WinExe(void *Pnt);
extern void __pragma("WinResult") WinResult(void *Pnt);
extern void __pragma("SetButton") *SetButton(void *Pnt,int X,int Y,char *Txt,int dX,int Id);
extern void __pragma("SetCheckBox") *SetCheckBox(void *Pnt,int X,int Y,char *Txt,unsigned *Dst);
extern void __pragma("SetRadio") *SetRadio(void *Pnt,int X,int Y,char *Txt,CnTbl *Dst);
extern void __pragma("SetInputTxt") *SetInputTxt(void *Pnt,int X,int Y,int dX,char *Txt,CnTxt *Dst);
extern void __pragma("SetInputNum") *SetInputNum(void *Pnt,int X,int Y,char *Txt,CnNum *Dst);
extern void __pragma("FileBox") FileBox(void*,char*,char*);

#endif
