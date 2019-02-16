;**************************************************************************
;
;Обработчики прерываний
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"

PUBLIC IntRMProc,_EndRM,_IntKeyPrev
PUBLIC IntVideo16_,_IntVideoPrev16
PUBLIC IntTimer_,IntVideo_,IntKey_
PUBLIC _IntDetect,_Keys
PUBLIC _Port1F,_TabKey,_DoubleKey

UDATASEG
CurrentInt	DW ?

CODESEG
ALIGN 4
PROC IntTimer_ FAR
	push	eax ds
	mov	eax,DGROUP
	mov	ds,ax

	mov	eax,[_RMInt.Adr]
ASSUME ds:_TEXT16
	or	[BYTE _TEXT16:_IntDetect+eax+3],080h
ASSUME ds:DGROUP

	mov	eax,[_EmuTable.TimerRate]
	test	eax,eax
	jz	@@ExitInt
	add	[CurrentInt],ax
	jc	@@ExitInt
	mov	al,020h
	out	020h,al
	pop	ds eax
	iretd

@@ExitInt:
	inc	[_TimeCount]
	pop	eax
	push	[DWORD _IntTimerPrev] eax
	mov	eax,[DWORD _IntTimerPrev+4]
	xchg	eax,[esp+8]
	pop	ds
	retf
ENDP

ALIGN 4
PROC IntVideo_ FAR
	push	eax edx ds
	mov	eax,DGROUP
	mov	ds,ax
	mov	edx,003C2h
	in	al,dx
	test	al,080h
	jz	@@ExitInt
	mov	eax,[_RMInt.Adr]
ASSUME ds:_TEXT16
	or	[BYTE _TEXT16:_IntDetect+eax+3],040h
ASSUME ds:DGROUP
	mov	edx,003D4h
	in	al,dx
	push	eax
	mov	eax,[_CRTCReg11]
	out	dx,ax
	or	ah,010h
	out	dx,ax
	pop	eax
	out	dx,al
	mov	al,020h
	out	020h,al
	mov	al,020h
	out	0A0h,al
	pop	ds edx eax
	iretd

@@ExitInt:
	mov	eax,[DWORD _IntVideoPrev+4]
	mov	edx,[DWORD _IntVideoPrev]
	pop	ds
	xchg	edx,[esp]
	xchg	eax,[esp+4]
	retf
ENDP
ENDS

ASSUME cs:_TEXT16,ds:_TEXT16

SEGMENT _TEXT16 PARA 'CODE' USE16
PROC IntRMProc FAR
@@VideoMode	DB 0
@@ExtKey	DB 0
_Port1F		DB 0,0
_IntKeyPrev	DD 0
;Индикатор прерывания
;Бит 00h - Esc (Exit)
;Бит 01h - F1 (Help)
;Бит 09h - F5 (Disks)
;Бит 0Fh - Trace
;Бит 10h - F9
;Бит 11h - F10
;Бит 12h - F11
;Бит 13h - F12
;Бит 14h - F7
;Бит 15h - F8
;Бит 18h - Int (Выключается после обнуления счетчика длительности Int)
;Бит 1Ah - F3 (Reset 128h)
;Бит 1Bh - F2 (Reset 48h)
;Бит 1Ch - F4 (Reset TR-DOS)
;Бит 1Dh - Int (Обратный ход луча)
;Бит 1Eh - Int (Вертикальное прерывание видеокарты)
;Бит 1Fh - Int (Прерывание таймера)
_IntDetect	DD 0

_CRTC11		DW 0	;Смещение 0Ch

_TabKey		DB 8 DUP (0)
_DoubleKey	DD 0
_IntVideoPrev16	DD 0
;Таблица клавиш
STRUC KeyStr
BitMask		DB 0
AdrKeyDetect	DW 0
ENDS
@@TableKey	KeyStr <>,<01h,OFFSET _IntDetect>
		KeyStr <01h,OFFSET _TabKey+4>,<02h,OFFSET _TabKey+4>,<04h,OFFSET _TabKey+4>,<08h,OFFSET _TabKey+4>,<10h,OFFSET _TabKey+4>,<10h,OFFSET _TabKey+3>,<08h,OFFSET _TabKey+3>,<04h,OFFSET _TabKey+3>,<02h,OFFSET _TabKey+3>,<01h,OFFSET _TabKey+3>,<08h,OFFSET _DoubleKey+1>,<04h,OFFSET _DoubleKey+1>,<04h,OFFSET _DoubleKey+3>,<02h,OFFSET _DoubleKey+3>
		KeyStr <01h,OFFSET _TabKey+5>,<02h,OFFSET _TabKey+5>,<04h,OFFSET _TabKey+5>,<08h,OFFSET _TabKey+5>,<10h,OFFSET _TabKey+5>,<10h,OFFSET _TabKey+2>,<08h,OFFSET _TabKey+2>,<04h,OFFSET _TabKey+2>,<02h,OFFSET _TabKey+2>,<01h,OFFSET _TabKey+2>,<10h,OFFSET _DoubleKey+1>,<20h,OFFSET _DoubleKey+1>,<01h,OFFSET _TabKey+1>,<01h,OFFSET _TabKey+7>,<01h,OFFSET _TabKey+6>,<02h,OFFSET _TabKey+6>
		KeyStr <04h,OFFSET _TabKey+6>,<08h,OFFSET _TabKey+6>,<10h,OFFSET _TabKey+6>,<10h,OFFSET _TabKey+1>,<08h,OFFSET _TabKey+1>,<04h,OFFSET _TabKey+1>,<02h,OFFSET _TabKey+1>,<80h,OFFSET _DoubleKey+1>,<40h,OFFSET _DoubleKey+1>,<01h,OFFSET _DoubleKey+3>,<20h,OFFSET _DoubleKey+3>,<02h,OFFSET _DoubleKey+1>,<02h,OFFSET _TabKey+7>,<04h,OFFSET _TabKey+7>,<08h,OFFSET _TabKey+7>,<10h,OFFSET _TabKey+7>
		KeyStr <10h,OFFSET _TabKey>,<08h,OFFSET _TabKey>,<04h,OFFSET _TabKey>,<04h,OFFSET _DoubleKey+2>,<02h,OFFSET _DoubleKey+2>,<01h,OFFSET _DoubleKey+2>,<10h,OFFSET _DoubleKey+3>,<40h,OFFSET _DoubleKey>,<02h,OFFSET _TabKey>,<01h,OFFSET _TabKey>,<08h,OFFSET _DoubleKey+3>,<02h,OFFSET _IntDetect>,<08h,OFFSET _IntDetect+3>,<04h,OFFSET _IntDetect+3>,<10h,OFFSET _IntDetect+3>,<20h,OFFSET _IntDetect>
		;40
		KeyStr <>,<10h,OFFSET _IntDetect+2>,<20h,OFFSET _IntDetect+2>
		;43
		KeyStr <01h,OFFSET _IntDetect+2>,<02h,OFFSET _IntDetect+2>,<>,<>,<01h,OFFSET _Port1F+1>,<08h,OFFSET _Port1F>,<02h,OFFSET _Port1F+1>,<80h,OFFSET _DoubleKey>,<02h,OFFSET _Port1F>,<10h,OFFSET _Port1F>,<01h,OFFSET _Port1F>,<01h,OFFSET _DoubleKey+1>,<04h,OFFSET _Port1F+1>
		;50
		KeyStr <04h,OFFSET _Port1F>,<08h,OFFSET _Port1F+1>,<>,<>,<>,<>,<>,<04h,OFFSET _IntDetect+2>,<08h,OFFSET _IntDetect+2>,<>,<>,<80h,OFFSET _DoubleKey+2>,<>,<>,<>,<>
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		;E0 00
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>
		;E0 18
		KeyStr <>,<>,<>,<>,<08h,OFFSET _DoubleKey+2>,<80h,OFFSET _DoubleKey+3>,<>,<>
		;E0 20
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		;E0 30
		KeyStr <>,<>,<>,<>,<>,<20h,OFFSET _DoubleKey>,<>,<>,<40h,OFFSET _DoubleKey+3>,<>,<>,<>,<>,<>,<>,<>
		;E0 40
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>
		;E0 48
		KeyStr <20h,OFFSET _DoubleKey+2>,<10h,OFFSET _DoubleKey>,<>,<80h,OFFSET _DoubleKey+2>,<>,<40h,OFFSET _DoubleKey+2>,<>,<>
		;E0 50
		KeyStr <10h,OFFSET _DoubleKey+2>,<08h,OFFSET _DoubleKey>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>
		KeyStr <>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>,<>

_Keys		DB 20h DUP (0)

IntKey_:	pushf
		cmp	ah,04Fh
		jnz     @@ExitFromInt
		push	ax ebx cx si ds
		push	cs
		pop	ds
		cmp	[@@ExtKey],0E1h
		jz	@@PauseKey
		cmp	[@@ExtKey],0E0h
		setz	ah
		mov	[@@ExtKey],al
		ror	ah,01h
		mov	bl,al
		and	ebx,07Fh
		or	bl,ah
		mov	si,bx
		shr	si,03h
		mov	cl,bl
		mov	ch,001h
		and	cl,007h
		rol	ch,cl
		mov	ah,[BYTE @@TableKey+ebx*2+ebx]
		mov	bx,[WORD @@TableKey+ebx*2+ebx+1]
		or	[_Keys+si],ch
		or	[bx],ah
		test	al,080h
		jz	@@PopAndJump
		not	ah
		and	[bx],ah
		not	ch
		and	[_Keys+si],ch
@@PopAndJump:   cmp	[BYTE @@VideoMode],001h
		pop	ds si cx ebx ax
		jz	@@ExitEmul
@@ExitFromInt:	popf
		jmp	SMALL [DWORD cs:_IntKeyPrev]
@@PauseKey:	and	al,07Fh
		cmp	al,045h
		jnz	@@PopAndJump
		mov	[BYTE @@ExtKey],000h
		jmp	@@PopAndJump
@@ExitEmul:	popf
		clc
		retf	2

IntVideo16_:	push	ax dx
		mov	dx,003C2h
		in	al,dx
		test	al,080h
		jz	@@ExitIntVideo
		or	[BYTE cs:_IntDetect+3],040h
		mov	dx,003D4h
		in	al,dx
		push	ax
		mov	ax,[cs:_CRTC11]
		out	dx,ax
		or	ah,010h
		out	dx,ax
		pop	ax
		out	dx,al
		mov	al,020h
		out	020h,al
		mov	al,020h
		out	0A0h,al
		pop	dx ax
		iret
@@ExitIntVideo:	pop	dx ax
		jmp	SMALL [DWORD cs:_IntVideoPrev16]
LABEL _EndRM
ENDP
ENDS

END
