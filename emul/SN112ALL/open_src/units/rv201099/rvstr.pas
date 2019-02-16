{$R-}
{----------------------------------------------------------------------------}
Function LZ(w:Word):String;
var
   s:String;
Begin
Str(w:0,s); if Length(s)=1 then s:='0'+s; LZ:=s;
End;
{----------------------------------------------------------------------------}
Function LZZ(w:Word):String;
var
   s:String;
Begin
Str(w:0,s);
if Length(s)=1 then s:='0'+s;
if Length(s)=2 then s:='0'+s;
LZZ:=s;
End;
{============================================================================}
{== SPACE ===================================================================}
{============================================================================}
function Space(len:integer):string;
var
    f:byte;
    s:string;
begin
s:='';
if len>0 then for f:=1 to len do s:=s+' ';
space:=s;
end;
{============================================================================}
{== NOSPACE =================================================================}
{============================================================================}
function NoSpace(s:string):string;
var
   f:byte;
   a:string;
begin
a:='';
for f:=1 to Length(s) do if s[f]<>' ' then a:=a+s[f];
NoSpace:=a;
end;
{============================================================================}
{== NOSPACE AT LEFT AND RIGHT ===============================================}
{============================================================================}
function NoSpaceLR(s:string):string;
var
   f,l,r:byte;
   a:string;
begin
a:='';
l:=1; while s[l]=' ' do inc(l);
r:=length(s); while s[r]=' ' do dec(r);
NoSpaceLR:=mid(s,l,r);
end;
{============================================================================}
{== NOSPACE AT LEFT =========================================================}
{============================================================================}
function NoSpaceL(s:string):string;
var
   f,l,r:byte;
   a:string;
begin
while s[1]=' ' do delete(s,1,1);
NoSpaceL:=s;
end;
{============================================================================}
{== NOSPACE AT RIGHT ========================================================}
{============================================================================}
function NoSpaceR(s:string):string;
var
   f,l,r:byte;
   a:string;
begin
while s[length(s)]=' ' do delete(s,length(s),1);
NoSpaceR:=s;
end;
{============================================================================}
{== MID =====================================================================}
{============================================================================}
function Mid(str:string; ind1,ind2:integer):string;
begin
Mid:=Copy(str,ind1,ind2-ind1+1);
end;
{============================================================================}
{== MID CHAR ================================================================}
{============================================================================}
function MidCh(str:string; index:integer):char;
begin
MidCh:=str[index];
end;
{============================================================================}
{== NUMBER TO STRING ========================================================}
{============================================================================}
function Strr(tempein:longint):string;
var
   rrr:string;
begin
str(tempein,rrr);
Strr:=rrr;
end;
{============================================================================}
{== STRING TO NUMBER ========================================================}
{============================================================================}
function Vall(tempein:string):longint;
var
   rrr:longint;
   code:integer;
begin
Val(tempein,rrr,code);
Vall:=rrr;
end;
{============================================================================}
{== DOWN CASE OF STRING =====================================================}
{============================================================================}
function StrLo(s:string):string;
var
   f:byte;
   a:string;
   x:byte;
begin
a:='';
for f:=1 to Length(s) do
 begin
  x:=0;
  if (((s[f]>='A')and(s[f]<='Z'))or((s[f]>='Ä')and(s[f]<='è'))) then x:=32;
  if (s[f]>='ê')and(s[f]<='ü') then x:=80;
  a:=a+chr(ord(s[f])+x);
 end;
StrLo:=a;
end;
{============================================================================}
{== UP CASE OF STRING =======================================================}
{============================================================================}
function StrHi(s:string):string;
var
   f:byte;
   a,t:string;
   x:byte;
begin
a:='';
for f:=1 to Length(s) do
 begin
  x:=0;
  if (((s[f]>='a')and(s[f]<='z'))or((s[f]>='†')and(s[f]<='Ø'))) then x:=32;
  if (s[f]>='‡')and(s[f]<='Ô') then x:=80;
  a:=a+chr(ord(s[f])-x);
 end;
StrHi:=a;
end;
{============================================================================}
{== FILL STRING BY CHAR =====================================================}
{============================================================================}
function Fill(len:byte; symb:char):string;
var
   f:byte;
   p:string;
begin
 p:='';
 for f:=1 to len do p:=p+symb;
 fill:=p;
end;
{============================================================================}
{== CODING STRING ===========================================================}
{============================================================================}
function CodeStr(ent:string; code:byte):string;
var
    i,t:integer;
    s,strtemp:string;
    chrtemp:char;
begin
s:='';
for i:=1 to Length(ent) do
 begin
  strtemp:=Mid(ent,i,1); chrtemp:=strtemp[1];
  t:=Ord(chrtemp);
{
 t:=t xor code ;
}
  t:=t+(i+$1A);
  s:=s+Chr(t)
 end;
CodeStr:=s;
end;
{============================================================================}
{== DECODING STRING =========================================================}
{============================================================================}
function DeCodeStr(ent:string; code:byte):string;
var
    i,t:integer;
    s,strtemp:string;
    chrtemp:char;
begin
s:='';
for i:=1 to Length(ent) do
 begin
  strtemp:=Mid(ent,i,1); chrtemp:=strtemp[1];
  t:=Ord(chrtemp);
  t:=t-(i+$1A);
{
  t:=t xor code;
}
  s:=s+chr(t)
 end;
DeCodeStr:=s;
end;
{============================================================================}
{== REVERSE STRING ==========================================================}
{============================================================================}
function ReverseStr(s:string):string;
var
   i:integer;
   a:string;
begin
a:='';
for i:=length(s) downto 1 do a:=a+s[i];
ReverseStr:=a;
end;
{============================================================================}
{== NO CR LF ================================================================}
{============================================================================}
function no1013(st:string):string;
var
   i:integer;
   s:string;
begin
s:='';
for i:=1 to length(st) do if (st[i]<>#10)and(st[i]<>#13) then s:=s+st[i];
no1013:=s;
end;
{============================================================================}
{== ASCII ONLY FROM STRING ==================================================}
{============================================================================}
function AsciiOnly(st:string):string;
var
   i:integer;
   s:string;
begin
s:='';
for i:=1 to length(st) do if (st[i]>=#32)and(st[i]<=#127) then s:=s+st[i];
AsciiOnly:=s;
end;
{============================================================================}
{== NUM ONLY FROM STRING ====================================================}
{============================================================================}
function NumOnly(st:string):string;
var
   i:integer;
   s:string;
begin
s:='';
for i:=1 to length(st) do if (st[i]>=#48)and(st[i]<=#57) then s:=s+st[i];
NumOnly:=s;
end;
{============================================================================}
{== EXTENDED NUMBER   |   EXMPL: 1234567 - 1 234 567 ========================}
{============================================================================}
function ExtNum(n:string):string;
var a,b:byte; s:string;
begin
s:='';
b:=length(n); a:=1;
while b>=1 do
 begin
  s:=s+n[b]; dec(b); inc(a);
  if a>3 then begin a:=1; s:=s+' '; end;
 end;
if copy(ReverseStr(s),1,1)<>' ' then extnum:=ReverseStr(s) else extnum:=copy(ReverseStr(s),2,length(s));
end;
{============================================================================}
{== ASCIIZ TO PASCAL STRING =================================================}
{============================================================================}
function ASCIZ2Str (ASCIZ: array of Char): String;
begin
ASCIZ2Str:=StrPas(@ASCIZ);
end;
{============================================================================}
{== WITHOUT =================================================================}
{============================================================================}
function WithOut(s,chars:string):string;
var a,b:integer; f:integer; st:string;
begin
st:=s; a:=255;
for f:=1 to length(chars) do
 for b:=1 to length(st) do
  begin
   a:=pos(chars[f],st);
   if a<>0 then delete(st,a,1);
  end;
WithOut:=st;
end;
{============================================================================}
{== CHANGE STRING ===========================================================}
{============================================================================}
function ChangeChar  (s:string; char1,char2:char)    :string;
var i:integer;
begin
for i:=1 to length(s) do if s[i]=char1 then s[i]:=char2;
ChangeChar:=s;
end;
{============================================================================}
{== C LENGHT ===========================================================}
{============================================================================}
function CLen  (s:string)    :integer;
begin
CLen:=length(without(s,'~'));
end;
{============================================================================}
{== CHANGE STRING ===========================================================}
{============================================================================}
function CCLen (s:string)    :integer;
begin
CCLen:=length(without(s,'~`'));
end;
{============================================================================}
{== EXPAND SPACES RIGHT =====================================================}
{============================================================================}
function sRexpand(s:string; tob:byte):string;
begin
if tob<=length(s) then begin sRexpand:=s; exit; end;
sRexpand:=s+space(tob-length(s));
end;
{============================================================================}
{== EXPAND SPACES LEFT ======================================================}
{============================================================================}
function sLexpand(s:string; tob:byte):string;
begin
if tob<=length(s) then begin sLexpand:=s; exit; end;
sLexpand:=space(tob-length(s))+s;
end;

{============================================================================}
{== WILDCARDS !!! ===========================================================}
{============================================================================}
Function Wild(input_word,wilds:String;upcase_wish:boolean):Boolean;

 {looking for next *, returns position and string until position}
 function search_next(var wilds:string):word;
 var position,position2:word;
 begin
  position:=pos('*',wilds); {looks for *}

  if position<>0 then wilds:= copy(wilds,1,position-1);
     {returns the string}

  search_next:= position;
 end;

 {compares a string with '?' and another,
  returns the position of helpwilds in input_word}
 function find_part(helpwilds,input_word:string):word;
 var q,q2,q3,between:word;
     diff:integer;
 begin
  q:= pos('?',helpwilds);

  if q= 0 then
   begin
    {if no '?' in helpwilds}

    find_part:= pos(helpwilds,input_word);
    exit;
   end;

  {'?' in helpwilds}
  diff:= length(input_word)-length(helpwilds);
  if diff<0 then begin find_part:= 0;exit;end;
  between:= 0;

  {now move helpwilds over input_word}
  for q:= 0 to diff do
   begin
    for q2:= 1 to length(helpwilds) do
     begin
      if (input_word[q+q2]= helpwilds[q2]) or (helpwilds[q2]= '?') then
       begin if q2= length(helpwilds) then begin find_part:= q+1;exit;end;end
        else break;
     end;
   end;
  find_part:= 0;
 end;
{************************** MAIN ******************************************}
{                this is the mainpart of wild                              }
var cwild,cinput_word:word;{counter for positions}
    q,lengthhelpwilds:word;
    maxinput_word,maxwilds:word;{length of input_word and wilds}
    helpwilds:string;
begin
 wild:= false;

 {uncomment this for often use with 'wildcardless' wilds}
 {if wilds= input_word then begin wild:= true;exit;end;}

 {delete '**', because '**'= '*'}
 repeat
  q:= pos('**',wilds);
  if q<>0 then
   wilds:= copy(wilds,1,q-1)+'*'+copy(wilds,q+2,255);
 until q= 0;
 {
 repeat
  q:= pos('**',input_word);
  if q<>0 then
   input_word:= copy(input_word,1,q-1)+'*'+copy(input_word,q+2,255);
 until q= 0;
 {}
 for q:=1 to length(input_word) do if input_word[q]='*' then input_word[q]:='?';


 {for fast end, if wilds only '*'}
 if wilds= '*' then begin wild:= true;exit;end;

 maxinput_word:= length(input_word);
 maxwilds     := length(wilds);

 {upcase all letters}
 if upcase_wish then
  begin
   for q:= 1 to maxinput_word do input_word[q]:= upcase(input_word[q]);
   for q:= 1 to maxwilds do wilds[q]:= upcase(wilds[q]);
  end;

 {set initialization}
 cinput_word:= 1;cwild:= 1;
 wild:= true;

 repeat
  {equal letters}
  if input_word[cinput_word]= wilds[cwild] then
   begin
    {goto next letter}
    inc(cwild);
    inc(cinput_word);
    continue;
   end;

  {equal to '?'}
  if wilds[cwild]= '?' then
   begin
    {goto next letter}
    inc(cwild);
    inc(cinput_word);
    continue;
   end;

  {handling of '*'}
  if wilds[cwild]= '*' then
   begin
    helpwilds:= copy(wilds,cwild+1,maxwilds);{takes the rest of wilds}

    q:= search_next(helpwilds);{search the next '*'}

    lengthhelpwilds:= length(helpwilds);

    if q= 0 then
     begin
      {no '*' in the rest}
      {compare the ends}
      if helpwilds= '' then exit;{'*' is the last letter}

      {check the rest for equal length and no '?'}
      for q:= 0 to lengthhelpwilds-1 do
       if (helpwilds[lengthhelpwilds-q]<>input_word[maxinput_word-q]) and
          (helpwilds[lengthhelpwilds-q]<>'?') then
         begin wild:= false;exit;end;
      exit;
     end;

    {handle all to the next '*'}
    inc(cwild,1+lengthhelpwilds);
    q:= find_part(helpwilds,copy(input_word,cinput_word,255));
    if q= 0 then begin wild:= false;exit;end;
    cinput_word:= q+lengthhelpwilds;
    continue;
   end;

  wild:= false;exit;

 until (cinput_word>maxinput_word) or (cwild>maxwilds);
 {no completed evaluation}
 if cinput_word<= maxinput_word then wild:= false;
 if cwild<= maxwilds then wild:= false;
end;

{============================================================================}
{== UP CASE OF CHAR =========================================================}
{============================================================================}
function DnCase(c:char):char;
var a:string;
begin
a:=strlo(c);
DnCase:=a[1];
end;







