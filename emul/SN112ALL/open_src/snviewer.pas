{$O+,F+}
Unit snViewer;
Interface

Function IntView(fname:string):byte;

Implementation

uses RV, palette, main;
Const
  MinMemLimit = $00000200;

Const
{ Standart key codes }

     kbEsc       = $011B;  kbAltSpace  = $0200;  kbCtrlIns   = $0400;
     kbShiftIns  = $0500;  kbCtrlDel   = $0600;  kbShiftDel  = $0700;
     kbBack      = $0E08;  kbCtrlBack  = $0E7F;  kbShiftTab  = $0F00;
     kbTab       = $0F09;  kbAltQ      = $1000;  kbAltW      = $1100;
     kbAltE      = $1200;  kbAltR      = $1300;  kbAltT      = $1400;
     kbAltY      = $1500;  kbAltU      = $1600;  kbAltI      = $1700;
     kbAltO      = $1800;  kbAltP      = $1900;  kbCtrlEnter = $1C0A;
     kbEnter     = $1C0D;  kbAltA      = $1E00;  kbAltS      = $1F00;
     kbAltD      = $2000;  kbAltF      = $2100;  kbAltG      = $2200;
     kbAltH      = $2300;  kbAltJ      = $2400;  kbAltK      = $2500;
     kbAltL      = $2600;  kbAltZ      = $2C00;  kbAltX      = $2D00;
     kbAltC      = $2E00;  kbAltV      = $2F00;  kbAltB      = $3000;
     kbAltN      = $3100;  kbAltM      = $3200;  kbF1        = $3B00;
     kbF2        = $3C00;  kbF3        = $3D00;  kbF4        = $3E00;
     kbF5        = $3F00;  kbF6        = $4000;  kbF7        = $4100;
     kbF8        = $4200;  kbF9        = $4300;  kbF10       = $4400;
     kbHome      = $4700;  kbUp        = $4800;  kbPgUp      = $4900;
     kbGrayMinus = $4A2D;  kbLeft      = $4B00;  kbRight     = $4D00;
     kbGrayPlus  = $4E2B;  kbEnd       = $4F00;  kbDown      = $5000;
     kbPgDn      = $5100;  kbIns       = $5200;  kbDel       = $5300;
     kbShiftF1   = $5400;  kbShiftF2   = $5500;  kbShiftF3   = $5600;
     kbShiftF4   = $5700;  kbShiftF5   = $5800;  kbShiftF6   = $5900;
     kbShiftF7   = $5A00;  kbShiftF8   = $5B00;  kbShiftF9   = $5C00;
     kbShiftF10  = $5D00;  kbCtrlF1    = $5E00;  kbCtrlF2    = $5F00;
     kbCtrlF3    = $6000;  kbCtrlF4    = $6100;  kbCtrlF5    = $6200;
     kbCtrlF6    = $6300;  kbCtrlF7    = $6400;  kbCtrlF8    = $6500;
     kbCtrlF9    = $6600;  kbCtrlF10   = $6700;  kbAltF1     = $6800;
     kbAltF2     = $6900;  kbAltF3     = $6A00;  kbAltF4     = $6B00;
     kbAltF5     = $6C00;  kbAltF6     = $6D00;  kbAltF7     = $6E00;
     kbAltF8     = $6F00;  kbAltF9     = $7000;  kbAltF10    = $7100;
     kbCtrlPrtSc = $7200;  kbCtrlLeft  = $7300;  kbCtrlRight = $7400;
     kbCtrlEnd   = $7500;  kbCtrlPgDn  = $7600;  kbCtrlHome  = $7700;
     kbAlt1      = $7800;  kbAlt2      = $7900;  kbAlt3      = $7A00;
     kbAlt4      = $7B00;  kbAlt5      = $7C00;  kbAlt6      = $7D00;
     kbAlt7      = $7E00;  kbAlt8      = $7F00;  kbAlt9      = $8000;
     kbAlt0      = $8100;  kbAltMinus  = $8200;  kbAltEqual  = $8300;
     kbCtrlPgUp  = $8400;  kbAltBack   = $0800;  kbSpaceBar  = $3920;

{ Special }
     kbNoKey     = $FFFF;

{ Keyboard state and shift masks }

     kbRightShift  = $0001;
     kbLeftShift   = $0002;
     kbCtrlShift   = $0004;
     kbAltShift    = $0008;
     kbScrollState = $0010;
     kbNumState    = $0020;
     kbCapsState   = $0040;
     kbInsState    = $0080;

{============================================================================}
Function KeyPressed: Boolean; Assembler;
Asm
  MOV   AH,001h

  INT   16h

  JZ    @NotPressed
@Pressed:
  MOV   AL,True
  JMP   @ProcExit

@NotPressed:
  MOV   AL,False

@ProcExit:
End;
{============================================================================}

{============================================================================}
Function ReadKey: Word; Assembler;
Asm
  XOR   AH,AH
  INT   16h
End;
{============================================================================}

{============================================================================}
Function SmartReadKey: Word;
Begin
  If KeyPressed Then SmartReadKey := ReadKey Else SmartReadKey := kbNoKey;
End;
{============================================================================}

Var
  ScrWidth:word;
  ScrHeight:word;
  MaxTextX:word;
  MaxTextY:word;

{============================================================================}
Procedure SetTextMode; Assembler;
Asm
  {
  MOV   AX,00003h
  INT   010h
  }
End;
{============================================================================}

{============================================================================}
Procedure WriteChar(X, Y: Byte; Char: Char; Attr: Byte);
Begin
  MemW[SegB800: (X + (Y Shl 4) + (Y Shl 6)) Shl 1] := Byte(Char) Or (Word(Attr) Shl 8);
End;
{============================================================================}

{============================================================================}
Procedure WriteStr(X, Y: Byte; Str: String; Attr: Byte);
Var
  Ofs: Word;
  B: Byte;
Begin
  Ofs := (X + (Y Shl 4) + (Y Shl 6)) Shl 1;
  For B := 1 To Length(Str) Do
  Begin
    MemW[SegB800: Ofs] := Byte(Str[B]) Or (Word(Attr) Shl 8);
    Inc(Ofs, 2);
  End;
End;
{============================================================================}

{============================================================================}
Procedure ClearScreen; Assembler;
Asm
  PUSH  ES
  MOV   AX,SegB800
  MOV   ES,AX
  XOR   DI,DI
  MOV   CX,2000
  CLD
  MOV   AX,00720h
  REP   STOSW
  POP   ES
  XOR   DX,DX
  XOR   BH,BH
  MOV   AH,002h
  INT   010h
End;
{============================================================================}

{============================================================================}
Procedure WriteStrC(X, Y: Byte; Str: String; Attr1, Attr2: Byte);
Var
  Ofs: Word;
  B: Byte;
  Attr: Byte;
Begin
  Ofs := (X + (Y Shl 4) + (Y Shl 6)) Shl 1;
  Attr := Attr1;
  For B := 1 To Length(Str) Do
    If Str[B] <> '~' Then
    Begin
      MemW[SegB800: Ofs] := Byte(Str[B]) Or (Word(Attr) Shl 8);
      Inc(Ofs, 2);
    End
    Else
      If Attr = Attr1 Then
        Attr := Attr2
      Else
        Attr := Attr1;
End;
{============================================================================}

{============================================================================}
Function Long2Str(B: LongInt): String;
Var
  S: String;
Begin
  Str(B, S);
  Long2Str := S;
End;
{============================================================================}

Type
  PString = ^String;

Type
  PStrings = ^TStrings;
  TStrings = Record
    Next, Prev: PStrings;
    Str: PString;
  End;

Type
  PText = ^TText;
  TText = Object
    Text: PStrings;
    Count: Longint;
    Constructor Init;
    Destructor Done; Virtual;
    Procedure Add(Str: String); Virtual;
    Procedure Clear; Virtual;
  End;

{============================================================================}
Constructor TText.Init;
Begin
  Text := Nil;
  Count := 0;
End;

{============================================================================}
Destructor TText.Done;
Begin
  Clear;
End;

{============================================================================}
Procedure TText.Add(Str: String);
Var
  L: PStrings;
Begin
  If MaxAvail < SizeOf(TStrings) + SizeOf(String) Then Exit;
  If Text = Nil Then
  Begin
    GetMem(Text, SizeOf(TStrings));
    GetMem(Text^.Str, Length(Str) + 1);
    Text^.Str^ := Str;
    Text^.Next := Text;
    Text^.Prev := Text^.Next;
  End
  Else
  Begin
    L := Text;
    While L^.Next <> Text Do
      L := L^.Next;
    GetMem(L^.Next, SizeOf(TStrings));
    L^.Next^.Prev := L;
    L := L^.Next;
    GetMem(L^.Str, Length(Str) + 1);
    L^.Str^ := Str;
    L^.Next := Text;
    Text^.Prev := L;
  End;
  Inc(Count);
End;

{============================================================================}
Procedure TText.Clear;
Var
  L: PStrings;
Begin
  If Text = Nil Then Exit;
  L := Text;
  L^.Prev^.Next := Nil;
  While L <> Nil Do
  Begin
    Text := L^.Next;
    FreeMem(L^.Str, Length(L^.Str^) + 1);
    FreeMem(L, SizeOf(TStrings));
    L := Text;
  End;
  Count := 0;
End;

{----------------------------------------------------------------------------}
Procedure GetTextFromFile(Var F: Text; T: PText);
{----------------------------------------------------------------------------}
Procedure MakeTabs(Var Str: String);
{----------------------------------------------------------------------------}
Function NumTabs(Pos: Byte): Byte;
Var
  B, N: Byte;
Begin
  B := Pos;
  N := 0;
  Repeat
    Inc(B);
    Inc(N);
  Until ((B - 1) Mod 8) = 0;
  NumTabs := N;
End;
{----------------------------------------------------------------------------}

Var
  B, D: Byte;
Begin
  While Pos(#9, Str) <> 0 Do
  Begin
    D := Pos(#9, Str);
    Delete(Str, D, 1);
    For B := 1 To NumTabs(D) Do
      Insert(' ', Str, D);
  End;
End;
{----------------------------------------------------------------------------}

Var
  S: String;
Begin
  While (Not EOF(F)) And (MaxAvail > MinMemLimit) Do
  Begin
    ReadLn(F, S);
    MakeTabs(S);
    T^.Add(S);
  End;
End;
{----------------------------------------------------------------------------}

{============================================================================}
Procedure ViewText(T: PText; Source: String);
Var
  CurPos: Longint;
  CurStrOfs: Byte;
  CurLine: PStrings;

  ViewerX:byte;
  ViewerY:byte;
  ViewerHeight:word;
  ViewerWidth:word;
{----------------------------------------------------------------------------}
Procedure DrawScr;
Var
  L,J: Byte;
  C: PStrings;

{----------------------------------------------------------------------------}
Procedure FillScreen(Char: Char; Attr: Byte); {Assembler;{}
var a,b:word;
begin
a:=ViewerY*80*2;
b:=80*ViewerHeight;
Asm
  PUSH  ES
  MOV   AX,SegB800
  MOV   ES,AX
  MOV   DI,a
  MOV   CX,b
  CLD
  MOV   AL,Char
  MOV   AH,Attr
  REP   STOSW
  POP   ES
End;
end;

var s:string; a:word;

Begin
  ViewerX:= 0;
  ViewerY:= 1;
  ViewerHeight:= ScrHeight - 2;
  ViewerWidth:= ScrWidth;
  C := CurLine;
  a:=ScrWidth*(ScrHeight-1)*2;

  cmprint(0,15,3,gMaxY-1,'['+strr(CurPos)+':'+strr(CurStrOfs)+']'+fill(10,'═'));
  For L := 0 To ViewerHeight - 2 Do
   Begin
    If (L+CurPos)>T^.Count Then
     Begin
      For J:=L+1 to ViewerHeight-1 Do cmprint(0,7,2,ViewerY+J,space(78));
      Exit;
     End;
    s:=Copy(C^.Str^, CurStrOfs, 78);
    WriteStr(ViewerX+1, ViewerY + L, s+space(78-length(s)), $07);
    C := C^.Next;
   End;
End;

{----------------------------------------------------------------------------}
Procedure PageUp;
Var
  C: Byte;
Begin
  If CurPos <= 1 Then Exit;
  If CurPos <= ViewerHeight Then
  Begin
    CurPos := 1;
    CurLine := T^.Text;
  End
  Else
  Begin
    For C := 1 To ViewerHeight - 1 Do
      CurLine := CurLine^.Prev;
    CurPos := CurPos - ViewerHeight + 1;
  End;
End;

{----------------------------------------------------------------------------}
Procedure PageDown;
Var
  C: Byte;
Begin
{  message(strr(CurPos+ViewerHeight-3)+'  '+strr(T^.Count));{}

  If (CurPos + (ViewerHeight - 2)) >= T^.Count Then Exit;
  If (CurPos + ViewerHeight * 2 - 2) >= T^.Count Then
  Begin

    CurPos := T^.Count;
    CurLine := T^.Text^.Prev;

    PageUp;
{}
                    Inc(CurPos);
                    CurLine := CurLine^.Next;
  End
  Else
  Begin
    For C := 1 To ViewerHeight - 1 Do
      CurLine := CurLine^.Next;
    CurPos := CurPos + ViewerHeight - 1;
  End;
End;
{----------------------------------------------------------------------------}
Var
  Quit: Boolean;
  Key: Word;
  l:word;
  a,b:integer;
  C: PStrings;
  s:string;
Begin
  cmprint(0,15,1,1,'╔'+fill(69,'═'));
  for l:=2 to gMaxY-2 do begin cmPrint(0,15,1,l,'║'); cmPrint(0,15,80,l,'║'); end;
  cmprint(0,15,1,gMaxY-1,'╚'+fill(78,'═')+'╝');

  cmprint(0,15,3,1,'['+ChangeChar(ExtNum(strr(MaxAvail)),' ',',')+']');
  cmcentre(0,15,1,' '+source+' ');
  for l:=2 to gMaxY-2 do begin cmPrint(0,15,2,l,space(78)); end;
  CancelSB;
  If T^.Count = 0 Then
  Begin
{    if lang=rus then errormessage('Пустой файл') else errormessage('Null file');{}
    errormessage('Пустой файл');
    Exit;
  End;
  CurPos := 1;
  CurStrOfs := 1;
  CurLine := T^.Text;
  Asm
    MOV DX,0FFFFh
    XOR BH,BH
    MOV AH,002h
    INT 010h
  End;
  DrawScr;
  Quit := False;
  Repeat
    Key := KeyCode;
{    message((dec2hex(strr(key)))+' '+(dec2hex(strr(_CtrlPgUp))));{}

    Case Key Of
     _ESC:       Quit := True;
     _Left:      If CurStrOfs > 1 Then Dec(CurStrOfs);
     _Right:     If CurStrOfs < ($FF - ScrWidth) Then Inc(CurStrOfs);
     _Down:      If (CurPos + ViewerHeight-1) <= T^.Count Then
                   Begin
                    Inc(CurPos);
                    CurLine := CurLine^.Next;
                   End;
     _Up:         If CurPos > 1 Then
                    Begin
                     Dec(CurPos);
                     CurLine := CurLine^.Prev;
                    End;
     _Home:
                   Begin
                    CurStrOfs:=1;
                    {CurLine := T^.Text;{}
                   End;
     _End:
                   Begin
                    a:=0;
                    C:=CurLine;
                    for l:=CurPos to CurPos+gMaxY-4 do
                     Begin
                      if length(C^.Str^)>a then a:=length(C^.Str^);
                      C := C^.Next;
                     End;
                    inc(a,3);
                    if a<81 then a:=81;
                    CurStrOfs:=a-ScrWidth;
                    {CurLine := T^.Text;{}
                   End;
     _PgDn:       PageDown;
     _PgUp:       PageUp;
     _CtrlHome:
                   Begin
                    CurStrOfs:=1;
                    CurPos := 1;
                    CurLine := T^.Text;
                   End;
     _CtrlEnd:
                   Begin
                    CurStrOfs:=1;
                    CurPos := T^.Count;
                    CurLine := T^.Text^.Prev;
                    PageUp;{}
                    Inc(CurPos);
                    CurLine := CurLine^.Next;
                   End;
    End;
    DrawScr;
  Until Quit;
End;

{============================================================================}
{============================================================================}
{============================================================================}
Function IntView(fname:string):byte;
Var
  StartMem: LongInt;
  ViewerFile: TText;
  ViewerFileName: String[79];
  F: Text;
Begin
  {
  If ParamCount <> 1 Then
  Begin
    WriteLn('Ошибка в параметрах!');
    Halt(1);
  End;
  {}
  ScrWidth:=gMaxX;        ScrHeight:=gMaxY;
  MaxTextX:=ScrWidth-1;   MaxTextY:=ScrHeight-1;

  StartMem := MaxAvail;
  SetTextMode;
  ViewerFile.Init;
  ViewerFileName := fname;
  Assign(F, ViewerFileName);
  FileMode := 0;
  Reset(F);
  If IOResult = 0 Then
  Begin
    GetTextFromFile(F, @ViewerFile);
    Close(F);
  End;
  ViewText(@ViewerFile, ViewerFileName);
  ViewerFile.Done;
{  ClearScreen;{}
{  If StartMem <> MaxAvail Then
    WriteLn('Ошибки при работе с памятью. (', StartMem, ', ', MaxAvail, ').');}
end;




End.