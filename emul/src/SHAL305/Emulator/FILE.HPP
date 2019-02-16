#include <stdio.h>

extern const char rb[];
extern const char wb[];
extern const char rbp[];
extern const char wbp[];

extern "C" int GetFileAttr(const char*);
#pragma aux GetFileAttr parm [edx] value [ecx]

extern "C" unsigned SetFileAttr(const unsigned,const char*);
#pragma aux SetFileAttr parm [ecx][edx] value [eax]

extern unsigned char FileLoad(void *Buf,char *Nam,unsigned Len,FILE *Str);
