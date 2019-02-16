{$O+,F+}
Unit SCL_Ovr;
interface
Uses RV, sn_Obj, Vars, Main, Main_Ovr, Palette, TRD,TRD_Ovr;

function  sclLoad(var p:TPanel; ind:word):boolean;
function  sclSave(var p:TPanel):boolean;

function  sclDel(var p:TPanel):boolean;
function  sclRename:boolean;

function  sclMakeImage(sys:boolean):boolean;



Implementation



{============================================================================}
function  sclLoad(var p:TPanel; ind:word):boolean;
Var f:file; fpos:longint; i:word;
Begin
HobetaInfo.name:=p.trdDir^[ind].name;
HobetaInfo.typ:=p.trdDir^[ind].typ;
HobetaInfo.start:=p.trdDir^[ind].start;
HobetaInfo.length:=p.trdDir^[ind].length;
HobetaInfo.param2:=p.trdDir^[ind].length;
if HobetaInfo.typ<>'B' then HobetaInfo.param2:=32768;
HobetaInfo.totalsec:=p.trdDir^[ind].totalsec;

sclLoad:=false; fpos:=0;
{$I-}
GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);
assign(f,p.sclfile); filemode:=0; reset(f,1);

for i:=2 to ind-1 do inc(fpos,p.trdDir^[i].totalsec); fpos:=256*fpos;
inc(fpos,9+14*p.zxDisk.files);

seek(f,fpos);
blockread(f,HobetaInfo.body^,256*HobetaInfo.totalsec);
close(f);
{$I+}
if ioresult=0 then sclLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;



{============================================================================}
function  sclSave(var p:TPanel):boolean;
type
    tbuf=array[1..2] of byte;
Var f:file; i,b:byte; buf:array[1..14]of byte; l,fpos:longint;
    w,bufsize,nr:word; csbuf:^tbuf;
Begin
sclSave:=false;
{$I-}
assign(f,p.sclfile); filemode:=2; reset(f,1);

seek(f,filesize(f)-4); blockwrite(f,HobetaInfo.body^,256*HobetaInfo.totalsec);
inc(p.scltfiles); inc(p.zxdisk.files);
p.trdDir^[p.scltfiles].totalsec:=HobetaInfo.totalsec;

for i:=p.scltfiles downto 2 do
 Begin
  fpos:=0;
  for b:=2 to i-1 do inc(fpos,p.trdDir^[b].totalsec); fpos:=256*fpos;
  inc(fpos,9+14*(p.scltfiles-2));
  seek(f,fpos);    blockread (f,HobetaInfo.body^,256*p.trdDir^[i].totalsec);
  seek(f,fpos+14); blockwrite(f,HobetaInfo.body^,256*p.trdDir^[i].totalsec);
 End;

for i:=1 to 8 do buf[i]:=ord(HobetaInfo.name[i]);
buf[9]:=ord(HobetaInfo.typ);
buf[10]:=lo(HobetaInfo.start);
buf[11]:=hi(HobetaInfo.start);
buf[12]:=lo(HobetaInfo.length);
buf[13]:=hi(HobetaInfo.length);
buf[14]:=HobetaInfo.totalsec;

seek(f,9+14*(p.scltfiles-2)); blockwrite(f,buf,14);
seek(f,8); b:=p.zxdisk.files; blockwrite(f,b,1);

FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);

l:=0;
if MemAvail<65280 then bufsize:=MemAvail-10240 else bufsize:=65280;
getmem(csbuf,bufsize);
seek(f,0);
Repeat
BlockRead(f,csbuf^,bufsize,nr);
if nr=bufsize then for w:=1 to bufsize do inc(l,csbuf^[w]);
if (nr<>bufsize)and(nr<>0) then for w:=1 to nr do inc(l,csbuf^[w]);
Until nr=0;
freemem(csbuf,bufsize);

b:=lo(longlo(l)); blockwrite(f,b,1);
b:=hi(longlo(l)); blockwrite(f,b,1);
b:=lo(longhi(l)); blockwrite(f,b,1);
b:=hi(longhi(l)); blockwrite(f,b,1);

close(f);
{$I+}
if ioresult=0 then sclSave:=true;
End;



{============================================================================}
function sclDel(var p:TPanel):boolean;
type
    tbuf=array[1..2] of byte;
Var f:file; ind,i,b,m:byte; buf:array[1..14]of byte; l,fpos:longint;
    w,bufsize,nr:word; csbuf:^tbuf;
Begin
sclDel:=false;
{$I-}
assign(f,p.sclfile); filemode:=2; reset(f,1);  ind:=p.Index-1;

for ind:=p.tfiles-1 downto 1 do if p.trdDir^[ind+1].mark then
 BEGIN{}
  for i:=ind to p.zxdisk.files do
   Begin
    seek(f,9+14*(i-0)); blockread(f,buf,14);
    seek(f,9+14*(i-1)); blockwrite(f,buf,14);
   End;

  for i:=1 to ind-1 do
   Begin
    fpos:=0; for b:=1 to i-1 do inc(fpos,p.trdDir^[b+1].totalsec);
    fpos:=256*fpos; inc(fpos,9+14*p.zxdisk.files);

    getmem (HobetaInfo.body,256*p.trdDir^[i+1].totalsec);
    seek(f,fpos);    blockread (f,HobetaInfo.body^,256*p.trdDir^[i+1].totalsec);
    seek(f,fpos-14); blockwrite(f,HobetaInfo.body^,256*p.trdDir^[i+1].totalsec);
    freemem(HobetaInfo.body,256*p.trdDir^[i+1].totalsec);
   End;

  for i:=ind+1 to p.zxdisk.files do
   Begin
    w:=256*p.trdDir^[i+1].totalsec;
    getmem(HobetaInfo.body,w);
    fpos:=0; for b:=1 to i-1 do inc(fpos,p.trdDir^[b+1].totalsec);
    fpos:=256*fpos;
    w:=14*p.zxdisk.files; inc(fpos,9+w);
    seek(f,fpos);
    w:=256*p.trdDir^[i+1].totalsec; blockread(f,HobetaInfo.body^,w);

    w:=256*p.trdDir^[ind+1].totalsec;
    dec(fpos,w); dec(fpos,14); seek(f,fpos);
    w:=256*p.trdDir^[i+1].totalsec;
    blockwrite(f,HobetaInfo.body^,w);
    freemem(HobetaInfo.body,w);
   End;

  fpos:=0;
  for i:=1 to ind-1 do inc(fpos,p.trdDir^[i+1].totalsec);
  for i:=ind+1 to p.zxdisk.files do inc(fpos,p.trdDir^[i+1].totalsec);
  fpos:=256*fpos; inc(fpos,9+14*(p.zxdisk.files-1));
  seek(f,fpos); truncate(f);

  dec(p.zxdisk.files); dec(p.scltfiles);
  seek(f,8); b:=p.zxdisk.files; blockwrite(f,b,1);

  l:=0; bufsize:=65280; seek(f,0);
  getmem(csbuf,bufsize);
  Repeat
   BlockRead(f,csbuf^,bufsize,nr);
   if nr=bufsize then for w:=1 to bufsize do inc(l,csbuf^[w]);
   if (nr<>bufsize)and(nr<>0) then for w:=1 to nr do inc(l,csbuf^[w]);
  Until nr=0;
  freemem(csbuf,bufsize);
  b:=lo(longlo(l)); blockwrite(f,b,1);
  b:=hi(longlo(l)); blockwrite(f,b,1);
  b:=lo(longhi(l)); blockwrite(f,b,1);
  b:=hi(longhi(l)); blockwrite(f,b,1);

  p.sclMDFs(p.sclfile);
{  p.sclPDFs(p.sclfrom); rpause;{}
 END;
{}
close(f);
{$I+}
if ioresult=0 then sclDel:=true;
End;




{============================================================================}
function sclRename:boolean;
type
    tbuf=array[1..2] of byte;
var i,io:integer;
    stemp,s:string;
    fs:file;
    xc,yc,b:byte;
    buf:array[1..14] of byte; csbuf:^tbuf;
    p:TPanel;
    w,nr,bufsize:word;
    l:longint;
label fin;
Begin
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
  assign(fs,p.sclfile); filemode:=2; reset(fs,1);
  i:=p.Index;
  if (TRDOS3)and(p.trddir^[p.Index].typ<>'B') then p.trddir^[i].start:=256*ord(stemp[12])+ord(stemp[11]);

  seek(fs,9+14*(p.Index-2)); blockread(fs,buf,14);
  for i:=1 to 8 do buf[i]:=ord(stemp[i]);
  if (TRDOS3)and(p.trddir^[p.Index].typ<>'B') then buf[9]:=ord(stemp[10]) else buf[9]:=ord(stemp[11]);
  buf[10]:=lo(p.trddir^[p.Index].start);
  buf[11]:=hi(p.trddir^[p.Index].start);
  seek(fs,9+14*(p.Index-2)); blockwrite(fs,buf,14);

  l:=0; bufsize:=65280; seek(fs,0);
  getmem(csbuf,bufsize);
  Repeat
   BlockRead(fs,csbuf^,bufsize,nr);
   if nr=bufsize then for w:=1 to bufsize do inc(l,csbuf^[w]);
   if (nr<>bufsize)and(nr<>0) then for w:=1 to nr do inc(l,csbuf^[w]);
  Until nr=0;
  freemem(csbuf,bufsize);
  b:=lo(longlo(l)); blockwrite(fs,b,1);
  b:=hi(longlo(l)); blockwrite(fs,b,1);
  b:=lo(longhi(l)); blockwrite(fs,b,1);
  b:=hi(longhi(l)); blockwrite(fs,b,1);

  close(fs);
  {$I+}
  i:=ioresult;
  {if itemp<>0 then errormessage('Неожиданная ошибка '+strr(itemp));{}

 end;
fin:
reMDF; reInfo('cbdnsfi'); rePDF;
End;



{============================================================================}
function  sclMakeImage(sys:boolean):boolean;
var p:TPanel; name,stemp:string; i:byte; f:file; a:array[1..13] of byte;
begin
sclMakeImage:=false; name:='';

{if not sys then{}
BEGIN
Case focus of left:p:=lp; right:p:=rp; End;
 CancelSB;
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+0);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый SCL-файл ')
             else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New SCL-file ');
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'Имя файла:')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'File name:');
 printself(pal.bkdInputNT,pal.txtdInputNT,42,halfmaxy-2,8);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon; name:=scanf(42,halfmaxy-2,name,8,8,1); curoff;
 restscr;
 name:=nospace(GetOf(name,_name));
END
{else name:=nm{};

if sys then Case focus of left:p:=rp; right:p:=lp; End;



if scanf_esc then exit;
if nospace(name)<>'' then
 begin
 {$I-}
  if lang=rus then stemp:='Файл '+name+'.scl'+' уже существует.'+#255+' Заменить его?'
              else stemp:='File '+name+'.scl'+' already exist.'+#255+' Overwrite?';
  if checkdirfile(p.pcnd+name+'.scl')=0 then if not cquestion(stemp,lang) then exit;
  a[1]:=$53; a[2]:=$49; a[3]:=$4e; a[4]:=$43; a[5]:=$4c; a[6]:=$41; a[7]:=$49;
  a[8]:=$52; a[9]:=0; a[10]:=$55; a[11]:=2; a[12]:=0; a[13]:=0;
  if not sys then
    case focus of left:lp.pcnn:=name+'.scl'; right:rp.pcnn:=name+'.scl'; end;


  if not sys then
    begin
     {
     if FOCUS=left  then lp.sclfile:=lp.pcnd+name+'.scl'
                    else rp.sclfile:=rp.pcnd+name+'.scl';
     {}
    end
             else
    begin
     if FOCUS=right then lp.sclfile:=lp.pcnd+name+'.scl'
                    else rp.sclfile:=rp.pcnd+name+'.scl';
    end;
  {}

  assign(f,p.pcnd+name+'.scl'); filemode:=1; rewrite(f,1); blockwrite(f,a,13); close(f);
 {$I+}
  i:=ioresult;
  if i<>0 then
   begin
    if lang=rus then errormessage('Ошибка '+strr(i)+' при создании SCL-файла')
                else errormessage('Error '+strr(i)+' while create SCL-file');
    exit;
   end;
  sclMakeImage:=true;
 end;
end;









End.