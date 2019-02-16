{$O+,F+}
Unit SN_KBD;
Interface
Uses
     rv, Vars;

Var
     fb:file of byte;

Type
     Tkbd=record
          sn_kb1_TAB,      sn_kb2_TAB,
          sn_kb1_EXIT,     sn_kb2_EXIT,
          sn_kb1_SETUP,    sn_kb2_SETUP,
          sn_kb1_CLEAN,    sn_kb2_CLEAN,
          sn_kb1_PACK,     sn_kb2_PACK,
          sn_kb1_HHAR,     sn_kb2_HHAR,
          sn_kb1_LIST,     sn_kb2_LIST,
          sn_kb1_HOBS,     sn_kb2_HOBS,
          sn_kb1_CHBACK,   sn_kb2_CHBACK,
          sn_kb1_CHFORW,   sn_kb2_CHFORW,
          sn_kb1_DESCRIP,  sn_kb2_DESCRIP,
          sn_kb1_ASCIITAB, sn_kb2_ASCIITAB,
          sn_kb1_JOIN,     sn_kb2_JOIN,
          sn_kb1_SAVEND,   sn_kb2_SAVEND,
          sn_kb1_FATTRS,   sn_kb2_FATTRS,
          sn_kb1_TRDOS3,   sn_kb2_TRDOS3,
          sn_kb1_ABOUT,    sn_kb2_ABOUT,
          sn_kb1_USERMENU, sn_kb2_USERMENU,
          sn_kb1_APACK,    sn_kb2_APACK,
          sn_kb1_AUNPACK,  sn_kb2_AUNPACK,
          sn_kb1_LPANEL,   sn_kb2_LPANEL,
          sn_kb1_RPANEL,   sn_kb2_RPANEL,
          sn_kb1_INSERT,   sn_kb2_INSERT,
          sn_kb1_SBYNAME,  sn_kb2_SBYNAME,
          sn_kb1_SBYEXT,   sn_kb2_SBYEXT,
          sn_kb1_SBYLEN,   sn_kb2_SBYLEN,
          sn_kb1_SBYNON,   sn_kb2_SBYNON,
          sn_kb1_VIDEO1,   sn_kb2_VIDEO1,
          sn_kb1_VIDEO2,   sn_kb2_VIDEO2,
          sn_kb1_LPONOFF,  sn_kb2_LPONOFF,
          sn_kb1_RPONOFF,  sn_kb2_RPONOFF,
          sn_kb1_NFPONOFF, sn_kb2_NFPONOFF,
          sn_kb1_BPONOFF,  sn_kb2_BPONOFF,
          sn_kb1_INFO,     sn_kb2_INFO,
          sn_kb1_REREAD,   sn_kb2_REREAD,
          sn_kb1_LFIND,    sn_kb2_LFIND,
          sn_kb1_GFIND,    sn_kb2_GFIND,
          sn_kb1_PCOLUMNS, sn_kb2_PCOLUMNS:   word;
         end;
Var
     kbd: Tkbd;


procedure SaveKBD(nm:string);
procedure LoadKBD;
procedure LoadDefaultKBD;
procedure SetupKBD;

Implementation

procedure SaveKBD(nm:string);
var fw:file of Tkbd; s:string;
Begin
{$I-}
if CheckDir(StartDir+'\KEYS')<>0 then CreateDir(StartDir+'\KEYS\');
assign(fw,StartDir+'\KEYS\'+nm+'.kbd'); rewrite(fw); write(fw,kbd); close(fw);
{$I+}
if IOResult<>0 then;
End;

{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}

procedure LoadKBD;
var fw:file of Tkbd; s:string;
Begin
GetProfile(StartDir+'\sn.ini','Interface','KeyboardFile',s);
if CheckDirFile(StartDir+'\KEYS\'+s)<>0 then exit;
if FileLen(StartDir+'\KEYS\'+s)<>152 then exit;
{$I-}
assign(fw,StartDir+'\KEYS\'+s); filemode:=0; reset(fw); read(fw,kbd); close(fw);
{$I-}
if IOResult<>0 then;
End;

{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}

procedure LoadDefaultKBD;
begin
          kbd.sn_kb1_TAB:=_Tab;         kbd.sn_kb2_TAB:=_Tab;
          kbd.sn_kb1_EXIT:=_AltX;       kbd.sn_kb2_EXIT:=_F10;
          kbd.sn_kb1_SETUP:=_AltF9;     kbd.sn_kb2_SETUP:=_AltF9;
          kbd.sn_kb1_CLEAN:=_AltC;      kbd.sn_kb2_CLEAN:=_AltC;
          kbd.sn_kb1_PACK:=_AltP;       kbd.sn_kb2_PACK:=_AltP;
          kbd.sn_kb1_HHAR:=_AltR;       kbd.sn_kb2_HHAR:=_AltR;
          kbd.sn_kb1_LIST:=_AltL;       kbd.sn_kb2_LIST:=_AltL;
          kbd.sn_kb1_HOBS:=_AltH;       kbd.sn_kb2_HOBS:=_AltH;
          kbd.sn_kb1_CHBACK:=_CtrlE;    kbd.sn_kb2_CHBACK:=_CtrlE;
          kbd.sn_kb1_CHFORW:=_CtrlX;    kbd.sn_kb2_CHFORW:=_CtrlX;
          kbd.sn_kb1_DESCRIP:=_CtrlK;   kbd.sn_kb2_DESCRIP:=_CtrlK;
          kbd.sn_kb1_ASCIITAB:=_CtrlB;  kbd.sn_kb2_ASCIITAB:=_CtrlB;
          kbd.sn_kb1_JOIN:=_CtrlJ;      kbd.sn_kb2_JOIN:=_CtrlJ;
          kbd.sn_kb1_SAVEND:=_AltPlus;  kbd.sn_kb2_SAVEND:=_AltPlus;
          kbd.sn_kb1_FATTRS:=_AltF;     kbd.sn_kb2_FATTRS:=_AltF;
          kbd.sn_kb1_TRDOS3:=_AltT;     kbd.sn_kb2_TRDOS3:=_AltT;
          kbd.sn_kb1_ABOUT:=_F1;        kbd.sn_kb2_ABOUT:=_F1;
          kbd.sn_kb1_USERMENU:=_F2;     kbd.sn_kb2_USERMENU:=_F2;
          kbd.sn_kb1_APACK:=_ShF1;      kbd.sn_kb2_APACK:=_ShF1;
          kbd.sn_kb1_AUNPACK:=_ShF2;    kbd.sn_kb2_AUNPACK:=_ShF2;
          kbd.sn_kb1_LPANEL:=_AltF1;    kbd.sn_kb2_LPANEL:=_AltF1;
          kbd.sn_kb1_RPANEL:=_AltF2;    kbd.sn_kb2_RPANEL:=_AltF2;
          kbd.sn_kb1_INSERT:=_Ins;      kbd.sn_kb2_INSERT:=Pad0;
          kbd.sn_kb1_SBYNAME:=_CtrlF3;  kbd.sn_kb2_SBYNAME:=_CtrlF3;
          kbd.sn_kb1_SBYEXT:=_CtrlF4;   kbd.sn_kb2_SBYEXT:=_CtrlF4;
          kbd.sn_kb1_SBYLEN:=_CtrlF5;   kbd.sn_kb2_SBYLEN:=_CtrlF5;
          kbd.sn_kb1_SBYNON:=_CtrlF6;   kbd.sn_kb2_SBYNON:=_CtrlF6;
          kbd.sn_kb1_VIDEO1:=_AltF10;   kbd.sn_kb2_VIDEO1:=_AltF10;
          kbd.sn_kb1_VIDEO2:=_CtrlF10;  kbd.sn_kb2_VIDEO2:=_CtrlF10;
          kbd.sn_kb1_LPONOFF:=_CtrlF1;  kbd.sn_kb2_LPONOFF:=_CtrlF1;
          kbd.sn_kb1_RPONOFF:=_CtrlF2;  kbd.sn_kb2_RPONOFF:=_CtrlF2;
          kbd.sn_kb1_NFPONOFF:=_CtrlP;  kbd.sn_kb2_NFPONOFF:=_CtrlP;
          kbd.sn_kb1_BPONOFF:=_CtrlO;   kbd.sn_kb2_BPONOFF:=_CtrlO;
          kbd.sn_kb1_INFO:=_CtrlL;      kbd.sn_kb2_INFO:=_CtrlL;
          kbd.sn_kb1_REREAD:=_CtrlR;    kbd.sn_kb2_REREAD:=_CtrlR;
          kbd.sn_kb1_LFIND:=_AltS;      kbd.sn_kb2_LFIND:=_AltS;
          kbd.sn_kb1_GFIND:=_AltF7;     kbd.sn_kb2_GFIND:=_AltF7;
          kbd.sn_kb1_PCOLUMNS:=_CtrlV;  kbd.sn_kb2_PCOLUMNS:=_CtrlV;
end;

{============================================================================}
{============================================================================}
{============================================================================}
{============================================================================}

const l=14;


function WhatKey(key:word):string;
var KeyName:string[l];
Begin
KeyName:='';

(* Function keys *)
if key=_f1 then KeyName:='F1';
if key=_f2 then KeyName:='F2';
if key=_f3 then KeyName:='F3';
if key=_f4 then KeyName:='F4';
if key=_f5 then KeyName:='F5';
if key=_f6 then KeyName:='F6';
if key=_f7 then KeyName:='F7';
if key=_f8 then KeyName:='F8';
if key=_f9 then KeyName:='F9';
if key=_f10 then KeyName:='F10';

if key=_Shf1 then KeyName:='Shift+F1';
if key=_Shf2 then KeyName:='Shift+F2';
if key=_Shf3 then KeyName:='Shift+F3';
if key=_Shf4 then KeyName:='Shift+F4';
if key=_Shf5 then KeyName:='Shift+F5';
if key=_Shf6 then KeyName:='Shift+F6';
if key=_Shf7 then KeyName:='Shift+F7';
if key=_Shf8 then KeyName:='Shift+F8';
if key=_Shf9 then KeyName:='Shift+F9';
if key=_Shf10 then KeyName:='Shift+F10';

if key=_Ctrlf1 then KeyName:='Ctrl+F1';
if key=_Ctrlf2 then KeyName:='Ctrl+F2';
if key=_Ctrlf3 then KeyName:='Ctrl+F3';
if key=_Ctrlf4 then KeyName:='Ctrl+F4';
if key=_Ctrlf5 then KeyName:='Ctrl+F5';
if key=_Ctrlf6 then KeyName:='Ctrl+F6';
if key=_Ctrlf7 then KeyName:='Ctrl+F7';
if key=_Ctrlf8 then KeyName:='Ctrl+F8';
if key=_Ctrlf9 then KeyName:='Ctrl+F9';
if key=_Ctrlf10 then KeyName:='Ctrl+F10';

if key=_Altf1 then KeyName:='Alt+F1';
if key=_Altf2 then KeyName:='Alt+F2';
if key=_Altf3 then KeyName:='Alt+F3';
if key=_Altf4 then KeyName:='Alt+F4';
if key=_Altf5 then KeyName:='Alt+F5';
if key=_Altf6 then KeyName:='Alt+F6';
if key=_Altf7 then KeyName:='Alt+F7';
if key=_Altf8 then KeyName:='Alt+F8';
if key=_Altf9 then KeyName:='Alt+F9';
if key=_Altf10 then KeyName:='Alt+F10';

(* Numeric keypad *)
if key=Pad8 then KeyName:='Pad8'; if key=ShPad8 then KeyName:='Shift+Pad8'; if key=Ctrlpad8 then KeyName:='Ctrl+Pad8';
if key=Pad2 then KeyName:='Pad2'; if key=ShPad2 then KeyName:='Shift+Pad2'; if key=Ctrlpad2 then KeyName:='Ctrl+Pad2';
if key=Pad4 then KeyName:='Pad4'; if key=ShPad4 then KeyName:='Shift+Pad4'; if key=Ctrlpad4 then KeyName:='Ctrl+Pad4';
if key=Pad6 then KeyName:='Pad6'; if key=ShPad6 then KeyName:='Shift+Pad6'; if key=Ctrlpad6 then KeyName:='Ctrl+Pad6';
if key=Pad5 then KeyName:='Pad5'; if key=ShPad5 then KeyName:='Shift+Pad5'; if key=Ctrlpad5 then KeyName:='Ctrl+Pad5';
if key=Pad0 then KeyName:='Pad0'; if key=ShPad0 then KeyName:='Shift+Pad0'; if key=Ctrlpad0 then KeyName:='Ctrl+Pad0';

if key=PadDel then KeyName:='PadDel';
if key=ShPadDel then KeyName:='Shift+PadDel';
if key=CtrlpadDel then KeyName:='Ctrl+PadDel';
if key=PadMinus then KeyName:='PadMinus';
if key=CtrlpadMinus then KeyName:='Ctrl+Pad-';
if key=PadPlus then KeyName:='PadPlus';
if key=CtrlpadPlus then KeyName:='Ctrl+Pad+';
if key=PadStar then KeyName:='PadStar';
if key=CtrlpadStar then KeyName:='Ctrl+Pad*';
if key=PadEnter then KeyName:='PadEnter';
if key=CtrlpadEnter then KeyName:='Ctrl+PadEnter';
if key=PadSlash then KeyName:='PadSlash';
if key=CtrlpadSlash then KeyName:='Ctrl+Pad/';

(* Cursor keys *)
if key=_Up then KeyName:='Up'; if key=_CtrlUp then KeyName:='Ctrl+Up'; if key=_AltUp then KeyName:='Alt+Up';
if key=_Down then KeyName:='Down'; if key=_CtrlDown then KeyName:='Ctrl+Down'; if key=_AltDown then KeyName:='Alt+Down';
if key=_Left then KeyName:='Left'; if key=_CtrlLeft then KeyName:='Ctrl+Left'; if key=_AltLeft then KeyName:='Alt+Left';
if key=_Right then KeyName:='Right'; if key=_CtrlRight then KeyName:='Ctrl+Right';
                                     if key=_AltRight then KeyName:='Alt+Right';

if key=_Home then KeyName:='Home';
if key=_ShHome then KeyName:='Shift+Home';
if key=_CtrlHome then KeyName:='Ctrl+Home';
if key=_AltHome then KeyName:='Alt+Home';

if key=_End then KeyName:='End';
if key=_ShEnd then KeyName:='Shift+End';
if key=_CtrlEnd then KeyName:='Ctrl+End';
if key=_AltEnd then KeyName:='Alt+End';

if key=_PgUp then KeyName:='PgUp';
if key=_ShPgUp then KeyName:='Shift+PgUp';
if key=_CtrlPgUp then KeyName:='Ctrl+PgUp';
if key=_AltPgUp then KeyName:='Alt+PgUp';

if key=_PgDn then KeyName:='PgDn';
if key=_ShPgDn then KeyName:='Shift+PgDn';
if key=_CtrlPgDn then KeyName:='Ctrl+PgDn';
if key=_AltPgDn then KeyName:='Alt+PgDn';

if key=_Ins then KeyName:='Ins';
if key=_ShIns then KeyName:='Shift+Ins';
if key=_CtrlIns then KeyName:='Ctrl+Ins';
if key=_AltIns then KeyName:='Alt+Ins';

if key=_Del then KeyName:='Del';
if key=_ShDel then KeyName:='Shift+Del';
if key=_CtrlDel then KeyName:='Ctrl+Del';
if key=_AltDel then KeyName:='Alt+Del';

(* Alphabetic keys *)

if key=_LowA then KeyName:='a'; if key=_UpA then KeyName:='A';
if key=_CtrlA then KeyName:='Ctrl+A'; if key=_AltA then KeyName:='Alt+A';

if key=_LowB then KeyName:='b'; if key=_UpB then KeyName:='B';
if key=_CtrlB then KeyName:='Ctrl+B'; if key=_AltB then KeyName:='Alt+B';

if key=_LowC then KeyName:='c'; if key=_UpC then KeyName:='C';
if key=_CtrlC then KeyName:='Ctrl+C'; if key=_AltC then KeyName:='Alt+C';

if key=_LowD then KeyName:='d'; if key=_UpD then KeyName:='D';
if key=_CtrlD then KeyName:='Ctrl+D'; if key=_AltD then KeyName:='Alt+D';

if key=_LowE then KeyName:='e'; if key=_UpE then KeyName:='E';
if key=_CtrlE then KeyName:='Ctrl+E'; if key=_AltE then KeyName:='Alt+E';

if key=_LowF then KeyName:='f'; if key=_UpF then KeyName:='F';
if key=_CtrlF then KeyName:='Ctrl+F'; if key=_AltF then KeyName:='Alt+F';

if key=_LowG then KeyName:='g'; if key=_UpG then KeyName:='G';
if key=_CtrlG then KeyName:='Ctrl+G'; if key=_AltG then KeyName:='Alt+G';

if key=_LowH then KeyName:='h'; if key=_UpH then KeyName:='H';
if key=_CtrlH then KeyName:='Ctrl+H'; if key=_AltH then KeyName:='Alt+H';

if key=_LowI then KeyName:='i'; if key=_UpI then KeyName:='I';
if key=_CtrlI then KeyName:='Ctrl+I'; if key=_AltI then KeyName:='Alt+I';

if key=_LowJ then KeyName:='j'; if key=_UpJ then KeyName:='J';
if key=_CtrlJ then KeyName:='Ctrl+J'; if key=_AltJ then KeyName:='Alt+J';

if key=_LowK then KeyName:='k'; if key=_UpK then KeyName:='K';
if key=_CtrlK then KeyName:='Ctrl+K'; if key=_AltK then KeyName:='Alt+K';

if key=_LowL then KeyName:='l'; if key=_UpL then KeyName:='L';
if key=_CtrlL then KeyName:='Ctrl+L'; if key=_AltL then KeyName:='Alt+L';

if key=_LowM then KeyName:='m'; if key=_UpM then KeyName:='M';
if key=_CtrlM then KeyName:='Ctrl+M'; if key=_AltM then KeyName:='Alt+M';

if key=_LowN then KeyName:='n'; if key=_UpG then KeyName:='N';
if key=_CtrlN then KeyName:='Ctrl+N'; if key=_AltN then KeyName:='Alt+N';

if key=_LowO then KeyName:='o'; if key=_UpO then KeyName:='O';
if key=_CtrlO then KeyName:='Ctrl+O'; if key=_AltO then KeyName:='Alt+O';

if key=_LowP then KeyName:='p'; if key=_UpP then KeyName:='P';
if key=_CtrlP then KeyName:='Ctrl+P'; if key=_AltP then KeyName:='Alt+P';

if key=_LowR then KeyName:='r'; if key=_UpR then KeyName:='R';
if key=_CtrlR then KeyName:='Ctrl+R'; if key=_AltR then KeyName:='Alt+R';

if key=_LowS then KeyName:='s'; if key=_UpS then KeyName:='S';
if key=_CtrlS then KeyName:='Ctrl+S'; if key=_AltS then KeyName:='Alt+S';

if key=_LowT then KeyName:='t'; if key=_UpT then KeyName:='T';
if key=_CtrlT then KeyName:='Ctrl+T'; if key=_AltT then KeyName:='Alt+T';

if key=_LowU then KeyName:='u'; if key=_UpU then KeyName:='U';
if key=_CtrlU then KeyName:='Ctrl+U'; if key=_AltU then KeyName:='Alt+U';

if key=_LowV then KeyName:='v'; if key=_UpV then KeyName:='V';
if key=_CtrlV then KeyName:='Ctrl+V'; if key=_AltV then KeyName:='Alt+V';

if key=_LowW then KeyName:='w'; if key=_UpW then KeyName:='W';
if key=_CtrlW then KeyName:='Ctrl+W'; if key=_AltW then KeyName:='Alt+W';

if key=_LowX then KeyName:='x'; if key=_UpX then KeyName:='X';
if key=_CtrlX then KeyName:='Ctrl+X'; if key=_AltX then KeyName:='Alt+X';

if key=_LowY then KeyName:='y'; if key=_UpY then KeyName:='Y';
if key=_CtrlY then KeyName:='Ctrl+Y'; if key=_AltY then KeyName:='Alt+Y';

if key=_LowZ then KeyName:='z'; if key=_UpZ then KeyName:='Z';
if key=_CtrlZ then KeyName:='Ctrl+Z'; if key=_AltZ then KeyName:='Alt+Z';


(* Number keys, on top row of keyboard *)
if key=_Num1 then KeyName:='1'; if key=_ShNum1 then KeyName:='Shift+1';
if key=_Alt1 then KeyName:='Alt+1';

if key=_Num2 then KeyName:='2'; if key=_ShNum2 then KeyName:='Shift+2';
if key=_Ctrl2 then KeyName:='Ctrl+2';
if key=_Alt2 then KeyName:='Alt+2';

if key=_Num3 then KeyName:='3'; if key=_ShNum3 then KeyName:='Shift+3';
if key=_Alt3 then KeyName:='Alt+3';

if key=_Num4 then KeyName:='4'; if key=_ShNum4 then KeyName:='Shift+4';
if key=_Alt4 then KeyName:='Alt+4';

if key=_Num5 then KeyName:='5'; if key=_ShNum5 then KeyName:='Shift+5';
if key=_Alt5 then KeyName:='Alt+5';

if key=_Num6 then KeyName:='6'; if key=_ShNum6 then KeyName:='Shift+6';
if key=_Ctrl6 then KeyName:='Ctrl+6';
if key=_Alt6 then KeyName:='Alt+6';

if key=_Num7 then KeyName:='7'; if key=_ShNum7 then KeyName:='Shift+7';
if key=_Alt7 then KeyName:='Alt+7';

if key=_Num8 then KeyName:='8'; if key=_ShNum8 then KeyName:='Shift+8';
if key=_Alt8 then KeyName:='Alt+8';

if key=_Num9 then KeyName:='9'; if key=_ShNum9 then KeyName:='Shift+9';
if key=_Alt9 then KeyName:='Alt+9';

if key=_Num0 then KeyName:='0'; if key=_ShNum0 then KeyName:='Shift+0';
if key=_Alt0 then KeyName:='Alt+0';

(* Miscellaneous *)
if key=_Space then KeyName:='SPACE';

if key=_BkSp then KeyName:='BkSp';
if key=_CtrlBkSp then KeyName:='Ctrl+BkSp';
if key=_AltBkSp then KeyName:='Alt+BkSp';

if key=_Tab then KeyName:='TAB';
if key=_ShTab then KeyName:='Shift+TAB';
if key=_CtrlTab then KeyName:='Ctrl+TAB';
if key=_AltTab then KeyName:='Alt+TAB';

if key=_Enter then KeyName:='ENTER';
if key=_CtrlEnter then KeyName:='Ctrl+ENTER';
if key=_AltEnter then KeyName:='Alt+ENTER';

if key=_Esc then KeyName:='ESC';
if key=_AltEsc then KeyName:='Alt+ESC';

if key=_Tilda then KeyName:='Tilda';
if key=_ShTilda then KeyName:='Shift+Tilda';
if key=_AltEnter then KeyName:='Alt+Tilda';

if key=_OpScob then KeyName:='[';
if key=_ShOpScob then KeyName:='Shift+"["';
if key=_CtrlOpScob then KeyName:='Ctrl+"["';
if key=_AltOpScob then KeyName:='Alt+"["';

if key=_ClScob then KeyName:=']';
if key=_ShClScob then KeyName:='Shift+"]"';
if key=_CtrlClScob then KeyName:='Ctrl+"]"';
if key=_AltClScob then KeyName:='Alt+"]"';

if key=_BkSlash then KeyName:='\';
if key=_ShBkSlash then KeyName:='Shift+"\"';
if key=_CtrlBkSlash then KeyName:='Ctrl+"\"';
if key=_AltBkSlash then KeyName:='Alt+"\"';

if key=_Slash then KeyName:='/';
if key=_ShSlash then KeyName:='Shift+"/"';
if key=_AltSlash then KeyName:='Alt+"/"';

if key=_Minus then KeyName:='-';
if key=_CtrlMinus then KeyName:='Ctrl+"-"';
if key=_AltMinus then KeyName:='Alt+"-"';

if key=_Plus then KeyName:='+';
if key=_AltPlus then KeyName:='Alt+"+"';

if key=_Star then KeyName:='*';

WhatKey:=KeyName;
End;


procedure SetupKBD;
var i,z1,z2,y,k:word; s,t:string;
label beg;


procedure ps(c,x,n:byte);
begin
 PrintSelf(menu_bkNT,menu_txtNT+c,x,y-4,n);
 PrintSelf(menu_bkNT,menu_txtNT+c,x,y-3,n);
 PrintSelf(menu_bkNT,menu_txtNT+c,x,y-2,n);
 PrintSelf(menu_bkNT,menu_txtNT+c,x,y-1,n);
 PrintSelf(menu_bkNT,menu_txtNT+c,x,y-0,n);
end;


procedure Exchange(n:byte; z1,z2:word);
begin
 Case n of
  1:  begin kbd.sn_kb1_TAB:=z1;       kbd.sn_kb2_TAB:=z2;      end;
  2:  begin kbd.sn_kb1_EXIT:=z1;      kbd.sn_kb2_EXIT:=z2;     end;
  3:  begin kbd.sn_kb1_SETUP:=z1;     kbd.sn_kb2_SETUP:=z2;    end;
  4:  begin kbd.sn_kb1_CLEAN:=z1;     kbd.sn_kb2_CLEAN:=z2;    end;
  5:  begin kbd.sn_kb1_PACK:=z1;      kbd.sn_kb2_PACK:=z2;     end;
  6:  begin kbd.sn_kb1_HHAR:=z1;      kbd.sn_kb2_HHAR:=z2;     end;
  7:  begin kbd.sn_kb1_LIST:=z1;      kbd.sn_kb2_LIST:=z2;     end;
  8:  begin kbd.sn_kb1_HOBS:=z1;      kbd.sn_kb2_HOBS:=z2;     end;
  9:  begin kbd.sn_kb1_CHBACK:=z1;    kbd.sn_kb2_CHBACK:=z2;   end;
  10: begin kbd.sn_kb1_CHFORW:=z1;    kbd.sn_kb2_CHFORW:=z2;   end;
  11: begin kbd.sn_kb1_DESCRIP:=z1;   kbd.sn_kb2_DESCRIP:=z2;  end;
  12: begin kbd.sn_kb1_ASCIITAB:=z1;  kbd.sn_kb2_ASCIITAB:=z2; end;
  13: begin kbd.sn_kb1_JOIN:=z1;      kbd.sn_kb2_JOIN:=z2;     end;
  14: begin kbd.sn_kb1_SAVEND:=z1;    kbd.sn_kb2_SAVEND:=z2;   end;
  15: begin kbd.sn_kb1_FATTRS:=z1;    kbd.sn_kb2_FATTRS:=z2;   end;
  16: begin kbd.sn_kb1_TRDOS3:=z1;    kbd.sn_kb2_TRDOS3:=z2;   end;
  17: begin kbd.sn_kb1_ABOUT:=z1;     kbd.sn_kb2_ABOUT:=z2;    end;
  18: begin kbd.sn_kb1_USERMENU:=z1;  kbd.sn_kb2_USERMENU:=z2; end;
  19: begin kbd.sn_kb1_APACK:=z1;     kbd.sn_kb2_APACK:=z2;    end;
  20: begin kbd.sn_kb1_AUNPACK:=z1;   kbd.sn_kb2_AUNPACK:=z2;  end;
  21: begin kbd.sn_kb1_LPANEL:=z1;    kbd.sn_kb2_LPANEL:=z2;   end;
  22: begin kbd.sn_kb1_RPANEL:=z1;    kbd.sn_kb2_RPANEL:=z2;   end;
  23: begin kbd.sn_kb1_INSERT:=z1;    kbd.sn_kb2_INSERT:=z2;   end;
  24: begin kbd.sn_kb1_SBYNAME:=z1;   kbd.sn_kb2_SBYNAME:=z2;  end;
  25: begin kbd.sn_kb1_SBYEXT:=z1;    kbd.sn_kb2_SBYEXT:=z2;   end;
  26: begin kbd.sn_kb1_SBYLEN:=z1;    kbd.sn_kb2_SBYLEN:=z2;   end;
  27: begin kbd.sn_kb1_SBYNON:=z1;    kbd.sn_kb2_SBYNON:=z2;   end;
  28: begin kbd.sn_kb1_VIDEO1:=z1;    kbd.sn_kb2_VIDEO1:=z2;   end;
  29: begin kbd.sn_kb1_VIDEO2:=z1;    kbd.sn_kb2_VIDEO2:=z2;   end;
  30: begin kbd.sn_kb1_LPONOFF:=z1;   kbd.sn_kb2_LPONOFF:=z2;  end;
  31: begin kbd.sn_kb1_RPONOFF:=z1;   kbd.sn_kb2_RPONOFF:=z2;  end;
  32: begin kbd.sn_kb1_NFPONOFF:=z1;  kbd.sn_kb2_NFPONOFF:=z2; end;
  33: begin kbd.sn_kb1_BPONOFF:=z1;   kbd.sn_kb2_BPONOFF:=z2;  end;
  34: begin kbd.sn_kb1_INFO:=z1;      kbd.sn_kb2_INFO:=z2;     end;
  35: begin kbd.sn_kb1_REREAD:=z1;    kbd.sn_kb2_REREAD:=z2;   end;
  36: begin kbd.sn_kb1_LFIND:=z1;     kbd.sn_kb2_LFIND:=z2;    end;
  37: begin kbd.sn_kb1_GFIND:=z1;     kbd.sn_kb2_GFIND:=z2;    end;
  38: begin kbd.sn_kb1_PCOLUMNS:=z1;  kbd.sn_kb2_PCOLUMNS:=z2; end;
 End;
{message(strr(n)+' '+whatkey(kbd.sn_kb1_ABOUT));{}
{message(strr(n)+' '+whatkey(z1));{}
end;


begin
menu_f:=1;
beg:
s:=WhatKey(kbd.sn_kb1_TAB); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_TAB); t:=t+space(l-length(t));
if LANG=rus then menu_name[1 ]:='Переключение между панелями            '+s+' '+t
            else menu_name[1 ]:='Switch panels                          '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_EXIT); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_EXIT); t:=t+space(l-length(t));
if LANG=rus then menu_name[2 ]:='Выход из программы                     '+s+' '+t
            else menu_name[2 ]:='Exit programm                          '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SETUP); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SETUP); t:=t+space(l-length(t));
if LANG=rus then menu_name[3 ]:='Настройки                              '+s+' '+t
            else menu_name[3 ]:='Setup                                  '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_CLEAN); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_CLEAN); t:=t+space(l-length(t));
if LANG=rus then menu_name[4 ]:='Функция TRD_clean                      '+s+' '+t
            else menu_name[4 ]:='Function TRD_clean                     '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_PACK); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_PACK); t:=t+space(l-length(t));
if LANG=rus then menu_name[5 ]:='Функция TRD_pack                       '+s+' '+t
            else menu_name[5 ]:='Function TRD_pack                      '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_HHAR); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_HHAR); t:=t+space(l-length(t));
if LANG=rus then menu_name[6 ]:='Функция HH Add/Remove                  '+s+' '+t
            else menu_name[6 ]:='Function HH Add/Remove                 '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_LIST); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_LIST); t:=t+space(l-length(t));
if LANG=rus then menu_name[7 ]:='Функция TRD_list                       '+s+' '+t
            else menu_name[7 ]:='Function TRD_list                      '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_HOBS); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_HOBS); t:=t+space(l-length(t));
if LANG=rus then menu_name[8 ]:='Поиск хобетных файлов                  '+s+' '+t
            else menu_name[8 ]:='Search hobeta files                    '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_CHBACK); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_CHBACK); t:=t+space(l-length(t));
if LANG=rus then menu_name[9 ]:='Прокрутка истории команд назад         '+s+' '+t
            else menu_name[9 ]:='Command history back                   '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_CHFORW); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_CHFORW); t:=t+space(l-length(t));
if LANG=rus then menu_name[10]:='Прокрутка истории команд вперед        '+s+' '+t
            else menu_name[10]:='Command history forward                '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_DESCRIP); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_DESCRIP); t:=t+space(l-length(t));
if LANG=rus then menu_name[11]:='Описания                               '+s+' '+t
            else menu_name[11]:='Desсriptions                           '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_ASCIITAB); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_ASCIITAB); t:=t+space(l-length(t));
if LANG=rus then menu_name[12]:='Вызов таблицы ASCII                    '+s+' '+t
            else menu_name[12]:='ASCII table                            '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_JOIN); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_JOIN); t:=t+space(l-length(t));
if LANG=rus then menu_name[13]:='Объединение файлов                     '+s+' '+t
            else menu_name[13]:='Join files                             '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SAVEND); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SAVEND); t:=t+space(l-length(t));
if LANG=rus then menu_name[14]:='Запомнить текущую директорию           '+s+' '+t
            else menu_name[14]:='Store current directory                '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_FATTRS); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_FATTRS); t:=t+space(l-length(t));
if LANG=rus then menu_name[15]:='Атрибуты файлов                        '+s+' '+t
            else menu_name[15]:='File attributes                        '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_TRDOS3); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_TRDOS3); t:=t+space(l-length(t));
if LANG=rus then menu_name[16]:='Включение/выключение режима TRDOS3     '+s+' '+t
            else menu_name[16]:='TRDOS3 mode toggle                     '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_ABOUT); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_ABOUT); t:=t+space(l-length(t));
if LANG=rus then menu_name[17]:='О программе...                         '+s+' '+t
            else menu_name[17]:='About...                               '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_USERMENU); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_USERMENU); t:=t+space(l-length(t));
if LANG=rus then menu_name[18]:='Вызов пользовательского меню           '+s+' '+t
            else menu_name[18]:='Call user menu                         '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_APACK); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_APACK); t:=t+space(l-length(t));
if LANG=rus then menu_name[19]:='Вызов архиватора                       '+s+' '+t
            else menu_name[19]:='Call archiver                          '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_AUNPACK); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_AUNPACK); t:=t+space(l-length(t));
if LANG=rus then menu_name[20]:='Вызов распаковщика                     '+s+' '+t
            else menu_name[20]:='Call unpacker                          '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_LPANEL); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_LPANEL); t:=t+space(l-length(t));
if LANG=rus then menu_name[21]:='Выбор устройства левой панели          '+s+' '+t
            else menu_name[21]:='Choose drive of left panel             '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_RPANEL); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_RPANEL); t:=t+space(l-length(t));
if LANG=rus then menu_name[22]:='Выбор устройства правой панели         '+s+' '+t
            else menu_name[22]:='Choose drive of right panel            '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_INSERT); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_INSERT); t:=t+space(l-length(t));
if LANG=rus then menu_name[23]:='Отметить файл                          '+s+' '+t
            else menu_name[23]:='Mark file                              '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SBYNAME); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SBYNAME); t:=t+space(l-length(t));
if LANG=rus then menu_name[24]:='Сортировка по имени                    '+s+' '+t
            else menu_name[24]:='Sorting by name                        '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SBYEXT); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SBYEXT); t:=t+space(l-length(t));
if LANG=rus then menu_name[25]:='Сортировка по расширению               '+s+' '+t
            else menu_name[25]:='Sorting by extention                   '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SBYLEN); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SBYLEN); t:=t+space(l-length(t));
if LANG=rus then menu_name[26]:='Сортировка по длине файла              '+s+' '+t
            else menu_name[26]:='Sorting by file length                 '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_SBYNON); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_SBYNON); t:=t+space(l-length(t));
if LANG=rus then menu_name[27]:='Без сортировки                         '+s+' '+t
            else menu_name[27]:='Without any sorting                    '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_VIDEO1); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_VIDEO1); t:=t+space(l-length(t));
if LANG=rus then menu_name[28]:='Переключение 25/30 строк               '+s+' '+t
            else menu_name[28]:='Toggle 25/30 video mode                '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_VIDEO2); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_VIDEO2); t:=t+space(l-length(t));
if LANG=rus then menu_name[29]:='Переключение 25/50 строк               '+s+' '+t
            else menu_name[29]:='Tjggle 25/50 video mode                '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_LPONOFF); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_LPONOFF); t:=t+space(l-length(t));
if LANG=rus then menu_name[30]:='Включение/выключение левой панели      '+s+' '+t
            else menu_name[30]:='Left panel on/off                      '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_RPONOFF); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_RPONOFF); t:=t+space(l-length(t));
if LANG=rus then menu_name[31]:='Включение/выключение правой панели     '+s+' '+t
            else menu_name[31]:='Right panel on/off                     '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_NFPONOFF); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_NFPONOFF); t:=t+space(l-length(t));
if LANG=rus then menu_name[32]:='Включение/выключение неактивной панели '+s+' '+t
            else menu_name[32]:='Not active panel on/off                '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_BPONOFF); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_BPONOFF); t:=t+space(l-length(t));
if LANG=rus then menu_name[33]:='Включение/выключение обоих панелей     '+s+' '+t
            else menu_name[33]:='Both panels on/off                     '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_INFO); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_INFO); t:=t+space(l-length(t));
if LANG=rus then menu_name[34]:='Показать информацию                    '+s+' '+t
            else menu_name[34]:='Show panel information                 '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_REREAD); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_REREAD); t:=t+space(l-length(t));
if LANG=rus then menu_name[35]:='Перечитать директорию                  '+s+' '+t
            else menu_name[35]:='Reread directory                       '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_LFIND); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_LFIND); t:=t+space(l-length(t));
if LANG=rus then menu_name[36]:='Локальный поиск                        '+s+' '+t
            else menu_name[36]:='Local files search                     '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_GFIND); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_GFIND); t:=t+space(l-length(t));
if LANG=rus then menu_name[37]:='Глобальный поиск                       '+s+' '+t
            else menu_name[37]:='Global files search                    '+s+' '+t;

s:=WhatKey(kbd.sn_kb1_PCOLUMNS); s:=s+space(l-length(s));
t:=WhatKey(kbd.sn_kb2_PCOLUMNS); t:=t+space(l-length(t));
if LANG=rus then menu_name[38]:='Переключение кол-ва колонок панели     '+s+' '+t
            else menu_name[38]:='Switch columns of panel                '+s+' '+t;

menu_total:=38; menu_visible:=gmaxy-2;
if LANG=rus then menu_title:='             Действие                 1-ое значение  2-ое значение'
            else menu_title:='             Operation                1-st value     2-nd value   ';

i:=ChooseItem;
if i<>0 then
 Begin
  CurOff; Colour(menu_bkNT,menu_txtNT); {if Moused then MouseOff;{}
  y:=halfmaxy;
  w_twosided:=true;

  scPutWin(menu_bkNT,menu_txtNT,20,y-6,61,y+1);

  flash(off);
  cmCentre(menu_bkST,menu_txtST,y-5,nospaceLR(copy(menu_name[i],1,39)));
  if LANG=rus then cmPrint(menu_bkNT,menu_txtNT,24,y-3,'1-ое значение:')
              else cmPrint(menu_bkNT,menu_txtNT,24,y-3,'1-st value:   ');
  if LANG=rus then cmPrint(menu_bkNT,menu_txtNT,44,y-3,'2-ое значение:')
              else cmPrint(menu_bkNT,menu_txtNT,44,y-3,'2-nd value:   ');
  cmPrint(menu_bkNT,menu_txtNT,26,y-1,copy(menu_name[i],40,12));
  cmPrint(menu_bkNT,menu_txtNT,46,y-1,copy(menu_name[i],55,12));

  ps(128,22,18);
  k:=KeyCode;
  z1:=k;
  cmPrint(menu_bkNT,menu_txtNT,26,y-1,WhatKey(z1)+space(l-length(WhatKey(z1))));

  ps(0,22,18);
  ps(128,42,18);
  k:=KeyCode;
  if k=_ESC then z2:=z1 else z2:=k;
  cmPrint(menu_bkNT,menu_txtNT,46,y-1,WhatKey(z2)+space(l-length(WhatKey(z2))));

  ps(0,42,18);
  flash(off);

  rPause;
  RestScr;
  w_twosided:=false;


  Exchange(i,z1,z2);
  goto beg;
 End;

end;

end.
