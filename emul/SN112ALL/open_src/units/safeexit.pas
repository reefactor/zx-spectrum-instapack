{$A-,B-,D-,E-,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X-,Y-}
{****************************************************}
{***	Модуль приличного вылетания при ошибке	  ***}
{***	его желательно подклячать в Uses первым   ***}
{*** Сергей Петрухин, Курск, 2:5035/18.33@FidoNet ***}
{**************************************************}
Unit SafeExit; interface

const MaxLenExitMsg = 52;      { максимальная длина титров программы   }
const ExitMsg : ^string = nil; { титульная строка программы при выходе }

implementation      {╔═════════════════════════╗}


const
   fCrLf    = #$0D;   { признак перехода к новой строке }
   fColor   = #$26;   { признак изменения цвета 	}

		      { цвета				}
   cTitle   ={#$FE}4*16+15;   {      титульная строка окна	}
   cNormal  = #$4F;   {      нормальный текст		}
   cPRGName = #$4B;   {      имя программы		}
   cErrCode = #$4A;   {      номер ошибки		}
   cAnyKey  = 4*16+15;   {      сообщение про Enter	}

   kbEnter  = $1C0D;  { код клавиши Enter		}
   MSGWidth = 56;     { ширина окна сообщения		}

const
   OldExit : pointer = nil;

procedure NewExit; far; assembler;
{$IFDEF DPMI}
const cS1 = fColor+cTitle+
	   '╔══════════════════ A t t e n t i o n ═════════════════╗'+fCrLf+
	   fColor+cNormal+'║ '+fColor+cPrgName;
      cS2 ='                                                    '+
	   fColor+cNormal+' ║'+fCrLf+
	   '╟──────────────────────────────────────────────────────╢'+fCrLf+
	   '║     Internal error '+fColor+cErrCode;
      cS3 ='XXX'+
	   fColor+cNormal+'.'+fColor+cAnyKey+'       Please, press Enter ...  '+
	   fColor+cNormal+'║'+fCrLf+
	   '╚══════════════════════════════════════════════════════╝'+#0;
const
    MSG : array[1..Length(cS1)] of char = cS1;
    Tit : array[1..Length(cS2)] of char = cS2;
    ENo : array[1..Length(cS3)] of char = cS3;

asm
{$ELSE}
    label MSG,Tit,ENo;
asm
   jmp	    @M0
MSG:
   db	 fColor,cTitle
   db	 '╔═════════════════ A t t e n t i o n ! ════════════════╗',fCrLf
   db	 fColor,cNormal,'║ ',fColor,cPrgName
Tit:
   db	 '                                                    '
   db	 fColor,cNormal,' ║',fCrLf
{   db	   '╟──────────────────────────────────────────────────────╢',fCrLf}
   db	   '║     Internal error ',fColor,cErrCode
ENo:
   db	 'XXX'
   db	 fColor,cNormal,'.',fColor,cAnyKey,'  Please, press Enter ...     '
   db	 fColor,cNormal,'║',fCrLf
   db	 fColor,cNormal,'║ ',fColor,cPrgName
   db	 '                                                    '
   db	 fColor,cNormal,' ║',fCrLf
   db	 '╚══════════════════════════════════════════════════════╝',0;
@M0:
{$ENDIF}




   mov	  ax,Seg @Data		{ на случай, если в программе	}
   mov	  ds,ax 		{ испорчен ds			}
   mov	  ax,ErrorAddr.word[0]	{ проверка наличия ошибки	}
   or	  ax,ErrorAddr.word[2]
   jz	  @M8
db 66h
   xor	  ax,ax 		{ сброс ошибки			}
db 66h
   mov	  ErrorAddr.word,ax
   mov	  ax,ExitCode		{ преобразование ExitCode	}
   aam
   add	  al,'0'
   mov	  ENo.byte[2],al
   mov	  al,ah
   aam
   add	  ax,'00'
   xchg   al,ah
   mov	  ENo.word[0],ax

   push   ds			{ запись наименования программы }
   lds	  si,ExitMsg
   mov	  ax,ds
   or	  ax,si
   jz	  @M2			{ если адрес nil - нет строки	}
   cld
   lodsb
   xor	  cx,cx
   mov	  cl,al
   jcxz   @M2			{ если длина 0 - нет строки	}
   cmp	  cl,MaxLenExitMsg
   jbe	  @M1
   mov	  cl,MaxLenExitMsg	{ ограничить длинну строки	}
@M1:
   mov	  di,Seg Tit
   mov	  es,di
   lea	  di,Tit
   mov	  ax,MaxLenExitMsg
   sub	  al,cl
   shr	  ax,1
   add	  di,ax 		{ строка пишется по центру	}
   rep	  movsb 		{ переписать строку		}
@M2:
   pop	  ds

   mov	  ah,0Fh
   int	  10h
{}
   xor	  ah,ah{}
   mov	  es,SegB000
   cmp	  al,7
   je	  @M21
   mov	  al,3{}
   mov	  es,SegB800{}
@M21:
{
   int	  10h
{}
   mov	  di,(10*80+(80-MSGWidth)/2)*2 { вывод сообщения на экран      }
   lea	  si,MSG
   mov	  ah,cNormal

  mov ah,1
  mov ch,32
  mov cl,14
  Int 10h      {Cursor OFF}

@M3:
{$IFNDEF DPMI}
   SegCS
{$ENDIF}
   lodsb
   or	  al,al
   jz	  @M6
   cmp	  al,fColor
   jne	  @M4
{$IFNDEF DPMI}
   SegCS
{$ENDIF}
   lodsb
   mov	  ah,al
   jmp	  @M3
@M4:
   cmp	  al,fCrLf
   jne	  @M5
   add	  di,(80-MSGWidth)*2
   jmp	  @M3
@M5:
   stosw
   jmp	  @M3
@M6:
   xor	  ax,ax
   int	  16h
   cmp	  ax,kbEnter
   jne	  @M6

  mov ax,6*256
  mov cx,0
  mov dx,3280h
  int 10h      {Clear Screen}

  mov ah,1
  mov ch,13
  mov cl,14
  Int 10h      {ON}

@M8:
db 66h
   mov	  ax,OldExit.word
db 66h
   mov	  ExitProc.word,ax



end;

begin			   { собственно основной прмер тут }
  asm			   { а все предыдущее - это proc   }
   mov	 ax,Seg NewExit    { отработки при выходе ;)	   }
db 66h
   shl	 ax,16
   lea	 ax,NewExit
db 66h
   xchg  ExitProc.word,ax
db 66h
   mov	 OldExit.word,ax
  end;
end.
