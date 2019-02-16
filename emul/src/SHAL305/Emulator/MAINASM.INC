
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:DGROUP,es:DGROUP,ss:DGROUP

INCLUDE "EMUDATA.INC"

TAdd=3
TAdO=4

P_DSC=00h
P_CFG=01h
P_SET=02h
P_INI=03h
P_UNI=04h
P_ON_=05h
P_OFF=06h
P_RES=07h
P_CPU=08h
P_INT=09h
P_ITP=0Ah
P_IN_=0Bh
P_INP=0Ch
P_OUT=0Dh
P_OUP=0Eh
P_MEM=0Fh
P_AY_=10h
P_VG_=11h
P_VGP=12h
P_F7_=13h
P_F8_=14h
P_F9_=15h
P_F10=16h
P_F11=17h
P_F12=18h
P_INS=19h

P_Num=1Ah

GLOBAL _PrFirst:DWORD
GLOBAL _EmuTable:EmuData

;Структура для вызова прерываний реального режима
STRUC RegByt
l		DB ?
h		DB ?
ENDS
STRUC RegInt
UNION
edi		DD ?
di		DW ?
ENDS
UNION
esi		DD ?
si		DW ?
ENDS
UNION
ebp		DD ?
bp		DW ?
ENDS
		DD ?
UNION
ebx		DD ?
bx		DW ?
b		RegByt<>
ENDS
UNION
edx		DD ?
dx		DW ?
d		RegByt<>
ENDS
UNION
ecx		DD ?
cx		DW ?
c		RegByt<>
ENDS
UNION
eax		DD ?
ax		DW ?
a		RegByt<>
ENDS
flags		DW ?
es		DW ?
ds		DW ?
fs		DW ?
gs		DW ?
		DW 4 DUP (?)
ENDS

STRUC MemBl
Seg		DD ?
Sel		DD ?
Adr		DD ?
Sz		DD ?
ENDS

STRUC Prc
Pr		DD ?
Prev		DD ?
Next		DD ?
ENDS

KEMP_MOUSE EQU 001h

;Определены в MAINCPP.CPP
GLOBAL _RMInt:MemBl
;Определены в MAINASM.ASM
GLOBAL _ri:RegInt
GLOBAL IntRealMode_:NEAR
;Определены в MODE.ASM
GLOBAL SetModeText_:NEAR,SetModeSpec_:NEAR,SetModeHelp_:NEAR
GLOBAL SetModeSpecAdv_:NEAR,ScreenFill_:NEAR
GLOBAL VideoTable_:NEAR

GLOBAL _SpecRAM:BYTE,_SpecROM:BYTE
GLOBAL TableScreen:DWORD,CRTC:DWORD,PortFE:BYTE
GLOBAL CounterTimer:DWORD,_IntRate:DWORD,TableColor:DWORD
GLOBAL FlashUse:DWORD,FlashDetect:DWORD
GLOBAL _Drive:DWORD,_FloppyDriveTyp:BYTE

GLOBAL ProgressView_:NEAR,DiskInit_:NEAR,IntFloppyDisk_:NEAR
GLOBAL DiskDataIn_:NEAR,DiskDataOut_:NEAR,DiskIntWait_:NEAR
GLOBAL _Track:DWORD

GLOBAL DiskVG_:NEAR
GLOBAL _EmuTable:EmuData

GLOBAL MouseSet_:NEAR,MouseSetSpec_:NEAR,MouseSetSpdDef_:NEAR
GLOBAL _JoyKemp:DWORD,_JoySinc:DWORD,_DblKeyKemp:DWORD
GLOBAL _IntLen:DWORD
GLOBAL _FormatDatLen:DWORD
GLOBAL _MouseType:DWORD,_MouseKempXChng:DWORD
GLOBAL _MouseKempX:BYTE,_MouseKempY:BYTE

GLOBAL JoystickInit_:NEAR
GLOBAL DriveTypeInit_:NEAR

GLOBAL PortIn_:NEAR,PortOut_:NEAR

GLOBAL SpeedTest_:NEAR,SpeedSet_:NEAR,_SpeedTestDetect:BYTE
GLOBAL _SlowData:DWORD,_SlowDataTR:DWORD,_SlowDataCanc:DWORD
GLOBAL _SlowVPix:DWORD,_SlowVAttr:DWORD

GLOBAL _TimeCount:DWORD,_PntIntDetect:DWORD
GLOBAL _DevDetect:BYTE
GLOBAL _TabKeyPnt:DWORD,_DoubleKeyPnt:DWORD,_Port1FPnt:DWORD

GLOBAL MainCPU_:NEAR,ResetCPU_:NEAR,IncDecTblIni_:NEAR
GLOBAL WritBytScr_:NEAR,WritBytScrAdv_:NEAR

GLOBAL SoundAY_:NEAR,_Beeper:DWORD,_SoundCard:DWORD,_SoundDigital:DWORD
GLOBAL _SBAdress:DWORD,_SBPort:DWORD,_SBVolume:DWORD,_AdLibWaitState:DWORD
GLOBAL _SampleRate:DWORD

GLOBAL MessageBox_:NEAR,_TxtNul:BYTE,_TxtErAdLib:BYTE,_TxtErSndBl:BYTE

GLOBAL CounterInt:BYTE,SetMemory_:NEAR
GLOBAL SetBorderColor_:NEAR,SetPage_:NEAR

GLOBAL _GrayMode:DWORD

GLOBAL _ExitIfInt:BYTE

GLOBAL _IntSource:DWORD,_VideoIRQ:DWORD,_VerRate:DWORD

GLOBAL _IntTimerPrev:QWORD,_IntVideoPrev:QWORD,_IntSBPrev:QWORD
GLOBAL CallAddition_:NEAR

GLOBAL _CRTCReg11:DWORD
GLOBAL Pause_:NEAR

GLOBAL _LimCountMulti:DWORD,_EnvelopeMul:DWORD

GLOBAL _MouseMoveLimit:DWORD
