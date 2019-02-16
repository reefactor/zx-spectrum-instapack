;**************************************************************************
;
;Основной ассемблерный файл
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"

UDATASEG
_ri		RegInt<>

CODESEG

;* Обработка прерываний реального режима *
;Вход:	EBX - номер прерывания
ALIGN 4
PROC IntRealMode_ NEAR
		pushad
		xor	ecx,ecx
		mov	edi,OFFSET _ri
		mov	ax,00300h
		int	031h
		popad
		ret
ENDP

;* Шкала *
ALIGN 4
PROC ProgressView_
		pushad
		cld
		mov	edi,0000B8666h
		mov	eax,002DBh
		mov	ecx,[_Track]
		shr	cl,01h
		repnz	stosw
		jnc	@@HalfOk
		mov	al,0DDh
		stosw
@@HalfOk:	mov	cl,050h
		sub	ecx,[_Track]
		shr	cl,01h
		mov	al,020h
		repnz	stosw
		popad
		ret
ENDP

ALIGN 4
PROC DiskInit_
		call	@@DiskInit
		mov	eax,[_Drive]
		mov	[_ri.edx],eax
		mov	[_ri.ecx],00001h
		mov	[_ri.eax],00401h
		call	IntFloppyDisk_
PROC @@DiskInit
		mov	eax,[_Drive]
		mov	[_ri.d.l],al
		mov	[_ri.a.h],ah
PROC IntFloppyDisk_
		push	ebx
		mov	ebx,[_Drive]
		mov	al,[_FloppyDriveTyp+ebx]
		mov	[00490h+ebx],al
		movzx	eax,[WORD LARGE 00078h]
		movzx	ebx,[WORD LARGE 0007Ah]
		shl	ebx,04h
		add	ebx,eax
		mov	eax,04E321001h
		xchg	ax,[ebx+3]
		ror	eax,10h
		xchg	ax,[ebx+7]
		push	ebx
		mov	ebx,013h
		call	IntRealMode_
		pop	ebx
		mov	[ebx+7],ax
		shr	eax,10h
		mov	[ebx+3],ax
		mov	al,[BYTE _ri.flags]
		and	al,001h
		pop	ebx
		ret
ENDP
ENDP
ENDP

ALIGN 4
PROC DiskDataIn_
		push	edx
		mov	edx,003F4h
@@Cicle:	in	al,dx
		test	al,080h
		jz	@@Cicle
		inc	edx
		in	al,dx
		pop	edx
		ret
ENDP

ALIGN 4
PROC DiskDataOut_
		push	edx
		mov	edx,003F4h
@@Cicle:	in	al,dx
		test	al,080h
		jz	@@Cicle
		inc	edx
		mov	al,ah
		out	dx,al
		pop	edx
		ret
ENDP

;* Ожидание прерывания FDD *
;Выход:	EAX=0 Ok
;	EAX=? Прерывания не произошло
ALIGN 4
PROC DiskIntWait_
		mov	eax,[_TimeCount]
		add	eax,0A0h
@@Cicle:	test	[BYTE LARGE 0043Eh],080h
		jnz	@@IntOk
		cmp	eax,[_TimeCount]
		jnc	@@Cicle
		ret
@@IntOk:	and	[BYTE LARGE 0043Eh],07Fh
		xor	eax,eax
		ret
ENDP

;* Инициализация переменных типа дисководов *
ALIGN 4
PROC DriveTypeInit_
		mov	al,010h
		out	070h,al
		in	al,071h
		xor	al,011h
		mov	bx,05353h
		test	al,0D0h
		jnz	@@DrivAOk
		mov	bl,093h
@@DrivAOk:	test	ah,00Dh
		jnz	@@DrivBOk
		mov	bh,093h
@@DrivBOk:	mov	[WORD _FloppyDriveTyp],bx
		ret
ENDP
END
