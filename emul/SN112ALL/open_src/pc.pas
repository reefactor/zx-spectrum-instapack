{$O+,F+}
Unit pc;
Interface
Uses
     Dos,sn_Obj;

function  pcNameLine(var p:TPanel; m:word):string;
Procedure pcInfoPanel(w:byte);
Function  WillCopyMove(wtype:word; var TargetPath:string; var Skip:boolean):boolean;
Function  DirSize(path:string; priory:byte; var size:longint; var UserOut:boolean; sys:boolean):boolean;
function  hob2pc(name:string):string;
function  CheckEx(dir,name:pathstr):string;


Implementation
Uses
     Crt, RV, Mouse,
     Vars, Palette, sn_Mem, Utils, Main, Main_Ovr,
     TRD,TRD_Ovr,TAP,TAP_Ovr,SCL,SCL_Ovr,FDI,FDI_Ovr,FDD,FDD_Ovr;



{============================================================================}
function pcNameLine(var p:TPanel; m:word):string;
var nm,stemp:string;
begin
         p.pcnn:=p.pcDir^[m].fname;
         if p.pcnn[1]=' ' then delete(p.pcnn,1,1);
         if nospace(p.pcDir^[m].fext)<>'' then p.pcnn:=p.pcnn+'.'+p.pcDir^[m].fext;
         p.pcnn:=p.pcnn+space(12-length(p.pcnn));
         if m>p.pctdirs then p.pcnn:=strlo(p.pcnn);

         stemp:=extnum(strr(p.pcdir^[m].flength));
         if p.pcdir^[m].flength>9999999 then stemp:=extnum(strr(p.pcdir^[m].flength div 1000))+'K';
         if p.pcdir^[m].flength>999999999 then stemp:=extnum(strr(p.pcdir^[m].flength div 1000000))+'M';
         if (p.pcdir^[m].flength<0) then if lang=rus then stemp:='Каталог' else stemp:='SUB-DIR';
         if (p.pcdir^[m].flength<0)and(nospace(p.pcnn)='..') then if lang=rus then stemp:='Каталог' else stemp:='SUB-DIR';
         stemp:=changechar(stemp,' ',',');
         stemp:=space(10-length(stemp))+stemp;
         nm:=p.pcnn+' '+stemp;

         stemp:=LZ(p.pcdir^[m].fdt.day)+'-'+LZ(p.pcdir^[m].fdt.month)+'-'+copy(LZ(p.pcdir^[m].fdt.year),3,2);
         nm:=nm+' '+stemp;
         stemp:=LZ(p.pcdir^[m].fdt.hour)+':'+LZ(p.pcdir^[m].fdt.min);
         if stemp[1]='0' then stemp[1]:=' ';
         nm:=nm+' '+stemp;
pcNameLine:=nm;
end;

{============================================================================}
Procedure pcInfoPanel(w:byte);
Var
     a,b:byte; s,s0:string; i,m,l:longint; k:char; posx,posy,panellong:byte;
     treec:byte; pcnd:string; pctdirs,pctfiles:word;
     p:TPanel;
Begin
Case w of
 left:
   BEGIN
    posx:=rp.posx;
    posy:=rp.posy;
    panellong:=rp.panellong;
    treec:=lp.treec;
    pcnd:=lp.pcnd;
    pctdirs:=lp.pctdirs;
    pctfiles:=lp.pctfiles;
    p:=lp;
   END;
 right:
   BEGIN
    posx:=lp.posx;
    posy:=lp.posy;
    panellong:=lp.panellong;
    treec:=rp.treec;
    pcnd:=rp.pcnd;
    pctdirs:=rp.pctdirs;
    pctfiles:=rp.pctfiles;
    p:=rp;
   END;
End;

cmPrint(pal.bkRama,pal.txtRama,posx,posy+PanelLong-2,'║'+space(38)+'║');
cmPrint(pal.bkRama,pal.txtRama,posx,posy+PanelLong-1,'╚'+fill(38,'═')+'╝');

if lang=rus then S0:='Текущий Каталог: ' else S0:='Current directory: ';
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,2,s);{}


if treec=1 then s0:=pcnd else s0:=copy(pcnd,1,length(pcnd)-1);
if length(s0)>29 then s0:=copy(s0,1,4)+'...'+copy(s0,length(s0)-22,30);
s0:='~`'+s0+'~`';
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
for i:=1 to 10 do if length(s)>38 then delete(s,length(s),1);
if s[length(s)]='~' then delete(s,length(s),1);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,3,s);

m:=0;
for i:=1 to pctdirs+pctfiles do
 begin
  if w=left then l:=lp.pcdir^[i].flength else l:=rp.pcdir^[i].flength;
  if w=left then s:=lp.pcdir^[i].fname else s:=rp.pcdir^[i].fname;
  if (l>=0)and(s<>' ..') then inc(m,l);
 end;
if treec=1 then i:=pctdirs+pctfiles else i:=pctdirs+pctfiles-1;
if lang=rus then s:='~`'+strr(i)+'~` файл'+efiles(i,rus)+'  ~`'+changechar(extnum(strr(m)),' ',',')+'~` байт'
else s:='~`'+strr(i)+'~` file'+efiles(i,lang)+' with ~`'+changechar(extnum(strr(m)),' ',',')+'~` bytes';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,4,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,5,space(38));

if lang=rus then s:='~`'+changechar(extnum(strr(disksize(ord(pcnd[1])-64))),' ',',')+'~` байт на диске ~`'+pcnd[1]+':~`'
else s:='~`'+changechar(extnum(strr(disksize(ord(lp.pcnd[1])-64))),' ',',')+'~` total bytes on drive ~`'+lp.pcnd[1]+':~`';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,6,s);

m:=diskfree(ord(pcnd[1])-64); s:=extnum(strr(m));
if m>999999999 then s:=extnum(strr(m div 1000000))+'G';
s0:=changechar(s,' ',',');
if lang=rus then s:='~`'+s0+'~` байт свободно на диске ~`'
else s:='~`'+s0+'~` free bytes on drive ~`';
s0:=s+lp.pcnd[1]+':~`';
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,7,s);

if lang=rus then s:='Метка тома на диске ~`'+pcnd[1]+': '+getvolname(ord(pcnd[1])-64)
else s:='Volume label on drive ~`'+pcnd[1]+': '+getvolname(ord(pcnd[1])-64);
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,8,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,9,space(38));

gettotalmemoryinfo;
if lang=rus then s:='~`'+strr(totalram)+'~`K байт памяти'
else s:='~`'+strr(totalram)+'~`K Bytes conventional memory';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,10,s);

if lang=rus then s:='~`'+changechar(extnum(strr(dosmem)),' ',',')+'~` байт памяти для работы'
else s:='~`'+changechar(extnum(strr(dosmem)),' ',',')+'~` Bytes memory for user';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,11,s);

m:=totalram; m:=m*1024-dosmem;
if lang=rus then s:='~`'+changechar(extnum(strr(m)),' ',',')+'~` байт памяти для Навигатора'
else s:='~`'+changechar(extnum(strr(m)),' ',',')+'~` Bytes memory for Navigator';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,12,s);

s0:='────────────────'; s:=s0;
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+12,13,s);

if EMM_Installed then
begin
if lang=rus then s:='~`EMM~` версия LIM ~`'+EXPversion else s:='~`EMM~` version LIM ~`'+EXPversion;
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,14,s);

if lang=rus then s:='EMS: ~`'+strr(totalEXP)+'~`K всего, ~`'+strr(availEXP)+'~`K свободно'
else s:='EMS: ~`'+strr(totalEXP)+'~`K total, ~`'+strr(availEXP)+'~`K free';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,15,s);
end;

if lang=rus then s:='~`'+strr(totalXMS)+'~`K байт свободной ~`XMS~` памяти'
else s:='~`'+strr(totalXMS)+'~`K free extended memory';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);

if XMS_installed then if EMM_Installed then
begin
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,16,s);
end else
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,14,s);

StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,17,space(38));
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,18,space(38));
StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+1,19,space(38));

{
if lang=rus then s:='Процессор ~`'+Cpu_Type+' '+strr(Cpu_Speed)+'MHz'
else s:='CPU ~`'+Cpu_Type+' '+strr(Cpu_Speed)+'MHz';
s0:=s;
i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);
StatusLineColor(bkDiskInfoNT,txtDiskInfoNT,bkDiskInfoST,txtDiskInfoST,posx+1,18,s);
{}

i:=0; l:=0;
for m:=pctdirs+1 to pctdirs+pctfiles do
 if p.pcdir^[m].mark then
  begin
   if keypressed then begin k:=readkey; if k=#27 then break; end;
   if ithobeta(pcnd+p.pcdir^[m].fname+'.'+p.pcdir^[m].fext, hobetainfo) then
    begin
     inc(i,hobetainfo.totalsec);
     inc(l);
    end;
  end;

if i>0 then
 begin
  s0:='────────────────'; s:=s0;
  StatusLineColor(pal.bkDiskInfoNT,pal.txtDiskInfoNT,pal.bkDiskInfoST,pal.txtDiskInfoST,posx+12,19,s);
  if lang=rus then s:='~`'+strr(i)+'~` блок'+eb(i,lang)+' отмечено в ~`'+strr(l)+'~` Хоб файл'+ewfiles(l,lang)
              else s:='~`'+strr(i)+'~` block'+eb(i,lang)+' selected in ~`'+strr(l)+'~` Hob file'+ewfiles(l,lang);
  s0:=s;
  i:=19-(length(without(s0,'~`'))div 2); if i<0 then i:=0;
  s:=space(i)+s0; s:=s+space(abs(38-CClen(s))); if CClen(s)>38 then delete(s,39+8,10);

  i:=p.putfrom+p.panelhi+1+(p.InfoLines-2);
{  if p.InfoLines=1 then dec(i);{}
{  if p.InfoLines=3 then inc(i);{}
  StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,posx+1,i-1,space(38));
  StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,posx+1,i,s);
 end
else
 begin
  i:=p.putfrom+p.panelhi+1+(p.InfoLines-2);
{  if p.InfoLines=1 then dec(i);{}
{  if p.InfoLines=3 then inc(i);{}
  StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,posx+1,i-1,space(38));
  StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,posx+1,i,space(38));
 end;
{}
End;






{============================================================================}
Function  WillCopyMove(wtype:word; var TargetPath:string; var Skip:boolean):boolean;
Var
    a1,a2:string[49]; s,st:string; wtemp:word;
{== SCANF ===================================================================}
function pscanf(scanf_posx, scanf_posy:byte;
               scanf_str:string;
               scanf_total, scanf_visible,
               scanf_cur:byte):string;
var
     scanf_kod:char; x:byte;
     scanf_x, scanf_from:byte;
     scanf_str_old:string;
label loop,loop2;
begin
x:=15;
scanf_esc:=false;
scanf_str_old:=scanf_str;
scanf_str:=scanf_str+space(scanf_total-length(scanf_str));
scanf_x:=scanf_cur;
scanf_from:=1;
if scanf_visible>length(scanf_str) then scanf_visible:=length(scanf_str);
if skip then
 begin
  cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+0,'( )'+a1);
  cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+1,'('#7')'+a2);
 end
else
 begin
  cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+0,'('#7')'+a1);
  cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+1,'( )'+a2);
 end;

loop:
mprint(scanf_posx,scanf_posy,copy(scanf_str,scanf_from,scanf_visible));
gotoxy(scanf_posx+scanf_x-scanf_from,scanf_posy);
If Moused then MouseOn;
scanf_kod:=readkey;
if scanf_kod=#27 then begin pscanf:=scanf_str_old; scanf_esc:=true; exit; end;
if scanf_kod=#13 then begin pscanf:=scanf_str; exit; end;

if ((scanf_kod)>=' ')and((scanf_kod)<='я')and(scanf_x<=length(scanf_str)) then
 begin
  scanf_str:=copy(scanf_str,1,scanf_x-1)+scanf_kod+copy(scanf_str,scanf_x,length(scanf_str));
  scanf_str:=copy(scanf_str,1,length(scanf_str)-1);
  inc(scanf_x);
  if scanf_x-scanf_from>scanf_visible then inc(scanf_from);
  if scanf_x>length(scanf_str)+1 then scanf_x:=length(scanf_str)+1;
 end;

if scanf_kod=#8 then
 begin
  scanf_str:=copy(scanf_str,1,scanf_x-2)+copy(scanf_str,scanf_x,length(scanf_str));
  dec(scanf_x);
  if scanf_x<scanf_from then dec(scanf_from);
  if scanf_x<1 then scanf_x:=1 else scanf_str:=scanf_str+' ';
  if scanf_from<1 then scanf_from:=1;
  if scanf_x<1 then scanf_x:=1;
 end;

if scanf_kod=#9 then
 begin
  curoff;
  if Moused then MouseOff;
  if skip then
   begin
    cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+0,'( )'+a1);
    cmprint(pal.bkdPoleST,pal.txtdPoleST,x,halfmaxy+1,'('#7')'+a2);
   end
  else
   begin
    cmprint(pal.bkdPoleST,pal.txtdPoleST,x,halfmaxy+0,'('#7')'+a1);
    cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+1,'( )'+a2);
   end;
loop2:
  if Moused then MouseOn;
  scanf_kod:=readkey;
  if scanf_kod=#9 then
   begin
    if Moused then MouseOff;
    cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+0,'( )'+a1);
    cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+1,'( )'+a2);
    if skip then
     begin
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x+1,halfmaxy+0,' ');
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x+1,halfmaxy+1,#7);
     end
    else
     begin
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x+1,halfmaxy+0,#7);
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x+1,halfmaxy+1,' ');
     end;
    curon;
    goto loop;
   end;
  if scanf_kod=#13 then begin pscanf:=scanf_str; exit; end;
  if scanf_kod=#27 then begin pscanf:=scanf_str_old; scanf_esc:=true; exit; end;
  if scanf_kod=#0 then
   begin
    scanf_kod:=readkey;
    if scanf_kod=kb_up then
     begin
      skip:=false;
      cmprint(pal.bkdPoleST,pal.txtdPoleST,x,halfmaxy+0,'('#7')'+a1);
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+1,'( )'+a2);
     end;
    if scanf_kod=kb_down then
     begin
      skip:=true;
      cmprint(pal.bkdPoleNT,pal.txtdPoleNT,x,halfmaxy+0,'( )'+a1);
      cmprint(pal.bkdPoleST,pal.txtdPoleST,x,halfmaxy+1,'('#7')'+a2);
     end;
   end;
  if Moused then MouseOff;
  goto loop2;
 end;

if scanf_kod=#25 then
 begin
  scanf_str:=space(scanf_total);
  scanf_from:=1;
  scanf_x:=1;
 end;

if scanf_kod=#0 then
 begin
  scanf_kod:=readkey;
  if scanf_kod=#71 then begin scanf_from:=1; scanf_x:=1; end;
  if scanf_kod=#79 then begin scanf_from:=scanf_total-scanf_visible+1; scanf_x:=length(scanf_str); end;
  if scanf_kod=#83 then scanf_str:=copy(scanf_str,1,scanf_x-1)+copy(scanf_str,scanf_x+1,length(scanf_str))+' ';
  if scanf_kod=#77 then
   begin
    inc(scanf_x);
    if scanf_x-scanf_from>scanf_visible then inc(scanf_from);
   end;
  if scanf_kod=#75 then
   begin
    dec(scanf_x);
    if scanf_x<scanf_from then dec(scanf_from);
   end;

  if scanf_from<1 then scanf_from:=1;
  if scanf_x<1 then scanf_x:=1;
  if scanf_x>length(scanf_str)+1 then begin scanf_x:=length(scanf_str)+1; dec(scanf_from); end;
  if scanf_posx+scanf_x>gmaxx then scanf_x:=gmaxx-scanf_posx;
 end;

if Moused then MouseOff;
goto loop;
end;
{============================================================================}
{== END SCANF ===============================================================}
{============================================================================}
Var p:TPanel;
Begin
if lang=rus then
 begin
  a1:=' Обновить старые файлы                           ';
  a2:=' Пропустить все существующие файлы               ';
 end
else
 begin
  a1:=' Overwrite all existing files                    ';
  a2:=' Skip all existing files                         ';
 end;
Skip:=false;
WillCopyMove:=false;

if (PanelTypeOf(focus)=zxzPanel)or(PanelTypeOf(ofocus)=zxzPanel) then exit;
{
if PanelTypeOf(focus)=zxzPanel then if PanelTypeOf(ofocus)<>zxzPanel then exit;
if PanelTypeOf(ofocus)=zxzPanel then if PanelTypeOf(focus)<>zxzPanel then exit;
{}
if PanelTypeOf(focus)=pcPanel then
BEGIN
if (PanelTypeOf(ofocus)<>pcPanel)and(InsedOf(focus)=0)and(IndexOf(focus)<=tDirsOf(focus))
then Exit;
if (PanelTypeOf(ofocus)<>pcPanel)and(InsedOf(focus)=1)and(FirstMarkedOf(focus)<=tDirsOf(focus))
then Exit;


if InsedOf(focus)=0 then Begin s:=TrueNameOf(focus,IndexOf(focus)); wtemp:=IndexOf(focus); End;
if (InsedOf(focus)=0)and(nospace(s)='..') then Exit;
if InsedOf(focus)=1 then Begin s:=TrueNameOf(focus,FirstMarkedOf(focus)); wtemp:=FirstMarkedOf(focus); End;
if wtemp<=tDirsOf(focus)
  then
    if wtype=_F5
    then
      if lang=rus then s:='Копировать каталог ~`'+s+'~`'
                  else s:='Copy directory ~`'+s+'~`'
    else
      if lang=rus then s:='Переименовать или переместить каталог ~`'+s+'~`'
                  else s:='Rename or move directory ~`'+s+'~`'
  else
    if wtype=_F5
    then
      if lang=rus then s:='Копировать файл ~`'+s+'~`'
                  else s:='Copy file ~`'+s+'~`'
    else
      if lang=rus then s:='Переименовать или переместить файл ~`'+s+'~`'
                  else s:='Rename or move file ~`'+s+'~`';
END
else
BEGIN
Case focus of left:p:=lp; right:p:=rp; end;
if (p.Insed=0)and(p.Index=1) then Exit;
if p.Insed=0 then
 Begin
  s:=p.trdDir^[p.Index].name+'.'+TRDOSe3(p,p.Index);
  if (s[1]=#0)or(s[1]=#1) then exit;
  if p.PanelType=tapPanel then
   begin
    if (p.Index>2)and(p.trdDir^[p.Index-1].tapflag=0)
      then s:=p.trdDir^[p.Index-1].name else s:='less';
    if PanelTypeOf(oFocus)=tapPanel then
     if p.trdDir^[p.Index].tapflag=0
      then s:=p.trdDir^[p.Index].name
      else
       if (p.Index>2)and(p.trdDir^[p.Index-1].tapflag=0)
          then s:='codes of "'+p.trdDir^[p.Index-1].name+'"'
          else s:='codes';
   end;
 End;
if p.Insed=1 then
 Begin
  s:=p.trdDir^[p.FirstMarked].name+'.'+TRDOSe3(p,p.FirstMarked);
  if (s[1]=#0)or(s[1]=#1) then exit;
  if p.PanelType=tapPanel then
   begin
    if (p.FirstMarked>2)and(p.trdDir^[p.FirstMarked-1].tapflag=0)
      then s:=p.trdDir^[p.FirstMarked-1].name else s:='less';
    if PanelTypeOf(oFocus)=tapPanel then
     if p.trdDir^[p.FirstMarked].tapflag=0
      then s:=p.trdDir^[p.FirstMarked].name
      else
       if (p.Index>2)and(p.trdDir^[p.FirstMarked-1].tapflag=0)
          then s:='codes of "'+p.trdDir^[p.FirstMarked-1].name+'"'
          else s:='codes';
   end;
 End;
if wtype=_F5
    then
      if lang=rus then s:='Копировать файл ~`'+s+'~`'
                  else s:='Copy file ~`'+s+'~`'
    else
      if lang=rus then s:='Переименовать или переместить файл ~`'+s+'~`'
                  else s:='Rename or move file ~`'+s+'~`';
END;

if InsedOf(focus)>1 then
 Begin
  s:=strr(InsedOf(focus));
  if wtype=_F5
  then
    if lang=rus then s:='Копировать ~`'+s+'~` файл'+efiles(InsedOf(focus),rus)
                else s:='Copy ~`'+s+'~` file'+efiles(InsedOf(focus),eng)
  else
    if lang=rus then s:='Пеpеименовать или пеpемеcтить ~`'+s+'~` файл'+efiles(InsedOf(focus),rus)
                else s:='Remane or move ~`'+s+'~` file'+efiles(InsedOf(focus),eng);
 End;

If Moused then MouseOff;{}
CancelSB;
Colour(pal.bkdRama,pal.txtdRama);
scPutWin(pal.bkdRama,pal.txtdRama,12,halfmaxy-5,69,halfmaxy-3+6);
if wtype=_F5
then
  if lang=rus then cmCentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Копирование ')
              else cmCentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Copy ')
else
  if lang=rus then cmCentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Переименование/перемещение ')
              else cmCentre(pal.bkdRama,pal.txtdRama,halfmaxy-5,' Rename/Move ');
StatusLineColor(pal.bkdLabelST,pal.txtdLabelST,pal.bkdLabelNT,pal.txtdLabelNT,16,halfmaxy-3,s);

Colour(pal.bkdInputNT,pal.txtdInputNT); curon;
 s:=nospace(pscanf(15,halfmaxy-2,'',52,52,1)); curoff; restscr;
 if not scanf_esc then
  begin
   TargetPath:={nospace{}(pcndOf(oFocus));

   if nospace(s)<>'' then {
    if (InsedOf(focus)=0)or(InsedOf(focus)=1)
     then TargetPath:=pcndOf(Focus)
     else {}TargetPath:=pcndOf(Focus)+(s);
   if s[1]='\' then Begin st:=pcndOf(Focus); TargetPath:=(st[1]+':'+strhi(s)); End;
   if s[2]=':' then TargetPath:=(strhi(s));
   if TargetPath[length(TargetPath)]<>'\' then TargetPath:=TargetPath+'\';
   WillCopyMove:=true;

  end;

End;




{============================================================================}
Function DirSize(path:string; priory:byte; var size:longint; var UserOut:boolean; sys:boolean):boolean;
Var
    q:char; stemp:string[20];
procedure FileScan(path:pathstr);
var sr:searchrec; s:string;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if not sys then if KeyPressed then begin q:=ReadKey; if q=#27 then UserOut:=true; end;

   if UserOut then break;
   if (sr.attr and (directory or volumeid)=0) then inc(size,sr.size);
   FindNext(sr);
  end;
end;

procedure DirScan(path:pathstr);
var sr:searchrec; s:string;
begin
 FindFirst(path+'\*.*', $3F, sr);
 while DosError=0 do
  begin
   if ((sr.attr and directory)=directory)and not((sr.name='.')or(sr.name='..')) then
    begin
     if not sys then if KeyPressed then begin q:=ReadKey; if q=#27 then UserOut:=true; end;

     if UserOut then break;
     DirScan(path+'\'+sr.name);
     FileScan(path+'\'+sr.name);
    end;
   FindNext(sr);
  end;
end;

Begin
UserOut:=false; DirSize:=true;
Size:=0;
if priory=0 then
 begin
  DirScan(path);
  FileScan(path);
 end
else
 begin
  Size:=filelen(path);
 end;
if UserOut then DirSize:=false;
End;




{============================================================================}
function hob2pc(name:string):string;
var i,m:byte; s,d:string;
begin
s:=nospaceLR(mid(name,1,8));
d:=strlo(s);
if (d='com1')or(d='com2')or(d='com3')or(d='com4')or(d='com5')or(d='com6')or
   (d='lpt1')or(d='lpt2')or(d='lpt3')or(d='lpt4')or(d='lpt5')or(d='lpt6')or
   (d='nul')or(d='con')or(d='aux')or(d='prn') then s:=s+d;

for i:=1 to length(s) do
 begin
  if s[i]=' ' then s[i]:='_';
  if s[i] in ['.',':',',','\','/','?','*','>','<','+','"',#39] then s[i]:='-';
  if s[i]=#0 then s[i]:='0';
  if s[i]=#1 then s[i]:='1';
  if s[i]=#2 then s[i]:='2';
  if s[i]=#3 then s[i]:='3';
  if s[i]=#4 then s[i]:='4';
  if s[i]=#5 then s[i]:='5';
  if s[i]=#6 then s[i]:='6';
  if s[i]=#7 then s[i]:='7';
  if s[i]=#8 then s[i]:='8';
  if s[i]=#9 then s[i]:='9';
  if s[i]=#10 then s[i]:='A';
  if s[i]=#11 then s[i]:='B';
  if s[i]=#12 then s[i]:='C';
  if s[i]=#13 then s[i]:='D';
  if s[i]=#14 then s[i]:='E';
  if s[i]=#15 then s[i]:='F';
  if s[i]=#16 then s[i]:='G';
  if s[i]=#17 then s[i]:='H';
  if s[i]=#18 then s[i]:='I';
  if s[i]=#19 then s[i]:='J';
  if s[i]=#20 then s[i]:='K';
  if s[i]=#21 then s[i]:='L';
  if s[i]=#22 then s[i]:='M';
  if s[i]=#23 then s[i]:='N';
  if s[i]=#24 then s[i]:='O';
  if s[i]=#25 then s[i]:='P';
  if s[i]=#26 then s[i]:='Q';
  if s[i]=#27 then s[i]:='R';
  if s[i]=#28 then s[i]:='S';
  if s[i]=#29 then s[i]:='T';
  if s[i]=#30 then s[i]:='U';
  if s[i]=#31 then s[i]:='V';
 end;
hob2pc:=s;
end;





{============================================================================}
function CheckEx(dir,name:pathstr):string;
var i:longint; s:string[3]; t:string[8]; e:byte;
begin
i:=0;
checkex:=name;
e:=checkdirfile(dir+name);
if e<>0 then exit;
while e=0 do
 begin
  t:=getof(name,_name);
  t:=t+space(8-length(t));
  s:=strr(i);
  if (i>=0)and(i<10) then s:='00'+s;
  if (i>=10)and(i<100) then s:='0'+s;
  t[6]:=s[1];
  t[7]:=s[2];
  t[8]:=s[3];
  checkex:=nospace(t)+getof(name,_ext);
  inc(i);
  e:=checkdirfile(dir+nospace(t)+getof(name,_ext));
 end;
end;




Begin
sBar[rus,pcPanel]:='~`Alt+X~` Выход  ~`F3~` Смотр  ~`F5~` Копия  ~`F6~` Перем  ~`F7~` Дир  ~`F8~` Удалить  ~`F9~` Новый';
sBar[eng,pcPanel]:='~`Alt+X~` Exit  ~`F3~` View  ~`F5~` Copy  ~`F6~` Rename/Move  ~`F7~` MkDir  ~`F8~` Delete  ~`F9~` New';
lp.pcfrom:=1; lp.pcf:=1;
rp.pcfrom:=1; rp.pcf:=1;
End.