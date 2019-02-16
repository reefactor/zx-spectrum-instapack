{$O+,F+}
Unit TRD;
Interface
Uses
     Dos,Crt,RV,sn_Obj, Vars, Main, Main_Ovr,
     PC,PC_Ovr;
Var
     less:byte;

function  trdNameLine(var p:TPanel; a:word):string;
function  bpos(tr,sc:byte):longint;

function  et(n:longint; lang:byte):string; {дорожка}
Procedure trdInfoPanel(w:byte);

function  isTRD(path:string):boolean;

function  TRDOSe3(var p:TPanel; i:integer):string;
function  TRDOSe31(var p:TPanel; i:integer):string;
function  hiTRDOSe3:string;
function  hiTRDOSe31:string;
procedure trdMDF(var p:TPanel; path:string);
procedure trdPDF(var p:TPanel; fr:integer);
function  eb(n:longint; lang:byte):string;   {блок, файл}
function  itHobeta(name:string; var rec:hobrec):boolean;


Implementation
Uses
     FLP,
     FDI,FDI_Ovr,SCL,SCL_Ovr,FDD,FDD_Ovr,TAP,TAP_Ovr,TRD_Ovr,ZXZIP,zxView,
     palette,FLP_OVR,mouse,trdos;


{============================================================================}
function trdNameLine(var p:TPanel; a:word):string;
var nm,stemp:string;
begin
           p.trdnn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;

           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';

           nm:=nm+space(8-length(stemp))+stemp;
trdNameLine:=nm;
end;




{============================================================================}
function bpos(tr,sc:byte):longint;
var a,b,c,d,s:longint;
begin
s:=0;
a:=4096;
b:=tr*a;
s:=s+b;
c:=256;
d:=sc*c;
s:=s+d;
bpos:=s;
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
Procedure trdInfoPanel(w:byte);
var
     a,b:byte; s,s0:string; i,m,l:longint; k:char; posx,posy,panellong:byte;
     trks,pt,treec:byte; zxlabel,trdfile,pcnd:string; free,trddfiles,trdtfiles:word;
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
     trdPanel: trdfile:=lp.trdfile;
     fdiPanel: trdfile:=lp.fdifile;
     fddPanel: trdfile:=lp.fddfile;
     sclPanel: trdfile:=lp.sclfile;
     tapPanel: trdfile:=lp.tapfile;
     zxzPanel: trdfile:=lp.zxzfile;
     flpPanel: trdfile:=lp.flpDrive+'>';
    End;
    zxlabel:=lp.zxdisk.disklabel;
    trdtfiles:=lp.zxdisk.files;
    trddfiles:=lp.zxdisk.delfiles;
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
     trdPanel: trdfile:=rp.trdfile;
     fdiPanel: trdfile:=rp.fdifile;
     fddPanel: trdfile:=rp.fddfile;
     sclPanel: trdfile:=rp.sclfile;
     tapPanel: trdfile:=rp.tapfile;
     zxzPanel: trdfile:=rp.zxzfile;
     flpPanel: trdfile:=rp.flpDrive+'>';
    End;
    zxlabel:=rp.zxdisk.disklabel;
    trdtfiles:=rp.zxdisk.files;
    trddfiles:=rp.zxdisk.delfiles;
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
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,2,s);{}

s0:=nospace(trdfile);
if length(s0)>29 then s0:=copy(s0,1,4)+'...'+copy(s0,length(s0)-22,30);
s:='~`'+s0+'~`';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,3,s);{}

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,4,space(38));

  Case TIP of
   1: s:=('5.25"~`,~` 360k');
   2: s:=('5.25"~`,~` 1.2M');
   3: s:=('3.5"~`,~` 720k');
   4: s:=('3.5"~`,~` 1.44M');
  End;
if lang=rus then s:='Устройство ~`'+s+'~`'
            else s:='Device ~`'+s+'~`';
i:=trks;
if (p.PanelType=trdPanel)or(p.PanelType=fdiPanel)or(p.PanelType=fddPanel) then
 Begin
  if lang=rus then s:='(~`'+changechar(extnum(strr(filelen(trdfile))),' ',',')+'~` байт)'
              else s:='(~`'+changechar(extnum(strr(filelen(trdfile))),' ',',')+'~` bytes)';
  if lang=rus then s:='~`'+strr(i)+'~` дорож'+et(i,rus)+' '+s
              else s:='~`'+strr(i)+'~` track'+et(i,lang)+' '+s;
 End;
if (p.PanelType=tapPanel)or(p.PanelType=sclPanel)or(p.PanelType=zxzPanel) then s:='';
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

if lang=rus then s:='Файлов всего - ~`'+strr(trdtfiles)+'~`, удаленных - ~`'+strr(trddfiles)
            else s:='Total files - ~`'+strr(trdtfiles)+'~`, deleted - ~`'+strr(trddfiles);
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

if (p.PanelType<>sclPanel)and(p.PanelType<>tapPanel)and(p.PanelType<>zxzPanel) then
 BEGIN
if LANG=rus then s:='Первый свободный трек - ~`'+strr(p.zxDisk.nTr1FreeSec)+'~` (~`'+dec2hex(strr(p.zxDisk.nTr1FreeSec))+'h~`)'
            else s:='The first free track - ~`'+strr(p.zxDisk.nTr1FreeSec)+'~` (~`'+dec2hex(strr(p.zxDisk.nTr1FreeSec))+'h~`)';

  s0:=s;
  i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
  s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
  StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,s);

if LANG=rus then s:='Первый свободный сектор - ~`'+strr(p.zxDisk.n1FreeSec)+'~` (~`'+dec2hex(strr(p.zxDisk.n1FreeSec))+'h~`)'
            else s:='The first free sector - ~`'+strr(p.zxDisk.n1FreeSec)+'~` (~`'+dec2hex(strr(p.zxDisk.n1FreeSec))+'h~`)';
  s0:=s;
  i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
  s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
  StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,17,s);

  Case p.PanelType of
   trdPanel: a:=p.trdtfiles;
   fdiPanel: a:=p.fditfiles;
   fddPanel: a:=p.fddtfiles;
   flpPanel: a:=p.flptfiles;
  End;
{  errormessage(strr(a));{}
  for i:=1 to a+1 do
   begin
{    message(p.trddir^[i].name+'.'+p.trddir^[i].typ);{}
    if p.trddir^[i].name+'.'+p.trddir^[i].typ='boot    .B' then break;
   end;
  if i>a then
   begin
    if lang=rus then s:='Файл ~`boot.<B>~` отсутствует'
                else s:='File ~`boot.<B>~` not present';
    s0:=s;
    i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
    s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
    StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,19,s);
   end else
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,19,space(38));
 END else
  Begin
   StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,space(38));
   StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,19,space(38));
  End;

end;


{============================================================================}
function isTRD(path:string):boolean;
var fb:file of byte;
    b:byte;
    i:integer;
label fin,fin2;
begin
{message(path);{}
isTRD:=false;
{$I-}
filemode:=0;
assign(fb,path); reset(fb);
{seek(fb,$8e3); read(fb,b); if not (b in [$16,$17,$18,$19]) then goto fin;
{seek(fb,$8e4); read(fb,b); if not (b in [0..128]) then goto fin;{}
seek(fb,$8e7); read(fb,b); if not (b in [$10]) then goto fin;
isTRD:=true;
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
function TRDOSe3(var p:TPanel; i:integer):string;
var name:string;
begin
if TRDOS3 then
 name:=p.trdDir^[i].typ+chr(lo(p.trdDir^[i].start))+chr(hi(p.trdDir^[i].start))
          else
 name:='<'+p.trdDir^[i].typ+'>';
if p.trdDir^[i].typ='B' then name:='<'+p.trdDir^[i].typ+'>';
TRDOSe3:=name;
end;


{============================================================================}
function TRDOSe31(var p:TPanel; i:integer):string;
var name:string;
begin
if TRDOS3 then
 name:=p.trdDir^[i].typ+chr(lo(p.trdDir^[i].start))+chr(hi(p.trdDir^[i].start))
          else
 name:=p.trdDir^[i].typ;
if p.trdDir^[i].typ='B' then name:=p.trdDir^[i].typ;
TRDOSe31:=name;
end;


{============================================================================}
function hiTRDOSe3:string;
var name:string;
begin
if TRDOS3 then
 name:=HobetaInfo.typ+chr(lo(HobetaInfo.start))+chr(hi(HobetaInfo.start))
          else
 name:='<'+HobetaInfo.typ+'>';
if HobetaInfo.typ='B' then name:='<'+HobetaInfo.typ+'>';
hiTRDOSe3:=name;
end;


{============================================================================}
function hiTRDOSe31:string;
var name:string;
begin
if TRDOS3 then
 name:=HobetaInfo.typ+chr(lo(HobetaInfo.start))+chr(hi(HobetaInfo.start))
          else
 name:=HobetaInfo.typ;
if HobetaInfo.typ='B' then name:=HobetaInfo.typ;
hiTRDOSe31:=name;
end;



{============================================================================}
procedure trdMDF(var p:TPanel; path:string);
var
    fb:file of byte;
    FoundFiles,i,k,trdinsed:integer;
    buf:array[1..16] of byte;
    s:string[8];
    b,b2:byte;
    stemp:string;
begin
if (checkdirfile(path)<>0)or(not isTRD(path)) then
 begin
  {
  if lang=rus then errormessage('Hе найден TRD файл')
              else errormessage('TRD file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

k:=0; for i:=1 to p.trdtfiles do if p.trdDir^[i].mark then begin inc(k);
p.trdins^[k].crc16:=crc16(p.trddir^[i].name+TRDOSe3(p,i)); end; trdinsed:=k;

{$I-}
filemode:=0;
assign(fb,path); reset(fb);
p.zxdisk.tracks:=filelen(p.trdfile)div 8192;

seek(fb,$8e1); read(fb,b); p.zxdisk.n1freesec:=b;
seek(fb,$8e2); read(fb,b); p.zxdisk.ntr1freesec:=b;
seek(fb,$8e3); read(fb,b); p.zxdisk.disktyp:=b;
seek(fb,$8e4); read(fb,b); p.zxdisk.files:=b;
seek(fb,$8e5); read(fb,b); read(fb,b2); p.zxdisk.free:=b+256*b2;
seek(fb,$8e7); read(fb,b); p.zxdisk.trdoscode:=b;
seek(fb,$8f4); read(fb,b); p.zxdisk.delfiles:=b;
seek(fb,$8f5); stemp:=''; for i:=1 to 8 do begin read(fb,b); stemp:=stemp+chr(b); end;
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
for i:=1 to p.zxdisk.files do
 begin
  seek(fb,16*(i-1));
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
  seek(fb,16*(i-1));
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

p.trdtfiles:=p.zxdisk.files; inc(p.trdtfiles);

close(fb);
{$I+}
if ioresult<>0 then;

for i:=1 to trdinsed do for k:=1 to p.trdtfiles do
if p.trdIns^[i].crc16=crc16(p.trddir^[k].name+TRDOSe3(p,k)) then p.trdDir^[k].mark:=true;
end;



{============================================================================}
procedure trdPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
begin

if p.paneltype<>trdPanel then exit;

n:=p.trdtfiles;
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
{  e:='<'+p.trdDir^[i].typ+'>';{}
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





{============================================================================}
function itHobeta(name:string; var rec:hobrec):boolean;
var
   i,a,b:byte;
   s,c:word;
   hob:array[0..16]of byte;
   fb:file of byte;
   temp:hobrec;
begin
{$I-}
ithobeta:=false;
if checkdirfile(name)<>0 then exit;
filemode:=0;
assign(fb,name); reset(fb); seek(fb,0); for i:=0 to 16 do read(fb,hob[i]); close(fb);
if ioresult<>0 then;
{$I+}

s:=0; for i:=0 to 14 do s:=s+257*hob[i]+i;
a:=hob[16]; b:=hob[15]; c:=256*a+b;
if c<>s then exit;
ithobeta:=true;

temp.name:=space(8);
for i:=0 to 7 do temp.name[i+1]:=chr(hob[i]);
temp.typ:=chr(hob[8]);
temp.start:=hob[9]+256*hob[10];
temp.length:=hob[11]+256*hob[12];
temp.param2:=hob[11]+256*hob[12];
if temp.typ<>'B' then temp.param2:=32768;
temp.totalsec:=hob[14];
rec:=temp;
end;







Begin
sBar[rus,trdPanel]:='~`Alt+X~` Выход ~` F3~` Смотp ~` F5~` Копия ~` F6~` Перем ~` F7~` Упл ~` F8~` Удалить ~` F9~` Метка ~`';
sBar[eng,trdPanel]:='~`Alt+X~` Exit ~` F3~` View ~` F5~` Copy ~` F6~` Rename ~` F7~` Move ~` F8~` Delete ~` F9~` Label ~`';
TRDOS3:=false;

End.