{$O+,F+}
Unit Utils;
Interface
Uses sn_Obj;

function  ASCIITable(x,y,lang,nl:byte; var c:char; var n:byte):boolean;
Procedure AltPlusPressed;


Implementation
Uses
     Crt, RV, Vars, Main, Palette;

{============================================================================}
function  ASCIITable(x,y,lang,nl:byte; var c:char; var n:byte):boolean;
Var
   kb:word;
   i,k,cx,cy:byte;
   s:string[32];
Label loop;
Begin
if x>44 then x:=44; if x<1 then x:=1;
if y>gmaxy-16 then y:=gmaxy-16; if y<1 then y:=1;
scPutWin(7,15,x,y,x+33,y+11);
cmPrint(7,15,x,y+9,'╟────────────────────────────────╢');
if lang=rus then cmPrint(7,15,x+9,y,' ASCII символы ')
            else cmPrint(7,15,x+9,y,' ASCII symbols ');

cx:=1; cy:=1;
for i:=0 to 255 do
 Begin
  cmPrint(7,0,x+cx,y+cy,chr(i));
  inc(cx);
  if cx>32 then Begin cx:=1; inc(cy); End;
 End;

ASCIITable:=false; i:=nl;
CurOn;
setCursor(400);
Repeat
cx:=0; cy:=1;
for k:=0 to 255 do
 Begin
  inc(cx); if cx>32 then Begin cx:=1; inc(cy); End;
  if k=i then Break;
 End;
GotoXY(x+cx,y+cy);
s:=strr(i); s:=space(3-length(s))+s;
s:='Char: '+chr(i)+' Decimal: '+s+' Hex: '+dec2hex(strr(i));
cmPrint(7,0,x+3,y+10,s);

reMouse;
kb:=KeyCode;
 if kb=_Enter then Begin ASCIITable:=true; c:=chr(i); Break; End;
 if kb=_Up    then Dec(i,32);
 if kb=_Down  then Inc(i,32);
 if kb=_Left  then Dec(i);
 if kb=_Right then Inc(i);
if i<=0 then i:=0;
if i>255 then i:=255;
reMouse;
Until kb=_Esc;
n:=i;
RestScr;
End;






{===========================================================================}
procedure AltPlusPressed;
var
   s,t:string;
   k:char;
label loop,fin;
begin
 CancelSB;
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,17,halfmaxy-4,64,halfmaxy+2);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Быcтpый Каталог ')
 else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Fast Directory ');
 if lang=rus then
  begin
   cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-2,'Под каким номеpом запомнить');
   cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,'текущий каталог?');
  end
 else
  begin
   cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-2,'What number will be fast using');
   cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,'for curent directory?');
  end;
 cmprint(pal.bkdInputNT,pal.txtdInputNT,41,halfmaxy-0,' ');
 gotoxy(41,halfmaxy-0); curon;

loop:
k:=readkey;
if k in['1'..'9','0'] then
 begin
  cmprint(pal.bkdInputNT,pal.txtdInputNT,41,halfmaxy-0,k);
  case focus of
   left:  s:=lp.pcnd;
   right: s:=rp.pcnd;
  end;
  t:=k; if k='0' then t:='10';
  writeprofile(startdir+'\sn.ini','FastCatalog','Alt'+t,s);
  goto fin;
 end;
if k=#27 then goto fin;
goto loop;

fin:
curoff;
restscr;
putcmdline;
exit;
end;





End.