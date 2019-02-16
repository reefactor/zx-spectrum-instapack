{============================================================================}
{== SCREEN INI ==============================================================}
{============================================================================}
procedure ScrIni;
var
   mx,my,ax,ay,i:integer;
begin
if Moused then MouseOn;
mx:=gmaxx; my:=gmaxy;
i:=0;
for ay:=0 to my-1 do
for ax:=0 to mx-1 do
 begin
  Mem[$B800:(mx*ay+ax+i)*2]:=176;
  Mem[$B800:(mx*ay+ax+i)*2+1]:=7*16+1;
 end;
if Moused then MouseOff;
end;
{============================================================================}
{== SAVE SCREEN =============================================================}
{============================================================================}
procedure SaveScr(x1,y1,x2,y2:byte);
var
   x,y   : byte;
   tmp,i : word;
begin
if Moused then MouseOff;
inc(WinNum);
SavedWins[WinNum].x1:=x1;
SavedWins[WinNum].y1:=y1;
SavedWins[WinNum].x2:=x2;
SavedWins[WinNum].y2:=y2;
   GetMem(SavedWins[WinNum].area,(x2-x1)*(y2-y1)*3);
   i:=0;
   for y:=y1-1 to y2-1 do
    begin
     tmp:=160*y;
     for x:=x1-1 to x2-1 do
      begin
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i]:=MemW[$B800:tmp+x+x];
       inc(i,2);
      end;
    end;
if Moused then MouseOn;
end;
{============================================================================}
{== RESTORE SCREEN ==========================================================}
{============================================================================}
procedure RestScr;
var
   x,y,x1,x2,y1,y2   : byte;
   a,b,a1,a2,b1,b2   : byte;
   tmp,i,k : word;
begin
if WinNum-1<1 then exit;
x1:=SavedWins[WinNum].x1;
y1:=SavedWins[WinNum].y1;
x2:=SavedWins[WinNum].x2;
y2:=SavedWins[WinNum].y2;

a1:=SavedWins[WinNum].x1;
b1:=SavedWins[WinNum].y1;
a2:=SavedWins[WinNum].x2;
b2:=SavedWins[WinNum].y2;
if Moused then MouseOff;

if w_animation then
 begin
  while (a2-a1<>2)or(b2-b1<>2) do
    begin

     for x:=a1-1 to a2-1   do
      begin
       y:=b1;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+2;
       MemW[$B800:(80*(y-1)+x)*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];

       y:=b2;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+2;
       MemW[$B800:(80*(y-1)+x)*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];
      end;
     {}

     for y:=b1 to b2 do
      begin
       x:=a1  ;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+0;
       MemW[$B800:(80*(y-1)+(x-1))*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];
       x:=a1+1  ;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+0;
       MemW[$B800:(80*(y-1)+(x-1))*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];

       x:=a2  ;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+0;
       MemW[$B800:(80*(y-1)+(x-1))*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];
       x:=a2-1  ;
       i:=((x2-x1+1)*abs(y-y1)+x-x1)*2+0;
       MemW[$B800:(80*(y-1)+(x-1))*2]:=
       MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];
      end;
     {}
     inc(a1,2); dec(a2,2);{}
     inc(b1); dec(b2);{}

     if a1>(x1+x2)div 2-1 then a1:=(x1+x2)div 2-1;
     if b1>(y1+y2)div 2-1 then b1:=(y1+y2)div 2-1;

     if a2<(x1+x2)div 2+1 then a2:=(x1+x2)div 2+1;
     if b2<(y1+y2)div 2+1 then b2:=(y1+y2)div 2+1;
     {}
    delay(10);
    end;
 end;

   i:=0;
   for y:=y1-1 to y2-1 do
    begin
     tmp:=160*y;
     for x:=x1-1 to x2-1 do
      begin
       MemW[$B800:tmp+x+x]:=MemW[Seg(SavedWins[WinNum].area^):Ofs(SavedWins[WinNum].area^)+i];
       inc(i,2)
      end
    end;
   {Dispose(p);{}
   FreeMem(SavedWins[WinNum].area,(x2-x1)*(y2-y1)*3);{}
dec(WinNum);
if Moused then MouseOn;

end;
{============================================================================}
{== BASE PUT WINDOW =========================================================}
{============================================================================}
procedure BasePutWin(paper,ink,xx1,yy1,xx2,yy2:integer);
var
    i,m,n:integer;
    a1,b1,a2,b2:integer;
    x1,y1,x2,y2:integer;
    a,b:char;

begin
if Moused then MouseOff;
if w_twosided then begin a:=#186; b:=#205; end else begin a:=#$B3; b:=#$C4; end;
if w_rama then else begin a:=' '; b:=' '; end;
if w_animation then{}
 begin
  a1:=(xx1+xx2)div 2-1; a2:=(xx1+xx2)div 2+1;
  b1:=(yy1+yy2)div 2-1; b2:=(yy1+yy2)div 2+1;
  if abs(a1-xx1)>abs(b1-yy1) then m:=abs(a1-xx1) else m:=abs(b1-yy1);
  while (a1>xx1)or(b1>yy1) do
   begin
    x1:=a1; x2:=a2; y1:=b1; y2:=b2;
    for i:=y1 to y2 do
     if w_twosided then cmprint(paper,ink,x1,i,a+space(x2-x1-1)+a)
                   else cmprint(paper,ink,x1+1,i,' '+a+space(x2-x1-3)+a+' ');
    for i:=x1 to x2 do begin cmprint(paper,ink,i,y1,b); cmprint(paper,ink,i,y2,b); end;
    if w_twosided then
     begin
      if w_rama then
       begin
        cmprint(paper,ink,x1,y1,#201); cmprint(paper,ink,x2,y1,#187);
        cmprint(paper,ink,x1,y2,#200); cmprint(paper,ink,x2,y2,#188);
       end
      else
       begin
        cmprint(paper,ink,x1,y1,#32); cmprint(paper,ink,x2,y1,#32);
        cmprint(paper,ink,x1,y2,#32); cmprint(paper,ink,x2,y2,#32);
       end;
     end
    else
     begin
      if w_rama then
       begin
        cmprint(paper,ink,x1,y1,' '#218); cmprint(paper,ink,x2-1,y1,#191' ');
        cmprint(paper,ink,x1,y2,' '#192); cmprint(paper,ink,x2-1,y2,#217' ');
       end
      else
       begin
        cmprint(paper,ink,x1,y1,' '#32); cmprint(paper,ink,x2-1,y1,#32' ');
        cmprint(paper,ink,x1,y2,' '#32); cmprint(paper,ink,x2-1,y2,#32' ');
       end;
     end;

    if w_shadow then
     begin
      PrintSelf(black,darkgray,x1+2,y2+1,x2-x1+1);
      for i:=y1+1 to y2+1 do PrintSelf(black,darkgray,x2+1,i,2);
     end;

    dec(a1,2); dec(b1);
    inc(a2,2); inc(b2);
    if a1<xx1 then a1:=xx1; if a2>xx2 then a2:=xx2;
    if b1<yy1 then b1:=yy1; if b2>yy2 then b2:=yy2;
    delay(10);
   end;
 end;

  x1:=xx1; x2:=xx2; y1:=yy1; y2:=yy2;
  for i:=y1 to y2 do
     if w_twosided then cmprint(paper,ink,x1,i,a+space(x2-x1-1)+a)
                   else cmprint(paper,ink,x1,i,' '+a+space(x2-x1-3)+a+' ');
  for i:=x1 to x2 do begin cmprint(paper,ink,i,y1,b); cmprint(paper,ink,i,y2,b); end;
  if w_twosided then
   begin
    if w_rama then
     begin
      cmprint(paper,ink,x1,y1,#201); cmprint(paper,ink,x2,y1,#187);
      cmprint(paper,ink,x1,y2,#200); cmprint(paper,ink,x2,y2,#188);
     end
    else
     begin
      cmprint(paper,ink,x1,y1,#32); cmprint(paper,ink,x2,y1,#32);
      cmprint(paper,ink,x1,y2,#32); cmprint(paper,ink,x2,y2,#32);
     end
   end
  else
   begin
    if w_rama then
     begin
      cmprint(paper,ink,x1,y1,' '#218); cmprint(paper,ink,x2-1,y1,#191' ');
      cmprint(paper,ink,x1,y2,' '#192); cmprint(paper,ink,x2-1,y2,#217' ');
     end
    else
     begin
      cmprint(paper,ink,x1,y1,' '#32); cmprint(paper,ink,x2-1,y1,#32' ');
      cmprint(paper,ink,x1,y2,' '#32); cmprint(paper,ink,x2-1,y2,#32' ');
     end
   end;
  if w_shadow then
   begin
    PrintSelf(black,darkgray,x1+2,y2+1,x2-x1+1);
    for i:=y1+1 to y2+1 do PrintSelf(black,darkgray,x2+1,i,2);
   end;
if Moused then MouseOn;
end;


{============================================================================}
{== PUT WINDOW ==============================================================}
{============================================================================}
procedure PutWin(x1,y1,x2,y2:integer);
begin
BasePutWin(hi(textattr),lo(textattr),x1,y1,x2,y2);
end;
{============================================================================}
{== PUT WINDOW AND SAVE =====================================================}
{============================================================================}
procedure SPutWin(x1,y1,x2,y2:integer);
var
   f:integer;
begin
if Moused then MouseOff;
SaveScr(x1,y1,x2+2,y2+1);
PutWin(x1,y1,x2,y2);
if Moused then MouseOn;
end;
{============================================================================}
{== PUT COLOR WINDOW AND SAVE ===============================================}
{============================================================================}
procedure SCPutWin(p,i,x1,y1,x2,y2:integer);
var
   f:integer;
begin
if Moused then MouseOff;
SaveScr(x1,y1,x2+2,y2+1);
BasePutWin(p,i,x1,y1,x2,y2);
if Moused then MouseOn;
end;
{============================================================================}
{== PUT TITLED WINDOW =======================================================}
{============================================================================}
procedure PutTitleWin(title:string; x1,y1,x2,y2:integer);
var
   f:integer;
begin
if Moused then MouseOff;
f:=(x1+x2)div 2;
PutWin(x1,y1,x2,y2);
if w_twosided then mprint(x1,y1+2,#$C7+fill(x2-x1-1,#$C4)+#$B6)
              else mprint(x1,y1+2,' '#$C7+fill(x2-x1-3,#$C4)+#$B6' ');
mprint(f-(length(title) div 2),y1+1,title);
if Moused then MouseOn;
end;
{============================================================================}
{== PUT TITLED WINDOW AND SAVE ==============================================}
{============================================================================}
procedure SPutTitleWin(title:string; x1,y1,x2,y2:integer);
var
   f:integer;
begin
if Moused then MouseOff;
f:=(x1+x2)div 2;
SaveScr(x1,y1,x2+2,y2+1);
PutWin(x1,y1,x2,y2);
if w_twosided then mprint(x1,y1+2,#$C7+fill(x2-x1-1,#$C4)+#$B6)
              else mprint(x1,y1+2,' '#$C7+fill(x2-x1-3,#$C4)+#$B6' ');
mprint(f-(length(title) div 2),y1+1,title);
if Moused then MouseOn;
end;
{============================================================================}
{== BASE MESSAGE ============================================================}
{============================================================================}
procedure BaseMessage(p,i:byte; tekst:string);
var cm:integer;
begin
if Moused then MouseOff;
CurOff;
cm:=textattr;
Colour(p,i);
if Length(tekst)>60 then tekst:=Copy(tekst,1,60)+'...';
sPutWin(1+round(halfmaxx-(Length(tekst)/2)-5),halfmaxy-4,round(halfmaxx+(Length(tekst)/2)+5),halfmaxy);
CMCentre(p,i,halfmaxy-2,tekst);
textattr:=cm;
if Moused then MouseOn;
end;
{============================================================================}
{== MESSAGE =================================================================}
{============================================================================}
procedure Message(tekst:string);
begin
BaseMessage(green,white,tekst);
WaitKey;;
RestScr;
end;
{============================================================================}
{== WAIT MESSAGE ============================================================}
{============================================================================}
function WaitMessage(tekst:string):byte;
var k:char;
begin
BaseMessage(cyan,yellow,tekst);
k:=readkey;
WaitMessage:=ord(k);
RestScr;
end;
{============================================================================}
{== NOT WAIT MESSAGE ========================================================}
{============================================================================}
procedure NotWaitMessage(paper,ink:byte; tekst:string);
begin
BaseMessage(paper,ink,tekst);
end;
{============================================================================}
{== ERROR MESSAGE ===========================================================}
{============================================================================}
procedure ErrorMessage(tekst:string);
begin
BaseMessage(red,white,tekst);
beep(900,20);{}
WaitKey;
RestScr;
end;
{============================================================================}
{== ERROR WAIT MESSAGE ======================================================}
{============================================================================}
function ErrorWaitMessage(tekst:string):byte;
var k:char;
begin
BaseMessage(red,white,tekst);
k:=readkey;
ErrorWaitMessage:=ord(k);
RestScr;
end;
{============================================================================}
{== STATUS BAR ==============================================================}
{============================================================================}
procedure StatusBar(s:string160);
var
   f,i:integer;
   col:boolean;
   paper,ink:integer;
   my:integer;
label skip;
begin
if Moused then MouseOff;
i:=1; my:=gmaxy;
paper:=lightgray;
col:=true;
CMPrint(paper,0,1,my,' ');
for f:=1 to Length(s) do
 begin
  if i>gmaxx then break;
  if s[f]='`' then goto skip;
  if (s[f]='~')and(s[f+1]='`') then begin col:=not col; goto skip; end;
  if col then
   begin CMPrint(paper,black,i+1,my,s[f]); Inc(i); end
  else
   begin CMPrint(paper,white,i+1,my,s[f]); Inc(i); end;
skip:
 end;
CMPrint(paper,0,i+1,my,Space(gmaxx-i));
if Moused then MouseOn;
end;
{============================================================================}
{== Color STATUS BAR ========================================================}
{============================================================================}
procedure CStatusBar (paper,ink,papermark,inkmark,putfrom:byte; s:string160);
var
   f,i:integer;
   col:boolean;
   my:integer;
label skip;
begin
if Moused then MouseOff;
i:=1; my:=gmaxy;
col:=true;
if putfrom=1 then CMPrint(paper,0,1,my,' ') else CMPrint(papermark,0,1,my,' ');
for f:=1 to Length(s) do
 begin
  if i>gmaxx then break;{}
  if s[f]='`' then goto skip;
  if (s[f]='~')and(s[f+1]='`') then begin col:=not col; goto skip; end;
  if col then
   begin CMPrint(paper,ink,i+1,my,s[f]); Inc(i); end
  else
   begin CMPrint(papermark,inkmark,i+1,my,s[f]); Inc(i); end;
skip:
 end;
CMPrint(paper,0,i+1,my,Space(gmaxx-i));
if Moused then MouseOn;
end;
{============================================================================}
{== STATUS LINE =============================================================}
{============================================================================}
procedure StatusLine(paper,x,y:integer; s:string);
var
   f,i:integer;
   col:boolean;
label skip;
begin
if Moused then MouseOff;
i:=0;
col:=true;
CMPrint(paper,0,x,y,' ');
for f:=1 to Length(s) do
 begin
  if i>gmaxx then break;
  if s[f]='`' then goto skip;
  if (s[f]='~')and(s[f+1]='`') then begin col:=not col; goto skip; end;
  if col then
   begin CMPrint(paper,black,i+1+x,y,s[f]); Inc(i); end
  else
   begin CMPrint(paper,white,i+1+x,y,s[f]); Inc(i); end;
skip:
 end;
if Moused then MouseOn;{}
end;
{============================================================================}
{== STATUS LINE COLOR =======================================================}
{============================================================================}
procedure StatusLineColor(paper,ink,papermark,inkmark,x,y:integer; s:string);
var
   f,i:integer;
   col:boolean;
label skip;
begin
if Moused then MouseOff;
i:=0;
col:=true;
{CMPrint(paper,0,x,y,' ');{}
for f:=1 to Length(s) do
 begin
  if i>gmaxx then break;
  if s[f]='`' then goto skip;
  if (s[f]='~')and(s[f+1]='`') then begin col:=not col; goto skip; end;
  if col then
   begin CMPrint(paper,ink,i+x,y,s[f]); Inc(i); end
  else
   begin CMPrint(papermark,inkmark,i+x,y,s[f]); Inc(i); end;
skip:
 end;
if Moused then MouseOn;
end;
{============================================================================}
{== CENTRE STATUS LINE COLOR ================================================}
{============================================================================}
procedure CStatusLineColor(paper,ink,inkmark,y:integer; s:string);
var
   x,f,i:integer;
   col:boolean;
label skip;
begin
if Moused then MouseOff;{}
i:=0;
col:=true;
x:=halfmaxx-(length(s) div 2);
CMPrint(paper,0,x,y,' ');
for f:=1 to Length(s) do
 begin
  if i>gmaxx then break;
  if s[f]='`' then goto skip;
  if (s[f]='~')and(s[f+1]='`') then begin col:=not col; goto skip; end;
  if col then
   begin CMPrint(paper,ink,i+1+x,y,s[f]); Inc(i); end
  else
   begin CMPrint(paper,inkmark,i+1+x,y,s[f]); Inc(i); end;
skip:
 end;
if Moused then MouseOn;{}
end;
{============================================================================}
{== PROCESS BAR =============================================================}
{============================================================================}
procedure ProcessBar(act,per,total:byte; title:string);
var
   k:char;
   cm,m,a,b:integer;
   x1,x2,dx:byte;
   yes,no:string;
   ops:integer;
label l;
begin
dx:=4;
cm:=halfmaxy;
x1:=halfmaxx-round(total/2)-dx;
Colour(white,black);
if act=run then
 begin
  x2:=halfmaxx+round(total/2)+dx;
  sPutWin(x1,cm-3,x2,cm);
  cmprint(7,0,x1+5,cm-2,title);
  cmprint(7,0,x1+5,cm-1,fill(total,#177));
 end;
ops:=round((total/100)*per);
mprint(x1+4+ops,cm-1,#$DB);
{if rMoused then MouseShow;{}
end;
{============================================================================}
{== QESTION =================================================================}
{============================================================================}
function Question(quest:string; lan:byte):boolean;
var
   k:char;
   cm,m,a,b:integer;
   x1,x2,dx:byte;
   yes,no:string;
label l;
begin
CurOff;
if Moused then MouseOff;
if lan=rus then
 begin yes:=' Да '; no:= ' Нет '; a:=round(maxx/2)-4; b:=round(maxx/2); end
else
 begin yes:=' Yes '; no:= ' No '; a:=round(maxx/2)-4; b:=round(maxx/2)+1; end;
cm:=halfmaxy;
if length(quest)<5 then dx:=5 else dx:=0;
x1:=halfmaxx-round(length(quest)/2)-3-dx;
x2:=halfmaxx+round(length(quest)/2)+3+dx;
SaveScr(x1,cm-4,x2+2,cm+3);
Colour(red,white); PutWin(x1,cm-4,x2,cm+2);
CStatusLineColor(red,white,lightgreen,cm-2,quest);
Colour(white,red); mPrint(a,cm,yes);
Colour(red,lightgray); mPrint(b,cm,no);
m:=1;
l:
if Moused then MouseOn;{}
 k:=ReadKey;
 if k=#27 then begin Question:=false; RestScr; Exit; end;
 if k=#13 then begin if m=0 then Question:=false else Question:=true; RestScr; Exit; end;
 if k=#0 then
  begin
   k:=ReadKey;
   if k=#77 then m:=0;
   if k=#75 then m:=1;
  end;
 if m=1 then
  begin
   Colour(white,red); mPrint(a,cm,yes);
   Colour(red,lightgray); mPrint(b,cm,no);
  end
 else
  begin
   Colour(red,lightgray); mPrint(a,cm,yes);
   Colour(white,red); mPrint(b,cm,no);
  end;
if Moused then MouseOff;
goto l;
end;
{============================================================================}
{== SURE ====================================================================}
{============================================================================}
function Sure(lan:byte):boolean;
var
   quest:string;
label l;
begin
CurOff;
if lan=rus then quest:='Вы уверены?' else quest:='Are you sure?';
sure:=question(quest,lan);
end;
{============================================================================}
{== STOP ====================================================================}
{============================================================================}
function Stop(lan:byte):boolean;
var
   quest:string;
label l;
begin
CurOff;
if lan=rus then quest:='Прервать операцию?' else quest:='   Halt?    ';
stop:=question(quest,lan);
end;
{============================================================================}
{== SCANF ===================================================================}
{============================================================================}
function scanf(scanf_posx, scanf_posy:byte;
               scanf_str:string;
               scanf_total, scanf_visible,
               scanf_cur:byte):string;
var
     scanf_kod:char;
     scanf_x, scanf_from:integer;
     scanf_str_old:string;
label loop;
begin
if Moused then MouseOff;
scanf_esc:=false;
scanf_tab:=false;
scanf_str_old:=scanf_str;
{message('['+scanf_str+']'); curon;{}
{scanf_str:=scanf_str+space(scanf_total-length(scanf_str));{}
scanf_x:=scanf_cur;
scanf_from:=1;
{if scanf_visible>length(scanf_str) then scanf_visible:=length(scanf_str);{}

loop:
if length(scanf_str)<scanf_total
 then mprint(scanf_posx,scanf_posy,copy(scanf_str,scanf_from,scanf_visible)+
        space(scanf_visible-(length(scanf_str)-scanf_from)-1))
 else mprint(scanf_posx,scanf_posy,copy(scanf_str,scanf_from,scanf_visible));
gotoxy(scanf_posx+scanf_x-scanf_from,scanf_posy);
if Moused then MouseOn;{}
scanf_kod:=readkey;
if scanf_kod=#9 then if scanf_tab_enable then begin scanf_shtab:=false; scanf_tab:=true; scanf:=scanf_str; exit; end;
if scanf_kod=#27 then begin scanf:=scanf_str_old; scanf_esc:=true; exit; end;
if scanf_kod=#13 then begin scanf:=scanf_str; exit; end;

if ((scanf_kod)>=' ')and((scanf_kod)<='я'){and(scanf_x<=length(scanf_str)){} then
 Begin
{ if length(scanf_str)+1<=scanf_total then{}
  scanf_str:=copy(scanf_str,1,scanf_x-1)+scanf_kod+copy(scanf_str,scanf_x,length(scanf_str));{}
  inc(scanf_x);
  if scanf_x-scanf_from>scanf_visible then inc(scanf_from);
  if scanf_x>length(scanf_str)+1 then scanf_x:=length(scanf_str)+1;
 End;

if scanf_kod=#8 then
 begin
  scanf_str:=copy(scanf_str,1,scanf_x-2)+copy(scanf_str,scanf_x,length(scanf_str));
  dec(scanf_x);
  if scanf_x<scanf_from then dec(scanf_from);
  if scanf_x<1 then scanf_x:=1;{ else scanf_str:=scanf_str+' ';{}
  if scanf_from<1 then scanf_from:=1;
  if scanf_x<1 then scanf_x:=1;
 end;

if scanf_kod=#25 then
 begin
  scanf_str:='';
  scanf_from:=1;
  scanf_x:=1;
 end;

if scanf_kod=#0 then
 begin
  scanf_kod:=readkey;
  if scanf_kod=#15 then if scanf_tab_enable then begin scanf_tab:=false; scanf_shtab:=true; scanf:=scanf_str; exit; end;
  if scanf_kod=#71 then begin scanf_from:=1; scanf_x:=1; end;
  if scanf_kod=#79 then
   begin
    scanf_from:=length(scanf_str)-scanf_visible+1;
    scanf_x:=length(scanf_str)+1;
   end;
  if scanf_kod=#83 then scanf_str:=copy(scanf_str,1,scanf_x-1)+copy(scanf_str,scanf_x+1,length(scanf_str));
  if scanf_kod=#77 then
   begin
    inc(scanf_x);
    if scanf_x-scanf_from>scanf_visible then inc(scanf_from);
   end;
  if scanf_kod=#75 then
   begin
    dec(scanf_x);
    if scanf_x<scanf_from then dec(scanf_from);
   end;

  if scanf_x<1 then scanf_x:=1;
  if scanf_x>length(scanf_str)+1 then begin scanf_x:=length(scanf_str)+1; dec(scanf_from); end;
  if scanf_from<1 then scanf_from:=1;
 end;

if Moused then MouseOff;
goto loop;
end;
{============================================================================}
{== CHOOSE ITEM =============================================================}
{============================================================================}
function ChooseItem:byte;
var
   f,inttemp,fr,a:integer;
   la:word; lx,ly:integer;
   i,p,is,ps:integer;
label loop;
{----------------------------------------------------------------------------}
Procedure PutItems;
var f:byte; v,k,p,i,p2,i2:integer;
Begin
if menu_visible>menu_total then v:=menu_total else v:=fr+menu_visible-1;
k:=1;
for f:=fr to v do
 begin
  if menu_ins[f] then
    if f<>menu_f
      then begin p:=menu_bkST; i:=menu_txtST; p2:=menu_bkNT; i2:=menu_txtNT; end
      else begin p:=menu_bkMarkST; i:=menu_txtMarkST; p2:=menu_bkMarkNT; i2:=menu_txtMarkNT; end
                 else
    if f<>menu_f
      then begin p:=menu_bkNT; i:=menu_txtNT; p2:=menu_bkST; i2:=menu_txtST; end
      else begin p:=menu_bkMarkNT; i:=menu_txtMarkNT; p2:=menu_bkMarkST; i2:=menu_txtMarkST; end;


    if menu_title=''
      then StatusLineColor(p,i,p2,i2,
                           menu_posx+2, menu_posy+k, '  '+copy(menu_name[f],1,65)+'  ')
      else StatusLineColor(p,i,p2,i2,
                           menu_posx+2, menu_posy+k+2, '  '+copy(menu_name[f],1,65)+'  ');
  inc(k);
 end;
End;
{----------------------------------------------------------------------------}
begin
if Moused then MouseOff;
la:=textattr; lx:=wherex; ly:=wherey;

if menu_bkNT<0 then      menu_bkNT     :=LightGray;
if menu_txtNT<0 then     menu_txtNT    :=Black;

if menu_bkST<0 then      menu_bkST     :=LightGray;
if menu_txtST<0 then     menu_txtST    :=White;

if menu_bkMarkNT<0 then  menu_bkMarkNT :=Blue;
if menu_txtMarkNT<0 then menu_txtMarkNT:=LightCyan;

if menu_bkMarkST<0 then  menu_bkMarkST :=Blue;
if menu_txtMarkST<0 then menu_txtMarkST:=White;

if menu_visible=255 then menu_visible:=round(gmaxy/3);
if menu_visible>menu_total then menu_visible:=menu_total;
if (menu_visible<=0)or(menu_visible>gmaxy-9) then menu_visible:=gmaxy-9;
if (menu_f<1)or(menu_f>menu_total) then menu_f:=1;
inttemp:=CCLen(menu_name[1]);
for f:=2 to menu_total do if CCLen(menu_name[f])>inttemp then inttemp:=CCLen(menu_name[f]);
if length(menu_title)>inttemp then inttemp:=length(menu_title);
if inttemp>65 then inttemp:=65;
if menu_posx=255 then menu_posx:=(halfmaxx)-round((6+inttemp)/2);
if menu_title<>'' then a:=2 else a:=2;
if menu_posy=255 then menu_posy:=round(halfmaxy-menu_visible/2)-a;
for f:=1 to menu_total do menu_name[f]:=menu_name[f]+space(inttemp-CCLen(menu_name[f]));
if menu_visible>menu_total then f:=menu_total else f:=menu_visible;

if menu_title=''
then
 scputwin(menu_bkNT,menu_txtNT,menu_posx, menu_posy, menu_posx+inttemp+7, menu_posy+f+1)
else
  begin
   scputwin(menu_bkNT,menu_txtNT,menu_posx, menu_posy, menu_posx+inttemp+7, menu_posy+f+3);
   if w_twosided
    then cmprint(menu_bkNT,menu_txtNT,menu_posx, menu_posy+2, chr(199)+fill(inttemp+6,#196)+chr(182))
    else cmprint(menu_bkNT,menu_txtNT,menu_posx, menu_posy+2, ' '+chr(195)+fill(inttemp+4,#196)+chr(180)+' ');
   cmprint(menu_bkNT,menu_txtNT,(menu_posx+round((inttemp+8)/2))-round((length(menu_title))/2), menu_posy+1, menu_title);
  end;

fr:=menu_f-menu_visible+1;
if fr<1 then fr:=1;
loop:
  PutItems;
if Moused then MouseOn;{}
  menu_kod:=readkey;
  if (menu_kod=#9) then
   begin
    scanf_tab:=true;
    restscr;
    ChooseItem:=menu_f;
    textattr:=la;
    gotoxy(lx,ly);
    menu_posx:=255; menu_posy:=255;
    exit;
   end;
  if (menu_kod=#13) then
   begin
    restscr;
    ChooseItem:=menu_f;
    textattr:=la;
    gotoxy(lx,ly);
    menu_posx:=255; menu_posy:=255;
    exit;
   end;
  if menu_kod=#27 then
   begin
    scanf_esc:=true;
    restscr;
    ChooseItem:=0;
    menu_posx:=255; menu_posy:=255;
    exit;
   end;
  if menu_mayins then
   begin
    if menu_kod=#45 then begin for f:=1 to menu_total do menu_ins[f]:=false; end;
    if menu_kod=#43 then begin for f:=1 to menu_total do menu_ins[f]:=true; end;
    if menu_kod=#42 then begin for f:=1 to menu_total do menu_ins[f]:=not menu_ins[f]; end;
   end;
  if menu_kod=#0 then
   begin
    menu_kod:=readkey;
    if menu_kod=#15 then
     begin
      scanf_shtab:=true;
      restscr;
      ChooseItem:=menu_f;
      textattr:=la;
      gotoxy(lx,ly);
      menu_posx:=255; menu_posy:=255;
      exit;
     end;
    if menu_mayins then
     begin
      if menu_kod=kb_Ins then
       begin menu_ins[menu_f]:=not menu_ins[menu_f]; inc(menu_f); end;
     end;
    if menu_kod=kb_Down then
     begin
      inc(menu_f);
      if menu_f>fr+menu_visible-1 then begin inc(fr); if fr>menu_total-menu_visible+1 then dec(fr); end;
     end;
    if menu_kod=kb_Up then
     begin
      dec(menu_f);
      if menu_f<fr then begin dec(fr); if fr<1 then inc(fr); end;
     end;
    if menu_kod=kb_PgDn then
     begin
      inc(menu_f,menu_visible);
      if menu_f>fr+menu_visible-1 then
      begin inc(fr,menu_visible); if fr>menu_total-menu_visible+1 then fr:=menu_total-menu_visible+1; end;
     end;
    if menu_kod=kb_PgUp then
     begin
      dec(menu_f,menu_visible);
      if menu_f<fr then begin dec(fr,menu_visible); if fr<1 then fr:=1; end;
     end;
    if menu_kod=kb_Home then
     begin
      fr:=1;
      menu_f:=1;
     end;
    if menu_kod=kb_End then
     begin
      fr:=menu_total-menu_visible+1;
      menu_f:=menu_total;
     end;
   end;
  if menu_f>menu_total then menu_f:=menu_total;
  if menu_f<1 then menu_f:=1;
if Moused then MouseOff;{}
goto loop;
end;
{============================================================================}
{== GET STRING FROM SCREEN ==================================================}
{============================================================================}
function GetScrStr(x,y,len:integer):string;
var
 f,i,mx:byte;
 s:string;
begin
s:=''; mx:=maxx;
i:=0; Dec(x); Dec(y);
for f:=1 to len do
 begin
  s:=s+chr(Mem[$B800:(mx*y+x)*2+i]);
  Inc(i); Inc(i);
 end;
GetScrStr:=s;
end;
{============================================================================}
{== CHOOSE DRIVE ============================================================}
{============================================================================}
function ChooseDrive(w,typ,lang:byte; cd:string):char;
{============================================================================}
{============================================================================}
{================== Выбираем пункт из меню ==================================}
{============================================================================}
{============================================================================}
function eChooseItem:byte;
var
   f,inttemp,fr,a:integer;
   la:word; lx,ly:integer;
   temp:integer;
   st:string;
   i,p:integer;
label loop;
{----------------------------------------------------------------------------}
Procedure PutItems;
var f:byte; v,k:integer;
Begin
if menu_visible>menu_total then v:=menu_total else v:=fr+menu_visible-1;
k:=1;
for f:=fr to v do
 begin
  if f<>menu_f then
    if menu_title=''
      then StatusLineColor(menu_bkNT,menu_txtNT,menu_bkST,menu_txtST,
                           menu_posx+2, menu_posy+k, '  '+menu_name[f]+'  ')
      else StatusLineColor(menu_bkNT,menu_txtNT,menu_bkST,menu_txtST,
                           menu_posx+2, menu_posy+k+2, '  '+menu_name[f]+'  ')
              else
    if menu_title=''
      then StatusLineColor(menu_bkMarkNT,menu_txtMarkNT,menu_bkMarkST,menu_txtMarkST,
                           menu_posx+2, menu_posy+k, '  '+menu_name[f]+'  ')
      else StatusLineColor(menu_bkMarkNT,menu_txtMarkNT,menu_bkMarkST,menu_txtMarkST,
                           menu_posx+2, menu_posy+k+2, '  '+menu_name[f]+'  ');
  inc(k);
 end;
End;
{----------------------------------------------------------------------------}
begin
if Moused then MouseOff;
la:=textattr; lx:=wherex; ly:=wherey;
if menu_bkNT<0 then      menu_bkNT     :=LightGray;
if menu_txtNT<0 then     menu_txtNT    :=Black;

if menu_bkST<0 then      menu_bkST     :=LightGray;
if menu_txtST<0 then     menu_txtST    :=White;

if menu_bkMarkNT<0 then  menu_bkMarkNT :=Blue;
if menu_txtMarkNT<0 then menu_txtMarkNT:=LightCyan;

if menu_bkMarkST<0 then  menu_bkMarkST :=Blue;
if menu_txtMarkST<0 then menu_txtMarkST:=White;

if menu_visible=255 then menu_visible:=round(gmaxy/3);
if menu_visible>menu_total then menu_visible:=menu_total;
if (menu_visible<=0)or(menu_visible>gmaxy-9) then menu_visible:=gmaxy-9;
if (menu_f<1)or(menu_f>menu_total) then menu_f:=1;
inttemp:=CCLen(menu_name[1]);
for f:=2 to menu_total do if CCLen(menu_name[f])>inttemp then inttemp:=CCLen(menu_name[f]);
if length(menu_title)>inttemp then inttemp:=length(menu_title);
if menu_posx=255 then menu_posx:=(halfmaxx)-round((6+inttemp)/2);
if menu_title<>'' then a:=2 else a:=2;
if menu_posy=255 then menu_posy:=round(halfmaxy-menu_visible/2)-a;
for f:=1 to menu_total do menu_name[f]:=menu_name[f]+space(inttemp-CCLen(menu_name[f]));
if menu_visible>menu_total then f:=menu_total else f:=menu_visible;
if menu_title=''
then
 scputwin(menu_bkNT,menu_txtNT,menu_posx, menu_posy, menu_posx+inttemp+7, menu_posy+f+1)
else
  begin
   scputwin(menu_bkNT,menu_txtNT,menu_posx, menu_posy, menu_posx+inttemp+7, menu_posy+f+3);
   if w_twosided
    then cmprint(menu_bkNT,menu_txtNT,menu_posx, menu_posy+2, chr(199)+fill(inttemp+6,#196)+chr(182))
    else cmprint(menu_bkNT,menu_txtNT,menu_posx, menu_posy+2, ' '+chr(195)+fill(inttemp+4,#196)+chr(180)+' ');
   cmprint(menu_bkNT,menu_txtNT,(menu_posx+round((inttemp+8)/2))-round((length(menu_title))/2), menu_posy+1, menu_title);
  end;
fr:=1;
loop:
  PutItems;
  if Moused then MouseOn;
  menu_kod:=readkey;

  if upcase(menu_kod) in ['A'..'Z'] then
   begin
    for temp:=1 to menu_total do
     begin
      if copy(nospace(menu_name[temp]),3,1)=upcase(menu_kod) then
       begin
        restscr;
        eChooseItem:=temp;
        textattr:=la;
        gotoxy(lx,ly);
        menu_posx:=255; menu_posy:=255;
        exit;
       end;
     end;
   end;
  if menu_kod=#13 then
   begin
    restscr;
    eChooseItem:=menu_f;
    textattr:=la;
    gotoxy(lx,ly);
    menu_posx:=255; menu_posy:=255;
    exit;
   end;
  if menu_kod=#27 then
   begin
    restscr;
    eChooseItem:=0;
    menu_posx:=255; menu_posy:=255;
    exit;
   end;
  if menu_kod=#0 then
   begin
    menu_kod:=readkey;
    if menu_kod=kb_End then
     begin
      restscr;
      eChooseItem:=0;
      menu_posx:=255; menu_posy:=255;
      exit;
     end;
    if (menu_kod=#80)or(menu_kod=#77) then
     begin
      inc(menu_f);
      if menu_f>fr+menu_visible-1 then begin inc(fr); if fr>menu_total-menu_visible+1 then dec(fr); end;
     end;
    if (menu_kod=#72)or(menu_kod=#75) then
     begin
      dec(menu_f);
      if menu_f<fr then begin dec(fr); if fr<1 then inc(fr); end;
     end;
   end;
  if menu_f>menu_total then menu_f:=menu_total;
  if menu_f<1 then menu_f:=1;

if Moused then MouseOff;
goto loop;
end;
{----------------------------------------------------------------------------}

var ll,r,s,t:string; i:integer; d:char; loc,sub:boolean; ab,a,b:byte; l:longint;
const SNS=0; SN=1; DN=2; NC=3;
label loop,out;
begin
r:='';

whatflopp(a,b);
if a<>0 then r:=r+'A';
if b<>0 then r:=r+'B';

{
message('!!!');
{}
r:=r+GetAllDrivers; s:='';
{r:='ABCDEFGHIJKLMNOPQRSTUVWXYZ';{}
if typ<>NC then
BEGIN
menu_total:=length(r);
for i:=1 to length(r) do
 begin
  s:='~`'+r[i]+':~`';

  if (r[i]='A')or(r[i]='B') then if (typ=SN)or(typ=SNS) then
   begin
    s:=s+' Floppy';
    if r[i]='A' then ab:=a;
    if r[i]='B' then ab:=b;
    if typ<>SNS then Case ab of
     1: s:=s+'  360k';
     2: s:=s+'  1.2k';
     3: s:=s+'  720k';
     4: s:=s+'  1.44k';
    End;
   end else
  else
   begin
    if (typ=SN)or(typ=SNS) then
     begin
      isDriveValid(r[i],loc,sub);
      if sub then t:='Subst' else if loc then t:='Local' else t:='NetWork';
      if itcdrom(r[i]) then t:='CD-ROM';

      s:=s+' '+t;

      if typ<>SNS then
       begin
        s:=s+space(7-CCLen(t))+' ';
        l:=disksize(byte(r[i])-64);
        if l>1000 then begin ll:=strr(l div 1000); d:='K'; end;
        if l>1000000 then begin ll:=strr(l div 1000000); d:='M'; end;
        if l>1000000000 then begin ll:=strr(l div 1000000000)+','+copy(strr(l),2,1)+copy(strr(l),3,1); d:='G'; end;
        if l>=0 then t:=ll+d else t:='none';

        s:=s+t+space(7-length(t))+getvolname(byte(r[i])-64);
       end;

     end;
   end;
  if typ=DN then s:=' '+s+' ';
  menu_name[i]:=s;
 end;

d:=cd[1];
for menu_f:=1 to length(r) do if r[menu_f]=upcase(d) then break;

if w=right then menu_posx:=42 else menu_posx:=2;
menu_posy:=3; menu_visible:=maxy-12;

if typ=SNS then inc(menu_posx,10);{}
if typ=DN then begin inc(menu_posx,15); dec(menu_posy); end;

menu_title:='';
if (typ=SN)or(typ=SNS) then if lang=rus then menu_title:='Диск' else menu_title:='Disk';

i:=eChooseItem;
if i=0 then begin ChooseDrive:='0'; exit; end;
ChooseDrive:=r[i];
END
ELSE
BEGIN
if menu_bkNT<0 then      menu_bkNT     :=LightGray;
if menu_txtNT<0 then     menu_txtNT    :=Black;

if menu_bkST<0 then      menu_bkST     :=LightGray;
if menu_txtST<0 then     menu_txtST    :=White;

if menu_bkMarkNT<0 then  menu_bkMarkNT :=Blue;
if menu_txtMarkNT<0 then menu_txtMarkNT:=LightCyan;

if menu_bkMarkST<0 then  menu_bkMarkST :=Blue;
if menu_txtMarkST<0 then menu_txtMarkST:=White;

 if lang=rus then
              if w=left then t:='Выберите ~`левый~` диск:' else t:='Выберите ~`правый~` диск:'
             else
              if w=left then t:='Choose ~`left~` drive:' else t:='Choose ~`right~` drive:';
 if length(r)<=15 then a:=4*length(r) else a:=2*length(r)+2;
 if a<CCLen(t) then a:=CCLen(t);
 if w=right then menu_posx:=80-15-a else menu_posx:=5; menu_posy:=6;

 w_rama:=false;
 scputwin(menu_bkNT,menu_txtNT,menu_posx, menu_posy, menu_posx+a+9, menu_posy+5);
 w_rama:=true;
 w_shadow:=false; w_twosided:=true;
 scputwin(menu_bkNT,menu_txtNT,menu_posx+3, menu_posy+1, menu_posx+a+6, menu_posy+4);
 w_shadow:=true;

 if lang=rus
  then cmPrint(menu_bkNT,menu_txtNT,menu_posx+(a div 2 + 2),menu_posy+1,' Диск ')
  else cmPrint(menu_bkNT,menu_txtNT,menu_posx+(a div 2 + 2),menu_posy+1,' Disk ');

 StatusLineColor(menu_bkNT,menu_txtNT,menu_bkST,menu_txtST,
                 menu_posx+7+(a div 2 - (length(nospaceLR(t)) div 2)), menu_posy+2, t);

 d:=cd[1];
 for menu_f:=1 to length(r) do if d=r[menu_f] then break;

loop:

t:='';
for i:=1 to length(r) do begin t:=t+' '+r[i]; if length(r)<=15 then t:=t+'  '; end;
StatusLineColor(menu_bkNT,menu_txtNT,menu_bkST,menu_txtST,
                menu_posx+4+(a div 2 - (length(nospaceLR(t)) div 2)), menu_posy+3, t);

b:=0;
for i:=1 to length(t) do
 begin
  if t[i]<>' ' then inc(b);
  if b=menu_f then
   begin
    if length(r)<=15
     then PrintSelf(menu_bkMarkNT,menu_txtMarkNT, menu_posx+4+(a div 2 - (length(nospaceLR(t)) div 2))+i-2,menu_posy+3, 3)
     else PrintSelf(menu_bkMarkNT,menu_txtMarkNT, menu_posx+4+(a div 2 - (length(nospaceLR(t)) div 2))+i-1,menu_posy+3, 1);
    break;
   end;
 end;

d:=readkey;
if pos(DnCase(d),strlo(r))<>0 then begin ChooseDrive:=UpCase(d); goto out; end;
if d=kb_Enter then begin ChooseDrive:=r[menu_f]; goto out; end;
if d=kb_ESC then begin ChooseDrive:='0'; goto out; end;
if d=#0 then
 begin
  d:=readkey;
  if d=kb_END then begin ChooseDrive:='0'; goto out; end;
  if d=kb_right then inc(menu_f);
  if d=kb_left then dec(menu_f);
 end;
if menu_f<1 then menu_f:=length(r);
if menu_f>length(r) then menu_f:=1;
goto loop;

out:
restscr; restscr; menu_posx:=255; menu_posy:=255;
END;
end;











{============================================================================}
{== COLOR BUTTON ============================================================}
{============================================================================}
procedure CButton(paper,ink,spaper,sink,x,y:byte; s:string; active:boolean);
begin
if active then begin s[1]:=#16; s[length(s)]:=#17; end;
cmprint(paper,ink,x,y,s); cmprint(spaper,sink,x+length(s),y,#220);
cmprint(spaper,sink,x+1,y+1,fill(length(s),#223));
{if rMoused then MouseShow;{}
end;






procedure rvPutsInit;
BEGIN
menu_visible:=255;
menu_mayins:=false;
menu_posx:=255; menu_posy:=255;

menu_bkNT:=-1; menu_txtNT:=-1;
menu_bkST:=-1; menu_txtST:=-1;
menu_bkMarkNT:=-1; menu_txtMarkNT:=-1;
menu_bkMarkST:=-1; menu_txtMarkST:=-1;

END;
