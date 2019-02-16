{$O+,F+}
Unit PC_Ovr;
Interface
Uses Crt,Dos,sn_Obj;

Procedure pcF7Pressed(path:string; w:byte);
Procedure pcDelete(ndpath:string; nm:pathstr; priory:byte; attr:byte);
Procedure pcF8;

Procedure pc2pc(flag:word);

Procedure pcRename;
procedure hobRename;

procedure pcAltF;

Procedure pcEditFile(nm:string);
function  whatbyext(fname,sname:string):string;
function  whatbylen(leng,fname,sname:string; change:boolean):string;
function  CheckExt(var s:string):boolean;
function  reBuildName(str,n:string):string;
function  ExecuteView(comm:string):boolean;
Procedure pcViewFile(nm:string);

Function  hobLoad(name:string):boolean;
Function  hobSave(path:string; AltF5flag:boolean):boolean;
procedure MakeImages(var p:TPanel);
procedure pcAltH(var p:TPanel);


Implementation
Uses Vars,RV,Main,Main_Ovr,Mouse,PC,Utils,TRD,FDI,FDD,TRD_Ovr,FDD_Ovr,FDI_Ovr,
     SCL_Ovr,TAP_Ovr,zxView,Palette,trdos;


{============================================================================}
procedure pcF7Pressed(path:string; w:byte);
var d:pathstr;
    i:integer;
    s:string[12];
function pcMakeDir:boolean;
begin
 if lang=rus then cstatusbar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,'~`ESC~` Отмена')
 else cstatusbar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,'~`ESC~` Cancel');
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,17,halfmaxy-3,64,halfmaxy-3+3);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-3,' Создать каталог ')
 else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-3,' Make directory ');
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy-2,'Имя каталога')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy-2,'Directory name');
 printself(pal.bkdInputNT,pal.txtdInputNT,19,halfmaxy-1,44);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon;
 d:=nospace(scanf(20,halfmaxy-1,'',42,42,1));
 curoff;
 restscr;
 pcMakeDir:=not scanf_esc;
 if nospace(d)='' then pcMakeDir:=false;
end;

Begin
if pcMakeDir then
 begin
  s:=strhi(getof(d,_name)+getof(d,_ext));

  if (clen(d)=clen(without(d,':')))and(d[1]<>'\') then d:=path+d;
  if d[clen(d)]<>'\' then d:=d+'\';
  createdir(d);
  reMDF;
  if w=left then
   begin
    lp.pcnn:=s;
   end
  else
   begin
    rp.pcnn:=s;
   end;
  lp.TrueCur; lp.Inside;
  rp.TrueCur; rp.Inside;
  reInfo('cdsfi');
  rePDF;
 end;
end;





{============================================================================}
procedure pcDelete(ndpath:string; nm:pathstr; priory:byte; attr:byte);

procedure Dels(path:pathstr);
procedure DirDel(n:string); begin {$I-} rmdir(n); {$I+} if ioresult<>0 then; end;
procedure DelFileScan(path:pathstr);
var sr:searchrec; s:string; attr:word; dest:file;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if (sr.attr and (directory or volumeid)=0) then
    begin
     s:=path+'\'+sr.name; delete(s,1,length(ndpath));
     assign(dest,{nospace{}(path+'\'+sr.name));
     getfattr(dest,attr); if attr and ReadOnly <> 0 then setfattr(dest,(attr xor ReadOnly));
     filedelete({nospace{}(path+'\'+sr.name));
    end;
   FindNext(sr);
  end;
end;

procedure DelDirScan(path:pathstr);
var sr:searchrec; s:string;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if ((sr.attr and directory)=directory)and not((sr.name='.')or(sr.name='..')) then
    begin
     deldirscan(path+'\'+sr.name);
     cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,
              halfmaxy-1,space((17-length(sr.name))div 2)+sr.name+space((17-length(sr.name))div 2));
     delfilescan(path+'\'+sr.name);
     dirdel(path+'\'+sr.name);
     if refresh then reInfo('sf');{}
    end;
   FindNext(sr);
  end;
end;

var a:string;
begin
deldirscan(path);
delfilescan(path);

if nospace(getof(path,_ext))=''
  then a:={nospace{}(getof(path,_name))
  else a:={nospace{}(getof(path,_name)+getof(path,_ext));

cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,
space((17-length(a))div 2)+
a+
space((17-length(a))div 2));
dirdel(path);
end;


var d:pathstr;
    i:integer;
    s:string;
Begin
if priory=0
 then if lang=rus then s:='Удаляется каталог' else s:='Deleting directory'
 else if lang=rus then s:=' Удаляется файл  ' else s:='  Deleting file   ';
cmCentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-2,s);
cmCentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,space((17-length(nm))div 2)+nm+space((17-length(nm))div 2));
if priory=0 then Dels(ndPath+nm) else FileDelete(ndPath+nm);
End;




{============================================================================}
Procedure pcF8;
Var
    i:word; n,s:string;
Begin
if InsedOf(focus)=0 then n:=TrueNameOf(focus,IndexOf(focus));
if InsedOf(focus)=1 then n:=TrueNameOf(focus,FirstMarkedOf(focus));
if IndexOf(focus)>tdirsOf(focus)
 then
  if lang=rus then s:='Хотите удалить'#255'файл '+n+' ?' else
                   s:='Do you wish to delete'#255'file '+n+' ?'
 else
  if lang=rus then s:='Вы дейcтвительно хотите'#255'удалить каталог '+n+' ?' else
                   s:='Do you wish to delete'#255'directory '+n+' ?';
if InsedOf(focus)>1 then
  if lang=rus then s:='Хотите удалить'#255'эти файлы ?' else
                   s:='Do you wish to delete'#255'this files ?';
if (InsedOf(focus)=0)and(nospace(n)='..') then Exit;
CancelSB;
if cQuestion(s,lang) then
 Begin
  if InsedOf(focus)=0 then
   Case focus of
    left: lp.pcDir^[IndexOf(focus)].mark:=true;
    right: rp.pcDir^[IndexOf(focus)].mark:=true;
   End;
  if lang=rus then PutSmallWindow(' Удаление ','   Стоп   ') else PutSmallWindow(' Erase ','   Stop   ');
  for i:=1 to tdirsfilesOf(focus) do if pcDirMarkOf(focus,i) then
   Begin
    pcDelete(pcndOf(focus),TrueNameOf(focus,i),pcDirPrioryOf(focus,i),
             pcDirFAttrOf(focus,i));
    Case focus of
     left: lp.pcDir^[i].mark:=false;
     right: rp.pcDir^[i].mark:=false;
    End;
   End;
  RestScr;
  reMDF;
  lp.TrueCur; rp.TrueCur;
  lp.Inside; rp.Inside;
  reInfo('cbdnsfi');
  rePDF;
 End;
End;


{============================================================================}
Procedure pc2pc(flag:word);
Var
    was:longint;
    TargetPath:string;
    skip:boolean;
    total:longint;
{    UserOut:boolean;{}
    h,m,s,s100:word; timer,timerstart:longint;
    vert:array[1..4] of char; cvert,fcvert:byte;


Procedure CopyMove_pc2pc(cmflag:word; sPath:string; nm:string; tPath:string;
                priory:byte; fattr:word; fdt:datetime;
                skip:boolean; totalsize:longint; var UserOut:boolean);
Var
    path:string;
    stemp:string; itemp:integer;

function GetTimer(sec:string):string;
Var h,m,s:byte; t:integer;
begin
t:=vall(sec);
h:=t div 3600;
m:=t div 60;
s:=t-h*3600-m*60;
GetTimer:=LZ(h)+':'+LZ(m)+':'+LZ(s);
end;

procedure copyfile(cfrom,cto:string; fftime:datetime; ffattr:word);
type mas=array[1..2] of byte;
var buf:^mas;
    ffr,fto:file;
    numread,numwritten:word;
    k,j,i,bufsize:longint;
    q:char;
    ftime:longint;
label outloop,fin,fin2;
begin
if checkdir(getof(cto,_dir))<>0 then createdir(getof(cto,_dir)+'\');
if (checkdirfile(cto)=0)and(skip) then exit;

if pos('\.\',nospace(tPath))<>0 then
 begin
  if lang=rus then errormessage('Нельзя скопировать файл сам в себя')
  else errormessage('Can'#39't copy file to itself');
  {}
  userout:=true;
  goto fin2;
 end;

if checkdir(getof(cto,_dir))<>0 then
 begin
  if lang=rus then errormessage('Ошибка при проверке каталога')
  else errormessage('Error while checking directory');
  userout:=true;
  goto fin2;
 end;

if cfrom=cto then
 begin

  if lang=rus then errormessage('Нельзя скопировать файл сам в себя')
  else errormessage('Can'#39't copy file to itself');
  {}
  userout:=true;
  goto fin2;
 end;

if diskfree(ord(cto[1])-64)<=filelen(cfrom) then
 begin
  if lang=rus then errormessage('Диск '+cto[1]+': полный')
  else errormessage('Disk '+cto[1]+': full');
  userout:=true;
  goto fin2;
 end;

if not checkwrite(cto[1]) then
 begin
  if lang=rus then errormessage('Диск '+cto[1]+': защищен от записи')
  else errormessage('Disk '+cto[1]+': write protect');
  userout:=true;
  goto fin2;
 end;

 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy-3,'Файл')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy-3,'File');
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy,'Всего')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,20,halfmaxy,'Total');
 cmprint(pal.bkdLabelNT,pal.txtdLabelNT,25,halfmaxy-3,strlo(getof(cfrom,_name)+getof(cfrom,_ext))+space(12));
 cmprint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy-2,fill(37,#177));

{$I-}
assign(ffr,cfrom); assign(fto,cto);

{if CheckDirFile(cto)=0 then {}setfattr(fto,archive);
bufsize:=49152; ftime:=0; k:=filelen(cfrom); fcvert:=1;

IF ((upcase(CFROM[1])<>upcase(CTO[1]))and(cmFlag=_F6))or(cmFlag=_F5) THEN
BEGIN
filemode:=1; rewrite(fto,1);
filemode:=0; reset(ffr,1);

getmem(buf,bufsize);
{$I-}
    if filesize(ffr)=0 then goto outloop;
    repeat
     if keypressed then
      begin
       q:=readkey;
       if lang=rus then stemp:='Прервать операцию?' else stemp:='Stop operation?';
       if q=#27 then if cquestion(stemp,lang) then begin userout:=true; break; end;
      end;

     blockread(ffr,buf^,bufsize,numread);
     blockwrite(fto,buf^,numread,numwritten);

     itemp:=ioresult;
     if itemp<>0 then begin {errormessage('Неожиданная ошибка '+strr(itemp));{} userout:=true; break; end;

     inc(was,numread); i:=round(((was)/totalsize)*100); if i>100 then i:=100;
     inc(ftime,numread); j:=round(((ftime)/k)*100); if j>100 then j:=100;

     gettime(h,m,s,s100); timer:=s+m*60+h*3600-timerstart;
     cmprint(pal.bkdStatic,pal.txtdStatic,55,halfmaxy-4,GetTimer(strr(timer)));

     if timer>0 then if lang=rus
     then cmcentre(pal.bkdStatic,pal.txtdStatic,halfmaxy-1,'   ('+strr(round((was/timer)/1024))+' kB/сек)  ')
     else cmcentre(pal.bkdStatic,pal.txtdStatic,halfmaxy-1,'   ('+strr(round((was/timer)/1024))+' kB/sec)  ');

     cmprint(pal.bkdStatic,pal.txtdStatic,20,halfmaxy-2,vert[fcvert]);
     cmprint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy-2,fill(round(j/2.7),#$DB));
     cmprint(pal.bkdStatic,pal.txtdStatic,60,halfmaxy-2,strr(j)+'%'+space(4-length(strr(j)+'%')));
     cmprint(pal.bkdStatic,pal.txtdStatic,20,halfmaxy+1,vert[cvert]);
     cmprint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy+1,fill(round(i/2.7),#$DB));
     cmprint(pal.bkdStatic,pal.txtdStatic,60,halfmaxy+1,strr(i)+'%'+space(4-length(strr(i)+'%')));
     if lang=rus then cmcentre(pal.bkdStatic,pal.txtdStatic,halfmaxy+2,extnum(strr(was))+' байт cкопиpовано')
                 else cmcentre(pal.bkdStatic,pal.txtdStatic,halfmaxy+2,extnum(strr(was))+' bytes copyed');{}
     inc(cvert); if cvert>4 then cvert:=1;
     inc(fcvert); if fcvert>4 then fcvert:=1;

     if moused then MouseOff;
     if moused then MouseOn;
    until (numread=0)or(numwritten<>numread);
outloop:
freemem(buf,bufsize);

fin:
packtime(fftime,ftime); setftime(fto,ftime);
close(ffr); close(fto);
if itcdrom(cfrom[1]) then else begin getfattr(ffr,ffattr); setfattr(fto,ffattr); end;
if cmflag=_F6 then
 begin
  setfattr(ffr,archive); erase(ffr);
 end;
END
ELSE
BEGIN
     setfattr(fto,archive); erase(fto);
     rename(ffr,cto);

     if keypressed then
      begin
       q:=readkey;
       if lang=rus then stemp:='Прервать операцию?' else stemp:='Stop operation?';
       if q=#27 then if cquestion(stemp,lang) then begin userout:=true; end;
      end;
     j:=100;
     inc(was,k); i:=round(((was)/totalsize)*100); if i>100 then i:=100;

     cmprint(pal.bkdStatic,pal.txtdStatic,20,halfmaxy-2,vert[fcvert]);
     cmprint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy-2,fill(round(j/2.7),#$DB));
     cmprint(pal.bkdStatic,pal.txtdStatic,60,halfmaxy-2,strr(j)+'%'+space(4-length(strr(j)+'%')));
     cmprint(pal.bkdStatic,pal.txtdStatic,20,halfmaxy+1,vert[cvert]);
     cmprint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy+1,fill(round(i/2.7),#$DB));
     cmprint(pal.bkdStatic,pal.txtdStatic,60,halfmaxy+1,strr(i)+'%'+space(4-length(strr(i)+'%')));

     inc(cvert); if cvert>4 then cvert:=1;
     inc(fcvert); if fcvert>4 then fcvert:=1;
END;

fin2:
if userout then erase(fto);
{$I+}
if ioresult<>0 then;
if refresh then reInfo('sf');{}
end;

procedure CopyFileScan(path:pathstr);
var sr:searchrec; s:string; dt:datetime;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if (sr.attr and (directory or volumeid)=0) then
    begin
     if userout then exit;
     s:=path+'\'+sr.name; delete(s,1,length(pcndOf(focus)));
     unpacktime(sr.time,dt);
     copyfile({nospace{}(path+'\'+sr.name),{nospace{}(tPath+s),dt,sr.attr);{}
     if userout then exit;
    end;
   FindNext(sr);
  end;
end;

procedure CopyDirScan(path:pathstr);
var sr:searchrec; s:string;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if ((sr.attr and directory)=directory)and not((sr.name='.')or(sr.name='..')) then
    begin
     if userout then exit;
     copydirscan(path+'\'+sr.name);
     if userout then exit;
     copyfilescan(path+'\'+sr.name);
     if userout then exit;
     {$I-} if cmFlag=_F6 then RmDir(path+'\'+sr.name); {$I+}
    end;
   FindNext(sr);
  end;
s:=path; delete(s,1,length(pcndOf(focus))); CreateDir(tpath+s+'\');
end;

Begin
Path:=sPath+nm;
if path[length(path)]='.' then delete(path,length(path),1);
stemp:=reversestr(path);
stemp:=reversestr(copy(stemp,1,pos('\',stemp)));
if pos(Path,tPath)<>0 then
 begin
  if lang=rus then errormessage('Каталог '+stemp+'; попытка рекурсивного копирования')
              else errormessage('Directory '+stemp+'; attempt copy to itself');
  exit;
 end;
if priory=0 then
 begin
  if userout then exit;
  copydirscan(path);
  if userout then exit;
  copyfilescan(path);
  if userout then exit;
  {$I-} if cmFlag=_F6 then RmDir(path); {$I+}
 end
else
 begin
  if userout then exit;
  CopyFile(path,tPath+nm,fdt,fattr);
  if userout then exit;
 end;
if Moused then MouseOff;
if Moused then MouseOn;
End;

Var dt:DateTime; ldt:longint; UserOutCopy:boolean;
BEGIN
UserOutCopy:=false;
 if WillCopyMove(Flag,TargetPath,Skip) then
  Begin
   Colour(pal.bkdRama,pal.txtdRama);
   scPutWin(pal.bkdRama,pal.txtdRama,17,halfmaxy-5,64,halfmaxy-3+6);
   if Flag=_F5
   then
     if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Копирование ')
                 else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Copy ')
   else
     if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Перемещение ')
                 else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Move ');
   if lang=rus
     then cmCentre(pal.bkdStatic,pal.txtdStatic,halfmaxy-1,'  Сканирую каталоги... ')
     else cmCentre(pal.bkdStatic,pal.txtdStatic,halfmaxy-1,' Scaning directories...');
   total:=ViewOf(focus,true);
   cmCentre(pal.bkdStatic,pal.txtdStatic,halfmaxy-1,'                       ');
   if lang=rus
     then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy+3,' Всего '+changechar(extnum(strr(total)),' ',',')+' байт ')
     else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy+3,' Total '+changechar(extnum(strr(total)),' ',',')+' bytes ');
   cmPrint(pal.bkdStatic,pal.txtdStatic,22,halfmaxy+1,fill(37,#177));
   was:=0;
gettime(h,m,s,s100); timerstart:=s+m*60+h*60*60;
vert[1]:='-'; vert[2]:='\'; vert[3]:='|'; vert[4]:='/';
cvert:=1;
   if InsedOf(focus)=0 then
    begin
     UnPackTime(pcDirFdtOf(focus,IndexOf(focus)),dt);
     CopyMove_pc2pc(flag,pcndOf(focus),TrueNameOf(focus,IndexOf(focus)),
                    TargetPath,
                    pcDirPrioryOf(focus,IndexOf(focus)),
                    pcDirFAttrOf(focus,IndexOf(focus)),dt,
                    Skip,total,UserOutCopy);
    end;
   if InsedOf(focus)>0 then for i:=1 to tdirsfilesOf(focus) do if pcDirMarkOf(focus,i) then
    begin
     if UserOutCopy then break;
     UnPackTime(pcDirFdtOf(focus,i),dt);
     CopyMove_pc2pc(flag,pcndOf(focus),TrueNameOf(focus,i),
                    TargetPath,
                    pcDirPrioryOf(focus,i),
                    pcDirFAttrOf(focus,i),dt,Skip,total,UserOutCopy);
     if UserOutCopy then break;
     Case focus of
      left: lp.pcDir^[i].mark:=false;
      right: rp.pcDir^[i].mark:=false;
     End;
    {}
    end;
  End;
 RestScr;
 reMDF;
  lp.TrueCur; lp.Inside;
  rp.TrueCur; rp.Inside;
 reInfo('cb nsfi');
 rePDF;
END;




{============================================================================}
Procedure pcRename;
Var
    s,stemp:string; ff:file; CurXPos, CurYPos:byte;
    n,dx:byte;
{== SCANF ===================================================================}
function SNscanf(scanf_posx, scanf_posy:byte;scanf_str:string):string;
var
     scanf_kod:char;
     scanf_x:byte;
     scanf_str_old:string;
label loop;
begin
scanf_esc:=false;
scanf_str_old:=scanf_str;
scanf_x:=1;
{scanf_str:=scanf_str+space(DX-length(scanf_str));{}
loop:
mprint(scanf_posx,scanf_posy,scanf_str);
gotoxy(scanf_posx+scanf_x-1,scanf_posy);
scanf_kod:=readkey;
if (scanf_kod in[' '..')','-','0'..'9','@'..'[',']'..#255])and(scanf_x<=length(scanf_str)) then
 begin
  scanf_str[scanf_x]:=scanf_kod;
  inc(scanf_x);
  if scanf_x=DX+1 then inc(scanf_x);
 end;
if scanf_kod='.' then scanf_x:=DX+2;

if scanf_kod=kb_CtrlB then if ASCIITable(scanf_posx,scanf_posy+1,lang,ASCln,scanf_kod,n) then
 begin
  scanf_str[scanf_x]:=scanf_kod;
  inc(scanf_x);
  if scanf_x=DX+1 then inc(scanf_x);
 end;
ASCln:=n;

if scanf_kod=#0 then
 begin
  scanf_kod:=readkey;
  if scanf_kod=#77 then begin inc(scanf_x); if scanf_x=DX+1 then inc(scanf_x); end;
  if scanf_kod=#75 then begin dec(scanf_x); if scanf_x=DX+1 then dec(scanf_x); end;
  if scanf_kod=#72 then scanf_kod:=#13;
  if scanf_kod=#80 then scanf_kod:=#13;
 end;

if scanf_kod=#27 then begin snscanf:=scanf_str_old; scanf_esc:=true; exit; end;
if scanf_kod=#13 then begin snscanf:=scanf_str; exit; end;

if scanf_x<1 then scanf_x:=1;
if scanf_x>DX+4 then begin scanf_x:=DX+4; end;
goto loop;
end;


Begin
 Case focus of
  left: stemp:=lp.pcDir^[IndexOf(focus)].fname;
  right: stemp:=rp.pcDir^[IndexOf(focus)].fname;
 End;
 if nospace(stemp)='..' then exit;
 CancelSB;
 GetCurXYOf(focus,CurXPos,CurYPos);
 Case ColumnsOf(focus) of
  1,3: DX:=8;
  2:   Begin DX:=15; if (CurXPos=2)or(CurXPos=42) then dec(DX);{} End;
 End;

 Colour(pal.bkCurNT,pal.txtCurNT);
 Case focus of
  left:  stemp:=sRexpand(lp.pcdir^[IndexOf(focus)].fname,DX)+'.'+sRexpand(lp.pcdir^[IndexOf(focus)].fext,3);
  right: stemp:=sRexpand(rp.pcdir^[IndexOf(focus)].fname,DX)+'.'+sRexpand(rp.pcdir^[IndexOf(focus)].fext,3);
 End;
 s:=TrueNameOf(focus,IndexOf(focus));
 if IndexOf(focus)>tdirsOf(focus) then stemp:=strlo(stemp);
 CurOn; SetCursor(400); stemp:=nospace(snscanf(CurXPos,CurYPos,stemp)); CurOff;
 if not scanf_esc then
  begin
   {$I-}
   assign(ff,pcndOf(focus)+s);
   rename(ff,pcndOf(focus)+stemp);
   {$I+}
   if ioresult<>0 then;
   reMDF;
   if stemp[length(stemp)]='.' then delete(stemp,length(stemp),1);
   Case focus of
    left: lp.pcnn:=stemp;
    right: rp.pcnn:=stemp;
   End;
   reTrueCur;
   reInside;
   reInfo('ni');
   rePDF;
  end;
End;




{============================================================================}
procedure hobRename;
var
   buf:array[1..19]of byte;
   s,stemp:string;
   tc,xc,yc:byte;
   m:word;
   f:file;
begin
if not itHobeta(pcndOf(focus)+TrueNameOf(focus,IndexOf(focus)),HobetaInfo) then exit;{}
CancelSB;
colour(pal.bkCurNT,pal.txtCurNT);

stemp:=HobetaInfo.name+'.';
if TRDOS3 then stemp:=stemp+hobetainfo.typ+chr(lo(hobetainfo.start))+chr(hi(hobetainfo.start))
          else stemp:=stemp+'<'+hobetainfo.typ+'>';

GetCurXYOf(focus,xc,yc);
curon; SetCursor(400); stemp:=zxsnscanf(xc,yc,stemp,HobetaInfo.typ); curoff;
if not scanf_esc then
 begin
  for xc:=1 to 8 do buf[xc]:=byte(stemp[xc]);
  if TRDOS3 then
   begin
    buf[9]:=byte(stemp[10]);
    buf[10]:=byte(stemp[11]);
    buf[11]:=byte(stemp[12]);
   end
  else
   begin
    buf[9]:=byte(stemp[11]);
    buf[10]:=lo(hobetainfo.start);
    buf[11]:=hi(hobetainfo.start);
   end;

  m:=HobetaInfo.length; buf[12]:=lo(m); buf[13]:=hi(m);
  buf[14]:=0; buf[15]:=HobetaInfo.totalsec;
  m:=0; for tc:=1 to 15 do m:=m+257*buf[tc]+(tc-1);
  buf[16]:=lo(m); buf[17]:=hi(m);

  {$I-}
  assign(f,pcndOf(focus)+TrueNameOf(focus,IndexOf(focus))); FileMode:=2;
  Reset(f,1);  Seek(f,0); BlockWrite(f,buf,17); Close(f);
  {$I+}
  if IOResult=0 then;
 end;
rePDF;
end;



{============================================================================}
procedure pcAltF;
var
    attrs:array[1..4]of string[24];
    xc,k,c,cs,i,lc:word;
    fa:file;
    stemp:string;
    ftime,fdate:string[8];
    unsetattrs,setattrs:array[1..4] of boolean;
label loop,loop2,loop3, loop4,loop5,loop6, fin;
Var
    bk:array[1..4] of byte;
    txt:array[1..4] of byte;
    dt: DateTime;
    atf:longint;

procedure BegColors;
Begin
 bk[1]:=pal.bkdPoleNT; txt[1]:=pal.txtdPoleNT;
 bk[2]:=pal.bkdPoleNT; txt[2]:=pal.txtdPoleNT;
 bk[3]:=pal.bkdPoleNT; txt[3]:=pal.txtdPoleNT;
 bk[4]:=pal.bkdPoleNT; txt[4]:=pal.txtdPoleNT;
End;

procedure PrintAttrs;
begin
BegColors;
case c of
 0:
   begin
    gotoxy(25,halfmaxy-2);
   end;
 1:
   begin
    bk[1]:=pal.bkdPoleST; txt[1]:=pal.txtdPoleST;
    gotoxy(25,halfmaxy-2);
   end;
 2:
   begin
    bk[2]:=pal.bkdPoleST; txt[2]:=pal.txtdPoleST;
    gotoxy(25,halfmaxy-1);
   end;
 3:
   begin
    bk[3]:=pal.bkdPoleST; txt[3]:=pal.txtdPoleST;
    gotoxy(25,halfmaxy-0);
   end;
 4:
   begin
    bk[4]:=pal.bkdPoleST; txt[4]:=pal.txtdPoleST;
    gotoxy(25,halfmaxy+1);
   end;
end;
cmprint(bk[1],txt[1],24,halfmaxy-2,attrs[1]);
cmprint(bk[2],txt[2],24,halfmaxy-1,attrs[2]);
cmprint(bk[3],txt[3],24,halfmaxy-0,attrs[3]);
cmprint(bk[4],txt[4],24,halfmaxy+1,attrs[4]);
if ((pcdirFAttrOf(focus,IndexOf(focus)) and archive)<>0) then cmprint(bk[1],txt[1],25,halfmaxy-2,'X');
if ((pcdirFAttrOf(focus,IndexOf(focus)) and hidden)<>0)  then cmprint(bk[2],txt[2],25,halfmaxy-1,'X');
if ((pcdirFAttrOf(focus,IndexOf(focus)) and readonly)<>0)then cmprint(bk[3],txt[3],25,halfmaxy-0,'X');
if ((pcdirFAttrOf(focus,IndexOf(focus)) and sysfile)<>0) then cmprint(bk[4],txt[4],25,halfmaxy+1,'X');
end;

procedure PrintAttrs2;
begin
if setattrs[1] then attrs[1][2]:='X' else attrs[1][2]:=' ';
if setattrs[2] then attrs[2][2]:='X' else attrs[2][2]:=' ';
if setattrs[3] then attrs[3][2]:='X' else attrs[3][2]:=' ';
if setattrs[4] then attrs[4][2]:='X' else attrs[4][2]:=' ';
if unsetattrs[1] then attrs[1][8]:='X' else attrs[1][8]:=' ';
if unsetattrs[2] then attrs[2][8]:='X' else attrs[2][8]:=' ';
if unsetattrs[3] then attrs[3][8]:='X' else attrs[3][8]:=' ';
if unsetattrs[4] then attrs[4][8]:='X' else attrs[4][8]:=' ';
BegColors;
case c of
 0:
   begin
   end;
 1,5:
   begin
    bk[1]:=pal.bkdPoleST; txt[1]:=pal.txtdPoleST;
    if c=1 then gotoxy(22,halfmaxy-2) else gotoxy(28,halfmaxy-2);
   end;
 2,6:
   begin
    bk[2]:=pal.bkdPoleST; txt[2]:=pal.txtdPoleST;
    if c=2 then gotoxy(22,halfmaxy-1) else gotoxy(28,halfmaxy-1);
   end;
 3,7:
   begin
    bk[3]:=pal.bkdPoleST; txt[3]:=pal.txtdPoleST;
    if c=3 then gotoxy(22,halfmaxy-0) else gotoxy(28,halfmaxy-0);
   end;
 4,8:
   begin
    bk[4]:=pal.bkdPoleST; txt[4]:=pal.txtdPoleST;
    if c=4 then gotoxy(22,halfmaxy+1) else gotoxy(28,halfmaxy+1);
   end;
end;
cmprint(bk[1],txt[1],21,halfmaxy-2,attrs[1]); cmprint(pal.bkdRama,pal.txtdRama,25,halfmaxy-2,'│');
cmprint(bk[2],txt[2],21,halfmaxy-1,attrs[2]); cmprint(pal.bkdRama,pal.txtdRama,25,halfmaxy-1,'│');
cmprint(bk[3],txt[3],21,halfmaxy-0,attrs[3]); cmprint(pal.bkdRama,pal.txtdRama,25,halfmaxy-0,'│');
cmprint(bk[4],txt[4],21,halfmaxy+1,attrs[4]); cmprint(pal.bkdRama,pal.txtdRama,25,halfmaxy+1,'│');
end;

procedure Enter(index:word);
var
    stemp  :string[127];
    ft     :longint;
    fattr  :word;
    itemp  :byte;
begin
curoff;
{$I-}
stemp:=TrueNameOf(focus,index);
fattr:=pcdirFAttrOf(focus,index);
assign(fa,pcndOf(focus)+stemp);

UnpackTime(pcDirFdtOf(focus,index),dt);
if nospace(ftime[1]+ftime[2])<>'' then dt.hour:=vall(ftime[1]+ftime[2]);
if nospace(ftime[4]+ftime[5])<>'' then dt.min:=vall(ftime[4]+ftime[5]);
if nospace(ftime[7]+ftime[8])<>'' then dt.sec:=vall(ftime[7]+ftime[8]);
if nospace(fdate[1]+fdate[2])<>'' then dt.day:=vall(fdate[1]+fdate[2]);
if nospace(fdate[4]+fdate[5])<>'' then dt.month:=vall(fdate[4]+fdate[5]);
stemp:=strr(dt.year); stemp[3]:=fdate[7]; stemp[4]:=fdate[8];
if nospace(fdate[7]+fdate[8])<>'' then dt.year:=vall(stemp);

packtime(dt,ft);
if index>tdirsOf(focus) then
 begin
  filemode:=0;
  reset(fa);
  setftime(fa,ft);
  close(fa);
 end;

if index>tdirsOf(focus) then
 begin
  setfattr(fa,fattr);
 end
else
 begin
  setfattr(fa,fattr xor directory);{}
  setfattr(fa,fattr);
  setfattr(fa,fattr xor directory);{}
 end;
{$I+}
itemp:=ioresult; if itemp<>0 then;
end;

Begin
c:=0; for i:=1 to tdirsfilesOf(focus) do if pcdirMarkOf(focus,i) then inc(c);
if (TreeCOf(focus,pcndOf(focus))<>1)and(IndexOf(focus)=1)and(c=0) then exit;
CancelSB;
colour(pal.bkdRama,pal.txtdRama);

IF C=0 THEN
BEGIN
if lang=rus then
 begin
  attrs[1]:='[ ] Аpхивный       ';
  attrs[2]:='[ ] Cкpытый        ';
  attrs[3]:='[ ] Только-Чтение  ';
  attrs[4]:='[ ] Cиcтемный      ';
 end
else
 begin
  attrs[1]:='[ ] Archive        ';
  attrs[2]:='[ ] Hidden         ';
  attrs[3]:='[ ] Read-Only      ';
  attrs[4]:='[ ] System         ';
 end;
scputwin(pal.bkdRama,pal.txtdRama,19,halfmaxy-5,62,halfmaxy+5);
if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Атpибуты файла ')
            else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' File attributes ');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy-3,'┌─────────────────────┐');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy-2,'│                     │');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy-1,'│                     │');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy-0,'│                     │');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy+1,'│                     │');
cmprint(pal.bkdRama,pal.txtdRama,22,halfmaxy+2,'└─────────────────────┘');
if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-3,'Вpемя (Ч:М:C)')
            else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-3,'Time (H:M:S)');
UnpackTime(pcDirFdtOf(focus,IndexOf(focus)),dt);
ftime:=LZ(dt.hour)+':'+
       LZ(dt.min)+':'+
       LZ(dt.sec);
cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy-2,' '+ftime+space(6));
if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-0,'Дата (Д-М-Г)')
            else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-0,'Date (D-M-Y)');
fdate:=LZ(dt.day)+'-'+
       LZ(dt.month)+'-'+
       copy(LZ(dt.year),3,2);
cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy+1,' '+fdate+space(6));
colour(pal.bkdLabelNT,pal.txtdLabelNT);
cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+3,'    OK    ',true);
c:=1; curon;

loop:
PrintAttrs;
k:=keycode;
{case k of{}
if k=_ESC then goto fin;
if (k=_Up)or(k=_Left) then dec(c);
if (k=_Down)or(k=_Right) then inc(c);
if k= _Space then
        Begin
         atf:=pcDirFAttrOf(focus,IndexOf(focus));
         case c of
          1: atf:=atf xor archive;
          2: atf:=atf xor hidden;
          3: atf:=atf xor readonly;
          4: atf:=atf xor sysfile;
         end;
         Case focus of
          left: lp.pcdir^[IndexOf(left)].fattr:=atf;
          right:rp.pcdir^[IndexOf(right)].fattr:=atf;
         End;
        End;
if k= _Enter then begin Enter(IndexOf(focus)); goto fin; end;
if k= _Tab then
        begin
         lc:=c; c:=0; printattrs; xc:=1;
         if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,47,halfmaxy-3,'Вpемя (Ч:М:C)')
         else cmprint(pal.bkdLabelST,pal.txtdLabelST,47,halfmaxy-3,'Time (H:M:S)');
         loop2:
          cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy-2,' '+ftime+space(6));
          cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy+1,' '+fdate+space(6));
          gotoxy(47+xc-1,halfmaxy-2);
          k:=keycode;
          {case k of{}
           if (k=_num1)or(k=_num2)or(k=_num3)or(k=_num4)or(k=_num5)or(k=_num6)or(k=_num7)or(k=_num8)or(k=_num9)or(k=_num0) then
                 begin
                  if (xc=1)and(k in[lo(_num1),lo(_num2),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                  if (i in[lo(_num2)])and(ftime[2]>'3') then ftime[2]:='3';
                  i:=0;
                  if (xc=2)and(k in[lo(_num1)..lo(_num3),lo(_num0)])and(ftime[1]='2') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(ftime[1]='1') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(ftime[1]='0') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=4)and(k in[lo(_num1)..lo(_num5),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=5)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=7)and(k in[lo(_num1)..lo(_num5),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=8)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8;
                 end;
           if k=_ESC then goto fin;
           if k=_Left then begin dec(xc); if (xc=3)or(xc=6) then dec(xc); if xc<1 then xc:=1; end;
           if k=_Right then begin inc(xc); if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8; end;
           if k=_Enter then begin Enter(IndexOf(focus)); goto fin; end;
           if k=_Tab then
                 begin
                  c:=0; printattrs; xc:=1;
                  if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-3,'Вpемя (Ч:М:C)')
                  else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-3,'Time (H:M:S)');
                  if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,47,halfmaxy-0,'Дата (Д-М-Г)')
                  else cmprint(pal.bkdLabelST,pal.txtdLabelST,47,halfmaxy-0,'Date (D-M-Y)');
                  loop3:
                   cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy-2,' '+ftime+space(6));
                   cmprint(pal.bkdInputNT,pal.txtdInputNT,46,halfmaxy+1,' '+fdate+space(6));
                   gotoxy(47+xc-1,halfmaxy+1);
                   k:=keycode;
                   {case k of{}
                     if (k=_num1)or(k=_num2)or(k=_num3)or(k=_num4)or(k=_num5)or
                        (k=_num6)or(k=_num7)or(k=_num8)or(k=_num9)or(k=_num0) then
                      begin
                       if (xc=1)and(k in[lo(_num1)..lo(_num3),lo(_num0)]) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                       if (i in[lo(_num3)])and(fdate[2]>'1') then fdate[2]:='1';
                       i:=0;
                       if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(fdate[1] in['0','1'..'2']) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=2)and(k in[lo(_num1),lo(_num0)])and(fdate[1]='3') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=4)and(k in[lo(_num1),lo(_num0)]) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                       if (i in[lo(_num1)])and(fdate[5]>'2') then fdate[5]:='2';
                       i:=0;
                       if (xc=5)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(fdate[4]='0') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=5)and(k in[lo(_num1)..lo(_num2),lo(_num0)])and(fdate[4]='1') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=7)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=8)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8;
                      end;
                    if k=_ESC then goto fin;
                    if k=_Left then begin dec(xc); if (xc=3)or(xc=6) then dec(xc); if xc<1 then xc:=1; end;
                    if k=_Right then begin inc(xc); if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8; end;
                    if k=_Enter then begin Enter(IndexOf(focus)); goto fin; end;
                    if k=_Tab then
                          begin
                           if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-0,'Дата (Д-М-Г)')
                           else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,47,halfmaxy-0,'Date (D-M-Y)');
                           c:=lc;
                           goto loop;
                          end;
                   {end;{}
                  goto loop3;
                 end;
          {end;{}
         goto loop2;
        end;
{end;{}

if c<1 then c:=4;
if c>4 then c:=1;

goto loop;
END
ELSE
BEGIN
setattrs[1]:=true;
setattrs[2]:=false;
setattrs[3]:=false;
setattrs[4]:=false;
unsetattrs[1]:=false;
unsetattrs[2]:=true;
unsetattrs[3]:=true;
unsetattrs[4]:=true;

if lang=rus then
 begin
  attrs[1]:='[ ] │ [ ] Аpхивный     ';
  attrs[2]:='[ ] │ [ ] Cкpытый      ';
  attrs[3]:='[ ] │ [ ] Только-Чтение';
  attrs[4]:='[ ] │ [ ] Cиcтемный    ';
 end
else
 begin
  attrs[1]:='[ ] │ [ ] Archive      ';
  attrs[2]:='[ ] │ [ ] Hidden       ';
  attrs[3]:='[ ] │ [ ] Read-Only    ';
  attrs[4]:='[ ] │ [ ] System       ';
 end;
scputwin(pal.bkdRama,pal.txtdRama,16,halfmaxy-5,64,halfmaxy+5);
if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Атpибуты файлов ')
            else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Files attributes ');
if lang=rus then cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy-3,'┌ Уcт ┬ Cнять ─────────────┐')
            else cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy-3,'┌ Set ┬ Unset ─────────────┐');
cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy-2,'│     │                    │');
cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy-1,'│     │                    │');
cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy-0,'│     │                    │');
cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy+1,'│     │                    │');
cmprint(pal.bkdRama,pal.txtdRama,19,halfmaxy+2,'└─────┴────────────────────┘');

if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-3,'Вpемя (Ч:М:C)')
            else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-3,'Time (H:M:S)');
ftime:='  '+':'+'  '+':'+'  ';
cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy-2,' '+ftime+space(6));

if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-0,'Дата (Д-М-Г)')
            else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-0,'Date (D-M-Y)');
fdate:='  '+'-'+'  '+'-'+'  ';
cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy+1,' '+fdate+space(6));

colour(pal.bkdLabelNT,pal.txtdLabelNT);
cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+3,'    OK    ',true);

c:=1; curon;
loop4:
PrintAttrs2;

k:=keycode;
{case k of{}
if k= _ESC then goto fin;
if k= _Down then inc(c);
if k= _Up then dec(c);
if k= _Left then if c>4 then dec(c,4);
if k= _Right then if c<5 then inc(c,4);
if k= _Space then
        begin
         if c in[1..4] then begin setattrs[c]:=not setattrs[c]; if unsetattrs[c] then unsetattrs[c]:=false; end;
         if c in[5..8] then begin unsetattrs[c-4]:=not unsetattrs[c-4]; if setattrs[c-4] then setattrs[c-4]:=false; end;
        end;
if k= _Enter then
        begin
         for i:=1 to tdirsfilesOf(focus) do
          begin
           if pcdirMarkOf(focus,i) then
            begin
             atf:=pcDirFAttrOf(focus,i);
             if setattrs[1] then if ((atf and archive)<>0) then else atf:=atf xor archive;
             if setattrs[2] then if ((atf and hidden)<>0) then else atf:=atf xor hidden;
             if setattrs[3] then if ((atf and readonly)<>0) then else atf:=atf xor readonly;
             if setattrs[4] then if ((atf and sysfile)<>0) then else atf:=atf xor sysfile;
             {}
             if unsetattrs[1] then if ((atf and archive)<>0) then atf:=atf xor archive;
             if unsetattrs[2] then if ((atf and hidden)<>0) then atf:=atf xor hidden;
             if unsetattrs[3] then if ((atf and readonly)<>0) then atf:=atf xor readonly;
             if unsetattrs[4] then if ((atf and sysfile)<>0) then atf:=atf xor sysfile;
             {}
             Case focus of
              left:  lp.pcDir^[i].fattr:=atf;
              right: rp.pcDir^[i].fattr:=atf;
             End;
             Enter(i);
            end;
           Case focus of
            left:  lp.pcdir^[i].mark:=false;
            right: rp.pcdir^[i].mark:=false;
           End;
          end;
         goto fin;
        end;

if k= _Tab then
        begin
         lc:=c; c:=0; printattrs2; xc:=1;
         if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,49,halfmaxy-3,'Вpемя (Ч:М:C)')
         else cmprint(pal.bkdLabelST,pal.txtdLabelST,49,halfmaxy-3,'Time (H:M:S)');
         loop5:
          cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy-2,' '+ftime+space(6));
          cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy+1,' '+fdate+space(6));
          gotoxy(49+xc-1,halfmaxy-2);
          k:=keycode;
          {case k of{}
          if (k=_num1)or(k=_num2)or(k=_num3)or(k=_num4)or(k=_num5)or
          (k=_num6)or(k=_num7)or(k=_num8)or(k=_num9)or(k=_num0) then
                 begin
                  if (xc=1)and(k in[lo(_num1),lo(_num2),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                  if (i in[lo(_num2)])and(ftime[2]>'3') then ftime[2]:='3';
                  i:=0;
                  if (xc=2)and(k in[lo(_num1)..lo(_num3),lo(_num0)])and(ftime[1]='2') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(ftime[1]='1') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(ftime[1]='0') then
                   begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=4)and(k in[lo(_num1)..lo(_num5),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=5)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=7)and(k in[lo(_num1)..lo(_num5),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=8)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin ftime[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                  if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8;
                 end;
           if k=_ESC then goto fin;
           if k=_Left then begin dec(xc); if (xc=3)or(xc=6) then dec(xc); if xc<1 then xc:=1; end;
           if k=_Right then begin inc(xc); if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8; end;
           if k=_Tab then
                 begin
                  c:=0; printattrs2; xc:=1;
                  if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-3,'Вpемя (Ч:М:C)')
                  else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-3,'Time (H:M:S)');
                  if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,49,halfmaxy-0,'Дата (Д-М-Г)')
                  else cmprint(pal.bkdLabelST,pal.txtdLabelST,49,halfmaxy-0,'Date (D-M-Y)');
                  loop6:
                   cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy-2,' '+ftime+space(6));
                   cmprint(pal.bkdInputNT,pal.txtdInputNT,48,halfmaxy+1,' '+fdate+space(6));
                   gotoxy(49+xc-1,halfmaxy+1);
                   k:=keycode;
                   {case k of{}
                    if (k=_num1)or(k=_num2)or(k=_num3)or(k=_num4)or(k=_num5)or
                    (k=_num6)or(k=_num7)or(k=_num8)or(k=_num9)or(k=_num0) then
                      begin
                       if (xc=1)and(k in[lo(_num1)..lo(_num3),lo(_num0)]) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                       if (i in[lo(_num3)])and(fdate[2]>'1') then fdate[2]:='1';
                       i:=0;
                       if (xc=2)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(fdate[1] in['0','1'..'2']) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=2)and(k in[lo(_num1),lo(_num0)])and(fdate[1]='3') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=4)and(k in[lo(_num1),lo(_num0)]) then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); i:=k; k:=0; end;
                       if (i in[lo(_num1)])and(fdate[5]>'2') then fdate[5]:='2';
                       i:=0;
                       if (xc=5)and(k in[lo(_num1)..lo(_num9),lo(_num0)])and(fdate[4]='0') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=5)and(k in[lo(_num1)..lo(_num2),lo(_num0)])and(fdate[4]='1') then
                         begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=7)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=8)and(k in[lo(_num1)..lo(_num9),lo(_num0)]) then begin fdate[xc]:=chr(lo(k)); inc(xc); k:=0; end;
                       if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8;
                      end;
                    if k=_ESC then goto fin;
                    if k=_Left then begin dec(xc); if (xc=3)or(xc=6) then dec(xc); if xc<1 then xc:=1; end;
                    if k=_Right then begin inc(xc); if (xc=3)or(xc=6) then inc(xc); if xc>8 then xc:=8; end;
                    if k=_Tab then
                          begin
                           if lang=rus then cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-0,'Дата (Д-М-Г)')
                           else cmprint(pal.bkdLabelNT,pal.txtdLabelNT,49,halfmaxy-0,'Date (D-M-Y)');
                           c:=lc;
                           goto loop4;
                          end;
                   {end;{}
                  goto loop6;
                 end;
          {end;{}
         goto loop5;
        end;
{end;{}
if c<1 then c:=8;
if c>8 then c:=1;
goto loop4;
END;
fin:
CurOff; RestScr;
reMDF;
lp.TrueCur; lp.Inside;
rp.TrueCur; rp.Inside;
reInfo('cdsfi');
rePDF;
End;


{============================================================================}
procedure pcEditFile(nm:string);
var
    stemp:string; p:TPanel; i:byte;
begin
case focus of left:p:=lp; right:p:=rp; end;
if p.index<=p.pctdirs then exit;
getprofile(startdir+'\sn.ini','Edit','Default',stemp);
for i:=1 to length(stemp) do if stemp[i]<>'*' then command:=command+stemp[i] else command:=command+nm;
putcmdline;
DoExec(command,false);
end;


{----------------------------------------------------------------------------}
function whatbyext(fname,sname:string):string;
var
    ft:text;
    i,m,k,l:word;
    cm,s:string;
    aaa:comstr;
    ext:string;

begin
{$I-}
cm:='';
ext:=nospace(copy(getof(fname,_ext),2,3));
if ext='' then ext:='.';
assign(ft,startdir+'\sn.ini'); filemode:=0; reset(ft);
s:=''; while (nospace(s)<>'['+sname+']') do
 begin
  readln(ft,s);
  if EOF(ft) then break;
 end;
s:=strlo(s); ext:=strlo(ext);

readln(ft,s);
while s[1]<>'[' do
 begin
  m:=pos(ext+',',s); if m=0 then m:=pos(ext+':',s);

  if m<>0 then if nospaceLR(s[1])<>';' then
   begin
    cm:=copy(s,pos(':',s)+1,255);
    break;
   end;

  readln(ft,s);
  if EOF(ft) then break;
 end;
close(ft);
{$I+}
if ioresult<>0 then;
aaa:='';
for i:=1 to length(cm) do
  if cm[i]='*' then aaa:=aaa+fname else aaa:=aaa+cm[i];

if nospace(aaa)<>'' then whatbyext:=aaa else whatbyext:='';
end;
{----------------------------------------------------------------------------}



{----------------------------------------------------------------------------}
function whatbylen(leng,fname,sname:string; change:boolean):string;
var
    ft:text;
    i,m,k,l:word;
    cm,s:string;
    aaa:comstr;
    ext:string;

begin
{$I-}
cm:='';
ext:=leng;
assign(ft,startdir+'\sn.ini'); filemode:=0; reset(ft);
s:=''; while (nospace(s)<>'['+sname+']') do
 begin
  readln(ft,s);
  if EOF(ft) then break;
 end;
s:=strlo(s); ext:=strlo(ext);

readln(ft,s);
while s[1]<>'[' do
 begin
  m:=pos(ext+',',s); if m=0 then m:=pos(ext+':',s);

  if m<>0 then if nospaceLR(s[1])<>';' then
   begin
    cm:=copy(s,pos(':',s)+1,255);
    break;
   end;

  readln(ft,s);
  if EOF(ft) then break;
 end;
close(ft);
{$I+}
if ioresult<>0 then;
aaa:='';
for i:=1 to length(cm) do
  if cm[i]='*' then if change then aaa:=aaa+fname else aaa:=aaa+cm[i]
               else aaa:=aaa+cm[i];

if nospace(aaa)<>'' then whatbylen:=aaa else whatbylen:='';
end;
{----------------------------------------------------------------------------}


{============================================================================}
function  reBuildName(str,n:string):string;
var i:byte; s:string;
Begin
s:='';
for i:=1 to length(str) do if str[i]<>'*' then s:=s+str[i] else s:=s+n;
reBuildName:=s;
End;



{----------------------------------------------------------------------------}
function CheckExt(var s:string):boolean;
var i:byte; stemp,t:string;
begin
CheckExt:=false;
if pos('@HobetaBasic',s)<>0 then
 begin
  getprofile(startdir+'\sn.ini','View','HobetaBasic',stemp);
  if pos('!',stemp)<>0 then begin delete(stemp,pos('!',stemp),1); CheckExt:=true; end;
  s:=startdir+'\TOOLS\'+stemp;
 end;
if pos('@HobetaCode',s)<>0 then
 begin
  getprofile(startdir+'\sn.ini','View','HobetaCode',stemp);
  if pos('!',stemp)<>0 then begin delete(stemp,pos('!',stemp),1); CheckExt:=true; end;
  s:=startdir+'\TOOLS\'+stemp;
 end;
if pos('@HobetaScreen',s)<>0 then
 begin
  getprofile(startdir+'\sn.ini','View','HobetaScreen',stemp);
  if pos('!',stemp)<>0 then begin delete(stemp,pos('!',stemp),1); CheckExt:=true; end;
  s:=startdir+'\TOOLS\'+stemp;
 end;
if pos('@HobetaTrueScreen',s)<>0 then
 begin
  getprofile(startdir+'\sn.ini','View','HobetaTrueScreen',stemp);
  if pos('!',stemp)<>0 then begin delete(stemp,pos('!',stemp),1); CheckExt:=true; end;
  s:=startdir+'\TOOLS\'+stemp;
 end;
t:=copy(s,2+length(GetOf(s,_dir)),255);
if pos('!',t)<>0 then begin delete(s,pos('!',s),1); s:=GetOf(t,_dir)+'\'+s; CheckExt:=true; end;
end;
{----------------------------------------------------------------------------}


function ExecuteView(comm:string):boolean;
var p:tpanel; done:boolean;
Begin
ExecuteView:=false;
if nospace(comm)<>'' then
 begin
  command:=comm;
  if pos('internal',strlo(command))=0 then DoExec(command,false) else
   begin
    if focus=left then p:=lp else p:=rp;
    if (p.pcDir^[p.Index].flength=18432)or(p.pcDir^[p.Index].flength=18432+17)
    then xpcView(p.pcnd+p.TrueName(p.Index),strlo(p.TrueName(p.Index)))
    else scrView(p.pcnd+p.TrueName(p.Index),strlo(p.TrueName(p.Index)));
    ExecuteView:=true;
    command:='';

    GlobalRedraw;
   end;
 end;
End;

{============================================================================}
Procedure pcViewFile(nm:string);
type tbuf=array[1..2] of byte;
Var stemp:string; p:TPanel; nr,nw,a,t:word; fs,fd:file; buf:^tbuf;
{----------------------------------------------------------------------------}
procedure SaveFile2View;
Begin
    {$I-}
    assign(fs,p.pcnd+p.TrueName(p.Index)); assign(fd,tempdir+getof(startnum,_name)+'.tmp');
    filemode:=0; reset(fs,1);
    filemode:=2; rewrite(fd,1);
    getmem(buf,filesize(fs)-17); seek(fs,17);
    blockread(fs,buf^,filesize(fs)-17,nr);
    blockwrite(fd,buf^,nr,nw);
    FreeMem(buf,filesize(fs)-17);
    close(fs); close(fd);
    {$I+}
    if ioresult<>0 then;
End;
{----------------------------------------------------------------------------}

Begin
case focus of left:p:=lp; right:p:=rp; end;
command:='';

if AltF3Pressed then
 Begin
  getprofile(startdir+'\sn.ini','View','Default',stemp);
  command:=reBuildName(stemp,nm);
  DoExec(command,false);
 End;

stemp:=whatbyext(nm,'ViewByExtention');
CheckExt(stemp);
if nospace(reBuildName(stemp,nm))<>'' then
 if ExecuteView(reBuildName(stemp,nm)) then exit;

stemp:=whatbylen(strr(p.pcDir^[p.Index].flength),nm,'ViewByLength',true);
CheckExt(stemp);
if nospace(reBuildName(stemp,nm))<>'' then
 if ExecuteView(reBuildName(stemp,nm)) then exit;


if itHobeta(nm,HobetaInfo) then
 Begin
  getprofile(startdir+'\sn.ini','View',hiTRDOSe3,stemp);
  if nospace(stemp)<>'' then if CheckExt(stemp) then
   begin
    stemp:=reBuildName(stemp,nm);
    if ExecuteView(stemp) then exit;
   end
  else
   begin
    stemp:=reBuildName(stemp,tempdir+getof(startnum,_name)+'.tmp');
    SaveFile2View;
    if ExecuteView(stemp) then exit;
   end;

  stemp:=whatbylen(strr(HobetaInfo.length),nm,'ViewByLength',false);
  if nospace(stemp)<>'' then if CheckExt(stemp) then
   begin
    stemp:=reBuildName(stemp,nm);
    if ExecuteView(stemp) then exit;
   end
  else
   begin
    stemp:=reBuildName(stemp,tempdir+getof(startnum,_name)+'.tmp');
    SaveFile2View;
    if ExecuteView(stemp) then exit;
   end;

  if HobetaInfo.Typ='B' then
   Begin
    getprofile(startdir+'\sn.ini','View','HobetaBasic',stemp);
    if nospace(stemp)<>'' then
     begin
      if pos('!',stemp)<>0 then
       begin
        delete(stemp,pos('!',stemp),1);
        stemp:=startdir+'\TOOLS\'+stemp;
        stemp:=reBuildName(stemp,p.TrueName(p.Index));
        if ExecuteView(stemp) then exit;
       end
      else
       begin
        delete(stemp,pos('!',stemp),1);
        stemp:=startdir+'\TOOLS\'+stemp;
        stemp:=reBuildName(stemp,tempdir+getof(startnum,_name)+'.tmp');
        SaveFile2View;
        if ExecuteView(stemp) then exit;
       end;
     end;
   End;
 End;

getprofile(startdir+'\sn.ini','View','Default',stemp);
command:=reBuildName(stemp,nm);
DoExec(command,false);
End;




{============================================================================}
Function  hobLoad(name:string):boolean;
Var
   f:file; i1,i2:byte;
Begin
hobLoad:=false;
if ItHobeta(name,HobetaInfo) then
 begin
  {$I-}
  GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);
  Assign(f,name); filemode:=0; reset(f,1); seek(f,17);
  i1:=IOResult;
  BlockRead(f,HobetaInfo.body^,256*HobetaInfo.totalsec);
  if IOResult=0 then;
  Close(f);
  i2:=IOResult;
  {$I+}
  if (i1=0)and(i2=0) then hobLoad:=true;
 end;
End;



{============================================================================}
Function  hobSave(path:string; AltF5flag:boolean):boolean;
Var
   f:file;
   buf:array[1..17] of byte;
   tc,m:word;
   stemp:string;
Begin
hobSave:=false;

for tc:=1 to 8 do buf[tc]:=ord(HobetaInfo.name[tc]);
buf[9]:=ord(HobetaInfo.typ);
m:=HobetaInfo.start; buf[10]:=lo(m); buf[11]:=hi(m);
m:=HobetaInfo.length; buf[12]:=lo(m); buf[13]:=hi(m);
buf[14]:=0; buf[15]:=HobetaInfo.totalsec;
m:=0; for tc:=1 to 15 do m:=m+257*buf[tc]+(tc-1);
buf[16]:=lo(m); buf[17]:=hi(m);

stemp:=strlo(hob2pc(HobetaInfo.name));
if nospace(stemp)='' then stemp:='________';
if TRDOS3 and altF5flag then
 begin
  stemp:=stemp+'.'+HobetaInfo.typ+chr(lo(HobetaInfo.start))+chr(hi(HobetaInfo.start));
 end
else
 begin
  stemp:=stemp+'.$';
  if HobetaInfo.typ=' ' then stemp:=stemp+'_' else stemp:=stemp+hob2pc(HobetaInfo.typ);
  if altF5flag then stemp:=stemp+'!';
 end;

 stemp:=CheckEx(path,stemp);

{$I-}
Assign(f,path+stemp); filemode:=2; rewrite(f,1);
if not AltF5flag then BlockWrite(f,buf,17);
if not AltF5flag then BlockWrite(f,HobetaInfo.body^,256*HobetaInfo.totalsec)
                 else if HobetaInfo.typ='B' then BlockWrite(f,HobetaInfo.body^,HobetaInfo.length+4)
                                            else BlockWrite(f,HobetaInfo.body^,HobetaInfo.length);
Close(f);
FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
{$I+}
if ioresult=0 then hobSave:=true;
End;





{============================================================================}
procedure MakeImages(var p:TPanel);
Var i:byte;
Begin
if lang=rus then
 begin
  menu_Name[1]:='~`TRD~`  - Стандартный образ диска';
  menu_Name[2]:='~`FDI~`  - Full Disk Image (UKV)';
  menu_Name[3]:='~`FDD~`  - для Scorpion256 by MOA';
  menu_Name[4]:='~`SCL~`  - Hobeta98 (AMD Copier)';
  menu_Name[5]:='~`TAP~`  - Образ магнитной ленты';
  Menu_Name[6]:='~`LOAD~` - Загрузить TR-DOS дискету в файл';
  Menu_Name[7]:='~`SAVE~` - Запиcать файл на TR-DOS диcкету';
 end
else
 begin
  menu_Name[1]:='~`TRD~`  - Standart TR-DOS Image';
  menu_Name[2]:='~`FDI~`  - Full Disk Image (UKV)';
  menu_Name[3]:='~`FDD~`  - for Scorpion256 by MOA';
  menu_Name[4]:='~`SCL~`  - Hobeta98 (AMD Copier)';
  menu_Name[5]:='~`TAP~`  - Tape Image';
  Menu_Name[6]:='~`LOAD~` - Load TR-DOS disk to file';
  Menu_Name[7]:='~`SAVE~` - Save file to TR-DOS disk';
 end;
CancelSB;
menu_Total:=6;
if (isTRD(pcndOf(focus)+TrueNameOf(focus,IndexOf(focus))))or
   (isFDI(p,pcndOf(focus)+TrueNameOf(focus,IndexOf(focus))))or
   (isFDD(pcndOf(focus)+TrueNameOf(focus,IndexOf(focus))))
   then menu_Total:=7;

menu_f:=1; menu_title:=''; menu_visible:=255;
w_twosided:=false;
i:=ChooseItem;
w_twosided:=true;
Case i of
 1: trdMakeImage(p,false);
 2: fdiMakeImage(p,false);
 3: fddMakeImage(p,false);
 4: sclMakeImage(false);
 5: tapMakeImage;
 6: Load_TRDOS;
 7: Save_TRDOS;
End;
reMDF;
p.truecur;
p.inside;
reInfo('cbdnsfi');
rePDF;
End;



{============================================================================}
procedure pcAltH(var p:TPanel);
var s:string; i,c:integer; k:char;
begin
if p.pctfiles=0 then exit;
 CancelSB;
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,29,halfmaxy-4,52,halfmaxy+3);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Хобетные файлы ')
             else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Hobeta files ');
 if lang=rus then cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-2,'Найдено файлов')
             else cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-2,'Found files');
 colour(pal.bkdLabelNT,pal.txtdLabelNT);
 if lang=rus then cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,
                          36,halfmaxy+1,'   Стоп   ',true)
             else cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,
                          36,halfmaxy+1,'   Stop   ',true);

c:=0;
for i:=p.pctdirs+1 to p.pctdirs+p.pctfiles do
 begin
  s:=p.pcnd+p.pcdir^[i].fname+'.'+p.pcdir^[i].fext;
  if ithobeta(s,hobetainfo) then begin p.pcdir^[i].mark:=true; inc(c); end else p.pcdir^[i].mark:=false;
  if lang=rus then cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,strr(c)+' из '+strr(i-p.pctdirs))
              else cmcentre(pal.bkdLabelNT,pal.txtdLabelNT,halfmaxy-1,strr(c)+' of '+strr(i-p.pctdirs));
  if keypressed then begin k:=readkey; if (k=#27)or(k=#13) then break; end;
 end;

cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+1,'    OK    ',true);
waitkey; restscr;
p.Info('cbdnsfi');
p.pcPDF(rp.pcfrom);
end;









End.