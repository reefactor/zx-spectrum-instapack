{============================================================================}
{== DIR OF ,   NAME OF ,   EXT OF ===========================================}
{============================================================================}
Function GetOf(fullpath:string; what:byte):string;
var
   dosdir  :dirstr;
   dosname :namestr;
   dosext  :extstr;
Begin
FSplit(fullpath, dosdir, dosname, dosext);
if length(dosdir) <> 3 then dosdir := Copy(dosdir, 1, Length(dosdir)-1);
case what of
 _dir  : GetOf := dosdir;
 _name : GetOf := dosname;
 _ext  : GetOf := dosext;
end;
End;
{============================================================================}
{== RUN UNDER ... ===========================================================}
{============================================================================}
Function RunBy:string;
var
  parentseg :^word;
  p         :pchar;
  i         :integer;
  s         :string;
begin
s:='';  i:=0;
parentseg:=ptr(prefixseg,$16);
p:=ptr(parentseg^-1,8);
while true do
 begin
  if p[i]=chr(0) then break;
  s:=s+p[i];
  inc(i);
 end;
runby:=s;
end;


{============================================================================}
{== DISK STATUS =============================================================}
{============================================================================}
function DiskStatus(drive:byte):byte;
VAR
   DiskStatusBuf : ARRAY[0..512] OF BYTE;  { Buffer MUST be outside }

function DS(drive:byte):byte; assembler;
asm
  cmp  drive,26
  jb   @driveok
  mov  drive,0   { if drive isn't between 0 and 25, make it 0 (for A:) }
  @driveok:

  mov  ax, seg DiskStatusbuf
  mov  es, ax
  mov  bx, offset DiskStatusbuf

  mov  ah, 02      { read disk sectors }
  mov  al, 1       { number of sectors to transfer }
  mov  ch, 1       { track number }
  mov  cl, 1       { sector number }
  mov  dh, 1       { head number }
  mov  dl, drive   { drive number (0=A, 3=C, or 80h=C, 81h=D) }
  int  13h

  mov  bl,0    { assume drive is ready }
  jnc  @done   { carry set if unsuccessfull (i.e. disk is not ready) }
  mov  bl,ah
  jmp  @done

  { take out the above two lines to make this just check
    for disk ready/not ready }

  and  ah,$80
  jz   @done   { error was something other than disk not ready }
  mov  bl,false{ disk wasn't ready. store result }
  @done:

  mov  ax,$0000  { reset drive }
  INT  13H
               { shut off disk drive quickly }
{  xor  ax,ax
  mov  es,ax
  mov  ax,440h
  mov  di,ax
  mov  byte ptr es:[di],01h
{}
  mov  al,bl   { retrieve result }
end;

begin
DiskStatus:=DS(drive);
end;  { diskstatus }


{============================================================================}
{== IS THIS DRIVE VALID ? ===================================================}
{============================================================================}
Function IsDriveValid(cDrive: Char; Var bLocal, bSUBST: Boolean): Boolean;
Var
  regs:Registers;
Begin
if not (UpCase(cDrive) in ['A'..'Z']) then IsDriveValid:=False else
 begin
  regs.bx := ord(UpCase(cDrive)) - ord('A') + 1;
  regs.ax := $4409;
  Intr($21, regs);
  if (regs.ax and FCarry) = FCarry then IsDriveValid := False else
   begin
    IsDriveValid := True;
    bLocal := ((regs.dx and $1000) = $0000);
    if bLocal then bSUBST := ((regs.dx and $8000) = $8000) else bSUBST := False;
   end;
 end;
End;
{============================================================================}
{== GET ALL DRIVERS =========================================================}
{============================================================================}
Function GetAllDrivers:string;
var
  cCurChar       :Char;
  sr             :SearchRec;
  s              :string;
Begin
{$I-}
s:='';
For cCurChar := 'C' to 'Z' do
 Begin
  FindFirst(cCurChar+':\*.*', AnyFile, sr);
  if DosError<>3 then s:=s+cCurChar;
 End;
GetAllDrivers := s;
{GetAllDrivers := 'ABCDEFGHHIJKLMNOPQRSTUVWXYZ';}
{$I+}
End;
{============================================================================}
{== CHECK DRIVE =============================================================}
{============================================================================}
{$I-}
Function CheckDrv(drv:char):byte;
var
   ff:searchrec;
Begin
filemode:=0;
findfirst(drv+':\*.*',anyfile,ff);
CheckDrv := doserror;
End;


{$I+}
{============================================================================}
{== CHECK DIRECTORY =========================================================}
{============================================================================}
{$I-}
Function CheckDir(direct:string):byte;
var
   s:string;
   i:byte;
Begin
filemode:=0;
GetDir(0, s);
ChDir(direct[1]+direct[2]);
ChDir(direct); CheckDir:=IOResult;
ChDir(s[1]+s[2]);
ChDir(s);
End;
{$I+}
{============================================================================}
{== CHECK FILE ==============================================================}
{============================================================================}
{$I-}
Function CheckFile(myfile:string):byte;
var
   ff  :searchrec;
Begin
filemode:=0;
findfirst(myfile,anyfile,ff);
CheckFile := doserror;
End;
{$I+}
{============================================================================}
{== CHECK DIR+FILE ==========================================================}
{============================================================================}
Function CheckDirFile(fullname:string):byte;
var
   ff  :searchrec;
Begin
filemode:=0;
findfirst(fullname,anyfile,ff);
{message(fullname+' '+strr(doserror));{}
CheckDirFile := doserror;
End;
{============================================================================}
{== CHECK DIR+FILE ==========================================================}
{============================================================================}
Function CheckWrite(drv:char):boolean;
{$I-}
var
a:string; f:file of byte; byt:byte;
Begin
filemode:=2;
a:=curentdir;
if CheckDrv(drv)<>0 then begin CheckWrite:=false; exit; end;
ChDir(drv+':');
assign(f,'RomanRom.2'); rewrite(f);
byt:=0; write(f,byt);{}
if ioresult<>0 then begin CheckWrite:=false; end
else begin close(f); erase(f); CheckWrite:=true; end;
ChDir(a);
if ioresult<>0 then;
End;
{============================================================================}
{== CREATE DIR ==============================================================}
{============================================================================}
{$I-}
function CreateDir(full:string):byte;
var
   cur:string;
   temp:string;
   ss:byte;
begin
filemode:=2;
temp:='';
GetDir(0,cur);
for ss:=1 to Length(full) do
 begin
  temp:=temp+Copy(full,ss,1);
  if Copy(full,ss,1)='\' then
   begin
    if length(temp)<>3 then
     begin
      if Copy(temp,Length(temp),1)='\' then temp:=Copy(temp,1,Length(temp)-1);
      if checkdir(temp)<>0 then MkDir(temp);
      temp:=temp+'\';
     end;
   end;
 end;
CreateDir:=CheckDir(Copy(full,1,Length(full)-1));
ChDir(cur);
end;
{$I+}
{============================================================================}
{== CURENT DIRECTORY ========================================================}
{============================================================================}
Function CurentDir:string;
var
   s:string;
Begin
filemode:=0;
Getdir(0,s); CurentDir:=s;
End;
{============================================================================}
{== FILE TIME ===============================================================}
{============================================================================}
Function FileTime(FileName: string): string;
var
   Srec : SearchRec;
   dt   : DateTime;
Begin
filemode:=0;
FindFirst(FileName, $01+$02+$04+$20, Srec);
if DosError = 0 then
 begin
  unpacktime(Srec.Time, dt);
  with dt do FileTime:=LZ(hour)+':'+LZ(min)+':'+LZ(sec);
 end
else FileTime := '';
End;
{============================================================================}
{== FILE DATE ===============================================================}
{============================================================================}
Function FileDate(FileName: string): string;
var
   Srec : SearchRec;
   dt   : DateTime;
Begin
filemode:=0;
FindFirst(FileName, $01+$02+$04+$20, Srec);
if DosError = 0 then
 begin
  unpacktime(Srec.Time, dt);
  with dt do FileDate:=LZ(day)+'-'+LZ(month)+'-'+Copy(LZ(year),3,2);
 end
else FileDate := '';
End;
{============================================================================}
{== FILE LENGTH =============================================================}
{============================================================================}
Function FileLen(FileName: string): longint;
var
   Srec: SearchRec;
Begin
filemode:=0;
FindFirst(FileName, {{$01+$02+$04+$20{}$3f, Srec);
{message(curentdir+' '+strr(doserror));{}
if DosError = 0 then FileLen := Srec.Size else FileLen := 0;
End;
{============================================================================}
{== GET VOLUME NAME OF DRIVE ================================================}
{============================================================================}
Function GetVolName(DriveNo:Byte): string;
var s:searchrec; err:boolean;
begin
filemode:=0;
findfirst(chr(DriveNo+64)+':\*.*', VolumeId, s);
err:=DosError=0;
if err then GetVolName:=without(s.name,'.') else GetVolName:='none';
end;

{============================================================================}
{== GET SERIAL NUMBER OF DRIVE ==============================================}
{============================================================================}
Function HexDigit(N:Byte):char;
begin
if n<10 then HexDigit:=Chr(Ord('0')+n) else HexDigit:=Chr(Ord('A')+(n-10));
end;

Function GetVolSerialNo(DriveNo:Byte): string;
type
  SerNo_type=
   record
    case integer of
     0: (SerNo1,SerNo2:word);
     1: (SerNo:longint);
   end;
  DiskSerNoInfo_type=
   record
    Infolevel:word;
    VolSerNo:SerNo_Type;
    VolLabel:array[1..11] of char;
    FileSys:array[1..8] of char;
   end;
var
  ReturnArray:DiskSerNoInfo_type;
  Regs:Registers;
Begin
  with regs do
   begin
    AX:=$440d;
    BL:=DriveNo;
    CH:=$08;
    CL:=$66;
    DS:=Seg(ReturnArray);
    DX:=Ofs(ReturnArray);
    Intr($21,Regs);
    if (Flags and FCarry)<>0 then GetVolSerialNo:='' else
     with ReturnArray.VolSerNo do
     GetVolSerialNo:=
      HexDigit(Hi(SerNo2)Div 16)+HexDigit(Hi(SerNo2)Mod 16)+
      HexDigit(Lo(SerNo2)Div 16)+HexDigit(Lo(SerNo2)Mod 16)+
      HexDigit(Hi(SerNo1)Div 16)+HexDigit(Hi(SerNo1)Mod 16)+
      HexDigit(Lo(SerNo1)Div 16)+HexDigit(Lo(SerNo1)Mod 16);
   end;
End;
{============================================================================}
{== GET PROFILE FROM *.INI FILES ============================================}
{============================================================================}
Function GetProfile(filename,group,key:string; var str:string):byte;
var
   ft:text;
   fstr:string;
Begin
GetProfile:=checkdirfile(filename);
if checkdirfile(filename)<>0 then begin str:=''; exit; end;
filemode:=0;
{$I-}
assign(ft,filename);
reset(ft);
while not EOF(ft) do
 begin
  readln(ft,fstr);
  if fstr='['+group+']' then break;
 end;
if fstr<>'['+group+']' then begin close(ft); str:=''; exit; end;
while not EOF(ft) do
 begin
  readln(ft,fstr);
  if copy(fstr,1,length(key))=key then break;
  if copy(nospaceLR(fstr),1,1)='[' then break;
 end;
if copy(fstr,1,length(key))<>key then begin close(ft); str:=''; exit; end;
str:=copy(fstr,length(key)+2,255);
GetProfile:=0;
close(ft);
{$I+}
if IOResult<>0 then str:='';
End;
{============================================================================}
{== WRITE PROFILE TO *.INI FILES ============================================}
{============================================================================}
Function WriteProfile(filename,group,key,str:string):byte;
type
  a=array[1..2] of string;
var
 err:byte;
 i:byte;
 ft:text;
 s:string;
 k:integer;
 f:^a;
 siz:word;
Begin {$R-} {$I-}
siz:=filelen(filename);
if checkdirfile(filename)<>0 then filecreate(filename);
err:=ioresult; if err<>0 then begin writeprofile:=err; exit; end;
getmem(f,siz);
filemode:=2;
assign(ft,filename); reset(ft);
s:=''; k:=1;
while (s<>'['+group+']')and(not EOF(ft)) do begin readln(ft,s); f^[k]:=s; inc(k); end;
if EOF(ft) then
 begin
  f^[k]:=''; inc(k);
  f^[k]:='['+group+']'; inc(k); f^[k]:=key+'='+str; inc(k);
  while not EOF(ft) do begin readln(ft,s); f^[k]:=s; inc(k); end;
  close(ft); i:=(k-1); rewrite(ft);
  for k:=1 to i do writeln(ft,f^[k]); close(ft);
  freemem(f,siz);
  exit;
 end;
s:='-=-=-=-';
while (not EOF(ft))and(copy(s,1,length(key))<>key) do
 begin
  readln(ft,s);
  if (copy(s,1,1)='[') then begin inc(k); break; end;
  if (s)='' then break;
  f^[k]:=s; inc(k);
 end;
 if copy(s,1,length(key))=key then
  begin
   dec(k);
   f^[k]:=key+'='+str; inc(k);
   while not EOF(ft) do begin readln(ft,s); f^[k]:=s; inc(k); end;
   close(ft); i:=(k-1); rewrite(ft);
   for k:=1 to i do writeln(ft,f^[k]); close(ft);
   freemem(f,siz); exit;
  end;
f^[k]:=key+'='+str; inc(k); f^[k]:=''; inc(k);
while not EOF(ft) do begin readln(ft,s); f^[k]:=s; inc(k); end;
close(ft); i:=(k-1); rewrite(ft);
for k:=1 to i do writeln(ft,f^[k]); close(ft);
freemem(f,siz);
{$I+}
exit;
{$R+} 
end;
{============================================================================}
{== CPU ID ==================================================================}
{============================================================================}
{$L CPU.OBJ} {$F+} Function WhichCPU : CpuType; EXTERNAL; {$F-}
Function CpuID(var cpun:integer) : string;
Begin
  Case WhichCPU Of
    c8088:      begin CpuID := '8088';       cpun:=0; end;
    c8086:      begin CpuID := '8086';       cpun:=1; end;
    c80286:     begin CpuID := '80286';      cpun:=2; end;
    c80386:     begin CpuID := '80386';      cpun:=3; end;
    c80486:     begin CpuID := '80486';      cpun:=4; end;
    Pentium:    begin CpuID := 'Pentium';    cpun:=5; end;
    PentiumPRO: begin CpuID := 'PentiumPRO'; cpun:=6; end;
  End;
End;
{
            Имя исходного файла : CPU.OBJ
                         Размер : 399 (1Kb)
                  Дата создания : 29-Авг-93 00:00:00
               Дата кодирования : 15-Фев-97 02:40:36
                 Размер UU-кода : 1Kb
              Количество секций : 1
     Число строк в одной секции : 9


section 1 of file cpu.obj  < uuencode by Dos Navigator >

filetime 454885376
begin 644 cpu.obj
M@`X`#&-P=6ED87-M+D%330&((````!Q4=7)B;R!!<W-E;6)L97(@(%9E<G-I
M;VX@,RXRF8@4`$#I-F?1&@QC<'5I9&%S;2Y!4TU"B`,`0.E,E@(``&B(`P!`
MH926!@`$0T]$1468!P!(\P`"`0$BD`\```$(5TA)0TA#4%4```#]B`0`0*(!
MD:#W``$``!Z,R([8Z!P`/`)]!>@P`.L1Z$D`/`-\"NAA`#P$?`/HA``?RYR<
M6X'C_P]3G9Q;@>,`\#/`@?L`\'0"L`*=PP:,R([`_;H!`+]8`+"0N0,`\ZK\
MD)"02I"0B\('PYP/`>#1V',%N`,`ZQ"X`'!0G9Q8@.1PN`(`=`%`G<.+^(O<
M9IQFG&989@T```0`9E!FG6:<9EAFJ0``!`!T`Y"01V:=B^.+Q\-FG&989HO8
M9C4``"``9E!FG6:<9EAF4V:=9B4``"``9H'C```@`&8[PW0>D)!FN`$````/
GHM'HT>C1Z-'HT>C1Z-'HT>@E#P##N`0`PZR<!0#$250!_8H"``!T
`
end
sum -r/size 41274/574 section (from "begin" to "end")
sum -r/size 17278/399 entire input file

}
{=================== END of CPU ID ==========================================}
{============================================================================}
{== CPU CLK =================================================================}
{============================================================================}
Function CpuCLK:string;
Var
   MHz,KHz:word;

Procedure CPUSpd(Var MHz, KHz:  Word);
Const
     Processor_cycles:Array[0..5] of Byte=(165,165,25,103,42,42);
                {Cycle times of 8086, 80186, 80286, 80386, 80486, Pentium}
{
 Notice that here I have defined the 8086 as a Processor type of 0 vice
 the returned value of 1 from WhatCPU.  Since the original code did not
 distinguish between the 8086 and the 80186, I can get away with this.
}
Var
   Ticks,Cycles,CPS:LongInt;
   Which_CPU:integer;
Function i86_to_i286:  Word;  Assembler;
Asm
   CLI
   MOV         CX,1234
   XOR         DX,DX
   XOR         AX,AX
   MOV         AL,$B8
   OUT         $43,AL
   IN          AL,$61
   OR          AL,1
   OUT         $61,AL
   XOR         AL,AL
   OUT         $42,AL
   OUT         $42,AL
   XOR         AX,AX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IDIV        CX
   IN          AL,$42
   MOV         AH,AL
   IN          AL,$42
   XCHG        AL,AH
   NEG         AX
   STI
End;
Function i386_to_i486:  Word;        Assembler;
Asm
   CLI
   MOV         AL,$B8
   OUT         $43,AL
   IN          AL,$61
   OR          AL,1
   OUT         $61,AL
   XOR         AL,AL
   OUT         $42,AL
   OUT         $42,AL
   DB 66H,$B8,00h,00h,00h,80h;
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   DB 66H,0FH,$BC,$C8;       {        BSF        ECX,EAX }
   IN          AL,42H
   MOV         AH,AL
   IN          AL,42H
   XCHG        AL,AH
   NEG         AX
   STI
End;

Begin
CPUid(Which_CPU);
If Which_cpu<3 Then Ticks:=i86_to_i286 Else Ticks:=i386_to_i486;
Cycles:=20*Processor_cycles[Which_CPU];
CPS:=(Cycles*119318) Div Ticks;
MHz:=CPS Div 100000;
KHz:=(CPS Mod 100000+500) Div 1000;
End;

Begin
CpuSpd(MHz, KHz);
CpuCLK:=strr(MHz)+'.'+strr(KHz)+' MHz';
end;

{============================================================================}
{== IS EMM INSTALED =========================================================}
{============================================================================}
Function Emm_Installed: Boolean;
Const
EMM_INT                   = $67;
DOS_Int                   = $21;
Var
Emm_Device_Name       : string[8];
Int_67_Device_Name    : string[8];
Position              : Word;
Regs                  : registers;

Begin
Int_67_Device_Name:='';
Emm_Device_Name   :='EMMXXXX0';
with Regs do
 Begin
  AH:=$35;
  AL:=EMM_INT;
  Intr(DOS_int,Regs);

  For Position:=0 to 7 do
   Int_67_Device_Name:=Int_67_Device_Name+Chr(mem[ES:Position+$0A]);
  Emm_Installed:=True;

  If Int_67_Device_Name<>Emm_Device_Name then Emm_Installed:=False;
 end;
end;

{============================================================================}
{== IS XMS INSTALED =========================================================}
{============================================================================}
Function xms_installed:boolean;
 var regs  :  registers;
begin
 regs.ax := $4300;
 intr($2F,regs);
 xms_installed := regs.al = $80;
   {
   if (installed = true) then
     begin
       regs.ax := $4310;
       regs.ah := $00;
       intr($2F,regs);
       ver := regs.ax;
       ver2 := regs.bx;
     end;
   }
end;

{============================================================================}
{== TOTAL MEMORY ============================================================}
{============================================================================}
procedure GetTotalMemoryInfo;

Function StrL(L : longint) : string;
var
  S : string;
begin
  Str(L,S);
  StrL := S;
end;

Function StrLF(L : longint;   Field : byte) : string;
var
  S : string;
begin
  Str(L:Field,S);
  StrLF := S;
end;

Procedure GetRAMInfo;
Begin
  FillChar(Regs,SizeOf(Regs),$00);
  Intr($12,Regs);
  TotalRAM := Regs.AX;                { Total RAM on system (usually 640 Kb) }
  AvailRAM := (MemAvail div 1000)+24; { Available RAM, 24 Kb used by program }
end;

procedure GetEXPInfo;
var
  v1,v2: byte;
begin
  { Check if installed expanded memory }
  FillChar(Regs,SizeOf(Regs),$00);
  Regs.AH := $40;
  Intr($67,Regs);
  EXPInstalled := (Regs.AH = 0);

  if not EXPInstalled then Exit;

  { Check number of installed and available 16K pages }
  FillChar(Regs,SizeOf(Regs),$00);
  Regs.AH := $42;
  Intr($67,Regs);
  PagesInst  := Regs.DX;
  PagesAvail := Regs.BX;
  TotalEXP   := 16*PagesInst;  { Total expanded in KBytes     }
  AvailEXP   := 16*PagesAvail; { Available expanded in KBytes }

  { Get LIM version number }
  FillChar(Regs,SizeOf(Regs),$00);
  Regs.AH := $46;
  Intr($67,Regs);
  v1 := Regs.AL shr 4;
  v2 := Regs.AL and $0F;
  EXPVersion := StrL(v1)+'.'+StrL(v2);

  { Get number of pages occupied by each handle }
  FillChar(Regs,SizeOf(Regs),$00);
  Regs.AH := $4D;
  Regs.ES := Seg(PList);
  Regs.DI := Ofs(PList);
  Intr($67,Regs);
  NumHandles := Regs.BX;
  SystemEXP := 16*PList[1].Pages;
  OtherEXP := 0;
  for i := 2 to NumHandles do
    OtherEXP := OtherEXP + 16*PList[i].Pages;
end;


procedure GetXMSInfo;
var
  b1,b2: word;
begin
  Port[$70] := $30;
  b1 := Port[$71];
  Port[$70] := $31;
  b2 := Port[$71];
  TotalXMS := (b2 shl 8) + b1;
end;

begin
GetRAMinfo;
if Emm_Installed then GetEXPinfo;
{if Emm_Installed then{} GetXMSinfo;
end;

{============================================================================}
{== FIND FILE ===============================================================}
{============================================================================}
Function FindFile(findfilename:string):string;
var
   founds:string;
   found:boolean;
   alld:string;
   f:integer;

function FileScan(path:pathstr):boolean;
var
    srf:searchrec;
begin
filescan:=false;
filemode:=0;
FindFirst(path+'*.*', (archive or readonly or hidden or sysfile), srf);
while DosError=0 do with srf do
 begin
  if (attr and (archive or readonly or hidden or sysfile)<>0)
  and (name[1]<>'.') then if strlo(name) = findfilename then
   begin founds:=copy(path,1,length(path)-1); filescan:=true; exit; end;
  FindNext(srf);
 end;
end;

procedure DirectoryScan(path:pathstr);
var
    sr:searchrec;
begin
if FileScan(path) then begin found:=true; exit; end;
filemode:=0;
FindFirst(path+'*.*', directory, sr);
while DosError=0 do
with sr do
 begin
  if (attr and directory<>0)and(name[1]<>'.') then
   begin
      if found then begin findfile:=founds; exit; end;
      DirectoryScan(path+name+'\');
   end;
  FindNext(sr);
 end;
end;

begin
found:=false;
findfile:='';
findfilename:=strlo(findfilename);
findfilename:=getof(findfilename,_name)+getof(findfilename,_ext);
alld:=getalldrivers;
for f:=1 to length(alld) do
 begin
  directoryscan(copy(alld,f,1)+':\');
  if found then break;
 end;
if not found then findfile:='?';
end;
{============================================================================}
{== CREATE FILE =============================================================}
{============================================================================}
Procedure FileCreate(f:string);
var
   a:file of byte;
Begin
filemode:=2;
Assign(a,f); ReWrite(a); Close(a);
End;
{============================================================================}
{== DELETE FILE =============================================================}
{============================================================================}
{$I-}
Procedure FileDelete(fn:string);
var
   ft:file of byte;
Begin
filemode:=2;
assign(ft,fn); setfattr(ft,archive);
erase(ft);
if ioresult<>0 then;
End;
{============================================================================}
{== MAKE FILE ===============================================================}
{============================================================================}
procedure MakeFile(name:string; bytes:longint; code:byte);
var
   fb:file of byte;
   a:longint;
Begin
filemode:=2;
assign(fb,name);
rewrite(fb);
for a:=1 to bytes do write(fb,code);
close(fb);
End;
{============================================================================}
{== STRING TO FILE OF CHAR OR BYTE ==========================================}
{============================================================================}
Procedure Str2FileOfChr(fl:string; num:longint; s:string);
var
   f:longint;
   ft:file of char;
   ss:string;
   b:char;
Begin
filemode:=2;
Assign(ft,fl); Reset(ft);
Seek(ft,num);
for f:=1 to Length(s) do
 begin
  ss:=Copy(s,f,1);
  Write(ft,ss[1]);
 end;
{
 b:=chr(13); write(ft,b);
 b:=chr(10); write(ft,b);
}
End;
{============================================================================}
{== ADD STRING TO FILE ======================================================}
{============================================================================}
Procedure Str2FileOfStr(name, str:string);
var
   ft:text;
Begin
assign(ft,name);
append(ft);
writeln(ft,str);
close(ft);
End;
{============================================================================}
{== COPY FILE ===============================================================}
{============================================================================}
Procedure FileCopy(source,dest:string; add:boolean);
var
   frfile,tofile:file;
   numread,numwritten:integer;
   buf:array[1..16384] of byte;
   ftime:longint;
   attr:word;
   k:char;
Begin
{$I+}
    filemode:=2;
    assign(frfile,source); reset(frfile,1);
    assign(tofile,dest);
    {
    getfattr(tofile,attr); if attr and ReadOnly <> 0 then setfattr(dest,(attr xor ReadOnly));
    getfattr(tofile,attr); if attr and Hidden <> 0 then setfattr(dest,(attr xor Hidden));
    getfattr(tofile,attr); if attr and SysFile <> 0 then setfattr(dest,(attr xor SysFile));
    {}

    {
    reset(tofile,1);
    {}

    
    if not add then if checkdirfile(dest)=0 then filedelete(dest);

    if checkdirfile(dest)<>0 then filecreate(dest);

    filemode:=2;
    reset(tofile,1);
    seek(tofile,filesize(tofile));

    repeat
     if keypressed then
      begin
       k:=readkey;
       if k=#27 then break;
      end;
     blockread(frfile,buf,sizeof(buf),numread);
     if filesize(frfile)=0 then break;
     blockwrite(tofile,buf,numread,numwritten);
    until (numread=0)or(numwritten<>numread);
{    getftime(frfile,ftime); setftime(tofile,ftime);{}
    close(frfile); close(tofile);
if IOResult=0 then;
End;
{============================================================================}
{== COPY DATA ===============================================================}
{============================================================================}
Procedure CopyData(source,dest:string; from,bytes:longint);
var
   frfile,tofile:file;
   numread,numwritten:integer;
   buf:array[1..16384] of byte;
   ftime:longint;
   attr:word;
   k:char;
   r,a,i:longint;
Begin
    filemode:=0;
    assign(frfile,source); reset(frfile,1);
    assign(tofile,dest);
    getfattr(tofile,attr); if attr and ReadOnly <> 0 then setfattr(dest,(attr xor ReadOnly));
    getfattr(tofile,attr); if attr and Hidden <> 0 then setfattr(dest,(attr xor Hidden));
    getfattr(tofile,attr); if attr and SysFile <> 0 then setfattr(dest,(attr xor SysFile));
    rewrite(tofile,1);
    seek(frfile,from);
    a:=round(int(bytes/sizeof(buf)));
    r:=round(bytes-a*sizeof(buf));
    if r<0 then r:=0;
    for i:=1 to a do
     begin
      if keypressed then begin k:=readkey; if k=#27 then break; end;
      blockread(frfile,buf,sizeof(buf),numread);
      if filesize(frfile)=0 then break;
      blockwrite(tofile,buf,numread,numwritten);
      if keypressed then begin k:=readkey; if k=#27 then break; end;
     end;
    blockread(frfile,buf,r,numread);
    blockwrite(tofile,buf,numread,numwritten);
    getftime(frfile,ftime); setftime(tofile,ftime);
    close(frfile); close(tofile);
End;
{============================================================================}
{== ECRAN ===================================================================}
{============================================================================}
procedure Ecran(s:pointer);
var
 se:word;
begin
 if (Lo(lastmode)=7) then se:=$B000 else se:=$B800;
 Move(s^,Ptr(se,0)^,4000);
end;


{============================================================================}
{== GET CDROM INFO ==========================================================}
{============================================================================}
procedure CD_ROMdat ( VAR DrvCount  : WORD;
                      VAR FirstDrv  : CHAR;
                      VAR IsMSCDEX  : BOOLEAN;
                      VAR IsCDROM   : BOOLEAN);
var Reg:Registers;
begin
FirstDrv  := #0;
IsMSCDEX  := FALSE;
IsCDROM   := FALSE;
Reg.AX := $1500;
Reg.BX := 0;
Intr ($2F, Reg);
DrvCount := Reg.BX;
IF (DrvCount = 0) THEN EXIT;
FirstDrv := CHR (Reg.CX + 65);
Reg.AX := $150B;
Reg.BX := 0;
Intr ($2F, Reg);
IF (Reg.BX <> $ADAD) THEN EXIT;
IsMSCDEX := TRUE;
IF (Reg.AX = 0) THEN EXIT;
IsCDROM := TRUE;
end;
{============================================================================}
{== IS IT CDROM ? ===========================================================}
{============================================================================}
function ItCDRom(drv:char):boolean;
var
   i:integer;
begin
itcdrom:=false;
CD_ROMdat (DrvCount, DrvName, IsMSCDEX, IsCDROM);
if drvcount<>0 then
 if (drv=DrvName)and(ismscdex)and(IsCDROM) then itcdrom:=true
 else itcdrom:=false
else itcdrom:=false;
end;
{============================================================================}
{== Files End Str ===========================================================}
{============================================================================}
function eFiles(n:longint; lang:byte):string;
var
   i:longint;
begin
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: efiles:='ов';
   1: efiles:='';
   2: efiles:='а';
   3: efiles:='а';
   4: efiles:='а';
   5: efiles:='ов';
   6: efiles:='ов';
   7: efiles:='ов';
   8: efiles:='ов';
   9: efiles:='ов';
  end;
  if n=11 then efiles:='ов';
  if n=12 then efiles:='ов';
  if n=13 then efiles:='ов';
  if n=14 then efiles:='ов';
 end
else
 begin
  if n=1 then efiles:='' else efiles:='s';
 end;
end;
{============================================================================}
{== Files End Str in 'Where'=================================================}
{============================================================================}
function ewFiles(n:longint; lang:byte):string;
var
   i:longint;
begin
i:=n div 10; i:=i*10; i:=n-i;
if lang=rus then
 begin
  case i of
   0: ewfiles:='ах';
   1: ewfiles:='е';
   2: ewfiles:='ах';
   3: ewfiles:='ах';
   4: ewfiles:='ах';
   5: ewfiles:='ах';
   6: ewfiles:='ах';
   7: ewfiles:='ах';
   8: ewfiles:='ах';
   9: ewfiles:='ах';
  end;
  if n=11 then ewfiles:='ах';
 end
else
 begin
  if n=1 then ewfiles:='' else ewfiles:='s';
 end;
end;
{============================================================================}
{== What Floppy Drives are present? =========================================}
{============================================================================}
procedure WhatFlopp(var DiskA, DiskB:byte);
var s:byte;
begin
port[$70]:=16; s:=port[$71];
DiskA:=s and 240; DiskA:=DiskA shr 4;
DiskB:=s and 15;
end;
{}

{============================================================================}
{== Get File Attributes =====================================================}
{============================================================================}
Function GetFileAttr(FileName : PChar) : integer; assembler;
{ Retrieves the attribute of a given file. The result is returned by DosError }
Asm
  MOV DosError,0
  PUSH DS
  LDS DX,FileName
  MOV AX,4300h
  INT 21h
  POP DS
  JNC @@noerror
  MOV DosError,AX { save error code in DOS global variable }
@@noerror:
  MOV AX,CX
End; { GetFileAttr }


{============================================================================}
{== Set File Attributes =====================================================}
{============================================================================}
Procedure SetFileAttr(FileName : pchar; Attr : word); assembler;
{ Sets the new attribute to a given file. The result is returned by DosError }
Asm
  MOV DosError,0
  PUSH DS
  LDS DX,FileName
  MOV CX,Attr
  MOV AX,4301h
  INT 21h
  POP DS
  JC  @@noerror
  MOV DosError,AX
@@noerror:
End; { SetFileAttr }


{============================================================================}
{============================================================================}
{============================================================================}
Function IsNotDriveReady (DriveSpec : Char) : Boolean; {A,B,etc}
Var
  result : Word;
  Drive,
  number,
  logical : Word;
  buf    : Array [1..512] of Byte;
  Regs   : Registers;
  temp: boolean;

Function DisketteDrives : Integer;
Var
  Regs : Registers;
begin
  FILLChar (Regs, SIZEOF (Regs), #0);
  INTR ($11, Regs);
  if Regs.AX and $0001 = 0 then
    DisketteDrives := 0
  else
    DisketteDrives := ( (Regs.AX SHL 8) SHR 14) + 1;
end;

begin
  IsNotDriveReady := True;     { Assume True to start }
  Drive   := ORD (UPCASE (DriveSpec) ) - 65;  { 0=a, 1=b, etc }

{writeln(drive,' ',DisketteDrives);
{  if Drive > DisketteDrives then
    Exit;  { do not CHECK HARD DRIVES }

  number  := 1;
  logical := 1;

  Inline (
    $55 /                       { PUSH BP         ; Interrupt 25 trashes all}
    $1E /                       { PUSH DS         ; Store DS                }
    $33 / $C0 /                 { xor  AX,AX      ; set AX to zero          }
    $89 / $86 / result /        { MOV  Result, AX ; Move AX to Result       }
    $8A / $86 / Drive /         { MOV  AL, Drive  ; Move Drive to AL        }
    $8B / $8E / number /        { MOV  CX, Number ; Move Number to CX       }
    $8B / $96 / logical /       { MOV  DX, Logical; Move Logical to DX      }
    $C5 / $9e / buf /           { LDS  BX, Buf    ; Move Buf to DS:BX       }
    $CD / $25 /                 { INT  25h        ; Call interrupt $25      }
    $5B /                       { POP  BX         ; Remove the flags valu fr}
    $1F /                       { POP  DS         ; Restore DS              }
    $5D /                       { POP  BP         ; Restore BP              }
    $73 / $04 /                 { JNB  Done       ; Jump ...                }
    $89 / $86 / result);        { MOV  Result, AX ; move error code to AX   }
  { Done: }

  IsNotDriveReady := (result = 0);
  write('drive=',drive,'   result=',result,'   ');

end;
