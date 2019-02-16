/**************************************************************************

Interface

**************************************************************************/

//#include <iostream.h>///
#include <mem.h>
#include "main.hpp"
#include "text.hpp"
#include "interfac.hpp"
#include "mouse.hpp"

unsigned char Obj::Insert=0x00;

unsigned char DKey=0x00;

static unsigned char WinHKey=0x00,*WinHKeyP=0x00;

void WinSet(int Color,byte *Adr,int XLen,int dXLen,int YLen);
#pragma aux WinSet=\
	"	cld"\
	"	mov ah,al"\
	"	mov al,'╔'"\
	"	stosw"\
	"	mov ecx,edx"\
	"	mov al,'═'"\
	"	rep stosw"\
	"	mov al,'╗'"\
	"	stosw"\
	"	add edi,ebx"\
	"	mov al,'║'"\
	"Cicle:"\
	"	stosw"\
	"	mov ecx,edx"\
	"	mov al,' '"\
	"	rep stosw"\
	"	mov al,'║'"\
	"	stosw"\
	"	mov BYTE [edi+1],001"\
	"	mov BYTE [edi+3],001"\
	"	add edi,ebx"\
	"	dec esi"\
	"	jnz Cicle"\
	"	mov al,'╚'"\
	"	stosw"\
	"	mov ecx,edx"\
	"	mov al,'═'"\
	"	rep stosw"\
	"	mov al,'╝'"\
	"	stosw"\
	"	mov al,001h"\
	"	mov [edi+1],al"\
	"	mov [edi+3],al"\
	"	lea edi,[edi+ebx+5]"\
	"	lea ecx,[edx+2]"\
	"CicleShadow:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"	loop CicleShadow"\
	parm [eax][edi][edx][ebx][esi] modify [eax ecx esi edi]

void SetLine(void *Adr,int Len,unsigned char Color);
#pragma aux SetLine=\
	"	cld"\
	"	mov al,' '"\
	"	rep stosw"\
	parm [edi][ecx][ah] modify [eax ecx edi]

void Print(void *Adr,char *Txt);
#pragma aux Print=\
	"	cld"\
	"	sub ebx,0A0h"\
	"NewLine:"\
	"	add ebx,0A0h"\
	"	mov edi,ebx"\
	"	jmp Start"\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"Start:"\
	"	lodsb"\
	"Cont:"\
	"	cmp al,' '"\
	"	jnc Cicle"\
	"	cmp al,00Ah"\
	"	jz NewLine"\
	"	cmp al,1"\
	"	jnz Return"\
	"	lodsb"\
	"	mov [WinHKey],al"\
	"	mov [WinHKeyP],edi"\
	"	jmp Cont"\
	"Return:"\
	parm [ebx][esi] modify [eax ebx esi edi]

int TextLen(const char *Txt) {
	int c=0;
	for(int i=0;Txt[i];i++) if (Txt[i]<' ') c++;
	return i-c;
}

Obj::Obj(Win *WinPnt,int L,int LR,int U,int UD) {
	WinP=WinPnt;
	PosX=L;
	PosY=U;
	LenX=LR;
	LenY=UD;
	LimR=(LimL=WinPnt->AbsX(L))+LR;
	LimD=(LimU=WinPnt->AbsY(U))+UD;
	Vid=VideoMemText+(LimU*0x50+LimL)*2;
	Ac=0;
	HKey=0;
	Prev=(Obj*)0;
	Next=WinPnt->ObjPoint;
	if (Next) Next->Prev=this;
	WinPnt->ObjPoint=this;
}

void Obj::TurnNext() {
	DeActive();
	if (!(WinP->ObjActive=Next)) WinP->ObjActive=WinP->ObjPoint;
	WinP->ObjActive->Active();
}

void Obj::TurnPrev() {
	DeActive();
	if (!(WinP->ObjActive=Prev)) {
		WinP->ObjActive=WinP->ObjPoint;
		while (WinP->ObjActive->Next) WinP->ObjActive=WinP->ObjActive->Next;
	}
	WinP->ObjActive->Active();
}

void SetButtonState(void *Adr,int Len,unsigned char Color);
#pragma aux SetButtonState=\
	"	cld"\
	"	mov ecx,ebx"\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"	loop Cicle"\
	"	mov ah,[edi]"\
	"	and ah,0F0h"\
	"	mov al,'▄'"\
	"	mov [edi-1],ax"\
	"	add edi,0A1h"\
	"	sub edi,ebx"\
	"	sub edi,ebx"\
	"	mov ecx,ebx"\
	"	mov al,'▀'"\
	"	rep stosw"\
	parm [edi][ebx][al] modify [eax ecx edi]

void SetButton(void *Adr,int Len,unsigned char Color) {
	SetButtonState(Adr,Len,Color);
}

void PressButton(void *Adr,int Len);
#pragma aux PressButton=\
	"	mov al,' '"\
	"	mov [edi],al"\
	"	add edi,0A2h"\
	"	sub edi,ecx"\
	"	sub edi,ecx"\
	"	mov al,' '"\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"	loop Cicle"\
	parm [edi][ecx] modify [eax ecx edi]

void PrintH(void *Adr,char *Txt);/////
#pragma aux PrintH=\
	"	cld"\
	"	sub ebx,0A0h"\
	"NewLine:"\
	"	add ebx,0A0h"\
	"	mov edi,ebx"\
	"	jmp Start"\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"Start:"\
	"	lodsb"\
	"	cmp al,' '"\
	"	jnc Cicle"\
	"	cmp al,1"\
	"	jz Start"\
	"	cmp al,00Ah"\
	"	jz NewLine"\
	parm [ebx][esi] modify [eax ebx esi edi]

ObjButton::ObjButton(Win *Pnt,int X,int Y,int dX,char *Txt,int IdButton):
		Obj(Pnt,X,dX,Y,1) {
	Id=IdButton;
	SetButton(Vid+1,dX,0x70);///
	Pnt->TxtOut(X+(dX-TextLen(Txt))/2,Y,Txt);
	ReadHotKey();
}

int ObjButton::MouseDown(int,int) {
	return HotKey();
}

int ObjButton::HotKey() {
	PressButton(Vid+LenX*2,LenX);
	return Id;
}

int ObjButton::Key(unsigned K) {
	switch (K) {
	 case 0x1C0D:
		return HotKey();
	 case 0x4800:
	 case 0x4B00:
		TurnPrev();
		break;
	 case 0x5000:
	 case 0x4D00:
		TurnNext();
		break;
	 default:
		return -1;
	}
	return 0;
}

void ObjButton::Refresh() {
	unsigned char C=0x70;
	if (Ac) C=0xF0;
	SetButton(Vid+1,LenX,C);
	SetHotKey();
}

void Obj::SetHotKey() {
	if (!HKey) return;
	unsigned char C=*HKeyP;
	*HKeyP=(C&0xF8)|0x4;
}

void Obj::ReadHotKey() {
	if (!WinHKey) return;
	HKey=RegUp(WinHKey);
	HKeyP=WinHKeyP+1;
}

ObjCheckBox::ObjCheckBox(Win* Pnt,int X,int Y,char *Txt,unsigned *Data):
		Obj(Pnt,X,TextLen(Txt)+4,Y,1) {
	Dat=*Data;
	DatL=Data;
	Vid[0]='[';
	Vid[4]=']';
	WinP->TxtOut(PosX+4,PosY,Txt);
	ReadHotKey();
	SetHotKey();
	Refresh();
}

int ObjCheckBox::Key(unsigned K) {
	switch (K) {
	 case 0x1C0D:
		Dat^=1;
		Refresh();
		TurnNext();
		break;
	 case 0x3920:
		Dat^=1;
		Refresh();
		break;
	 case 0x4800:
		TurnPrev();
		break;
	 case 0x5000:
		TurnNext();
		break;
	 case 0x4B00:
		TurnPrev();
		break;
	 case 0x4D00:
		TurnNext();
		break;
	 default:
		return -1;
	}
	return 0;
}

int ObjCheckBox::MouseDown(int,int) {
	return HotKey();
}

int ObjCheckBox::HotKey() {
	Dat^=1;
	Refresh();
	return 0;
}

void ObjCheckBox::Refresh() {
	Vid[2]=' ';
	if (Dat) Vid[2]='X';
	if (Ac) SetCursor(LimL+1,LimU);
	else CursorOff();
}

void ObjCheckBox::SetResult() {
	*DatL=Dat;
}

int PrTxtRad(void *Adr,char *Txt);
#pragma aux PrTxtRad=\
	"	cld"\
	"	mov edi,ebx"\
	"	add ebx,008h"\
	"	xor ecx,ecx"\
	"	jmp Start"\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"Start:"\
	"	lodsb"\
	"Cont:"\
	"	cmp al,' '"\
	"	jnc Cicle"\
	"	cmp al,1"\
	"	jnz NextCode"\
	"	lodsb"\
	"	mov [WinHKey],al"\
	"	mov [WinHKeyP],edi"\
	"	jmp Cont"\
	"NextCode:"\
	"	sub edi,ebx"\
	"	cmp edi,ecx"\
	"	jl LenOk"\
	"	mov ecx,edi"\
	"LenOk:"\
	"	add ebx,0A0h"\
	"	mov edi,ebx"\
	"	cmp al,00Ah"\
	"	jz Start"\
	"	shr ecx,01h"\
	parm [ebx][esi] value [ecx] modify [eax ebx ecx esi edi]

ObjRadio::ObjRadio(Win *Pnt,int X,int Y,char *Txt,CnTbl *Cfg):
		Obj(Pnt,X,
		PrTxtRad(VideoMemText+Pnt->AbsY(Y)*0xA0+Pnt->AbsX(X)*2,Txt)+4,
		Y+1,Cfg->ValN) {
	Dat=*(DatL=Cfg->Dst);
	for (int i=0;i<LenY;i++) {
		Vid[i*0xA0]='(';
		Vid[i*0xA0+4]=')';
	}
	ReadHotKey();
	SetHotKey();
	Refresh();
}

void ObjRadio::Refresh() {
	for (int i=0;i<LimD-LimU;i++) Vid[i*0xA0+2]=' ';
	Vid[Dat*0xA0+2]=0x07;
	if (Ac) SetCursor(LimL+1,LimU+Dat);
	else CursorOff();
}

int ObjRadio::Key(unsigned K) {
	switch (K) {
	 case 0x1C0D:
		TurnNext();
		break;
	 case 0x4800:
		if (Dat) Dat--;
		else Dat=LimD-LimU-1;
		Refresh();
		break;
	 case 0x5000:
		if (Dat<LimD-LimU-1) Dat++;
		else Dat=0;
		Refresh();
		break;
	 case 0x4B00:
		TurnPrev();
		break;
	 case 0x4D00:
		TurnNext();
		break;
	 default:
		return -1;
	}
	return 0;
}

int ObjRadio::MouseDown(int,int Y) {
	Dat=Y-LimU;
	Refresh();
	return 0;
}

int ObjRadio::HotKey() {
	if (Dat<LimD-LimU-1) Dat++;
	else Dat=0;
	Refresh();
	return 0;
}

void ObjRadio::SetResult() {
	*DatL=Dat;
}

ObjInputTxt::ObjInputTxt(Win *Pnt,int X,int Y,int dX,char *TxtT,CnTxt *Cfg):
		Obj(Pnt,X,dX,Y+1,1) {
	EdLen=Cfg->Siz;
	TxtRes=Cfg->Dst;
	EdPos=0;
	VwPos=0;
	Ed=new char[EdLen];
	memcpy(Ed,TxtRes,EdLen);
	WinP->TxtOut(X,Y,TxtT);
	ReadHotKey();
	SetHotKey();
	Refresh();
}

ObjInputTxt::~ObjInputTxt() {
	delete[] Ed;
}

void ObjInputTxt::SetResult() {
	memcpy(TxtRes,Ed,EdLen);
}

int ObjInputTxt::Key(unsigned K) {
	switch (K) {
	 case 0x1C0D:
		TurnNext();
		return 0;
	 case 0x4800:
		TurnPrev();
		return 0;
	 case 0x5000:
		TurnNext();
		return 0;
	 case 0x4B00:
		if (EdPos) EdPos--;
		break;
	 case 0x4D00:
		if (EdPos<EdLen&&Ed[EdPos]) EdPos++;
		break;
	 case 0x0E08:
		if (EdPos) {
			EdPos--;
			for (int i=EdPos;Ed[i+1]&&i+1<EdLen;i++) Ed[i]=Ed[i+1];
			Ed[i]=0;
		}
		break;
	 case 0x5300:
		if (Ed[EdPos]) {
			for (int i=EdPos;Ed[i+1]&&i+1<EdLen;i++) Ed[i]=Ed[i+1];
			Ed[i]=0;
		}
		break;
	 case 0x4700:
		EdPos=0;
		break;
	 case 0x4F00:
		EdPos=TextLen(Ed);
		break;
	 default: {
		unsigned char Asc=K;
		if (Asc>=' ') {
			if (EdPos+1<EdLen) if (Insert) {
				if (!Ed[EdPos]) Ed[EdPos+1]=0;
				Ed[EdPos++]=Asc;
			} else {
				int i=EdPos;
				char c=Ed[i++];
				char d;
				while (c&&i+1<EdLen) {
					d=Ed[i];
					Ed[i++]=c;
					c=d;
				}
				Ed[i]=0;
				Ed[EdPos++]=Asc;
			}
		}
		break;
	 }
	}
	Refresh();
	return 0;
}

void PrintEL(void*,char*,int,unsigned char);
#pragma aux PrintEL=\
	"	cld"\
	"Cicle:"\
	"	lodsb"\
	"	test al,al"\
	"	jz SpaceFill"\
	"	stosw"\
	"	loop Cicle"\
	"	jmp Return"\
	"SpaceFill:"\
	"	mov al,' '"\
	"	rep stosw"\
	"Return:"\
	parm [edi][esi][ecx][ah] modify [eax esi edi]

void ObjInputTxt::Refresh() {
	unsigned char C;
	if (Ac) {
		if (EdPos<VwPos) VwPos=EdPos;
		int MaxFar=EdPos-LenX+1;
		if (VwPos<MaxFar) VwPos=MaxFar;
		SetCursor(LimL+EdPos-VwPos,LimU);
		C=0xF;
	} else {
		VwPos=0;
		CursorOff();
		C=0xE;
	}
	PrintEL(Vid,Ed+VwPos,LenX,C);
}

int ObjInputTxt::MouseDown(int X,int Y) {
	int MsX=X-LimL;
	int Len=TextLen(Ed);
	if (MsX>Len) EdPos=Len;
	else EdPos=VwPos+MsX;
	Refresh();
	return 0;
}

void SetColorLine(void*,int,unsigned char);
#pragma aux SetColorLine=\
	"Cicle:"\
	"	mov [edi],al"\
	"	add edi,2"\
	"	loop Cicle"\
	parm [edi][ecx][al] modify [ecx edi]

void ObjInputTxt::Active() {
	EdPos=0;/////	EdPos=TextLen(Ed);
	Obj::Active();
}

void ObjInputTxt::FileBox(char *Mask,char *Path) {
	if (*Path) if (ChDir(Path)) MessageBox(0x4F,TxtErPth,Path);
	{Win W(10,59,1,23);
	W.SetTitle(TxtFileCh);
	ObjFListBox LB(&W,4,2,15,Mask,Ed);
	ObjButton ButCn(&W,32,20,14,ButtCanc,1);
	ObjButton ButOK(&W,13,20,14,ButtOK,2);
	if (W.Exe()) W.SetResult();}
	ChDir(StPth);
	Refresh();
}

void NumberToString(int,char*);
#pragma aux NumberToString=\
	"	mov ebx,0Ah"\
	"	mov ecx,NumL"\
	"Cicle:"\
	"	xor edx,edx"\
	"	div ebx"\
	"	add dl,'0'"\
	"	mov [edi],dl"\
	"	inc edi"\
	"	test eax,eax"\
	"	loopnz Cicle"\
	"	mov BYTE [edi],0"\
	parm [eax][edi][ecx] modify [eax ebx ecx edx edi]

void NumToStr(int Num,char *Txt) {
	NumberToString(Num,Txt);
}

int StringToNumber(char*);
#pragma aux StringToNumber=\
	"	xor eax,eax"\
	"	cmp BYTE [edi],0"\
	"	jz Return"\
	"	mov ebx,edi"\
	"CicleCount:"\
	"	inc edi"\
	"	cmp BYTE [edi],0"\
	"	jnz CicleCount"\
	"	mov ecx,edi"\
	"	sub ecx,ebx"\
	"	mov ebx,0Ah"\
	"Cicle:"\
	"	mul ebx"\
	"	dec edi"\
	"	mov dl,[edi]"\
	"	lea eax,[eax+edx-030h]"\
	"	loop Cicle"\
	"Return:"\
	parm [edi] value [eax] modify [eax ebx ecx edx edi]

int StrToNum(char *Txt) {
	return StringToNumber(Txt);
}

void PrintRev(void *Adr,char *Txt);
#pragma aux PrintRev=\
	"	cld"\
	"	mov ecx,NumL"\
	"CicleFill:"\
	"	add edi,2"\
	"	mov BYTE [edi],' '"\
	"	loop CicleFill"\
	"	jmp Start"\
	"Cicle:"\
	"	mov [edi],al"\
	"	sub edi,2"\
	"Start:"\
	"	lodsb"\
	"	test al,al"\
	"	jnz Cicle"\
	parm [edi][esi] modify [eax ecx esi edi]

ObjInputNum::ObjInputNum(Win *Pnt,int X,int Y,char *TxtT,CnNum *Cfg):
		Obj(Pnt,X,NumL+4,Y,1) {
	EdPos=0;
	Min=Cfg->Min;
	Max=Cfg->Max;
	Res=Cfg->Dst;
	Ed[NumL]=0;////?
	WinP->TxtOut(X+10,Y,TxtT);
	*(word*)(Vid+14)=0x3019;
	*(word*)(Vid+16)=0x3018;
	NumToStr(*Res,Ed);
	ReadHotKey();
	SetHotKey();
	Refresh();
}

int ObjInputNum::Key(unsigned K) {
	switch (K) {
	 case 0x1C0D:
		TurnNext();
		return 0;
	 case 0x4800:
		NumUp();
		return 0;
	 case 0x5000:
		NumDown();
		return 0;
	 case 0x4B00:
		if (EdPos<NumL&&Ed[EdPos]) EdPos++;
		break;
	 case 0x4D00:
		if (EdPos) EdPos--;
		break;
	 case 0x0E08:
		if (Ed[EdPos]) {
			for (int i=EdPos;Ed[i+1]&&i<NumL-1;i++) Ed[i]=Ed[i+1];
			Ed[i]=0;
		}
		break;
	 case 0x5300:
		if (EdPos) {
			EdPos--;
			for (int i=EdPos;Ed[i+1]&&i<NumL-1;i++) Ed[i]=Ed[i+1];
			Ed[i]=0;
		}
		break;
	 case 0x4700:
		EdPos=TextLen(Ed);
		break;
	 case 0x4F00:
		EdPos=0;
		break;
	 default: {
		unsigned char Asc=K;
		if (Asc>='0'&&Asc<='9') {
			if (EdPos&&Insert) {
				Ed[EdPos--]=Asc;
			} else {
				for (unsigned i=NumL-1;i>EdPos;i--) Ed[i]=Ed[i-1];
				Ed[EdPos]=Asc;
			}
		} else return -1;
		break;
	 }
	}
	Refresh();
	return 0;
}

void ObjInputNum::TestLimit() {
	unsigned A=StrToNum(Ed);
	if (A<Min) A=Min;
	if (A>Max) A=Max;
	NumToStr(A,Ed);
}

void ObjInputNum::NumDown() {
	unsigned A=StrToNum(Ed);
	if (A) A--;
	NumToStr(A,Ed);
	TestLimit();
	EdPos=0;
	Refresh();
}

void ObjInputNum::NumUp() {
	unsigned A=StrToNum(Ed);
	if (A<99999) A++;
	NumToStr(A,Ed);
	TestLimit();
	EdPos=0;
	Refresh();
}

int ObjInputNum::MouseDown(int X,int) {
	X-=LimL;
	if (X==NumL+2) {
		NumDown();
		return 0;
	}
	if (X==NumL+3) {
		NumUp();
		return 0;
	}
	int L=TextLen(Ed);
	unsigned E=NumL-X+1;
	EdPos=(L<E)?L:E;
	Refresh();
	return 0;
}

void ObjInputNum::Active() {
	EdPos=0;
	Obj::Active();
}

void ObjInputNum::DeActive() {
	TestLimit();
	Obj::DeActive();
}

void ObjInputNum::SetResult() {
	*Res=StrToNum(Ed);
}

void ObjInputNum::Refresh() {
	PrintRev(Vid,Ed);
	unsigned char C;
	if (Ac) {
		SetCursor(LimL+NumL+1-EdPos,LimU);
		C=0xF;
	} else {
		CursorOff();
		C=0xE;
	}
	SetColorLine(Vid+1,NumL+2,C);
}

Win::Win(int L,int LR,int U,int UD,unsigned char Color) {
	KeepArea=ScrSave();
	ObjPoint=(Obj*)0;
	ObjActive=(Obj*)0;
	LimL=L;
	LimR=L+LR;
	LimU=U;
	LimD=U+UD;
	LenX=LR;
	HlpTxt=(char*)0;
	Prog=(int(*)())0;
	Vid=VideoMemText+(LimU*0x50+LimL)*2;
	WinSet(Color,Vid,LenX-2,(0x50-LenX)*2,UD-2);
}

Win::~Win() {
	CursorOff();
	ScrLoad(KeepArea);
}

unsigned Key();
#pragma aux Key=\
	"	mov ah,001h"\
	"	int 016h"\
	"	mov eax,0"\
	"	jz Return"\
	"	mov ah,000h"\
	"	int 016h"\
	"Return:"\
	value [eax] modify [eax]

void PrintHelp(void *Adr,char *Txt,unsigned Len);
#pragma aux PrintHelp=\
	"	push ebp"\
	"	cld"\
	"	mov ah,[ebx+1]"\
	"NewLine:"\
	"	add ebx,0A0h"\
	"	mov edi,ebx"\
	"	xor ecx,ecx"\
	"	jmp Start"\
	"Cicle:"\
	"	inc ecx"\
	"	cmp ecx,edx"\
	"	jna Cont"\
	"	cmp al,' '"\
	"	jz NewLine"\
	"CicleRear:"\
	"	dec esi"\
	"	cmp BYTE [esi-1],' '"\
	"	jz NewLine"\
	"	jnc RearCont"\
	"	xor ah,001h"\
	"	jmp CicleRear"\
	"RearCont:"\
	"	sub edi,2"\
	"	mov BYTE [edi],' '"\
	"	jmp CicleRear"\
	"Cont:"\
	"	stosw"\
	"Start:"\
	"	lodsb"\
	"	cmp al,' '"\
	"	jnc Cicle"\
	"	cmp al,00Ah"\
	"	jz NewLine"\
	"	xor ah,001h"\
	"	cmp al,001h"\
	"	jz Start"\
	"	pop ebp"\
	parm [ebx][esi][edx] modify [eax ebx ecx esi edi]

inline void Win::Hlp() {
	Win H((ScrHeight-HdX)/2,HdX,(ScrWidth-HdY)/2,HdY,0x70);
	H.SetTitle(TxtHlp,0x0F);
	PrintHelp(VideoMemText+(H.AbsY(1)*0x50+H.AbsX(4))*2,HlpTxt,H.dX()-8);
	H.Exe();
}

void Win::Help() {
	if (HlpTxt) {
		CursorOff();
		MouseOff();
		Hlp();
		ObjActive->Active();
		MouseOn();
		do {Mouse();} while(MouseK&3);
	}
}

int Win::Exe() {
	int MouseLastX,MouseLastY;
	unsigned MouseKey=0;
	unsigned char DKeyU=0x0;/////
	if (ObjPoint&&!ObjActive) (ObjActive=ObjPoint)->Active();
	Obj *Pnt=ObjPoint;
	while (Pnt) {
		Pnt->Refresh();
		Pnt=Pnt->GetNext();
	}
	MouseOn();
	do {Mouse();} while(MouseK&3);
	while(1) {
		unsigned K=Key();
		if (K) {
			if (!ObjActive) {
				MouseOff();
				return 0;
			}
			switch(K) {
			 case 0x0F09:
				MouseOff();
				ObjActive->TurnNext();
				MouseOn();
				break;
			 case 0x0F00:
				MouseOff();
				ObjActive->TurnPrev();
				MouseOn();
				break;
			 case 0x3B00:
				Help();
				break;
			 case 0x5200:
				Obj::Insert^=0x01;
				break;
			 case 0x011B:
				MouseOff();
				return 0;
			 default:
				MouseOff();
				int Code=-1;
				if (!Prog) {
					Code=ObjActive->Key(K);
					if (Code>0) return Code-1;
				}
				if (Code==-1) {
					unsigned char HK=RegUp((unsigned char)K);
					if (HK) {
						Obj *Pnt=ObjPoint;
						while (Pnt) {
							if (Pnt->HKey==HK) {
								ObjActive->DeActive();
								ObjActive=Pnt;
								Pnt->Active();
								int Code=Pnt->HotKey();
								if (Code) return Code-1;
								break;
							}
							Pnt=Pnt->GetNext();
						}
					}
				}
				MouseOn();
				break;
			}
		}
		Mouse();
		int X=MouseX/8;
		int Y=MouseY/8;
		if (MouseK&1) {
			if (MouseLastX==X&&MouseLastY==Y&&!DKeyU) DKey=0x1;
			else DKey=0x0;
			if (!MouseKey||MouseLastX!=X||MouseLastY!=Y) {
				MouseKey=1;
				MouseLastX=X;
				MouseLastY=Y;
				if (!ObjActive) {
					MouseOff();
					return 0;
				}
				Obj *Pnt=ObjPoint;
				while (Pnt) {
					if (Pnt->ObjPlace(X,Y)) {
						MouseOff();
						if (ObjActive!=Pnt) {
							ObjActive->DeActive();
							ObjActive=Pnt;
							Pnt->Active();
						}
						DKeyU=DKey;
						int Code=Pnt->MouseDown(X,Y);
						if (Code) return Code-1;
						MouseOn();
						break;
					}
					Pnt=Pnt->GetNext();
				}
			}
		} else MouseKey=0;
		if (MouseK&2) Help();
		if (Prog) {
			int Code=Prog();
			if (Code) {
				MouseOff();
				return Code;
			}
		}
	}
}

void Win::SetTitle(char *Txt,unsigned char Color) {
	SetLine(Vid,LenX,Color);
	TxtOut((LenX-TextLen(Txt))/2,0,Txt);
}

void Win::SetResult() {
	Obj *Pnt=ObjPoint;
	while (Pnt) {
		Pnt->SetResult();
		Pnt=Pnt->GetNext();
	}
}

void Win::SetHelp(int dX,int dY,char *Txt) {
	HdX=dX;
	HdY=dY;
	HlpTxt=Txt;
}

void Win::SetProg(int (*ProgName)()) {
	Prog=ProgName;
}

void Win::PrintNum(int X,int Y,unsigned Num) {
	char Ed[NumL+1];
	NumToStr(Num,Ed);
	PrintRev(VideoMemText+((LimU+Y)*0x50+LimL+X)*2,Ed);
}

void SetCursor(int X,int Y) {
	ri.a.h=0x02;
	ri.b.h=0x00;
	ri.d.h=Y;
	ri.d.l=X;
	IntRealMode(0x10);
}

void CursorOff() {
	SetCursor(0,0x19);
}

void *ScrSave() {
	char *Pnt=new char[4000];
	MemCopyW(Pnt,VideoMemText,2000);
	return Pnt;
}

void ScrLoad(void *Pnt) {
	MemCopyW(VideoMemText,Pnt,2000);
	delete[] Pnt;
}

void ScreenFull(void *Adr,unsigned Fill);
#pragma aux ScreenFull=\
	"	mov ecx,2000"\
	"	rep stosw"\
	parm [edi][eax] modify [eax ecx edi]

void ScreenClear() {
	ScreenFull(VideoMemText,0x0720);
	SetCursor(0,0);
}

void ScreenFill() {
	ScreenFull(VideoMemText,0x0FB0);
	CursorOff();
}

void PrintL(void*,char*,int,int,unsigned char);
#pragma aux PrintL=\
	"	cld"\
	"	sub ebx,ecx"\
	"	jna Start"\
	"	lea esi,[esi+ebx+03h]"\
	"	mov al,'.'"\
	"	stosw"\
	"	stosw"\
	"Cicle:"\
	"	stosw"\
	"Start:"\
	"	lodsb"\
	"	test al,al"\
	"	jnz Cicle"\
	"	xor ecx,ecx"\
	"	sub ecx,ebx"\
	"	jng Return"\
	"	mov al,' '"\
	"	rep stosw"\
	"Return:"\
	parm [edi][esi][ecx][ebx][ah] modify [eax ebx esi edi]

void Win::LineOut(int X,int Y,char *Txt,int Len,unsigned char Color) {
	PrintL(VideoMemText+((LimU+Y)*0x50+LimL+X)*2,Txt,Len,TextLen(Txt),Color);
}

void Win::TxtOut(int X,int Y,char *Txt) {
	WinHKey=0x00;
	Print(VideoMemText+((LimU+Y)*0x50+LimL+X)*2,Txt);
}

void PrintD(void*,const char*,const char*,const byte,const byte);
#pragma aux PrintD=\
	"	cld"\
	"	call Start"\
	"	test cl,cl"\
	"	jz Continue"\
	"	mov al,'.'"\
	"	stosw"\
	"	stosw"\
	"	stosw"\
	"	jmp Continue"\
	"Cicle:"\
	"	stosw"\
	"Start:"\
	"	lodsb"\
	"	cmp al,' '"\
	"	jnc Cicle"\
	"	ret"\
	"Continue:"\
	"	mov esi,ebx"\
	"	call Start"\
	parm [edi][esi][ebx][ah][cl] modify [eax ebx esi edi]

void MessageBox(const unsigned char C,const char *Txt0,const char *Txt1) {
	unsigned char LnD=0x0;
	int BrdAdd=0;
	int Len=TextLen(Txt0)+TextLen(Txt1);
	const BoxMinLen=14; //Минимальная длина сообщения
	if (Len<BoxMinLen) {
		BrdAdd=(BoxMinLen-Len)>>1;
		Len=BoxMinLen;
	}
	const BoxMaxLen=66; //Максимальная длина сообщения
	if (Len>BoxMaxLen) {
		Txt1+=Len-BoxMaxLen+3;
		Len=BoxMaxLen;
		LnD=0x1;
	}
	const Brd=5;
	int BoxH=Len+Brd*2;
	Win W((ScrHeight-BoxH)>>1,BoxH,ScrWidth/2-3,7,C);
	PrintD(VideoMemText+(W.AbsY(2)*0x50+W.AbsX(Brd+BrdAdd))*2,
			Txt0,Txt1,C,LnD);
	ObjButton ButOK(&W,Len/2,4,10,ButtOK,1);
	W.Exe();
}

int CDir(char*);
#pragma aux CDir=\
	"	cmp BYTE [edx+1],':'"\
	"	jnz SetDir"\
	"	push edx"\
	"	mov ah,00Eh"\
	"	mov dl,[edx]"\
	"	sub dl,'A'"\
	"	and dl,01Fh"\
	"	int 021h"\
	"	pop edx"\
	"SetDir:"\
	"	mov ah,03Bh"\
	"	int 021h"\
	"	sbb eax,eax"\
	parm [edx] value [eax] modify [eax]

int ChDir(char* Path) {
	return CDir(Path);
}

void GDir(char*);
#pragma aux GDir=\
	"	mov ah,019h"\
	"	int 021h"\
	"	lea edx,[eax+1]"\
	"	add al,'A'"\
	"	mov [esi],al"\
	"	mov WORD [esi+1],05C3Ah"\
	"	add esi,3"\
	"	mov ah,047h"\
	"	int 021h"\
	parm [esi] modify [eax edx esi]

void GetDir(char *Path) {
	GDir(Path);
}

ObjFListBox::ObjFListBox(Win *Pnt,int X,int Y,int dY,char *Mask,char *BgT):
		Obj(Pnt,X,51,Y,dY) {
	VwNum=(LenY-1)*3;
	FPnt=0;
	Res=BgT;
	Msk=Mask;
	CurPos=0;
	VwPos=0;
	GetDir(BegPath);
	CreateFList(Mask);
	memcpy(Ed,BgT,sizeof(Ed));
	Refresh();////
}

ObjFListBox::~ObjFListBox() {
	DeleteFList();
}

void FListBoxScrollBar(void*,int);
#pragma aux FListBoxScrollBar=\
	"	cld"\
	"	mov ax,09711h"\
	"	stosw"\
	"	mov ax,071B1h"\
	"	mov ecx,031h"\
	"	rep stosw"\
	"	mov ax,09710h"\
	"	stosw"\
	"	lea edi,[edi+edx*2-64h]"\
	"	mov ax,07020h"\
	"	mov ecx,3"\
	"	rep stosw"\
	parm [edi][edx] modify [eax ecx edi]

void FListBoxPrint(void*,char*,int,unsigned char);
#pragma aux FListBoxPrint=\
	"	cld"\
	"	mov al,' '"\
	"	stosw"\
	"Cicle:"\
	"	stosw"\
	"	dec ecx"\
	"	lodsb"\
	"	test al,al"\
	"	jnz Cicle"\
	"	mov al,' '"\
	"	rep stosw"\
	parm [edi][esi][ecx][ah] modify [eax ebx esi edi]

void ObjFListBox::Refresh() {
	if (VwPos&&VwPos>Num-VwNum) VwPos=Num-VwNum;
	if (CurPos>=Num) CurPos=Num-1;
	int PrScr=0;
	if (VwPos) PrScr=VwPos*(46*2+1)/((Num-VwNum)*2);
	FListBoxScrollBar(Vid+(LenY-1)*0xA0,PrScr);
	WinP->LineOut(PosX,PosY+LenY+1,Ed,0x33,0x9F);
	for (int j=0;j<3;j++) for (int i=0;i<LenY-1;i++) {
		int Pos=VwPos+j*(LenY-1)+i;
		char *Name=TxtNul;
		if (Pos<Num) Name=FPnt[Pos]->Name;
		unsigned char C=0x30;
		if (Pos==CurPos) {
			C=0x3F;
			if (Ac) C=0xF;
		}
		FListBoxPrint(Vid+j*0x22+i*0xA0,Name,0x10,C);
	}
}

void ObjFListBox::Select() {
	char *TxtN=FPnt[CurPos]->Name;
	if (FPnt[CurPos]->Typ) {
		char *Txt=TxtN;
		while (*Txt!='\\') Txt++;
		*Txt=0;
		ChDir(TxtN);
		CreateFList(Msk);
		VwPos=CurPos=0;
	} else {
		char Path[0x40];
		GetDir(Path);
		int i=0;
		if (!TxtCmp(Path,BegPath)) {
			while (Ed[i]=Path[i]) i++;
			Ed[i++]='\\';
		}
		for (int j=0;Ed[i+j]=TxtN[j];j++);
	}
}

int ObjFListBox::Key(unsigned K) {
	if (!Num) return 0;
	switch (K) {
	 case 0x1C0D: {
		Select();
		if (!FPnt[CurPos]->Typ) {
			TurnNext();
			Refresh();
			return 0;
		}
		break;
	 }
	 case 0x3920:
		Select();
		break;
	 case 0x4700:
		CurPos=0;
		break;
	 case 0x4F00:
		CurPos=Num-1;
		break;
	 case 0x4800:
		if (CurPos) CurPos--;
		break;
	 case 0x4900:
		if (CurPos>VwNum-1) CurPos-=VwNum-1;
		else CurPos=0;
		break;
	 case 0x5100:
		if (CurPos<Num-VwNum) CurPos+=VwNum-1;
		else CurPos=Num-1;
		break;
	 case 0x5000:
		if (CurPos<Num-1) CurPos++;
		break;
	 case 0x4B00:
		if (CurPos>LenY-1) CurPos-=LenY-1;
		else CurPos=0;
		break;
	 case 0x4D00:
		if (CurPos<Num-LenY+1) CurPos+=LenY-1;
		else CurPos=Num-1;
		break;
	 default:
		return -1;
	}
	if (CurPos<VwPos) VwPos=CurPos;
	if (CurPos>=VwPos+VwNum) VwPos=CurPos-VwNum+1;
	Refresh();
	return 0;
}

int ObjFListBox::MouseDown(int X,int Y) {
	if (!Num) return 0;
	X-=LimL;
	Y-=LimU;///
	if (Y==LenY-1) {
		if (Num<=VwNum) return 0;
		switch (X) {
		 case 0:
			if (VwPos) VwPos--;
			break;
		 case 1:
			VwPos=0;
			break;
		 case 49:
			VwPos=Num-VwNum;
			break;
		 case 50:
			if (VwPos<Num-VwNum) VwPos++;
			break;
		 default:
			VwPos=((X-2)*(Num-VwNum)*2/46+1)/2;
			break;
		}
	} else {
		CurPos=X/0x11*(LenY-1)+Y+VwPos;
		if (CurPos>=Num) CurPos=Num-1;
		else {
			if (!FPnt[CurPos]->Typ) {
				if (!DKey) Select();
				else return 2;
			} else if (DKey) Select();
		}
	}
	Refresh();
	return 0;
}

void ObjFListBox::SetResult() {
	memcpy(Res,Ed,sizeof(Ed));
}

void ObjFListBox::AddFList(FLst *&P,find_t &F,unsigned char Type) {
	FLst *PT=new FLst;
	PT->Typ=Type;
	PT->Next=P;
	char *PntD=PT->Name,*PntS=F.name;
	while (*PntD++=*PntS++);
	if (Type) *(unsigned short*)(PntD-1)=0x005C;
	if (P) {
		if (!TxtSort(PT->Name,P->Name)) {
			PT->Next=P;
			P=PT;
		} else {
			FLst *PTmp=P;
			while (PTmp->Next&&TxtSort(PT->Name,PTmp->Next->Name)) PTmp=PTmp->Next;
			PT->Next=PTmp->Next;
			PTmp->Next=PT;
		}
	} else {
		PT->Next=(FLst*)0;
		P=PT;
	}
}

void ObjFListBox::CreateFList(char *Mask) {
	char TmpMask[0x50];
	DeleteFList();
	FLst *PD=(FLst*)0,*PF=(FLst*)0;
	find_t F;
	Num=0x0;
	if (!_dos_findfirst(MaskAll,_A_SUBDIR,&F)) while (!_dos_findnext(&F))
			if (F.attrib&_A_SUBDIR) {
		AddFList(PD,F,1);
		Num++;
	}
	unsigned char End=0;
	do {
		char *TxtD=TmpMask;
		while (1) {
			*TxtD=*Mask;
			if (!*Mask) {
				End=1;
				break;
			}
			if (*Mask++==',') {
				*TxtD=0;
				break;
			}
			TxtD++;
		}
		if (!_dos_findfirst(TmpMask,_A_NORMAL,&F)) do {
			AddFList(PF,F,0);
			Num++;
		} while (!_dos_findnext(&F));
	} while (!End);
	FPnt=new FLst*[Num];
	FLst **PntT=FPnt;
	while (PD) {
		*PntT++=PD;
		PD=PD->Next;
	}
	while (PF) {
		*PntT++=PF;
		PF=PF->Next;
	}
}

void ObjFListBox::DeleteFList() {
	if (!FPnt) return;
	for (int i=0;i<Num;i++) delete FPnt[i];
	delete[] FPnt;
	FPnt=0;
}

const AdX=62;
const AdY=14;

ObjAListBox::ObjAListBox(Win *Pnt,int X,int Y):Obj(Pnt,X,AdX,Y,AdY) {
	APnt=(Add**)0;
	CurPos=0;
	VwPos=0;
	CreateAList();
	Refresh();
}

void SetALBox(void*,int);
#pragma aux SetALBox=\
	"	cld"\
	"	push edi"\
	"	mov WORD [edi],0x971E"\
	"	add edi,0xA0"\
	"	mov ecx,12"\
	"Cicle:"\
	"	mov WORD [edi],0x71B1"\
	"	add edi,0xA0"\
	"	loop Cicle"\
	"	mov WORD [edi],0x971F"\
	"	mov eax,0xA0"\
	"	inc edx"\
	"	mul edx"\
	"	pop edi"\
	"	add edi,eax"\
	"	mov WORD [edi],0x7020"\
	parm [edi][edx] modify [eax ebx ecx edi]

void PrintAddFile(void*,char*,char*,int,unsigned char);
#pragma aux PrintAddFile=\
	"	cld"\
	"	mov al,' '"\
	"	stosw"\
	"	sub ebx,0x10"\
	"	jna Start"\
	"	lea esi,[esi+ebx+0x03]"\
	"	xor ebx,ebx"\
	"	mov al,'.'"\
	"	stosw"\
	"	stosw"\
	"Cicle:"\
	"	stosw"\
	"Start:"\
	"	lodsb"\
	"	test al,al"\
	"	jnz Cicle"\
	"	mov ecx,0x01"\
	"	sub ecx,ebx"\
	"	jng Descript"\
	"	mov al,' '"\
	"	rep stosw"\
	"Descript:"\
	"	mov esi,edx"\
	"	mov ecx,0x2B"\
	"	jmp StartDsc"\
	"CicleDsc:"\
	"	stosw"\
	"StartDsc:"\
	"	lodsb"\
	"	test al,al"\
	"	loopnz CicleDsc"\
	"	test ecx,ecx"\
	"	repnz stosw"\
	"	stosw"\
	parm [edi][esi][edx][ebx][ah] modify [eax ebx ecx esi edi]

void ObjAListBox::Refresh() {
	if (VwPos&&VwPos>Num-AdY) VwPos=Num-AdY;
	if (Num&&CurPos>=Num) CurPos=Num-1;
	int PrScr=0;
	if (VwPos) PrScr=VwPos*((AdY-3)*2+1)/((Num-AdY)*2);
	SetALBox(Vid+0x7A,PrScr);
	for (int i=0;i<AdY;i++) {
		int Pos=VwPos+i;
		unsigned char C=0x30;
		char *Pnt=TxtNul,*Dsc=TxtNul;
		if (Pos<Num) {
			Pnt=APnt[Pos]->Name;
			Proc *PPnt=APnt[Pos]->PrLoc[P_DSC];
			if (PPnt) Dsc=(char*)PPnt->Pr;
			if (Pos==CurPos) {
				C=0x3F;
				if (Ac) C=0x0F;
			}
		}
		int LenR=TextLen(Pnt);
		PrintAddFile(Vid+i*0xA0,Pnt,Dsc,LenR,C);
	}
}

int ObjAListBox::Key(unsigned K) {
	if (!Num) return 0;
	switch (K) {
	 case 0x1C0D:
		return 2;
	 case 0x4700:
		CurPos=0;
		break;
	 case 0x4F00:
		CurPos=Num-1;
		break;
	 case 0x4800:
		if (CurPos) CurPos--;
		break;
	 case 0x4900:
		if (CurPos>AdY-1) CurPos-=AdY-1;
		else CurPos=0;
		break;
	 case 0x5100:
		if (CurPos<Num-AdY) CurPos+=AdY-1;
		else CurPos=Num-1;
		break;
	 case 0x5000:
		if (CurPos<Num-1) CurPos++;
		break;
	 default:
		return -1;
	}
	if (CurPos<VwPos) VwPos=CurPos;
	if (CurPos>=VwPos+AdY) VwPos=CurPos-AdY+1;
	Refresh();
	return 0;
}

int ObjAListBox::MouseDown(int X,int Y) {
	if (!Num) return 0;
	X-=LimL;
	Y-=LimU;///
	if (X==LenX-1) {
		if (Num<=AdY) return 0;
		switch (Y) {
		 case 0:
			if (VwPos) VwPos--;
			break;
		 case AdY-1:
			if (VwPos<Num-AdY) VwPos++;
			break;
		 default:
			VwPos=((Y-1)*(Num-AdY)*2/(AdY-3)+1)/2;
			break;
		}
	} else {
		CurPos=Y+VwPos;
		if (CurPos>=Num) CurPos=Num-1;
		else if (DKey) return 2;
	}
	Refresh();
	return 0;
}

void ObjAListBox::CreateAList() {
	DeleteAList();
	Add *PntAdd=AddFirst;
	for (Num=0;PntAdd;Num++) PntAdd=PntAdd->Next;
	APnt=new Add*[Num+1];
	PntAdd=AddFirst;
	for (unsigned i=0;i<Num+1;i++) {
		APnt[i]=PntAdd;
		PntAdd=PntAdd->Next;
	}
}

void *WinCreate(int X,int Y,int dX,int dY,unsigned char C) {
	return new Win(X,dX,Y,dY,C);
}

void WinRemove(void *Pnt) {
	Obj *Pnt0=((Win*)Pnt)->ObjPoint;
	while (Pnt0) {
		Obj *Pnt1=Pnt0;
		Pnt0=Pnt0->GetNext();
		delete Pnt1;
	}
	delete (Win*)Pnt;
}

void WinTitle(void *Pnt,char *Txt,unsigned char C) {
	((Win*)Pnt)->SetTitle(Txt,C);
}

void WinHelp(void *Pnt,int dX,int dY,char *Txt) {
	((Win*)Pnt)->SetHelp(dX,dY,Txt);
}

void WinText(void *Pnt,int X,int Y,char *Txt) {
	((Win*)Pnt)->TxtOut(X,Y,Txt);
}

int WinExe(void *Pnt) {
	return ((Win*)Pnt)->Exe();
}

void WinResult(void *Pnt) {
	((Win*)Pnt)->SetResult();
}

void *SetButton(void *Pnt,int X,int Y,char *Txt,int dX,int Id) {
	return new ObjButton((Win*)Pnt,X,Y,dX,Txt,Id+1);
}

void *SetCheckBox(void *Pnt,int X,int Y,char *Txt,unsigned *Dst) {
	return new ObjCheckBox((Win*)Pnt,X,Y,Txt,Dst);
}

void *SetRadio(void *Pnt,int X,int Y,char *Txt,CnTbl *Dst) {
	return new ObjRadio((Win*)Pnt,X,Y,Txt,Dst);
}

void *SetInputTxt(void *Pnt,int X,int Y,int dX,char *Txt,CnTxt *Dst) {
	return new ObjInputTxt((Win*)Pnt,X,Y,dX,Txt,Dst);
}

void *SetInputNum(void *Pnt,int X,int Y,char *Txt,CnNum *Dst) {
	return new ObjInputNum((Win*)Pnt,X,Y,Txt,Dst);
}

void FileBox(void *Pnt,char *Mask,char *Path) {
	((ObjInputTxt*)Pnt)->FileBox(Mask,Path);
}
