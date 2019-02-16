{$O+,F+}
Unit TAP_Ovr;
Interface
Uses
     Crt,RV,sn_Obj, Vars, Palette, Main, Utils, Main_Ovr, TRD;

Function  tapLoad(var p:TPanel; ind:word):boolean;
Function  tapSave(var p:TPanel):boolean;

Function  tapDel(var p:TPanel):boolean;
function  tapRename:boolean;

function  tapMakeImage:boolean;

Implementation


{============================================================================}
Function tapLoad(var p:TPanel; ind:word):boolean;
Var f:file; i,b:byte; w:word;
Begin
if (ind>2)and(p.trdDir^[ind-1].tapflag=0) then
 Begin
  HobetaInfo.name:=p.trdDir^[ind-1].name;
  if p.trdDir^[ind-1].taptyp=0 then
   Begin
    HobetaInfo.typ:='B';
    {
    HobetaInfo.start:=p.trdDir^[ind-1].start;
    {}
    HobetaInfo.start:=p.trdDir^[ind-1].param2;
    HobetaInfo.line:=p.trdDir^[ind-1].start;
    {}
   End
  else
   Begin
    HobetaInfo.typ:='C';
    HobetaInfo.start:=p.trdDir^[ind-1].start;
    HobetaInfo.param2:=p.trdDir^[ind-1].param2;
   End;
 End
else
 Begin
  HobetaInfo.name:='less'+strr(less); HobetaInfo.name:=HobetaInfo.name+space(8);
  inc(less);
  HobetaInfo.typ:='C';
  HobetaInfo.start:=HobetaStartAddr;
  HobetaInfo.param2:=32768;
 End;
HobetaInfo.tapFlag:=p.trdDir^[ind].tapFlag;
HobetaInfo.length:=p.trdDir^[ind].length;

HobetaInfo.totalsec:=HobetaInfo.length div 256;
if HobetaInfo.length-256*HobetaInfo.totalsec>0 then inc(HobetaInfo.totalsec);

tapLoad:=false;
{$I-}
GetMem(HobetaInfo.body,256*HobetaInfo.totalsec);
for w:=1 to 256*HobetaInfo.totalsec do HobetaInfo.body^[w]:=0;
assign(f,p.tapfile); filemode:=0; reset(f,1);
seek(f,p.trdDir^[ind].offset);
blockread(f,HobetaInfo.body^,HobetaInfo.length);
close(f);
{$I+}
i:=IOResult;

if HobetaInfo.typ='B' then
 begin
  HobetaInfo.body^[HobetaInfo.length+1]:=$80;
  HobetaInfo.body^[HobetaInfo.length+2]:=$AA;
  HobetaInfo.body^[HobetaInfo.length+3]:=lo(HobetaInfo.line);
  HobetaInfo.body^[HobetaInfo.length+4]:=hi(HobetaInfo.line);
 end;

if i=0 then tapLoad:=true else FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
End;




{============================================================================}
Function tapSave(var p:TPanel):boolean;
var buf:array[1..21] of byte; i,cs:byte; f:file;
Begin
 buf[1]:=19; buf[2]:=0;
 buf[3]:=0;
 if HobetaInfo.typ='B' then buf[4]:=0 else buf[4]:=3;
 for i:=5 to 14 do buf[i]:=32;
 for i:=1 to length(HobetaInfo.name) do buf[5+i-1]:=ord(HobetaInfo.name[i]);
 buf[15]:=lo(HobetaInfo.length); buf[16]:=hi(HobetaInfo.length);
 if HobetaInfo.typ<>'B' then
                         begin
                          buf[17]:=lo(HobetaInfo.start);
                          buf[18]:=hi(HobetaInfo.start);
                         end
                        else
                         begin
                          buf[17]:=HobetaInfo.body^[HobetaInfo.length+3];
                          buf[18]:=HobetaInfo.body^[HobetaInfo.length+4];
                         end;
 buf[19]:=lo(HobetaInfo.param2); buf[20]:=hi(HobetaInfo.param2);
 cs:=0; for i:=4 to 20 do cs:=cs xor buf[i]; buf[21]:=cs;

 {$I-}
 assign(f,p.tapfile); filemode:=2; reset(f,1); seek(f,filesize(f));

 if (lp.PanelType=tapPanel)and(rp.PanelType=tapPanel) then
  Begin
   i:=lo(HobetaInfo.length+2); blockwrite(f,i,1);
   i:=hi(HobetaInfo.length+2); blockwrite(f,i,1);
   i:=HobetaInfo.tapflag; blockwrite(f,i,1);
   cs:=HobetaInfo.tapflag; for i:=1 to HobetaInfo.length do cs:=cs xor HobetaInfo.body^[i];
   blockwrite(f,HobetaInfo.body^,HobetaInfo.length); blockwrite(f,cs,1);
  End
 else
  Begin
   blockwrite(f,buf,21);
   i:=lo(HobetaInfo.length+2); blockwrite(f,i,1);
   i:=hi(HobetaInfo.length+2); blockwrite(f,i,1);
   i:=255; blockwrite(f,i,1);
   cs:=255; for i:=1 to HobetaInfo.length do cs:=cs xor HobetaInfo.body^[i];
   blockwrite(f,HobetaInfo.body^,HobetaInfo.length); blockwrite(f,cs,1);
  End;

 FreeMem(HobetaInfo.body,256*HobetaInfo.totalsec);
 close(f);
 {$I+}
 if ioresult=0 then tapSave:=true;
 inc(p.zxdisk.files);
End;



{============================================================================}
Function tapDel(var p:TPanel):boolean;
Var
    bufsize,nr,ind:word; was,head,tail,dif,TruncatePos:longint;
    f:file;
Begin

 ind:=p.Index;
 bufsize:=65280;

 {$I-}
 GetMem(HobetaInfo.body,bufsize);
 assign(f,p.tapfile); filemode:=2; reset(f,1);

for ind:=p.taptfiles downto 2{} do if p.trdDir^[ind].mark then
BEGIN{}
 was:=filesize(f);
 if PanelTypeOf(oFocus)=tapPanel then
  BEGIN
   head:=p.trdDir^[ind].offset-3; tail:=p.trdDir^[ind+1].offset-3;
   if ind=p.taptfiles then TruncatePos:=head
   else
    Begin
     dif:=tail-head;
     repeat
      seek(f,tail); BlockRead(f,HobetaInfo.body^,bufsize,nr);
      seek(f,head); BlockWrite(f,HobetaInfo.body^,nr);
      inc(head,nr); inc(tail,nr);
     until nr=0;
     TruncatePos:=was-dif;
    End;
  END
 else
  BEGIN
   if p.trdDir^[ind].tapflag<>0 then
    Begin

     if (ind>2)and(p.trdDir^[ind-1].tapflag=0) then
      Begin
       head:=p.trdDir^[ind-1].offset-3; tail:=p.trdDir^[ind+1].offset-3;
      End
     else
      Begin
       head:=p.trdDir^[ind].offset-3;   tail:=p.trdDir^[ind+1].offset-3;
      End;

     if ind=p.taptfiles then TruncatePos:=head else
      Begin
       dif:=tail-head;
       repeat
        seek(f,tail); BlockRead(f,HobetaInfo.body^,bufsize,nr);
        seek(f,head); BlockWrite(f,HobetaInfo.body^,nr);
        inc(head,nr); inc(tail,nr);
       until nr=0;
       TruncatePos:=was-dif;
      End;

    End;
  END;
 seek(f,TruncatePos); truncate(f);
END;    {}
 FreeMem(HobetaInfo.body,bufsize);
 close(f);
 {$I+}
 if ioresult=0 then tapDel:=true;
 for nr:=1 to 257 do p.trdDir^[nr].name[1]:=#0;
End;




{============================================================================}
function tapRename:boolean;
var p:TPanel; n,dx,cs,i,xc,yc:byte; s:string; f:file; buf:array[1..21]of byte;

{== SCANF ===================================================================}
function tapSNscanf(scanf_posx, scanf_posy:byte;scanf_str:string):string;
var
     scanf_kod:char;
     scanf_x:byte;
     scanf_str_old:string;
label loop;
begin
scanf_esc:=false;
scanf_str_old:=scanf_str;
scanf_x:=1;
{scanf_str:=scanf_str+space(DX-length(scanf_str));{}
loop:
mprint(scanf_posx,scanf_posy,scanf_str);
gotoxy(scanf_posx+scanf_x-1,scanf_posy);
scanf_kod:=readkey;
if scanf_kod=#27 then begin tapsnscanf:=scanf_str_old; scanf_esc:=true; exit; end;
if scanf_kod=#13 then begin tapsnscanf:=scanf_str; exit; end;

if (scanf_kod in[' '..')','-','0'..'9','@'..'[',']'..#255])and(scanf_x<=length(scanf_str)) then
 begin
  scanf_str[scanf_x]:=scanf_kod;
  inc(scanf_x);
 end;
{if scanf_kod='.' then scanf_x:=DX+2;{}

if scanf_kod=kb_CtrlB then if ASCIITable(scanf_posx,scanf_posy+1,lang,ASCln,scanf_kod,n) then
 begin
  scanf_str[scanf_x]:=scanf_kod;
  inc(scanf_x);
  if scanf_x=DX+1 then inc(scanf_x);
 end;
ASCln:=n;

if scanf_kod=#0 then
 begin
  scanf_kod:=readkey;
  if scanf_kod=#77 then
   begin
    inc(scanf_x);
    if scanf_x=DX+3 then
     begin
      menu_name[1]:='~`P~`rogram';
      menu_name[2]:='~`N~`umber array';
      menu_name[3]:='~`C~`haracter array';
      menu_name[4]:='~`B~`ytes';
      menu_total:=4; menu_f:=p.trdDir^[p.Index].taptyp+1; menu_title:=''; menu_visible:=255;
      curoff; cs:=ChooseItem; curon; setcursor(400);
      if cs<>0 then begin p.trdDir^[p.Index].taptyp:=cs-1; p.PDF; end;
      dec(scanf_x);
      colour(pal.bkCurNT,pal.txtCurNT);
     end;
   end;
  if scanf_kod=#75 then begin dec(scanf_x); end;
  if scanf_kod=#72 then scanf_kod:=#27;
  if scanf_kod=#80 then scanf_kod:=#27;
 end;

if scanf_kod=#27 then begin tapsnscanf:=scanf_str_old; scanf_esc:=true; exit; end;

if scanf_x<1 then scanf_x:=1;
if scanf_x>DX+3 then begin scanf_x:=DX+3; end;
goto loop;
end;


Begin
tapRename:=false;
Case focus of left:p:=lp; right:p:=rp; End;
if (p.trdDir^[p.Index].tapflag<>0)or(p.Index<=1) then exit;
s:=p.trdDir^[p.Index].name; GetCurXYOf(focus,xc,yc);

 Case ColumnsOf(focus) of
  1,3: DX:=8;
  2:   Begin DX:=15; if (xc=2)or(yc=42) then dec(DX);{} End;
 End;

CancelSB; colour(pal.bkCurNT,pal.txtCurNT);
curon; SetCursor(400); s:=tapsnscanf(xc,yc,s); curoff;
if not scanf_esc then
 BEGIN
  {$I-}
  assign(f,p.tapfile); filemode:=2; reset(f,1);
  seek(f,p.trdDir^[p.Index].offset-3); blockread(f,buf,21);

  for i:=1 to 10 do buf[4+i]:=ord(s[i]);
  buf[4]:=p.trdDir^[p.Index].taptyp;
  cs:=0; for i:=4 to 20 do cs:=cs xor buf[i]; buf[21]:=cs;

  seek(f,p.trdDir^[p.Index].offset-3); blockwrite(f,buf,21);
  close(f);
  {$I+}
  if IOResult=0 then tapRename:=true;
  reMDF; reInfo('cbdnsfi'); rePDF;
 END;
p.tapMDFs(p.tapfile);
End;




{============================================================================}
function tapMakeImage:boolean;
var p:TPanel; name,stemp:string; i:byte; f:file;
begin
tapMakeImage:=false; name:='';
Case focus of left:p:=lp; right:p:=rp; End;
 CancelSB;
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+0);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Новый TAP-файл ')
             else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' New TAP-file ');
 if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'Имя файла:')
 else cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'File name:');
 printself(pal.bkdInputNT,pal.txtdInputNT,42,halfmaxy-2,8);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon; name:=scanf(42,halfmaxy-2,name,8,8,1); curoff;
 restscr;

name:=nospace(GetOf(name,_name));

if scanf_esc then exit;
if nospace(name)<>'' then
 begin
 {$I-}
  if lang=rus then stemp:='Файл '+name+'.tap'+' уже существует.'+#255+' Заменить его?'
              else stemp:='File '+name+'.tap'+' alredy exist.'+#255+' Overwrite?';
  if checkdirfile(p.pcnd+name+'.tap')=0 then if not cquestion(stemp,lang) then exit;
  case focus of left:lp.pcnn:=name+'.tap'; right:rp.pcnn:=name+'.tap'; end;
assign(f,p.pcnd+name+'.tap'); filemode:=1; rewrite(f); close(f);
 {$I+}
 end;
i:=ioresult;
if i<>0 then
 begin
  if lang=rus then errormessage('Ошибка '+strr(i)+' при создании TAP-файла')
              else errormessage('Error '+strr(i)+' while create TAP-file');
  exit;
 end;
tapMakeImage:=true;
end;







End.