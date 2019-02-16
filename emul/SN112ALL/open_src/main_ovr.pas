{$O+,F+}
Unit Main_Ovr;
Interface
Uses sn_Obj;

Procedure snDone(sys:boolean);

Procedure About;
Procedure AltF10Pressed;
Procedure CtrlF10Pressed;
Procedure CtrlKPressed(var p:TPanel);
Procedure CtrlNPressed;
Procedure CtrlF1Pressed;
Procedure CtrlF2Pressed;
Procedure CtrlLPressed;
Procedure CtrlBPressed(x,y:byte);

function  CQuestion (quest:string; lan:byte):boolean;
Procedure PutSmallWindow(ts:string; bs:string);

function  GetWildMask(tit,curentmask:string):string;

Procedure SaveDesktop(fn:string);
Procedure LoadDesktop(fn:string);
Procedure ViewHistoryCommands;
Procedure HistoryCommand;
Procedure DoExec(CmdStr:string; look:boolean);


{Procedure CtrlUPressed;{}

Procedure LocalFind;
Procedure GlobalFind;

Implementation
Uses
     crc32c,Crt, Dos, RV, Inyan, Clock, Mouse,
     Vars, Main, sn_Mem, Palette, Utils,
     PC, TRD;


{============================================================================}
Procedure snDone(sys:boolean);
Var PT:byte;
Begin
if SaveOnExit then
 begin
{$I-}
  WriteProfile(startdir+'\sn.ini','System','ASCn',strr(ASCln));
  WriteProfile(startdir+'\sn.ini','Interface','LColumns',strr(lp.Columns));
  WriteProfile(startdir+'\sn.ini','Interface','RColumns',strr(rp.Columns));
{$I+}
 end;

if Clocked then ClockExitProc;
if not sys then
 Begin
  TextAttr:=SavedAttr; RestCur; RestBkDesk; FreeMemPCDirs; MemDeskDone;
  CurOn;
  {ChDir(StartDir);{}
  Halt(0);
 End;
End;



{============================================================================}
procedure About;
var y:byte;
begin
CurOff; Colour(7,15); if Moused then MouseOff; y:=halfmaxy;
sPutWin(10,y-9,70,y+9);
cmCentre(7,15,y-8,'ZX Spectrum Navigator');
cmCentre(7,15,y-7,'Version '+ver+'');
cmCentre(7,15,y-6,'Copyright (c) 1997-99 RomanRoms Software Co.');
if lang=rus then cmCentre(7,15,y-5,'Россия. Нижний Новгород.')
            else cmCentre(7,15,y-5,'Russia. Nizhny Novgorod.');

if lang=rus then cmCentre(7,15,y-4,'Copyright (c) 1998,99 Mihal Soft°')
            else cmCentre(7,15,y-4,'Copyright (c) 1998,99 Mihal Soft°');

if lang=rus then cmCentre(7,15,y-3,'Татаpcтан. Нижнекамск.')
            else cmCentre(7,15,y-3,'Tatarstan. Nizhnekamsk.');



if lang=rus then cmCentre(7,0,y+2,'- у Вас есть ZX Spectrum?')
            else cmCentre(7,0,y+2,'- Do you have ZX Spectrum?');
if lang=rus then cmCentre(7,0,y+3,'- у Вас есть адрес в сети FIDOnet?')
            else cmCentre(7,0,y+3,'- Do you have node in the FIDOnet?');
if lang=rus then cmCentre(7,0,y+4,'- Вы подписаны на эху ZX.SPECTRUM?')
            else cmCentre(7,0,y+4,'- Do you receive echomail ZX.SPECTRUM?');
if lang=rus then cmCentre(7,0,y+6,'Тогда Вы являетесь')
            else cmCentre(7,0,y+6,'So you are legal user of this programm.');
if lang=rus then cmCentre(7,15,y+7,'легальным пользователем')
            else cmCentre(7,15,y+7,'────────────────');
if lang=rus then cmCentre(7,0,y+8,'этой программы.')
            else cmCentre(7,0,y+8,'Powered by Borland Pascal 7.01');
{
cmCentre(7,15,y-3, '     ');
cmCentre(7,15,y-2,'     ');
cmCentre(7,15,y-1,'     ');
{}
if gMaxY<=30 then if Clocked then ClockExitProc;
if gMaxY<=30 then InyanOn(38,y-2);{}
if Moused then MouseOn;
rPause;
if gMaxY<=30 then InyanOff;{}
if gMaxY<=30 then if Clocked then Initialise;
RestScr;
PutCmdLine;
end;



{============================================================================}
Procedure AltF10Pressed;
begin
if Moused then MouseOff;
if gmaxy=30 then set80x25 else set80x30; curoff; flash(off);
GlobalRedraw;
SetMouseRange(1,1,gmaxx*8-1,gmaxy*8-1);
if Moused then MouseOn;
end;



{============================================================================}
Procedure CtrlF10Pressed;
begin
if Moused then MouseOff;
if gmaxy=25 then set80x50 else set80x25; curoff; flash(off);
GlobalRedraw;
SetMouseRange(1,1,gmaxx*8-1,gmaxy*8-1);
if Moused then MouseOn;
end;



{============================================================================}
Procedure CtrlKPressed(var p:TPanel);
Begin
if p.Columns<>1 then
 Begin
  p.clLastPanelType:=p.Columns;
  p.Columns:=1;
  p.Build('12');
  p.Info('A');
 End
else
 Begin
  p.Columns:=p.clLastPanelType;
  if p.Columns=0 then p.Columns:=3;
  p.Build('12');
  p.Info('A');
 End;
End;



{============================================================================}
Procedure CtrlNPressed;
Label fin;
begin
{
if PanelType[focus]=noPanel then exit;
if nLine[focus,PanelType[focus]]=3 then begin nLine[focus,PanelType[focus]]:=2; goto fin; end;
if nLine[focus,PanelType[focus]]=2 then begin nLine[focus,PanelType[focus]]:=3; goto fin; end;
fin:
Build(focus,'12');
{}
end;



{============================================================================}
Procedure CtrlF1Pressed;
Begin
if lp.PanelType=noPanel then
 Begin
  lp.PanelType:=lp.LastPanelType;
  lp.Build('012');
  reInfo('cbdnsfi');
  lp.pcPDF(lp.pcfrom);
  rePDF;
  snKernelExitCode:=11;
 End
else
 Begin
  lp.LastPanelType:=lp.PanelType;
  lp.PanelType:=noPanel;
  lp.Hide;
  snKernelExitCode:=10;
 End;
End;



{============================================================================}
Procedure CtrlF2Pressed;
Begin
if rp.PanelType=noPanel then
 Begin
  rp.PanelType:=rp.LastPanelType;
  rp.Build('012');
  reInfo('cbdnsfi');
  rePDF;
  snKernelExitCode:=21;
 End
else
 Begin
  rp.LastPanelType:=rp.PanelType;
  rp.PanelType:=noPanel;
  rp.Hide;
  snKernelExitCode:=20;
 End;
End;





{============================================================================}
Procedure CtrlLPressed;
Begin
Case focus of
 left:
   BEGIN
    if rp.PanelType<>noPanel then if rp.PanelType<>infPanel then
     Begin
      rp.clLastPanelType:=rp.PanelType;
      rp.PanelType:=infPanel;
      rp.Build('0');
      rp.Info('ci');
      Case lp.PanelType of
       pcPanel:
         BEGIN
          pcInfoPanel(left);
         END;
      End;
     End
    else
     Begin
      rp.PanelType:=rp.clLastPanelType;
      if (rp.Paneltype>=1)and(rp.Paneltype<=10) then rp.Build('012');
      reInfo('cbdnsfi');
      rePDF;
      snKernelExitCode:=21;
     End;
   END;
 right:
   BEGIN
    if lp.PanelType<>noPanel then if lp.PanelType<>infPanel then
     Begin
      lp.clLastPanelType:=lp.PanelType;
      lp.PanelType:=infPanel;
      lp.Build('0');
      lp.Info('ci');

      Case rp.PanelType of
       pcPanel:
         BEGIN
          pcInfoPanel(right);
         END;
      End;
     End
    else
     Begin
      lp.PanelType:=lp.clLastPanelType;
      if (lp.Paneltype>=1)and(lp.Paneltype<=10) then lp.Build('012');
      reInfo('cbdnsfi');
      rePDF;
      snKernelExitCode:=21;
     End;
   END;
End;
End;




{============================================================================}
Procedure CtrlBPressed(x,y:byte);
Var
   k:char; n:byte;
Begin
if ASCIITable(x,y,lang,ASCln,k,n) then command:=command+k;
ASCln:=n;
End;







{============================================================================}
{== COLOR QESTION ===========================================================}
{============================================================================}
function  CQuestion (quest:string; lan:byte):boolean;
var
   k:char;
   cm,m,a,b:integer;
   x1,x2,dx:byte;
   yes,no,s:string;
label l;
begin
CurOff;
if lan=rus then
 begin yes:='   Да   '; no:= '  Нет   '; end
else
 begin yes:='  Yes   '; no:= '   No   '; end;
cm:=halfmaxy;
if length(quest)<5 then dx:=5 else dx:=0;
x1:=halfmaxx-20;
x2:=halfmaxx+21;
if Moused then MouseOff;
Colour(pal.bkdRama,pal.txtdRama); sPutWin(x1,cm-4,x2,cm+3);
if lan=rus then
cmcentre(pal.bkdRama,pal.txtdRama,cm-4,' Подтвеpждение ')
else cmcentre(pal.bkdRama,pal.txtdRama,cm-4,' Confirmation ');

if length(quest)<>length(without(quest,#255)) then
 begin
  CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,cm-2,copy(quest,1,pos(#255,quest)));
  CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,cm-1,copy(quest,pos(#255,quest)+1,255));
 end
else
 CStatusLineColor(pal.bkdStatic,pal.txtdStatic,pal.txtdStatic,cm-2,quest);

colour(pal.bkdRama,0);
m:=1;
{if Moused then MouseOn;{}

l:
 if m=1 then
  begin
   cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,halfmaxx-9,cm+1,yes,true);
   cbutton(pal.bkdButtonNA,pal.txtdButtonNA,pal.bkdButtonShadow,pal.txtdButtonShadow,halfmaxx+3,cm+1,no,false);
  end
 else
  begin
   cbutton(pal.bkdButtonNA,pal.txtdButtonNA,pal.bkdButtonShadow,pal.txtdButtonShadow,halfmaxx-9,cm+1,yes,false);
   cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,halfmaxx+3,cm+1,no,true);
  end;
if moused then MouseOn;
 k:=ReadKey;
 if k=#27 then begin CQuestion:=false; RestScr; Exit; end;
 if k=#13 then begin if m=0 then CQuestion:=false else CQuestion:=true; RestScr; Exit; end;
 if k=#0 then
  begin
   k:=ReadKey;
   if k=#77 then m:=0;
   if k=#75 then m:=1;
  end;
if moused then MouseOff;
goto l;
end;





{============================================================================}
function GetWildMask(tit,curentmask:string):string;
var newmask:string;
begin
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,29,halfmaxy-4,52,halfmaxy+3);
 cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,tit);
 colour(pal.bkdLabelNT,pal.txtdLabelNT);
 cmprint(pal.bkdInputNT,pal.txtdInputNT,32,halfmaxy-1,space(18));

 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,33,halfmaxy-2,'Маcка')
             else cmprint(pal.bkdLabelST,pal.txtdLabelST,33,halfmaxy-2,'Mask');
 cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+1,'    OK    ',true);

 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon;
 newmask:=scanf(32,halfmaxy-1,curentmask,18,18,pos('.',CurentMask)+1);
 curoff;
 restscr;
 if scanf_esc then GetWildMask:=curentmask else GetWildMask:=newmask;

end;


{============================================================================}
Procedure PutSmallWindow(ts:string; bs:string);
Begin
Colour(pal.bkdRama,pal.txtdRama);
scPutWin(pal.bkdRama,pal.txtdRama,29,halfmaxy-4,52,halfmaxy+3);
cmCentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,ts);
Colour(pal.bkdLabelNT,pal.txtdLabelNT);
cButton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+1,bs,true)
End;





{============================================================================}
Procedure SaveDesktop(fn:string);
Var
    s:string; b:byte; i:integer;
    ff:file; buf:array[1..3072] of byte;
procedure Add2BufStr(ind:word; str:string);
var w:word;
begin
for w:=1 to length(str) do buf[ind+w-1]:=ord(str[w]);
end;

Begin
for i:=1 to 1024 do buf[i]:=0;
Add2BufStr(1,'SN Desktop');
buf[11]:=lp.Columns; buf[12]:=rp.Columns;
buf[13]:=lp.InfoLines; buf[14]:=rp.InfoLines;
if lp.NameLine then buf[15]:=1 else buf[15]:=0;
if rp.NameLine then buf[16]:=1 else buf[16]:=0;
s:=lp.pcnn+space(12-length(lp.pcnn)); Add2BufStr(17,s);
s:=rp.pcnn+space(12-length(rp.pcnn)); Add2BufStr(29,s);
s:=lp.pcnd+space(128-length(lp.pcnd)); Add2BufStr(41,s);
s:=rp.pcnd+space(128-length(rp.pcnd)); Add2BufStr(169,s);
buf[297]:=lp.PanelType; buf[298]:=rp.PanelType;
buf[299]:=lp.LastPanelType; buf[300]:=rp.LastPanelType;
buf[301]:=lp.clLastPanelType; buf[302]:=rp.clLastPanelType;
buf[303]:=lp.SortType; buf[304]:=rp.SortType;

buf[305]:=lo(lp.tdirs); buf[306]:=hi(lp.tdirs);
buf[307]:=lo(rp.tdirs); buf[308]:=hi(rp.tdirs);
buf[309]:=lo(lp.tfiles); buf[310]:=hi(lp.tfiles);
buf[311]:=lo(rp.tfiles); buf[312]:=hi(rp.tfiles);

buf[313]:=lo(lp.from); buf[314]:=hi(lp.from);
buf[315]:=lo(rp.from); buf[316]:=hi(rp.from);
buf[317]:=lo(lp.f); buf[318]:=hi(lp.f);
buf[319]:=lo(rp.f); buf[320]:=hi(rp.f);
{}
buf[321]:=lo(lp.pcfrom); buf[322]:=hi(lp.pcfrom);
buf[323]:=lo(rp.pcfrom); buf[324]:=hi(rp.pcfrom);
buf[325]:=lo(lp.pcf); buf[326]:=hi(lp.pcf);
buf[327]:=lo(rp.pcf); buf[328]:=hi(rp.pcf);

buf[329]:=lp.ckLastPanelType; buf[330]:=rp.ckLastPanelType;

buf[331]:=ord(lp.flpDrive); buf[332]:=ord(rp.flpDrive);

if TRDOS3 then buf[333]:=1 else buf[333]:=0;

{
buf[329]:=lo(lp.pctdirs); buf[330]:=hi(lp.pctdirs);
buf[331]:=lo(rp.pctdirs); buf[332]:=hi(rp.pctdirs);
buf[333]:=lo(lp.pctfiles); buf[334]:=hi(lp.pctfiles);
buf[335]:=lo(rp.pctfiles); buf[336]:=hi(rp.pctfiles);
{}
buf[765]:=focus; buf[766]:=gmaxy;
buf[767]:=length(command);
s:=command+space(255-length(command)); Add2BufStr(768,s);

Add2BufStr(1024,sRexpand(lp.fddfile,127)); Add2BufStr(1151,sRexpand(rp.fddfile,127));
Add2BufStr(1278,sRexpand(lp.trdfile,127)); Add2BufStr(1405,sRexpand(rp.trdfile,127));
Add2BufStr(1532,sRexpand(lp.fdifile,127)); Add2BufStr(1659,sRexpand(rp.fdifile,127));
Add2BufStr(1786,sRexpand(lp.sclfile,127)); Add2BufStr(1913,sRexpand(rp.sclfile,127));
Add2BufStr(2040,sRexpand(lp.tapfile,127)); Add2BufStr(2167,sRexpand(rp.tapfile,127));
Add2BufStr(2294,sRexpand(lp.zxzfile,127)); Add2BufStr(2421,sRexpand(rp.zxzfile,127));

{$I-}
assign(ff,fn); rewrite(ff,1); blockwrite(ff,buf,3072); close(ff);
{$I+}
if IOResult<>0 then
 if lang=rus then errormessage('Невозможно сохранить состояние')
             else errormessage('Can'#39't save settings');

End;



{============================================================================}
Procedure LoadDesktop(fn:string);
Var
    s:string; b:byte; i:integer;
    ff:file; buf:array[1..3072] of byte;
function GetBufStr(ind,l:word):string;
var w:word;
begin
s:='';
for w:=1 to l do s:=s+chr(buf[ind+w-1]);
GetBufStr:=s;
end;

Begin
{$I-}
assign(ff,fn); reset(ff,1); blockread(ff,buf,3072); close(ff);
{$I+}
if ioresult<>0 then exit;
s:=GetBufStr(1,10); if s<>'SN Desktop' then exit;

lp.Columns:=buf[11]; rp.Columns:=buf[12];
lp.InfoLines:=buf[13]; rp.InfoLines:=buf[14];
if buf[15]=1 then lp.NameLine:=true else lp.NameLine:=false;
if buf[16]=1 then rp.NameLine:=true else rp.NameLine:=false;
lp.pcnn:=nospaceLR(GetBufStr(17,12));
rp.pcnn:=nospaceLR(GetBufStr(29,12));
lp.pcnd:=nospaceLR(GetBufStr(41,128));
rp.pcnd:=nospaceLR(GetBufStr(169,128));


lp.PanelType:=buf[297]; rp.PanelType:=buf[298];
lp.LastPanelType:=buf[299]; rp.LastPanelType:=buf[300];
lp.clLastPanelType:=buf[301]; rp.clLastPanelType:=buf[302];
lp.ckLastPanelType:=buf[329]; rp.ckLastPanelType:=buf[330];
lp.flpDrive:=chr(buf[331]); rp.flpDrive:=chr(buf[332]);
lp.SortType:=buf[303]; rp.SortType:=buf[304];

lp.tdirs   :=256*buf[306]+buf[305]; rp.tdirs   :=256*buf[308]+buf[307];
lp.tfiles  :=256*buf[310]+buf[309]; rp.tfiles  :=256*buf[312]+buf[311];
{}
lp.from    :=256*buf[314]+buf[313]; rp.from    :=256*buf[316]+buf[315];
lp.f       :=256*buf[318]+buf[317]; rp.f       :=256*buf[320]+buf[319];
{}
lp.pcfrom  :=256*buf[322]+buf[321]; rp.pcfrom  :=256*buf[324]+buf[323];
lp.pcf     :=256*buf[326]+buf[325]; rp.pcf     :=256*buf[328]+buf[327];

if buf[333]=1 then TRDOS3:=true else TRDOS3:=false;

focus:=buf[765];
b:=buf[766];
if RestoreVideo then
 Begin
  Case b of
   25: if gmaxy<>25 then Set80x25;
   30: if gmaxy<>30 then Set80x30;
   50: if gmaxy<>50 then Set80x50;
  End;
 End;
command:=nospaceLR(GetBufStr(768,255));{}
if nospace(command)='' then command:='';

lp.fddfile:=nospaceLR(GetBufStr(1024,127)); rp.fddfile:=nospaceLR(GetBufStr(1151,127));
lp.trdfile:=nospaceLR(GetBufStr(1278,127)); rp.trdfile:=nospaceLR(GetBufStr(1405,127));
lp.fdifile:=nospaceLR(GetBufStr(1532,127)); rp.fdifile:=nospaceLR(GetBufStr(1659,127));
lp.sclfile:=nospaceLR(GetBufStr(1786,127)); rp.sclfile:=nospaceLR(GetBufStr(1913,127));
lp.tapfile:=nospaceLR(GetBufStr(2040,127)); rp.tapfile:=nospaceLR(GetBufStr(2167,127));
lp.zxzfile:=nospaceLR(GetBufStr(2294,127)); rp.zxzfile:=nospaceLR(GetBufStr(2421,127));
End;




{============================================================================}
Procedure ViewHistoryCommands;
var i:byte;
begin
menu_total:=0;
for i:=1 to 32 do
 begin
  if History[i]='end of history' then break;
  menu_name[i]:=History[i];
  inc(menu_total);
 end;
if menu_total=0 then exit;
menu_visible:=gmaxy-5;
menu_f:=menu_total; if lang=rus then menu_title:='История команд' else menu_title:='Command history';
i:=ChooseItem;
if i<>0 then
 begin
  command:=nospaceLR(menu_name[i]);
  CommandXFrom:=255; CommandXPos:=255;
 end;
end;




{============================================================================}
Procedure HistoryCommand;
Var
f:text; a:array[1..32] of string[128]; i,m:byte;
Begin
 {$I-}
 assign(f,startdir+'\sn.his');
 if CheckDirFile(startdir+'\sn.his')<>0 then
  begin filemode:=2; rewrite(f); writeln(f,'SN History file'); close(f); end;

 filemode:=0; reset(f);
 readln(f,a[1]); i:=1;
 repeat
  readln(f,a[i]);
  inc(i);
  if (i>30)or(EOF(f)) then break;
 until false;
 close(f);

 if i>30 then
  begin
   filemode:=2; rewrite(f); writeln(f,'SN History file');
   for m:=2 to 30 do writeln(f,a[m]);
   close(f);
  end;

 filemode:=2; append(f);
 writeln(f,command);
 close(f);
 {$I+}
 if IOResult<>0 then;
End;


{============================================================================}
Procedure DoExec(CmdStr:string; look:boolean);
var
stemp:string; ndir:string;
f:text; a:array[1..30] of string[128]; i,m:word;
Begin
 if clocked then clockexitproc;
 textattr:=savedattr; restbkdesk; restcur; curon; MemDeskDone; FreeMemPCDirs; {savetextmode;{}

 HistoryCommand;
 ndir:=pcndOf(focus);
 if (length(ndir)>3)and(ndir[length(ndir)]='\') then stemp:=copy(ndir,1,length(ndir)-1) else stemp:=ndir;
{ message(TempDir);{}
 SaveDesktop(TempDir+'\'+GetOf(startnum,_name)+'.swp');
 {$I-} chdir(stemp); {$I+}
 if IOResult=0 then;
 colour(0,7);
 if look then
  begin
   if wherex<>1 then writeln;
   if GetOf(cmdstr,_dir)>'' then writeln(cmdstr) else writeln(ndir+cmdstr);
  end;
 halt(1);
End;





{============================================================================}
{
Procedure CtrlUPressed;
var lpp,rpp:TPanel; i:word;
begin
lpp:=lp; rpp:=rp;

lp.PanelLong:=rpp.PanelLong; rp.PanelLong:=lpp.PanelLong;
lp.PanelHi:=rpp.PanelHi; rp.PanelHi:=lpp.PanelHi;
lp.Columns:=rpp.Columns; rp.Columns:=lpp.Columns;
lp.InfoLines:=rpp.InfoLines; rp.InfoLines:=lpp.InfoLines;
lp.PutFrom:=rpp.PutFrom; rp.PutFrom:=lpp.PutFrom;
lp.NameLine:=rpp.NameLine; rp.NameLine:=lpp.NameLine;
lp.Visible:=rpp.Visible; rp.Visible:=lpp.Visible;
lp.PanelType:=rpp.PanelType; rp.PanelType:=lpp.PanelType;
lp.clLastPanelType:=rpp.clLastPanelType; rp.clLastPanelType:=lpp.clLastPanelType;
lp.ckLastPanelType:=rpp.ckLastPanelType; rp.ckLastPanelType:=lpp.ckLastPanelType;
lp.ckLastPanelType:=rpp.ckLastPanelType; rp.ckLastPanelType:=lpp.ckLastPanelType;
lp.xc:=rpp.xc; rp.xc:=lpp.xc;
lp.yc:=rpp.yc; rp.yc:=lpp.yc;
lp.lc:=rpp.lc; rp.lc:=lpp.lc;
lp.tdirs:=rpp.tdirs; rp.tdirs:=lpp.tdirs;
lp.tfiles:=rpp.tfiles; rp.tfiles:=lpp.tfiles;
lp.from:=rpp.from; rp.from:=lpp.from;
lp.f:=rpp.f; rp.f:=lpp.f;
lp.pcnd:=rpp.pcnd; rp.pcnd:=lpp.pcnd;
lp.oldpcnd:=rpp.oldpcnd; rp.oldpcnd:=lpp.oldpcnd;
lp.pcnn:=rpp.pcnn; rp.pcnn:=lpp.pcnn;
lp.TreeC:=rpp.TreeC; rp.TreeC:=lpp.TreeC;
lp.SortType:=rpp.SortType; rp.SortType:=lpp.SortType;
lp.pctdirs:=rpp.pctdirs; rp.pctdirs:=lpp.pctdirs;
lp.pctfiles:=rpp.pctfiles; rp.pctfiles:=lpp.pctfiles;
lp.pctfiles:=rpp.pctfiles; rp.pctfiles:=lpp.pctfiles;
lp.oldpctfiles:=rpp.oldpctfiles; rp.oldpctfiles:=lpp.oldpctfiles;
lp.trdtfiles:=rpp.trdtfiles; rp.trdtfiles:=lpp.trdtfiles;
lp.taptfiles:=rpp.taptfiles; rp.taptfiles:=lpp.taptfiles;
lp.fditfiles:=rpp.fditfiles; rp.fditfiles:=lpp.fditfiles;
lp.fddtfiles:=rpp.fddtfiles; rp.fddtfiles:=lpp.fddtfiles;
lp.zxztfiles:=rpp.zxztfiles; rp.zxztfiles:=lpp.zxztfiles;
lp.scltfiles:=rpp.scltfiles; rp.scltfiles:=lpp.scltfiles;
lp.trdnn:=rpp.trdnn; rp.trdnn:=lpp.trdnn;
lp.fdinn:=rpp.fdinn; rp.fdinn:=lpp.fdinn;
lp.fddnn:=rpp.fddnn; rp.fddnn:=lpp.fddnn;
lp.tapnn:=rpp.tapnn; rp.tapnn:=lpp.tapnn;
lp.sclnn:=rpp.sclnn; rp.sclnn:=lpp.sclnn;
lp.zxznn:=rpp.zxznn; rp.zxznn:=lpp.zxznn;
lp.pcf:=rpp.pcf; rp.pcf:=lpp.pcf;
lp.pcfrom:=rpp.pcfrom; rp.pcfrom:=lpp.pcfrom;
lp.trdfrom:=rpp.trdfrom; rp.trdfrom:=lpp.trdfrom;
lp.trdf:=rpp.trdf; rp.trdf:=lpp.trdf;
lp.fdifrom:=rpp.fdifrom; rp.fdifrom:=lpp.fdifrom;
lp.fdif:=rpp.fdif; rp.fdif:=lpp.fdif;
lp.tapfrom:=rpp.tapfrom; rp.tapfrom:=lpp.tapfrom;
lp.tapf:=rpp.tapf; rp.tapf:=lpp.tapf;
lp.fddfrom:=rpp.fddfrom; rp.fddfrom:=lpp.fddfrom;
lp.fddf:=rpp.fddf; rp.fddf:=lpp.fddf;
lp.zxzfrom:=rpp.zxzfrom; rp.zxzfrom:=lpp.zxzfrom;
lp.zxzf:=rpp.zxzf; rp.zxzf:=lpp.zxzf;
lp.sclfrom:=rpp.sclfrom; rp.sclfrom:=lpp.sclfrom;
lp.sclf:=rpp.sclf; rp.sclf:=lpp.sclf;
lp.trdFile:=rpp.trdFile; rp.trdFile:=lpp.trdFile;
lp.tapFile:=rpp.tapFile; rp.tapFile:=lpp.tapFile;
lp.fdiFile:=rpp.fdiFile; rp.fdiFile:=lpp.fdiFile;
lp.fddFile:=rpp.fddFile; rp.fddFile:=lpp.fddFile;
lp.zxzFile:=rpp.zxzFile; rp.zxzFile:=lpp.zxzFile;
lp.sclFile:=rpp.sclFile; rp.sclFile:=lpp.sclFile;

ChangeFocus;
reMDF;

lp.Build('12'); rp.Build('12');
reInfo('A');
rePDF;
end;
{}

{============================================================================}
Procedure LocalFind;
var
    p:TPanel;
    a,kb:word;
    fname,t,s,ff:string[13];

    i:byte;
    fnd:boolean;

Label loop,fin;
Begin
Case focus of left:p:=lp; right:p:=rp; end;
 CancelSB;
 w_shadow:=false;{}
 scPutWin(pal.bkdRama,pal.txtdRama,p.posx+9,gmaxy-3,p.posx+32,gmaxy-1);
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,p.posx+11,gmaxy-2,'Поиск:')
             else cmprint(pal.bkdLabelST,pal.txtdLabelST,p.posx+11,gmaxy-2,'Find:');
 printself(pal.bkdInputNT,pal.txtdInputNT,p.posx+18,gmaxy-2,13);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 s:='';

loop:
 cmprint(pal.bkdInputNT,pal.txtdInputNT,p.posx+18,gmaxy-2,s+space(13-length(s)));
 gotoXY(p.posx+18+length(nospace(s)),gmaxy-2);
 CurOn;

 kb:=KeyCode;
 if (kb=_ESC)or(kb=_ENTER)or(kb=_Tab) then goto fin;

 if kb=_HOME then
  Case focus of
   left:
    begin
     Case lp.PanelType of
      pcPanel:  begin lp.pcfrom:=1; lp.pcf:=1; end;
      trdPanel: begin lp.trdfrom:=1; lp.trdf:=1; end;
      fdiPanel: begin lp.fdifrom:=1; lp.fdif:=1; end;
      fddPanel: begin lp.fddfrom:=1; lp.fddf:=1; end;
      flpPanel: begin lp.flpfrom:=1; lp.flpf:=1; end;
      sclPanel: begin lp.sclfrom:=1; lp.sclf:=1; end;
      tapPanel: begin lp.tapfrom:=1; lp.tapf:=1; end;
      zxzPanel: begin lp.zxzfrom:=1; lp.zxzf:=1; end;
     End;
     lp.Inside; rePDF; s:='';
    end;
   right:
    begin
     Case rp.PanelType of
      pcPanel:  begin rp.pcfrom:=1; rp.pcf:=1; end;
      trdPanel: begin rp.trdfrom:=1; rp.trdf:=1; end;
      fdiPanel: begin rp.fdifrom:=1; rp.fdif:=1; end;
      fddPanel: begin rp.fddfrom:=1; rp.fddf:=1; end;
      flpPanel: begin rp.flpfrom:=1; rp.flpf:=1; end;
      sclPanel: begin rp.sclfrom:=1; rp.sclf:=1; end;
      tapPanel: begin rp.tapfrom:=1; rp.tapf:=1; end;
      zxzPanel: begin rp.zxzfrom:=1; rp.zxzf:=1; end;
     End;
     rp.Inside; rePDF; s:='';
    end;
  End;

 if chr(lo(kb)) in [#8] then delete(s,length(s),1);

 if (chr(lo(kb)) in [#32..'я'])and
    (hi(kb) in [0..$d,$10..$1b,$1e..$29,$2b..$35,$39]) then
  begin

   s:=s+chr(lo(kb));
   for a:=IndexOf(Focus) to p.tdirs+p.tfiles do
    begin
     if PanelTypeOf(focus)=pcPanel
       then fname:=TrueNameOf(focus,a)
       else fname:=nospaceLR(p.trdDir^[a].name)+'.'+TRDOSe3(p,a);


     t:=fill(length(fname),'?');
     for i:=1 to length(s) do t[i]:=s[i];
     fnd:=false;
     if wild(fname,t,false) then{}
      begin
       Case focus of
        left:  begin
                Case lp.PanelType of
                 pcPanel:
                  begin
                   inc(lp.pcf,abs(a-IndexOf(focus)));
                   if lp.pcf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.pcfrom,(lp.pcf-lp.PanelHi*lp.Columns));
                     lp.pcf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 trdPanel:
                  begin
                   inc(lp.trdf,abs(a-IndexOf(focus)));
                   if lp.trdf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.trdfrom,(lp.trdf-lp.PanelHi*lp.Columns));
                     lp.trdf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 fdiPanel:
                  begin
                   inc(lp.fdif,abs(a-IndexOf(focus)));
                   if lp.fdif>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.fdifrom,(lp.fdif-lp.PanelHi*lp.Columns));
                     lp.fdif:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 fddPanel:
                  begin
                   inc(lp.fddf,abs(a-IndexOf(focus)));
                   if lp.fddf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.fddfrom,(lp.fddf-lp.PanelHi*lp.Columns));
                     lp.fddf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 flpPanel:
                  begin
                   inc(lp.flpf,abs(a-IndexOf(focus)));
                   if lp.flpf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.flpfrom,(lp.flpf-lp.PanelHi*lp.Columns));
                     lp.flpf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 sclPanel:
                  begin
                   inc(lp.sclf,abs(a-IndexOf(focus)));
                   if lp.sclf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.sclfrom,(lp.sclf-lp.PanelHi*lp.Columns));
                     lp.sclf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 tapPanel:
                  begin
                   inc(lp.tapf,abs(a-IndexOf(focus)));
                   if lp.tapf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.tapfrom,(lp.tapf-lp.PanelHi*lp.Columns));
                     lp.tapf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                 zxzPanel:
                  begin
                   inc(lp.zxzf,abs(a-IndexOf(focus)));
                   if lp.zxzf>lp.PanelHi*lp.Columns then
                    begin
                     inc(lp.zxzfrom,(lp.zxzf-lp.PanelHi*lp.Columns));
                     lp.zxzf:=lp.PanelHi*lp.Columns;
                    end;
                  end;
                End;
                lp.Inside;
               end;
        right: begin
                Case rp.PanelType of
                 pcPanel:
                  begin
                   inc(rp.pcf,abs(a-IndexOf(focus)));
                   if rp.pcf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.pcfrom,(rp.pcf-rp.PanelHi*rp.Columns));
                     rp.pcf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 trdPanel:
                  begin
                   inc(rp.trdf,abs(a-IndexOf(focus)));
                   if rp.trdf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.trdfrom,(rp.trdf-rp.PanelHi*rp.Columns));
                     rp.trdf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 fdiPanel:
                  begin
                   inc(rp.fdif,abs(a-IndexOf(focus)));
                   if rp.fdif>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.fdifrom,(rp.fdif-rp.PanelHi*rp.Columns));
                     rp.fdif:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 fddPanel:
                  begin
                   inc(rp.fddf,abs(a-IndexOf(focus)));
                   if rp.fddf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.fddfrom,(rp.fddf-rp.PanelHi*rp.Columns));
                     rp.fddf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 flpPanel:
                  begin
                   inc(rp.flpf,abs(a-IndexOf(focus)));
                   if rp.flpf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.flpfrom,(rp.flpf-rp.PanelHi*rp.Columns));
                     rp.flpf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 sclPanel:
                  begin
                   inc(rp.sclf,abs(a-IndexOf(focus)));
                   if rp.sclf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.sclfrom,(rp.sclf-rp.PanelHi*rp.Columns));
                     rp.sclf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 tapPanel:
                  begin
                   inc(rp.tapf,abs(a-IndexOf(focus)));
                   if rp.tapf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.tapfrom,(rp.tapf-rp.PanelHi*rp.Columns));
                     rp.tapf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                 zxzPanel:
                  begin
                   inc(rp.zxzf,abs(a-IndexOf(focus)));
                   if rp.zxzf>rp.PanelHi*rp.Columns then
                    begin
                     inc(rp.zxzfrom,(rp.zxzf-rp.PanelHi*rp.Columns));
                     rp.zxzf:=rp.PanelHi*rp.Columns;
                    end;
                  end;
                End;
                rp.Inside;
               end;
       End;
       rePDF;
       fnd:=true;
       break;
      end;
    end;
   if not fnd then delete(s,length(s),1);
  end;
goto loop;

fin:
 w_shadow:=true;
 CurOff;
 RestScr;
End;


{============================================================================}
Procedure GlobalFind;
Begin
End;


Begin
sBar[rus,noPanel]:='~`Alt+X~` Выход'; sBar[eng,noPanel]:='~`Alt+X~` Exit';
sBar[rus,infPanel]:='~`Alt+X~` Выход'; sBar[eng,infPanel]:='~`Alt+X~` Exit';
End.