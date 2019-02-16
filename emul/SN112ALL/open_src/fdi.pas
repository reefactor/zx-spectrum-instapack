{$O+,F+}
Unit FDI;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, TRD, PC, Main_Ovr,TRD_Ovr,FDI_Ovr;

Type
   tfdi=
    record
     kLabel:string[3];
     Flag:byte;
     cyl:word;
     heads:word;
     offText:word;
     offData:word;
     extDataLenHeader:word;
     extDataLen:word;
     offHeaderCyl:word;
    end;


function  fdiNameLine(var p:TPanel; a:word):string;

function  et(n:longint; lang:byte):string; {дорожка}

function  isFDI(var p:TPanel; path:string):boolean;

function  fdiTracks(var p:TPanel; name:string):byte;
procedure fdiMDF(var p:TPanel; path:string);
procedure fdiPDF(var p:TPanel; fr:integer);
function  eb(n:longint; lang:byte):string;   {блок, файл}

Implementation

{============================================================================}
function fdiNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
begin
           p.fdinn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';

           nm:=nm+space(8-length(stemp))+stemp;
fdiNameLine:=nm;
end;





{============================================================================}
function et(n:longint; lang:byte):string; {дорожка}
var
   i:longint;
begin
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: et:='ек';
   1: et:='ка';
   2: et:='ки';
   3: et:='ки';
   4: et:='ки';
   5: et:='ек';
   6: et:='ек';
   7: et:='ек';
   8: et:='ек';
   9: et:='ек';
  end;
  if n=11 then et:='ек';
  if n=12 then et:='ек';
  if n=13 then et:='ек';
  if n=14 then et:='ек';
 end
else
 begin
  if n=1 then et:='' else et:='s';
 end;
end;



{============================================================================}
function isFDI(var p:TPanel; path:string):boolean;
var fb:file of byte;
    a,b:byte;
    i:integer;
    s:string;
label fin,fin2;
begin
isFDI:=false;
{$I-}
filemode:=0;
assign(fb,path); reset(fb);

seek(fb,0); s:='';
read(fb,b); s:=s+chr(b); read(fb,b); s:=s+chr(b); read(fb,b); s:=s+chr(b);
if s<>'FDI' then goto fin;

read(fb,a); p.fdiRec.flag:=a;{3}
read(fb,a); read(fb,b); {4} p.fdiRec.cyl:=a+256*b;
read(fb,a); read(fb,b); {6} p.fdiRec.heads:=a+256*b;
read(fb,a); read(fb,b); {8} p.fdiRec.offText:=a+256*b;
read(fb,a); read(fb,b); {A} p.fdiRec.offData:=a+256*b;
read(fb,a); read(fb,b); {C} p.fdiRec.extDataLenHeader:=a+256*b;
read(fb,a); read(fb,b); {E} p.fdiRec.extDataLen:=a+256*b;
p.fdiRec.offHeaderCyl:=$E+p.fdiRec.extDataLen;

if p.fdiRec.heads<>2 then goto fin;
{
seek(fb,p.fdiRec.offData+$8e3); read(fb,b); if not (b in [$16,$17,$18,$19]) then goto fin;
seek(fb,p.fdiRec.offData+$8e4); read(fb,b); if not (b in [0..128]) then goto fin;{}
seek(fb,p.fdiRec.offData+$8e7); read(fb,b); if not (b in [$10]) then goto fin;
isFDI:=true;
fin:
close(fb);
{$I+}
fin2:
if ioresult<>0 then;
end;
{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}



{============================================================================}
function fdiTracks(var p:TPanel; name:string):byte;
var i:byte;
begin
i:=p.fdiRec.cyl;
fdiTracks:=i;
end;




{============================================================================}
procedure fdiMDF(var p:TPanel; path:string);
var
    fb:file of byte;
    FoundFiles,i,k,trdinsed:integer;
    buf:array[1..16] of byte;
    s:string[8];
    b,b2:byte;
    stemp:string;
begin
if (checkdirfile(path)<>0)or(not isFDI(p,path)) then
 begin
  {
  if lang=rus then errormessage('Hе найден FDI файл')
              else errormessage('FDI file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

k:=0; for i:=1 to p.fditfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

{$I-}
filemode:=0;
assign(fb,path); reset(fb);
seek(fb,4); read(fb,b); p.zxdisk.tracks:=b;

seek(fb,p.fdiRec.offData+$8e1); read(fb,b); p.zxdisk.n1freesec:=b;
seek(fb,p.fdiRec.offData+$8e2); read(fb,b); p.zxdisk.ntr1freesec:=b;
seek(fb,p.fdiRec.offData+$8e3); read(fb,b); p.zxdisk.disktyp:=b;
seek(fb,p.fdiRec.offData+$8e4); read(fb,b); p.zxdisk.files:=b;
seek(fb,p.fdiRec.offData+$8e5); read(fb,b); read(fb,b2); p.zxdisk.free:=b+256*b2;
seek(fb,p.fdiRec.offData+$8e7); read(fb,b); p.zxdisk.trdoscode:=b;
seek(fb,p.fdiRec.offData+$8f4); read(fb,b); p.zxdisk.delfiles:=b;
seek(fb,p.fdiRec.offData+$8f5); stemp:=''; for i:=1 to 8 do begin read(fb,b); stemp:=stemp+chr(b); end;
p.zxdisk.disklabel:=stemp;

p.trddir^[1].name:='<<      ';
p.trddir^[1].typ:='-';
p.trddir^[1].start:=0;
p.trddir^[1].length:=0;
p.trddir^[1].totalsec:=0;
p.trddir^[1].n1sec:=0;
p.trddir^[1].n1tr:=0;
p.trddir^[1].mark:=false;

if Cat9 then
BEGIN
for i:=1 to p.zxDisk.files do
 begin
  seek(fb,p.fdiRec.offData+16*(i-1));
  for k:=0 to 15 do read(fb,buf[k+1]);
  s:=''; for k:=1 to 8 do s:=s+chr(buf[k]);
  p.trddir^[i+1].name:=s;
  p.trddir^[i+1].typ:=chr(buf[9]);
  p.trddir^[i+1].start:=buf[10]+256*buf[11];
  p.trddir^[i+1].length:=buf[12]+256*buf[13];
  p.trddir^[i+1].totalsec:=buf[14];
  p.trddir^[i+1].n1sec:=buf[15];
  p.trddir^[i+1].n1tr:=buf[16];
  p.trddir^[i+1].mark:=false;
 end;
END
ELSE
BEGIN
FoundFiles:=0; i:=1;
While i<=128 do
 begin
  seek(fb,p.fdiRec.offData+16*(i-1));
  for k:=0 to 15 do read(fb,buf[k+1]);
  if (buf[1]<>0){and(buf[1]<>1){} then
   Begin
    s:=''; for k:=1 to 8 do s:=s+chr(buf[k]);
    p.trddir^[i+1].name:=s;
    p.trddir^[i+1].typ:=chr(buf[9]);
    p.trddir^[i+1].start:=buf[10]+256*buf[11];
    p.trddir^[i+1].length:=buf[12]+256*buf[13];
    p.trddir^[i+1].totalsec:=buf[14];
    p.trddir^[i+1].n1sec:=buf[15];
    p.trddir^[i+1].n1tr:=buf[16];
    p.trddir^[i+1].mark:=false;
    Inc(FoundFiles);
   End else Break;
   inc(i);
 end;
if p.zxDisk.files<>FoundFiles then
 if LANG=rus then errormessage('Количеcтво файлов не cовпадает cо значением 9ого cектоpа')
             else errormessage('Directory size is not equ 9th sector value');
if p.zxDisk.files>FoundFiles then p.zxDisk.files:=FoundFiles;
END;

p.fditfiles:=p.zxdisk.files; inc(p.fditfiles);

close(fb);
{$I+}
if ioresult<>0 then;

for i:=1 to trdinsed do for k:=1 to p.fditfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;
end;



{============================================================================}
procedure fdiPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
begin

if p.paneltype<>fdiPanel then exit;

n:=p.fditfiles;

if n>fr-1+p.panelhi*p.Columns then n:=fr-1+p.panelhi*p.Columns;
px:=p.posx+1; py:=p.putfrom;
Case p.Columns of 1: dx:=13; 2: dx:=19; 3: dx:=13; End;
for i:=fr to n do
 begin
  if (px=21)or(px=61) then ddx:=1 else ddx:=0;
  name:=p.trdDir^[i].name;
  if i=1
    then name:='<<'+space(dx+ddx-3)
    else name:=name+space((dx+ddx-5)-length(name))+' '+TRDOSe3(p,i);

  paper:=pal.bkNT; ink:=pal.txtNT;
  e:=TRDOSe3(p,i);
  col(e,p.trdDir^[i].length,paper,ink);
  if (ord(p.trdDir^[i].name[1])=1)or(ord(p.trdDir^[i].name[1])=0) then begin paper:=pal.bkg4; ink:=pal.txtg4; end;
  if i=1 then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
  pp:=paper; ii:=ink;
  if p.trddir^[i].mark then begin paper:=pal.bkST; ink:=pal.txtST; end;

  if p.focused and(i=p.from+p.f-1) then begin paper:=pal.bkCurNT; ink:=pal.txtCurNT; end;
  if p.focused and(i=p.from+p.f-1)and(p.trddir^[i].mark) then begin paper:=pal.bkCurST; ink:=pal.txtCurST; end;

  if p.trddir^[i].mark then name[(dx+ddx-4)]:=#251;

  cmprint(paper,ink,px,py,name);

  s:=space(25);
  if p.Columns=1 then
   begin
    cmprint(paper,ink,px+13,py,s); cmprint(paper,pal.TxtRama,px+12,py,'│');
   end;

  if ii=paper then ii:=ink;                                    {
  if p.focused and(i=p.from+p.f-1) then ii:=txtCurNT;
  if p.focused and(i=p.from+p.f-1)and(p.pcdir^[i].mark) then
    begin ii:=     ink; if ii=bkCurST then ii:=txtCurST; end;  {}
  PrintSelf(paper,ii,px+(dx+ddx-5),py,1);

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
    cmprint(pal.bkNT,pal.txtNT,px+13,py,space(25)); cmprint(pal.bkRama,pal.TxtRama,px+12,py,'│');
   end;
  inc(py);
  if py>p.panelhi+p.putfrom-1 then begin py:=p.putfrom; inc(px,dx); end;
 end;
end;




{============================================================================}
function eb(n:longint; lang:byte):string;   {блок, файл}
var
   i:longint; s:string;
begin
s:=(strr(n));
s:=s[length(s)-1]+s[length(s)];
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: eb:='ов';
   1: eb:='';
   2: eb:='а';
   3: eb:='а';
   4: eb:='а';
   5: eb:='ов';
   6: eb:='ов';
   7: eb:='ов';
   8: eb:='ов';
   9: eb:='ов';
  end;
  if n=11 then eb:='ов';
  if n=12 then eb:='ов';
  if n=13 then eb:='ов';
  if n=14 then eb:='ов';
  if vall(s)=11 then eb:='ов';
  if vall(s)=12 then eb:='ов';
  if vall(s)=13 then eb:='ов';
  if vall(s)=14 then eb:='ов';
 end
else
 begin
  if n=1 then eb:='' else eb:='s';
 end;
end;







Begin
sBar[rus,fdiPanel]:='~`Alt+X~` Выход ~` F3~` Смотp ~` F5~` Копия ~` F6~` Перем ~` F7~` Упл ~` F8~` Удалить ~` F9~` Метка ~`';
sBar[eng,fdiPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F7~` Move ~` F8~` Delete ~` F9~` Label ~`';
End.