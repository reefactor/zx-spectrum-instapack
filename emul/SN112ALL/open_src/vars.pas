Unit Vars;
Interface
Uses Dos;

Const
     Rus=1; Eng=2;
     Left=1; Right=2;
     NonType=0; NameType=1; ExtType=2; LenType=3;

     noPanel=0; infPanel=11; lastPanel=12;
     pcPanel=1; trdPanel=2; tapPanel=3; fdiPanel=4; fddPanel=5;
     isPanel=6; flpPanel=7; zxzPanel=8; sclPanel=9; bbsPanel=10;

     MaxFiles=1500;

     Ver='1.12';

Var
     focus:byte;
     lang:byte;
     Clocked:boolean;
     CmdLine:boolean; HideCmdLine:boolean;
     DiskLine:boolean;
     HideHidden:boolean;
     DiskMenuType:byte;
     Esc_ShowUserScr:boolean;
     Del_F8:boolean;
     bLoadDesktop:boolean;
     RestoreVideo:boolean;
     BkSpUpDir:boolean;
     snMouse:boolean;
     SaveOnExit:boolean;

     Refresh:boolean;
     AltF3Pressed,AltF5Pressed:boolean;

     InternalView:boolean;

     snKernelExitCode:byte;
     Command:string;
     CommandXFrom,CommandXPos:integer;
     History:array[1..32] of string[128];
     HistoryTotal,HistoryIndex:integer;
     sBar:array[Rus..Eng,noPanel..lastPanel]of string[120];
     dCur:array[1..3] of byte;
     pr1,pr2,pr3,pr4,pr5,pr6,pr7,pr8,pr9,pr11:string[128];

     ASCln:byte;
     PlusMask,MinusMask:string[12];

     WorkDir,StartDir,TempDir,StartNum:string[128];
     SavedAttr:word;
     group1,group2,group3,group4,group5,gExe,gArc:string[128];

     TRDOS3en,TRDOS3:boolean;
     AutoMove,trdAutoMove:boolean;
     ExecuteEmu:boolean;
     ExecuteEmulator:string;
     HobetaStartAddr:word;
     MakeBoot:boolean;
     hob2scl:boolean;
     noHobNaming:byte;

     LoadUp80:boolean;
     CheckMedia:boolean;
     Cat9:boolean;

Type THobBody=array[1..1]of byte;
     HobRec=record
             name:string[10];
             typ:char;
             start:word;
             length:word;
             param1:word;
             param2:word;
             line:word;
             totalsec:byte;
             body:^THobBody;
             tapFlag:byte;
            end;
Var  HobetaInfo:HobRec;





Implementation


Begin
Clocked:=true;
CmdLine:=true;

dCur[1]:=0; dCur[2]:=19; dCur[3]:=13;
PlusMask:='*.*'; MinusMask:='*.*';
Command:='';
End.