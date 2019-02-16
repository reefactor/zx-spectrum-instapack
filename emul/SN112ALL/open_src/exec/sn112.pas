{$M 3072,0,0}
Uses
    Dos,HeapMan,crt;
Var
    sn:string[6]; Cmd:string[4]; TempDir:ComStr;
    f:file of byte; i,b:byte;

Label beg;

Function CurTime:string;
 Function LZ(w:Word):String; Var s:String[2];
 Begin Str(w:0,s); if Length(s)=1 then s:='0'+s; LZ:=s; End;
Var h,m,s,hund:Word;
Begin GetTime(h,m,s,hund); CurTime:=LZ(h)+LZ(m)+LZ(s); End;

Function GetOf(fullpath:comstr):comstr;
Var DosDir:DirStr; DosName:NameStr; DosExt:ExtStr;
Begin FSplit(FullPath, DosDir, DosName, DosExt); GetOf:=DosDir; End;

Begin
WriteLn('ZX Spectrum Navigator  Version 1.12  Copyright (c) 1999 RomanRoms Software Co.');
sn:=CurTime; Cmd:='';
Beg:
TempDir:=GetOf(ParamStr(0));
if TempDir[Length(TempDir)]<>'\' then TempDir:=TempDir+'\';
for i:=1 to ParamCount do Cmd:=Cmd+' '+ParamStr(i);
Execute(TempDir+'SN.PRG',sn+Cmd);
if DosExitCode=1 then
 Begin
  TempDir:=GetEnv('TEMP');
  if TempDir='' then TempDir:=GetEnv('TMP');
  if TempDir='' then TempDir:='C:\';
  if TempDir[Length(TempDir)]<>'\' then TempDir:=TempDir+'\';

  TextColor(yellow); writeln(TempDir); TextColor(7);


  {$I-}
  Assign(f,TempDir+'SN'+sn+'.SWP'); FileMode:=0;
  Reset(f); Seek(f,766); Read(f,b);
  TempDir:=''; for i:=1 to b do Begin Read(f,b); TempDir:=TempDir+Chr(b); End;
  Close(f);
  {$I+}
  if IOResult<>0 then;
  Execute(GetEnv('COMSPEC'),'/c '+TempDir);
  Cmd:='E';  for i:=1 to ParamCount do Cmd:=Cmd+' '+ParamStr(i);
  GoTo Beg;
 End;
end.