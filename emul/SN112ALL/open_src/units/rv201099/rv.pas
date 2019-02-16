{$I-,R-,F+,O+}
Unit RV;
Interface

uses dos, crt, strings, mouse;

{===== CRT SECTION =====}
Const
     On=1;    Off=0;
     Rus=1;   Eng=2;
     Left=1;  Right=2;
     DaysRus   :array [0..6] of String[11] =
('Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота');
     DaysEng   :array [0..6] of String[11] =
('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');
Var

   GmaxX,GmaxY          :byte;
   HalfMaxX,HalfMaxY    :byte;
   OldMaxX,OldMaxY      :byte;
   SavedCurX,SavedCurY  :byte;

  Regs          : registers;
  TotalRAM,
  AvailRAM,
  TotalXMS,
  PagesInst,
  PagesAvail,
  TotalEXP,
  AvailEXP,
  SystemEXP,
  OtherEXP,
  i,NumHandles  : word;
  EXTInfo,
  EXPInstalled  : boolean;
  EXPVersion    : string;
  PList         : array[1..512] of record
                                     Handle,Pages: word;
                                   end;



procedure Cls;
procedure ClrBox        (x1,y1,x2,y2:byte);
procedure Colour        (paper,ink : byte);

procedure Print         (x,y:byte; s:string);
procedure MPrint        (x,y:byte; s:string);
procedure CMPrint       (paper,ink,x,y:word; s:string);
procedure PrintSelf     (paper,ink,x,y,len:byte);
procedure MWrite        (s:string);
procedure CMWrite       (paper,ink:byte; s:string);
procedure Centre        (y:byte; s:string);
procedure MCentre       (y:byte; s:string);
procedure CMCentre      (paper,ink,y:byte; s:string);

procedure GotoXY        (x,y:Byte);
function  MaxX          :Byte;
function  MaxY          :Byte;
function  WhereX        :Byte;
function  WhereY        :Byte;
function  GetXY         (x,y:Byte):Char;

procedure Set80x25;
procedure Set80x28;
procedure Set80x30;
procedure Set80x43;
procedure Set80x50;
procedure Set132x25;
procedure Set132x28;
procedure Set132x50;
procedure SetTextMode   (mx,my:byte);
procedure SaveTextMode;
procedure RestTextMode;
procedure GetCurTextMode;

procedure CurOn;
procedure CurOff;
procedure SaveCur;
procedure RestCur;
procedure WaitKey;

function  CurDateTime(lan:byte)   :string;
function  CurDate       :string;
function  CurDay(lan:byte)        :string;
function  CurTime       :string;

procedure Flash         (OffOn:byte);
procedure Border        (colour:Byte);
procedure Ring;
procedure Beep          (ton,len:integer);
procedure Wait          (Seconds:Word);
procedure rPause;
function  Bit           (n,b:byte):boolean;

function  GetCursor     :word;
procedure SetCursor     (curs:word);

function  longHi        (num:longint):word;
function  longLo        (num:longint):word;


{===== DOS SECTION =====}

Const
    _dir=1; _name=2; _ext=3;
Type
    CpuType=(c8088,c8086,c80286,c80386,c80486,Pentium,PentiumPRO);
function LZ(w:Word):String;
function LZZ(w:Word):String;
function GetOf(fullpath:string; what:byte):string;

function RunBy:string;

function DiskStatus(drive:byte):byte;
function IsDriveValid(cDrive: Char; Var bLocal, bSUBST: Boolean): Boolean;
function GetAllDrivers:string;
function CheckDrv(drv:char):byte;
function CheckDir(direct:string):byte;
function CheckFile(myfile:string):byte;
function CheckDirFile(fullname:string):byte;
function CheckWrite(drv:char):boolean;

function FileTime(FileName: string): string;
function FileDate(FileName: string): string;
function FileLen(FileName: string): longint;

function GetVolSerialNo(DriveNo:Byte): string;
function GetVolName(DriveNo:Byte): string;
Function CreateDir(full:string):byte;
function CurentDir:string;

function GetProfile(filename,group,key:string; var str:string):byte;
function WriteProfile(filename,group,key,str:string):byte;

function CpuID(var cpun:integer) : string;
function CpuCLK:string;
Function EMM_Installed: Boolean;
Function XMS_Installed: Boolean;
procedure GetTotalMemoryInfo;

function FindFile(findfilename:string):string;

procedure FileCreate(f:string);
procedure FileDelete(fn:string);
procedure MakeFile(name:string; bytes:longint; code:byte);

procedure Str2FileOfChr(fl:string; num:longint; s:string);
procedure Str2FileOfStr(name, str:string);

procedure FileCopy(source,dest:string; add:boolean);
procedure CopyData(source,dest:string; from,bytes:longint);

procedure Ecran(s:pointer);

function eFiles(n:longint; lang:byte):string;
function ewFiles(n:longint; lang:byte):string;
procedure WhatFlopp(var DiskA, DiskB:byte);{}


Function GetFileAttr(FileName:PChar):integer;
Procedure SetFileAttr(FileName:PChar; Attr:word);
Function IsNotDriveReady (DriveSpec : Char) : Boolean; {A,B,etc}



{----- CD-ROM SUBSECTION -----}
Var
   DrvName   :CHAR;
   DrvCount  :WORD;
   IsMSCDEX,
   IsCDROM   :BOOLEAN;

procedure CD_ROMdat(VAR DrvCount:WORD;
                    VAR FirstDrv:CHAR;
                    VAR IsMSCDEX:BOOLEAN;
                    VAR IsCDROM:BOOLEAN);
function  ItCDRom  (drv:char):boolean;






{===== DOS95 LONG NAMES SECTION =====}

type
 TLSearchRec=record
  Attr:longint;
  CreationTime,LastAccessTime,LastModTime:comp; { See below for conversion }
  HiSize,LoSize:longint;
  Reserved:comp;
  Name:array[0..259] of char;
  ShortName:array[0..13] of char; { Only if longname exists }
  Handle:word;
 end;

function LFindFirst(FileSpec:pchar; Attr:word; var SRec:TLSearchRec):word;
{ Search for files }

function LFindNext(var SRec:TLSearchRec):word;
{ Find next file }

function LFindClose(var SRec:TLSearchRec):word;
{ Free search handle }

function LTruename(FileName:pchar; Result:pchar):word;
{ Return complete path, if relative uppercased longnames added, }
{ in buffer Result (261 bytes) }

function LGetShortName(FileName:pchar; Result:pchar):word;
{ Return complete short name/path for input file/path in buffer }
{ Result (79 bytes) }

function LGetLongName(FileName:pchar; Result:pchar):word;
{ Return complete long name/path for input file/path in buffer }
{ Result (261 bytes) }

function LFileSystemInfo(RootName:pchar; FSName:pchar; FSNameBufSize:word;
 var Flags,MaxFileNameLen,MaxPathLen:word):word;
{ Return File System Information, for FSName 32 bytes should be sufficient }
{ Rootname is for example 'C:\' }
{ Flags: }
{ bit
{  0   searches are case sensitive }
{  1   preserves case in directory entries }
{  2   uses Unicode characters in file and directory names }
{ 3-13 reserved (0) }
{ 14   supports DOS long filename functions }
{ 15   volume is compressed }


function LErase(Filename:pchar):word;
{ Erase file }

function LMkDir(Directory:pchar):word;
{ Make directory }

function LRmDir(Directory:pchar):word;
{ Remove directory }

function LChDir(Directory:pchar):word;
{ Change current directory }

function LGetDir(Drive:byte; Result:pchar):word;
{ Get current drive and directory. Drive: 0=current, 1=A: etc. }

function LGetAttr(Filename:pchar; var Attr:word):word;
{ Get file attributes}

function LSetAttr(Filename:pchar; Attr:word):word;
{ Set file attributes }

function LRename(OldFilename,NewFilename:pchar):word;
{ Rename file }

function LTimeToDos(var LTime:comp):longint;
{ Convert 64-bit number of 100ns since 01-01-1601 UTC to local DOS format time
}{ (LTime is var to avoid putting it on the stack) }

procedure UnpackLTime(var LTime:comp; var DT:DateTime);
{ Convert 64-bit time to date/time record }






{===== STRING SECTION =====}

function Space      (len:integer)                   :string;
function NoSpace    (s:string)                      :string;
function NoSpaceLR  (s:string)                      :string;
function NoSpaceR   (s:string)                      :string;
function NoSpaceL   (s:string)                      :string;
function Mid        (str:string; ind1,ind2:integer) :string;
function MidCh      (str:string; index:integer)     :char;
function Strr       (tempein:longint)               :string;
function Vall       (tempein:string)                :longint;
function Fill       (len:byte; symb:char)           :string;
function StrLo      (s:string)                      :string;
function StrHi      (s:string)                      :string;
function CodeStr    (ent:string; code:byte)         :string;
function DeCodeStr  (ent:string; code:byte)         :string;
function ReverseStr (s:string)                      :string;
function no1013     (st:string)                     :string;
function AsciiOnly  (st:string)                     :string;
function NumOnly    (st:string)                     :string;
function ExtNum     (n:string)                      :string;
function ASCIZ2Str  (ASCIZ: array of Char)          :string;
function WithOut    (s,chars:string)                :string;
function ChangeChar (s:string; char1,char2:char)    :string;
function CLen       (s:string)                      :integer;
function CCLen      (s:string)                      :integer;
function sLexpand   (s:string; tob:byte)            :string;
function sRexpand   (s:string; tob:byte)            :string;
Function Wild       (input_word,wilds:String;upcase_wish:boolean):Boolean;
function DnCase     (c:char)                        :char;


{===== PUTS SECTION =====}

Type
{  ScreenImage = Array [0..2499] of Word;{}
  ScreenImage = Pointer;{}
  FrameRec=Record
            x1    : byte;
            y1    : byte;
            x2    : byte;
            y2    : byte;
            area  : ScreenImage;
           End;
  SavedWin       = FrameRec;

Const
  MenuMax=50;

var
  SavedWins      :array[1..10] of SavedWin;
  WinNum         :Byte;

  menu_kod       :char;
  menu_f         :integer;
  menu_posx,
  menu_posy      :integer;
  menu_total     :integer;
  menu_name      :array[1..MenuMax] of string;
  menu_ins       :array[1..MenuMax] of boolean;
  menu_mayins    :boolean;
  menu_title     :string;
  menu_visible   :integer;

  menu_bkNT,menu_txtNT,
  menu_bkST,menu_txtST,
  menu_bkMarkNT,menu_txtMarkNT,
  menu_bkMarkST,menu_txtMarkST:  integer;

  scanf_tab_enable, scanf_tab, scanf_shtab, scanf_esc      :boolean;

  w_animation:boolean;
  w_twosided:boolean;
  w_rama:boolean;
  w_shadow:boolean;


Type
  string160=string[160];
Const
  run=1; pro=0;

procedure ScrIni;

procedure SaveScr           (x1,y1,x2,y2:byte);
procedure RestScr;

procedure BasePutWin        (paper,ink,xx1,yy1,xx2,yy2:integer);
procedure PutWin            (x1,y1,x2,y2:integer);
procedure SPutWin           (x1,y1,x2,y2:integer);
procedure SCPutWin          (p,i,x1,y1,x2,y2:integer);
procedure PutTitleWin       (title:string; x1,y1,x2,y2:integer);
procedure SPutTitleWin      (title:string; x1,y1,x2,y2:integer);

procedure Message           (tekst:string);
function  WaitMessage       (tekst:string):byte;
procedure NotWaitMessage    (paper,ink:byte; tekst:string);
procedure ErrorMessage      (tekst:string);
function  ErrorWaitMessage  (tekst:string):byte;

procedure StatusBar         (s:string160);
procedure CStatusBar        (paper,ink,papermark,inkmark,putfrom:byte; s:string160);
procedure StatusLine        (paper,x,y:integer; s:string);
procedure StatusLineColor   (paper,ink,papermark,inkmark,x,y:integer; s:string);
procedure CStatusLineColor  (paper,ink,inkmark,y:integer; s:string);
procedure ProcessBar        (act,per,total:byte; title:string);

function  Question          (quest:string; lan:byte):boolean;
function  Sure              (lan:byte):boolean;
function  Stop              (lan:byte):boolean;

function  Scanf             (scanf_posx, scanf_posy:byte;
                             scanf_str:string;
                             scanf_total, scanf_visible,
                             scanf_cur:byte):string;
function  ChooseItem:byte;
function  GetScrStr         (x,y,len:integer):string;
function  ChooseDrive       (w,typ,lang:byte; cd:string):char;

procedure CButton           (paper,ink,spaper,sink,x,y:byte; s:string; active:boolean);
procedure rvPutsInit;


{===== KEYBOARD SECTION =====}
const
     kb_EXT=#0;
     kb_ESC=#27;
     kb_UP=#72;
     kb_DOWN=#80;
     kb_LEFT=#75;
     kb_RIGHT=#77;
     kb_ENTER=#13;
     kb_SPACE=#32;
     kb_TAB=#9;
     kb_BS=#8;
     kb_HOME=#71;
     kb_END=#79;
     kb_DEL=#83;
     kb_INS=#82;
     kb_PgDn=#81;
     kb_PgUp=#73;
     kb_F1=#59;
     kb_F2=#60;
     kb_F3=#61;
     kb_F4=#62;
     kb_F5=#63;
     kb_F6=#64;
     kb_F7=#65;
     kb_F8=#66;
     kb_F9=#67;
     kb_AltF1=#104;
     kb_AltF2=#105;
     kb_AltF3=#106;
     kb_AltF4=#107;
     kb_AltF5=#108;
     kb_AltF6=#109;
     kb_AltF7=#110;
     kb_AltF8=#111;
     kb_CtrlF1=#94;
     kb_CtrlF2=#95;
     kb_CtrlF3=#96;
     kb_CtrlF4=#97;
     kb_CtrlF5=#98;
     kb_CtrlF6=#99;
     kb_CtrlF9=#102;
     kb_AltX=#45;
     kb_AltC=#46;
     kb_AltD=#32;
     kb_AltE=#18;
     kb_AltF=#33;
     kb_AltG=#34;
     kb_AltH=#35;
     kb_AltI=#23;
     kb_AltJ=#36;
     kb_AltK=#37;
     kb_AltL=#38;
     kb_AltM=#50;
     kb_AltN=#49;
     kb_AltO=#24;
     kb_AltS=#31;
     kb_AltF9=#112;
     kb_AltF10=#113;
     kb_C=#99;
     kb_CtrlC=#3;
     kb_CtrlB=#2;
     kb_CtrlR=#18;
     kb_CtrlO=#15;
     kb_CtrlL=#12;
     kb_CtrlUp=#160;
     kb_CtrlDown=#164;
     kb_CtrlLeft=#115;
     kb_CtrlRight=#116;
     kb_CtrlPgUp=#132;
     kb_CtrlPgDn=#118;
     kb_CtrlENTER=#10;
     kb_CtrlEND=#117;
     kb_INVERSE=#42;
     kb_PLUS=#43;
     kb_MINUS=#45;

Const

(* Function keys *)
   _F1 = $3B00;      _ShF1 = $5400;     _CtrlF1 = $5E00;     _AltF1 = $6800;
   _F2 = $3C00;      _ShF2 = $5500;     _CtrlF2 = $5F00;     _AltF2 = $6900;
   _F3 = $3D00;      _ShF3 = $5600;     _CtrlF3 = $6000;     _AltF3 = $6A00;
   _F4 = $3E00;      _ShF4 = $5700;     _CtrlF4 = $6100;     _AltF4 = $6B00;
   _F5 = $3F00;      _ShF5 = $5800;     _CtrlF5 = $6200;     _AltF5 = $6C00;
   _F6 = $4000;      _ShF6 = $5900;     _CtrlF6 = $6300;     _AltF6 = $6D00;
   _F7 = $4100;      _ShF7 = $5A00;     _CtrlF7 = $6400;     _AltF7 = $6E00;
   _F8 = $4200;      _ShF8 = $5B00;     _CtrlF8 = $6500;     _AltF8 = $6F00;
   _F9 = $4300;      _ShF9 = $5C00;     _CtrlF9 = $6600;     _AltF9 = $7000;
  _F10 = $4400;     _ShF10 = $5D00;    _CtrlF10 = $6700;    _AltF10 = $7100;
  _F11 = $8500;     _ShF11 = $8700;    _CtrlF11 = $8900;    _AltF11 = $8B00;
  _F12 = $8600;     _ShF12 = $8800;    _CtrlF12 = $8A00;    _AltF12 = $8C00;

(* Numeric keypad *)
  Pad8 = $4800;     ShPad8 = $4838;    CtrlPad8 = $8D00;
  Pad2 = $5000;     ShPad2 = $5032;    CtrlPad2 = $9100;
  Pad4 = $4B00;     ShPad4 = $4B34;    CtrlPad4 = $7300;
  Pad6 = $4D00;     ShPad6 = $4D36;    CtrlPad6 = $7400;
  Pad5 = $4C00;     ShPad5 = $4C35;    CtrlPad5 = $8F00;
  Pad0 = $5200;     ShPad0 = $5230;    CtrlPad0 = $9200;
PadDel = $5300;   ShPadDel = $522E;  CtrlPadDel = $9300;
PadMinus=$4A2D;                    CtrlPadMinus = $8E00; AltPadMinus= $4A00;
PadPlus =$4E2B;                     CtrlPadPlus = $9000; AltPadPlus = $4E00;
PadStar =$372A;                     CtrlPadStar = $9600; AltPadStar = $3700;
PadEnter=$E00D;                    CtrlPadEnter = $E00A; AltPadEnter= $A600;
PadSlash=$E02F;                    CtrlPadSlash = $9500; AltPadSlash= $A400;


(* Cursor keys *)
   _Up = $48E0;                         _CtrlUp = $8DE0;     _AltUp = $9800;
  _Down= $50E0;                       _CtrlDown = $91E0;   _AltDown = $A000;
  _Left= $4BE0;                       _CtrlLeft = $73E0;   _AltLeft = $9B00;
 _Right= $4DE0;                      _CtrlRight = $74E0;  _AltRight = $9D00;

 _Home = $47E0;    _ShHome = $4737;   _CtrlHome = $77E0;   _AltHome = $9700;
  _End = $4FE0;     _Shend = $4F31;    _Ctrlend = $75E0;    _Altend = $9F00;
 _PgUp = $49E0;    _ShPgUp = $4939;   _CtrlPgUp = $84E0;   _AltPgUp = $9900;
 _PgDn = $51E0;    _ShPgDn = $5133;   _CtrlPgDn = $76E0;   _AltPgDn = $A100;
  _Ins = $52E0;     _ShIns = $5230;    _CtrlIns = $92E0;    _AltIns = $A200;
  _Del = $53E0;     _ShDel = $532E;    _CtrlDel = $93E0;    _AltDel = $A300;


(* Alphabetic keys *)
 _LowA = $1E61;       _UpA = $1E41;      _CtrlA = $1E01;      _AltA = $1E00;
 _LowB = $3062;       _UpB = $3042;      _CtrlB = $3002;      _AltB = $3000;
 _LowC = $2E63;       _UpC = $2E43;      _CtrlC = $2E03;      _AltC = $2E00;
 _LowD = $2064;       _UpD = $2044;      _CtrlD = $2004;      _AltD = $2000;
 _LowE = $1265;       _UpE = $1245;      _CtrlE = $1205;      _AltE = $1200;
 _LowF = $2166;       _UpF = $2146;      _CtrlF = $2106;      _AltF = $2100;
 _LowG = $2267;       _UpG = $2247;      _CtrlG = $2207;      _AltG = $2200;
 _LowH = $2368;       _UpH = $2348;      _CtrlH = $2308;      _AltH = $2300;
 _LowI = $1769;       _UpI = $1749;      _CtrlI = $1709;      _AltI = $1700;
 _LowJ = $246A;       _UpJ = $244A;      _CtrlJ = $240A;      _AltJ = $2400;
 _LowK = $256B;       _UpK = $254B;      _CtrlK = $250B;      _AltK = $2500;
 _LowL = $266C;       _UpL = $264C;      _CtrlL = $260C;      _AltL = $2600;
 _LowM = $326D;       _UpM = $324D;      _CtrlM = $320D;      _AltM = $3200;
 _LowN = $316E;       _UpN = $314E;      _CtrlN = $310E;      _AltN = $3100;
 _LowO = $186F;       _UpO = $184F;      _CtrlO = $180F;      _AltO = $1800;
 _LowP = $1970;       _UpP = $1950;      _CtrlP = $1910;      _AltP = $1900;
 _LowQ = $1071;       _UpQ = $1051;      _CtrlQ = $1011;      _AltQ = $1000;
 _LowR = $1372;       _UpR = $1352;      _CtrlR = $1312;      _AltR = $1300;
 _LowS = $1F73;       _UpS = $1F53;      _CtrlS = $1F13;      _AltS = $1F00;
 _LowT = $1474;       _UpT = $1454;      _CtrlT = $1414;      _AltT = $1400;
 _LowU = $1675;       _UpU = $1655;      _CtrlU = $1615;      _AltU = $1600;
 _LowV = $2F76;       _UpV = $2F56;      _CtrlV = $2F16;      _AltV = $2F00;
 _LowW = $1177;       _UpW = $1157;      _CtrlW = $1117;      _AltW = $1100;
 _LowX = $2D78;       _UpX = $2D58;      _CtrlX = $2D18;      _AltX = $2D00;
 _LowY = $1579;       _UpY = $1559;      _CtrlY = $1519;      _AltY = $1500;
 _LowZ = $2C7A;       _UpZ = $2C5A;      _CtrlZ = $2C1A;      _AltZ = $2C00;

_LowrA = $1EE4;      _UprA = $1E94;
_LowrB = $30A8;      _UprB = $3088;
_LowrC = $2EE1;      _UprC = $2E91;
_LowrD = $20A2;      _UprD = $2082;
_LowrE = $12E3;      _UprE = $1293;
_LowrF = $21A0;      _UprF = $2180;
_LowrG = $22AF;      _UprG = $228F;
_LowrH = $23E0;      _UprH = $2390;
_LowrI = $17E8;      _UprI = $1798;
_LowrJ = $24AE;      _UprJ = $248E;
_LowrK = $25AB;      _UprK = $258B;
_LowrL = $26A4;      _UprL = $2684;
_LowrM = $32EC;      _UprM = $329C;
_LowrN = $31E2;      _UprN = $3192;
_LowrO = $18E9;      _UprO = $1899;
_LowrP = $19A7;      _UprP = $1987;
_LowrQ = $10A9;      _UprQ = $1089;
_LowrR = $13AA;      _UprR = $138A;
_LowrS = $1FEB;      _UprS = $1F9B;
_LowrT = $14A5;      _UprT = $1485;
_LowrU = $16A3;      _UprU = $1683;
_LowrV = $2FAC;      _UprV = $2F8C;
_LowrW = $11E6;      _UprW = $1196;
_LowrX = $2DE7;      _UprX = $2D97;
_LowrY = $15AD;      _UprY = $158D;
_LowrZ = $2CEF;      _UprZ = $2C9F;

(* Number keys, on top row of keyboard *)
 _Num1 = $0231;    _ShNum1 = $0221;                           _Alt1 = $7800;
 _Num2 = $0332;    _ShNum2 = $0340;      _Ctrl2 = $0300;      _Alt2 = $7900;
 _Num3 = $0433;    _ShNum3 = $0423;                           _Alt3 = $7A00;
 _Num4 = $0534;    _ShNum4 = $0424;                           _Alt4 = $7B00;
 _Num5 = $0635;    _ShNum5 = $0424;                           _Alt5 = $7C00;
 _Num6 = $0736;    _ShNum6 = $075E;      _Ctrl6 = $071E;      _Alt6 = $7D00;
 _Num7 = $0837;    _ShNum7 = $0826;                           _Alt7 = $7E00;
 _Num8 = $0938;    _ShNum8 = $092A;                           _Alt8 = $7F00;
 _Num9 = $0A39;    _ShNum9 = $0A28;                           _Alt9 = $8000;
 _Num0 = $0B30;    _ShNum0 = $0B29;                           _Alt0 = $8100;

                  _ShNumR2 = $0322;
                  _ShNumR3 = $04FC;
                  _ShNumR4 = $053B;
                  _ShNumR5 = $0625;
                  _ShNumR6 = $073A;
                  _ShNumR7 = $083F;
                  _ShNumR8 = $092A;
                  _ShNumR9 = $0A28;
                  _ShNumR0 = $0B29;


(* Miscellaneous *)
  _Space = $3920;
   _BkSp = $0E08;                     _CtrlBkSp = $0E7F;   _AltBkSp = $0E00;
    _Tab = $0F09;   _ShTab = $0F00;   _CtrlTab  = $9400;    _AltTab = $A500;
  _Enter = $1C0D;                     _CtrlEnter= $1C0A;  _AltEnter = $1C00;
    _Esc = $011B;                                           _AltEsc = $0100;


  _Tilda = $2960; _ShTilda = $297E;                       _AltTilda = $2900;
 _TildaR = $29F1;_ShTildaR = $00F0;
 _OpScob = $1A5B;_ShOpScob = $1A7B; _CtrlOpScob = $1A1B; _AltOpScob = $1A00;
 _ClScob = $1B5D;_ShClScob = $1B7D; _CtrlClScob = $1B1D; _AltClScob = $1B00;
_OpScobR = $1AE5;_ShOpScobR= $1A95;_CtrlOpScobR = $1A1B;_AltOpScobR = $1A00;
_ClScobR = $1BEA;_ShClScobR= $1B9A;_CtrlClScobR = $1B1D;_AltClScobR = $1B00;
_BkSlash = $2B5C;_ShBkSlash= $2B7C;_CtrlBkSlash = $2B1C;_AltBkSlash = $2B00;
                 _ShBkSlashR=$2B2F;

 _Slash  = $352F; _ShSlash = $353F;                      _AltSlash  = $3500;
 _SlashR = $352E; _ShSlashR= $352C;

  _Minus = $0C2D;                    _CtrlMinus = $0C1F;  _AltMinus = $8200;
   _Plus = $0D2B;                                          _AltPlus = $8300;
   _Star = $092A;



function KeyCode:word;
function KeyCodePressed(var kc:word):boolean;
function Ctrl:boolean;
function Alt:boolean;
function LShift:boolean;
function RShift:boolean;


{===== WINDOWS SECTION =====}
function WinX   :boolean;
function WinVer :word;
function Is95   :boolean;




{===== MOUSE SECTION =====}

var
   Moused: boolean;
{
procedure rMouseOn;
procedure rMouseOff;

function InitMouseOk : boolean;
function GetButton : byte;
function GetX : byte;
function GetY : byte;
procedure GetMousePos(var x,y : integer);
procedure MouseShow;
procedure MouseHide;
{}





{===== CONVERT SECTION =====}
function dec2hex(decn:string):string;
function hex2dec(hex:string):string;
function hex2bin(hex:string):string;
function bin2hex(bin:string):string;
FUNCTION Hexlong(argument:longint):string;
{===== CONVERT SECTION =====}


Implementation
{$I rvCRT.pas}
{$I rvDOS.pas}
{$I rvSTR.pas}
{$I rvPUTS.pas}
{$I rvWIN.pas}
{$I rvDOS95.pas}
{$I rvKEYB.pas}
{$I rvCONV.pas}


Begin
gmaxx:=maxx;
gmaxy:=maxy;
halfmaxx:=gmaxx div 2;
halfmaxy:=gmaxy div 2;
{
menu_visible:=255;
menu_mayins:=false;
menu_posx:=255; menu_posy:=255;
{}
rvPutsInit;

WinNum:=1;
w_animation:=false;
w_twosided:=true;
w_rama:=true;
w_shadow:=true;
moused:=false;
scanf_tab_enable:=false;
End.