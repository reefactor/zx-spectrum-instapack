{$O+,F+}
Unit FDI_Ovr;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, TRD, PC,PC_Ovr,Main_Ovr,TRD_Ovr,SCL,SCL_Ovr;

function  fdiLoad(var p:TPanel; ind:word):boolean;
function  fdiSave(var p:TPanel):boolean;

function  fdiDel(var p:TPanel):boolean;
function  fdiRename:boolean;
function  fdiMove(var p:Tpanel):boolean;
function  fdiLabel:boolean;

procedure fdiMakeImage(var p:TPanel; BootOnly:boolean);


Implementation


{============================================================================}
function  fdiLoad(var p:TPanel; ind:word):boolean;
Var f:file;
Begin
HobetaInfo.name:=p.trdDir^[ind].name;
HobetaInfo.typ:=p.trdDir^[ind].typ;
HobetaInfo.start:=p.trdDir^[ind].start;
HobetaInfo.length:=p.trdDir^[ind].length;
HobetaInfo.param2:=p.trdDir^[ind].length;
if HobetaInfo.typ<>'B' then HobetaInfo.param2:=32768;
HobetaInfo.totalsec:=p.trdDir^[ind].totalsec;

fdiLoad:=false;
{$I-}
GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);
assign(f,p.fdifile); filemode:=0; reset(f,1);
seek(f,p.fdiRec.offData+bpos(p.trdDir^[ind].n1tr,p.trdDir^[ind].n1sec));
blockread(f,HobetaInfo.body^,256*HobetaInfo.totalsec);
close(f);
{$I-}
if ioresult=0 then fdiLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;



{============================================================================}
function  fdiSave(var p:TPanel):boolean;
Var f:file; i,b:byte; buf:array[0..15]of byte;
Begin
fdiSave:=false;
{$I-}
assign(f,p.fdifile); filemode:=2; reset(f,1);

seek(f,p.fdiRec.offData+bpos(p.zxDisk.nTr1FreeSec,p.zxDisk.n1FreeSec));
blockwrite(f,HobetaInfo.body^,256*HobetaInfo.totalsec);

inc(p.zxdisk.files);
dec(p.zxdisk.free,hobetainfo.totalsec);

p.trdDir^[p.zxdisk.files].name:=HobetaInfo.name;
p.trdDir^[p.zxdisk.files].typ:=HobetaInfo.typ;
p.trdDir^[p.zxdisk.files].start:=HobetaInfo.start;
p.trdDir^[p.zxdisk.files].length:=HobetaInfo.length;
p.trdDir^[p.zxdisk.files].totalsec:=HobetaInfo.totalsec;
p.trdDir^[p.zxdisk.files].n1tr:=p.zxDisk.nTr1FreeSec;
p.trdDir^[p.zxdisk.files].n1sec:=p.zxDisk.n1FreeSec;

for i:=1 to hobetainfo.totalsec do
 begin
  inc(p.zxdisk.n1freesec);
  if p.zxdisk.n1freesec>15 then begin p.zxdisk.n1freesec:=0; inc(p.zxdisk.ntr1freesec); end;
 end;

seek(f,p.fdiRec.offData+$8e1); b:=p.zxdisk.n1freesec;   blockwrite(f,b,1);
seek(f,p.fdiRec.offData+$8e2); b:=p.zxdisk.ntr1freesec; blockwrite(f,b,1);
seek(f,p.fdiRec.offData+$8e4); b:=p.zxdisk.files;       blockwrite(f,b,1);
seek(f,p.fdiRec.offData+$8e5); b:=lo(p.zxdisk.free);    blockwrite(f,b,1);
seek(f,p.fdiRec.offData+$8e6); b:=hi(p.zxdisk.free);    blockwrite(f,b,1);

for i:=1 to 8 do buf[i-1]:=ord(p.trddir^[p.zxdisk.files].name[i]);
buf[8]:=ord(p.trddir^[p.zxdisk.files].typ);
buf[9]:=lo(p.trddir^[p.zxdisk.files].start);
buf[10]:=hi(p.trddir^[p.zxdisk.files].start);
buf[11]:=lo(p.trddir^[p.zxdisk.files].length);
buf[12]:=hi(p.trddir^[p.zxdisk.files].length);
buf[13]:=p.trddir^[p.zxdisk.files].totalsec;
buf[14]:=p.trddir^[p.zxdisk.files].n1sec;
buf[15]:=p.trddir^[p.zxdisk.files].n1tr;
seek(f,p.fdiRec.offData+16*(p.zxdisk.files-1)); blockwrite(f,buf,16);

FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
close(f);
{$I-}
if ioresult=0 then fdiSave:=true;
End;





{============================================================================}
function fdiDel(var p:TPanel):boolean;
type hbuft=array[0..15] of byte; var i,io:byte; hbuf:hbuft; fs:file;
begin
fdiDel:=false;
  {$I-}
  assign(fs,p.fdifile); filemode:=2; reset(fs,1);

  for i:=1 to p.tfiles do if p.trddir^[i].mark then
   begin
    inc(p.zxdisk.delfiles); seek(fs,p.fdiRec.offData+$8f4); blockwrite(fs,p.zxdisk.delfiles,1);
    p.trddir^[i].name[1]:=chr(ord('1')-48);
    for io:=1 to 8 do hbuf[io-1]:=ord(p.trddir^[i].name[io]);
    hbuf[8]:=ord(p.trddir^[i].typ);
    hbuf[9]:=lo(p.trddir^[i].start);
    hbuf[10]:=hi(p.trddir^[i].start);
    hbuf[11]:=lo(p.trddir^[i].length);
    hbuf[12]:=hi(p.trddir^[i].length);
    hbuf[13]:=p.trddir^[i].totalsec;
    hbuf[14]:=p.trddir^[i].n1sec;
    hbuf[15]:=p.trddir^[i].n1tr;
    seek(fs,p.fdiRec.offData+16*(i-2)); blockwrite(fs,hbuf,16);
    p.trddir^[i].mark:=false;
   end;
  close(fs);
  {$I+}
  if ioresult=0 then fdiDel:=true;
  if AutoMove then
   begin
    trdautomove:=true;
    fdiMove(p);
    trdautomove:=false;
   end;
end;




{============================================================================}
function  fdiRename:boolean;
type hbuft=array[0..15] of byte;
var i,io:integer;
    stemp,s:string;
    fs:file;
    xc,yc,b:byte;
    hbuf:hbuft;
    p:TPanel;
label fin;
Begin
fdiRename:=false;
Case focus of left:p:=lp; right:p:=rp; End;

if p.Index<=1 then exit;
CancelSB;
colour(pal.bkCurNT,pal.txtCurNT);
stemp:=p.trddir^[p.Index].name+'.'+TRDOSe3(p,p.Index);
s:=stemp; GetCurXYOf(focus,xc,yc);
curon; SetCursor(400); stemp:=zxsnscanf(xc,yc,stemp,p.trddir^[p.Index].typ); curoff;
if not scanf_esc then
 begin
  {$I-}
  assign(fs,p.fdifile); filemode:=2; reset(fs,1);
  i:=p.Index;
  if (TRDOS3)and(p.trddir^[p.Index].typ<>'B') then p.trddir^[i].start:=256*ord(stemp[12])+ord(stemp[11]);
  if (s[1]=chr(ord('1')-48))or(s[1]=chr(ord('0')-48)) then
   if (stemp[1]<>chr(ord('1')-48))and(stemp[1]<>chr(ord('0')-48))
   then dec(p.zxdisk.delfiles);

  seek(fs,p.fdiRec.offData+$8f4); b:=p.zxdisk.delfiles;  blockwrite(fs,b,1);

  for io:=1 to 8 do hbuf[io-1]:=ord(stemp[io]);
  if (TRDOS3)and(p.trddir^[p.Index].typ<>'B') then hbuf[8]:=ord(stemp[10]) else hbuf[8]:=ord(stemp[11]);
  hbuf[9]:=lo(p.trddir^[i].start);
  hbuf[10]:=hi(p.trddir^[i].start);
  hbuf[11]:=lo(p.trddir^[i].length);
  hbuf[12]:=hi(p.trddir^[i].length);
  hbuf[13]:=p.trddir^[i].totalsec;
  hbuf[14]:=p.trddir^[i].n1sec;
  hbuf[15]:=p.trddir^[i].n1tr;
  seek(fs,p.fdiRec.offData+16*(i-2));
  blockwrite(fs,hbuf,16);

  close(fs);
  {$I+}
   if ioresult=0 then fdiRename:=true;
 end;
fin:
reMDF; reInfo('cbdnsfi'); rePDF;
End;



{============================================================================}
function fdiMove(var p:Tpanel):boolean;
type hbuft=array[1..2] of byte;
var fr,t:word;
    c,i,a,m:integer; fs:file; buf:^hbuft; nr,nw:word; hbuf:array[0..15] of byte;
    b:byte;
    stemp:string;
begin
fdiMove:=false;
{Case focus of left:p:=lp; right:p:=rp; End;{}
if p.zxdisk.delfiles=0 then exit;
CancelSB;
if lang=rus then stemp:='Хотите уплотнить'#255'этот диск ?'
            else stemp:='Do you wish to move'#255'this disk ?';
if not trdautomove then
if not cquestion(stemp,lang) then exit;
if checkdirfile(p.fdifile)<>0 then
 begin
  if lang=rus then errormessage('Не найден файл '+strlo(getof(p.fdifile,_name))+'.fdi')
  else errormessage('File '+strlo(getof(p.fdifile,_name))+'.fdi not found');
  p.paneltype:=pcpanel;
  p.pcMDF(p.pcnd);
  p.truecur;
  p.inside;
  p.Info('cbdnsfi');
  p.pcPDF(p.pcfrom);
  exit;
 end;

p.fdiMDFs(p.fdifile);
fr:=0; t:=0;
for i:=1 to p.fditfiles do fr:=fr+p.trddir^[i].totalsec;
inc(fr,p.zxdisk.free);
for i:=1 to p.fditfiles do
 if (ord(p.trddir^[i].name[1])<>1)and(ord(p.trddir^[i].name[1])<>0) then
  t:=t+p.trddir^[i].totalsec;

 p.zxdisk.free:=fr-t;

  for i:=1 to p.fditfiles do
   if (ord(p.trddir^[i].name[1])=1)or(ord(p.trddir^[i].name[1])=0) then break;
  p.zxdisk.n1freesec:=p.trddir^[i].n1sec;
  p.zxdisk.ntr1freesec:=p.trddir^[i].n1tr;
  for c:=i to p.fditfiles do
   if (ord(p.trddir^[c].name[1])<>1)and(ord(p.trddir^[c].name[1])<>0) then break;
  {$I-}
  assign(fs,p.fdifile); filemode:=2; reset(fs,1);

  for a:=c to p.fditfiles do
  if (ord(p.trddir^[a].name[1])<>1)and(ord(p.trddir^[a].name[1])<>0) then
   begin
    getmem(buf,p.trddir^[a].totalsec*256);
    seek(fs,p.fdiRec.offData+bpos(p.trddir^[a].n1tr,p.trddir^[a].n1sec));
    blockread(fs,buf^,p.trddir^[a].totalsec*256,nr);
    seek(fs,p.fdiRec.offData+bpos(p.zxdisk.ntr1freesec,p.zxdisk.n1freesec));
    blockwrite(fs,buf^,nr,nw);
    freemem(buf,p.trddir^[a].totalsec*256);

    p.trddir^[i].n1tr:=p.zxdisk.ntr1freesec;
    p.trddir^[i].n1sec:=p.zxdisk.n1freesec;
    p.trddir^[i].name:=p.trddir^[a].name;
    p.trddir^[i].typ:=p.trddir^[a].typ;
    p.trddir^[i].start:=p.trddir^[a].start;
    p.trddir^[i].length:=p.trddir^[a].length;
    p.trddir^[i].totalsec:=p.trddir^[a].totalsec;
    for m:=1 to p.trddir^[a].totalsec do
     begin
      inc(p.zxdisk.n1freesec);
      if p.zxdisk.n1freesec>15 then begin p.zxdisk.n1freesec:=0; inc(p.zxdisk.ntr1freesec); end;
     end;

    for m:=1 to 8 do hbuf[m-1]:=ord(p.trddir^[i].name[m]);
    hbuf[8]:=ord(p.trddir^[i].typ);
    hbuf[9]:=lo(p.trddir^[i].start);
    hbuf[10]:=hi(p.trddir^[i].start);
    hbuf[11]:=lo(p.trddir^[i].length);
    hbuf[12]:=hi(p.trddir^[i].length);
    hbuf[13]:=p.trddir^[i].totalsec;
    hbuf[14]:=p.trddir^[i].n1sec;
    hbuf[15]:=p.trddir^[i].n1tr;
    seek(fs,p.fdiRec.offData+16*(i-2)); blockwrite(fs,hbuf,16);

    inc(i);
   end;
  for m:=i-1 to 128 do begin seek(fs,p.fdiRec.offData+16*(m-1)); b:=0; blockwrite(fs,b,1); end;
  seek(fs,p.fdiRec.offData+$8e1); b:=p.zxdisk.n1freesec;   blockwrite(fs,b,1);
  seek(fs,p.fdiRec.offData+$8e2); b:=p.zxdisk.ntr1freesec; blockwrite(fs,b,1);
  seek(fs,p.fdiRec.offData+$8e4); b:=i-2;                  blockwrite(fs,b,1);
  seek(fs,p.fdiRec.offData+$8f4); b:=0;                    blockwrite(fs,b,1);

  seek(fs,p.fdiRec.offData+$8e5); b:=lo(p.zxdisk.free);    blockwrite(fs,b,1);
  seek(fs,p.fdiRec.offData+$8e6); b:=hi(p.zxdisk.free);    blockwrite(fs,b,1);

  close(fs);
  {$I+}
if ioresult=0 then fdiMove:=true;
p.fdiMDFs(p.fdifile);
if trdAutoMove then exit;{}
p.TrueCur; p.Inside;{}
reInfo('cbdnsfi');
rePDF;
end;



{============================================================================}
function fdiLabel:boolean;
var s:string; fs:file of byte; b:byte; p:TPanel;
label fin;
begin
fdiLabel:=false; Case focus of left:p:=lp; right:p:=rp; End;
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
  {$I-}
  assign(fs,p.fdifile); filemode:=2; reset(fs);
  seek(fs,p.fdiRec.offData+$8f5);
  for i:=1 to 8 do begin b:=ord(s[i]); write(fs,b); end;
  close(fs);
  {$I+}
  if ioresult=0 then fdiLabel:=true;
  reMDF; rePDF;
 end;
fin:
reInfo('cbdnsfi');
end;




{============================================================================}
procedure fdiMakeImage(var p:TPanel; BootOnly:boolean);
var name:string; stemp,tr:string;
    buf:array[1..8192] of byte;
    i,w:word;
    ff:file;
    fb:file of byte;
    ft:text;
    s,b,h:byte;
    fpos:longint;
    pp:TPanel;
begin
 CancelSB;
if BootOnly then else
BEGIN
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+2);
 if makeboot
  then if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый FDI-файл + boot ')
                   else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New FDI-file + boot ')
  else if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый FDI-файл ')
                   else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New FDI-file ');

 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'Имя файла:')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'File name:');
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-0,'Кол-во дорожек:')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-0,'Tracks on disk:');
 printself(pal.bkdInputNT,pal.txtdInputNT,42,halfmaxy-2,8);
 printself(pal.bkdInputNT,pal.txtdInputNT,47,halfmaxy-0,3);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon;
 mtscanf('','80',name,tr);
 curoff;
 restscr;

name:=nospace(name); tr:=nospace(tr);
if (name='com1')or(name='com2')or(name='com3')or(name='com4')or
   (name='lpt1')or(name='lpt2')or(name='lpt3')or(name='lpt4')or
   (name='con')or(name='nul')or(name='prn')or(name='aux') then
    begin if lang=rus then errormessage('Ошибка при создании FDI-файла')
                      else errormessage('Error while create FDI-file'); exit; end;

if scanf_esc then exit;
if nospace(name)<>'' then
 begin
 {$I-}
  scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+2);
  if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,30,halfmaxy-2,'Форматирование...')
              else cmprint(pal.bkdLabelST,pal.txtdLabelST,30,halfmaxy-2,'Formating...');
  cmprint(7,0,30,halfmaxy-1,fill(23,#177));

  if lang=rus then stemp:='Файл '+getof(name,_name)+'.fdi'+' уже существует.'+#255+' Заменить его?'
              else stemp:='File '+getof(name,_name)+'.fdi'+' alredy exist.'+#255+' Overwrite?';
  if checkdirfile(p.pcnd+getof(name,_name)+'.fdi')=0 then
   if not cquestion(stemp,lang) then exit;

  if vall(tr)=0 then tr:='80';

  p.pcnn:=getof(name,_name)+'.fdi';
  assign(ff,p.pcnd+getof(name,_name)+'.fdi'); filemode:=2; rewrite(ff,1);
  buf[1]:=$46; buf[2]:=$44; buf[3]:=$49;   {FDI}
  buf[4]:=0;                               {write protect}
  buf[5]:=vall(tr);  buf[6]:=0;            {cylinders}
  buf[7]:=2;         buf[8]:=0;            {heads}
  buf[9]:=0;         buf[10]:=0;           {text offset}
  buf[11]:=0;        buf[12]:=0;           {data offset}
  buf[13]:=0;        buf[14]:=0;           {adv data offset}
  blockwrite(ff,buf,14);
  fpos:=0;
  for i:=0 to vall(tr)-1 do for h:=1 to 2 do
   Begin
    buf[1]:=lo(longlo(fpos)); buf[2]:=hi(longlo(fpos));
    buf[3]:=lo(longhi(fpos)); buf[4]:=hi(longhi(fpos));
    buf[5]:=0; buf[6]:=0; buf[7]:=16;
    blockwrite(ff,buf,7);
    for s:=0 to 15 do
     Begin
      buf[1]:=i; buf[2]:=0; buf[3]:=s+1;
      buf[4]:=1; buf[5]:=2; buf[6]:=0;
      buf[7]:=s;
      blockwrite(ff,buf,7);
     End;
    inc(fpos,4096);
   End;

  w:=17*7*2*vall(tr);
  inc(w,160); p.fdiRec.offText:=w;
  {inc(w,128); {}p.fdiRec.offData:=w;

  seek(ff,p.fdiRec.offData);
  for i:=1 to sizeof(buf) do buf[i]:=0;
  if vall(tr)=0 then blockwrite(ff,buf,4096) else
  for i:=1 to vall(tr) do
   begin
    blockwrite(ff,buf,sizeof(buf));
    ProcessBar(0,round(100*i/vall(tr)),22,'');
    cmprint(7,0,49,halfmaxy-0,strr(round(100*i/vall(tr))-1)+'%');
   end;

  close(ff);

  assign(fb,p.pcnd+getof(name,_name)+'.fdi'); filemode:=2; reset(fb);{}
  seek(fb,8);
  b:=lo(p.fdiRec.offText); write(fb,b); b:=hi(p.fdiRec.offText); write(fb,b);
  b:=lo(p.fdiRec.offData); write(fb,b); b:=hi(p.fdiRec.offData); write(fb,b);

  seek(fb,p.fdiRec.offData+$8e1); b:=0; write(fb,b);
  seek(fb,p.fdiRec.offData+$8e2); b:=1; write(fb,b);
  seek(fb,p.fdiRec.offData+$8e3); if vall(nospace(tr))=40 then b:=$17 else b:=$16; write(fb,b);
  seek(fb,p.fdiRec.offData+$8e4); b:=0; write(fb,b);
  i:=(vall(tr)*2-1)*16;
  seek(fb,p.fdiRec.offData+$8e5); b:=lo(i); write(fb,b);
  seek(fb,p.fdiRec.offData+$8e6); b:=hi(i); write(fb,b);
  seek(fb,p.fdiRec.offData+$8e7); b:=$10; write(fb,b);
{  seek(fb,p.fdiRec.offData+$8ea); b:=32; for i:=0 to 9 do write(fb,b);{}
  seek(fb,p.fdiRec.offData+$8f4); b:=0; write(fb,b);
  name:=name+space(8-length(name));
  seek(fb,p.fdiRec.offData+$8f5);
  for i:=0 to 7 do begin b:=byte(name[i+1]); write(fb,b); end;
{
  seek(fb,p.fdiRec.offData+$801);
  stemp:='ZX Spectrum Navigator  Version '+ver+'  Copyright (c) 1997,98 RomanRoms Software Co.  ';
  for i:=1 to length(stemp) do begin b:=byte(stemp[i]); write(fb,b); end;
  stemp:='Russia. Nizhny Novgorod.  Written by Roman Khroupnin (RomanRom2)  ';
  for i:=1 to length(stemp) do begin b:=byte(stemp[i]); write(fb,b); end;
  stemp:='To find me use FIDOnet - 2:5015/97 or Internet - RomanRom2@usa.net';
  for i:=1 to length(stemp) do begin b:=byte(stemp[i]); write(fb,b); end;
{}
  close(fb);

  {$I+}
  i:=ioresult;
  if i<>0 then if lang=rus then errormessage('Ошибка '+strr(i)+' при создании FDI-файла')
                           else errormessage('Error '+strr(i)+' while create FDI-file');
  RestScr;
 end;
END;

  if (makeboot)and(checkdirfile(startdir+'\boots\boots.ini')=0){} then
   Begin
    assign(ft,startdir+'\boots\boots.ini'); filemode:=0; reset(ft);
    b:=0;
    while not EOF(ft) do
     begin
      readln(ft,stemp);
      if length(stemp)>60 then stemp:=copy(stemp,1,60);
      if nospace(stemp)<>'' then inc(b); menu_name[b]:=stemp;
     end;
    close(ft);
    menu_total:=b;
    menu_title:='';
    menu_f:=1;
    if b<>0 then
     begin
      i:=chooseitem;
      if i<>0 then
       begin
        stemp:=menu_name[i];
        delete(stemp,pos(' ',stemp),255);
        if ithobeta(startdir+'\boots\'+stemp,hobetainfo)
         then
          begin
           if BootOnly then else p.fdifile:=p.pcnd+getof(name,_name)+'.fdi';
           p.fdiMDFs(p.fdifile);
           if hobetainfo.totalsec>p.zxdisk.free then
           if lang=rus then errormessage('Hет меcта на диcке для boot.<B>')
                       else errormessage('Not enough space for boot.<B>')
           else Begin hobLoad(startdir+'\boots\'+stemp); fdiSave(p); End;
          end;
        if isSCL(startdir+'\boots\'+stemp) then
         begin
          p.sclfile:=startdir+'\boots\'+stemp;
          sclMDF(p,p.sclfile);
          if BootOnly then else p.fdifile:=p.pcnd+getof(name,_name)+'.fdi';
          for i:=1 to p.zxdisk.files do
           Begin
            sclMDF(p,p.sclfile);
            sclLoad(p,i+1);{}
            p.fdiMDFs(p.fdifile);
            fdiSave(p);
           End;
         end;
       end;
     end;
   End;
makeboot:=false;
end;





End.