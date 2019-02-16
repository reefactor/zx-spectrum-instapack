function InitMouseOk;
var r : registers;
begin
  r.ax:=0;
  intr($33,r);
  InitMouseOk:=boolean(r.al)
end;

function GetButton;
var r : registers;
begin
  r.ax:=5;
  intr($33,r);
  GetButton:=r.al
end;

function GetX;
var x : byte;
var r : registers;
begin
  r.ax:=3;
  intr($33,r);
  x:=r.cx shr 3;
  GetX:=x
end;

function GetY;
var y : byte;
var r : registers;
begin
  r.ax:=3;
  intr($33,r);
  y:=r.dx shr 3;
  GetY:=y
end;

procedure GetMousePos;
var r : registers;
begin
  r.ax:=3;
  intr($33,r);
  x:=r.cx shr 3;
  y:=r.dx shr 3
end;

procedure MouseShow;
var r : registers;
begin
  r.ax:=1;
  intr($33,r);
  rMoused:=true;
end;

procedure MouseHide;
var r : registers;
begin
  r.ax:=2;
  intr($33,r);
  rMoused:=false;
end;
