{============================================================================}
{== CLS =====================================================================}
{============================================================================}
procedure Cls;
var
   ax,ay,i:byte;
begin
ax:=gmaxx; ay:=gmaxy;
colour(black,lightgray);
for i:=1 to ay do mprint(1,i,space(ax));
gotoxy(1,1);
end;
{============================================================================}
{== CLEAR BOX ===============================================================}
{============================================================================}
procedure ClrBox(x1,y1,x2,y2:byte);
var
   i:byte;
   p,ink:byte;
begin
p:=textattr div 16; ink:=textattr-p*16;
for i:=y1 to y2 do cmprint(p,ink,x1,i,space(x2-x1));
end;
{============================================================================}
{== COLOUR ==================================================================}
{============================================================================}
procedure Colour(paper,ink:byte);
begin
TextColor(ink); TextBackGround(paper);
textattr:=(paper-0)*16+ink;
end;
{============================================================================}
{== PRINT ===================================================================}
{============================================================================}
procedure Print(x,y:byte; s:string);
begin
GotoXY(x,y);
Write(s);
end;
{============================================================================}
{== MEMORY PRINT ============================================================}
{============================================================================}
{procedure BaseCMPrint(paper,ink,x,y:word; const s:string);}
Procedure baseCMprint(colors:word; X,Y:byte; s:string); assembler;
asm
   mov    dx,ds
   mov    es,SegB800
   xor    ax,ax
   mov    al,Y
   dec    ax
   mov    di,ax
   shl    ax,1
   shl    ax,1
   add    di,ax
   mov    cl,5
   shl    di,cl
   xor    ax,ax
   mov    al,X
   dec    al
   shl    al,1
   add    di,ax
   mov    ah,colors.byte[0]
   mov    bl,colors.byte[1]
   lds    si,S
   xor    cx,cx
   cld
   lodsb
   mov    cl,al
   jcxz   @M2
@M1:
   lodsb
{   cmp    al,'~'
{   jne    @M3
{   xchg   bl,ah{}
{   jmp    @M4 {}
@M3:
   stosw
@M4:
   loop   @M1

@M2:
   mov    ds,dx
end;



procedure MPrint(x,y:byte; s:string);
var
   mx,f,i:byte;
   b:char;
begin
mx:=gmaxx; i:=0; dec(x); dec(y);
for f:=1 to Length(s) do
 begin
  b:=s[f];
  Mem[$B800:(mx*y+x)*2+i]:=ord(b);
  inc(i);
  Mem[$B800:(mx*y+x)*2+i]:=textattr;
  inc(i);
 end;
end;
{============================================================================}
{== COLOR MEMORY PRINT ======================================================}
{============================================================================}
procedure CMPrint(paper,ink,x,y:word; s:string);
{var
   mx,f,i:byte;
   b:char;
begin
mx:=gmaxx; i:=0; dec(x); dec(y);
for f:=1 to Length(s) do
 begin
  b:=s[f];
  Mem[$B800:(mx*y+x)*2+i]:=ord(b);
  inc(i);
  Mem[$B800:(mx*y+x)*2+i]:=byte(paper*16+ink);
  Inc(i);
 end;
end;
}
begin
baseCMPrint(paper*16+ink,x,y,s);
end;


{============================================================================}
{== PRINT SELF IN COLOR =====================================================}
{============================================================================}
procedure PrintSelf(paper,ink,x,y,len:byte);
var
 f,i:byte;
begin
i:=0; Dec(x); Dec(y);
for f:=1 to len do
 begin
  Mem[$B800:(gmaxx*y+x)*2+i+1]:=byte(paper*16+ink);
  Inc(i); Inc(i);
 end;
end;
{============================================================================}
{== MEMORY WRITE ============================================================}
{============================================================================}
procedure MWrite(s:string);
var
   f:integer;
begin
MPrint(WhereX,WhereY,s);
GotoXY(WhereX+Length(s),WhereY);
end;
{============================================================================}
{== COLOR MEMORY WRITE ======================================================}
{============================================================================}
procedure CMWrite(paper,ink:byte; s:string);
begin
CMPrint(paper,ink,WhereX,WhereY,s);
GotoXY(WhereX+Length(s),WhereY);
end;
{============================================================================}
{== CENTRE ==================================================================}
{============================================================================}
procedure Centre(y:byte; s:string);
begin
Print(1+(halfmaxx-(Length(s))div 2),y,s);
end;
{============================================================================}
{== MEMORY CENTRE ===========================================================}
{============================================================================}
procedure MCentre(y:byte; s:string);
begin
MPrint(1+(halfmaxx-(Length(s))div 2),y,s);
end;
{============================================================================}
{== COLOR MEMORY CENTRE =====================================================}
{============================================================================}
procedure CMCentre(paper,ink,y:byte; s:string);
var
   x:integer;
begin
x:=1+(halfmaxx-(Length(s))div 2);
CMPrint(paper,ink,x,y,s);
end;
{============================================================================}
{== GO TO (X,Y) =============================================================}
{============================================================================}
procedure GotoXY(x,y:Byte);
var
   r:registers;
begin
  r.ah:=$0f; Intr($10,r);
  r.ah:=$02; r.dh:=y-1; r.dl:=x-1; Intr($10,r);
end;
{============================================================================}
{== MAX X COORDINATE ========================================================}
{============================================================================}
function MaxX:Byte;
var
   r:Registers;
begin
  r.ah:=$0F;
  Intr($10,r);
  MaxX:=r.AH;
end;
{============================================================================}
{== MAX Y COORDINATE ========================================================}
{============================================================================}
function MaxY:Byte;
var
   r:Registers;
   buf:Array[0..63] Of byte;
begin
  r.ah:=$1B;
  r.bx:=$00;
  r.es:=Seg(buf);
  r.di:=Ofs(buf);
  Intr($10,r);
  MaxY:=buf[$22];
end;
{============================================================================}
{== WHERE IS X ==============================================================}
{============================================================================}
function WhereX:Byte;
var
   r:registers;
begin
  r.ah:=$0f;
  Intr($10,r);
  r.ah:=$03;
  Intr($10,r);
  WhereX:=r.dl+1;
end;
{============================================================================}
{== WHERE IS Y ==============================================================}
{============================================================================}
function WhereY : Byte;
var
   r:registers;
begin
  r.ah:=$0f;
  Intr($10,r);
  r.ah:=$03;
  Intr($10,r);
  WhereY:=r.dh+1;
end;
{============================================================================}
{== GET CHAR FROM (X,Y) =====================================================}
{============================================================================}
function GetXY(x,y:Byte):Char;
Var
   r:registers;
   xs,ys:Byte;
begin
  xs:=WhereX;
  ys:=WhereY;
  GotoXY(x,y);
  r.ah:=$0f;
  Intr($10,r);
  r.ah:=$08;
  Intr($10,r);
  GetXY:=Chr(r.al);
  GotoXY(xs,ys);
end;
{============================================================================}
{== SET TEXT MODE AS 80x25 ==================================================}
{============================================================================}
procedure Set80x25;
begin
asm
   MOV AX,03h
   INT 10h
end;
gmaxx:=80; gmaxy:=25;
halfmaxx:=40; halfmaxy:=13;
end;
{============================================================================}
{== SET TEXT MODE AS 80x28 ==================================================}
{============================================================================}
procedure Set80x28;
begin
asm
  mov ax,1202
  mov bl,30h
  int 10h
  mov ax,0003h
  int 10h
  mov ax,1111h
  mov bl,00h
  int 10h
END;
gmaxx:=80; gmaxy:=28;
halfmaxx:=40; halfmaxy:=14;
end;
{============================================================================}
{== SET TEXT MODE AS 80x30 ==================================================}
{============================================================================}
Procedure Set80x30;
Var CrtcReg:Array[1..8] of Word;
    Offset:Word;
    i,Data:Byte;
Begin
set80x25;
  CrtcReg[1]:=$0c11;
  CrtcReg[2]:=$0d06;
  CrtcReg[3]:=$3e07;
  CrtcReg[4]:=$ea10;
  CrtcReg[5]:=$8c11;
  CrtcReg[6]:=$df12;
  CrtcReg[7]:=$e715;
  CrtcReg[8]:=$0616;

  MemW[$0040:$004c]:=8192;
  Mem[$0040:$0084]:=29;
  Offset:=MemW[$0040:$0063];
  Asm
    cli
  End;

  For i:=1 to 8 do
    PortW[Offset]:=CrtcReg[i];

  Data:=Port[$03cc];
  Data:=Data And $33;
  Data:=Data Or $C4;
  Port[$03c2]:=Data;
  Asm
   sti
   mov ah,12h
   mov bl,20h
   int 10h
  End;
gmaxx:=80; gmaxy:=30;
halfmaxx:=40; halfmaxy:=15;
End;
{============================================================================}
{== SET TEXT MODE AS 80x50 ==================================================}
{============================================================================}
Procedure Set80x50;
begin
Asm
  mov ax, $1202
  mov bl, $30
  int $10     {set 400 scan lines}
  mov ax, 3
  int $10     {set Text mode}
  mov ax, $1112
  mov bl, 0
  int $10     {load 8x8 font to page 0 block}
end;
gmaxx:=80; gmaxy:=50;
halfmaxx:=40; halfmaxy:=25;
end;
{============================================================================}
{== SET TEXT MODE AS 80x43 ==================================================}
{============================================================================}
procedure Set80x43; assembler;
asm
  mov ax, $1202
  mov bl, $30
  int $10     {set 400 scan lines}
  mov ax, $50
  mov bl, 0
  int $10     {load 8x15 font to page 0 block}
end;
{============================================================================}
{== SET TEXT MODE AS 132x25 =================================================}
{============================================================================}
procedure Set132x25;
begin
asm
 mov ah,0
 mov al,85
 int 10h
 mov ax, $1114
 mov bl, 0
 int $10     {8x16}
end;
gmaxx:=132; gmaxy:=maxy;
halfmaxx:=66; halfmaxy:=gmaxy div 2;
end;
{============================================================================}
{== SET TEXT MODE AS 132x28 =================================================}
{============================================================================}
procedure Set132x28;
begin
asm
 mov ah,0
 mov al,85
 int 10h
 mov ax,$1111
 mov bl, 0
 int $10     {8x14}
end;
gmaxx:=132; gmaxy:=maxy;
halfmaxx:=66; halfmaxy:=gmaxy div 2;
end;
{============================================================================}
{== SET TEXT MODE AS 132x30 =================================================}
{============================================================================}
procedure Set132x50;
begin
asm
 mov ah,0
 mov al,85
 int 10h
 mov ax, $1112
 mov bl, 0
 int $10     {8x8}
end;
gmaxx:=132; gmaxy:=maxy;
halfmaxx:=66; halfmaxy:=gmaxy div 2;
end;
{============================================================================}
{== SET TEXT MODE OF (MX,MY) ================================================}
{============================================================================}
procedure SetTextMode(mx,my:byte);
begin
if (mx=80)and(my=25) then set80x25;
if (mx=80)and(my=28) then set80x28;
if (mx=80)and(my=30) then set80x30;
if (mx=80)and(my=50) then set80x50;
if (mx=132)and((my=25)or(my=30)) then set132x25;
if (mx=132)and((my=28)or(my=34)) then set132x28;
if (mx=132)and((my=50)or(my=60)) then set132x50;
end;
{============================================================================}
{== SAVE TEXT MODE FOR LATER RESTORE ========================================}
{============================================================================}
procedure SaveTextMode;
begin
OldMaxX:=maxx;
OldMaxY:=maxy;
end;
{============================================================================}
{== RESTORE TEXT MODE =======================================================}
{============================================================================}
procedure RestTextMode;
begin
settextmode(OldMaxX,OldMaxY);
end;
{============================================================================}
{== GET CUR TEXT MODE =======================================================}
{============================================================================}
procedure GetCurTextMode;
begin
gmaxx:=maxx;
gmaxy:=maxy;
halfmaxx:=gmaxx div 2;
halfmaxy:=gmaxy div 2;
end;
{============================================================================}
{== SHOW CURSOR =============================================================}
{============================================================================}
procedure CurOn;
var
   regs:registers;
begin
 regs.ah:=1;
 regs.ch:=13;
 regs.cl:=14;
 Intr($10,regs);
end;
{============================================================================}
{== HIDE CURSOR =============================================================}
{============================================================================}
procedure CurOff;
var
   regs:registers;
begin
 regs.ah:=1;
 regs.ch:=32;
 regs.cl:=14;
 Intr($10,regs);
end;
{============================================================================}
{== SAVE CURSOR FOR LATER RESTORE ===========================================}
{============================================================================}
procedure SaveCur;
begin
savedcurx:=wherex;
savedcury:=wherey;
if savedcurx>gmaxx then savedcurx:=gmaxx;
if savedcury>gmaxy then savedcury:=gmaxy;
end;
{============================================================================}
{== RESTORE CURSOR ==========================================================}
{============================================================================}
procedure RestCur;
begin
if savedcurx>gmaxx then savedcurx:=gmaxx;
if savedcury>gmaxy then savedcury:=gmaxy;
gotoxy(savedcurx,savedcury);
end;
{============================================================================}
{== WAIT KEY ================================================================}
{============================================================================}
{
procedure WaitKey;
var
   i:byte;
label loop;
begin
i:=1;
loop:
wait(1);
i:=i+1;
if i>10 then Exit;
if KeyPressed then begin ReadKey; Exit; end;
goto loop;
end;
{}
procedure WaitKey;
var
   i:real; k:char;
label loop;
begin
i:=1;
loop:
Delay(10);
i:=i+0.1;
if i>120 then Exit;
if KeyPressed then begin k:=ReadKey; if k=#0 then ReadKey; Exit; end;
goto loop;
end;

{============================================================================}
{== CURENT DATE+TIME ========================================================}
{============================================================================}
function CurDateTime(lan:byte):string;
var
   y, mn, d, dow, h, m, s, hund:Word;
      strtemp:string;
begin
GetTime(h,m,s,hund); GetDate(y,mn,d,dow);
if lan=rus then strtemp:=daysrus[dow] else strtemp:=dayseng[dow];
strtemp:=strtemp+' '+ Strr(d)+ '.'+ Strr(mn)+ '.'+ Strr(y);
strtemp:=strtemp+'   '+LZ(h)+':'+LZ(m)+':'+LZ(s){+'.'+LeadingZero(hund)};
CurDateTime:=strtemp;
end;
{============================================================================}
{== CURENT DATE =============================================================}
{============================================================================}
function CurDate:string;
var
   y, mn, d, dow:Word;
begin
GetDate(y,mn,d,dow);
CurDate:=lz(d)+ '-'+ lz(mn)+ '-'+ Strr(y);
end;
{============================================================================}
{== CURENT DAY ==============================================================}
{============================================================================}
function CurDay(lan:byte):string;
var
   y, mn, d, dow:Word;
begin
GetDate(y,mn,d,dow);
if lan=rus then CurDay:=daysrus[dow] else CurDay:=dayseng[dow];
end;
{============================================================================}
{== CURENT TIME =============================================================}
{============================================================================}
function CurTime:string;
var
   h, m, s, hund : Word;
   strtemp:string;
begin
GetTime(h,m,s,hund);
strtemp:=LZ(h)+':'+LZ(m)+':'+LZ(s){+'.'+LZ(hund)};
CurTime:=strtemp;
end;
{============================================================================}
{== FLASH ON/OFF ============================================================}
{============================================================================}
procedure Flash(OffOn:byte);
var ofon:boolean;
begin
if OffOn=on then ofon:=true else ofon:=false;
asm
  Push AX
  Mov AX,$1003
  Mov BL,OfOn
  Int $10
  Pop AX
end;
end;
{============================================================================}
{== BORDER ==================================================================}
{============================================================================}
Procedure Border(colour : Byte);
Var
  regs : Registers;
begin
 regs.ah := $10;
 regs.al := $01;
 regs.bh := colour;
 intr($10, regs);
end;
{============================================================================}
{== RING ====================================================================}
{============================================================================}
Procedure Ring;
var i:word;
begin
for i:=1 to 9 do
 begin
  sound(523); asm hlt end;
  Delay(180);
  sound(659); asm hlt end;
  Delay(180);
 end;
nosound;
end;
{============================================================================}
{== BEEP ====================================================================}
{============================================================================}
procedure Beep(ton,len:integer);
begin
Sound(ton);
Delay(len);
NoSound;
end;
{============================================================================}
{== WAIT ====================================================================}
{============================================================================}
Procedure Wait(Seconds : Word);
VAR Delay : Word;
Begin
   Delay := ((976 SHL 10) * Seconds) SHR 16;  { (976*1024*seconds)/65536 }
   Asm
     mov ah,86h
     mov cx,delay
     mov dx,0
     int 15h
   End
End;
{============================================================================}
{== PAUSE ===================================================================}
{============================================================================}
procedure rPause;
var k:char;
begin
repeat until keypressed;
if keypressed then k:=readkey;
if k=#0 then k:=readkey;
end;
{============================================================================}
{== CHECK BIT ===============================================================}
{============================================================================}
function bit(n,b:byte):boolean;
var s:string;
begin
bit:=false;
s:=reversestr(hex2bin(dec2hex(strr(b))));
if s[n]='1' then bit:=true;
end;
{============================================================================}
{== CHECK BIT ===============================================================}
{============================================================================}
function GetCursor:word;
begin
  GetCursor:=(mem[$0040:$0060] shl 4)+mem[$0040:$0061];
end;

procedure SetCursor(curs:word);
var
  regs:registers;
begin
 FillChar(regs,SizeOf(regs),0);
 regs.ah:=$01;
 regs.ch:=curs mod 16;
 regs.cl:=curs div 16;
 Intr($10,regs);
end;

{============================================================================}
{== LONG HI =================================================================}
{============================================================================}
function LongHi(num:longint):word;
Begin
LongHi:=num div 65536;
End;
{============================================================================}
{== LONG LO =================================================================}
{============================================================================}
function LongLo(num:longint):word;
Begin
LongLo:=num-65536*LongHi(num);
End;
