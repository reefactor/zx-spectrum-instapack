{$O+,F+}
Unit Init;
Interface

Procedure snInit(sys:boolean);

Implementation
Uses
     Crt, Dos, RV, Mouse, Clock,
     Vars, sn_Mem, sn_Obj, Palette, Main, Main_Ovr, sn_KBD;


Procedure snInit(sys:boolean);
Var
   s:string; i:word; f:text;
{----------------------------------------------------------------------------}
function makePR:string;
begin
if pos('Group1',s)<>0 then s:=copy(s,1,pos(';Group1;',s)-1)+group1+copy(s,8+pos(';Group1;',s),255);
if pos('Group2',s)<>0 then s:=copy(s,1,pos(';Group2;',s)-1)+group2+copy(s,8+pos(';Group2;',s),255);
if pos('Group3',s)<>0 then s:=copy(s,1,pos(';Group3;',s)-1)+group3+copy(s,8+pos(';Group3;',s),255);
if pos('Group4',s)<>0 then s:=copy(s,1,pos(';Group4;',s)-1)+group4+copy(s,8+pos(';Group4;',s),255);
if pos('Group5',s)<>0 then s:=copy(s,1,pos(';Group5;',s)-1)+group5+copy(s,8+pos(';Group5;',s),255);
if pos('GroupExe',s)<>0 then s:=copy(s,1,pos(';GroupExe;',s)-1)+gExe+copy(s,10+pos(';GroupExe;',s),255);
if pos('GroupArc',s)<>0 then s:=copy(s,1,pos(';GroupArc;',s)-1)+gArc+copy(s,10+pos(';GroupArc;',s),255);
makePR:=s;
end;
{----------------------------------------------------------------------------}
label contsys;
Begin
if sys then goto contsys;{}
{if strlo(nospace(runby))<>'sn' then halt(0);{}
if (DosMem<400*1024) then
 begin
  WriteLn('Not enough request 400K conventional memory. '+
          ChangeChar(ExtNum(strr(DosMem)),' ',',')+'K is free.');
  Halt;
 end;
CurOff; Flash(off);
SavedAttr:=TextAttr;
if WhereY>=gmaxy-2 then WriteLn;
SaveCur;
GetMemDesk;
SaveBkDesk;
GetMemPCDirs;

if (MemAvail<70*1024) then
 begin
  WriteLn('Not enough request 70K data segment memory. '+
          ChangeChar(ExtNum(strr(MemAvail)),' ',',')+'K is free.');
  Halt;
 end;

ContSys:

WorkDir:=CurentDir; StartDir:=GetOf(ParamStr(0),_dir);
if StartDir='' then StartDir:=CurentDir;{}
if snMouse then if InitMouse then Moused:=true else Moused:=false;{}
if snMouse then if Moused then SetMousePos(1,1);

focus:=left; Lang:=eng;

Refresh:=true; Del_F8:=true; Esc_ShowUserScr:=true;
DiskMenuType:=0; HideHidden:=false; ASCln:=111;
lp.pcnd:=curentdir;
rp.pcnd:=curentdir;

GetPalFile;
LoadDefaultKBD;
LoadKBD;

menu_bkNT:=pal.bkMenuNT;          menu_txtNT:=pal.txtMenuNT;
menu_bkST:=pal.bkMenuST;          menu_txtST:=pal.txtMenuST;

menu_bkMarkNT:=pal.bkMenuMarkNT;  menu_txtMarkNT:=pal.txtMenuMarkNT;
menu_bkMarkST:=pal.bkMenuMarkST;  menu_txtMarkST:=pal.txtMenuMarkST;

if checkdirfile(startdir+'\sn.ini')=0 then
BEGIN
getprofile(startdir+'\sn.ini','Interface','Clock',s);
if s='1' then clocked:=true else clocked:=false;

getprofile(startdir+'\sn.ini','Interface','NameLine',s);
if s='0' then begin lp.nameline:=false; rp.nameline:=false; end
         else begin lp.nameline:=true; rp.nameline:=true; end;

getprofile(startdir+'\sn.ini','Interface','DiskLine',s);
if s='1' then diskLine:=true else DiskLine:=false;

getprofile(startdir+'\sn.ini','Interface','InfoLines',s);
if vall(s)in[1..3] then begin lp.infolines:=vall(s); rp.infolines:=vall(s); end;

getprofile(startdir+'\sn.ini','System','Animation',s);
if s='1' then w_animation:=true else w_animation:=false;

getprofile(startdir+'\sn.ini','System','LoadDesktop',s);
if s='1' then bloaddesktop:=true else bloaddesktop:=false;

getprofile(startdir+'\sn.ini','System','SaveOnExit',s);
if s='1' then SaveOnExit:=true else SaveOnExit:=false;

getprofile(startdir+'\sn.ini','System','RestoreVideo',s);
if s='1' then RestoreVideo:=true else RestoreVideo:=false;

getprofile(startdir+'\sn.ini','System','BkSpUpDir',s);
if s='1' then BkSpUpDir:=true else BkSpUpDir:=false;

getprofile(startdir+'\sn.ini','Interface','HideCmdLine',s);
if s='1' then HideCmdLine:=true else HideCmdLine:=false;

getprofile(startdir+'\sn.ini','System','Focus',s);
if strlo(s)='left' then FOCUS:=left else FOCUS:=right;

getprofile(startdir+'\sn.ini','System','DiskMenuType',s);
DiskMenuType:=vall(nospace(s));

getprofile(startdir+'\sn.ini','System','HideHidden',s);
if strlo(s)='1' then HideHidden:=true else HideHidden:=false;

getprofile(startdir+'\sn.ini','System','Refresh',s);
if strlo(s)='1' then Refresh:=true else Refresh:=false;

getprofile(startdir+'\sn.ini','System','Del_F8',s);
if strlo(s)='1' then Del_F8:=true else Del_F8:=false;

getprofile(startdir+'\sn.ini','System','Esc_ShowUserScr',s);
if strlo(s)='1' then Esc_ShowUserScr:=true else Esc_ShowUserScr:=false;

getprofile(startdir+'\sn.ini','Interface','LColumns',s);
lp.Columns:=vall(s);
getprofile(startdir+'\sn.ini','Interface','RColumns',s);
rp.Columns:=vall(s);

getprofile(startdir+'\sn.ini','System','ASCn',s);
ASCln:=vall(s);

getprofile(startdir+'\sn.ini','System','National',s);
LANG:=rus;
if strlo(s)='rus' then LANG:=rus;
if strlo(s)='eng' then LANG:=eng;

getprofile(startdir+'\sn.ini','System','InternalView',s);
if strlo(s)='1' then InternalView:=true else InternalView:=false;

getprofile(startdir+'\sn.ini','Priory','1',s); pr1:=makePR;
getprofile(startdir+'\sn.ini','Priory','2',s); pr2:=makePR;
getprofile(startdir+'\sn.ini','Priory','3',s); pr3:=makePR;
getprofile(startdir+'\sn.ini','Priory','4',s); pr4:=makePR;
getprofile(startdir+'\sn.ini','Priory','5',s); pr5:=makePR;
getprofile(startdir+'\sn.ini','Priory','6',s); pr6:=makePR;
getprofile(startdir+'\sn.ini','Priory','7',s); pr7:=makePR;
getprofile(startdir+'\sn.ini','Priory','8',s); pr8:=makePR;
getprofile(startdir+'\sn.ini','Priory','9',s); pr9:=makePR;
getprofile(startdir+'\sn.ini','Priory','11',s); pr11:=makePR;

getprofile(startdir+'\sn.ini','Spectrum','TRDOS3',s);
if s='1' then
 begin
  TRDOS3en:=true;
  getprofile(startdir+'\sn.ini','Spectrum','TRDOS3onStart',s);
  if s='1' then TRDOS3:=true else TRDOS3:=false;
 end else begin TRDOS3en:=false; TRDOS3:=false; end;

getprofile(startdir+'\sn.ini','Spectrum','AutoMove',s);
if s='1' then automove:=true else automove:=false;

getprofile(startdir+'\sn.ini','Spectrum','hob2scl',s);
if s='1' then hob2scl:=true else hob2scl:=false;

getprofile(startdir+'\sn.ini','Spectrum','Execute',s);
if s='1' then executeEmu:=true else executeEmu:=false;
getprofile(startdir+'\sn.ini','Spectrum','ExecuteEmulator',ExecuteEmulator);

getprofile(startdir+'\sn.ini','Spectrum','HobetaStartAddr',s);
if nospace(s)='' then HobetaStartAddr:=32768 else HobetaStartAddr:=vall(s);

getprofile(startdir+'\sn.ini','Spectrum','noHobNaming',s);
if s='1' then noHobNaming:=1 else noHobNaming:=0;

getprofile(startdir+'\sn.ini','Spectrum','CheckMedia',s);
if s='1' then CheckMedia:=true else CheckMedia:=false;
{}
getprofile(startdir+'\sn.ini','Spectrum','LoadUp80',s);
if s='1' then LoadUp80:=true else LoadUp80:=false;

getprofile(startdir+'\sn.ini','Spectrum','Cat9',s);
if s='1' then Cat9:=true else Cat9:=false;


tempdir:=GetEnv('TEMP');
if tempdir='' then tempdir:=GetEnv('TMP');
if tempdir='' then tempdir:='C:\';
if tempdir[length(tempdir)]<>'\' then tempdir:=tempdir+'\';
startnum:='SN'+copy(paramstr(1),1,6)+'.TMP';

s:=ParamStr(1);
if s[7]<>'E' then
 begin
  if CheckDirFile(StartDir+'\SN.DSK')=0 then
  if bLoadDesktop then LoadDesktop(StartDir+'\SN.DSK');
 end;

if s[7]='E' then if CheckDirFile(TempDir+GetOf(StartNum,_name)+'.SWP')=0 then
 begin
  LoadDesktop(TempDir+GetOf(StartNum,_name)+'.SWP');
  FileDelete(TempDir+GetOf(StartNum,_name)+'.SWP');
  FileDelete(TempDir+StartNum);
  Command:='';
  Case focus of
   left:  lp.pcnd:=CurentDir;
   right: rp.pcnd:=CurentDir;
  End;
 end;

if s[7]<>'E' then
 begin
  getprofile(startdir+'\sn.ini','System','LoadStartDirs',s);
  if strlo(s)='1' then
   Begin
    getprofile(startdir+'\sn.ini','System','LStartDir',lp.pcnd);
    getprofile(startdir+'\sn.ini','System','RStartDir',rp.pcnd);
   End;
 end;
END;

if lp.pcnd[length(lp.pcnd)]<>'\' then lp.pcnd:=lp.pcnd+'\';
if rp.pcnd[length(rp.pcnd)]<>'\' then rp.pcnd:=rp.pcnd+'\';

if Clocked then Initialise;{}
cStatusBar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,sBar[lang,PanelTypeOf(focus)]);{}
{PutCmdLine;{}
if moused then MouseOn;
if HideCmdLine then CmdLine:=false else CmdLine:=true;


if CheckDirFile(startdir+'\sn.his')=0 then
 begin
  assign(f,startdir+'\sn.his'); filemode:=0; reset(f); i:=1;
  readln(f,s);
  if s='SN History file' then
   repeat
    readln(f,s);
    s:=s+space(128-length(s));
    History[i]:=s;
    inc(i);
    if (EOF(f))or(i>30) then begin HistoryTotal:=i-1; History[i]:='end of history'; break; end;
   until false
  else History[1]:='end of history';
 end;

HistoryIndex:=HistoryTotal+1;

flash(off);
{
s:=ParamStr(1);
if s[7]<>'E' then
 begin

  getprofile(startdir+'\sn.ini','System','Security',s);
  if strlo(s)<>'0' then
   begin
    if GetInfoRR(paramstr(0),snver,host,serial,crc1,crc2,crc3,crc) then
     begin
      message(snver+' '+ver);
     end
    else
     begin
      if lang=rus then s:='Ошибка в EXE файле' else s:='Error in EXE-file';
      errormessage(s);
      snDone;
     end;
   end;
 end;
{}
{
lp.trdfile:=''; rp.trdfile:='';
lp.fdifile:=''; rp.fdifile:='';
lp.fddfile:=''; rp.fddfile:='';
lp.sclfile:=''; rp.sclfile:='';
lp.tapfile:=''; rp.tapfile:='';
lp.zxzfile:=''; rp.zxzfile:='';

{}
End;


End.