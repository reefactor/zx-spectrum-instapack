Unit Main;
Interface
Uses
     Dos;

Function  CRC16(InString: String) : Word;
Function  CheckPath(p:string):string;
Procedure PutCmdLine;
Procedure GlobalRedraw;
Procedure rePDF;
Procedure reMDF;
Procedure reInfo(parts:string);
Procedure reInside;
Procedure reOutside;
Procedure reTrueCur;
Procedure reMouse;

Procedure EscPressed;

Procedure CancelSB;
Procedure ChangeFocus;
Function  PanelTypeOf(w:byte):byte;
Function  InsedOf(w:byte):word;
Function  IndexOf(w:byte):word;
Function  FirstMarkedOf(w:byte):word;
Function  TrueNameOf(w:byte; i:word):String;
Function  tDirsOf(w:word):word;
Function  tFilesOf(w:word):word;
Function  tDirsFilesOf(w:word):word;
Function  oFocus:byte;
Function  pcndOf(w:word):string;
Function  ViewOf(w:byte; sys:boolean):longint;
Function  pcDirPrioryOf(w:byte; ind:word):byte;
Function  pcDirFAttrOf(w:byte; ind:word):word;
Function  pcDirFdtOf(w:byte; ind:word):longint;
Function  pcDirMarkOf(w:byte; ind:word):boolean;
Function  trdDirMarkOf(w:byte; ind:word):boolean;
Function  TreeCOf(w:byte; path:string):byte;
Procedure GetCurXYOf(w:byte; var x,y:byte);
Function  ColumnsOf(w:byte):byte;
Function  FocusedOf(w:byte):boolean;

Procedure Navigate;

Implementation
Uses
     RV, Clock, Mouse,
     Vars, sn_Mem, sn_Obj, Palette;


{============================================================================}
Function CRC16(InString: String) : Word;
Var
  CRC     : Word;
  Index1,
  Index2  : Byte;
begin
  CRC := 0;
  For Index1 := 1 to length(InString) do
  begin
    CRC := (CRC xor (ord(InString[Index1]) SHL 8));
    For Index2 := 1 to 8 do
      if ((CRC and $8000) <> 0) then
        CRC := ((CRC SHL 1) xor $1021)
      else
        CRC := (CRC SHL 1)
  end;
  CRC16 := (CRC and $FFFF)
end;



{============================================================================}
Function CheckPath(p:string):string;
Var
    ie,er:integer; prev:pathstr;
begin
GetDir(0,prev);{}
if (p[Length(p)]='\')and(Length(p)>3){} then Delete(p,Length(p),1);
{$I-}
ChDir(p);
{$I+}
er:=IOResult;
if (er=15)or(er=152) then
 begin
  CheckPath:='C:\';
  {from:=1; f:=1;{}
  Exit;
 end;
if er<>0 then
 begin
  for ie:=1 to Length(p)-Length(WithOut(p,'\')) do
   begin
    Delete(p,Length(p)-Pos('\',ReverseStr(Copy(p,1,Length(p)-1))),255);

    {$I-}
    ChDir(p);
    {$I+}
    if IOResult=0 then
     begin
      Break;
     end;
    if Length(p)<=3 then
     begin
      p:=p[1]+':\';
      Break;
     end;
   end;
 end;

if p[Length(p)]<>'\' then p:=p+'\';{}
CheckPath:=p;

{if CheckDir(prev)<>0 then prev:=CheckPath(prev);{}
{$I-}
ChDir(prev);
{$I+}
if ioresult<>0 then;
end;


{============================================================================}
Procedure PutCmdLine;
Var
    s,c:string[127];
Begin
if HideCmdLine then
 begin
  if NoSpace(command)='' then
   begin
    {скрываем командную строку}
    if CmdLine then
     begin
      CmdLine:=false;
      lp.Build('12'); rp.Build('12');
      if lp.PanelType=noPanel then lp.Hide;
      if rp.PanelType=noPanel then rp.Hide;
      reInfo('cbndsfi'); rePDF;
     end;
   end
  else
   begin
    {показываем командную строку}
    if not CmdLine then
     begin
      CmdLine:=true;
      lp.Build('12'); rp.Build('12');
      if lp.PanelType=noPanel then lp.Hide;
      if rp.PanelType=noPanel then rp.Hide;
      reInfo('cbndsfi'); rePDF;
     end;
   end;
 end;

if CommandXPos<1 then begin CommandXPos:=1; Dec(CommandXFrom); end;
if CommandXFrom<1 then CommandXFrom:=1;

if not CmdLine then Begin CurOff; Exit; End;
if lp.focused then s:=strhi(lp.pcnd) else s:=strhi(rp.pcnd);
if (s[length(s)]='\')and(length(s)>3) then delete(s,length(s),1);
cmPrint(0,15,1,gMaxY-1,s+'>');

if CommandXPos>78-length(s) then begin CommandXPos:=78-length(s); Inc(CommandXFrom); end;
if CommandXPos>length(Command)+1 then CommandXPos:=length(Command)+1;
{if CommandXFrom>length(Command)-(76-length(s)) then CommandXFrom:=length(Command)-(76-length(s));{}
if CommandXFrom+CommandXPos-2>length(Command) then CommandXFrom:=length(Command)-CommandXPos+2;

if CommandXPos<1 then begin CommandXPos:=1; Dec(CommandXFrom); end;
if CommandXFrom<1 then CommandXFrom:=1;

c:=Copy(Command,CommandXFrom,78-length(s));
cmprint(0,7,length(s+'>')+1,gMaxY-1,c);
GoToXY(Length(s+'>')+CommandXPos,gMaxY-1);

if Length(s+'>'+c)<80 then cmPrint(0,7,1+Length(s+'>'+c),gMaxY-1,Space(80-Length(s+'>'+c)));
CurOn;

if length(nospace(Command))=0 then begin CommandXPos:=1; CommandXFrom:=1; end;
{}
End;




{============================================================================}
Procedure GlobalRedraw;
Begin
{if Moused then MouseOff;{}
lp.PanelSetup; rp.PanelSetup;
if lp.PanelType=noPanel then lp.Hide else lp.Build('012');
if rp.PanelType=noPanel then rp.Hide else rp.Build('012');
lp.Info('cbdnsfi'); rp.Info('cbdnsfi');
Case lp.PanelType of
 pcPanel:  begin lp.TrueCur; lp.Inside; lp.pcPDF(lp.pcfrom); end;
 trdPanel: begin lp.TrueCur; lp.Inside; lp.trdPDFs(lp.trdfrom); end;
 fdiPanel: begin lp.TrueCur; lp.Inside; lp.fdiPDFs(lp.fdifrom); end;
 sclPanel: begin lp.TrueCur; lp.Inside; lp.sclPDFs(lp.sclfrom); end;
 tapPanel: begin lp.TrueCur; lp.Inside; lp.tapPDFs(lp.tapfrom); end;
 fddPanel: begin lp.TrueCur; lp.Inside; lp.fddPDFs(lp.fddfrom); end;
 zxzPanel: begin lp.TrueCur; lp.Inside; lp.zxzPDFs(lp.zxzfrom); end;
 flpPanel: begin lp.TrueCur; lp.Inside; lp.flpPDFs(lp.flpfrom); end;
End;
Case rp.PanelType of
 pcPanel:  begin rp.TrueCur; rp.Inside; rp.pcPDF(rp.pcfrom); end;
 trdPanel: begin rp.TrueCur; rp.Inside; rp.trdPDFs(rp.trdfrom); end;
 fdiPanel: begin rp.TrueCur; rp.Inside; rp.fdiPDFs(rp.fdifrom); end;
 sclPanel: begin rp.TrueCur; rp.Inside; rp.sclPDFs(rp.sclfrom); end;
 tapPanel: begin rp.TrueCur; rp.Inside; rp.tapPDFs(rp.tapfrom); end;
 fddPanel: begin rp.TrueCur; rp.Inside; rp.fddPDFs(rp.fddfrom); end;
 zxzPanel: begin rp.TrueCur; rp.Inside; rp.zxzPDFs(rp.zxzfrom); end;
 flpPanel: begin rp.TrueCur; rp.Inside; rp.flpPDFs(rp.flpfrom); end;
End;
{if Moused then MouseOn;{}
End;



{============================================================================}
Procedure rePDF;
begin
 case lp.PanelType of
  pcPanel:  lp.pcPDF(lp.pcfrom);
  trdPanel: lp.trdPDFs(lp.trdfrom);
  fdiPanel: lp.fdiPDFs(lp.fdifrom);
  sclPanel: lp.sclPDFs(lp.sclfrom);
  tapPanel: lp.tapPDFs(lp.tapfrom);
  fddPanel: lp.fddPDFs(lp.fddfrom);
  zxzPanel: lp.zxzPDFs(lp.zxzfrom);
  flpPanel: lp.flpPDFs(lp.flpfrom);
 end;
 case rp.PanelType of
  pcPanel:  rp.pcPDF(rp.pcfrom);
  trdPanel: rp.trdPDFs(rp.trdfrom);
  fdiPanel: rp.fdiPDFs(rp.fdifrom);
  sclPanel: rp.sclPDFs(rp.sclfrom);
  tapPanel: rp.tapPDFs(rp.tapfrom);
  fddPanel: rp.fddPDFs(rp.fddfrom);
  zxzPanel: rp.zxzPDFs(rp.zxzfrom);
  flpPanel: rp.flpPDFs(rp.flpfrom);
 end;
end;





{============================================================================}
Procedure reMDF;
Var lPT,rPT:byte;
begin
lPT:=lp.PanelType;
if lPT=noPanel then lPT:=lp.LastPanelType;
if lPT=infPanel then lPT:=lp.clLastPanelType;

rPT:=rp.PanelType;
if rPT=noPanel then rPT:=rp.LastPanelType;
if rPT=infPanel then rPT:=rp.clLastPanelType;
{
 case lPT of
  pcPanel:
   if lp.pcnd=rp.pcnd then lp.pcMDF(lp.pcnd) else
   if FOCUS=left then lp.pcMDF(lp.pcnd);
  trdPanel:
   if lp.trdfile=rp.trdfile then lp.trdMDFs(lp.trdfile) else
   if FOCUS=left then lp.trdMDFs(lp.trdfile);
  fdiPanel:
   if lp.fdifile=rp.fdifile then lp.fdiMDFs(lp.fdifile) else
   if FOCUS=left then lp.fdiMDFs(lp.fdifile);
  sclPanel:
   if lp.sclfile=rp.sclfile then lp.sclMDFs(lp.sclfile) else
   if FOCUS=left then lp.sclMDFs(lp.sclfile);
  tapPanel:
   if lp.tapfile=rp.tapfile then lp.tapMDFs(lp.tapfile) else
   if FOCUS=left then lp.tapMDFs(lp.tapfile);
  fddPanel:
   if lp.fddfile=rp.fddfile then lp.fddMDFs(lp.fddfile) else
   if FOCUS=left then lp.fddMDFs(lp.fddfile);
  zxzPanel:
   if lp.zxzfile=rp.zxzfile then lp.zxzMDFs(lp.zxzfile) else
   if FOCUS=left then lp.zxzMDFs(lp.zxzfile);
  flpPanel:
   if lp.flpDrive=rp.flpDrive then lp.flpMDFs(lp.flpDrive) else
   if FOCUS=left then lp.flpMDFs(lp.flpDrive);
 end;

 case rPT of
  pcPanel:
   if rp.pcnd=lp.pcnd then rp.pcMDF(rp.pcnd) else
   if FOCUS=right then rp.pcMDF(rp.pcnd);
  trdPanel:
   if rp.trdfile=lp.trdfile then rp.trdMDFs(rp.trdfile) else
   if FOCUS=right then rp.trdMDFs(rp.trdfile);
  fdiPanel:
   if rp.fdifile=lp.fdifile then rp.fdiMDFs(rp.fdifile) else
   if FOCUS=right then rp.fdiMDFs(rp.fdifile);
  sclPanel:
   if rp.sclfile=lp.sclfile then rp.sclMDFs(rp.sclfile) else
   if FOCUS=right then rp.sclMDFs(rp.sclfile);
  tapPanel:
   if rp.tapfile=lp.tapfile then rp.tapMDFs(rp.tapfile) else
   if FOCUS=right then rp.tapMDFs(rp.tapfile);
  fddPanel:
   if rp.fddfile=lp.fddfile then rp.fddMDFs(rp.fddfile) else
   if FOCUS=right then rp.fddMDFs(rp.fddfile);
  zxzPanel:
   if rp.zxzfile=lp.zxzfile then rp.zxzMDFs(rp.zxzfile) else
   if FOCUS=right then rp.zxzMDFs(rp.zxzfile);
  flpPanel:
   if rp.flpDrive=lp.flpDrive then rp.flpMDFs(rp.flpDrive) else
   if FOCUS=right then rp.flpMDFs(rp.flpDrive);
{}

 case lPT of
  pcPanel:  lp.pcMDF(lp.pcnd);
  trdPanel: lp.trdMDFs(lp.trdfile);
  fdiPanel: lp.fdiMDFs(lp.fdifile);
  sclPanel: lp.sclMDFs(lp.sclfile);
  tapPanel: lp.tapMDFs(lp.tapfile);
  fddPanel: lp.fddMDFs(lp.fddfile);
  zxzPanel: lp.zxzMDFs(lp.zxzfile);
  flpPanel: lp.flpMDFs(lp.flpDrive);
 end;

 case rPT of
  pcPanel:  rp.pcMDF(rp.pcnd);
  trdPanel: rp.trdMDFs(rp.trdfile);
  fdiPanel: rp.fdiMDFs(rp.fdifile);
  sclPanel: rp.sclMDFs(rp.sclfile);
  tapPanel: rp.tapMDFs(rp.tapfile);
  fddPanel: rp.fddMDFs(rp.fddfile);
  zxzPanel: rp.zxzMDFs(rp.zxzfile);
  flpPanel: rp.flpMDFs(rp.flpDrive);
 end;
{}

end;





{============================================================================}
Procedure reInfo(parts:string);
begin
lp.Info(parts);
rp.Info(parts);
end;




{============================================================================}
Procedure reInside;
begin
lp.Inside; rp.Inside;
end;


{============================================================================}
Procedure reOutside;
begin
lp.Outside; rp.Outside;
end;



{============================================================================}
Procedure reTrueCur;
begin
 case lp.PanelType of
  pcPanel: lp.TrueCur;
 end;
 case rp.PanelType of
  pcPanel: rp.TrueCur;
 end;
end;


{============================================================================}
Procedure reMouse;
Begin
if moused then MouseOff;
if moused then MouseOn;
End;



{============================================================================}
Procedure EscPressed;
Begin
 if Length(Command)>0 then
  begin
   Command:='';
   PutCmdLine;
  end
 else if Esc_ShowUserScr then
  begin
   if Clocked then ClockExitProc;
   if Moused then MouseOff;
   CurOff; SaveScr(1,1,gmaxx,gmaxy); RestBkDesk;
   if Moused then MouseOn;
   rPause;
   if w_animation then begin w_animation:=false; RestScr; w_animation:=true; end else RestScr;
   PutCmdLine;
   if Clocked then Initialise;
  end;
 End;





{============================================================================}
Procedure CancelSB;
Begin
 if lang=rus
  then cstatusbar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,'~`ESC~` Отмена')
  else cstatusbar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,'~`ESC~` Cancel');
End;



{============================================================================}
Procedure ChangeFocus;
Begin
 lp.focused:=not lp.focused;
 rp.focused:=not rp.focused;
 if focus=left then focus:=right else focus:=left;
End;





{============================================================================}
Function PanelTypeOf(w:byte):byte;
Begin
Case w of
 left:  PanelTypeOf:=lp.PanelType;
 right: PanelTypeOf:=rp.PanelType;
End;
End;





{============================================================================}
Function InsedOf(w:byte):word;
Begin
Case w of
 left:  InsedOf:=lp.Insed;
 right: InsedOf:=rp.Insed;
End;
End;




{============================================================================}
Function IndexOf(w:byte):word;
Begin
Case w of
 left:  IndexOf:=lp.Index;
 right: IndexOf:=rp.Index;
End;
End;




{============================================================================}
Function FirstMarkedOf(w:byte):word;
Begin
Case w of
 left:  FirstMarkedOf:=lp.FirstMarked;
 right: FirstMarkedOf:=rp.FirstMarked;
End;
End;




{============================================================================}
Function TrueNameOf(w:byte; i:word):String;
Begin
Case w of
 left:  TrueNameOf:=lp.TrueName(i);
 right: TrueNameOf:=rp.TrueName(i);
End;
End;



{============================================================================}
Function tDirsOf(w:word):word;
Begin
Case w of
 left:  tDirsOf:=lp.tDirs;
 right: tDirsOf:=rp.tDirs;
End;
End;




{============================================================================}
Function tFilesOf(w:word):word;
Begin
Case w of
 left:  tFilesOf:=lp.tFiles;
 right: tFilesOf:=rp.tFiles;
End;
End;





{============================================================================}
Function tDirsFilesOf(w:word):word;
Begin
Case w of
 left:  tDirsFilesOf:=lp.tFiles+lp.tDirs;
 right: tDirsFilesOf:=rp.tFiles+rp.tDirs;
End;
End;



{============================================================================}
Function oFocus:byte;
Begin
if focus=left then oFocus:=right else oFocus:=left;
End;





{============================================================================}
Function pcndOf(w:word):string;
Begin
Case w of
 left:  pcndOf:=lp.pcnd;
 right: pcndOf:=rp.pcnd;
End;
End;



{============================================================================}
Function ViewOf(w:byte; sys:boolean):longint;
Begin
Case w of
 left:  ViewOf:=lp.View(sys);
 right: ViewOf:=rp.View(sys);
End;
End;



{============================================================================}
Function  pcDirPrioryOf(w:byte; ind:word):byte;
Begin
Case w of
 left:  pcDirPrioryOf:=lp.pcDir^[ind].Priory;
 right: pcDirPrioryOf:=rp.pcDir^[ind].Priory;
End;
End;





{============================================================================}
Function  pcDirFAttrOf(w:byte; ind:word):word;
Begin
Case w of
 left:  pcDirFAttrOf:=lp.pcDir^[ind].FAttr;
 right: pcDirFAttrOf:=rp.pcDir^[ind].FAttr;
End;
End;



{============================================================================}
Function  pcDirFdtOf(w:byte; ind:word):longint;
Var
    dt:datetime; ldt:longint;
Begin
Case w of
 left:  dt:=lp.pcDir^[ind].Fdt;
 right: dt:=rp.pcDir^[ind].Fdt;
End;
PackTime(dt,ldt);
pcDirFdtOf:=ldt;
End;



{============================================================================}
Function  pcDirMarkOf(w:byte; ind:word):boolean;
Begin
Case w of
 left:  pcDirMarkOf:=lp.pcDir^[ind].mark;
 right: pcDirMarkOf:=rp.pcDir^[ind].mark;
End;
End;



{============================================================================}
Function  trdDirMarkOf(w:byte; ind:word):boolean;
Begin
Case w of
 left:  trdDirMarkOf:=lp.trdDir^[ind].mark;
 right: trdDirMarkOf:=rp.trdDir^[ind].mark;
End;
End;



{============================================================================}
Function  TreeCOf(w:byte; path:string):byte;
Begin
Case w of
 left:  TreeCOf:=lp.GetTreeC(path);
 right: TreeCOf:=rp.GetTreeC(path);
End;
End;



{============================================================================}
Procedure GetCurXYOf(w:byte; Var x,y:byte);
Begin
Case w of
 left:  lp.GetCurXY(x,y);
 right: rp.GetCurXY(x,y);
End;
End;



{============================================================================}
Function ColumnsOf(w:byte):byte;
Begin
Case w of
 left:  ColumnsOf:=lp.Columns;
 right: ColumnsOf:=rp.Columns;
End;
End;



{============================================================================}
Function FocusedOf(w:byte):boolean;
Begin
Case w of
 left:  FocusedOf:=lp.focused;
 right: FocusedOf:=rp.focused;
End;
End;



{============================================================================}
Procedure Navigate;
Begin
snKernelExitCode:=0;
Case focus of
 Left:
   Begin
    lp.navigate;
   End;
 Right:
   Begin
    rp.navigate;
   End;
End;
End;






End.