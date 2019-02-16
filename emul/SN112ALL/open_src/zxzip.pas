{$O+,F+}
Unit ZXZIP;
Interface
Uses
     RV,Vars,sn_Obj,Palette,TRD,Main,Main_Ovr;

function  zxzNameLine(var p:TPanel; a:byte):string;
Function  isZXZIP(path:string):boolean;

Procedure zxzMDF(var p:TPanel; path:string);
Procedure zxzPDF(var p:TPanel; fr:integer);
function  zxzLoad(var p:TPanel; ind:word):boolean;
function  zxzSave(p:TPanel):boolean;

Procedure zxzExtract(sp,dp:TPanel);

Implementation

{============================================================================}
function zxzNameLine(var p:TPanel; a:byte):string;
var nm,stemp:string;
begin
nm:='<<'+space(36);
if a>1 then
 Begin
           p.zxznn:=p.trddir^[a].name+'.'+TRDOSe31(p,a);
           nm:=p.trddir^[a].name+' '+TRDOSe3(p,a);
           stemp:=extnum(strr(p.trddir^[a].start)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;
           stemp:=extnum(strr(p.trddir^[a].length)); stemp:=changechar(stemp,' ',',');
           nm:=nm+space(9-length(stemp))+stemp;
           stemp:=strr(p.trddir^[a].totalsec);
           stemp:='('+space(4-length(stemp))+stemp+')';
           nm:=nm+space(8-length(stemp))+stemp;
 End;
zxzNameLine:=nm;
end;


{============================================================================}
Function  isZXZIP(path:string):boolean;
Begin
isZXZIP:=false;
if itHobeta(path,hobetaInfo) then
 if (HobetaInfo.typ='Z')and(HobetaInfo.start=20553)and(HobetaInfo.name<>'********')
  then isZXZIP:=true;
End;




{============================================================================}
Procedure zxzMDF(var p:TPanel; path:string);
var
    fb:file of byte; f:file;
    m,w,i,vol:word;
    pos:longint;
    b,b1,cs,csf:byte;
    buf:array[1..22] of byte;
    s:string;
Label RepeatMDF;
Begin
if (checkdirfile(path)<>0)or(not isZXZIP(path)) then
 begin
  {
  if lang=rus then errormessage('Hе найден ZXZIP файл')
              else errormessage('ZXZIP file not found');
  {}
  p.PanelType:=pcPanel;
  p.pcMDF(p.pcnd);
  p.Inside;
  Exit;
 end;

filemode:=0; pos:=0; p.zxztfiles:=1;
p.trddir^[1].name:='<<        ';
p.trddir^[1].length:=0;
p.trddir^[1].tapflag:=0;
p.trddir^[1].taptyp:=0;
p.trddir^[1].mark:=false;

{$I-}
pos:=17; vol:=0; s:=path;
assign(f,s); filemode:=0; reset(f,1);

for w:=1 to 256 do
 begin
RepeatMDF:
  seek(f,pos);
  blockRead(f,buf,22); inc(pos,22);
  if EOF(f) then
   begin
    inc(vol);
    if vol>9 then break;
    s:=nospaceLR(s); s[length(s)]:=midch(strr(vol),1);
    if CheckDirFile(s)<>0 then begin dec(vol); break;{} end;
    pos:=pos-22-filesize(f)+17;
    close(f); assign(f,s); filemode:=0; reset(f,1);
    goto RepeatMDF;
   end;
  inc(p.zxztfiles);

  p.trdDir^[p.zxztfiles].name:=space(8);
  for i:=1 to 8 do p.trdDir^[p.zxztfiles].name[i]:=chr(buf[i]);
  p.trddir^[p.zxztfiles].typ:=chr(buf[9]);
  p.trddir^[p.zxztfiles].start:=256*buf[11]+buf[10];

  p.trddir^[p.zxztfiles].length:=256*buf[13]+buf[12];
  if chr(buf[9])='B' then p.trddir^[p.zxztfiles].length:=p.trddir^[p.zxztfiles].start+4;
  if 256*buf[14]-p.trddir^[p.zxztfiles].length>256 then p.trddir^[p.zxztfiles].length:=256*buf[14];

  p.trddir^[p.zxztfiles].totalsec:=buf[14];
  p.trddir^[p.zxztfiles].zxzPackSize:=256*buf[16]+buf[15];
  p.trddir^[p.zxztfiles].zxzCRC32:=(buf[17]+256*buf[18])+65536*(buf[19]+256*buf[20]);
  p.trddir^[p.zxztfiles].zxzPackMethod:=buf[21];
  p.trddir^[p.zxztfiles].zxzFlag:=buf[22];
  p.trddir^[p.zxztfiles].offset:=pos;
  p.trddir^[p.zxztfiles].mark:=false;

  inc(pos,p.trddir^[p.zxztfiles].zxzPackSize);

  if buf[21]>3 then begin dec(p.zxztfiles); break; end;{}
  m:=256*buf[16]+buf[15];
  if (buf[21]=0)and(m<>p.trddir^[p.zxztfiles].length) then begin dec(p.zxztfiles); break; end;{}
  if (buf[21]<>0)and(m>=p.trddir^[p.zxztfiles].length) then begin dec(p.zxztfiles); break; end;{}
  if (ord(p.trdDir^[p.zxztfiles].name[1])<32)then begin dec(p.zxztfiles); break; end;{}
 end;
close(f);
{$I+}

if ioresult<>0 then;
p.zxzfile:=path;
p.zxdisk.n1freesec:=0;
p.zxdisk.ntr1freesec:=0;
p.zxdisk.disktyp:=0;
p.zxdisk.free:=0;
p.zxdisk.trdoscode:=16;
p.zxdisk.delfiles:=0;
if vol+1<=1 then p.zxdisk.disklabel:='ZXZIP' else p.zxdisk.disklabel:='ZXZIP ('+strr(vol+1)+')';
p.zxdisk.files:=p.zxztfiles-1;{}

End;


{============================================================================}
Procedure zxzPDF(var p:TPanel; fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
Begin

if p.paneltype<>zxzPanel then exit;

n:=p.zxztfiles;
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


{============================================================================}
function  zxzLoad(var p:TPanel; ind:word):boolean;
Begin
zxzLoad:=false;
{$I-}
GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);
{$I+}
if ioresult=0 then zxzLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;



{============================================================================}
function  zxzSave(p:TPanel):boolean;
Begin
zxzSave:=false;
{$I-}
FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
{$I+}
if ioresult=0 then zxzSave:=true;
End;



{============================================================================}
Procedure zxzExtract(sp,dp:TPanel);
Var s,t:string; n:word;
Begin
zxzMDF(sp,sp.pcnd+sp.pcnn);
CancelSB;
if sp.zxdisk.files=1 then
 if lang=rus then s:='Извлеч файл '+sp.trdDir^[sp.zxdisk.files+1].name+'.'+TRDOSe3(sp,sp.zxdisk.files+1)+' в'
             else s:='Extract file '+sp.trdDir^[sp.zxdisk.files+1].name+'.'+TRDOSe3(sp,sp.zxdisk.files+1)+' to'
                     else
 if lang=rus then s:='Извлеч '+strr(sp.zxdisk.files)+' файл'+efiles(sp.zxdisk.files,lang)+' в'
             else s:='Extract '+strr(sp.zxdisk.files)+' file'+efiles(sp.zxdisk.files,lang)+' to';
t:=sp.pcnd; if length(t)>30 then t:=copy(t,1,3)+'...'+copy(t,length(t)-30,30);
s:=s+#255+t;
if cQuestion(s,lang) then
 begin
  getprofile(startdir+'\sn.ini','Spectrum','zxunzip',s);
  command:=s+' '+sp.pcnd+sp.pcnn;
  DoExec(command,false);
 end;
End;





Begin
sBar[rus,zxzPanel]:='~`Alt+X~` Выход ~` F4~` Извлеч';
sBar[eng,zxzPanel]:='~`Alt+X~` Exit ~` F4~` Extract';
End.