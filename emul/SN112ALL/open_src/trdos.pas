{$O+,F+}
unit trdos;

interface

const
  { коды ошибок }
  eOk=0;
  eBadController =1;
  eTimeOut       =2;
  eSeekError     =3;
  eDriveNotReady =4;
  eEndOfCylinder =5;
  eBadSector     =6;
  eDMAError      =7;
  eSectorNotFound=8;
  eWriteProtect  =9;
  eUnknownError  =10;

Type
  TBuf=ARRAY[0..4095] OF Byte;
  TFDDtype=(DD5,HD5,DD3,HD3);
  PDriveParams=^TDriveParams;
  TDriveParams=Record
    GPL, GPLF: Byte;
    EOT: 1..26;
    FillByte: Byte;
    FDDtype: TFDDtype;
    SectorSize: 1..8;
    HUT: 0..15;
    SRT: 0..15;
    HLT: 0..127;
  end;

  TSector=Record
    C, H, R, N: Byte;
  end;
  TSectors=ARRAY[1..26] OF TSector;
  PSectors=^TSectors;

  TOpResult=Record
    ST0, ST1, ST2, ST3, C, H, R, N: Byte;
  end;

Var IOError: Byte;
    OpResult: TOpResult;

    HobetaBug:boolean;

    RealBuf: TBuf;
    FDDType: Byte;
    FF: File OF TBuf;
    Track, Head, Sector: Byte;
    FDDParams: TDriveParams;
    TIP:byte;


function InitFDD(What:char; check:boolean):boolean;{}

function ErrorStr(err:byte):string;

procedure GetFDDRes; { Инициализация модуля и перехват ресурсов контроллера }
procedure FreeFDDRes; { Возврат ресурсов BIOS }

procedure StartDrive(Drive: Byte);

procedure SetDriveParams(Params: PDriveParams);

Procedure Recalibrate(Drive: Byte);
Procedure zxSeek(Drive,Track: Byte);
Procedure ReadSector(Buf: pointer; Drive,Track,Head,Sector, Quant: Byte);
Procedure WriteSector(Buf: Pointer; Drive,Track, Head, Sector, Quant: Byte);
Procedure FormatTrack(Sectors: Pointer; Drive,Head: Byte);
Procedure ResetController;
Procedure ReadTrack(Track: byte; Head: Byte);
procedure Load_TRDOS;
procedure Save_TRDOS;


implementation

uses Dos, Crt, rv, pc, main, vars, palette, TRD, FDD, FDI, sn_obj;

const
  MainStat=$3f2;      { Общий регистр состояния }
  ContStat=$3f4;      { Регистр состояния контроллера }
  ContData=$3f5;      { Регистр данных контроллера }

  MaxDataSize=256*16; {512*18 Максимальный размер считываемого блока данных}

type
  TBuffer= ARRAY[0..MaxDataSize*2-1] OF Byte;
  PBuffer=^TBuffer;

var
  DriveParams, InternalDriveParams: PDriveParams;
  Buffer, BufBegin: PBuffer;
  DMAPage, DMAOfs: Word;







function InitFDD(What:char; check:boolean):boolean;{}
var atempt,ab,DiskA,DiskB:byte;
label remap;

begin
InitFDD:=false;
FDDType:=Ord(UpCase(What))-Ord('A');
GetFDDRes; { Установка новых параметров дисковода }

port[$70]:=16; ab:=port[$71];
DiskA:=ab and 240; DiskA:=DiskA shr 4;
DiskB:=ab and 15;
if UpCase(What)='A' then ab:=DiskA else ab:=DiskB;
Case ab of
 1:begin FDDParams.GPL:=$2A; FDDParams.GPLF:=$50; TIP:=1; end; {360k  5.25"}
 2:begin FDDParams.GPL:=$2A; FDDParams.GPLF:=$50; TIP:=2; end; {1.2k  5.25"}
 3:begin FDDParams.GPL:=$1B; FDDParams.GPLF:=$6C; TIP:=3; end; {720k  3.5"}
 4:begin FDDParams.GPL:=$1B; FDDParams.GPLF:=$6C; TIP:=4; end; {1.44k 3.5"}
End;

FDDParams.FillByte:=$F6;
FDDParams.EOT:=16;
FDDParams.SectorSize:=1;
FDDParams.HUT:=$D;
FDDParams.SRT:=$F;
FDDParams.HLT:=1;

if Check then
 Begin

  Atempt:=1;
{  Message('Выяснение типа диска... ');{}
remap:
  IF TIP=1 THEN FDDParams.FDDtype:=DD5; {5.25"  360kB}
  IF TIP=2 THEN FDDParams.FDDtype:=HD5; {5.25"  1.2Mb}
  IF TIP=3 THEN FDDParams.FDDtype:=DD3; {3.5"   720kB}
  IF TIP=4 THEN FDDParams.FDDtype:=HD3; {3.5"   1.44mB}

  SetDriveParams(@FDDParams);
  Recalibrate(FDDType);  { Инициализация контроллера }

  zxSeek(FDDType,0); ReadSector(@RealBuf,FDDType,0,0,9,1);
   IF IOError<>eOk THEN BEGIN
    inc(TIP);
    if TIP>4 then TIP:=1;
    inc(Atempt);
    if Atempt>4 then
     begin {WriteLn('это не TR-DOS диск.'); Halt(1);{}
      FreeFDDRes; { Восстановление старых параметров дисковода }
      Exit;
     end;
    goto remap;
    FreeFDDRes; { Восстановление старых параметров дисковода }
   END;
 End
else
 Begin
  IF TIP=1 THEN FDDParams.FDDtype:=DD5; {5.25"  360kB}
  IF TIP=2 THEN FDDParams.FDDtype:=HD5; {5.25"  1.2Mb}
  IF TIP=3 THEN FDDParams.FDDtype:=DD3; {3.5"   720kB}
  IF TIP=4 THEN FDDParams.FDDtype:=HD3; {3.5"   1.44mB}
  SetDriveParams(@FDDParams);
  Recalibrate(FDDType);  { Инициализация контроллера }
 End;
{
  Write(#13'Диск TR-DOS, для устройства ');
  Case TIP of
   1: writeln('5.25", 360k');
   2: writeln('5.25", 1.2M');
   3: writeln('3.5", 720k');
   4: writeln('3.5", 1.44M');
  End;

  if ((ab=3)or(ab=4))and((TIP=1)or(TIP=2)) then Message('Эмулем Шалаева форматирован? ;)');
{
  Write('Проверка на вшивость... ');{}
  HobetaBug:=true;
  ReadSector(@RealBuf,FDDType,0,1,1,1);
  if (IOError=eOk) then
   Begin
{    Writeln(#13'Диск имеющий косяк в hobeta на первой стороне!');{}
   End
  else
   Begin
{    Writeln('все нормально');{}
    HobetaBug:=false;
   End;
InitFDD:=true;
end;








function ErrorStr(err:byte):string;
begin
Case err of
 0: ErrorStr:='Ok              ';
 1: ErrorStr:='Bad Controller  ';
 2: ErrorStr:='Time Out        ';
 3: ErrorStr:='Seek Error      ';
 4: ErrorStr:='Drive Not Ready ';
 5: ErrorStr:='End Of Cylinder ';
 6: ErrorStr:='Bad Sector      ';
 7: ErrorStr:='DMA Error       ';
 8: ErrorStr:='Sector Not Found';
 9: ErrorStr:='Write Protect   ';
 10:ErrorStr:='Unknown Error   ';
 27:ErrorStr:='User Break      ';
End;
end;










{-------------------------------------------------------}
Function TestBit(Num, Bit: Byte): Boolean;
const  Bits: ARRAY[0..7] OF Word = (1,2,4,8,16,32,64,128);
begin
  TestBit:=(Num AND Bits[Bit])<>0;
end;






Function In_FDC: Byte;
VAR i: LongInt;
begin
  i:=128;
  While (port[$3F4] AND $C0)<>$C0 DO BEGIN
    Dec(i); IF i=0 THEN Exit;
  END;
  IF i<>0 THEN In_FDC:=port[$3F5]
  ELSE IOError:=eTimeOut;
end;







Procedure Out_FDC(Comm: Byte);
VAR i: LongInt;
begin
  i:=128;
  While (port[$3F4] AND $C0)<>$80 DO BEGIN
    Dec(i); IF i=0 THEN Exit;
  END;
  IF i<>0 THEN port[$3F5]:=Comm
  ELSE IOError:=eTimeOut;
end;


{процедура ввода байта из контроллера FD}
{
Function In_FDC: Byte;
 var InB:byte;
begin
 asm
     mov  dx, 3F4h
   @WaitBit7i:
     in   al, dx
     test al, 80h
     jz   @WaitBit7i
     inc  dx
     in   al, dx
     mov  InB, al
 end;
 In_FDC:=InB;
end;
{}
{процедура вывода байта в контроллер FD}
{
Procedure Out_FDC(OutB: Byte); assembler;
asm
     mov  dx, 3F4h
   @WaitBit7o:
     in   al, dx
     test al, 80h
     jz   @WaitBit7o
     inc  dx
     mov  al, OutB
     out  dx, al
end;
{}









Procedure ReadResult;
begin
  OpResult.ST0:=In_FDC;
  OpResult.ST1:=In_FDC;
  OpResult.ST2:=In_FDC;
  OpResult.C:=In_FDC;
  OpResult.H:=In_FDC;
  OpResult.R:=In_FDC;
  OpResult.N:=In_FDC;
end;






Function SenseInterruptStatus: Byte;
VAR PCN : Byte;
Begin
  Out_FDC($08);
  OpResult.ST0:=In_FDC;
  SenseInterruptStatus:=OpResult.ST0;
  PCN:=In_FDC;
End;







Procedure WaitInterrupt;
 var timer:word;
     WasInt:byte;
begin
  WasInt:=0; timer:=4000;  { 2 sec. }
  While (WasInt=0)AND(Timer>0) DO begin
   dec(timer); delay(1);
   asm
      push DS
      push AX
      xor  AX, AX
      mov  DS, AX
      test byte ptr DS:[43Eh], 80h
      jz   @noInt
      and  byte ptr DS:[43Eh], 7Fh
      mov  WasInt, 1
   @noInt:
      pop  AX
      pop  DS
   end;
  end;
  IF WasInt=0 then IOError:=eTimeOut;
end;












Procedure ResetController;
var i: Integer;
begin
  port[MainStat]:=port[MainStat] AND $FB;
  port[MainStat]:=port[MainStat] OR $04;
  WaitInterrupt;
  FOR i:=0 TO 3 DO
  BEGIN
    IF SenseInterruptStatus<>($c0+i) THEN BEGIN
      IOError:=eBadController;
      Exit;
    END;
  END;
end;









procedure SetDriveParams(Params: PDriveParams);
begin
  IOError:=eOk;
  DriveParams:=Params;
  { Настройка дисковода (Specify) и скорости передачи }
  Out_FDC($03);
  WITH DriveParams^ DO
  BEGIN
    Out_FDC(SRT OR (HUT SHL 4));
    Out_FDC(HLT SHL 1);
  END;
  { Установка скорости передачи данных DD: 250 kb/s; HD: 500 kb/s }
  IF Params^.FDDtype=HD5 THEN port[$3F7]:=1;
  IF Params^.FDDtype=HD3 THEN port[$3F7]:=2;
  IF Params^.FDDtype=DD5 THEN port[$3F7]:=0; { ? }
  IF Params^.FDDtype=DD3 THEN port[$3F7]:=0;
end;











procedure StartDrive(Drive: Byte);
VAR NewValue, OldValue: Byte;
begin
  IOError:=eOk;
  NewValue:=(1 SHL (Drive+4)) OR Drive OR $0C;
  OldValue:=port[MainStat];
  IF OldValue<>NewValue THEN BEGIN
    port[MainStat]:=NewValue;
    Delay(500);
  END;
end;











procedure GetFDDRes;
var s, o: Word;
  { Увеличить значение указателя p на величину Off}
  procedure IncPtr(VAR p: PBuffer; Off: Word);
  begin
    asm
      push      ds
      lds       di,p
      mov       ax,Off
      add       [di],ax
      jnc       @1
      add       word ptr [di+2],1000h
  @1: pop       ds
    end;
  end;
  { Преобразовать указатель в страницу и смещение для DMA}
  procedure ConvPtr(p: Pointer; VAR Page, Off: Word);
  begin
    asm
      push      ds
      lds       dx,p
      mov       bx,ds
      mov       ax,bx
      mov       cl,4
      shl       ax,cl
      add       ax,dx
      pushf
      lds       di,off
      mov       [di],ax
      mov       ax,bx
      mov       cl,12
      shr       ax,cl
      popf
      jnc        @1
      inc       ax
  @1: lds       di,page
      mov       [di],ax
      pop       ds
    end;
  end;

begin
  IOError:=eOk;
  ResetController;
  IF IOError<>eOk THEN Exit;
{ Выделить память для внутреннего буфера }
  New(Buffer);
  ConvPtr(Buffer, DMAPage, DMAOfs);
  BufBegin:=Buffer;
  IncPtr(BufBegin,MaxDataSize-1);
  ConvPtr(BufBegin, s,o);
  IF s>DMAPage THEN BEGIN
    DMAPage:=s; DMAOfs:=0;
  END;
  BufBegin:=Ptr(DMAPage SHL 12,DMAOfs);
end;









procedure FreeFDDRes;
begin
  IOError:=eOk;
  port[$0A]:=$06;          { маскировать 2 канал }
  Dispose(Buffer);
end;








Procedure  Recalibrate(Drive: Byte);
VAR Tries: Byte;
begin
  IOError:=eOk;
  StartDrive(Drive);
  FOR Tries:=1 TO 2 DO BEGIN
    Out_FDC($07);
    Out_FDC(Drive);
    WaitInterrupt;         IF IOError<>eOk THEN Exit;
    IF (SenseInterruptStatus AND $10)=0 THEN Exit; { Операция завершена}
    IF IOError<>eOk THEN Exit;
  END;
  IF IOError<>eOk THEN Exit;
  IF (OpResult.ST0 AND $C0) <> 0  THEN IOError:=eSeekError;
end;









Procedure zxSeek(Drive,Track: Byte);
begin
  IOError:=eOk;
  StartDrive(Drive);
  Out_FDC($0F);
  Out_FDC(Drive);
  Out_FDC(Track);
  WaitInterrupt;         IF IOError<>eOk THEN Exit;
  IF (SenseInterruptStatus AND $C0) <> 0  THEN IOError:=eSeekError;
end;








Procedure ReadSector(Buf: pointer; Drive,Track, Head, Sector, Quant: Byte);
var tmp: Byte;
    BlockSize: Word;
begin

  asm {в счетчик [0:440] ведающий остановкой мотора дискеты заносим 5 сек}
   push DS
   push AX
   xor  AX, AX
   mov  DS, AX
   mov  byte ptr DS:[440h], 90
   pop  AX
   pop  DS
  end;
  IOError:=eOk;

  { Программирование DMA }
  BlockSize:=Quant*(128 SHL DriveParams^.SectorSize);
  asm cli end;
  port[$0A]:=$06;                   { маскировать 2 канал }
  port[$0C]:=$46;                   { сбросить триггер }
  port[$04]:=DMAOfs AND $FF;        { смещение в странице DMA, мл. байт }
  port[$04]:=DMAOfs SHR 8;          { смещение в странице DMA, ст. байт }
  port[$81]:=DMAPage AND $FF;       { страница DMA }
  port[$05]:=(BlockSize-1) AND $FF; { размер блока, мл. байт }
  port[$05]:=(BlockSize-1) SHR 8;   { размер блока, ст. байт }
  port[$0B]:=$46;                   { режим: FDD -> Memory }
  port[$0A]:=$02;                   { размаскировать 2 канал }
  asm sti end;

  { Формирование приказа }
  Out_FDC($46);
  IF Head>0 THEN Out_FDC(Drive OR $04) ELSE Out_FDC(Drive);
  Out_FDC(Track);
  if HobetaBug then Out_FDC(Head) else Out_FDC(0);
  Out_FDC(Sector);
  Out_FDC(DriveParams^.SectorSize);
  Out_FDC(DriveParams^.EOT);
  Out_FDC(DriveParams^.GPL);
  Out_FDC($FF); { DTL }

  { Выполнение }
  WaitInterrupt; IF IOError<>eOk THEN Exit;
  ReadResult;    IF IOError<>eOk THEN Exit;    { Считывание результатов }

  { Анализ результатов операции}
  WITH OpResult DO BEGIN
    IF (ST0 AND $C0) <>0 THEN BEGIN
      IOError:=eUnknownError;
      IF TestBit(ST0,3) THEN IOError:=eDriveNotReady;
      IF TestBit(ST1,7) THEN IOError:=eEndOfCylinder;
      IF TestBit(ST1,5) OR TestBit(ST2,5) OR TestBit(ST2,0) THEN
        IOError:=eBadSector;
      IF TestBit(ST1,2) OR TestBit(ST1,4) THEN IOError:=eSectorNotFound;
      IF TestBit(ST1,4) THEN IOError:=eDMAError;
    END;
  END;

  { Копирование буфера }
  Move(BufBegin^,Buf^,BlockSize);

end;








{запись сектора}
Procedure  WriteSector(Buf: Pointer; Drive,Track, Head, Sector, Quant: Byte);

procedure  WS(Buf: Pointer; Drive,Track, Head, Sector, Quant: Byte);
var BlockSize: Word;
begin

  asm {в счетчик [0:440] ведающий остановкой мотора дискеты заносим 5 сек}
   push DS
   push AX
   xor  AX, AX
   mov  DS, AX
   mov  byte ptr DS:[440h], 90
   pop  AX
   pop  DS
  end;
  IOError:=eOk;

  { Программирование DMA }
  BlockSize:=Quant*(128 SHL DriveParams^.SectorSize);
  asm cli end;
  port[$0A]:=$06;                   { маскировать 2 канал }
  port[$0C]:=$4A;                   { сбросить триггер }
  port[$04]:=DMAOfs AND $FF;        { смещение в странице DMA, мл. байт }
  port[$04]:=DMAOfs SHR 8;          { смещение в странице DMA, ст. байт }
  port[$81]:=DMAPage AND $FF;       { страница DMA }
  port[$05]:=(BlockSize-1) AND $FF; { размер блока, мл. байт }
  port[$05]:=(BlockSize-1) SHR 8;   { размер блока, ст. байт }
  port[$0B]:=$4A;                   { режим: Memory -> FDD }
  port[$0A]:=$02;                   { размаскировать 2 канал }
  asm sti end;

  { Копирование буфера }
  Move(Buf^,BufBegin^,BlockSize);

  { Формирование приказа }
  Out_FDC($45);
  IF Head>0 THEN Out_FDC(Drive OR $04) ELSE Out_FDC(Drive);
  Out_FDC(Track);
  if HobetaBug then{} Out_FDC(Head) else Out_FDC(0){};
  Out_FDC(Sector);
  Out_FDC(DriveParams^.SectorSize);
  Out_FDC(DriveParams^.EOT);
  Out_FDC(DriveParams^.GPL);
  Out_FDC($FF); { DTL }

  { Выполнение }
  WaitInterrupt; IF IOError<>eOk THEN Exit;
  ReadResult;    IF IOError<>eOk THEN Exit;    { Считывание результатов }
  ReadResult;    IF IOError<>eOk THEN Exit;    { Считывание результатов }

  { Анализ результатов операции}
  WITH OpResult DO BEGIN
    IF (ST0 AND $C0) <>0 THEN BEGIN
      IOError:=eUnknownError;
      IF TestBit(ST0,3) THEN IOError:=eDriveNotReady;
      IF TestBit(ST1,7) THEN IOError:=eEndOfCylinder;
      IF TestBit(ST1,5) OR TestBit(ST2,5) OR TestBit(ST2,0) THEN
        IOError:=eBadSector;
      IF TestBit(ST1,2) OR TestBit(ST1,4) THEN IOError:=eSectorNotFound;
      IF TestBit(ST1,4) THEN IOError:=eDMAError;
      IF TestBit(ST1,1) THEN IOError:=eWriteProtect;
    END;
  END;

end;

Begin
WS(Buf,Drive,Track,Head,Sector,Quant);
WS(Buf,Drive,Track,Head,Sector,Quant);{}
End;











Procedure FormatTrack(Sectors: Pointer; Drive,Head: Byte);
var BlockSize: Word;
begin
  asm {в счетчик [0:440] ведающий остановкой мотора дискеты заносим 5 сек}
   push DS
   push AX
   xor  AX, AX
   mov  DS, AX
   mov  byte ptr DS:[440h], 90
   pop  AX
   pop  DS
  end;
  IOError:=eOk;
  { Программирование DMA }
  BlockSize:=DriveParams^.EOT*SizeOf(TSector);
  asm cli end;
  port[$0A]:=$06;                   { маскировать 2 канал }
  port[$0C]:=$4A;                   { сбросить триггер }
  port[$04]:=DMAOfs AND $FF;        { смещение в странице DMA, мл. байт }
  port[$04]:=DMAOfs SHR 8;          { смещение в странице DMA, ст. байт }
  port[$81]:=DMAPage AND $FF;       { страница DMA }
  port[$05]:=(BlockSize-1) AND $FF; { размер блока, мл. байт }
  port[$05]:=(BlockSize-1) SHR 8;   { размер блока, ст. байт }
  port[$0B]:=$4A;                   { режим: Memory -> FDD }
  port[$0A]:=$02;                   { размаскировать 2 канал }
  asm sti end;
  { Копирование буфера }
  Move(Sectors^,BufBegin^,BlockSize);
  { Формирование приказа }
  Out_FDC($4D);
  IF Head>0 THEN Out_FDC(Drive OR $04) ELSE Out_FDC(Drive);
  Out_FDC(DriveParams^.SectorSize);
  Out_FDC(DriveParams^.EOT);
  Out_FDC(DriveParams^.GPLF);
  Out_FDC(DriveParams^.FillByte);
  { Выполнение }
  WaitInterrupt;
  IF IOError<>eOk THEN Exit;
  ReadResult; IF IOError<>eOk THEN Exit;    { Считывание результатов }
  { Анализ результатов операции}
  WITH OpResult DO BEGIN
    IF (ST0 AND $C0) <>0 THEN BEGIN
      IOError:=eUnknownError;
      IF TestBit(ST0,3) THEN IOError:=eDriveNotReady;
      IF TestBit(ST1,7) THEN IOError:=eEndOfCylinder;
      IF TestBit(ST1,5) OR TestBit(ST2,5) OR TestBit(ST2,0) THEN
        IOError:=eBadSector;
      IF TestBit(ST1,2) OR TestBit(ST1,4) THEN IOError:=eSectorNotFound;
      IF TestBit(ST1,4) THEN IOError:=eDMAError;
      IF TestBit(ST1,1) THEN IOError:=eWriteProtect;
    END;
  END;
end;







Procedure ReadTrack(Track: byte; Head: Byte);
Var Tries: Integer;
BEGIN
  Tries:=1;
  zxSeek(FDDType,Track);
  REPEAT
    ReadSector(@RealBuf,FDDType,Track,Head,1,16);
    Dec(Tries);
  UNTIL (Tries=0) OR (IOError=eOk);
END;









Procedure ReadTrackSector(Track: byte; Head: Byte; Sector: Byte);
Var i,sec,Tries: Integer; var bufw:array[1..256]of byte; wasHobetaBug:boolean;
    k:char;
BEGIN
wasHobetaBug:=HobetaBug;
Tries:=5;
{zxSeek(FDDType,Track);{}
REPEAT
 Case Tries of
  1: Colour(Blue,Blue);
  2: Colour(Blue,Black);
  3: Colour(Blue,LightRed);
  4: Colour(Blue,LightMagenta);
  5: Colour(Blue,LightGreen);
 End;
 ReadSector(@Bufw,FDDType,Track,Head,Sector,1);
 if IOError<>eOk then
  Begin
   HobetaBug:=not HobetaBug;
   ReadSector(@Bufw,FDDType,Track,Head,Sector,1);
   if IOError<>eOk then HobetaBug:=not HobetaBug;
  End;
 for i:=1 to 256 do Realbuf[i-1+256*(Sector-1)]:=bufw[i];
 if Tries<5 then gotoxy(wherex-1,wherey); Write('');
 Dec(Tries);
 if KeyPressed then
  Begin
   k:=ReadKey;
   if k=#27 then begin IOError:=27; exit; end;
  End;
UNTIL (Tries=0) OR (IOError=eOk);

if IOError<>eOk then for i:=1 to 256 do Realbuf[i-1+256*(Sector-1)]:=FDDParams.FillByte;
HobetaBug:=wasHobetaBug;
END;







Procedure WriteTrackSector(Track: byte; Head: Byte; Sector: Byte);
Var i,sec,Tries: Integer; var bufw:array[1..256]of byte; wasHobetaBug:boolean;
    k:char;
BEGIN
wasHobetaBug:=HobetaBug;
Tries:=5;
{zxSeek(FDDType,Track);{}
REPEAT
 Case Tries of
  1: Colour(Blue,Blue);
  2: Colour(Blue,Black);
  3: Colour(Blue,LightRed);
  4: Colour(Blue,LightMagenta);
  5: Colour(Blue,LightGreen);
 End;
 for i:=1 to 256 do bufw[i]:=Realbuf[i-1+256*(Sector-1)];

 WriteSector(@Bufw,FDDType,Track,Head,Sector,1);
 if IOError<>eOk then
  Begin
   HobetaBug:=not HobetaBug;
   WriteSector(@Bufw,FDDType,Track,Head,Sector,1);
   if IOError<>eOk then HobetaBug:=not HobetaBug;
  End;
 if KeyPressed then
  Begin
   k:=ReadKey;
   if k=#27 then begin IOError:=27; exit; end;
  End;
 if Tries<5 then gotoxy(wherex-1,wherey); Write('');
 Dec(Tries);
UNTIL (Tries=0) OR (IOError=eOk);

{if IOError<>eOk then for i:=1 to 256 do Realbuf[i-1+256*(Sector-1)]:=FDDParams.FillByte;{}
HobetaBug:=wasHobetaBug;
END;






procedure Load_TRDOS;
label
      beg,fin;
var
      fname:string;
      bads,lastx,i:integer;
      Out,error:boolean;
      key,What:char;
      TotalTracks,up80err,In1HeadErr:byte;

begin
  What:=ChooseDrive(focus,DiskMenuType,LANG,'A');
  if (What<>'A')and(What<>'B') then exit;

beg:
  CancelSB;
  if not InitFDD(What,CheckMedia) then exit;

  CurOff;
  window(15,8,66,18);
  scputwin(Blue,White,13,5,67,21);
  if LANG=rus then cmcentre(Blue,White,5,' Чтение TR-DOS диcкеты ')
              else cmcentre(Blue,White,5,' Reading TR-DOS disk ');
  zxSeek(FDDType,0);
  ReadSector(@RealBuf,FDDType,0,0,9,1);
  fname:=''; for i:=1 to 8 do fname:=fname+chr(Realbuf[$f5+i-1]); fname:=hob2pc(fname);
{  cmprint(Blue,White,15,6,'Disk name:');{}
  cmprint(Blue,Yellow,15{+11{},6,fname);

  if nospace(fname)='' then fname:='zxdisk';
  fname:=fname+'.trd';
  fname:=CheckEx(pcndOf(Focus),fname);

{  cmprint(Blue,LightGray,15+11,6,strlo(''+fname+''));{}

  { Открытие выходного файла }
  Assign(FF,fname); ReWrite(FF);

  { Чтение дорожек и запись в файл }
{  Writeln('Копирование дискеты...');{}
  bads:=0; error:=false; up80err:=0; Out:=false;
  if LoadUp80 then TotalTracks:=82 else TotalTracks:=79;
  FOR Track:=0 TO TotalTracks DO BEGIN
    zxSeek(FDDType,Track);
    FOR Head:=0 TO 1 DO BEGIN

      Colour(Blue,White);
      Write('Track:');
      Colour(Blue,LightGray);
      Write(Track:2);
      Colour(Blue,White);
      Write(' Head:');
      Colour(Blue,LightGray);
      Write(Head:1,'  ');

      In1HeadErr:=0;


      ReadSector(@RealBuf,FDDType,Track,Head,1,16);
      if IOError=0 then
       Begin
        Colour(Blue,LightGreen);
        gotoxy(wherex-1,wherey);
        FOR Sector:=1 to 16 DO BEGIN Write(''); END;
       End
      else
      {}
       Begin
        gotoxy(wherex-1,wherey);
        FOR Sector:=1 to 16 DO BEGIN
          ReadTrackSector(Track,Head,Sector);
          if IOError=27 then goto fin;
          IF IOError<>eOk THEN
           BEGIN
            cmprint(Blue,LightRed,50,wherey,ErrorStr(IOError));
            inc(bads);
            inc(In1HeadErr);
            if (track>79)and(IOError=eUnknownError) then inc(up80err);
            error:=true;
            if up80err>3 then begin Out:=true; break; end;
            if In1HeadErr>3 then begin Out:=true; break; end;
           END;
          IF keypressed THEN BEGIN key:=readkey; if key=kb_ESC then goto fin; END;
        END;
       End;

     up80err:=0;
     WriteLn;
     if (up80err<=3)and(In1HeadErr<=3) then Write(FF,RealBuf){};{}
     if (IOError=eOk)and(not error) then
      Begin
       cmprint(Blue,White,50,wherey-1,ErrorStr(IOError));
       error:=false;
      End;
     IF keypressed THEN BEGIN key:=readkey; if key=kb_ESC then goto fin; END;
     if Out then break;
    END;
   if Out then break;
  END;

{  Message('Файл сформирован.');{}
fin:
  cmprint(Blue,White,15,20,strr(bads)+' bad sectors.');

  Close(FF); { Закрытие файла }
  FreeFDDRes; { Восстановление старых параметров дисковода }

  if LANG=rus then fname:='~`ESC~` Отмена  ~`ENTER~` Загpузить еще один диcк'
              else fname:='~`ESC~` Cancel  ~`ENTER~` To load one more disk';
  cStatusBar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,fname);

  key:=readkey;
  restscr;
  if (key=kb_ENTER){or(key=kb_SPACE){} then goto beg;
end;







procedure Save_TRDOS;
label
      beg,fin;
var
      fname:string;
      bads,lastx,i:integer;
      Out,error:boolean;
      key,What:char;
      TotalTracks,up80err,In1HeadErr:byte;
      fr:file;
      typeOfImage:byte;
      offData:longint;
      p:TPanel;

begin
  What:=ChooseDrive(focus,DiskMenuType,LANG,'A');
  if (What<>'A')and(What<>'B') then exit;

beg:
  CancelSB;
  if not InitFDD(What,CheckMedia) then exit;

  CurOff;
  window(15,8,66,18);
  scputwin(Blue,White,13,5,67,21);
  if LANG=rus then cmcentre(Blue,White,5,' Запиcь TR-DOS диcкеты ')
              else cmcentre(Blue,White,5,' Writing TR-DOS disk ');

  fname:=pcndOf(focus)+TrueNameOf(focus,IndexOf(focus));
  cmprint(Blue,Yellow,15,6,TrueNameOf(focus,IndexOf(focus)));

  TypeOfImage:=fdiPanel;
  if isTRD(fname) then TypeOfImage:=trdPanel;
  if isFDD(fname) then TypeOfImage:=fddPanel;

{$I-}
  { Открытие файла }
  Case TypeOfImage of
   trdPanel: begin Assign(FF,fname); Reset(FF); end;
   fdiPanel:
    begin
     Assign(FR,fname); Reset(FR,1);
     Case focus of left: p:=lp; right: p:=rp; End;
     p.fdiMDFs(fname);
    end;
  End;

  { Writeln('Запись дискеты...');{}
  bads:=0; error:=false; up80err:=0; Out:=false;
  if LoadUp80 then TotalTracks:=82 else TotalTracks:=79;
  FOR Track:=0 TO TotalTracks DO BEGIN
    zxSeek(FDDType,Track);
    FOR Head:=0 TO 1 DO BEGIN

      Colour(Blue,White);
      Write('Track:');
      Colour(Blue,LightGray);
      Write(Track:2);
      Colour(Blue,White);
      Write(' Head:');
      Colour(Blue,LightGray);
      Write(Head:1,'  ');

      In1HeadErr:=0;

      for i:=0 to 4095 do RealBuf[i]:=0;

      {Чтение дорожки}
      Case TypeOfImage of
       trdPanel: Read(FF,RealBuf);
       fdiPanel:
        begin
         seek(FR,p.fdiRec.offData+Track*4096*2+Head*(256*16));
         blockread(FR,RealBuf,256*16);
        end;
       fddPanel:
        begin
         for Sector:=1 to 16 do
          begin
           fddReadSector(fname,Track*2+Head,Sector);
           for i:=0 to 255 do RealBuf[i+(Sector-1)*256]:=fddSectorBuf[i];
          end;
        end;
      End;

      WriteSector(@RealBuf,FDDType,Track,Head,1,16);
      if IOError=0 then
       Begin
        Colour(Blue,LightGreen);
        gotoxy(wherex-1,wherey);
        FOR Sector:=1 to 16 DO BEGIN Write(''); END;
       End
      else
       Begin
        gotoxy(wherex-1,wherey);
        FOR Sector:=1 to 16 DO BEGIN
          WriteTrackSector(Track,Head,Sector);
          if IOError=27 then goto fin;
          IF IOError<>eOk THEN
           BEGIN
            cmprint(Blue,LightRed,50,wherey,ErrorStr(IOError));
            inc(bads);
            inc(In1HeadErr);
            if (track>79)and(IOError=eUnknownError) then inc(up80err);
            error:=true;
            if up80err>3 then begin Out:=true; break; end;
            if In1HeadErr>3 then begin Out:=true; break; end;
           END;
          IF keypressed THEN BEGIN key:=readkey; if key=kb_ESC then goto fin; END;
        END;
       End;

     up80err:=0;
     WriteLn;
     if (IOError=eOk)and(not error) then
      Begin
       cmprint(Blue,White,50,wherey-1,ErrorStr(IOError));
       error:=false;
      End;
     Case TypeOfImage of
      trdPanel: if EOF(FF) then Out:=true;
      fdiPanel: if EOF(FR) then Out:=true;
     End;
     IF keypressed THEN BEGIN key:=readkey; if key=kb_ESC then goto fin; END;
     if Out then break;
    END;
   if Out then break;
  END;

fin:
  cmprint(Blue,White,15,20,strr(bads)+' bad sectors.');

{ Закрытие файла }
  Case TypeOfImage of
   trdPanel: Close(FF);
   fdiPanel: Close(FR);
  End;
  
  FreeFDDRes; { Восстановление старых параметров дисковода }
{$I+}
if IOResult<>0 then;

  if LANG=rus then fname:='~`ESC~` Отмена  ~`ENTER~` Записать еще один диcк'
              else fname:='~`ESC~` Cancel  ~`ENTER~` To save one more disk';
  cStatusBar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,fname);

  key:=readkey;
  restscr;
  if (key=kb_ENTER){or(key=kb_SPACE){} then goto beg;
end;




end.