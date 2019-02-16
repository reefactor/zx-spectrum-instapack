{$O+,F+}
Unit SCL;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, TRD, Main_Ovr;

function  sclNameLine(var p:TPanel; a:word):string;
Function  isSCL(path:string):boolean;
Procedure sclMDF(var p:TPanel; path:string);
Procedure sclPDF(var p:TPanel; fr:integer);

Implementation

{============================================================================}
function sclNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
begin
           p.sclnn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';

           nm:=nm+space(8-length(stemp))+stemp;
sclNameLine:=nm;
end;


{============================================================================}
Function isSCL(path:string):boolean;
type
    tbuf=array[1..2] of byte;
var
    ff:file;
    s:string; cs,l:longint; bufsize,w,nr:word;
    buf:^tbuf;

label fin;
Begin
isSCL:=false;
{$I-}
getmem(buf,8);
filemode:=0; assign(ff,path); reset(ff,1); seek(ff,0);
BlockRead(ff,buf^,8,nr);
s:=''; for w:=1 to 8 do s:=s+chr(buf^[w]);
freemem(buf,8);
if s<>'SINCLAIR' then goto fin;
l:=0;
if MemAvail<49152 then bufsize:=MemAvail-10240 else bufsize:=49152;
getmem(buf,bufsize);
seek(ff,0);
Repeat
BlockRead(ff,buf^,bufsize,nr);
if nr=bufsize then for w:=1 to bufsize do inc(l,buf^[w]);
if (nr<>bufsize)and(nr<>0) then
 begin
  cs:=(buf^[nr-3]+256*buf^[nr-2])+65536*(buf^[nr-1]+256*buf^[nr-0]);
  dec(nr,4);
  for w:=1 to nr do inc(l,buf^[w]);
 end;
Until nr=0;
freemem(buf,bufsize);

{errormessage(strr(l)+' - '+strr(cs)+' = '+strr(l-cs));{}

if (cs=l)or(cs=l-65536) then isSCL:=true;
fin:
Close(ff);
{$I+}
if ioresult<>0 then;
end;




{============================================================================}
Procedure sclMDF(var p:TPanel; path:string);
var
    fb:file of byte;
    i,k,trdinsed:integer;
    buf:array[1..16] of byte;
    s:string[8];
    b:byte;
begin
{message(strr(checkdirfile(path))+' '+path);{}
if (checkdirfile(path)<>0)or(not isSCL(path)) then
 begin
  {
  if lang=rus then errormessage('Hе найден SCL файл')
              else errormessage('SCL file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

{$I-}
k:=0; for i:=1 to p.scltfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

filemode:=0;
assign(fb,path); reset(fb);

seek(fb,$8); read(fb,b); p.scltfiles:=b;
p.zxdisk.files:=p.scltfiles; inc(p.scltfiles);
p.zxdisk.n1freesec:=0;
p.zxdisk.ntr1freesec:=0;
p.zxdisk.disktyp:=0;
p.zxdisk.free:=0;
p.zxdisk.trdoscode:=16;
p.zxdisk.delfiles:=0;
p.zxdisk.disklabel:='Hobeta98';

p.trddir^[1].name:='<<      ';
p.trddir^[1].typ:='-';
p.trddir^[1].start:=0;
p.trddir^[1].length:=0;
p.trddir^[1].totalsec:=0;
p.trddir^[1].n1sec:=0;
p.trddir^[1].n1tr:=0;
p.trddir^[1].mark:=false;

for i:=1 to p.scltfiles do
 begin
  seek(fb,9+14*(i-1));
  for k:=0 to 13 do read(fb,buf[k+1]);
  s:='';
  for k:=1 to 8 do s:=s+chr(buf[k]);
  p.trddir^[i+1].name:=s;
  p.trddir^[i+1].typ:=chr(buf[9]);
  p.trddir^[i+1].start:=buf[10]+256*buf[11];
  p.trddir^[i+1].length:=buf[12]+256*buf[13];
  p.trddir^[i+1].totalsec:=buf[14];
  p.trddir^[i+1].n1sec:=0;
  p.trddir^[i+1].n1tr:=0;
  p.trddir^[i+1].mark:=false;
 end;

close(fb);
{$I+}
if ioresult<>0 then;

for i:=1 to trdinsed do for k:=1 to p.scltfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;
End;



{============================================================================}
Procedure sclPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
Begin

if p.paneltype<>sclPanel then exit;

n:=p.scltfiles;
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

  if ii=paper then ii:=ink;                                      {
  if p.focused and(i=p.from+p.f-1) then ii:=txtCurNT;
  if p.focused and(i=p.from+p.f-1)and(p.pcdir^[i].mark) then
    begin ii:=ink; if ii=bkCurST then ii:=txtCurST; end;         {}
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
End;








Begin
sBar[rus,sclPanel]:='~`Alt+X~` Выход ~` F3~` Смотp ~` F5~` Копия ~` F6~` Перем ~` F8~` Удалить ';
sBar[eng,sclPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F8~` Delete ';
End.
