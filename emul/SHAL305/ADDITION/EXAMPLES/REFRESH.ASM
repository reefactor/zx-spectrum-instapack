;*********************************************************************
;
;Обновление экрана для мультизадачных систем
;
;*********************************************************************

;В некоторых мультизадачных системах на некоторых видеокартах происходит
;некорректное восстановление нестандартного видеорежима эмулятора.
;Данный модуль - поддержка горячей клавиши обновления экрана.

IDEAL
P386
MODEL USE32 SMALL
ASSUME cs:@code,ds:@data,es:@data
INCLUDE "EMUDATA.INC"

DATASEG

LABEL _DSC BYTE ;Описание
	DB "Обновление экрана",0

;Строки для конфигурации
TxtCfgKey	DB "Key=",0
TxtCfgF7	DB "F7",0
TxtCfgF8	DB "F8",0
TxtCfgF9	DB "F9",0
TxtCfgF10	DB "F10",0
TxtCfgF11	DB "F11",0
TxtCfgF12	DB "F12",0

;Данные конфигурации
TblTCKey	DD OFFSET TxtCfgF7,OFFSET TxtCfgF8,OFFSET TxtCfgF9
		DD OFFSET TxtCfgF10,OFFSET TxtCfgF11,OFFSET TxtCfgF12

CfgKey		CnTbl <OFFSET Key,OFFSET TblTCKey,6>

;Таблица конфигурации
CfgTable	CfgS <TTbl,OFFSET TxtCfgKey,OFFSET CfgKey>

;Данные о конфигурации
_CFG		CfgDat <OFFSET CfgTable,1>

;Строки для интерфейса
TxtKey		DB 1,"Клавиша",0Ah,"F7",0Ah,"F8",0Ah,"F9",0Ah
		DB "F10",0Ah,"F11",0Ah,"F12",0
TxtOk		DB 1,"OK",0
TxtCancel	DB "О",1,"тмена",0

UDATASEG
TblData		DD ? ;Адрес таблицы данных эмулятора
Key		DD ? ;Рабочая клавиша

CODESEG

;Инициализация (сохранение адреса данных эмулятора)
PROC _INI
	mov	[TblData],eax
	ret
ENDP

;Конфигурирование
UDATASEG
WinPnt		DD ? ;Адрес данных панели диалога
CODESEG

PROC _SET
	push	ebp

;Создание окна
	mov	ebp,[TblData]
	MWinCreate ebp,016h,005h,01Fh,00Dh,01Fh
	mov	[WinPnt],eax ;Сохранение адреса данных окна

;Установка заголовка окна
	MWinTitle ebp,eax,<OFFSET _DSC>,0F0h

;Установка переключателя "Клавиша"
	MSetRadio ebp,[WinPnt],006h,002h,<OFFSET TxtKey>,<OFFSET CfgKey>

;Установка кнопки "Отмена"
	MSetButton ebp,[WinPnt],011h,00Ah,00Ah,<OFFSET TxtCancel>,0

;Установка кнопки "OK"
	MSetButton ebp,[WinPnt],004h,00Ah,00Ah,<OFFSET TxtOk>,1

;Обработка окна
	MWinExe ebp,[WinPnt]

;Проверка результата окна
	test	eax,eax
	jz	@@Exit

;Сохранение установок окна
	MWinResult ebp,[WinPnt]

;Удаление окна
@@Exit:	MWinRemove ebp,[WinPnt]

	pop	ebp
	ret

ENDP

;Обработка клавиш
MACRO KeyProc KeyP,Num
PROC KeyP
	cmp	[Key],Num ;Проверка: эта ли клавиша выбрана ?
	jz	Refresh
	ret
ENDP
ENDM

	KeyProc _F7_,000h
	KeyProc _F8_,001h
	KeyProc _F9_,002h
	KeyProc _F10,003h
	KeyProc _F11,004h
	KeyProc _F12,005h

PROC Refresh
	mov	eax,[TblData]
	jmp	[eax+EmuData.SpecMode]
ENDP

END
