function dec2hex(decn:string):string;
var hex:string; f,tdec,valcode,h3,h4:word;
decm                                  :array[1..2] of real;

label fin;
begin
 hex:=''; val(decn,tdec,valcode);
 if (tdec<0)or(tdec>65535) then begin hex:='error'; goto fin; end;
 decm[1]:=int(tdec/256); decm[2]:=tdec-256*decm[1];
 for i:=1 to 2 do
  begin
   h3:=48; h4:=48;
   for f:=1 to round(decm[i]) do
    begin
     h4:=h4+1;
     if (h4>57)and(h4<65) then h4:=h4+7;
     if h4>70 then begin h3:=h3+1; h4:=48; end;
     if (h3>57)and(h3<65) then h3:=h3+7;
    end;
   hex:=hex+chr(h3)+chr(h4);
  end;
fin:
if vall(decn)>255 then dec2hex:=hex else dec2hex:=copy(hex,3,2);

end;

function hex2dec(hex:string):string;
var
hexm                                  :array[1..2] of string;
h3,h4,f:word;
hidec                                 :array[1..2] of word;
decresult:string;
label cont,fin;
begin
 if (length(hex)>4)or(length(hex)<1) then begin hex2dec:='error'; goto fin; end;
 if length(hex)<2 then hex:='0'+hex;
 if length(hex)<3 then hex:='0'+hex;
 if length(hex)<4 then hex:='0'+hex;
 hexm[1]:=copy(hex,1,2); hexm[2]:=copy(hex,3,2);
 for i:=1 to 2 do
  begin
   h3:=48; h4:=48;
   for f:=0 to 255 do
    begin
     if (h4>57)and(h4<65) then h4:=h4+7;
     if h4>70 then begin h3:=h3+1; h4:=48; end;
     if (h3>57)and(h3<65) then h3:=h3+7;
     if hexm[i]=chr(h3)+chr(h4) then goto cont;
     h4:=h4+1;
    end;
cont:
   hidec[i]:=f;
  end;
 str((hidec[1]*256+hidec[2]),decresult);
 hex2dec:=decresult;
fin:
end;

function hex2bin(hex:string):string;
var
hx                                    :array[0..15] of string;
bn                                    :array[0..15] of string;
sc,bin:string;
f:word;
label fin;
begin
 hx[0]:='0';   bn[0]:='0000'; hx[1]:='1';   bn[1]:='0001';
 hx[2]:='2';   bn[2]:='0010'; hx[3]:='3';   bn[3]:='0011';
 hx[4]:='4';   bn[4]:='0100'; hx[5]:='5';   bn[5]:='0101';
 hx[6]:='6';   bn[6]:='0110'; hx[7]:='7';   bn[7]:='0111';
 hx[8]:='8';   bn[8]:='1000'; hx[9]:='9';   bn[9]:='1001';
 hx[10]:='A'; bn[10]:='1010'; hx[11]:='B'; bn[11]:='1011';
 hx[12]:='C'; bn[12]:='1100'; hx[13]:='D'; bn[13]:='1101';
 hx[14]:='E';bn[14]:='1110'; hx[15]:='F'; bn[15]:='1111';
 bin:='';
 if length(hex)>2 then
 begin
  if length(hex)=3 then
   begin
    hex:='0'+hex;
   end;
 end;
 for f:=1 to length(hex) do
  begin
   sc:=copy(hex,f,1);
   for i:=0 to 15 do if sc=hx[i] then bin:=bin+bn[i];
  end;
 fin:
 hex2bin:=bin;
{if length(hex)>3 then hex2bin:=bin else hex2bin:=copy(bin,9,8);}
end;

function bin2hex(bin:string):string;
var
hx                                    :array[0..15] of string;
bn                                    :array[0..15] of string;
sc,bn1,bn2,bn3,bn4:string;
f:word;
hexresult                             :array[1..4] of string;

label fin;
begin
 hx[0]:='0';   bn[0]:='0000'; hx[1]:='1';   bn[1]:='0001';
 hx[2]:='2';   bn[2]:='0010'; hx[3]:='3';   bn[3]:='0011';
 hx[4]:='4';   bn[4]:='0100'; hx[5]:='5';   bn[5]:='0101';
 hx[6]:='6';   bn[6]:='0110'; hx[7]:='7';   bn[7]:='0111';
 hx[8]:='8';   bn[8]:='1000'; hx[9]:='9';   bn[9]:='1001';
 hx[10]:='A'; bn[10]:='1010'; hx[11]:='B'; bn[11]:='1011';
 hx[12]:='C'; bn[12]:='1100'; hx[13]:='D'; bn[13]:='1101';
 hx[14]:='E'; bn[14]:='1110'; hx[15]:='F'; bn[15]:='1111';
 bn1:=' '; bn2:=' '; bn3:=' '; bn4:=' ';
 if length(bin)>16 then begin bin2hex:='error'; goto fin; end;
 if (length(bin)<=16)and(length(bin)>12) then
  begin
   for f:=1 to (16-length(bin)) do bin:='0'+bin;
   bn1:=copy(bin,1,4); bn2:=copy(bin,5,4);
   bn3:=copy(bin,9,4); bn4:=copy(bin,13,4);
   for f:=0 to 15 do
    begin
     if bn1=bn[f] then hexresult[1]:=hx[f];
     if bn2=bn[f] then hexresult[2]:=hx[f];
     if bn3=bn[f] then hexresult[3]:=hx[f];
     if bn4=bn[f] then hexresult[4]:=hx[f];
    end;
  end;
 if (length(bin)<=12)and(length(bin)>8) then
  begin
   for f:=1 to (12-length(bin)) do bin:='0'+bin;
   bn1:=copy(bin,1,4); bn2:=copy(bin,5,4); bn3:=copy(bin,9,4);
   for f:=0 to 15 do
    begin
                       hexresult[1]:=hx[0];
     if bn1=bn[f] then hexresult[2]:=hx[f];
     if bn2=bn[f] then hexresult[3]:=hx[f];
     if bn3=bn[f] then hexresult[4]:=hx[f];
    end;
  end;
 if (length(bin)<=8)and(length(bin)>4) then
  begin
   for f:=1 to (8-length(bin)) do bin:='0'+bin;
   bn1:=copy(bin,1,4); bn2:=copy(bin,5,4);
   for f:=0 to 15 do
    begin
                       hexresult[1]:=hx[0];
                       hexresult[2]:=hx[0];
     if bn1=bn[f] then hexresult[3]:=hx[f];
     if bn2=bn[f] then hexresult[4]:=hx[f];
    end;
  end;
 if (length(bin)<=4)and(length(bin)>1) then
  begin
   for f:=1 to (4-length(bin)) do bin:='0'+bin;
   bn1:=copy(bin,1,4);
   for f:=0 to 15 do
    begin
                       hexresult[1]:=hx[0];
                       hexresult[2]:=hx[0];
                       hexresult[3]:=hx[0];
     if bn1=bn[f] then hexresult[4]:=hx[f];
    end;
  end;
 bin2hex:=hexresult[1]+hexresult[2]+hexresult[3]+hexresult[4];
fin:
end;


FUNCTION  Hexlong (argument : longint): string;
   var i      :longint;
       res    :string;
   Const
       HexTable  :array[0..15] of char = '0123456789ABCDEF';
  begin
    res[0] := #8;
    for i := 0 to 7 do
      res[8-i] := HexTable[ argument shr (i shl 2) and $f];
    hexlong := res;
  end;

