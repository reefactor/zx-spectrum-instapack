{$O+,F+}
Unit FDD_Ovr;
Interface
Uses
     RV,sn_Obj, Vars, Palette, Main, TRD, Main_Ovr,PC,PC_Ovr,FDD,TRD_Ovr,SCL,SCL_Ovr;

Procedure fddInfoPanel(w:byte);

Function  fddLoad(var p:TPanel; ind:word):boolean;
Function  fddSave(var p:TPanel):boolean;

function  fddDel(var p:TPanel):boolean;
function  fddRename:boolean;
function  fddMove(var p:Tpanel):boolean;
function  fddLabel:boolean;

procedure fddMakeImage(var p:TPanel; BootOnly:boolean);


Implementation


{============================================================================}
Procedure fddInfoPanel(w:byte);
begin
end;



{============================================================================}
Function fddLoad(var p:TPanel; ind:word):boolean;
Var
    bufpos,i,k:word; s,t:byte;
Begin
HobetaInfo.name:=p.trdDir^[ind].name;
HobetaInfo.typ:=p.trdDir^[ind].typ;
HobetaInfo.start:=p.trdDir^[ind].start;
HobetaInfo.length:=p.trdDir^[ind].length;
HobetaInfo.param2:=p.trdDir^[ind].length;
if HobetaInfo.typ<>'B' then HobetaInfo.param2:=32768;
HobetaInfo.totalsec:=p.trdDir^[ind].totalsec;

fddLoad:=false;
{$I-}
GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);

s:=p.trdDir^[ind].n1sec+1; t:=p.trdDir^[ind].n1tr; bufpos:=1;
for i:=1 to p.trdDir^[ind].totalsec do
 Begin
  fddReadSector(p.fddfile,t,s);
  for k:=0 to 255 do begin HobetaInfo.body^[bufpos]:=fddSectorBuf[k]; inc(bufpos); end;
  inc(s); if s>16 then begin s:=1; inc(t); end;
 End;
{$I+}
if ioresult=0 then fddLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;


{============================================================================}
Function fddSave(var p:TPanel):boolean;
Var f:file; k,i,b:byte; buf:array[0..15]of byte; bufpos:word;
Begin
fddSave:=false; bufpos:=1;
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

{message(strr(hobetainfo.totalsec));{}

for i:=1 to hobetainfo.totalsec do
 Begin
  for k:=0 to 255 do begin fddSectorBuf[k]:=HobetaInfo.body^[bufpos]; inc(bufpos); end;
  fddWriteSector(p.fddfile,p.zxDisk.ntr1freesec,p.zxDisk.n1freesec+1);{}
  inc(p.zxDisk.n1freesec);
  if p.zxDisk.n1freesec>15 then begin p.zxDisk.n1freesec:=0; inc(p.zxDisk.ntr1freesec); end;
 End;

fddReadSector(p.fddfile,0,9);
fddSectorBuf[$e1]:=p.zxdisk.n1freesec;
fddSectorBuf[$e2]:=p.zxdisk.ntr1freesec;
fddSectorBuf[$e4]:=p.zxdisk.files;
fddSectorBuf[$e5]:=lo(p.zxdisk.free);
fddSectorBuf[$e6]:=hi(p.zxdisk.free);
fddWriteSector(p.fddfile,0,9);

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
fddReadSector(p.fddfile,0,b);
k:=p.zxdisk.files-(p.zxdisk.files div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
for i:=0 to 15 do fddSectorBuf[k+i]:=buf[i];{}
fddWriteSector(p.fddfile,0,b);

FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
{$I+}
if ioresult=0 then fddSave:=true;
End;



{============================================================================}
function fddDel(var p:TPanel):boolean;
var df,b,k,io:byte; buf:array[0..15]of byte; fs:file;
begin
fddDel:=false;
  {$I-}

  for i:=1 to p.tfiles do if p.trddir^[i].mark then
   begin
    df:=i-1; b:=(df div 16)+1; if (df mod 16)=0 then dec(b);
    fddReadSector(p.fddfile,0,b);

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
    for io:=0 to 15 do fddSectorBuf[k+io]:=buf[io];{}
    fddWriteSector(p.fddfile,0,b);

    p.trddir^[i].mark:=false;
    inc(p.zxdisk.delfiles);
   end;
  {$I+}
fddReadSector(p.fddfile,0,9);
fddSectorBuf[$f4]:=p.zxdisk.delfiles;
fddWriteSector(p.fddfile,0,9);
if ioresult=0 then fddDel:=true;
  if AutoMove then
   begin
    trdautomove:=true;
    fddMove(p);
    trdautomove:=false;
   end;
end;



{============================================================================}
function fddRename:boolean;
var xc,yc,df,b,k,io:byte; buf:array[0..15]of byte; fs:file; s,stemp:string;
    p:tPanel;
begin
Case focus of left:p:=lp; right:p:=rp; End;

fddRename:=false;
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
fddReadSector(p.fddfile,0,b);

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
for io:=0 to 15 do fddSectorBuf[k+io]:=buf[io];{}
fddWriteSector(p.fddfile,0,b);

fddReadSector(p.fddfile,0,9);
fddSectorBuf[$f4]:=p.zxdisk.delfiles;
fddWriteSector(p.fddfile,0,9);

END;
  {$I+}
if ioresult=0 then fddRename:=true;
reMDF; reInfo('cbdnsfi'); rePDF;
end;




{============================================================================}
function fddMove(var p:Tpanel):boolean;
type hbuft=array[1..2] of byte;
var fr,t:word;
    c,i,a,m,k,io:word; fs:file; buf:^hbuft; nr,nw:word; hbuf:array[0..15] of byte;
    b:byte;
    stemp:string;
begin
fddMove:=false;
if p.zxdisk.delfiles=0 then exit;
CancelSB;
if lang=rus then stemp:='Хотите уплотнить'#255'этот диск ?'
            else stemp:='Do you wish to move'#255'this disk ?';
if not trdautomove then
if not cquestion(stemp,lang) then exit;
if checkdirfile(p.fddfile)<>0 then
 begin
  if lang=rus then errormessage('Не найден файл '+strlo(getof(p.fddfile,_name))+'.fdd')
  else errormessage('File '+strlo(getof(p.fddfile,_name))+'.fdd not found');
  p.paneltype:=pcpanel;
  p.pcMDF(p.pcnd);
  p.truecur;
  p.inside;
  p.Info('cbdnsfi');
  p.pcPDF(p.pcfrom);
  exit;
 end;
fddMDF(p,p.fddfile);

fr:=0; t:=0;
for i:=2 to p.fddtfiles do inc(fr,p.trddir^[i].totalsec); inc(fr,p.zxdisk.free);
for i:=2 to p.fddtfiles do
 if (ord(p.trddir^[i].name[1])<>1)and(ord(p.trddir^[i].name[1])<>0)
   then inc(t,p.trddir^[i].totalsec);
p.zxdisk.free:=fr-t;

for i:=2 to p.fddtfiles do
 if (ord(p.trddir^[i].name[1])=1)or(ord(p.trddir^[i].name[1])=0) then break;
p.zxdisk.n1freesec:=p.trddir^[i].n1sec;
p.zxdisk.ntr1freesec:=p.trddir^[i].n1tr;
p.zxdisk.files:=i-2;

for c:=i to p.fddtfiles do
 if (ord(p.trddir^[c].name[1])<>1)and(ord(p.trddir^[c].name[1])<>0) then break;

for a:=c to p.fddtfiles do
if (ord(p.trddir^[a].name[1])<>1)and(ord(p.trddir^[a].name[1])<>0) then
 begin
  fddLoad(p,a);
  fddSave(p);
  inc(p.zxdisk.free,p.trddir^[a].totalsec);{}
 end;

for m:=p.zxdisk.files+2 to 128 do
 begin
  c:=m-1; b:=(c div 16)+1; if (c mod 16)=0 then dec(b);
  fddReadSector(p.fddfile,0,b);
  k:=c-(c div 16)*16; if k=0 then k:=16; k:=(k-1)*16;
  fddSectorBuf[k]:=0;
  fddWriteSector(p.fddfile,0,b);
 end;

fddReadSector(p.fddfile,0,9);
fddSectorBuf[$f4]:=p.zxdisk.delfiles;
fddSectorBuf[$e1]:=p.zxdisk.n1freesec;
fddSectorBuf[$e2]:=p.zxdisk.ntr1freesec;
fddSectorBuf[$e4]:=p.zxdisk.files;
fddSectorBuf[$f4]:=0;
fddSectorBuf[$e5]:=lo(p.zxdisk.free);
fddSectorBuf[$e6]:=hi(p.zxdisk.free);
fddWriteSector(p.fddfile,0,9);

if ioresult=0 then fddMove:=true;

p.fddMDFs(p.fddfile);
if trdAutoMove then exit;
p.TrueCur; p.Inside;
reInfo('cbdnsfi');
rePDF;
end;



{============================================================================}
function fddLabel:boolean;
var s:string; fs:file of byte; b:byte; p:TPanel;
label fin;
begin
fddLabel:=false; Case focus of left:p:=lp; right:p:=rp; End;
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
  fddReadSector(p.fddfile,0,9);
  fddSectorBuf[$f4]:=p.zxdisk.delfiles;

  for i:=1 to 8 do fddSectorBuf[$f5+i-1]:=ord(s[i]);

  fddWriteSector(p.fddfile,0,9);
  if ioresult=0 then fddLabel:=true;
  reMDF; rePDF;
 end;
fin:
reInfo('cbdnsfi');
end;




{============================================================================}
procedure fddMakeImage(var p:TPanel; BootOnly:boolean);
var name:string; stemp,tr:string;
    buf:array[1..8192] of byte;
    i,w,w1,w2:word;
    ff:file;
    fb:file of byte;
    ft:text;
    s,b,h:byte;
    fpos,l:longint;
    pp:TPanel;
begin
 CancelSB;

if BootOnly then else
BEGIN
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+2);
 if makeboot
  then if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый FDD-файл + boot ')
                   else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New FDD-file + boot ')
  else if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый FDD-файл ')
                   else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New FDD-file ');

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
    begin if lang=rus then errormessage('Ошибка при создании FDD-файла')
                      else errormessage('Error while create FDD-file'); exit; end;

if scanf_esc then exit;
if nospace(name)<>'' then
 begin
 {$I-}
  scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+2);
  if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,30,halfmaxy-2,'Форматирование...')
              else cmprint(pal.bkdLabelST,pal.txtdLabelST,30,halfmaxy-2,'Formating...');
  cmprint(7,0,30,halfmaxy-1,fill(23,#177));

  if lang=rus then stemp:='Файл '+getof(name,_name)+'.fdd'+' уже существует.'+#255+' Заменить его?'
              else stemp:='File '+getof(name,_name)+'.fdd'+' alredy exist.'+#255+' Overwrite?';
  if checkdirfile(p.pcnd+getof(name,_name)+'.fdd')=0 then
   if not cquestion(stemp,lang) then exit;

  if vall(tr)=0 then tr:='80';

  p.pcnn:=getof(name,_name)+'.fdd';
  assign(ff,p.pcnd+getof(name,_name)+'.fdd'); filemode:=2; rewrite(ff,1);
  stemp:='SPM DISK (c) 1996 MOA v0.1    ';
  for i:=1 to 30 do buf[i]:=ord(stemp[i]);  {SPM}
  buf[31]:=vall(tr);                        {cylinders}
  buf[32]:=2;                               {heads}
  buf[33]:=0; buf[34]:=0; buf[35]:=0; buf[36]:=0;
  blockwrite(ff,buf,36);

  fpos:=716;
  for i:=1 to 2*85 do
   Begin
    buf[1]:=lo(longlo(fpos)); buf[2]:=hi(longlo(fpos));
    buf[3]:=lo(longhi(fpos)); buf[4]:=hi(longhi(fpos));
    if i>2*vall(tr) then
     begin
      buf[1]:=0; buf[2]:=0; buf[3]:=0; buf[4]:=0;
     end;
    blockwrite(ff,buf,4);
    inc(fpos,30*8+2+16*256);
   End;

  w:=1; w2:=vall(tr);
  for i:=1 to w2 do for h:=1 to 2 do
   Begin
    buf[1]:=0; buf[2]:=16; blockwrite(ff,buf,2);
    for s:=1 to 30 do
     Begin
      fpos:=716;

      l:=30*8; inc(l,2); l:=l*w; inc(fpos,l);
      l:=16*256; l:=l*(w-1); inc(fpos,l);
      l:=(s-1)*256; inc(fpos,l);

      {if w=160 then message('tr:'+strr(w)+'  sec:'+strr(s)+'  fpos:'+strr(fpos));{}
      buf[1]:=i-1; buf[2]:=0; buf[3]:=s; buf[4]:=1;

      w1:=longlo(fpos); buf[5]:=lo(w1); buf[6]:=hi(w1);
      w1:=longhi(fpos); buf[7]:=lo(w1); buf[8]:=hi(w1);
      if s>16 then
       begin
        buf[1]:=0; buf[2]:=0; buf[3]:=0; buf[4]:=0;
        buf[5]:=0; buf[6]:=0; buf[7]:=0; buf[8]:=0;
       end;
      blockwrite(ff,buf,8);
     End;
    {for s:=1 to 16 do blockwrite(ff,buf,256);{}
    for w1:=1 to 4096 do Buf[w1]:=0;
    blockwrite(ff,buf,4096);
    inc(w);
    ProcessBar(0,round(100*i/(w2)),22,'');
    cmprint(7,0,49,halfmaxy-0,strr(round(100*i/(w2))-1)+'%');
   End;
{}
  close(ff);

{  fddReadSector(p.pcnd+getof(name,_name)+'.fdd',0,9);{}

  for w1:=1 to 256 do fddSectorBuf[w1]:=0;

  fddSectorBuf[$e1]:=0; fddSectorBuf[$e2]:=1;
  if vall(nospace(tr))=40 then fddSectorBuf[$e3]:=$17 else fddSectorBuf[$e3]:=$16;

  fddSectorBuf[$e4]:=0;

  i:=(vall(tr)*2-1)*16; fddSectorBuf[$e5]:=lo(i); fddSectorBuf[$e6]:=hi(i);

  fddSectorBuf[$e7]:=$10;
{  for i:=0 to 9 do fddSectorBuf[$ea]:=32;{}
  fddSectorBuf[$f4]:=0;

  name:=name+space(8-length(name));
  for i:=0 to 7 do fddSectorBuf[$f5+i]:=ord(name[i+1]);
{
  w:=1;
  stemp:='ZX Spectrum Navigator  Version '+ver+'  Copyright (c) 1997,98 RomanRoms Software Co.  ';
  for i:=0 to length(stemp)-1 do fddSectorBuf[w+i]:=ord(stemp[i+1]);

  inc(w,length(stemp));
  stemp:='Russia. Nizhny Novgorod.  Written by Roman Khroupnin (RomanRom2)  ';
  for i:=0 to length(stemp)-1 do fddSectorBuf[w+i]:=ord(stemp[i+1]);

  inc(w,length(stemp));
  stemp:='To find me use FIDOnet - 2:5015/97 or Internet - RomanRom2@usa.net';
  for i:=0 to length(stemp)-1 do fddSectorBuf[w+i]:=ord(stemp[i+1]);
{}
  fddWriteSector(p.pcnd+getof(name,_name)+'.fdd',0,9);

  {$I+}
  i:=ioresult;
  if i<>0 then if lang=rus then errormessage('Ошибка '+strr(i)+' при создании FDD-файла')
                           else errormessage('Error '+strr(i)+' while create FDD-file');
  RestScr;
 end;
END;

  if (makeboot)and(checkdirfile(startdir+'\boots\boots.ini')=0) then
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
           if BootOnly then else p.fddfile:=p.pcnd+getof(name,_name)+'.fdd';
           p.fddMDFs(p.fddfile);
           if hobetainfo.totalsec>p.zxdisk.free then
           if lang=rus then errormessage('Hет меcта на диcке для boot.<B>')
                       else errormessage('Not enough space for boot.<B>')
           else if hobLoad(startdir+'\boots\'+stemp) then fddSave(p)
          end;
        if isSCL(startdir+'\boots\'+stemp) then
         begin
          p.sclfile:=startdir+'\boots\'+stemp;
          sclMDF(p,p.sclfile);
          if BootOnly then else p.fddfile:=p.pcnd+getof(name,_name)+'.fdd';
          for i:=1 to p.zxdisk.files do
           Begin
            sclMDF(p,p.sclfile);
            sclLoad(p,i+1);{}
            p.fddMDFs(p.fddfile);
            fddSave(p);
           End;
         end;
       end;
     end;
   End;
makeboot:=false;
{}
end;









End.