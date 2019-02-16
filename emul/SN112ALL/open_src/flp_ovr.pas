{$O+,F+}
Unit FLP_Ovr;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, Main_Ovr,PC,PC_Ovr,FLP,TRD_Ovr,TRD;

Function  flpLoad(var p:TPanel; ind:word; What:char):boolean;
Function  flpSave(var p:TPanel; What:char):boolean;
function  flpDel(var p:TPanel; What:char):boolean;
function  flpRename(What:char):boolean;
function  flpLabel(What:char):boolean;
function  flpMove(var p:Tpanel; What:char):boolean;


Implementation

Uses trdos, mouse;

{============================================================================}
Function flpLoad(var p:TPanel; ind:word; What:char):boolean;
Var
    bufpos,i,k:word; t,s, t_old,t_,s_,h_:byte;
Begin
HobetaInfo.name:=p.trdDir^[ind].name;
HobetaInfo.typ:=p.trdDir^[ind].typ;
HobetaInfo.start:=p.trdDir^[ind].start;
HobetaInfo.length:=p.trdDir^[ind].length;
HobetaInfo.param2:=p.trdDir^[ind].length;
if HobetaInfo.typ<>'B' then HobetaInfo.param2:=32768;
HobetaInfo.totalsec:=p.trdDir^[ind].totalsec;

flpLoad:=false;
{$I-}
if not InitFDD(What,CheckMedia) then exit;

GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);

s:=p.trdDir^[ind].n1sec+1; t:=p.trdDir^[ind].n1tr; bufpos:=1;
t_old:=0;
for i:=1 to p.trdDir^[ind].totalsec do
 Begin
  t_:=t div 2;
  h_:=t-2*t_;
  s_:=s;
  if t_<>t_old then zxSeek(FDDType,t_);
  ReadSector(@RealBuf,FDDType,t_,h_,s_,1);
  t_old:=t_;
  for k:=0 to 255 do begin HobetaInfo.body^[bufpos]:=RealBuf[k]; inc(bufpos); end;
  inc(s); if s>16 then begin s:=1; inc(t); end;
 End;
{$I+}
FreeFDDRes; { Восстановление старых параметров дисковода }
if ioresult=0 then flpLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;


{============================================================================}
Function flpSave(var p:TPanel; What:char):boolean;
Var f:file; t_,h_,s_,k,i,b:byte; buf:array[0..15]of byte; m,bufpos:word;
    tot,t1,t2:integer;

Begin
flpSave:=false;
if not InitFDD(What,CheckMedia) then exit;
{$I-}
inc(p.zxdisk.files);
dec(p.zxdisk.free,hobetainfo.totalsec);

p.trdDir^[p.zxdisk.files].name:=HobetaInfo.name;
p.trdDir^[p.zxdisk.files].typ:=HobetaInfo.typ;
p.trdDir^[p.zxdisk.files].start:=HobetaInfo.start;
p.trdDir^[p.zxdisk.files].length:=HobetaInfo.length;
p.trdDir^[p.zxdisk.files].totalsec:=HobetaInfo.totalsec;
p.trdDir^[p.zxdisk.files].n1tr:=p.zxDisk.nTr1FreeSec;
p.trdDir^[p.zxdisk.files].n1sec:=p.zxDisk.n1FreeSec;

bufpos:=1;
tot:=hobetainfo.totalsec;
t1:=16-p.zxDisk.n1freesec;

  t_:=p.zxDisk.ntr1freesec div 2;
  h_:=p.zxDisk.ntr1freesec-2*t_;
  s_:=p.zxDisk.n1freesec+1;

  for m:=1 to t1*256 do begin RealBuf[m-1]:=HobetaInfo.body^[bufpos]; inc(bufpos); end;
  zxSeek(FDDType,t_);{}
  WriteSector(@RealBuf,FDDType,t_,h_,s_,t1);

  s_:=1; if h_=0 then h_:=1 else h_:=0;
  if h_=0 then inc(t_);
  dec(tot,t1); if tot<0 then tot:=0;

t2:=tot div 16;
while t2>0 do
 begin
  for m:=1 to 16*256 do begin RealBuf[m-1]:=HobetaInfo.body^[bufpos]; inc(bufpos); end;
  zxSeek(FDDType,t_);{}
  WriteSector(@RealBuf,FDDType,t_,h_,s_,16);
  s_:=1; if h_=0 then h_:=1 else h_:=0;
  if h_=0 then inc(t_);

  dec(t2);
 end;
dec(tot,(tot div 16)*16); if tot<0 then tot:=0;

if tot>0 then
 begin
  for m:=1 to tot*256 do begin RealBuf[m-1]:=HobetaInfo.body^[bufpos]; inc(bufpos); end;
  zxSeek(FDDType,t_);{}
  WriteSector(@RealBuf,FDDType,t_,h_,s_,tot);
 end;

for i:=1 to hobetainfo.totalsec do
 Begin
  inc(p.zxDisk.n1freesec);
  if p.zxDisk.n1freesec>15 then begin p.zxDisk.n1freesec:=0; inc(p.zxDisk.ntr1freesec); end;
 End;

zxSeek(FDDType,0);
ReadSector(@RealBuf,FDDType,0,0,9,1);
RealBuf[$e1]:=p.zxdisk.n1freesec;
RealBuf[$e2]:=p.zxdisk.ntr1freesec;
RealBuf[$e4]:=p.zxdisk.files;
RealBuf[$e5]:=lo(p.zxdisk.free);
RealBuf[$e6]:=hi(p.zxdisk.free);
WriteSector(@RealBuf,FDDType,0,0,9,1);

for i:=1 to 8 do buf[i-1]:=ord(p.trddir^[p.zxdisk.files].name[i]);
buf[8]:=ord(p.trddir^[p.zxdisk.files].typ);
buf[9]:=lo(p.trddir^[p.zxdisk.files].start);
buf[10]:=hi(p.trddir^[p.zxdisk.files].start);
buf[11]:=lo(p.trddir^[p.zxdisk.files].length);
buf[12]:=hi(p.trddir^[p.zxdisk.files].length);
buf[13]:=p.trddir^[p.zxdisk.files].totalsec;
buf[14]:=p.trddir^[p.zxdisk.files].n1sec;
buf[15]:=p.trddir^[p.zxdisk.files].n1tr;

b:=(p.zxdisk.files div 16)+1; if (p.zxdisk.files mod 16)=0 then dec(b);
ReadSector(@RealBuf,FDDType,0,0,b,1);
k:=p.zxdisk.files-(p.zxdisk.files div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
for i:=0 to 15 do RealBuf[k+i]:=buf[i];{}
WriteSector(@RealBuf,FDDType,0,0,b,1);

FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
FreeFDDRes; { Восстановление старых параметров дисковода }
{$I+}
if ioresult=0 then flpSave:=true;
End;



{============================================================================}
function flpDel(var p:TPanel; What:char):boolean;
var df,b,k,io:byte; buf:array[0..15]of byte; fs:file;
begin
flpDel:=false;
if not InitFDD(What,CheckMedia) then exit;
  {$I-}

    zxSeek(FDDType,0);
    ReadSector(@RealBuf,FDDType,0,0,1,9);

  for i:=1 to p.tfiles do if p.trddir^[i].mark then
   begin
    df:=i-1; b:=(df div 16)+1; if (df mod 16)=0 then dec(b);

    p.trddir^[i].name[1]:=chr(ord('1')-48);
    for io:=0 to 7 do buf[io]:=ord(p.trddir^[i].name[io+1]);
    buf[8]:=ord(p.trddir^[i].typ);
    buf[9]:=lo(p.trddir^[i].start);
    buf[10]:=hi(p.trddir^[i].start);
    buf[11]:=lo(p.trddir^[i].length);
    buf[12]:=hi(p.trddir^[i].length);
    buf[13]:=p.trddir^[i].totalsec;
    buf[14]:=p.trddir^[i].n1sec;
    buf[15]:=p.trddir^[i].n1tr;

    k:=df-(df div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
    for io:=0 to 15 do RealBuf[256*(b-1)+k+io]:=buf[io];{}

    p.trddir^[i].mark:=false;
    inc(p.zxdisk.delfiles);
   end;
  {$I+}
RealBuf[256*8+$f4]:=p.zxdisk.delfiles;
    WriteSector(@RealBuf,FDDType,0,0,1,9);

FreeFDDRes; { Восстановление старых параметров дисковода }
if ioresult=0 then flpDel:=true;
{
  if AutoMove then
   begin
    trdautomove:=true;
    fddMove(p);
    trdautomove:=false;
   end;
{}
end;



{============================================================================}
function flpRename(What:char):boolean;
var xc,yc,df,b,k,io:byte; buf:array[0..15]of byte; fs:file; s,stemp:string;
    p:tPanel;
begin
flpRename:=false;
if not InitFDD(What,CheckMedia) then exit;

Case focus of left:p:=lp; right:p:=rp; End;
  {$I-}
if p.Index<=1 then exit;
CancelSB;
colour(pal.bkCurNT,pal.txtCurNT);
stemp:=p.trddir^[p.Index].name+'.'+TRDOSe3(p,p.Index);
s:=stemp; GetCurXYOf(focus,xc,yc);
curon; SetCursor(400); stemp:=zxsnscanf(xc,yc,stemp,p.trddir^[p.Index].typ); curoff;
if not scanf_esc then
BEGIN

i:=p.Index;

df:=i-1; b:=(df div 16)+1; if (df mod 16)=0 then dec(b);
zxSeek(FDDType,0);
ReadSector(@RealBuf,FDDType,0,0,b,1);

    if (s[1]=chr(ord('1')-48))or(s[1]=chr(ord('0')-48)) then
      if (stemp[1]<>chr(ord('1')-48))and(stemp[1]<>chr(ord('0')-48))
      then dec(p.zxdisk.delfiles);

    p.trddir^[i].name:=stemp;
    for io:=0 to 7 do buf[io]:=ord(p.trddir^[i].name[io+1]);
    if (TRDOS3)and(p.trddir^[p.Index].typ<>'B') then buf[8]:=ord(stemp[10]) else buf[8]:=ord(stemp[11]);
    buf[9]:=lo(p.trddir^[i].start);
    buf[10]:=hi(p.trddir^[i].start);
    buf[11]:=lo(p.trddir^[i].length);
    buf[12]:=hi(p.trddir^[i].length);
    buf[13]:=p.trddir^[i].totalsec;
    buf[14]:=p.trddir^[i].n1sec;
    buf[15]:=p.trddir^[i].n1tr;

k:=df-(df div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
for io:=0 to 15 do RealBuf[k+io]:=buf[io];{}
WriteSector(@RealBuf,FDDType,0,0,b,1);

ReadSector(@RealBuf,FDDType,0,0,9,1);
RealBuf[$f4]:=p.zxdisk.delfiles;
WriteSector(@RealBuf,FDDType,0,0,9,1);
END;

FreeFDDRes; { Восстановление старых параметров дисковода }
  {$I+}
if ioresult=0 then flpRename:=true;
reMDF; reInfo('cbdnsfi'); rePDF;
end;




{============================================================================}
function flpLabel(What:char):boolean;
var s:string; fs:file of byte; b:byte; p:TPanel;
label fin;
begin
flpLabel:=false;
if not InitFDD(What,CheckMedia) then exit;
{$I-}
Case focus of left:p:=lp; right:p:=rp; End;
CancelSB; colour(pal.bkCurST,pal.txtCurST);
s:=p.zxdisk.disklabel;
curon;
Case focus of
 left:  begin mprint(16,1,space(10)); s:=scanf(17,1,nospaceLR(s),8,8,1); end;
 right: begin mprint(56,1,space(10)); s:=scanf(57,1,nospaceLR(s),8,8,1); end;
End;
s:=copy(s,1,8)+space(8-length(copy(s,1,8)));
curoff;
if not scanf_esc then
 begin
  zxSeek(FDDType,0);
  ReadSector(@RealBuf,FDDType,0,0,9,1);
  RealBuf[$f4]:=p.zxdisk.delfiles;
  for i:=1 to 8 do RealBuf[$f5+i-1]:=ord(s[i]);
  WriteSector(@RealBuf,FDDType,0,0,9,1);
 end;
FreeFDDRes; { Восстановление старых параметров дисковода }
{$I+}
if ioresult=0 then flpLabel:=true;
reMDF; rePDF;
reInfo('cbdnsfi');
end;




{============================================================================}
function flpMove(var p:Tpanel; What:char):boolean;
var fr,t:word;
    r,c,i,a,m,k,io:word;
    b:byte;
    stemp:string;
begin
{$I-}
flpMove:=false;
if p.zxdisk.delfiles=0 then exit;

CancelSB;
if lang=rus then stemp:='Хотите уплотнить'#255'этот диск ?'
            else stemp:='Do you wish to move'#255'this disk ?';
if not trdautomove then
if not cquestion(stemp,lang) then exit;

if not InitFDD(What,CheckMedia) then exit else FreeFDDRes;

if Moused then MouseOff;
Colour(pal.bkdRama,pal.txtdRama); sPutWin(halfmaxx-20,halfmaxy-4,halfmaxx+21,halfmaxy+2);
if LANG=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Уплотнение ')
            else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Move ');


flpMDF(p,p.flpDrive);
fr:=0; t:=0; r:=0;
for i:=2 to p.flptfiles do inc(fr,p.trddir^[i].totalsec); inc(fr,p.zxdisk.free);
for i:=2 to p.flptfiles do
 if (ord(p.trddir^[i].name[1])<>1)and(ord(p.trddir^[i].name[1])<>0)
   then inc(t,p.trddir^[i].totalsec);
p.zxdisk.free:=fr-t;

for i:=2 to p.flptfiles do
 if (ord(p.trddir^[i].name[1])=1)or(ord(p.trddir^[i].name[1])=0) then break;
p.zxdisk.n1freesec:=p.trddir^[i].n1sec;
p.zxdisk.ntr1freesec:=p.trddir^[i].n1tr;
p.zxdisk.files:=i-2;

for c:=i to p.flptfiles do
 if (ord(p.trddir^[c].name[1])<>1)and(ord(p.trddir^[c].name[1])<>0) then inc(r);

for c:=i to p.flptfiles do
 if (ord(p.trddir^[c].name[1])<>1)and(ord(p.trddir^[c].name[1])<>0) then break;

for a:=c to p.flptfiles do
if (ord(p.trddir^[a].name[1])<>1)and(ord(p.trddir^[a].name[1])<>0) then
 begin
  CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-2,
      p.trdDir^[a].name+'.'+TRDOSe3(p,a));

  if LANG=rus then
   begin
     CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-0,
       'Осталось перенести - '+strr(r)+' ');
   end
  else
   begin
     CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-0,
       'Remained to trasfer - '+strr(r)+' ');
   end;

  flpLoad(p,a,p.flpDrive);
  flpSave(p,p.flpDrive);
  inc(p.zxdisk.free,p.trddir^[a].totalsec);{}
  dec(r);
 end;

InitFDD(What,CheckMedia);


CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-0,space(26));
CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-2,space(26));

if LANG=rus then
  CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-1,
   '   Обновление каталога...   ')
            else
   CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,halfmaxy-1,
   '   Updating directory...   ');
{}

zxSeek(FDDType,0);
ReadSector(@RealBuf,FDDType,0,0,1,8);
for m:=p.zxdisk.files+2 to 128 do
 begin
  c:=m-1; b:=(c div 16)+1; if (c mod 16)=0 then dec(b);
  k:=c-(c div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
  RealBuf[256*(b-1)+k]:=0;
 end;
WriteSector(@RealBuf,FDDType,0,0,1,8);

ReadSector(@RealBuf,FDDType,0,0,9,1);
RealBuf[$f4]:=p.zxdisk.delfiles;
RealBuf[$e1]:=p.zxdisk.n1freesec;
RealBuf[$e2]:=p.zxdisk.ntr1freesec;
RealBuf[$e4]:=p.zxdisk.files;
RealBuf[$f4]:=0;
RealBuf[$e5]:=lo(p.zxdisk.free);
RealBuf[$e6]:=hi(p.zxdisk.free);
WriteSector(@RealBuf,FDDType,0,0,9,1);

FreeFDDRes; { Восстановление старых параметров дисковода }
if ioresult=0 then;

RestScr;

p.flpMDFs(p.flpDrive);
if trdAutoMove then exit;
p.TrueCur; p.Inside;
reInfo('cbdnsfi');
rePDF;

{$I+}

if ioresult=0 then flpMove:=true;
end;




End.