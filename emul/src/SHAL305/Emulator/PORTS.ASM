;**************************************************************************
;
;Порты
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"

DATASEG
;Тип мыши
_MouseType	DD 1
_Beeper		DD 1
_JoyKemp	DD 1
_JoySinc	DD 1
_DblKeyKemp	DD 1
_MouseMoveLimit	DD 1

;Таблица двойных клавиш
STRUC DblKeyS
KeyLine0	DB 0
KeyMask0	DB 0
KeyLine1	DB 0
KeyMask1	DB 0
ENDS
TableDoubleKey	DblKeyS <01h,01h>,<80h,02h>,<01h,01h>,<01h,01h>
		DblKeyS <01h,01h,08h,02h>,<01h,01h,10h,01h>,<01h,01h,80h,02h>,<01h,01h,08h,01h>
		DblKeyS <01h,01h,08h,10h>,<01h,01h,10h,04h>,<01h,01h,10h,08h>,<01h,01h,10h,10h>
		DblKeyS <40h,01h>,<80h,02h,80h,08h>,<80h,02h,80h,04h>,<80h,02h,01h,08h>
		DblKeyS <80h,02h,20h,02h>,<80h,02h,20h,01h>,<80h,02h,10h,02h>,<80h,02h,10h,04h>
		DblKeyS <80h,02h,40h,08h>,<80h,02h,40h,02h>,<80h,02h,01h,02h>,<80h,02h,40h,04h>
		DblKeyS <80h,02h,40h,08h>,<80h,02h,80h,10h>,<80h,02h,01h,10h>,<01h,01h,08h,04h>
		DblKeyS <01h,01h,08h,08h>,<>,<>,<>

TblKempstonDbl	DB 0Ah,09h,06h,05h

UDATASEG
JoystickLeft	DD ?
JoystickRight	DD ?
JoystickUp	DD ?
JoystickDown	DD ?
_MouseKempXChng	DD ?
_MouseKempX	DB ?
_MouseKempY	DB ?
_MouseKempK	DB ?

CODESEG
ALIGN 4
PROC PortIn_ NEAR
;Вход:	BX - порт.
;Выход:	AL - значение.
	push	ecx edx esi edi
	mov	edx,[_PrFirst+P_IN_*4]
	test	edx,edx
	jz	@@ContinuePort
@@CicleExc:
	push	ebx edx
	call	[edx+Prc.Pr]
	pop	edx ebx
	test	ah,ah
	jnz	@@PortINP
	mov	edx,[edx+Prc.Next]
	test	edx,edx
	jnz	@@CicleExc
@@ContinuePort:
	push	ebx
	call	@@CallPort
	pop	ebx
@@PortINP:
	mov	edx,[_PrFirst+P_INP*4]
	test	edx,edx
	jz	@@Exit
@@CicleExcPost:
	push	ebx edx
	call	[edx+Prc.Pr]
	pop	edx ebx
	mov	edx,[edx+Prc.Next]
	test	edx,edx
	jnz	@@CicleExcPost
@@Exit:	pop	edi esi edx ecx
	ret

@@CallPort:	test	bl,001h
		jnz	@@PortXXXXXXX1
;Порты XXXXXXX0b: Клавиатура.
		xor	eax,eax
;Опрос аналогового джойстика.
		cmp	[_JoySinc],001h
		jnz	@@Keyboard
		cmp	[JoystickPresent],001h
		jnz	@@Keyboard
		test	bh,010h
		jnz	@@Keyboard
		push	ebx ecx edx
		call	Joystick
		mov	ah,al
		mov	al,000h
		cmp	ebx,[JoystickLeft]
		adc	al,al
		cmp	ebx,[JoystickRight]
		adc	al,al
		cmp	ecx,[JoystickDown]
		adc	al,al
		cmp	ecx,[JoystickUp]
		adc	al,al
		and	ah,030h
		sub	ah,030h
		adc	al,al
		xor	al,00Ch
		pop	edx ecx ebx
@@Keyboard:	not	bh
		mov	ah,bh
		sub	esi,esi
		mov	ebx,[_DoubleKeyPnt]
		mov	ebx,[ebx]
		cmp	[_DblKeyKemp],000h
		jnz	@@KeyDblStart
		mov	esi,[_TabKeyPnt]
		jmp	@@Begin
@@KeyDblSet:	test	ah,[esi+TableDoubleKey.KeyLine0]
		jz	@@KeyDblTwo
		or	al,[esi+TableDoubleKey.KeyMask0]
@@KeyDblTwo:	test	ah,[esi+TableDoubleKey.KeyLine1]
		jz	@@KeyDblNext
		or	al,[esi+TableDoubleKey.KeyMask1]
@@KeyDblNext:	add	esi,004h
@@KeyDblStart:	add	ebx,ebx
		jc	@@KeyDblSet
		jnz	@@KeyDblNext
		mov	esi,[_TabKeyPnt]
		jmp	@@Begin
@@Cicle:	or	al,[esi]
@@NoKey:	inc	esi
@@Begin:	add	ah,ah
		jc	@@Cicle
		jnz	@@NoKey
		not	al
		ret
@@PortXXXXXXX1:	test	bl,002h
		jnz	@@PortXXXXXX11
		cmp	bh,0E0h
		jc	@@NotUsedPort
;Порт FFFDh
		mov	eax,[_EmuTable.AY.RegIndex]
		cmp	al,00Eh
		jnc	@@NotUsedPort
		mov	al,[(_EmuTable.AY.RegData)+eax]
		ret
@@PortXXXXXX11:	mov	ah,bl
		and	ah,01Fh
		cmp	ah,01Fh
		jnz	@@NotUsedPort
;Порты XXX11111b
		cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
		jz	@@CallVGIn
		cmp	bl,01Fh
		jz	@@Kempston
		cmp	bl,0DFh
		jnz	@@NotUsedPort
		cmp	[_MouseType],001h
		jnz	@@Kempston
		cmp	bh,0FAh
		jz	@@MouseKey
		cmp	bh,0FBh
		jz	@@MouseX
		cmp	bh,0FFh
		jnz	@@Kempston
		call	MouseKemp
		xor	al,al
		sub	al,[_MouseKempY]
		ret
@@MouseX:	call	MouseKemp
		mov	al,[_MouseKempX]
		ret
@@MouseKey:	call	MouseKemp
		mov	al,[_MouseKempK]
		ret
;Порты 01Fh и 0DFh: Kempston Joystick
@@Kempston:	mov	al,000h
		cmp	[_JoyKemp],001h
		jnz	@@KempOk
		cmp	[JoystickPresent],001h
		jnz	@@KempOk
		push	ecx edx
		call	Joystick
		xor	al,030h
		test	al,030h
		pop	edx
		setnz	al
		cmp	ecx,[JoystickUp]
		adc	al,al
		cmp	ecx,[JoystickDown]
		adc	al,al
		cmp	ebx,[JoystickLeft]
		adc	al,al
		cmp	ebx,[JoystickRight]
		adc	al,al
		xor	al,005h
		pop	ecx
@@KempOk:	cmp	[_DblKeyKemp],000h
		jz	@@NoKempKey
		mov	esi,[_Port1FPnt]
		or	al,[esi]
		mov	ebx,OFFSET TblKempstonDbl-1
		mov	ah,[esi+1]
@@CicleKemp:	inc	ebx
		shr	ah,01h
		jnc	@@KeyOk
		or	al,[ebx]
@@KeyOk:        jnz	@@CicleKemp
@@NoKempKey:	ret
;Порты XXX11111b: при активном TR-DOS - ВГ.
@@CallVGIn:	shr	bl,04h
		and	bl,00Eh
		cmp	bl,008h
		jc	@@VGOk
		cmp	bl,00Eh
		jnz	@@NotUsedPort
		mov	bl,008h
@@VGOk:		call	DiskVG_
		mov	al,[_EmuTable.VG.DataIO]
		ret
;Неиспользуемый порт.
@@NotUsedPort:	mov	al,0FFh
		ret
ENDP

ALIGN 4
PROC PortOut_ NEAR
;Вход:	BX - порт.
;	AL - значение.
	push	ecx edx esi edi
	mov	edx,[_PrFirst+P_OUT*4]
	test	edx,edx
	jz	@@ContinuePort
@@CicleExc:
	push	eax ebx edx
	call	[edx+Prc.Pr]
	test	ah,ah
	pop	edx ebx eax
	jnz	@@PortOUP
	mov	edx,[edx+Prc.Next]
	test	edx,edx
	jnz	@@CicleExc
@@ContinuePort:
	push	eax ebx
	call	@@CallPort
	pop	ebx eax
@@PortOUP:
	mov	edx,[_PrFirst+P_OUP*4]
	test	edx,edx
	jz	@@Exit
@@CicleExcPost:
	push	eax ebx edx
	call	[edx+Prc.Pr]
	pop	edx ebx eax
	mov	edx,[edx+Prc.Next]
	test	edx,edx
	jnz	@@CicleExcPost
@@Exit:	pop	edi esi edx ecx
	ret

@@CallPort:
	test	bl,001h
	jnz	@@PortXXXXXXX1
;Порты XXXXXXX0b: Бордюр и Beeper
	push	eax edx
	mov	[_EmuTable.PortFE],al
	cmp	[_Beeper],001h
	jnz	@@BeeperOk
	mov	ah,al
	in	al,061h
	ror	ah,03h
	and	eax,002FDh
	or	al,ah
	out	061h,al
@@BeeperOk:
	call	SetBorderColor_
	pop	edx eax	;;;;
@@PortXXXXXXX1:
	test	bl,002h
	jz	@@PortXXXXXX0X
	mov	ah,bl
	and	ah,01Fh
	cmp	ah,01Fh
	jnz	@@Ret
;Порты XXX11111b: при активном TR-DOS - ВГ.
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jnz	@@Ret
	shr	bl,04h
	cmp	bl,008h
	jc	@@VGOk
	cmp	bl,00Fh
	jnz	@@Ret
	mov	bl,009h
@@VGOk:
	mov	[_EmuTable.VG.DataIO],al
	jmp	DiskVG_
;Порты XXXXXX0Xb: Управление памятью и AY.
@@PortXXXXXX0X:
	test	bh,080h
	jnz	@@TestAY
	test	[_EmuTable.Port7FFD],020h
	jnz	@@Ret
	mov	[_EmuTable.Port7FFD],al		;;;;al==30h
	call	SetPage_
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jnz	SetMemory_			;;;??
	call	SetMemory_
	mov	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	ret
@@TestAY:
	test	bh,040h
	jz	@@PortBFFD
	mov	[BYTE _EmuTable.AY.RegIndex],al
@@Ret:	ret
@@PortBFFD:
	mov	ebx,[_EmuTable.AY.RegIndex]
	cmp	bl,00Eh		;;;
	jnc	@@Ret
	mov	[(_EmuTable.AY.RegData)+ebx],al
	jmp	SoundAY_
ENDP

PROC SetMemory_
	mov	al,[_EmuTable.Port7FFD]
	and	eax,007h
	shl	eax,0Eh
	add	eax,OFFSET _SpecRAM
	mov	[(_EmuTable.SpecSeg)+0Ch],eax
	mov	al,[_EmuTable.Port7FFD]
	and	eax,010h
	shl	eax,0Ah
	add	eax,OFFSET _SpecROM
	mov	[_EmuTable.SpecSeg],eax
	mov	eax,[_PrFirst+P_MEM*4]
	jmp	CallAddition_
ENDP

;* Аналоговый джойстик *
UDATASEG
;Присутствие джойстика.
JoystickPresent	DB ?

CODESEG

;* Инициализация джойстика *
ALIGN 4
PROC JoystickInit_ NEAR
		pushad
		call	Joystick
		mov	[JoystickPresent],000h		;;;O
		test	bh,ch
		js	@@Ret
		mov	[JoystickPresent],001h
		mov	eax,ebx
		shr	eax,02h
		mov	[JoystickLeft],eax
		add	ebx,ebx
		sub	ebx,eax
		mov	[JoystickRight],ebx
		mov	eax,ecx
		shr	eax,02h
		mov	[JoystickUp],eax
		add	ecx,ecx
		sub	ecx,eax
		mov	[JoystickDown],ecx
@@Ret:		popad
		ret
ENDP

ALIGN 4
PROC Joystick NEAR
;Опрос джойстика.
;Выход:	AL - положение кнопок;
;	EBX - координата X;
;	ECX - координата Y;
;	BH и CH > 7Fh - джойстик не подключен.
		sub	ebx,ebx
		sub	ecx,ecx
		mov	edx,00201h
		out	dx,al
		jmp	@@Start
@@Cicle:	shr	al,1
		adc	ebx,0
		shr	al,1
		adc	ecx,0
		test	bh,ch
		js	@@Ret
@@Start:	in	al,dx
		test	al,003h
		jnz	@@Cicle
@@Ret:		ret
ENDP

UDATASEG
_DevDetect	DB ?

CODESEG
ALIGN 4
PROC MouseKemp NEAR
	test	[BYTE _DevDetect],KEMP_MOUSE
	jnz	@@Ret
	or	[BYTE _DevDetect],KEMP_MOUSE
	mov	[_ri.ax],00003h
	mov	ebx,033h
	call	IntRealMode_
	mov	al,[_ri.b.l]
	cmp	[_MouseKempXChng],000h
	jnz	@@NoXChange
	mov	ah,al
	shr	al,02h
	shr	ah,01h
	adc	al,al
	shr	ah,01h
	adc	al,al
@@NoXChange:
	and	al,007h
	xor	al,0FFh
	mov	[_MouseKempK],al

	mov	eax,[_ri.ecx]
	shr	eax,01h
	and	eax,03FFFh

	cmp	[_MouseMoveLimit],000h
	jz	@@XOk

	mov	ebx,00200h
	mov	bl,[_MouseKempX]
	sub	eax,ebx
	cmp	eax,07Fh
	jg	@@XMax
	cmp	eax,-07Fh
	jl	@@XMin

@@X:	add	eax,ebx
@@XOk:	mov	[_MouseKempX],al

	mov	eax,[_ri.edx]
	and	eax,03FFFh

	cmp	[_MouseMoveLimit],000h
	jz	@@YOk

	mov	ebx,00200h
	mov	bl,[_MouseKempY]
	sub	eax,ebx
	cmp	eax,07Fh
	jg	@@YMax
	cmp	eax,-07Fh
	jl	@@YMin

@@Y:	add	eax,ebx
@@YOk:	mov	[_MouseKempY],al

	mov	al,[_ri.c.h]
	shr	al,01h
	cmp	al,002h
	jnz	@@Correct

	cmp	[_ri.d.h],002h
	jnz	@@Correct
@@Ret:	ret

@@XMax:	mov	eax,07Fh
	jmp	@@X

@@XMin:	mov	eax,-07Fh
	jmp	@@X

@@YMax:	mov	eax,07Fh
	jmp	@@Y

@@YMin:	mov	eax,-07Fh
	jmp	@@Y

@@Correct:
	mov	[_ri.ax],00004h
	mov	eax,00200h
	mov	al,[_MouseKempX]
	add	eax,eax
	mov	[_ri.ecx],eax
	mov	ah,002h
	mov	al,[_MouseKempY]
	mov	[_ri.edx],eax
	mov	ebx,033h
	jmp	IntRealMode_
ENDP

END
