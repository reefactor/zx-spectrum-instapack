
#include "messages.hpp"
#include "interfac.hpp"
#include "file.hpp"

// Определения для работы с файлами
const char rb[]="rb";
const char wb[]="wb";
const char rbp[]="rb+";
const char wbp[]="wb+";

int GetFA(const char*);
#pragma aux GetFA=\
	"	mov eax,04300h"\
	"	int 021h"\
	"	sbb eax,eax"\
	"	or ecx,eax"\
	parm [edx] value [ecx] modify [eax]

int GetFileAttr(const char *FileName) {
	return GetFA(FileName);
}

unsigned SetFA(const unsigned,const char*);
#pragma aux SetFA=\
	"	mov eax,04301h"\
	"	int 021h"\
	"	sbb eax,eax"\
	parm [ecx][edx] value [eax] modify [eax]

unsigned SetFileAttr(const unsigned Attr,const char *FileName) {
	return SetFA(Attr,FileName);
}

unsigned char FileLoad(void *Buf,char *Nam,unsigned Len,FILE *Str) {
	if (!fread(Buf,Len,1,Str)) {
		fclose(Str);
		return 1;
	}
	return 0;
}
