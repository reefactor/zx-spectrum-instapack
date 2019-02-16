
#ifndef ADDITION_INCLUDED
#define ADDITION_INCLUDED

const FileNameLen=0x40;

enum {
	P_DSC,P_CFG,P_SET,P_INI,P_UNI,P_ON_,P_OFF,P_RES,P_CPU,P_INT,P_ITP,P_IN_,
	P_INP,P_OUT,P_OUP,P_MEM,P_AY_,P_VG_,P_VGP,P_F7_,P_F8_,P_F9_,P_F10,P_F11,
	P_F12,P_INS,
	P_Num // Количество позиций в перечислении
};

struct AddHeader {
	char Signature[3];
	unsigned char Version;
	unsigned long Mask;
	unsigned long ProcOffs;
	unsigned long FixOffs;
	unsigned long FixNum;
	unsigned long DataOffs;
	unsigned long DataLen;
	unsigned long DataAll;
};

class Add;

class Proc {
 public:
	void *Pr;
	Proc *Prev,*Next;
	Add *AddP;
 private:
	unsigned NumP;
 public:
	Proc(void*,unsigned,Add*);
	~Proc();
};

extern "C" Proc *PrFirst[P_Num];

extern "C" Add *NewAdd(const char*);

class Add {
 private:
	byte *DataPnt;
	Add(const char*);
	const char *LoadAdd();
 public:
	class Proc *PrLoc[P_Num];
	char Name[FileNameLen];
	class Add *Prev,*Next;
	unsigned char Trace;
	~Add();
	friend class Add *NewAdd(const char*);
};

extern Add *AddFirst,*AddLast;

extern "C" void CallAddition(Proc*);
#pragma aux CallAddition parm [eax]

#endif
