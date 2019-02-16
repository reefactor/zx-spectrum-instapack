;Begin

IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE "..\EMUDATA.INC"

DATASEG
LABEL _DSC BYTE
		db "Screen Grabber [H,"
KeyPreview	db "Fxx]",0,"By Hexman/BYTEX",0

;Ключи конфигурации
TxtCfgKey	db "SGrabKey=",0
TxtCfgFile	db "SGrabFile=",0
TxtCfgType	db "SGrabType=",0
TxtCfgF7	db "F7",0
TxtCfgF8	db "F8",0
TxtCfgF9	db "F9",0
TxtCfgF10	db "F10",0
TxtCfgF11	db "F11",0
TxtCfgF12	db "F12",0
TxtCfgTypeHob	db "Hobeta",0
TxtCfgTypeScr	db "Dump",0
TxtCfgKeys	db "F7] F8] F9] F10]F11]F12]"

MemAdr		dd 0
Hobeta		dd 0
TblData 	dd ? ;Адрес таблицы данных эмулятора
WinPnt		dd ? ;Адрес данных окна
Key		dd ?

;Данные о конфигурации
_CFG		CfgDat <OFFSET CfgTable,3>
CfgTable	CfgS <TTxt,OFFSET TxtCfgFile,OFFSET CfgScr>
		CfgS <TTbl,OFFSET TxtCfgKey,OFFSET CfgKey>
		CfgS <TTbl,OFFSET TxtCfgType,OFFSET CfgHobeta>
CfgScr		CnTxt <OFFSET ParamSav,20>
CfgKey		CnTbl <OFFSET Key,OFFSET TblTCKey,6>
CfgHobeta	CnTbl <OFFSET Hobeta,OFFSET TblTCHob,2>
TblTCKey	dd OFFSET TxtCfgF7,OFFSET TxtCfgF8,OFFSET TxtCfgF9
		dd OFFSET TxtCfgF10,OFFSET TxtCfgF11,OFFSET TxtCfgF12
TblTCHob	dd OFFSET TxtCfgTypeHob,TxtCfgTypeScr
ParamSav	db "screen.scr",0
		db 9 dup (?)


;Строки для интерфейса
TxtTitle	db "Screen Grabber",0
TxtOk		db 1,"OK",0
TxtCancel	db 1,"Cancel",0
TxtHelp 	db "Screen Grabber",10,"(c) Hexman/BYTEX, 2:469/32.7@Fidonet",0
TxtHobeta	db 1,"File type",10,"Hobeta",10,"Dump",0
TxtKey		db 1,"Key",0Ah,"F7",0Ah,"F8",0Ah,"F9",0Ah,"F10",0Ah,"F11",0Ah,"F12",0
TxtFile 	db 1,"File Name:",0

CODESEG

;Инициализация
PROC _INI
	mov	[TblData],eax
	ret
_INS:	mov	ax,[WORD Key]
	mov	ebx,OFFSET TxtCfgKeys
	add	ax,ax
	add	ax,ax
	add	bx,ax
	mov	ecx,OFFSET KeyPreview
	mov	dx,4
_INS1:	mov	al,[ebx]
	mov	[ecx],al
	inc	ebx
	inc	ecx
	dec	dx
	cmp	dx,0
	jnz	_INS1

	mov	al,[BYTE Hobeta]
	test	al,al
	mov	ah,'D'
	jnz	_INS2
	mov	ah,'H'
_INS2:	mov	[OFFSET KeyPreview-2],ah
	ret
ENDP


;Обработка клавиш
MACRO KeyProc KeyP,Num
PROC KeyP
	cmp	[Key],Num
	jz	Action
	ret
ENDP
ENDM
	KeyProc _F7_,000h
	KeyProc _F8_,001h
	KeyProc _F9_,002h
	KeyProc _F10,003h
	KeyProc _F11,004h
	KeyProc _F12,005h

;Конфигурирование

PROC _SET
	push	ebp

	;Создание окна
	mov ebp,[TblData]
	MWinCreate ebp,27,6,25,11,01Fh
	mov [WinPnt],eax

	MWinTitle ebp,eax,<OFFSET TxtTitle>,0F0h
	MWinHelp ebp,[WinPnt],44,6,<OFFSET TxtHelp>

	MSetButton ebp,[WinPnt],11,8,00Ah,<OFFSET TxtCancel>,0
	MSetButton ebp,[WinPnt],11,6,00Ah,<OFFSET TxtOk>,1
	MSetRadio ebp,[WinPnt],11,2,<OFFSET TxtHobeta>,<OFFSET CfgHobeta>
	MSetRadio ebp,[WinPnt],2,2,<OFFSET TxtKey>,<OFFSET CfgKey>

	;Обработка окна
	MWinExe ebp,[WinPnt]

	;Проверка результата окна
	test	eax,eax
	jz	@@Sxt

	;Сохранение результата окна
	MWinResult ebp,[WinPnt]
@@Sxt:	MWinRemove ebp,[WinPnt]
	pop ebp
	ret

Action:
	push	ebp
	mov	ebp,[TblData]
	call	[ebp+EmuData.TextMode]

	;Создание окна
	mov ebp,[TblData]
	MWinCreate ebp,27,5,26,8,31
	mov [WinPnt],eax

	MWinTitle ebp,eax,<OFFSET TxtTitle>,0F0h

	MSetButton ebp,[WinPnt],14,5,10,<OFFSET TxtCancel>,0
	MSetButton ebp,[WinPnt],2,5,10,<OFFSET TxtOk>,1
	MSetInputTxt ebp,[WinPnt],2,2,22,<OFFSET TxtFile>,<OFFSET CfgScr>
	mov [MemAdr],eax

	;Обработка окна
	MWinExe ebp,[WinPnt]
	test	eax,eax
	jz	@@Exit

	;Сохранение результата окна
	MWinResult ebp,[WinPnt]

	;■■■ создание файла ■■■

	mov	ebp,[TblData]
	mov	eax,6929
	call	[ebp+EmuData.MemAlloc]
	test	eax,eax
	jz	@@Exit
	mov	[MemAdr],eax

	;создание заголовка hobeta-файла
	mov	cx,8
	mov	ebx,[MemAdr]
	mov	edx,OFFSET ParamSav
	push	ebx
@@Hob1: mov	al,[edx]
	test	al,al
	jz	@@Hob2
	mov	[ebx],al
	inc	ebx
	inc	edx
	dec	cx
	jnz	@@Hob1
	jmp	@@Hob4
@@Hob2: mov	al," "
@@Hob3: mov	[ebx],al
	inc	ebx
	dec	cx
	jnz	@@Hob3
@@Hob4: pop	ebx
	push	ebx
	mov	al,"C"
	mov	[ebx+8],al ;тип
	mov	ax,16384
	mov	[ebx+9],ax ;адрес
	mov	ax,6912
	mov	[ebx+11],ax ;длина
	mov	ax,27
	mov	[ebx+14],ax ;объём

	;S=S+257*Di+i
	mov	edx,ebx
	xor	cx,cx		;счётчик
	xor	bx,bx		;сумма
@Sum:	mov	al,[edx]
	mov	ah,al		;ax=257*Di
	add	ax,cx		;ax=257*Di+i
	inc	cx
	add	bx,ax		;bx=bx+257*Di+i
	inc	edx
	cmp	cx,15
	jnz	@Sum
	mov	ax,bx
	pop	ebx
	mov	[ebx+15],eax
	add	ebx,17
	push	ebx


	mov	ebx,[TblData]
	mov	al,[ebp+EmuData.Port7FFD]
	mov	edx,14000h
	and	al,8
	jz	@@Low
	mov	edx,1C000h
@@Low:	mov	ecx,[ebp+EmuData.SpecRAM]
	add	edx,ecx
       ;mov	edx,[(ebp+EmuData.SpecSeg)+04h] ;адрес картинки
	pop	ebx
	mov	cx,6912
@@Hob5: mov	al,[edx]
	mov	[ebx],al
	inc	ebx
	inc	edx
	dec	cx
	jnz	@@Hob5

	mov	ah,3Ch ;create file
	mov	cx,00
	mov	edx,OFFSET ParamSav
	int	21h
	jc	@@Exit

	push	ax
	mov	bx,ax

	mov	al,[BYTE Hobeta]
	mov	edx,[MemAdr]
	mov	ecx,6929
	or	al,al
	jz	@@Save
	add	edx,17
	mov	ecx,6912

@@Save: mov	ah,40h ;write to file
	int	21h

	pop	bx
	mov	ah,3Eh ;закрытие файла
	int	21h

	mov	[MemAdr],eax
	call	[ebp+EmuData.MemFree]

;Удаление окна
@@Exit: mov	eax,[WinPnt]
	call	[ebp+EmuData.WinRemove]
	mov	ebp,[TblData]
	call	[ebp+EmuData.SpecMode]
	mov	ebp,[TblData]
	call	[ebp+EmuData.SetSpec]
	pop	ebp
	ret
ENDP

END
