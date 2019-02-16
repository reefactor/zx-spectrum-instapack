
#include "text.hpp"

unsigned char RegUp(unsigned char Ch) {
	if (Ch>='a'&&Ch<='z') return Ch-0x20;
	if (Ch>=' '&&Ch<='¯') return Ch-0x20;
	if (Ch>='à'&&Ch<='ï') return Ch-0x50;
	return Ch;
}

unsigned char TxtCmp(const char *Txt0,const char *Txt1) {
	for (int i=0;Txt0[i]==Txt1[i];i++) if (!Txt0[i]) return 1;
	return 0;
}

unsigned char TxtCmpReg(const char *Txt0,const char *Txt1) {
	while (1) {
		char Ch=*Txt0++;
		if (Ch>='a'&&Ch<='z') Ch-=0x20;
		if (*Txt1++!=Ch) return 0;
		if (!Ch) return 1;
	}
}

unsigned char TxtSort(char *Txt0,char *Txt1) {
	while (*Txt0&&*Txt1) {
		if (*Txt0>*Txt1) return 1;
		if (*Txt0<*Txt1) return 0;
		Txt0++;
		Txt1++;
	}
	return 0;
}

unsigned char TextCopy(char *Dest,const char *Src,int Max) {
	Max--;
	while (*Dest++=*Src++) if (!(--Max)) {
		*Dest=0;
		return 0;
	}
	return 1;
}

void TxtCopy(char *Dst,const char *Src,int Max,const char *Add) {
	unsigned char R=0;
	while (Max&&(*Dst=*Src++)) {
		if (*Dst=='\\') R=0;
		if (*Dst=='.') R=1;
		Dst++;
		Max--;
	}
	if (!R) while (Max--&&(*Dst++=*Add++));
}

