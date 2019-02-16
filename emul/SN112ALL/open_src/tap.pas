{$O+,F+}
Unit TAP;
Interface
Uses
     Crt,RV,sn_Obj, Vars, Palette, Main, Utils, Main_Ovr;

function tapNameLine(var p:TPanel; a:word):string;
function  isTAP(path:string):boolean;
procedure tapMDF(var p:TPanel; path:string);
procedure tapPDF(var p:TPanel; fr:integer);
function  ewitems(n:longint; lang:byte):string; {§ ―¨αμ}
function  ei(n:longint; lang:byte):string; {§ ―¨αμ}
procedure CheckTapInsed;


Implementation
Uses
     TRD;

{============================================================================}
function tapNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
begin
           if p.trddir^[a].tapflag=0 then
            begin
             nm:=nospaceLR(p.trddir^[a].name);
             nm:=nm+space(12-length(nm));

             if p.trdDir^[a].taptyp=0
              then stemp:=ChangeChar(extnum(strr(p.trdDir^[a].param2)),' ',',')
              else stemp:=ChangeChar(extnum(strr(p.trdDir^[a].start)),' ',',');
             nm:=nm+space(9-length(stemp))+stemp; {}

             stemp:=ChangeChar(extnum(strr(p.trdDir^[a].param1)),' ',',');
             nm:=nm+space(9-length(stemp))+stemp; {}

             if (p.trdDir^[a].taptyp=0)and(p.trdDir^[a].tapflag=0) then
              begin
               if (p.trddir^[a].start>9999) then stemp:='none' else stemp:=strr(p.trddir^[a].start);
               stemp:='('+space(4-length(stemp))+stemp+')';
               nm:=nm+space(8-length(stemp))+stemp;
              end;
            end
           else
            begin
             if lang=rus then nm:='±„ ­­λ¥±±±' else nm:='±Data±±±±±';

             stemp:=strr(p.trdDir^[a].tapflag);
             nm:=nm+space(11-length(stemp))+stemp;

{             nm:=nm+space(11-length(nm));{}

             stemp:=ChangeChar(extnum(strr(p.trdDir^[a].length)),' ',',');
             nm:=nm+space(9-length(stemp))+stemp;{}
            end;
tapNameLine:=nm;
end;


{============================================================================}
function ewitems(n:longint; lang:byte):string; {§ ―¨αμ}
var
   i:longint;
begin
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: ewitems:='οε';
   1: ewitems:='¨';
   2: ewitems:='οε';
   3: ewitems:='οε';
   4: ewitems:='οε';
   5: ewitems:='οε';
   6: ewitems:='οε';
   7: ewitems:='οε';
   8: ewitems:='οε';
   9: ewitems:='οε';
  end;
  if n=11 then ewitems:='οε';
  if n=12 then ewitems:='οε';
  if n=13 then ewitems:='οε';
  if n=14 then ewitems:='οε';
 end
else
 begin
  if n=1 then ewitems:='' else ewitems:='s';
 end;
end;


{============================================================================}
function ei(n:longint; lang:byte):string; {§ ―¨αμ}
var
   i:longint;
begin
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: ei:='¥©';
   1: ei:='μ';
   2: ei:='¨';
   3: ei:='¨';
   4: ei:='¨';
   5: ei:='¥©';
   6: ei:='¥©';
   7: ei:='¥©';
   8: ei:='¥©';
   9: ei:='¥©';
  end;
  if n=11 then ei:='¥©';
  if n=12 then ei:='¥©';
  if n=13 then ei:='¥©';
  if n=14 then ei:='¥©';
 end
else
 begin
  if n=1 then ei:='' else ei:='s';
 end;
end;


{============================================================================}
function isTAP(path:string):boolean;
type tbuf=array[1..2] of byte;
var fb:file of byte; f:file;
    b,b1,cs,csf:byte;
    w,i:word;
    buf:^tbuf;
label fin;
begin
isTAP:=false;
if strlo(nospace(getof(path,_ext)))<>'.tap' then exit;
{$I-}
filemode:=0;
assign(fb,path); reset(fb);  assign(f,path); reset(f,1);
if filesize(fb)=0 then begin isTAP:=true; goto fin; end;
seek(fb,0); read(fb,b); read(fb,b1); w:=b+256*b1;
seek(fb,2); read(fb,csf);

getmem(buf,w-2);
seek(f,filepos(fb)); blockread(f,buf^,w-2);
for i:=1 to w-2 do begin b:=buf^[i]; csf:=csf xor b; end;
freemem(buf,w-2);

seek(fb,w+1); read(fb,cs);
if cs=csf then isTAP:=true;

fin:
close(fb); close(f);
{$I+}
if ioresult<>0 then;
end;


{============================================================================}
procedure tapMDF(var p:TPanel; path:string);
type tbuf=array[1..2] of byte;
var
    fb:file of byte; f:file;
    k,m,w,i,trdinsed:word;
    pos:longint;
    b,b1,cs,csf:byte;
    buf:^tbuf;
    s:string;
begin
{message(path);{}
if (checkdirfile(path)<>0)or(not isTAP(path)) then
 begin
  {
  if lang=rus then errormessage('H¥ ­ ©¤¥­ TAP δ ©«')
              else errormessage('TAP file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

k:=0; for i:=1 to p.taptfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

{$I-}
p.zxdisk.n1freesec:=0;
p.zxdisk.ntr1freesec:=0;
p.zxdisk.disktyp:=0;
p.zxdisk.free:=0;
p.zxdisk.trdoscode:=16;
p.zxdisk.delfiles:=0;
p.zxdisk.disklabel:='Tape';
p.zxdisk.files:=0;

filemode:=0; pos:=0; p.taptfiles:=1;
p.trddir^[1].name:='<<        ';
p.trddir^[1].length:=0;
p.trddir^[1].tapflag:=0;
p.trddir^[1].taptyp:=0;
p.trddir^[1].mark:=false;

p.taptfiles:=1;
assign(fb,path); reset(fb);  assign(f,path); reset(f,1);
for m:=1 to 256 do
 begin
  seek(fb,pos); if EOF(fb) then break;{}
  read(fb,b); read(fb,b1); w:=b+256*b1;  read(fb,csf);{}
  if EOF(fb) then break;{}

  getmem(buf,w-2); p.trdDir^[p.taptfiles+1].offset:=pos+3;
  seek(f,pos+2); blockread(f,buf^,w-1);
  for i:=2 to w-1 do csf:=csf xor buf^[i];
  seek(fb,pos+w+1); read(fb,cs);

  if buf^[1]=0 then
   begin
    inc(p.taptfiles); inc(pos,2+w);
    s:=''; for i:=3 to 12 do s:=s+chr(buf^[i]);

    i:=13; b:=buf^[i]; i:=14; b1:=buf^[i];
    p.trddir^[p.taptfiles].param1:=b+256*b1;
    i:=17; b:=buf^[i]; i:=18; b1:=buf^[i];
    p.trddir^[p.taptfiles].param2:=b+256*b1;
    i:=15; b:=buf^[i]; i:=16; b1:=buf^[i];
    p.trddir^[p.taptfiles].start:=b+256*b1;
   end;
  if buf^[1]<>0 then
   begin
    inc(p.taptfiles); inc(pos,2+w);
    s:='±±±±±±±±±±';{}
    {s:='°°°°°°°°°°';{}
    p.trddir^[p.taptfiles].param2:=0;
    p.trddir^[p.taptfiles].start:=0;
   end;

  p.trddir^[p.taptfiles].name:=s;
  p.trddir^[p.taptfiles].length:=w-2;
  p.trddir^[p.taptfiles].tapflag:=buf^[1];
  p.trddir^[p.taptfiles].taptyp:=buf^[2];
  p.trddir^[p.taptfiles].mark:=false;

  freemem(buf,w-2);
 end;
close(fb); close(f);
{$I+}
if ioresult<>0 then;

for i:=1 to trdinsed do for k:=1 to p.taptfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;

p.zxdisk.files:=p.taptfiles-1;
end;



{============================================================================}
procedure tapPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,iii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
begin
if p.paneltype<>tapPanel then exit;
n:=p.taptfiles; px:=p.posx+1; py:=p.putfrom;
Case p.Columns of 1: dx:=13; 2: dx:=19; 3: dx:=13; End;

if n>fr-1+p.panelhi*p.Columns then n:=fr-1+p.panelhi*p.Columns;
for i:=fr to n do
 begin
  if (px=21)or(px=61) then ddx:=1 else ddx:=0;
  name:=p.trdDir^[i].name;
  if i=1 then name:='<<'+space(dx+ddx-3) else
   begin
    name:=name+space(dx+ddx-3-length(name));
    if p.trdDir^[i].tapflag=0 then
     case p.trdDir^[i].taptyp of
      0: name:=name+' P';
      1: name:=name+' N';
      2: name:=name+' C';
      3: name:=name+' B';
     end
    else
     name:=name+'  ';
   end;
  paper:=pal.bkNT; ink:=pal.txtNT;

  if p.trdDir^[i].tapflag=0 then
   begin
    if p.trdDir^[i].taptyp=0 then e:='>'+'P'+'<';
    if p.trdDir^[i].taptyp=1 then e:='>'+'N'+'<';
    if p.trdDir^[i].taptyp=2 then e:='>'+'C'+'<';
    if p.trdDir^[i].taptyp=3 then e:='>'+'B'+'<';
   end
  else
   begin
    e:='';
   end;
  col(e,p.trdDir^[i].length,paper,ink);
  if i=1 then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
  pp:=paper; ii:=ink; iii:=ink;

  if p.trddir^[i].mark then begin paper:=pal.bkST; ink:=pal.txtST; end;
  if p.focused and(i=p.from+p.f-1) then begin paper:=pal.bkCurNT; ink:=pal.txtCurNT; end;
  if p.focused and(i=p.from+p.f-1)and(p.trddir^[i].mark) then begin paper:=pal.bkCurST; ink:=pal.txtCurST; end;
  if p.trddir^[i].mark then name[(dx+ddx-2)]:=#251;

  cmprint(paper,ink,px,py,name);

  s:=space(25);
  if p.Columns=1 then
   begin
    cmprint(paper,ink,px+13,py,s); cmprint(paper,pal.TxtRama,px+12,py,'³');
   end;

  if ii=paper then ii:=ink;                                        {
  if p.focused and(i=p.from+p.f-1) then ii:=txtCurNT;
  if p.focused and(i=p.from+p.f-1)and(p.pcdir^[i].mark) then
    begin ii:=iii; if ii=bkCurST then ii:=txtCurST; end;         {}
  PrintSelf(paper,ii,px+(dx+ddx-3),py,1);

  inc(py);
  if py>p.panelhi+p.putfrom-1 then begin py:=p.putfrom; inc(px,dx); end;
 end;

for i:=n+1 to p.panelhi*p.Columns do
 begin
  if (px=21)or(px=61) then ddx:=1 else ddx:=0;
  name:=space(dx+ddx-1);
  cmprint(pal.bkNT,pal.txtNT,px,py,name);
  if p.Columns=1 then
   begin
    cmprint(pal.bkNT,pal.txtNT,px+13,py,space(25)); cmprint(pal.bkRama,pal.TxtRama,px+12,py,'³');
   end;
  inc(py);
  if py>p.panelhi+p.putfrom-1 then begin py:=p.putfrom; inc(px,dx); end;
 end;
{if rMoused then MouseShow;{}
end;



{============================================================================}
procedure CheckTapInsed;
Var
    i:integer; otp,tp:TPanel;
Begin
Case focus of
 left:  begin tp:=lp; otp:=rp; end;
 right: begin tp:=lp; otp:=lp; end;
End;
if otp.PanelType=tapPanel then for i:=1 to otp.taptfiles do
 begin
  if otp.trdDir^[i].tapflag=0 then if otp.trdDir^[i].mark then otp.trdDir^[i].mark:=false;
 end;
End;




Begin
sBar[rus,tapPanel]:='~`Alt+X~` ‚λε®¤ ~` F3~` ‘¬®βp ~` F5~` ®―¨ο ~` F6~` ¥ΰ¥¬ ~` F8~` “¤ «¨βμ ';
sBar[eng,tapPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F8~` Delete ';
End.