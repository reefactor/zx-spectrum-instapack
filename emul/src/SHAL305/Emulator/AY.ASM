;**************************************************************************
;
;AY-3-8910/12
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"

DATASEG
_SoundCard	DD 2 ;Установка звуковой карты
_SBAdress	DD 1 ;Установка адреса Sound Blaster
_SoundDigital	DD 1 ;Цифровой звук
_AdLibWaitState	DD 024h ;Ad Lib циклы ожидания
_SBVolume	DD 050h ;Установка громкости AY на Sound Blaster
TblAdrSB	DD 210h,220h,230h,240h,250h,260h,280h ;Порты Sound Blaster
_TblHiAdrDMA	DD 087h,083h,081h,082h ;Адреса страниц DMA

UDATASEG
_ALRegData	DB 0100h DUP (?) ;Значение регистров Ad Lib
_SBPort		DD ? ;Адрес Sound Blaster
PresentAdLib	DB ? ;Наличие AdLib, B0 - была ли проверка, B1 - наличие
PresentSndBl	DB ? ;Наличие SndBl, B0 - была ли проверка, B1 - наличие
_ALDigLevel	DB ? ;Значение уровня цифрового звука
		DB ? ;ALIGN

CODESEG
SoundAY_:
;Вход:	EBX=00h-0Dh - номер регистра AY
;	    0Eh - включение режима ZX-Spectrum
;	    0Fh - выключение режима ZX-Spectrum
;	    10h - Reset AY
;	    11h - инициализация звуковой карты
;	    12h - коррекция амплитуды огибающей
;	AL - значение (если EBX=00h-0Dh)

DATASEG
@@PrNo	DD OFFSET Ret_,OFFSET Ret_,OFFSET Ret_
	DD OFFSET Ret_,OFFSET Ret_,OFFSET Ret_
	DD OFFSET Ret_,OFFSET Ret_
	DD OFFSET Ret_,OFFSET Ret_,OFFSET Ret_
	DD OFFSET NoRegEnvFreq_,OFFSET NoRegEnvFreq_,OFFSET NoRegEnvForm_
	DD OFFSET Ret_,OFFSET Ret_
	DD OFFSET NoReset_,OFFSET Ret_,OFFSET NoEnvCorr_

@@PrAL	DD OFFSET ALRegFreq_,OFFSET ALRegFreq_,OFFSET ALRegFreq_
	DD OFFSET ALRegFreq_,OFFSET ALRegFreq_,OFFSET ALRegFreq_
	DD OFFSET Ret_,OFFSET ALRegOnOff_
	DD OFFSET ALRegLev_,OFFSET ALRegLev_,OFFSET ALRegLev_
	DD OFFSET NoRegEnvFreq_,OFFSET NoRegEnvFreq_,OFFSET ALRegEnvForm_
	DD OFFSET ALSpecOn_,OFFSET ALSpecOff_
	DD OFFSET ALReset_,OFFSET ALInit_,OFFSET ALEnvCorr_

CODESEG
	pushad
	mov	edx,[_PrFirst+P_AY_*4]
	test	edx,edx
	jz	@@Continue
@@CicleExc:
	push	eax ebx edx
	call	[edx+Prc.Pr]
	test	ah,ah
	pop	edx ebx eax
	jnz	@@Exit
	mov	edx,[edx+Prc.Next]
	test	edx,edx
	jnz	@@CicleExc
@@Continue:
	cmp	[_SoundCard],001h
;	ja	@@CardDG
	jc	@@CardNo
	call	[@@PrAL+ebx*4]
@@Exit:	popad
	ret

;@@CardDG:
;	call	[@@PrDG+ebx*4]
;	popad
;	ret

@@CardNo:
	call	[@@PrNo+ebx*4]
	popad
Ret_:	ret


;NoCard: Reset AY
NoReset_:
	mov	ecx,000000004h
@@CicleSetRegAY:
	mov	[DWORD (_EmuTable.AY.RegData)+ecx*4-4],000000000h
	loopd	@@CicleSetRegAY
	mov	[_EmuTable.AY.EnvStatus],000h
	mov	[_EmuTable.AY.EnvCurrent],07FFFFFFFh
;	mov	[(_EmuTable.AY.RegData)+07h],03Fh	;;;;;;;
	ret


;NoCard: Коррекция амплитуды огибающей
NoEnvCorr_:
DATASEG
@@EnvUD	DD OFFSET @@DD,OFFSET @@DD,OFFSET @@DD,OFFSET @@DD
	DD OFFSET @@DD,OFFSET @@DD,OFFSET @@DD,OFFSET @@DD
	DD OFFSET @@UD,OFFSET @@DD,OFFSET @@DU,OFFSET @@UU
	DD OFFSET @@DU,OFFSET @@UU,OFFSET @@DU,OFFSET @@DD
@@EnvDU	DD OFFSET @@DD,OFFSET @@DD,OFFSET @@DD,OFFSET @@DD
	DD OFFSET @@DD,OFFSET @@DD,OFFSET @@DD,OFFSET @@DD
	DD OFFSET @@UD,OFFSET @@DD,OFFSET @@UD,OFFSET @@UU
	DD OFFSET @@DU,OFFSET @@UU,OFFSET @@UD,OFFSET @@DD
CODESEG
	cmp	[_EmuTable.AY.EnvStatus],000h
	jz	@@Ret
	mov	eax,[_EmuTable.AY.EnvDelta]
	cmp	[_EmuTable.AY.EnvStatus],001h
	jz	@@AmplUp
	sub	[_EmuTable.AY.EnvCurrent],eax
	jnc	@@Ret
	mov	al,[(_EmuTable.AY.RegData)+0Dh]
	and	eax,00Fh
	jmp	[@@EnvUD+eax*4]

@@AmplUp:
	add	[_EmuTable.AY.EnvCurrent],eax
	jno	@@Ret
	mov	al,[(_EmuTable.AY.RegData)+0Dh]
	and	eax,00Fh
	jmp	[@@EnvDU+eax*4]

@@UU:	mov	[_EmuTable.AY.EnvStatus],0
	mov	[_EmuTable.AY.EnvCurrent],07FFFFFFFh
@@Ret:	ret

@@DD:	mov	[_EmuTable.AY.EnvStatus],000h
	mov	[_EmuTable.AY.EnvCurrent],00000h
	ret

@@DU:	mov	[_EmuTable.AY.EnvStatus],001h
	mov	[_EmuTable.AY.EnvCurrent],00000h
	ret

@@UD:	mov	[_EmuTable.AY.EnvStatus],002h
	mov	[_EmuTable.AY.EnvCurrent],07FFFFFFFh
	ret


;NoCard: Установка регистров R11 и R12 (частота огибающей)
NoRegEnvFreq_:
	mov	eax,000BE3E71h
	mul	[_EmuTable.TimerRate]
	mov	ebx,[DWORD (_EmuTable.AY.RegData)+00Bh]
	and	ebx,0FFFFh	;;;Opt
	jnz	@@FreqOk
	mov	ebx,000010000h
@@FreqOk:
	push	eax
	mov	eax,edx
	xor	edx,edx
	div	ebx
	test	eax,eax
	pop	eax
	jnz	@@Overflow
	div	ebx
	cmp	eax,080000000h
	jc	@@DeltaOk
@@Overflow:
	mov	eax,080000000h
@@DeltaOk:
	mov	[_EmuTable.AY.EnvDelta],eax
	ret


;NoCard: Установка регистра R13 (форма огибающей)
NoRegEnvForm_:
	test	[(_EmuTable.AY.RegData)+0Dh],004h
	jz	@@Dec
	mov	[_EmuTable.AY.EnvCurrent],00000h
	mov	[_EmuTable.AY.EnvStatus],001h
	ret
@@Dec:	mov	[_EmuTable.AY.EnvCurrent],07FFFFFFFh
	mov	[_EmuTable.AY.EnvStatus],002h
	ret


;AdLib: Инициализация звуковой карты
ALInit_:test	[PresentAdLib],001h
	jnz	@@SB
	mov	[PresentAdLib],001h
	mov	ebx,06004h
	call	ALRegSetAlw_
	mov	ebx,08004h
	call	ALRegSetAlw_
	mov	cl,al
	mov	ebx,0FF02h
	call	ALRegSetAlw_
	mov	ebx,02104h
	call	ALRegSetAlw_
	mov	ah,090h
@@CicleWaitIni:
	in	al,dx
	dec	ah
	jnz	@@CicleWaitIni
	mov	ch,al
	mov	ebx,06004h
	call	ALRegSetAlw_
	mov	ebx,08004h
	call	ALRegSetAlw_
	and	ecx,0E0E0h
	cmp	ecx,0C000h
	mov	ebx,OFFSET _TxtErAdLib
	jnz	PrintMessage_
	mov	[PresentAdLib],003h
@@SB:	test	[PresentAdLib],002h
	jz	@@Ret
	cmp	[BYTE _SoundCard],002h
	jnz	@@Ret				;No Digital
	cmp	[BYTE _SoundDigital],000h
	jnz	DGInit_
@@Ret:	ret


;AdLib: Включение режима ZX-Spectrum
ALSpecOn_:
	test	[PresentAdLib],002h
	jz	Ret_
	call	ALSpecOffB
	mov	ebx,02001h
	call	ALRegSet_		;;;??
	mov	ecx,015h+012h
@@CicleOp:
	sub	ecx,012h
@@CicleOperator:
	lea	ebx,[ecx+0201Fh]
	call	ALRegSet_		;;;??
	lea	ebx,[ecx+0FF5Fh]
	call	ALRegSet_
	lea	ebx,[ecx+00F7Fh]
	call	ALRegSet_
	cmp	ecx,015h
	jz	@@CicleOp
@@CicleCont:
	lea	ebx,[ecx+003DFh]
	call	ALRegSet_
	lea	ebx,[ecx+001BFh]
	call	ALRegSet_
	loopd	@@CicleOperator
	call	ALRegSet_
	mov	ebx,020BDh
	call	ALRegSet_
	cmp	[BYTE _SoundCard],002h
	jnz	ALSetAll_			;No Digital
	cmp	[BYTE _SoundDigital],000h
	jz	ALSetAll_
	test	[PresentSndBl],002h
	jz	ALSetAll_
	mov	ah,0D1h
	call	SBWriteDSP_
	jmp	ALSetAll_


;AdLib: Выключение режима ZX-Spectrum
ALSpecOff_:
	test	[PresentAdLib],002h
	jz	Ret_

LABEL ALSpecOffB NEAR
	sub	ebx,ebx
@@CicleClear:
	call	ALRegSetAlw_
	dec	bl
	jnz	@@CicleClear
	cmp	[BYTE _SoundCard],002h
	jnz	Ret_				;No Digital
	cmp	[BYTE _SoundDigital],000h
	jz	Ret_
	test	[PresentSndBl],002h
	jz	Ret_
	mov	bh,080h
	call	ALDigLevSet_
	mov	ah,0D3h
	jmp	SBWriteDSP_


;AdLib: Reset AY
ALReset_:
	call	NoReset_
	test	[PresentAdLib],002h
	jz	Ret_

;AdLib: Звучание карты в соответствии со значением регистров AY
ALSetAll_:
	call	NoRegEnvFreq_
	xor	ebx,ebx
	call	ALRegFreq_
	mov	ebx,002h
	call	ALRegFreq_
	mov	ebx,004h
	call	ALRegFreq_
	jmp	ALSetLevels_


;AdLib: Коррекция амплитуды огибающей
ALEnvCorr_:
	call	NoEnvCorr_
	test	[PresentAdLib],002h
	jz	Ret_

;AdLib: Установка уровней всех каналов
ALSetLevels_:
	mov	bl,008h
	call	ALSetLevTone_
	mov	bl,009h
	call	ALSetLevTone_
	mov	bl,00Ah

;AdLib: Установка уровня канала
;Вход:	BL - номер регистра уровня канала
ALSetLev_:
	call	ALSetLevTone_

;AdLib: Установка уровня шума
	xor	ebx,ebx

MACRO LevNoise Bit,Reg
LOCAL @@Cont
	test	[(_EmuTable.AY.RegData)+07h],Bit
	jnz	@@Cont
	mov	edx,Reg
	call	ALAddLev_
@@Cont:
ENDM

	LevNoise 08h,008h
	LevNoise 10h,009h
	LevNoise 20h,00Ah
	test	bh,bh
	jz	@@NoiSleep
	xor	bh,03Fh
	mov	bl,054h
	call	ALRegSet_
	mov	ebx,028BDh
	jmp	@@Cont
@@NoiSleep:
	mov	ebx,020BDh
@@Cont:
	call	ALRegSet_

;AdLib + Sound Blaster: Установка уровня цифрового звука
	cmp	[BYTE _SoundCard],002h
	jnz	Ret_				;No Digital
	cmp	[BYTE _SoundDigital],000h
	jz	Ret_
	test	[PresentSndBl],002h
	jz	Ret_
	xor	ebx,ebx

MACRO LevDig Bit,Reg
LOCAL @@Cont
	mov	al,[(_EmuTable.AY.RegData)+07h]
	and	al,Bit
	cmp	al,Bit
	jnz	@@Cont
	mov	edx,Reg
	call	ALAddLev_
@@Cont:
ENDM

	LevDig 09h,008h
	LevDig 12h,009h
	LevDig 24h,00Ah
	mov	eax,[_SBVolume]
	mul	bh
	shr	eax,06h
	add	al,080h
	mov	bh,al

;AdLib + Sound Blaster: Установка уровня цифрового звука
;Вход:	BH - значение уровня
ALDigLevSet_:
	cmp	bh,[_ALDigLevel]
	jz	Ret_
	mov	[_ALDigLevel],bh
	mov	ah,010h
	call	SBWriteDSP_
	mov	ah,bh
	jmp	SBWriteDSP_


;AdLib: Установка регистров R0-R5 (частота каналов A-C)
;Вход:	EBX - номер регистра
ALRegFreq_:
	test	[PresentAdLib],002h
	jz	Ret_
	shr	ebx,01h
	mov	ecx,[DWORD (_EmuTable.AY.RegData)+ebx*2]
	and	ecx,00FFFh
	jnz	@@FreqCor
	mov	ch,010h
@@FreqCor:
	mov	eax,00023332Eh
	mov	bh,000h
	cmp	ecx,008CEh
	jnc	@@OkFreq
	mov	eax,000119997h
	mov	bh,004h
	cmp	ecx,00468h
	jnc	@@OkFreq
	mov	eax,00008CCCCh
	mov	bh,008h
	cmp	ecx,00234h
	jnc	@@OkFreq
	mov	eax,000046666h
	mov	bh,00Ch
	cmp	ecx,0011Ah
	jnc	@@OkFreq
	mov	eax,000023333h
	mov	bh,010h
	cmp	ecx,0008Dh
	jnc	@@OkFreq
	mov	eax,000004666h
	mov	bh,01Ch
	cmp	ecx,00018h
	jnc	@@OkFreq
	mov	al,0FFh
	mov	bh,01Fh
	jmp	@@FreqSet
@@OkFreq:
	xor	edx,edx
	div	ecx
	or	bh,ah
@@FreqSet:
	mov	cl,al
	add	bl,0B0h
	movzx	eax,bl
	mov	al,[_ALRegData+eax]
	and	al,020h
	or	bh,al
	call	ALRegSet_
	mov	bh,cl
	sub	bl,010h
	jmp	ALRegSet_


;AdLib: Установка регистра R13 (форма огибающей)
ALRegEnvForm_:
	call	NoRegEnvForm_

;AdLib: Установка регистра R7 (включение/выключение каналов)
ALRegOnOff_:
	test	[PresentAdLib],002h
	jnz	ALSetLevels_
	ret


;AdLib: Установка регистров R8-R10 (уровни каналов A-C)
ALRegLev_:
	test	[PresentAdLib],002h
	jnz	ALSetLev_
	ret


;AdLib: Установка уровня канала
;Вход:	BL - номер регистра AY, соответствующего номеру канала
ALSetLevTone_:
	and	ebx,003h
	mov	cl,bl
	mov	al,[(_EmuTable.AY.RegData)+07h]
	ror	al,cl
	xor	cl,cl
	test	al,001h
	jnz	@@SetKey
	mov	al,[(_EmuTable.AY.RegData)+08h+ebx]
	test	al,010h
	jnz	@@Env
	and	eax,00Fh
	mov	edx,eax
	shr	edx,02h
	lea	eax,[eax*4+edx]
	test	eax,eax
	jz	@@SetKey
	jmp	@@ContLevTone
@@Env:
	mov	al,[BYTE HIGH WORD HIGH _EmuTable.AY.EnvCurrent]
	and	eax,07Fh
	shr	eax,01h
@@ContLevTone:
	push	ebx
	add	ebx,03F40h
	sub	bh,al
	call	ALRegSet_
	pop	ebx
	mov	cl,020h
@@SetKey:
	add	bl,0B0h
	mov	bh,[_ALRegData+ebx]
	and	bh,0DFh
	or	bh,cl

;AdLib: Установка регистра звуковой карты
;Вход:	BL - порт
;	BH - значение
;Выход:	AL - статус AdLib
ALRegSet_:
	movzx	eax,bl
	cmp	bh,[_ALRegData+eax]
	jz	RetAL

;AdLib: Установка регистра звуковой карты без проверки текущего значения
ALRegSetAlw_:
	movzx	eax,bl
	mov	[_ALRegData+eax],bh
	mov	edx,00388h
	out	dx,al
REPT 6
	in	al,dx
ENDM
	inc	edx
	mov	al,bh
	out	dx,al
	dec	edx
	mov	ah,[BYTE _AdLibWaitState]
@@CicleWait:
	in	al,dx
	dec	ah
	jnz	@@CicleWait
RetAL:	ret


;AdLib: Добавление уровня очередного канала
;Вход:	EBX - текущий уровень
;	EDX - номер регистра уровня
;Выход:	EBX - новый уровень
ALAddLev_:
	mov	al,[(_EmuTable.AY.RegData)+edx]
	test	al,010h
	jnz	@@Env
	and	eax,00Fh
	mov	edx,eax
	shr	edx,02h
	lea	eax,[eax*4+edx]
	jmp	@@Calk
@@Env:
	mov	al,[BYTE HIGH WORD HIGH _EmuTable.AY.EnvCurrent]
	and	eax,07Fh
	shr	eax,01h
@@Calk:
	mov	edx,000003F80h
	sub	edx,ebx
	mul	edx
	mov	dl,00Dh
	mul	edx
	shr	eax,0Ah
	add	ebx,eax
	ret


;Wave: Инициализация звуковой карты
DGInit_:mov	eax,[_SBAdress]
	mov	edx,[TblAdrSB+eax*4]
	cmp	edx,[_SBPort]
	jz	@@TestNeedNot
	mov	[_SBPort],edx
	mov	[PresentSndBl],000h

@@TestNeedNot:
	test	[PresentSndBl],001h
	jnz	Ret_
	mov	[PresentSndBl],001h

	add	edx,006h	;2x6
	mov	al,001h
	out	dx,al
	add	edx,008h	;2xE
REPT 6
	in	al,dx
ENDM
	sub	edx,008h	;2x6
	mov	al,000h
	out	dx,al
	call	SBReadDSP_
	jz	@@SndBlEr
	cmp	al,0AAh
	jz	@@SndBlOk
	call	SBReadDSP_
	jz	@@SndBlEr
	cmp	al,0AAh
	jnz	@@SndBlEr

@@SndBlOk:
	mov	[PresentSndBl],003h
	ret

@@SndBlEr:
	mov	ebx,OFFSET _TxtErSndBl

PrintMessage_:
	mov	edx,OFFSET _TxtNul
	mov	eax,04Fh
	jmp	MessageBox_

;Sound Blaster: Запись байта в DSP
;Вход:	AH - записываемый байт
;Выход: ZF=1 - успешно, ZF=0 - ошибка
SBWriteDSP_:
	mov	edx,[_SBPort]
	add	edx,00Ch	;2xC
	mov	ecx,00400h
@@Cicle:
	in	al,dx
	test	al,080h
	loopdnz	@@Cicle
	jnz	@@Ret
	mov	al,ah
	out	dx,al
@@Ret:	ret

;Sound Blaster: Чтение байта из DSP
;Выход: AL - считанный байт
;	ZF=0 - успешно, ZF=1 - ошибка
SBReadDSP_:
	mov	edx,[_SBPort]
	add	edx,00Eh	;2xE
	mov	ecx,00400h
@@Cicle:
	in	al,dx
	test	al,080h
	loopdz	@@Cicle
	jz	@@Ret
	sub	edx,004h	;2xA
	in	al,dx
@@Ret:	ret

END
