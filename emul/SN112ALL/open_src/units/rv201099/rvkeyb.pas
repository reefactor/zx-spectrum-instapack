function KeyCode : Word;
Var
  regs : Registers;
begin
  regs.al := $00;
  regs.ah := $10;
  intr($16, regs);
  {KeyCode := (regs.ah shl 4) + regs.al;}
  KeyCode:=regs.ax;
end;

function KeyCodePressed(var kc:word): boolean;
Var
  regs : Registers; zflag:byte; l,h:byte;
Label
  nokey,ext;
begin
KeyCodePressed:=false;
  asm
   mov ax,0100h
   int 16h
   jz nokey
   mov zflag,1
  end;
nokey:
  if zflag<>0 then
   begin
    KeyCodePressed:=true;
    regs.al := $00;
    regs.ah:=$10;
    intr($16,regs);
    kc:=regs.ax;
   end;
end;

function Ctrl:boolean;
begin
 if bit(3,mem[0:$417]) then Ctrl:=true else Ctrl:=false;;
end;

function Alt:boolean;
begin
 if bit(4,mem[0:$417]) then Alt:=true else Alt:=false;;
end;


function LShift:boolean;
begin
 if bit(2,mem[0:$417]) then LShift:=true else LShift:=false;;
end;


function RShift:boolean;
begin
 if bit(1,mem[0:$417]) then RShift:=true else RShift:=false;;
end;

