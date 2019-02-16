{$O+,F+}
Unit FLP;
Interface
Uses
     RV,sn_Obj, Vars, Palette, TRD, main, trdos;

function  flpNameLine(var p:TPanel; a:word):string;
function  isFLP(What:char):boolean;
procedure flpMDF(var p:TPanel; What:char);
procedure flpPDF(var p:TPanel; fr:integer);
{Procedure flpInfoPanel(w:byte);{}


Implementation


{============================================================================}
function  flpNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
Begin
           p.flpnn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';

           nm:=nm+space(8-length(stemp))+stemp;
flpNameLine:=nm;
End;


{============================================================================}
function  isFLP(What:char):boolean;
var ff:file; s:string; i:integer; b:byte;
Begin
isFLP:=false;
if (What<>'A')and(What<>'B') then exit;
if not InitFDD(What,CheckMedia) then exit;

isFLP:=true;
ReadSector(@RealBuf,FDDType,0,0,9,1);
if IOError<>0 then isFLP:=false;
{
if not (RealBuf[$e3] in [$16,$17,$18,$19]) then isFLP:=false;
if not (RealBuf[$e4] in [0..128]) then isFLP:=false;
{}
if not (RealBuf[$e7] in [$10]) then isFLP:=false;

FreeFDDRes; { Восстановление старых параметров дисковода }
End;




{============================================================================}
procedure flpMDF(var p:TPanel; What:char);
var ff:file; buf:array[1..8] of byte; indx:longint;
    sec,n:byte; s:string; FoundFiles,ffile,k,i,trdinsed:integer;
begin
if (What<>'A')and(What<>'B') then exit;
if not InitFDD(What,CheckMedia) then exit;

k:=0; for i:=1 to p.flptfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

{zxSeek(FDDType,5);{}
zxSeek(FDDType,0);
ReadSector(@RealBuf,FDDType,0,0,9,1);

p.zxDisk.files      :=RealBuf[$e4];
p.zxDisk.n1freesec  :=RealBuf[$e1];
p.zxDisk.ntr1freesec:=RealBuf[$e2];
p.zxDisk.disktyp    :=RealBuf[$e3];
p.zxDisk.free       :=RealBuf[$e5]+256*RealBuf[$e6];
p.zxDisk.trdoscode  :=RealBuf[$e7];
p.zxDisk.delfiles   :=RealBuf[$f4];
s:=''; for i:=1 to 8 do begin s:=s+chr(RealBuf[$f5+i-1]); end;
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
  ReadSector(@RealBuf,FDDType,0,0,sec,1);
  for n:=1 to 16 do
   begin
{    ffile:=16*(sec-1)+n+1;{}
    if Cat9 then
     BEGIN
      s:=''; for i:=1 to 8 do s:=s+chr(RealBuf[16*(n-1)+i-1]);
      p.trddir^[ffile].name    :=s+space(8-length(s));
      p.trddir^[ffile].typ     :=chr(RealBuf[16*(n-1)+9-1]);
      p.trddir^[ffile].start   :=256*RealBuf[16*(n-1)+11-1]+RealBuf[16*(n-1)+10-1];
      p.trddir^[ffile].length  :=256*RealBuf[16*(n-1)+13-1]+RealBuf[16*(n-1)+12-1];
      p.trddir^[ffile].totalsec:=RealBuf[16*(n-1)+14-1];
      p.trddir^[ffile].n1sec   :=RealBuf[16*(n-1)+15-1];
      p.trddir^[ffile].n1tr    :=RealBuf[16*(n-1)+16-1];
      p.trddir^[ffile].mark    :=false;
      Inc(ffile);
     END
    ELSE
     BEGIN
      if RealBuf[16*(n-1)]<>0 then
       Begin
        s:=''; for i:=1 to 8 do s:=s+chr(RealBuf[16*(n-1)+i-1]);
        p.trddir^[ffile].name    :=s+space(8-length(s));
        p.trddir^[ffile].typ     :=chr(RealBuf[16*(n-1)+9-1]);
        p.trddir^[ffile].start   :=256*RealBuf[16*(n-1)+11-1]+RealBuf[16*(n-1)+10-1];
        p.trddir^[ffile].length  :=256*RealBuf[16*(n-1)+13-1]+RealBuf[16*(n-1)+12-1];
        p.trddir^[ffile].totalsec:=RealBuf[16*(n-1)+14-1];
        p.trddir^[ffile].n1sec   :=RealBuf[16*(n-1)+15-1];
        p.trddir^[ffile].n1tr    :=RealBuf[16*(n-1)+16-1];
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

p.flptfiles:=p.zxDisk.files; inc(p.flptfiles);

if IOResult=0 then;

for i:=1 to trdinsed do for k:=1 to p.fddtfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;

FreeFDDRes; { Восстановление старых параметров дисковода }
End;





{============================================================================}
procedure flpPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
Begin

if p.paneltype<>flpPanel then exit;

n:=p.flptfiles;
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




{============================================================================}
{
Procedure flpInfoPanel(w:byte);
var
     a,b:byte; s,s0:string; i,m,l:longint; k:char; posx,posy,panellong:byte;
     trks,pt,treec:byte; zxlabel,flpfile,pcnd:string; free,flpdfiles,flptfiles:word;
     p:TPanel;
begin

Case w of
 left:
   BEGIN
    p:=lp;
    trks:=lp.zxdisk.tracks;
    pt:=lp.PanelType;
    posx:=rp.posx;
    posy:=rp.posy;
    panellong:=rp.panellong;
    treec:=lp.treec;
    pcnd:=lp.pcnd;
    Case pt of
     trdPanel: flpfile:=lp.trdfile;
     fdiPanel: flpfile:=lp.fdifile;
     fddPanel: flpfile:=lp.fddfile;
     sclPanel: flpfile:=lp.sclfile;
     tapPanel: flpfile:=lp.tapfile;
     zxzPanel: flpfile:=lp.zxzfile;
     flpPanel: flpfile:=lp.flpDrive+'>';
    End;
    zxlabel:=lp.zxdisk.disklabel;
    flptfiles:=lp.zxdisk.files;
    flpdfiles:=lp.zxdisk.delfiles;
    free:=lp.zxdisk.free;
   END;
 right:
   BEGIN
    p:=rp;
    trks:=rp.zxdisk.tracks;
    pt:=rp.PanelType;
    posx:=lp.posx;
    posy:=lp.posy;
    panellong:=lp.panellong;
    treec:=rp.treec;
    pcnd:=rp.pcnd;
    Case pt of
     trdPanel: flpfile:=rp.trdfile;
     fdiPanel: flpfile:=rp.fdifile;
     fddPanel: flpfile:=rp.fddfile;
     sclPanel: flpfile:=rp.sclfile;
     tapPanel: flpfile:=rp.tapfile;
     zxzPanel: flpfile:=rp.zxzfile;
     flpPanel: flpfile:=rp.flpDrive+'>';
    End;
    zxlabel:=rp.zxdisk.disklabel;
    flptfiles:=rp.zxdisk.files;
    flpdfiles:=rp.zxdisk.delfiles;
    free:=rp.zxdisk.free;
   END;
End;

cmPrint(pal.bkRama,pal.txtRama,posx,posy+PanelLong-2,'║'+space(38)+'║');
cmPrint(pal.bkRama,pal.txtRama,posx,posy+PanelLong-1,'╚'+fill(38,'═')+'╝');

Case pt of
 trdPanel: if lang=rus then s0:='Текущий TRD-файл:' else s0:='Current TRD-file:';
 fdiPanel: if lang=rus then s0:='Текущий FDI-файл:' else s0:='Current FDI-file:';
 fddPanel: if lang=rus then s0:='Текущий FDD-файл:' else s0:='Current FDD-file:';
 sclPanel: if lang=rus then s0:='Текущий SCL-файл:' else s0:='Current SCL-file:';
 tapPanel: if lang=rus then s0:='Текущий TAP-файл:' else s0:='Current TAP-file:';
 zxzPanel: if lang=rus then s0:='Текущий ZXZIP-файл:' else s0:='Current ZXZIP-file:';
 flpPanel: if lang=rus then s0:='Текущий дисковод:' else s0:='Current drive:';
End;

i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,2,s);

s0:=nospace(flpfile);
if length(s0)>29 then s0:=copy(s0,1,4)+'...'+copy(s0,length(s0)-22,30);
s:='~`'+s0+'~`';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,3,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,4,space(38));

i:=trks;
  Case TIP of
   1: s:=('5.25"~`,~` 360k');
   2: s:=('5.25"~`,~` 1.2M');
   3: s:=('3.5"~`,~` 720k');
   4: s:=('3.5"~`,~` 1.44M');
  End;
if lang=rus then s:='Устройство ~`'+s+'~`'
            else s:='Device ~`'+s+'~`';


if (p.PanelType=trdPanel)or(p.PanelType=fdiPanel)or(p.PanelType=fddPanel) then
 Begin
  if lang=rus then s:='~`'+strr(i)+'~` дорож'+et(i,rus)+' '+s
              else s:='~`'+strr(i)+'~` track'+et(i,lang)+' '+s;
 End;
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,5,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,6,space(38));

s:='────────────────';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,7,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,8,space(38));

if lang=rus then s:='Имя диска: ~`'+nospaceLR(zxlabel)
            else s:='Disk name: ~`'+nospaceLR(zxlabel);
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,9,s);

if lang=rus then s:='Файлов всего - ~`'+strr(flptfiles)+'~`, удаленных - ~`'+strr(flpdfiles)
            else s:='Total files - ~`'+strr(flptfiles)+'~`, deleted - ~`'+strr(flpdfiles);
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,10,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,11,space(38));

if lang=rus then s:='~`'+strr(free)+'~` блок'+eb(free,rus)+' свободно'
            else s:='~`'+strr(free)+'~` block'+eb(free,lang)+' free';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,12,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,13,space(38));

s:='────────────────';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,14,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,15,space(38));

if (p.PanelType<>sclPanel)and(p.PanelType<>tapPanel) then
 BEGIN
  for i:=1 to p.flptfiles+1 do if p.trddir^[i].name+'.'+p.trddir^[i].typ='boot    .B' then break;
  if i>p.flptfiles then
   begin
    if lang=rus then s:='Файл ~`boot.<B>~` отсутствует'
                else s:='File ~`boot.<B>~` not present';
    s0:=s;
    i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
    s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
    StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,s);
   end else
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,space(38));
 END else
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,space(38));

end;
{}


Begin
sBar[rus,flpPanel]:='~`Alt+X~` Выход ~` F3~` Смотp ~` F5~` Копия ~` F6~` Перем ~` F7~` Упл ~` F8~` Удалить ~` F9~` Метка ~`';
sBar[eng,flpPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F7~` Move ~` F8~` Delete ~` F9~` Label ~`';
End.
