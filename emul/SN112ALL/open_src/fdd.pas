{$O+,F+}
Unit FDD;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, TRD, Main_Ovr, PC;

Type
   tfdd=
    record
     head:string;
     trkMax:byte;
     headMax:byte;
    end;
Var
    fddRec:tfdd;
    fddSectorBuf:array[0..255] of byte;


function  fddNameLine(var p:TPanel; a:word):string;
function  isFDD(path:string):boolean;
procedure fddReadSector(fddfile:string; t,s:byte);
procedure fddWriteSector(fddfile:string; t,s:byte);

procedure fddMDF(var p:TPanel; path:string);
procedure fddPDF(var p:TPanel; fr:integer);




Implementation


{============================================================================}
function  fddNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
Begin
           p.fddnn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';

           nm:=nm+space(8-length(stemp))+stemp;
fddNameLine:=nm;
End;


{============================================================================}
function  isFDD(path:string):boolean;
var ff:file; s:string; i:integer; b:byte;
Begin
isFDD:=false;
if checkdirfile(path)<>0 then exit;
{$I-}
assign(ff,path); filemode:=0; reset(ff,1); blockread(ff,fddSectorBuf,256); close(ff);
{$I+}
if IOResult<>0 then exit;
s:=''; for i:=1 to 30 do s:=s+chr(fddSectorBuf[i-1]);
fddRec.Head:=s;                     if copy(s,1,8)<>'SPM DISK' then exit;
fddRec.trkMax:=fddSectorBuf[$1f-1];
fddRec.headMax:=fddSectorBuf[$20-1];
if fddRec.headMax<>2 then exit;

fddReadSector(path,0,9);
{
b:=fddSectorBuf[$e3]; if not (b in [$16,$17,$18,$19]) then exit;
b:=fddSectorBuf[$e4]; if not (b in [0..128]) then exit;
{}
b:=fddSectorBuf[$e7]; if not (b in [$10]) then exit;

isFDD:=true;{}
End;


{============================================================================}
procedure fddReadSector(fddfile:string; t,s:byte);
var ff:file; buf:array[1..8] of byte; indx:longint; b:byte;
    w1,w2:word;
Begin
{$I-}
assign(ff,fddfile); filemode:=0; reset(ff,1); seek(ff,36+t*4);
blockread(ff,buf,4);
w1:=Buf[1]+256*Buf[2]; w2:=Buf[3]+256*Buf[4]; indx:=w1+65536*w2;
seek(ff,indx); blockread(ff,buf,2);
seek(ff,filepos(ff)+(s-1)*8); blockread(ff,Buf,8);
w1:=Buf[5]+256*Buf[6]; w2:=Buf[7]+256*Buf[8]; indx:=w1+65536*w2;
seek(ff,indx); blockread(ff,fddSectorBuf,256);
close(ff);
{$I+}
if IOResult<>0 then{ errormessage('FDD: Sector read error. Track '+strr(t)+', sector '+strr(s)){};
End;



{============================================================================}
procedure fddWriteSector(fddfile:string; t,s:byte);
var ff:file; buf:array[1..8] of byte; indx:longint; b:byte;
    w1,w2:word;
Begin
{$I-}
assign(ff,fddfile); filemode:=2;
reset(ff,1); if ioresult<>0 then;
seek(ff,36+t*4);
blockread(ff,buf,4);
w1:=Buf[1]+256*Buf[2]; w2:=Buf[3]+256*Buf[4]; indx:=w1+65536*w2;
seek(ff,indx); blockread(ff,buf,2);
seek(ff,filepos(ff)+(s-1)*8); blockread(ff,Buf,8);
w1:=Buf[5]+256*Buf[6]; w2:=Buf[7]+256*Buf[8]; indx:=w1+65536*w2;
seek(ff,indx); blockWrite(ff,fddSectorBuf,256);
close(ff);
{$I+}
if IOResult<>0 then{ errormessage('FDD: Sector write error. Track '+strr(t)+', sector '+strr(s)){};
End;



{============================================================================}
procedure fddMDF(var p:TPanel; path:string);
var ff:file; buf:array[1..8] of byte; indx:longint;
{----------------------------------------------------------------------------}
procedure ReadSector(fddfile:string; t,s:byte);
Begin
{$I-}
seek(ff,36+t*4);
blockread(ff,buf,4);
indx:=(Buf[1]+256*Buf[2])+65536*(Buf[3]+256*Buf[4]);{}
seek(ff,indx); blockread(ff,buf,2);
seek(ff,filepos(ff)+(s-1)*8); blockread(ff,Buf,8);
indx:=(Buf[5]+256*Buf[6])+65536*(Buf[7]+256*Buf[8]);{}
seek(ff,indx); blockread(ff,fddSectorBuf,256);
{$I+}
if IOResult=0 then;
End;
{----------------------------------------------------------------------------}
var sec,n:byte; s:string; FoundFiles,ffile,k,i,trdinsed:integer;
begin

if (checkdirfile(path)<>0)or(not isFDD(path)){} then
 begin
  {
  if lang=rus then errormessage('Hе найден FDD файл')
              else errormessage('FDD file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

{$I-}
k:=0; for i:=1 to p.fddtfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

assign(ff,p.fddfile); filemode:=0; reset(ff,1);
blockread(ff,fddSectorBuf,32); p.zxdisk.tracks:=fddSectorBuf[$1E];

ReadSector(p.fddfile,0,9);

p.zxDisk.files:=fddSectorBuf[$e4];
p.zxDisk.n1freesec:=fddSectorBuf[$e1];
p.zxDisk.ntr1freesec:=fddSectorBuf[$e2];
p.zxDisk.disktyp:=fddSectorBuf[$e3];
p.zxDisk.free:=fddSectorBuf[$e5]+256*fddSectorBuf[$e6];
p.zxDisk.trdoscode:=fddSectorBuf[$e7];
p.zxDisk.delfiles:=fddSectorBuf[$f4];
s:=''; for i:=1 to 8 do begin s:=s+chr(fddSectorBuf[$f5+i-1]); end;
p.zxdisk.disklabel:=s;

p.trddir^[1].name:='<<      ';
p.trddir^[1].typ:='-';
p.trddir^[1].start:=0;
p.trddir^[1].length:=0;
p.trddir^[1].totalsec:=0;
p.trddir^[1].n1sec:=0;
p.trddir^[1].n1tr:=0;
p.trddir^[1].mark:=false;

ffile:=2; FoundFiles:=0;
for sec:=1 to 8 do
 begin
  ReadSector(p.fddfile,0,sec);
  for n:=1 to 16 do
   begin
{    ffile:=16*(sec-1)+n+1;{}
    if Cat9 then
     BEGIN
      s:=''; for i:=1 to 8 do s:=s+chr(fddSectorBuf[16*(n-1)+i-1]);
      p.trddir^[ffile].name    :=s+space(8-length(s));
      p.trddir^[ffile].typ     :=chr(fddSectorBuf[16*(n-1)+9-1]);
      p.trddir^[ffile].start   :=256*fddSectorBuf[16*(n-1)+11-1]+fddSectorBuf[16*(n-1)+10-1];
      p.trddir^[ffile].length  :=256*fddSectorBuf[16*(n-1)+13-1]+fddSectorBuf[16*(n-1)+12-1];
      p.trddir^[ffile].totalsec:=fddSectorBuf[16*(n-1)+14-1];
      p.trddir^[ffile].n1sec   :=fddSectorBuf[16*(n-1)+15-1];
      p.trddir^[ffile].n1tr    :=fddSectorBuf[16*(n-1)+16-1];
      p.trddir^[ffile].mark    :=false;
      Inc(ffile);
     END
    ELSE
     BEGIN
      if fddSectorBuf[16*(n-1)]<>0 then
       Begin
        s:=''; for i:=1 to 8 do s:=s+chr(fddSectorBuf[16*(n-1)+i-1]);
        p.trddir^[ffile].name    :=s+space(8-length(s));
        p.trddir^[ffile].typ     :=chr(fddSectorBuf[16*(n-1)+9-1]);
        p.trddir^[ffile].start   :=256*fddSectorBuf[16*(n-1)+11-1]+fddSectorBuf[16*(n-1)+10-1];
        p.trddir^[ffile].length  :=256*fddSectorBuf[16*(n-1)+13-1]+fddSectorBuf[16*(n-1)+12-1];
        p.trddir^[ffile].totalsec:=fddSectorBuf[16*(n-1)+14-1];
        p.trddir^[ffile].n1sec   :=fddSectorBuf[16*(n-1)+15-1];
        p.trddir^[ffile].n1tr    :=fddSectorBuf[16*(n-1)+16-1];
        p.trddir^[ffile].mark    :=false;
        Inc(ffile);
        Inc(FoundFiles);
       End;
     END;
   end;
 end;

if not Cat9 then
 BEGIN
  if p.zxDisk.files<>FoundFiles then
   if LANG=rus then errormessage('Количеcтво файлов не cовпадает cо значением 9ого cектоpа')
               else errormessage('Directory size is not equ 9th sector value');
  if p.zxDisk.files>FoundFiles then p.zxDisk.files:=FoundFiles;
 END;

p.fddtfiles:=p.zxDisk.files; inc(p.fddtfiles);

close(ff);
{$I+}
if IOResult=0 then;

for i:=1 to trdinsed do for k:=1 to p.fddtfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;
End;



{============================================================================}
procedure fddPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
Begin

if p.paneltype<>fddPanel then exit;

n:=p.fddtfiles;
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

  if ii=paper then ii:=ink;
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
sBar[rus,fddPanel]:='~`Alt+X~` Выход ~` F3~` Смотp ~` F5~` Копия ~` F6~` Перем ~` F7~` Упл ~` F8~` Удалить ~` F9~` Метка ~`';
sBar[eng,fddPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F7~` Move ~` F8~` Delete ~` F9~` Label ~`';

End.