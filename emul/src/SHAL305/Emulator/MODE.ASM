;**************************************************************************
;
;Включение видеорежимов
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"

DATASEG
_IntRate	DD 032h
_VerRate	DD 002h

PaletteDAC	DB 0,0,0,0,0,2Ah,2Ah,0,0,2Ah,0,2Ah
		DB 0,2Ah,0,0,2Ah,2Ah,2Ah,2Ah,0,2Ah,2Ah,2Ah
		DB 0,0,3Fh,3Fh,0,0,3Fh,0,3Fh
		DB 0,3Fh,0,0,3Fh,3Fh,3Fh,3Fh,0,3Fh,3Fh,3Fh
PaletteDACGray	DB 00h,00h,00h,05h,05h,05h,0Dh,0Dh,0Dh,11h,11h,11h
		DB 19h,19h,19h,1Bh,1Bh,1Bh,25h,25h,25h,2Ah,2Ah,2Ah
		DB 07h,07h,07h,13h,13h,13h,1Ah,1Ah,1Ah
		DB 25h,25h,25h,2Ch,2Ch,2Ch,38h,38h,38h,3Fh,3Fh,3Fh

		DW 0  ;;ALIGN

TblEnvelopeMul	DD 00h,01h,03h,07h,0Fh,1Fh,3Fh,7Fh,0FFh,1FFh

UDATASEG
_EnvelopeMul	DD ? ;Параметр "Огибающая"
_GrayMode	DD ? ;Черно-белый режим
_CRTCReg11	DD ? ;Регистр 11 CRTC

CODESEG

;* Включение спектрумовского видеорежима *
ALIGN 4
PROC SetModeSpec_ NEAR
DATASEG
@@CRTCRegs	DD OFFSET @@CRTC50,OFFSET @@CRTC55
		DD OFFSET @@CRTC60,OFFSET @@CRTC75
@@CRTC50	DW 02E00h,01F01h,02502h,00D03h,02804h,08D05h,06506h
		DW 03E07h,0EE10h,08011h,07F12h,01013h,0E715h,00416h
@@CRTC55	DW 02E00h,01F01h,02502h,00D03h,02804h,08D05h,02D06h
		DW 03E07h,0C210h,08411h,07F12h,01013h,0BF15h,0DC16h
@@CRTC60	DW 01F01h,02402h,00C03h,02704h,08C05h,00B06h,03E07h
		DW 0BA10h,08C11h,07F12h,01013h,0B715h,0D416h
@@CRTC75	DW 02A00h,01F01h,02302h,00B03h,02604h,08B05h,0F206h
		DW 01F07h,0B010h,08211h,07F12h,01013h,0AD15h,0CA16h
CODESEG
		pushad
		mov	eax,[_RMInt.Adr]
		mov	[BYTE eax],001h
		mov	ebx,[_VerRate]
		mov	ebx,[@@CRTCRegs+ebx*4]
		mov	bx,[ebx+12h]
		mov	[eax+0Ch],bx
;Включение видеорежима 0Dh
		mov	[_ri.ax],0000Dh
		mov	ebx,000000010h
		call	IntRealMode_
;Синхронный reset и установка частоты.
		mov	dx,003C4h
		mov	ax,00100h
		out	dx,ax
		mov	dx,003C2h
		mov	al,0E3h
		cmp	[_VerRate],003h
		jnz	@@PixRateOk
		mov	al,0E7h
@@PixRateOk:
		out	dx,al
		mov	dx,003C5h
		mov	al,003h
		out	dx,al

;Разрешение изменения регистров CRTC 0-7.
		mov	dx,003D4h
		mov	al,011h
		out	dx,al
		inc	edx
		in	al,dx
		and	al,07Fh
		out	dx,al
		dec	edx
;Программирование CRTC.
		mov	eax,[_VerRate]
		mov	esi,[@@CRTCRegs+eax*4]
		cld
@@CicleCRTC:    lodsw
		out	dx,ax
		cmp	al,011h
		jnz	@@ControlCRTC
		mov	[WORD _CRTCReg11],ax
		mov	ebx,[_RMInt.Adr]
		mov	[ebx+0Ch],ax
@@ControlCRTC:	cmp	al,016h
		jc	@@CicleCRTC
;Установка значений палитры.
		mov	ecx,00010h
@@CiclePalette:	mov	dx,003D4h
		add	dl,006h
		in	al,dx
		mov	dx,003C0h
		lea	eax,[ecx-1]
		out	dx,al
		out	dx,al
		loopd	@@CiclePalette
;Установка значений DAC.
		mov	edx,003C8h
		mov	al,000h
		out	dx,al
		inc	edx
		mov	esi,OFFSET PaletteDAC
		cmp	[_GrayMode],000h
		jz	@@GrayOk
		add	esi,OFFSET PaletteDACGray-OFFSET PaletteDAC
@@GrayOk:	mov	ecx,0002Dh
		rep	outsb
;Установка цвета рамки
		mov	[Border],0FFh
		call	SetBorderColor_
;Установка видеостраницы
		mov	[CurrentPage],000h
		mov	al,[_EmuTable.Port7FFD]
		call	SetPage_
;Установка 2-ого режима записи.
		mov	edx,003CEh
		mov	ax,00205h
		out	dx,ax
;Установка содержимого видеопамяти
		mov	dx,003CEh
		mov	al,008h
		out	dx,al
		inc	edx
		sub	ebp,ebp
		call	@@SetScreenPage
		mov	ebp,000008000h
		call	@@SetScreenPage
		popad
		ret

PROC @@SetScreenPage NEAR
		mov	ebx,000001800h
@@Cicle:	mov	al,0FFh
		out	dx,al
		mov	edi,[TableScreen+ebx*8]
		test	ebp,ebp
		jz	@@AdrOk
		add	edi,000001800h
@@AdrOk:	mov	esi,[TableScreen+ebx*8+4]
		movzx	eax,[_SpecRAM+14000h+ebp+ebx]
		mov	cl,al
		and	al,07Fh
		mov	eax,[TableColor+eax*4]
		test	cl,[BYTE HIGH WORD HIGH FlashDetect]
		jns	@@StartSetByte
		xchg	ah,al
@@StartSetByte:	mov	[edi],al
		mov	al,[edi]
		mov	ecx,000000008h
@@CicleSetByte:	mov	al,[ebp+esi]
		add	esi,00100h
		out	dx,al
		mov	[edi],ah
		add	edi,00020h
		loopd	@@CicleSetByte
		inc	ebx
		cmp	bh,01Bh
		jc	@@Cicle
		ret
ENDP
ENDP

ALIGN 4
PROC SetModeSpecAdv_ NEAR
		pushad

;Вызов _ON_
		mov	eax,[_PrFirst+P_ON_*4]
		call	CallAddition_

		call	SetModeSpec_

;Измерение быстродействия
		cmp	[_SpeedTestDetect],000h
		jnz	@@SpeedTestOk
		call	SpeedTest_
@@SpeedTestOk:

;Установка быстродействия
		call	SpeedSet_

;Разрешение вертикального прерывания
		cmp	[_IntSource],001h
		jnz	@@NoInt
		in	al,021h
		and	al,0FBh
		out	021h,al
		in	al,0A1h
		mov	cl,[BYTE _VideoIRQ]
		mov	ch,0FDh
		rol	ch,cl
		and	al,ch
		out	0A1h,al
		mov	dx,003D4h
		mov	eax,[_RMInt.Adr]
		mov	ax,[eax+0Ch]
		or	ah,010h
		out	dx,ax
@@NoInt:

;Программирование таймера
		mov	ecx,[_EnvelopeMul]
		mov	eax,[TblEnvelopeMul+ecx*4]
		mov	[_LimCountMulti],eax
		xor	edx,edx
		mov	eax,0001234DCh
		div	[_IntRate]
		shr	eax,cl
		mov	ebx,eax
		call	NewTimer_
		shl	ebx,0Ch
		mov	[FlashUse],ebx

;Пауза чуть меньше 1/2 с
		mov	eax,009h
		call	Pause_
;Инициализация мыши
		call	MouseSetSpec_
;Инициализация файла образа диска
		mov	bl,00Ah
		call	DiskVG_
;Включение звука
		mov	ebx,00Eh
		call	SoundAY_
		popad
		ret
ENDP

;* Включение видеорежима помощи *
ALIGN 4
PROC SetModeHelp_ NEAR
		mov	eax,[_RMInt.Adr]
		mov	[BYTE eax],002h
;Выключение звука
		mov	ebx,00Fh
		call	SoundAY_
;Вызов _OFF
		mov	eax,[_PrFirst+P_OFF*4]
		call	CallAddition_
;Включение видеорежима 11h
		mov	[_ri.ax],00011h
		mov	ebx,000000010h
		jmp	IntRealMode_
ENDP

;* Включение текстового режима *
ALIGN 4
PROC SetModeText_ NEAR
		pushad
		mov	ebx,[_RMInt.Adr]
		cmp	[BYTE ebx],003h
		jz	@@Exit
		cmp	[BYTE ebx],001h
		jnz	@@Start
		cmp	[_IntSource],001h
		jnz	@@Start
		mov	dx,003D4h
		mov	eax,[_CRTCReg11]
		out	dx,ax
@@Start:	mov	[BYTE ebx],003h
;Выключение звука
		mov	ebx,00Fh
		call	SoundAY_
;Деинициализация файла образа диска
		mov	bl,00Bh
		call	DiskVG_
;Включение видеорежима 03h.
		mov	[_ri.ax],00003h
		mov	ebx,000000010h
		call	IntRealMode_
;Переключение в режим повышенной яркости
		mov	[_ri.ax],01003h
		mov	[_ri.b.l],000h
		mov	ebx,000000010h
		call	IntRealMode_
;Программирование таймера на частоту 18.2 Hz.
		xor	ebx,ebx
		call	NewTimer_
;Установка начальной скорости перемещения мыши
		call	MouseSetSpdDef_

;Вызов _OFF
		mov	eax,[_PrFirst+P_OFF*4]
		call	CallAddition_
@@Exit:		call	ScreenFill_
		popad
		ret
ENDP

UDATASEG

CODESEG
;* Программирование таймера *
ALIGN 4
PROC NewTimer_ NEAR
	mov	[_EmuTable.TimerRate],ebx
	mov	al,036h
	out	043h,al
	mov	al,bl
	out	040h,al
	mov	al,bh
	out	040h,al
	ret
ENDP

;* Инициализация таблицы адресов видеопамяти *
ALIGN 4
PROC VideoTable_ NEAR
		pushad
		mov	ecx,01800h
@@CicleSetPixel:dec	ecx
		mov	eax,ecx
		shr	ah,03h
		or	ah,018h
		and	eax,01BFFh
		add	eax,OFFSET _SpecRAM+14000h
		mov	[TableScreen+ecx*8+4],eax
		add	eax,08000h
		mov	[TableScreen+ecx*8+1B00h*8+4],eax
		lea	eax,[ecx+0A0000h]
		mov	ebx,ecx
		xchg	bh,bl
		shr	bh,05h
		shl	bl,05h
		and	eax,0AF81Fh
		or	eax,ebx
		mov	[TableScreen+ecx*8],eax
		add	ah,018h
		mov	[TableScreen+ecx*8+1B00h*8],eax
		test	ecx,ecx
		jnz	@@CicleSetPixel
		mov	ecx,00300h
@@CicleSetColor:dec	ecx
		mov	eax,ecx
		shl	ah,03h
		and	eax,018FFh
		add	eax,OFFSET _SpecRAM+14000h
		mov	[TableScreen+ecx*8+1800h*8+4],eax
		add	eax,08000h
		mov	[TableScreen+ecx*8+1800h*8+1B00h*8+4],eax
		lea	eax,[ecx+0A0000h]
		mov	ebx,ecx
		shl	ebx,03h
		mov	ah,bh
		and	eax,0A1F1Fh
		mov	[TableScreen+ecx*8+1800h*8],eax
		add	ah,018h
		mov	[TableScreen+ecx*8+1800h*8+1B00h*8],eax
		test	ecx,ecx
		jnz	@@CicleSetColor
		popad
		ret
ENDP

;* Установка цвета рамки *
ALIGN 4
PROC SetBorderColor_
UDATASEG
Border		DB ?
CODESEG
		push	eax
		mov	al,[_EmuTable.PortFE]
		and	eax,007h
		cmp	al,[Border]
		jz	@@Exit
		mov	[Border],al
		push	edx esi
;Установка цвета рамки
		mov	dx,003DAh
		in	al,dx
		mov	dx,003C0h
		mov	al,031h
		out	dx,al
		mov	al,00Fh
		out	dx,al
;Установка значений DAC.
		mov	edx,003C8h
		mov	al,00Fh
		out	dx,al
		inc	edx
		mov	al,[Border]
		lea	esi,[OFFSET PaletteDAC+eax*2+eax]
		cmp	[_GrayMode],000h
		jz	@@GrayOk
		add	esi,OFFSET PaletteDACGray-OFFSET PaletteDAC
@@GrayOk:	outsb
		outsb
		outsb
		pop	esi edx
@@Exit:		pop	eax
		ret
ENDP

;* Установка видеостраницы *
;Вход:	AL бит 3 - видеостраница
ALIGN 4
PROC SetPage_

UDATASEG
CurrentPage	DB ?

CODESEG
		push	eax edx
		shl	al,05h
		sbb	ah,ah
		and	ah,018h
		cmp	ah,[CurrentPage]
		jz	@@Exit
		mov	[CurrentPage],ah
		mov	al,00Ch
		mov	edx,003D4h
		out	dx,ax
@@Exit:		pop	edx eax
		ret
ENDP
END
