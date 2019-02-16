Unit sn_Obj;
Interface
Uses
     Dos;

Type
    zxDirRec=
         record
          name:string[10];
          typ:char;
          start:word;
          length:word;
          totalsec:byte;
          n1sec:byte;
          n1tr:byte;
          mark:boolean;

          param1:word;
          param2:word;
          tapflag:byte;
          taptyp:byte;
          offset:longint;

          zxzPackSize:word;
          zxzCRC32:longint;
          zxzPackMethod:byte;
          zxzFlag:byte;

          description:string[1];

         end;
    zxDirP=array[1..1] of zxDirRec;
    zxDiskRec=
         record
          n1FreeSec:byte;
          nTr1FreeSec:byte;
          DiskTyp:byte;
          files:word;
          free:word;
          trdosCode:byte;
          delfiles:word;
          diskLabel:string[20];
          tracks:byte;
         end;
    zxInsedRec=
         record
          crc16:word;
         end;
    zxInsedP=array[1..1] of zxInsedRec;


     pcDirRec=
      record
       fname:string[8];
       fext:string[3];
       flength:longint;
       mark:boolean;
       fdt:datetime;
       fattr:word;
       priory:byte;
       description:string[1];
      end;
     pcDirP=array[1..1]of pcDirRec;

     pcInsedRec=
      record
       crc16:word;
      end;
     pcInsedP=array[1..1] of pcInsedRec;

Type
   tfdi=
    record
     kLabel:string[3];
     Flag:byte;
     cyl:word;
     heads:word;
     offText:word;
     offData:word;
     extDataLenHeader:word;
     extDataLen:word;
     offHeaderCyl:word;
    end;

Type
     PPanel=^TPanel;
     TPanel=
      object
       Place                    :byte;
       PanelLong, PanelHi,
       Columns                  :byte;
       InfoLines                :byte;
       PutFrom, PosX, PosY      :byte;
       NameLine                 :boolean;
       Visible                  :boolean;
       Focused                  :boolean;

       PanelType                :byte;
       clLastPanelType,
       ckLastPanelType,
       LastPanelType            :byte;

       xc,yc,lc                 :byte;
       tdirs,tfiles             :integer;
       from,f                   :integer;

       pcDir                    :^pcdirp;
       pcIns                    :^pcinsedp;
       pcnd,oldpcnd             :string;
       pcnn                     :string;
       TreeC                    :byte;
       SortType                 :byte;

       pctdirs,pctfiles         :integer;
       oldpctdirs,oldpctfiles   :integer;

       flptfiles,
       trdtfiles,taptfiles,fditfiles,
       fddtfiles,zxztfiles,scltfiles
                                :word;

       flpnn,
       trdnn,fdinn,fddnn,
       tapnn,sclnn,zxznn        :string;

       pcf,pcfrom,
       trdfrom,trdf,fdifrom,fdif,
       tapfrom,tapf, fddfrom,fddf,
       flpfrom,flpf, isfrom,isf,
       zxzfrom,zxzf, sclfrom,sclf,
       bbsfrom,bbsf             :integer;

       zxDisk                   :zxDiskRec;
       trdDir                   :^zxDirP;
       trdIns                   :^zxInsedP;

       flpDrive                 :char;
       trdFile,tapFile,fdiFile,
       fddFile,zxzFile,sclFile  :string;

       fdiRec:tfdi;

       Procedure flpMDFs(flpDriveName:char);
       Procedure flpPDFs(fr:integer);

       Procedure zxzMDFs(zxzFileName:string);
       Procedure zxzPDFs(fr:integer);

       Procedure fddMDFs(fddFileName:string);
       Procedure fddPDFs(fr:integer);

       Procedure tapMDFs(tapFileName:string);
       Procedure tapPDFs(fr:integer);

       Procedure sclMDFs(sclFileName:string);
       Procedure sclPDFs(fr:integer);

       Procedure trdMDFs(trdFileName:string);
       Procedure trdPDFs(fr:integer);

       Procedure fdiMDFs(fdiFileName:string);
       Procedure fdiPDFs(fr:integer);

       Procedure PanelSetup;
       Procedure Build(parts:string);
       Procedure Hide;
       {
       Procedure ShowCur;
       Procedure HideCur;
       {}
       procedure pcAdd(r:pcdirrec; isitdir:boolean; ind:integer);
       procedure pcMDF(path:pathstr);
       procedure GetCurXY(var x,y:byte);
       procedure pcPDF(fr:integer);

       procedure MDF;
       procedure PDF;

       Procedure Info(parts:string);

       Function  GetTreeC(path:string):byte;
       Function  Insed:word;

       Procedure Inside;
       Procedure Outside;
       Function  Index:word;
       Function  TrueName(ind:word):string;
       Procedure TrueCur;

       Procedure ShiftEnter;
       Procedure Enter;
       Procedure CtrlPgUp;
       Procedure CtrlPgDn;

       Procedure AltF1F2(ps:byte);
       Procedure CtrlLeft;
       Procedure CtrlRight;
       Procedure CtrlLeftRightDoIt(stemp:char);

       Procedure Insert;
       Procedure Star(Ctrled:boolean);
       Procedure Plus(Ctrled:boolean);
       Procedure Minus(Ctrled:boolean);

       Function  FirstMarked:word;
       Procedure Del;

       Procedure fCopy;
       Procedure fMove;
       Procedure Rename;
       Function  View(sys:boolean):longint;
       Procedure Edit;
       Procedure FileAttrs;
       Procedure AltNumber(n:byte);

       Procedure pcJoinFiles;
       Procedure Navigate;
      end;

Var
     rp,lp:TPanel;

Implementation
Uses
     Crt, RV, Mouse, Clock,
     Vars, Palette, sn_Mem, Main, Main_Ovr, Sorting, Utils, snViewer,
     PC,PC_Ovr,TRD,TRD_Ovr,FDI,FDI_Ovr,SCL,SCL_Ovr,TAP,TAP_Ovr,
     FDD,FDD_Ovr,ZXZIP, UserMenu, sn_KBD, sn_Setup, init, FLP,FLP_OVR;



{============================================================================}
Procedure TPanel.flpMDFs(flpDriveName:char);
Begin
 if Place=left  then flpMDF(lp,flpDrive);
 if Place=right then flpMDF(rp,flpDrive);
End;



{============================================================================}
Procedure TPanel.flpPDFs(fr:integer);
Begin
 if Place=left  then flpPDF(lp,fr);
 if Place=right then flpPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.zxzMDFs(zxzFileName:string);
Begin
 if Place=left  then zxzMDF(lp,zxzfile);
 if Place=right then zxzMDF(rp,zxzfile);
End;



{============================================================================}
Procedure TPanel.zxzPDFs(fr:integer);
Begin
 if Place=left  then zxzPDF(lp,fr);
 if Place=right then zxzPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.fddMDFs(fddFileName:string);
Begin
 if Place=left  then fddMDF(lp,fddfile);
 if Place=right then fddMDF(rp,fddfile);
End;



{============================================================================}
Procedure TPanel.fddPDFs(fr:integer);
Begin
 if Place=left  then fddPDF(lp,fr);
 if Place=right then fddPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.tapMDFs(tapFileName:string);
Begin
 if Place=left  then tapMDF(lp,tapfile);
 if Place=right then tapMDF(rp,tapfile);
End;



{============================================================================}
Procedure TPanel.tapPDFs(fr:integer);
Begin
 if Place=left  then tapPDF(lp,fr);
 if Place=right then tapPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.sclMDFs(sclFileName:string);
Begin
 if Place=left  then sclMDF(lp,lp.sclfile);
 if Place=right then sclMDF(rp,rp.sclfile);
End;



{============================================================================}
Procedure TPanel.sclPDFs(fr:integer);
Begin
 if Place=left  then sclPDF(lp,fr);
 if Place=right then sclPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.trdMDFs(trdFileName:string);
Begin
 if Place=left  then trdMDF(lp,trdfile);
 if Place=right then trdMDF(rp,trdfile);
End;



{============================================================================}
Procedure TPanel.trdPDFs(fr:integer);
Begin
 if Place=left  then trdPDF(lp,fr);
 if Place=right then trdPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.fdiMDFs(fdiFileName:string);
Begin
 if Place=left  then fdiMDF(lp,fdifile);
 if Place=right then fdiMDF(rp,fdifile);
End;



{============================================================================}
Procedure TPanel.fdiPDFs(fr:integer);
Begin
 if Place=left  then fdiPDF(lp,fr);
 if Place=right then fdiPDF(rp,fr);
End;



{============================================================================}
Procedure TPanel.PanelSetup;
Var
    i:byte;
Begin
PanelLong:=gmaxy-1;
if CmdLine then dec(PanelLong);

PanelHi:=gmaxy-4-InfoLines;
if NameLine then Begin dec(PanelHi); PutFrom:=3; End else PutFrom:=2;
if CmdLine then dec(PanelHi);
End;




{============================================================================}
Procedure TPanel.Build(parts:string);
Var
    s:string;
Begin
PanelSetup;{}
if Columns<1 then Columns:=1;
if Columns>3 then Columns:=3;

if pos('0',parts)<>0 then if PanelType<>noPanel then
 begin
  s:='…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕª';
  if (posx<>1)and clocked then s:='…ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ';
  cmprint(pal.BkRama,pal.TxtRama,posx,1, s);
  for i:=1 to PanelLong-2 do cmprint(pal.BkRama,pal.TxtRama,posx,1+i, '∫                                      ∫');
  cmprint(pal.BkRama,pal.TxtRama,posx,PanelLong, '»ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº');
 end;

if pos('1',parts)<>0 then if (PanelType>=1)and(PanelType<=10) then
 begin
  for i:=1 to PanelLong-InfoLines-3 do
   begin
    case Columns of
     1:  begin
          cmprint(pal.BkRama,pal.TxtRama,posx+13,1+i,'≥');
          cmprint(pal.BkRama,pal.TxtRama,posx+26,1+i,' ');{}
          cmprint(pal.BkRama,pal.TxtRama,posx+19,1+i,' ');{}
         end;
     2:  begin
          {cmprint(BkRama,TxtRama,posx+13,1+i,' ');{}
          {cmprint(BkRama,TxtRama,posx+26,1+i,' ');{}
          cmprint(pal.BkRama,pal.TxtRama,posx+19,1+i,'≥');
         end;
     3:  begin
          cmprint(pal.BkRama,pal.TxtRama,posx+13,1+i,'≥');
          cmprint(pal.BkRama,pal.TxtRama,posx+26,1+i,'≥');
          {cmprint(BkRama,TxtRama,posx+19,1+i,' ');{}
         end;
    end;
   end;

  case Columns of
   1:  s:='∫ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∫';
   2:  s:='∫ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ∫';
   3:  s:='∫ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒ∫';
  end;
  cmprint(pal.BkRama,pal.TxtRama,posx,PanelLong-InfoLines-1,s);
 end;

if pos('2',parts)<>0 then if (PanelType>=1)and(PanelType<=10) then
 begin
  if NameLine then
   begin
    if lang=rus then s:='    à¨Ô     ' else s:='    Name    ';
    case Columns of
     1:
        Begin
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+1,2,s);
         if lang=rus then s:='éØ®·†≠®•' else s:='Description';
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+15,2,s+space(24-length(s)));
        End;
     2:
        Begin
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+4,2,s+space(3));
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+20,2,space(4)+s);
        End;
     3:
        Begin
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+1,2,s);
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+1+13,2,s);
         cmprint(pal.BkNameLine,pal.TxtNameLine,posx+1+13+13,2,s);
        End;
    end;
   end;
 end;

End;




{============================================================================}
procedure TPanel.Hide;
var
   dy,ix,iy,i:word; dx:byte;
begin
 if CmdLine then dy:=gmaxy-3 else dy:=gmaxy-2;
 i:=posx*2-1;
 for iy:=0 to dy{gmaxy-3{} do
  begin
   if Clocked and (iy=0)and(posx=41) then dx:=30 else dx:=40;
   for ix:=posx-1 to posx+dx-2 do
    begin
     mem[$B800:((80*iy)+ix)*2]:=SavedDeskTop^[i];   inc(i);
     mem[$B800:((80*iy)+ix)*2+1]:=SavedDeskTop^[i]; inc(i);
    end;
   if dx=40 then inc(i,80) else inc(i,100);
  end;
 PanelType:=noPanel;
end;


{============================================================================}
{
Procedure TPanel.ShowCur;
Var
    i:byte;
    px,py,paper,ink,dx,dlc:byte;
Begin
yc:=PutFrom-1; xc:=posx+1;
if Columns=2 then begin dx:=19; lc:=18; end else begin dx:=13; lc:=12; end;
if Columns=1 then begin dx:=0; lc:=38; end;
paper:=bkCurNT; ink:=txtCurNT;
for i:=1 to f do
 begin
  inc(yc);
  if yc>PanelHi+PutFrom-1 then begin inc(xc,dx); yc:=PutFrom; end;
  if xc=posx+20 then dlc:=1 else dlc:=0;
 end;
printself(paper,ink,xc,yc,lc+dlc);
End;
{}

{============================================================================}
{
Procedure TPanel.HideCur;
Var
    i:byte;
    px,py,paper,ink,dx,dlc:byte;
Begin
if Columns=2 then begin dx:=19; lc:=18; end else begin dx:=13; lc:=12; end;
if Columns=1 then begin dx:=0; lc:=38; end;
paper:=bkNT; ink:=txtNT;
printself(paper,ink,xc,yc,lc+dlc);
End;
{}


{============================================================================}
procedure TPanel.pcAdd(r:pcdirrec; isitdir:boolean; ind:integer);
var
   m:integer;
begin
pcdir^[ind].fname  :=r.fname;
pcdir^[ind].fext   :=r.fext;
pcdir^[ind].fdt    :=r.fdt;
pcdir^[ind].fattr  :=r.fattr;
pcdir^[ind].mark   :=false;
if isitdir then
 begin
  pcdir^[ind].flength:=-1; pcdir^[ind].priory:=0;
 end
else
 begin
  pcdir^[ind].flength:=r.flength;  pcdir^[ind].priory:=10;
  r.fext:=nospace(strlo(r.fext)); if r.fext='' then r.fext:='.';
  if pos(';'+r.fext+';',pr1)<>0 then pcdir^[ind].priory:=1;
  if pos(';'+r.fext+';',pr2)<>0 then pcdir^[ind].priory:=2;
  if pos(';'+r.fext+';',pr3)<>0 then pcdir^[ind].priory:=3;
  if pos(';'+r.fext+';',pr4)<>0 then pcdir^[ind].priory:=4;
  if pos(';'+r.fext+';',pr5)<>0 then pcdir^[ind].priory:=5;
  if pos(';'+r.fext+';',pr6)<>0 then pcdir^[ind].priory:=6;
  if pos(';'+r.fext+';',pr7)<>0 then pcdir^[ind].priory:=7;
  if pos(';'+r.fext+';',pr8)<>0 then pcdir^[ind].priory:=8;
  if pos(';'+r.fext+';',pr9)<>0 then pcdir^[ind].priory:=9;
 end;
end;



{============================================================================}
procedure TPanel.pcMDF(path:pathstr);
var
   rec:searchrec; dt:datetime;
   strtemp:string; fattrm,ie,i,m,j,readed:integer;
   fa:file; fnew:pcdirrec; nd:string; pcinsed:word;
Label beg;
begin
beg:
j:=0; nd:=pcnd;
for i:=1 to pctdirs+pctfiles do if pcdir^[i].mark then
 begin inc(j); pcins^[j].crc16:=crc16(pcdir^[i].fname+'.'+pcdir^[i].fext); end;
pcinsed:=j;

path:=checkpath(path);
if (path[length(path)]='\')and(length(path)>3) then delete(path,length(path),1);
{$I-} chdir(Path); {$I+}
if ioresult<>0 then Begin Path:='C:'; goto beg; end;

pcnd:=curentdir; if pcnd[length(pcnd)]<>'\' then pcnd:=pcnd+'\';
GetTreeC(pcnd);
oldpctdirs:=pctdirs; oldpctfiles:=pctfiles;
pctdirs:=0; pctfiles:=0;

findfirst('*.*',$3F,rec);
while doserror=0 do
 begin
  if (rec.name='.') then findnext(rec);
  unpacktime(rec.time,dt);
  fnew.fname:=getof(rec.name,_name);
  fnew.fext:=copy(getof(rec.name,_ext),2,3);
  if rec.name='..' then begin fnew.fname:=' ..'; fnew.fext:=''; end;
  fnew.fext:=fnew.fext+space(3-length(fnew.fext));
  fnew.flength:=rec.size;
  fnew.fdt:=dt;
  fnew.fattr:=rec.attr;
  fnew.mark:=false;

  if (rec.attr and directory = directory) then
  if HideHidden then
   begin
    if (rec.attr and hidden <> hidden) then
    begin inc(pctdirs); pcAdd(fnew,true,pctdirs+pctfiles); end;
   end
  else
   begin
    begin inc(pctdirs); pcAdd(fnew,true,pctdirs+pctfiles); end;
   end;

  if (rec.attr and (directory or volumeid)=0) then
  if HideHidden then
   begin
    if (rec.attr and hidden <> hidden) then
    begin inc(pctfiles); pcAdd(fnew,false,pctdirs+pctfiles); end;
   end
  else
   begin
    begin inc(pctfiles); pcAdd(fnew,false,pctdirs+pctfiles); end;
   end;

  if (rec.name='..')and(treec=1) then dec(pctdirs);{}
  if pctdirs<0 then pctdirs:=0;
  if pctfiles<0 then pctfiles:=0;

  if pctdirs+pctfiles>(MaxFiles-10) then
   begin
    if lang=rus then errormessage('ë´®Ë™Æ¨ ¨≠Æ£Æ ‰†©´Æ¢')
                else errormessage('More than '+strr(MaxFiles)+' files');
    break;
   end;
  findnext(rec);
 end;

for i:=pctdirs+pctfiles+1 to pctdirs+pctfiles+panelhi*Columns do
 begin
  pcdir^[i].fname:='        ';
  pcdir^[i].fext:='   ';
 end;

globalsort(left);
globalsort(right);

if path[length(path)]<>'\' then path:=path+'\';
if path=nd then for i:=1 to pcinsed do for j:=1 to pctdirs+pctfiles do
if pcins^[i].crc16=crc16(pcdir^[j].fname+'.'+pcdir^[j].fext) then pcdir^[j].mark:=true;
End;








{============================================================================}
Procedure TPanel.GetCurXY(var x,y:byte);
Var
    px,py,dx:byte;
    i,n:integer;
Begin
n:=tdirs+tfiles;
if n>from-1+panelhi*Columns then n:=from-1+panelhi*Columns;
px:=posx+1; py:=putfrom;
Case Columns of 1: dx:=13; 2: dx:=19; 3: dx:=13; End;
for i:=from to n do
 begin
  if i=Index then
   begin
    x:=px; y:=py; Exit;
   end;
  inc(py);
  if py>panelhi+putfrom-1 then begin py:=putfrom; inc(px,dx); end;
 end;
End;




{============================================================================}
procedure TPanel.pcPDF(fr:integer);
var px,py,py0,ph,paper,ink,pp,ii,iii,dx,ddx:byte;
    i,n:integer;
    s,name:string; e:string[3];
begin

if paneltype<>pcPanel then exit;{}

n:=pctdirs+pctfiles;
if n>fr-1+panelhi*Columns then n:=fr-1+panelhi*Columns;
px:=posx+1; py:=putfrom;
Case Columns of 1: dx:=13; 2: dx:=19; 3: dx:=13; End;
for i:=fr to n do
 begin
  if (px=21)or(px=61) then ddx:=1 else ddx:=0;
  name:=pcDir^[i].fname; if name[1]=' ' then delete(name,1,1);
  name:=name+space((dx+ddx-5)-length(name))+' '+pcDir^[i].fext;
  if i>pctdirs then name:=strlo(name);
  paper:=pal.bkNT; ink:=pal.txtNT;
  if i<=pctdirs then begin paper:=pal.bkDir; ink:=pal.txtDir; ii:=ink; end
  else
   begin
    e:=nospace(copy(name,(dx+ddx-3),3)); if e='' then e:='.';
    col(e,pcDir^[i].flength,paper,ink);
   end;
  pp:=paper; ii:=ink; iii:=ink;
  if pcdir^[i].mark then begin paper:=pal.bkST; ink:=pal.txtST; end;
  if focused and(i=from+f-1) then begin paper:=pal.bkCurNT; ink:=pal.txtCurNT; end;
  if focused and(i=from+f-1)and(pcdir^[i].mark) then begin paper:=pal.bkCurST; ink:=pal.txtCurST; end;
  if ((pcdir^[i].fattr and SysFile) <> 0) then name[1]:=upcase(name[1]);
  e:=' ';
  if ((pcdir^[i].fattr and ReadOnly)<> 0) then e:=#$B0;
  if ((pcdir^[i].fattr and Hidden)  <> 0) then e:=#$B1;
  if ((pcdir^[i].fattr and SysFile) <> 0) then e:=#$B2;
  if pcdir^[i].mark then e:=#251;
  name[(dx+ddx-4)]:=e[1];
  cmprint(paper,ink,px,py,name);

  s:=space(25);
  if Columns=1 then
   begin
    cmprint(paper,ink,px+13,py,s); cmprint(paper,pal.TxtRama,px+12,py,'≥');
   end;

  if ii=paper then ii:=ink;
  if focused and(i=from+f-1) then ii:=pal.txtCurNT;
  if focused and(i=from+f-1)and(pcdir^[i].mark) then
    begin ii:=iii; if ii=pal.bkCurST then ii:=pal.txtCurST; end;
  PrintSelf(paper,ii,px+(dx+ddx-5),py,1);

  inc(py);
  if py>panelhi+putfrom-1 then begin py:=putfrom; inc(px,dx); end;
 end;

for i:=n+1 to panelhi*Columns do
 begin
  if (px=21)or(px=61) then ddx:=1 else ddx:=0;
  name:=space(dx+ddx-1);
  cmprint(pal.bkNT,pal.txtNT,px,py,name);
  if Columns=1 then
   begin
    cmprint(pal.bkNT,pal.txtNT,px+13,py,space(25)); cmprint(pal.bkRama,pal.TxtRama,px+12,py,'≥');
   end;
  inc(py);
  if py>panelhi+putfrom-1 then begin py:=putfrom; inc(px,dx); end;
 end;

end;




{============================================================================}
Procedure TPanel.MDF;
Begin
 case PanelType of
  pcPanel: pcMDF(pcnd);
  trdPanel: trdMDFs(trdfile);
  fdiPanel: fdiMDFs(fdifile);
  sclPanel: sclMDFs(sclfile);
  tapPanel: tapMDFs(tapfile);
  fddPanel: fddMDFs(fddfile);
  zxzPanel: zxzMDFs(zxzfile);
  flpPanel: flpMDFs(flpDrive);
 end;
End;



{============================================================================}
Procedure TPanel.PDF;
Begin
 case PanelType of
  pcPanel: pcPDF(pcfrom);
  trdPanel: trdPDFs(trdfrom);
  fdiPanel: fdiPDFs(fdifrom);
  sclPanel: sclPDFs(sclfrom);
  tapPanel: tapPDFs(tapfrom);
  fddPanel: fddPDFs(fddfrom);
  zxzPanel: zxzPDFs(zxzfrom);
  flpPanel: flpPDFs(flpfrom);
 end;
End;



{============================================================================}
Procedure TPanel.Info(parts:string);
Var
    s:string[127]; r:string[40]; itemp,a,b,p,x,y,d:byte; m,n:word; i,k:integer;
    nm,stemp:string[50]; ml,byt,byt2:longint; rbyt:real;
Begin


                        {== í•™„È®© ™†‚†´Æ£ ==}
if (pos('c',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=12) then
 Begin
  Case PanelType of
   pcPanel: if TreeC=1 then s:=' '+pcnd+' ' else s:=' '+copy(pcnd,1,length(pcnd)-1)+' ';
   infPanel: if lang=rus then s:=' à≠‰Æ‡¨†Ê®Ô ' else s:=' Information ';
   trdPanel: s:={' TRD:'+}' '+nospaceLR(zxDisk.DiskLabel)+' ';
   fdiPanel: s:={' FDI:'+}' '+nospaceLR(zxDisk.DiskLabel)+' ';
   sclPanel: s:=' Hobeta98 ';
   tapPanel: s:=' Tape ';
   fddPanel: s:={' FDD:'+}' '+nospaceLR(zxDisk.DiskLabel)+' ';
   zxzPanel: s:=' '+nospaceLR(zxDisk.DiskLabel)+' ';
   flpPanel: s:={' TRD:'+}' '+nospaceLR(zxDisk.DiskLabel)+' ';
  End;
  if length(s)>29 then s:=copy(s,1,4)+'...'+copy(s,length(s)-22,23);
  if focused then begin p:=pal.bkNDactive; i:=pal.txtNDactive; end else begin p:=pal.bkNDpassive; i:=pal.txtNDpassive; end;
  {if TRDOS3 then cmprint(BkRama,TxtRama,lp.posx+2,lp.posy,'T3');{}
  x:=length(s)div 2; if length(s)>x*2 then inc(x); x:=posx+20-x;
  r:='ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ';
  if posx<>left then if clocked then
   begin
    r:='ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ';
    if x+length(s)>71 then
    begin d:=x+length(s)-71; s:=copy(s,1,4)+'...'+copy(s,8+d,30); end;
   end;
  cmprint(pal.BkRama,pal.TxtRama,posx+1,posy,r);
  cmprint(p,i,x,1,s);

  Case PanelType of
   trdPanel: cmprint(pal.BkRama,pal.TxtRama,posx+5,posy,'TRD');
   fdiPanel: cmprint(pal.BkRama,pal.TxtRama,posx+5,posy,'FDI');
   fddPanel: cmprint(pal.BkRama,pal.TxtRama,posx+5,posy,'FDD');
   flpPanel: cmprint(pal.BkRama,pal.TxtRama,posx+5,posy,'FLP '+flpDrive);
  End;

  if TRDOS3 then cmprint(pal.BkRama,pal.TxtRama,posx+2,1,'T3') else cmprint(pal.BkRama,pal.TxtRama,posx+2,1,'ÕÕ');
 End;


                        {=== Å•£„≠Æ™ Ø‡Æ™‡„‚™® ==}
if (pos('b',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=10) then
 Begin
  if (tdirs+tfiles-1)<=0 then m:=1 else m:=tdirs+tfiles-1;
  k:=((from+f-2)*(PanelHi-2))div(m);
  for a:=1 to PanelHi+1 do
   begin
    p:=pal.bkRama; i:=pal.txtRama;
    r:='∫';
    if focused then
     begin
      r:='±';
      if a=1 then         begin p:=pal.bkBP; i:=pal.txtBP; r:=''; end;
      if a=PanelHi+1 then begin p:=pal.bkBP; i:=pal.txtBP; r:=''; end;
      if a=k+2 then begin p:=pal.bkBP; i:=pal.txtBP; r:='˛'; end;
     end;
    cmprint(p,i,posx+39,posy+a,r);
   end;
 End;


if (pos('d',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=10) then
 Begin
  s:='';
  whatflopp(a,b);
  if a<>0 then s:=s+'A';
  if b<>0 then s:=s+'B';
  s:=s+getalldrivers;
  if DiskLine then cmprint(pal.bkDiskLineR,pal.txtDiskLineR,posx,panellong,'»[ ')
              else cmprint(pal.bkDiskLineR,pal.txtDiskLineR,posx,panellong,'»ÕÕÕ');
  d:=posx+3;
  if DiskLine then
  for x:=1 to length(s) do
   begin
    p:=pal.bkDiskLineNT; i:=pal.txtDiskLineNT;
    if s[x]=pcnd[1] then begin p:=pal.bkDiskLineST; i:=pal.txtDiskLineST; end;
    cmprint(p,i,d,panellong,s[x]);
    p:=pal.bkDiskLineNT; i:=pal.txtDiskLineNT;
    inc(d);
    if length(s)<17 then begin cmprint(p,i,d,panellong,' '); inc(d); end;
   end;
  if d>40 then a:=d-40 else a:=d;
  if DiskLine then cmprint(pal.bkDiskLineR,pal.txtDiskLineR,d-1,PanelLong,' ]');

  if not DiskLine then a:=4;
  cmprint(pal.bkRama,pal.txtRama,d+1,PanelLong,fill(39-a,'Õ'));
  cmprint(pal.bkRama,pal.txtRama,posx+39,PanelLong,'º');
 End;


                    {========== CURSOR NAME =========}
if (pos('n',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=10) then
 Begin
  Case PanelType of
   pcPanel:
      BEGIN
       m:=pcfrom+pcf-1; nm:=space(38);
       if (m>0)and(pctdirs+pctfiles>0) then
        if place=left then nm:=pcNameLine(lp,m) else nm:=pcNameLine(rp,m);
       m:=0; for n:=1 to pctdirs+pctfiles do if pcdir^[n].mark then inc(m);
       if (infolines<=1)and(m<>0) then else
       cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
       cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
       cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
      END;
   trdPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<'+space(36);
         if Index>1 then if place=left then nm:=trdNameLine(lp,Index) else nm:=trdNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;
      END;
   fdiPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<'+space(36);
         if Index>1 then if place=left then nm:=fdiNameLine(lp,Index) else nm:=fdiNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;
      END;
   fddPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<'+space(36);
         if Index>1 then if place=left then nm:=fddNameLine(lp,Index) else nm:=fddNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;
      END;
   tapPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<';
         if Index>1 then if place=left then nm:=tapNameLine(lp,Index) else nm:=tapNameLine(rp,Index);
         nm:=nm+space(38-length(nm));
         p:=pal.bkcurline; i:=pal.txtcurline; x:=posx+1; y:=putfrom+panelhi+1;
         cmprint(p,i,x,y,nm);{}
        end;
      END;
   sclPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<'+space(36);
         if Index>1 then if place=left then nm:=sclNameLine(lp,Index) else nm:=sclNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;
      END;
   zxzPanel:
      BEGIN
       if (infolines<3)and(Insed<>0) then else
        begin
         if place=left then nm:=zxzNameLine(lp,Index) else nm:=zxzNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;

       stemp:=space(38);
       if Index>1 then
        begin
         m:=trdDir^[Index].zxzPackSize;
         byt:=m; byt2:=trdDir^[Index].length; ml:=byt;
        end
       else
        begin
         byt:=0; byt2:=0;
         for n:=2 to zxztfiles do
          begin
           inc(byt,trdDir^[n].zxzPackSize);
           inc(byt2,trdDir^[n].length);
          end;
         ml:=byt;
        end;
       byt:=byt*100;
       byt:=byt div byt2;

       if lang=rus then stemp:='~`ìØ†™Æ¢†≠Æ:  ~`'+changechar(extnum(strr(ml)),' ',',')+
                               space(14-length(changechar(extnum(strr(ml)),' ',',')))+
                               '~`äÆ¨Ø‡.: ~`'+strr(100-byt)+'%'
                   else stemp:='~`Packed:  ~`'+changechar(extnum(strr(ml)),' ',',')+
                               space(17-length(changechar(extnum(strr(ml)),' ',',')))+
                               '~`Ratio:  ~`'+strr(100-byt)+'%';
       i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
       nm:=stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
       {}
       x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
       if infolines>1 then
        StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
       cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
      END;
   flpPanel:
      BEGIN
       if (infolines<=1)and(Insed<>0) then else
        begin
         nm:='<<'+space(36);
         if Index>1 then if place=left then nm:=flpNameLine(lp,Index) else nm:=flpNameLine(rp,Index);
         cmprint(pal.bkCurLine,pal.txtCurLine,posx+1,PutFrom+PanelHi+1,nm);{}
         cmPrint(pal.bkRama,pal.txtRama,posx,PutFrom+PanelHi+1,'∫');
         cmPrint(pal.bkRama,pal.txtRama,posx+39,PutFrom+PanelHi+1,'∫');
        end;
      END;
  End;
 End;


                       {=========== SELECTED =============}
if (pos('s',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=10) then
 Begin
  Case PanelType of
   pcPanel:
     BEGIN
      m:=0; byt:=0;
      for n:=1 to pctdirs+pctfiles do
       if pcdir^[n].mark then
       begin inc(m); if pcdir^[n].flength>=0 then inc(byt,pcdir^[n].flength); end;
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus
       then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+'~` °†©‚ Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,lang)
       else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+'~` bytes selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm)));
      if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  trdPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to trdtfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  fdiPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to fditfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  fddPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to fddtfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  tapPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to taptfiles do if trddir^[i].mark then
       begin inc(m); inc(byt,trddir^[i].length); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';

      if (lp.PanelType=tapPanel)and(rp.PanelType=tapPanel) then
      if lang=rus then stemp:='á†Ø®·® ≠• Æ‚¨•Á•≠Î' else stemp:='No items selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °†©‚ Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` bytes selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      if (lp.PanelType=tapPanel)and(rp.PanelType=tapPanel) then
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °†©‚ Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ß†Ø®·'+ewitems(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` bytes selected in ~`'+strr(m)+'~` item'+ewitems(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  sclPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to scltfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  zxzPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to zxztfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);

      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      Case InfoLines of
       1: y:=putfrom+panelhi+1;
       2: y:=putfrom+panelhi+1;
       3: y:=putfrom+panelhi+3;
      End;
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
      cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  flpPanel:
     BEGIN
      m:=0; byt:=0;
      for i:=2 to flptfiles do if trddir^[i].mark then
        begin inc(m); inc(byt,trddir^[i].totalsec); end;
      x:=posx+1; y:=putfrom+panelhi+2;
      if infolines<=1 then dec(y);
      if lang=rus then stemp:='î†©´Î ≠• Æ‚¨•Á•≠Î' else stemp:='No files selected';
      if m>0 then if lang=rus then stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` °´Æ™'+eb(byt,rus)+' Æ‚¨•Á•≠Æ ¢ ~`'+strr(m)+'~` ‰†©´'+ewfiles(m,rus)
                              else stemp:='~`'+changechar(extnum(strr(byt)),' ',',')+
                                          '~` block'+eb(byt,lang)+' selected in ~`'+strr(m)+'~` file'+ewfiles(m,lang);
      i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
      nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
      x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
      if (m=0)and(infolines=1) then else
      StatusLineColor(pal.bkSelectedNT,pal.txtSelectedNT,pal.bkSelectedST,pal.txtSelectedST,x,y,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y,'∫');
     END;
  End;
 End;

                       {=========== FREE =============}
if (pos('f',strlo(parts))<>0)or(pos('A',parts)<>0) then if (PanelType>=1)and(PanelType<=10) then
 Begin
  Case PanelType of
   pcPanel:
     BEGIN
      if infolines>2 then
       begin
        byt:=diskfree(ord(pcnd[1])-64); nm:=extnum(strr(byt));
        if byt>999999999 then nm:=extnum(strr(byt div 1000000))+'G';
        stemp:=changechar(nm,' ',',');
        if lang=rus
          then nm:='~`'+stemp+'~` °†©‚ ·¢Æ°Æ§≠Æ ≠† §®·™• ~`'
          else nm:='~`'+stemp+'~` bytes free on drive ~`';
        stemp:=nm+pcnd[1]+':~`';
        i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
        nm:=space(i)+stemp;
        nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
        x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
        StatusLineColor(pal.bkFreeLineNT,pal.txtFreeLineNT,pal.bkFreeLineST,pal.txtFreeLineST,x,y+1,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y+1,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y+1,'∫');
       end;
     END;
  trdPanel,fdiPanel,fddPanel,flpPanel:
     BEGIN
      if infolines>2 then
       begin
        byt:=zxdisk.free;
        stemp:=strr(byt);
        if lang=rus then nm:='~`'+stemp+'~` °´Æ™'+eb(byt,rus)+' ·¢Æ°Æ§≠Æ~`'
        else nm:='~`'+stemp+'~` block'+eb(byt,lang)+' free~`';
        stemp:=nm+'~`';
        i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
        nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
        x:=posx+1; if InfoLines<=1 then y:=PutFrom+PanelHi+1 else y:=PutFrom+PanelHi+2;
        StatusLineColor(pal.bkFreeLineNT,pal.txtFreeLineNT,pal.bkFreeLineST,pal.txtFreeLineST,x,y+1,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y+1,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y+1,'∫');
       end;
     END;
  sclPanel:
     BEGIN
      if infolines>2 then
       begin
        stemp:=strr(scltfiles-1);
        if lang=rus then nm:='Ç·•£Æ ~`'+stemp+'~` ‰†©´'+eb(vall(stemp),rus)+'~`'
                    else nm:='Total ~`'+stemp+'~` file'+eb(vall(stemp),eng)+'~`';
        stemp:=nm+'~`';
        i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
        nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
        StatusLineColor(pal.bkFreeLineNT,pal.txtFreeLineNT,pal.bkFreeLineST,pal.txtFreeLineST,x,y+1,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y+1,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y+1,'∫');
       end;
     END;
  tapPanel:
     BEGIN
      if infolines>2 then
       begin
        byt:=taptfiles-1; m:=0;
        for i:=2 to taptfiles do if trddir^[i].tapflag=0 then inc(m);
        stemp:=strr(byt-m);
        if (lp.PanelType=tapPanel)and(rp.PanelType=tapPanel) then stemp:=strr(byt);
        if lang=rus then nm:='Ç·•£Æ ~`'+stemp+'~` ‰†©´'+eb(vall(stemp),rus)+'~`'
                    else nm:='Total ~`'+stemp+'~` file'+eb(vall(stemp),eng)+'~`';
        if (lp.PanelType=tapPanel)and(rp.PanelType=tapPanel) then
        if lang=rus then nm:='Ç·•£Æ ~`'+stemp+'~` ß†Ø®·'+ei(vall(stemp),rus)+'~`'
                    else nm:='Total ~`'+stemp+'~` item'+eb(vall(stemp),eng)+'~`';
        stemp:=nm+'~`';
        i:=19-(length(without(stemp,'~`'))div 2); if i<0 then i:=0;
        nm:=space(i)+stemp; nm:=nm+space(abs(38-CClen(nm))); if CClen(nm)>38 then delete(nm,39+8,10);
        StatusLineColor(pal.bkFreeLineNT,pal.txtFreeLineNT,pal.bkFreeLineST,pal.txtFreeLineST,x,y+1,nm);{}
        cmPrint(pal.bkRama,pal.txtRama,posx,y+1,'∫'); cmPrint(pal.bkRama,pal.txtRama,posx+39,y+1,'∫');
       end;
     END;
  End;
 End;


if (pos('i',strlo(parts))<>0)or(pos('A',parts)<>0) then
 Begin
  Case lp.PanelType of
   pcPanel:  if rp.PanelType=infPanel then pcInfoPanel(left);
   trdPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   fdiPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   sclPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   tapPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   fddPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   zxzPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
   flpPanel: if rp.PanelType=infPanel then trdInfoPanel(left);
  End;
  Case rp.PanelType of
   pcPanel:  if lp.PanelType=infPanel then pcInfoPanel(right);
   trdPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   fdiPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   sclPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   tapPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   fddPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   zxzPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
   flpPanel: if lp.PanelType=infPanel then trdInfoPanel(right);
  End;
 End;

End;



{============================================================================}
Function  TPanel.GetTreeC(path:string):byte;
Begin
TreeC:=length(path)-length(without(path,'\'));
GetTreeC:=TreeC;
End;



{============================================================================}
Function  TPanel.Insed:word;
Var
   i,m:word;
Begin
m:=0;
Case PanelType of
 pcPanel:
   BEGIN
    for i:=1 to pctdirs+pctfiles do if pcDir^[i].mark then inc(m);
   END;
 trdPanel:
   BEGIN
    for i:=1 to trdtfiles do if trdDir^[i].mark then inc(m);
   END;
 fdiPanel:
   BEGIN
    for i:=1 to fditfiles do if trdDir^[i].mark then inc(m);
   END;
 sclPanel:
   BEGIN
    for i:=1 to scltfiles do if trdDir^[i].mark then inc(m);
   END;
 tapPanel:
   BEGIN
    for i:=1 to taptfiles do if trdDir^[i].mark then inc(m);
   END;
 fddPanel:
   BEGIN
    for i:=1 to fddtfiles do if trdDir^[i].mark then inc(m);
   END;
 zxzPanel:
   BEGIN
    for i:=1 to zxztfiles do if trdDir^[i].mark then inc(m);
   END;
 flpPanel:
   BEGIN
    for i:=1 to flptfiles do if trdDir^[i].mark then inc(m);
   END;
End;
Insed:=m;
End;



{============================================================================}
Procedure TPanel.Inside;
Begin
Case PanelType of
 pcPanel:
   BEGIN
     tdirs:=pctdirs;
     tfiles:=pctfiles;
     f:=pcf;
     from:=pcfrom;
   END;
 trdPanel:
   BEGIN
     tdirs:=0;
     tfiles:=trdtfiles;
     f:=trdf;
     from:=trdfrom;
   END;
 fdiPanel:
   BEGIN
     tdirs:=0;
     tfiles:=fditfiles;
     f:=fdif;
     from:=fdifrom;
   END;
 fddPanel:
   BEGIN
     tdirs:=0;
     tfiles:=fddtfiles;
     f:=fddf;
     from:=fddfrom;
   END;
 tapPanel:
   BEGIN
     tdirs:=0;
     tfiles:=taptfiles;
     f:=tapf;
     from:=tapfrom;
   END;
 sclPanel:
   BEGIN
     tdirs:=0;
     tfiles:=scltfiles;
     f:=sclf;
     from:=sclfrom;
   END;
 zxzPanel:
   BEGIN
     tdirs:=0;
     tfiles:=zxztfiles;
     f:=zxzf;
     from:=zxzfrom;
   END;
 flpPanel:
   BEGIN
     tdirs:=0;
     tfiles:=flptfiles;
     f:=flpf;
     from:=flpfrom;
   END;
End;
End;



{============================================================================}
Procedure TPanel.Outside;
Var PT:byte;
Begin
PT:=PanelType;
if PT=noPanel then PT:=LastPanelType;
if PT=infPanel then PT:=clLastPanelType;
Case PT of
 pcPanel:
   BEGIN
     pctdirs:=tdirs;
     pctfiles:=tfiles;
     pcf:=f;
     pcfrom:=from;
   END;
 trdPanel:
   BEGIN
     trdtfiles:=tfiles;
     trdf:=f;
     trdfrom:=from;
   END;
 fdiPanel:
   BEGIN
     fditfiles:=tfiles;
     fdif:=f;
     fdifrom:=from;
   END;
 fddPanel:
   BEGIN
     fddtfiles:=tfiles;
     fddf:=f;
     fddfrom:=from;
   END;
 tapPanel:
   BEGIN
     taptfiles:=tfiles;
     tapf:=f;
     tapfrom:=from;
   END;
 sclPanel:
   BEGIN
     scltfiles:=tfiles;
     sclf:=f;
     sclfrom:=from;
   END;
 zxzPanel:
   BEGIN
     zxztfiles:=tfiles;
     zxzf:=f;
     zxzfrom:=from;
   END;
 flpPanel:
   BEGIN
     flptfiles:=tfiles;
     flpf:=f;
     flpfrom:=from;
   END;
End;
End;



{============================================================================}
Function TPanel.Index:word;
Begin
 Index:=from+f-1;
End;





{============================================================================}
Function TPanel.TrueName(ind:word):string;
Var
    s:string;
Begin
{
if PanelType=pcPanel then
 BEGIN
{}
  if nospace(pcDir^[ind].fext)=''
    then s:=pcDir^[ind].fname
    else s:=pcDir^[ind].fname+'.'+pcDir^[ind].fext;
  if ind>pctdirs then s:=strlo(s) else s:=strhi(s);
{
 END
else
 BEGIN
  if Place=left then p:=lp else p:=rp;
  s:=trdDir^[ind].name+TRDOSe3(p,ind);
 END;
{}
TrueName:=s;
End;







{============================================================================}
Procedure TPanel.TrueCur;
Var
    fnd:boolean; st:string; i:integer;
Begin
fnd:=false;
 Case panelType of

  pcPanel:
   BEGIN
    for i:=1 to pctdirs+pctfiles do
     begin
      if nospace(pcdir^[i].fext)=''
        then st:=strlo(pcdir^[i].fname)
        else st:=strlo(pcdir^[i].fname+'.'+pcdir^[i].fext);
      {message('['+st+'] ['+nospace(strlo(pcnn)+']'));{}
      if nospaceLR(st)=nospaceLR(strlo(pcnn)) then begin fnd:=true; break; end;
     end;

    if fnd then
     begin
      pcf:=1; pcfrom:=1;
      while pcfrom+pcf-1<i do
       begin
        inc(pcf);
        if pcf>panelhi*columns then begin pcf:=panelhi*columns; inc(pcfrom); end;
       end;
     end;

    while pcfrom+pcf-1 > pctdirs+pctfiles do
     begin
      dec(pcfrom);
      if pcfrom<1 then begin pcfrom:=1; dec(pcf); end;
     end;
    if pcf<1 then pcf:=1;
   END;

  trdPanel:
   BEGIN
    if trdfrom+trdf-1<>1 then
     begin
      for i:=1 to trdtfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=trdnn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        trdf:=1; trdfrom:=1;
        while trdfrom+trdf-1<i do
         begin
          inc(trdf);
          if trdf>panelhi*Columns then begin trdf:=panelhi*Columns; inc(trdfrom); end;
         end;
       end;

      while trdfrom+trdf-1 > trdtfiles do
       begin
        dec(trdfrom);
        if trdfrom<1 then begin trdfrom:=1; dec(trdf); end;
       end;
      if trdf<1 then trdf:=1;
     end;
   END;

  fdiPanel:
   BEGIN
    if fdifrom+fdif-1<>1 then
     begin
      for i:=1 to fditfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=fdinn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        fdif:=1; fdifrom:=1;
        while fdifrom+fdif-1<i do
         begin
          inc(fdif);
          if fdif>panelhi*Columns then begin fdif:=panelhi*Columns; inc(fdifrom); end;
         end;
       end;

      while fdifrom+fdif-1 > fditfiles do
       begin
        dec(fdifrom);
        if fdifrom<1 then begin fdifrom:=1; dec(fdif); end;
       end;
      if fdif<1 then fdif:=1;
     end;
   END;

  sclPanel:
   BEGIN
    if sclfrom+sclf-1<>1 then
     begin
      for i:=1 to scltfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=sclnn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        sclf:=1; sclfrom:=1;
        while sclfrom+sclf-1<i do
         begin
          inc(sclf);
          if sclf>panelhi*Columns then begin sclf:=panelhi*Columns; inc(sclfrom); end;
         end;
       end;

      while sclfrom+sclf-1 > scltfiles do
       begin
        dec(sclfrom);
        if sclfrom<1 then begin sclfrom:=1; dec(sclf); end;
       end;
      if sclf<1 then sclf:=1;
     end;
   END;

  fddPanel:
   BEGIN
    if fddfrom+fddf-1<>1 then
     begin
      for i:=1 to fddtfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=fddnn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        fddf:=1; fddfrom:=1;
        while fddfrom+fddf-1<i do
         begin
          inc(fddf);
          if fddf>panelhi*Columns then begin fddf:=panelhi*Columns; inc(fddfrom); end;
         end;
       end;

      while fddfrom+fddf-1 > fddtfiles do
       begin
        dec(fddfrom);
        if fddfrom<1 then begin fddfrom:=1; dec(fddf); end;
       end;
      if fddf<1 then fddf:=1;
     end;
   END;

  zxzPanel:
   BEGIN
    if zxzfrom+zxzf-1<>1 then
     begin
      for i:=1 to zxztfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=zxznn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        zxzf:=1; zxzfrom:=1;
        while zxzfrom+zxzf-1<i do
         begin
          inc(zxzf);
          if zxzf>panelhi*Columns then begin zxzf:=panelhi*Columns; inc(zxzfrom); end;
         end;
       end;

      while zxzfrom+zxzf-1 > zxztfiles do
       begin
        dec(zxzfrom);
        if zxzfrom<1 then begin zxzfrom:=1; dec(zxzf); end;
       end;
      if zxzf<1 then zxzf:=1;
     end;
   END;

  flpPanel:
   BEGIN
    if flpfrom+flpf-1<>1 then
     begin
      for i:=1 to flptfiles do
       begin
        st:=trddir^[i].name+'.'+trddir^[i].typ;
        if st=flpnn then begin fnd:=true; break; end;
       end;

      if fnd then
       begin
        flpf:=1; flpfrom:=1;
        while flpfrom+flpf-1<i do
         begin
          inc(flpf);
          if flpf>panelhi*Columns then begin flpf:=panelhi*Columns; inc(flpfrom); end;
         end;
       end;

      while flpfrom+flpf-1 > flptfiles do
       begin
        dec(flpfrom);
        if flpfrom<1 then begin flpfrom:=1; dec(flpf); end;
       end;
      if flpf<1 then flpf:=1;
     end;
   END;


 End;
End;



{============================================================================}
Procedure TPanel.ShiftEnter;
Var
    stemp:string;
Begin
if (PanelType=trdPanel)or(PanelType=fdiPanel)or(PanelType=fddPanel)or
   (PanelType=sclPanel)or(PanelType=tapPanel) then
begin

 getprofile(startdir+'\sn.ini','Spectrum','Execute',stemp);
 if stemp='1' then{}
  BEGIN
   getprofile(startdir+'\sn.ini','Spectrum','ExecuteEmulator',stemp);
   Case PanelType of
    trdPanel: command:=stemp+' '+trdfile+' ';
    fdiPanel: command:=stemp+' '+fdifile+' ';
    fddPanel: command:=stemp+' '+fddfile+' ';
    sclPanel: command:=stemp+' '+sclfile+' ';
    tapPanel: command:=stemp+' '+tapfile+' ';
   End;
   DoExec(command,true);
  END;

end;


End;


{============================================================================}
Procedure TPanel.Enter;
Var
    stemp:string; i:word; a,b,c:byte;
Begin
if command<>'' then DoExec(command,true);
Case PanelType of
 pcPanel:
   BEGIN

    if isZXZIP(pcnd+TrueName(Index)) then
     begin
      PanelType:=zxzPanel;
      zxzFile:=pcnd+TrueName(Index);
      zxzMDFs(zxzfile);
      zxzfrom:=1; zxzf:=1; Inside;
      reInfo('cbdnsfi');
      zxzPDFs(zxzfrom);
      Exit;
     end;

    if (Index>tdirs)and(itHobeta(pcnd+pcnn,hobetainfo)) then
     begin
      scputwin(pal.bkdRama,pal.txtdRama,16,halfmaxy-4,65,halfmaxy-3+6);
      if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,#205' à≠‰Æ‡¨†Ê®Ô ')
                  else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,#205' Information ');
      if lang=rus then StatusLineColor(pal.bkdLabelST,pal.txtdLabelST,pal.bkdLabelNT,pal.txtdLabelNT,19,halfmaxy-2,
        'à¨Ô        í®Ø      ë‚†‡‚      Ñ´®≠†  Å´Æ™Æ¢')
                  else StatusLineColor(pal.bkdLabelST,pal.txtdLabelST,pal.bkdLabelNT,pal.txtdLabelNT,19,halfmaxy-2,
        'Name       Type     Start      Length Blocks');

      stemp:='~`'+hobetainfo.name+'   ';
      if TRDOS3 then stemp:=stemp+hobetainfo.typ+chr(lo(hobetainfo.start))+chr(hi(hobetainfo.start))
                else stemp:=stemp+'<'+hobetainfo.typ+'>';
      stemp:=stemp+
             space(11-length(changechar(extnum(strr(hobetainfo.start)),' ',',')))+
             changechar(extnum(strr(hobetainfo.start)),' ',',')+
             space(11-length(changechar(extnum(strr(hobetainfo.length)),' ',',')))+
             changechar(extnum(strr(hobetainfo.length)),' ',',')+
             '  ('+strr(hobetainfo.totalsec)+')~`';
      StatusLineColor(pal.bkdLabelST,pal.txtdLabelST,pal.bkdLabelNT,pal.txtdLabelNT,19,halfmaxy-1,
             stemp);

      colour(pal.bkdLabelNT,pal.txtdLabelNT);
      cbutton(pal.bkdButtonA,pal.txtdButtonA,pal.bkdButtonShadow,pal.txtdButtonShadow,36,halfmaxy+1,'    OK    ',true);

      rpause;
      restscr;
     end;


    if (Index>tdirs)and(isTRD(pcnd+TrueName(Index))) then
     begin
      PanelType:=trdPanel;
      trdFile:=pcnd+TrueName(Index);
      trdMDFs(trdfile);{}
      trdfrom:=1; trdf:=1; Inside;
      reInfo('cbdnsfi');
      trdPDFs(trdfrom);{}
      Exit;
     end;

    if place=left then
     BEGIN
      if (Index>tdirs)and(isFDI(lp,pcnd+TrueName(Index))) then
       begin
        PanelType:=fdiPanel;
        fdiFile:=pcnd+TrueName(Index);
        fdiMDFs(fdifile);
        fdifrom:=1; fdif:=1; Inside;
        reInfo('cbdnsfi');
        fdiPDFs(fdifrom);
        Exit;
       end;
     END
    ELSE
     BEGIN
      if (Index>tdirs)and(isFDI(rp,pcnd+TrueName(Index))) then
       begin
        PanelType:=fdiPanel;
        fdiFile:=pcnd+TrueName(Index);
        fdiMDFs(fdifile);
        fdifrom:=1; fdif:=1; Inside;
        reInfo('cbdnsfi');
        fdiPDFs(fdifrom);
        Exit;
       end;
     END;


    if (Index>tdirs)and(isTAP(pcnd+TrueName(Index))) then
     Begin
      PanelType:=tapPanel;
      tapFile:=pcnd+TrueName(Index);
      tapMDFs(tapfile);
      tapfrom:=1; tapf:=1; Inside;
      reInfo('cbdnsfi');
      tapPDFs(tapfrom);
      Exit;
     End;


    if (Index>tdirs)and(isSCL(pcnd+TrueName(Index))) then
     Begin
      PanelType:=sclPanel;
      sclFile:=pcnd+TrueName(Index);
      sclMDFs(sclfile);
      sclfrom:=1; sclf:=1; Inside;
      reInfo('cbdnsfi');
      sclPDFs(sclfrom);
      Exit;
     End;


    if (Index>tdirs)and(isFDD(pcnd+TrueName(Index))) then
     Begin
      PanelType:=fddPanel;
      fddFile:=pcnd+TrueName(Index);
      fddMDFs(fddfile);
      fddfrom:=1; fddf:=1; Inside;
      reInfo('cbdnsfi');
      fddPDFs(fddfrom);
      Exit;
     End;


    if (pcDir^[Index].fext='BAT')or(pcDir^[Index].fext='COM')or(pcDir^[Index].fext='EXE')
    then
     Begin
      command:=TrueName(Index);
      DoExec(command,true);
     End;

    if Index<=tdirs then
     begin
      if NoSpace(pcnn)='..' then
       begin
        Dec(TreeC);
        stemp:=ReverseStr(pcnd);
        pcnn:=copy(ReverseStr(Copy(stemp,2,pos('\',Copy(stemp,2,15)))),2,15);
        stemp:=reversestr(pcnd);
        stemp:=reversestr(copy(stemp,2,pos('\',copy(stemp,2,15))-1));
        stemp:=copy(pcnd,1,length(pcnd)-length(stemp)-1);
        if stemp[length(stemp)]<>'\' then stemp:=stemp+'\';
        pcMDF(stemp);
        TrueCur;
       end
      else
       begin
        inc(treec); pcfrom:=1; pcf:=1;
        stemp:=pcnd+pcnn+'\';
        pcMDF(stemp);
       end;
      Inside;
      Info('csi');{}
      pcPDF(pcfrom);{}
     end
    else
     begin
      stemp:=whatbyext(pcnd+pcnn,'ExecuteByExtention');
      CheckExt(stemp); ExecuteView(reBuildName(stemp,pcnd+pcnn));

      stemp:=whatbylen(strr(pcDir^[Index].flength),pcnd+pcnn,'ExecuteByLength',true);
      CheckExt(stemp); ExecuteView(reBuildName(stemp,pcnd+pcnn));
     end;
   END;
 trdPanel,fdiPanel,sclPanel,tapPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN

    if Index=1 then
     begin

      trdfile:=''; fdifile:=''; sclfile:=''; tapfile:=''; fddfile:='';{}

      for i:=1 to 257 do Begin trdIns^[i].crc16:=0; trdDir^[i].name[1]:=#0; end;
      if PanelType=tapPanel then CheckTapInsed;
      PanelType:=pcPanel;
      MDF;
      TrueCur;
      Inside;
      reInfo('A');{}
      rePDF;{}
      Exit;
     end;

    getprofile(startdir+'\sn.ini','Spectrum','Execute',stemp);
    if stemp='1' then
     BEGIN
      getprofile(startdir+'\sn.ini','Spectrum','ExecuteEmulator',stemp);
      a:=PanelType; b:=trdDir^[Index].taptyp; c:=trdDir^[Index].tapflag;
      if PanelType=tapPanel then if b=0 then if c=0 then
       begin
        Case PanelType of
         trdPanel: command:=stemp+' '+trdfile+' ';
         fdiPanel: command:=stemp+' '+fdifile+' ';
         fddPanel: command:=stemp+' '+fddfile+' ';
         sclPanel: command:=stemp+' '+sclfile+' ';
         tapPanel: command:=stemp+' '+tapfile+' ';
        End;
        command:=command+'"'+trdDir^[Index].name+'"';
        DoExec(command,true);
       end;

      if PanelType<>zxzPanel then if trdDir^[Index].typ='B' then
       begin
        Case PanelType of
         trdPanel: command:=stemp+' '+trdfile+' ';
         fdiPanel: command:=stemp+' '+fdifile+' ';
         fddPanel: command:=stemp+' '+fddfile+' ';
         sclPanel: command:=stemp+' '+sclfile+' ';
         tapPanel: command:=stemp+' '+tapfile+' ';
        End;
        command:=command+'"'+trdDir^[Index].name+'"';
        DoExec(command,true);
       end;

     END;
    if place=left then zxViewFile(lp) else zxViewFile(rp);
   END;
End;
End;




{============================================================================}
Procedure TPanel.CtrlPgUp;
Var
    stemp:string; i:word;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if TreeC>1 then
     Begin
      Dec(TreeC);
      stemp:=ReverseStr(pcnd);
      pcnn:=copy(ReverseStr(Copy(stemp,2,pos('\',Copy(stemp,2,15)))),2,15);
      stemp:=reversestr(pcnd);
      stemp:=reversestr(copy(stemp,2,pos('\',copy(stemp,2,15))-1));
      stemp:=copy(pcnd,1,length(pcnd)-length(stemp)-1);
      if stemp[length(stemp)]<>'\' then stemp:=stemp+'\';
      pcMDF(stemp);
      TrueCur;
      Inside;
      Info('csi');
      pcPDF(pcfrom);{}
     End;
   END;
 trdPanel,fdiPanel,sclPanel,tapPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN
      for i:=1 to 257 do Begin trdIns^[i].crc16:=0; trdDir^[i].name[1]:=#0; end;
      if PanelType=tapPanel then CheckTapInsed;
      PanelType:=pcPanel;
      reMDF;
      TrueCur;
      Inside;
      reInfo('cbdnsfi');{}
      rePDF;{}
   END;
End;
End;




{============================================================================}
Procedure TPanel.CtrlPgDn;
Var
    stemp:string;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if Index<=tdirs then
     begin
      if NoSpace(pcnn)='..' then
       begin
        Dec(TreeC);
        stemp:=ReverseStr(pcnd);
        pcnn:=copy(ReverseStr(Copy(stemp,2,pos('\',Copy(stemp,2,15)))),2,15);
        stemp:=reversestr(pcnd);
        stemp:=reversestr(copy(stemp,2,pos('\',copy(stemp,2,15))-1));
        stemp:=copy(pcnd,1,length(pcnd)-length(stemp)-1);
        if stemp[length(stemp)]<>'\' then stemp:=stemp+'\';
        pcMDF(stemp);
        TrueCur;
       end
      else
       begin
        inc(treec); pcfrom:=1; pcf:=1;
        pcnd:=pcnd+pcnn+'\';
        pcMDF(pcnd);
       end;
     end;
    Inside;
    Info('csi');
    pcPDF(pcfrom);{}
   END;
End;
End;




{============================================================================}
Procedure TPanel.AltF1F2(ps:byte);
Var
     t:word; stemp:string; sr:searchrec;
Label fin;
Begin
 CurOff; CancelSB;
 w_twosided:=false;
 if ps=left then stemp:=ChooseDrive(ps,DiskMenuType,lang,lp.pcnd)
            else stemp:=ChooseDrive(ps,DiskMenuType,lang,rp.pcnd);
 w_twosided:=true;

 if stemp<>'0' then
  begin

  if ((UpCase(stemp[1])='A')or(UpCase(stemp[1])='B')) then
  BEGIN
   {
   findfirst(stemp[1]+':\*.*',anyfile,sr);
   if doserror=162 then
   {}
   if isFLP(stemp[1]) then
    Begin
     if ps=left then
      begin
       if (lp.pcnd[1]='A')or(lp.pcnd[1]='B') then
        Begin
         ChDir('C:'); lp.pcnd:=CurentDir;
         if lp.pcnd[length(lp.pcnd)]<>'\' then lp.pcnd:=lp.pcnd+'\';
        End;
       if (lp.PanelType=noPanel)or(lp.PanelType=infPanel) then begin lp.PanelType:=flpPanel; lp.Build('012'); end;
       lp.PanelType:=flpPanel;
       lp.flpDrive:=UpCase(stemp[1]);
       lp.flpMDFs(lp.flpDrive);
       lp.flpfrom:=1; lp.flpf:=1; lp.Inside;
       reInfo('cbdnsfi');
       lp.flpPDFs(lp.flpfrom);
       Exit;
      end
     else
      begin
       if (rp.pcnd[1]='A')or(rp.pcnd[1]='B') then
        Begin
         ChDir('C:'); rp.pcnd:=CurentDir;
         if rp.pcnd[length(rp.pcnd)]<>'\' then rp.pcnd:=rp.pcnd+'\';
        End;
       if (rp.PanelType=noPanel)or(rp.PanelType=infPanel) then begin rp.PanelType:=flpPanel; rp.Build('012'); end;
       rp.PanelType:=flpPanel;
       rp.flpDrive:=UpCase(stemp[1]);
       rp.flpMDFs(rp.flpDrive);
       rp.flpfrom:=1; rp.flpf:=1; rp.Inside;
       reInfo('cbdnsfi');
       rp.flpPDFs(rp.flpfrom);
       Exit;
      end;
    End;
  END;
{}
   if CheckDrv(stemp[1])=0 then
     begin
      Case ps of
       Left:
         BEGIN
          if lp.PanelType<>pcPanel then
           Begin
            lp.PanelType:=pcPanel;
            {if (lp.PanelType<1)or(lp.PanelType>10) then {}
            lp.Build('012');
           End;
          {$I-} ChDir(stemp+':'); {$I+}
          if ioresult<>0 then
           begin
            if lang=rus
              then errormessage('ì·‚‡Æ©·‚¢Æ '+stemp+': ≠• £Æ‚Æ¢Æ')
              else errormessage('Drive '+stemp+': not ready');
           end
          else
           begin
            lp.pcnd:=curentdir;
            if lp.pcnd[length(lp.pcnd)]<>'\' then lp.pcnd:=lp.pcnd+'\';
            lp.pcf:=1; lp.pcfrom:=1; lp.TreeC:=1;
            for t:=1 to MaxFiles do begin lp.pcdir^[t].mark:=false; end;
            lp.pcMDF(lp.pcnd);
            lp.Inside;
            lp.Info('cbdnsfi');
            lp.pcPDF(lp.pcfrom);
           end;
         END;
       Right:
         BEGIN
          if rp.PanelType<>pcPanel then
           begin
            rp.PanelType:=pcPanel;
            {if (rp.PanelType<1)or(rp.PanelType>10) then{}
            rp.Build('012');
           end;
          {$I-} ChDir(stemp+':'); {$I+}
          if ioresult<>0 then
           begin
            if lang=rus
              then errormessage('ì·‚‡Æ©·‚¢Æ '+stemp+': ≠• £Æ‚Æ¢Æ')
              else errormessage('Drive '+stemp+': not ready');
           end
          else
           begin
            rp.pcnd:=curentdir;
            if rp.pcnd[length(rp.pcnd)]<>'\' then rp.pcnd:=rp.pcnd+'\';
            rp.pcf:=1; rp.pcfrom:=1; rp.TreeC:=1;
            for t:=1 to MaxFiles do begin rp.pcdir^[t].mark:=false; end;
            rp.pcMDF(rp.pcnd);
            rp.Inside;
            rp.Info('cbdnsfi');
            rp.pcPDF(rp.pcfrom);
           end;
         END;
      End;
     end
    else
     begin
            if lang=rus
              then errormessage('ì·‚‡Æ©·‚¢Æ '+stemp+': ≠• £Æ‚Æ¢Æ')
              else errormessage('Drive '+stemp+': not ready');
     end;
  end;
fin:
End;



{============================================================================}
Procedure TPanel.CtrlLeftRightDoIt(stemp:char);
Var
    btemp:byte; t:word;
begin
  {$I-} ChDir(stemp+':'); {$I+}
  if ioresult<>0 then
   begin
    if lang=rus
      then errormessage('ì·‚‡Æ©·‚¢Æ '+stemp+': ≠• £Æ‚Æ¢Æ')
      else errormessage('Drive '+stemp+': not ready');
   end
  else
   begin
    pcnd:=curentdir;
    if pcnd[length(pcnd)]<>'\' then pcnd:=pcnd+'\';
    pcf:=1; pcfrom:=1; TreeC:=1;
    for t:=1 to MaxFiles do begin pcdir^[t].mark:=false; end;
    pcMDF(pcnd);
    Inside;
    Info('cbdnsfi');
    pcPDF(pcfrom);
   end;
end;



{============================================================================}
Procedure TPanel.CtrlLeft;
Var
    stemp:string[27]; btemp:byte; t:word;
Begin
if (paneltype=pcPanel) then
 begin
  stemp:=getalldrivers;
  for btemp:=1 to length(stemp) do if stemp[btemp]=pcnd[1] then break;
  dec(btemp); if btemp<1 then btemp:=length(stemp);
  CtrlLeftRightDoIt(stemp[btemp]);
 end;
End;



{============================================================================}
Procedure TPanel.CtrlRight;
Var
    stemp:string[27]; btemp:byte; t:word;
Begin
if (paneltype=pcPanel) then
 begin
  stemp:=getalldrivers;
  for btemp:=1 to length(stemp) do if stemp[btemp]=pcnd[1] then break;
  inc(btemp); if btemp>length(stemp) then btemp:=1;
  CtrlLeftRightDoIt(stemp[btemp]);
 end;
End;



{============================================================================}
Procedure TPanel.Insert;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if pcDir^[Index].fname<>' ..' then pcDir^[Index].mark:=not pcDir^[Index].mark;
    inc(f);
   END;

 trdPanel,fdiPanel,sclPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN
    if from+f-1>1 then
      if (ord(trddir^[from+f-1].name[1])<>1)and(ord(trddir^[from+f-1].name[1])<>0) then
    trddir^[from+f-1].mark:=not trddir^[from+f-1].mark;
    inc(f);
   END;
 tapPanel:
   BEGIN
    if from+f-1>1 then
    if PanelTypeOf(oFocus)=tapPanel then
     begin
       trddir^[from+f-1].mark:=not trddir^[from+f-1].mark;
     end
    else
     begin
      if trddir^[from+f-1].tapflag<>0 then
       trddir^[from+f-1].mark:=not trddir^[from+f-1].mark;
     end;
    inc(f);
   END;

End;
Info('si')
End;




{============================================================================}
Procedure TPanel.Star(ctrled:boolean);
Var
    b,i:word;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if Ctrled then b:=1 else b:=pctdirs+1;
    for i:=b to pctdirs+pctfiles do if pcDir^[i].fname<>' ..' then pcDir^[i].mark:=not pcDir^[i].mark;
   END;
 trdPanel,fdiPanel,sclPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN
    for i:=2 to tfiles do if (ord(trddir^[i].name[1])<>1)and(ord(trddir^[i].name[1])<>0) then
     trddir^[i].mark:=not trddir^[i].mark;
   END;
 tapPanel:
   BEGIN
    for i:=2 to taptfiles do
     begin
      if PanelTypeOf(oFocus)=tapPanel then
       begin
         trddir^[i].mark:=not trddir^[i].mark;
       end
      else
       begin
        if trddir^[i].tapflag<>0 then
         trddir^[i].mark:=not trddir^[i].mark;
       end;
     end;
   END;
End;
Info('si');
End;





{============================================================================}
Procedure TPanel.Plus(ctrled:boolean);
Var
    a,b,i:word; s,stemp:string[12];
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if Ctrled then
     begin a:=1; b:=pctdirs; s:='*.*'; end
    else
     begin
      a:=pctdirs+1; b:=pctdirs+pctfiles;
      if lang=rus then stemp:=' ÇÎ°Æp ' else stemp:=' Select ';
      plusmask:=nospace(GetWildMask(stemp,plusmask));
      if scanf_esc then exit;
      s:=plusmask;
     end;
    for i:=a to b do if pcDir^[i].fname<>' ..' then
     Begin
      if nospace(pcdir^[i].fext)=''
        then stemp:=nospace(pcdir^[i].fname+'.!!!')
        else stemp:=nospace(pcdir^[i].fname+'.'+pcdir^[i].fext);
      if wild(stemp,s,true) then pcDir^[i].mark:=true;
     End;
   END;
 trdPanel,fdiPanel,sclPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN
    if lang=rus then stemp:=' ÇÎ°Æp ' else stemp:=' Select ';
    plusmask:=nospaceLR(GetWildMask(stemp,plusmask));
    if scanf_esc then exit;
    for i:=2 to tfiles do if (ord(trddir^[i].name[1])<>1)and(ord(trddir^[i].name[1])<>0) then
     begin
      stemp:=nospaceLR(trddir^[i].name)+'.'+trddir^[i].typ;
      if TRDOS3 then stemp:=stemp+chr(lo(trddir^[i].start))+chr(hi(trddir^[i].start));
      if wild(stemp,plusmask,false) then trddir^[i].mark:=true;
     end;
   END;
 tapPanel:
   BEGIN
    for i:=2 to taptfiles do
     begin
      if PanelTypeOf(oFocus)=tapPanel then
       begin
         trddir^[i].mark:=true;
       end
      else
       begin
        if trddir^[i].tapflag<>0 then
         trddir^[i].mark:=true;
       end;
     end;
   END;
End;
Info('si');
End;





{============================================================================}
Procedure TPanel.Minus(ctrled:boolean);
Var
    a,b,i:word; s,stemp:string[12];
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if Ctrled then
     begin a:=1; b:=pctdirs; s:='*.*'; end
    else
     begin
      a:=pctdirs+1; b:=pctdirs+pctfiles;
      if lang=rus then stemp:=' é‚¨•≠† ' else stemp:=' Cancel ';
      minusmask:=nospace(GetWildMask(stemp,minusmask));
      if scanf_esc then exit;
      s:=plusmask;
     end;
    for i:=a to b do if pcDir^[i].fname<>' ..' then
     Begin
      if nospace(pcdir^[i].fext)=''
        then stemp:=nospace(pcdir^[i].fname+'.!!!')
        else stemp:=nospace(pcdir^[i].fname+'.'+pcdir^[i].fext);
      if wild(stemp,minusmask,true) then pcDir^[i].mark:=false;
     End;
   END;
 trdPanel,fdiPanel,sclPanel,fddPanel,zxzPanel,flpPanel:
   BEGIN
    if lang=rus then stemp:=' é‚¨•≠† ' else stemp:=' Cancel ';
    minusmask:=nospaceLR(GetWildMask(stemp,minusmask));
    if scanf_esc then exit;
    for i:=2 to tfiles do if (ord(trddir^[i].name[1])<>1)and(ord(trddir^[i].name[1])<>0) then
     begin
      stemp:=nospaceLR(trddir^[i].name)+'.'+trddir^[i].typ;
      if TRDOS3 then stemp:=stemp+chr(lo(trddir^[i].start))+chr(hi(trddir^[i].start));
      if wild(stemp,minusmask,false) then trddir^[i].mark:=false;
     end;
   END;
 tapPanel:
   BEGIN
    for i:=2 to taptfiles do
     begin
      if PanelTypeOf(oFocus)=tapPanel then
       begin
         trddir^[i].mark:=false;
       end
      else
       begin
        if trddir^[i].tapflag<>0 then
         trddir^[i].mark:=false;
       end;
     end;
   END;
End;
Info('si');
End;





{============================================================================}
Function TPanel.FirstMarked:word;
Var
    i:word; fnd:boolean;
Begin
fnd:=false;
Case PanelType of
 pcPanel:
   BEGIN
    for i:=1 to pctdirs+pctfiles do if pcDir^[i].mark then begin fnd:=true; break; end;
   END;
 trdPanel:
   BEGIN
    for i:=1 to trdtfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 fdiPanel:
   BEGIN
    for i:=1 to fditfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 sclPanel:
   BEGIN
    for i:=1 to scltfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 tapPanel:
   BEGIN
    for i:=1 to taptfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 fddPanel:
   BEGIN
    for i:=1 to fddtfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 zxzPanel:
   BEGIN
    for i:=1 to zxztfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
 flpPanel:
   BEGIN
    for i:=1 to flptfiles do if trdDir^[i].mark then begin fnd:=true; break; end;
   END;
End;
if fnd then FirstMarked:=i else FirstMarked:=0;
End;






{============================================================================}
Procedure TPanel.Del;
Begin
if PanelType=pcPanel then pcF8 else if place=left then snEraser(lp) else snEraser(rp);
End;



{============================================================================}
Procedure TPanel.fCopy;
Var
    i:word; n,s:string; was:longint;
Begin
if (PanelTypeOf(Focus)=pcPanel)and(PanelTypeOf(oFocus)=pcPanel)
 then pc2pc(_F5)
 else snCopier(_F5,PanelTypeOf(Focus),PanelTypeOf(oFocus));
End;



{============================================================================}
Procedure TPanel.fMove;
Var
    i:word; n,s:string;
    skip:boolean;
    TargetPath:string;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    Case PanelTypeOf(oFocus) of
     pcPanel: pc2pc(_F6);
     trdPanel,fdiPanel,fddPanel,tapPanel,sclPanel,flpPanel:
      begin
       snCopier(_F6,PanelTypeOf(Focus),PanelTypeOf(oFocus));
      end;
    End;
   END;
 trdPanel: trdRename;
 fdiPanel: fdiRename;
 fddPanel: fddRename;
 tapPanel: tapRename;
 sclPanel: sclRename;
 flpPanel: flpRename(flpDrive);
End;

End;





{============================================================================}
Procedure TPanel.Rename;
Var
    i:word; n,s:string;
    skip:boolean;
    TargetPath:string;
Begin
Case PanelType of
 pcPanel: pcRename;
{
   BEGIN
    Case PanelTypeOf(oFocus) of
     pcPanel: pcRename;
    End;
   END;
{}
 trdPanel: trdRename;
 fdiPanel: fdiRename;
 fddPanel: fddRename;
 tapPanel: tapRename;
 sclPanel: sclRename;
 flpPanel: flpRename(flpDrive);
End;

End;





{============================================================================}
Function TPanel.View(sys:boolean):longint;
Var
    i:word; total,size:longint; UserOut:boolean; path:string;
Begin
UserOut:=false; total:=0;
if PanelType=pcPanel then
 BEGIN
  if not sys then
   begin
    if Index>TDirs then
     begin

      if InternalView or AltF3Pressed then
       begin
        intView(pcnd+TrueName(Index));
        GlobalReDraw;
       end
       else
      {}
      pcViewFile(pcnd+TrueName(Index));{}
      Exit;
     end;
   end;

  if Insed=0 then
   begin
    path:=TrueName(Index);
    if nospace(path)='..' then path:=pcnd else path:=pcnd+path;
    if DirSize(path,pcDir^[Index].priory,size,UserOut,sys) then
      if sys then inc(total,size) else pcDir^[Index].flength:=size;
   end;
  for i:=1 to pctdirs+pctfiles do if pcDir^[i].mark then
   begin
    if sys then if UserOut then break;
      if DirSize(pcnd+TrueName(i),pcDir^[i].priory,size,UserOut,sys) then
      if sys then inc(total,size) else pcDir^[i].flength:=size;
   end;
  View:=total;
  reInfo('s');
 END
else
 BEGIN
  if place=left then zxViewFile(lp) else zxViewFile(rp);
 END;
End;




{============================================================================}
Procedure TPanel.Edit;
Begin
Case PanelType of
 pcPanel:
   BEGIN
    if Index>TDirs then
     begin
      pcEditFile(pcnd+TrueName(Index));
      Exit;
     end;
   END;
 trdPanel,fdiPanel,fddPanel,flpPanel:
   BEGIN
    if place=left then zxEditParam(lp,Index) else zxEditParam(rp,Index);
   END;
 zxzPanel:
   BEGIN
    if place=left then zxzExtract(lp,rp) else zxzExtract(rp,lp);
   END;
End;
End;




{============================================================================}
Procedure TPanel.FileAttrs;
Var
    kb:word;
    n:byte;
Begin
Case PanelType of
 pcPanel: pcAltF;
End;
End;




{============================================================================}
Procedure TPanel.AltNumber(n:byte);
Var
    stemp:string;
Begin
getprofile(startdir+'\sn.ini','FastCatalog','Alt'+strr(n-119),stemp);
if nospace(stemp)<>'' then
 begin
  PanelType:=pcPanel;
  pcnd:=stemp;
  pcfrom:=1; pcf:=1;
  pcMDF(pcnd);
  Inside;
  Info('cdsfi');
  pcPDF(pcfrom);
 end;
End;



{============================================================================}
Procedure TPanel.pcJoinFiles;
type tbuf=array[1..2] of byte;
var
    i,c:word;
    s:string;
    fs,fd:file;
    buf:^tbuf;
    nw,nr:word;
begin
c:=0; for i:=pctdirs+1 to pctdirs+pctfiles do if pcdir^[i].mark then inc(c);
if c<2 then exit;
for i:=1 to pctdirs do if pcdir^[i].mark then pcdir^[i].mark:=false;
pcPDF(pcfrom); reInfo('s');

 CancelSB;
 colour(pal.bkdRama,pal.txtdRama);
 scputwin(pal.bkdRama,pal.txtdRama,24,halfmaxy-3,57,halfmaxy+2);
 if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-3,' C™´•®¢†≠®• ‰†©´Æ¢')
 else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-3,' Join files ');

 if lang=rus then s:='C™´•®‚Ï ~`'+strr(c)+'~` ‰†©´'+efiles(c,rus)+' ¢ ‰†©´'
             else s:='Join ~`'+strr(c)+'~` file'+efiles(c,lang)+' to file';
 StatusLineColor(pal.bkdLabelST,pal.txtdLabelST,pal.bkdLabelNT,pal.txtdLabelNT,41-(length(without(s,'~`'))div 2),halfmaxy-1,s);

 printself(pal.bkdInputNT,pal.txtdInputNT,35,halfmaxy+0,12);
 colour(pal.bkdInputNT,pal.txtdInputNT);
 curon;
 s:=scanf(35,halfmaxy+0,'',12,12,1);
 curoff;
 restscr;
 putcmdline;
 if scanf_esc then exit;

 if nospace(s)<>'' then
  begin
   s:=getof(s,_name)+getof(s,_ext);
   getmem(buf,32768);
   {$I-}
   assign(fd,pcnd+s); rewrite(fd,1);
   for i:=pctdirs+1 to pctdirs+pctfiles do if pcdir^[i].mark then
    begin
     s:=pcnd+TrueName(i);
     assign(fs,s); reset(fs,1);
     repeat
      blockread(fs,buf^,32768,nr);
      blockwrite(fd,buf^,nr,nw);
     until (NR=0)or(NW<>NR);
     close(fs);
     pcdir^[i].mark:=false;
    end;
   freemem(buf,32768);
   close(fd);
   {$I+}
   if ioresult<>0 then;
  end;
reMDF;
reTrueCur;
reInside;
rePDF;
reInfo('cbdnsfi');
end;







{============================================================================}
Procedure TPanel.Navigate;
Var
    kk,kb:word; k:char; n:byte; stemp:string[20]; s:string;
Label LOOP, Cont, Cont2;
Begin
reInfo('cbdnsfi');
rePDF;
LOOP:

Inside;
cStatusBar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,sBar[lang,PanelType]);
PutCmdLine;
if Moused then MouseOn; {showcur;{}

{
Repeat
if Ctrl then
            begin
             cmprint(clcolour div 16,clcolour-(clcolour div 16)*16,72,1,
             copy(curdate,1,6)+copy(curdate,9,2));
            end;
if LShift or RShift then
            begin
             cmprint(clcolour div 16,clcolour-(clcolour div 16)*16,72,1,
             changechar(extnum(strr(memavail)),' ',',')+' ');
            end;
Until KeyPressed;
{}
{
repeat
if mem[$40:$18]=128 then
 Begin
  asm
   mov ah,5
   mov cx,_Ins
   int 16h
  end;
  delay(125);
  break;
 End;
until keypressed;
{}
Cont:
kb:=KeyCode;{}

Cont2:
{case kb of{}
if kb=_AltZ then    begin message('lp: '+lp.sclfile); message('rp: '+ rp.sclfile); end;

if (kb=kbd.sn_kb1_TAB)or(kb=kbd.sn_kb2_TAB) then
                    begin snKernelExitCode:=9; Exit; end;
if kb=_CtrlEnd then begin snKernelExitCode:=9; Exit; end;

if (kb=kbd.sn_kb1_EXIT)or(kb=kbd.sn_kb2_EXIT) then
                    snDone(false);
if kb=_Esc then     EscPressed;

if (kb=kbd.sn_kb1_SETUP)or(kb=kbd.sn_kb2_SETUP) then
                    begin
                     curoff;
                     if Setup then
                      begin
                       sp1:=lp.pcnd; sp2:=rp.pcnd;
                       snKernelExitCode:=Focus;
                       snDone(true);
                       snInit(true);
                       lp.pcnd:=sp1; rp.pcnd:=sp2;
                       GlobalRedraw;{}
                       Focus:=snKernelExitCode;
                       Exit;
                      end;
                    end;

if (kb=kbd.sn_kb1_CLEAN)or(kb=kbd.sn_kb2_CLEAN) then
                    if place=left then AltCPressed(lp) else AltCPressed(rp);
if (kb=kbd.sn_kb1_PACK)or(kb=kbd.sn_kb2_PACK) then
                    if place=left then AltPPressed(lp) else AltPPressed(rp);
if (kb=kbd.sn_kb1_HHAR)or(kb=kbd.sn_kb2_HHAR) then
                    if place=left then AltRPressed(lp) else AltRPressed(rp);
if (kb=kbd.sn_kb1_LIST)or(kb=kbd.sn_kb2_LIST) then
                    if place=left then AltLPressed(lp) else AltLPressed(rp);
if (kb=kbd.sn_kb1_HOBS)or(kb=kbd.sn_kb2_HOBS) then
                    if place=left then pcAltH(lp) else pcAltH(rp);

if (kb=kbd.sn_kb1_CHBACK)or(kb=kbd.sn_kb2_CHBACK) then
                    begin
                     dec(HistoryIndex);
                     if HistoryIndex<1 then HistoryIndex:=1{HistoryTotal{};
                     command:=nospaceLR(History[HistoryIndex]);
                     CommandXFrom:=255; CommandXPos:=255;
                    end;
if (kb=kbd.sn_kb1_CHFORW)or(kb=kbd.sn_kb2_CHFORW) then
                    begin
                     inc(HistoryIndex);
                     if HistoryIndex>HistoryTotal then begin HistoryIndex:=HistoryTotal+1; command:=''; end else
                     command:=nospaceLR(History[HistoryIndex]);
                    end;

if (kb=kbd.sn_kb1_DESCRIP)or(kb=kbd.sn_kb2_DESCRIP) then
                    if place=left then CtrlKPressed(lp) else CtrlKPressed(rp);
if (kb=kbd.sn_kb1_ASCIITAB)or(kb=kbd.sn_kb2_ASCIITAB) then
                    begin CtrlBPressed(length(pcnd),gmaxy-15); Inc(CommandXPos); end;
if (kb=kbd.sn_kb1_JOIN)or(kb=kbd.sn_kb2_JOIN) then
                    pcJoinFiles;
if (kb=kbd.sn_kb1_SAVEND)or(kb=kbd.sn_kb2_SAVEND) then
                    AltPlusPressed;
if (kb=_Alt1)or(kb=_Alt2)or(kb=_Alt3)or(kb=_Alt4)or(kb=_Alt5)or
   (kb=_Alt6)or(kb=_Alt7)or(kb=_Alt8)or(kb=_Alt9)or(kb=_Alt0) then AltNumber(hi(kb));

if (kb=kbd.sn_kb1_FATTRS)or(kb=kbd.sn_kb2_FATTRS) then
                    FileAttrs;

if (kb=kbd.sn_kb1_TRDOS3)or(kb=kbd.sn_kb2_TRDOS3) then
                    Begin TRDOS3:=not TRDOS3; rePDF; reInfo('c'); End;
{}
if kb= _AltM then   errormessage('Free avail memory: '+strr(memavail));
if kb= _AltV then
                    Begin
                     getprofile(startdir+'\sn.ini','System','InternalView',s);
                     if s='1' then
                      begin
                       writeprofile(startdir+'\sn.ini','System','InternalView','0');
                       if LANG=rus then s:='Ç·‚‡Æ•≠≠Î© Ø‡Æ·¨Æ‚‡ ¢Î™´ÓÁ•≠'
                                   else s:='Internal viewer disabled';
                       InternalView:=false;
                       errormessage(s);
                      end
                     else
                      begin
                       writeprofile(startdir+'\sn.ini','System','InternalView','1');
                       if LANG=rus then s:='Ç·‚‡Æ•≠≠Î© Ø‡Æ·¨Æ‚‡ ¢™´ÓÁ•≠'
                                   else s:='Internal viewer enabled';
                       InternalView:=true;
                       errormessage(s);
                      end;
                    End;
{}
if (kb=kbd.sn_kb1_ABOUT)or(kb=kbd.sn_kb2_ABOUT) then     About;

if (kb=kbd.sn_kb1_USERMENU)or(kb=kbd.sn_kb2_USERMENU) then
                    CallUserMenu;

if (kb=kbd.sn_kb1_APACK)or(kb=kbd.sn_kb2_APACK) then
                    if place=left then snPacker(lp) else snPacker(rp);
if (kb=kbd.sn_kb1_AUNPACK)or(kb=kbd.sn_kb2_AUNPACK) then
                    if place=left then if isZXZIP(pcnd+pcnn) then zxzExtract(lp,rp) else
                                  else if isZXZIP(pcnd+pcnn) then zxzExtract(rp,lp);

if (kb=kbd.sn_kb1_LPANEL)or(kb=kbd.sn_kb2_LPANEL) then
                    AltF1F2(left);
if (kb=kbd.sn_kb1_RPANEL)or(kb=kbd.sn_kb2_RPANEL) then
                    AltF1F2(right);
if kb= _CtrlHome then AltF1F2(focus);
if kb= _CtrlLeft then if DiskLine then CtrlLeft;
if kb= _CtrlRight then if DiskLine then CtrlRight;
if kb= _CtrlBkSlash then
          Begin
           if PanelType=pcPanel then
            BEGIN
             if TreeC>1 then pcnn:=copy(pcnd,4,pos('\',copy(pcnd,4,255))-1);
             pcnd:=copy(pcnd,1,3); reMDF;
             TrueCur; Inside; reInfo('cdsfi');
            END;
          End;

if (kb=kbd.sn_kb1_INSERT)or(kb=kbd.sn_kb2_INSERT) then
                    Insert;{}
if kb=  PadStar then Star(false);
if kb=  PadPlus then Plus(false);
if kb=  PadMinus then Minus(false);
if kb=  CtrlPadStar then Star(true);
if kb=  CtrlPadPlus then Plus(true);
if kb=  CtrlPadMinus then Minus(true);

if kb= _CtrlBkSp then   if bkspupdir then CtrlPgUp;
if kb= _BkSp     then   if bkspupdir then if nospace(command)='' then CtrlPgUp;


if (kb=kbd.sn_kb1_SBYNAME)or(kb=kbd.sn_kb2_SBYNAME) then
                     Begin SortType:=NameType; GlobalSort(255); TrueCur; Inside; rePDF; End;
if (kb=kbd.sn_kb1_SBYEXT)or(kb=kbd.sn_kb2_SBYEXT) then
                     Begin SortType:=ExtType; GlobalSort(255); TrueCur; Inside; rePDF; End;
if (kb=kbd.sn_kb1_SBYLEN)or(kb=kbd.sn_kb2_SBYLEN) then
                     Begin SortType:=LenType; GlobalSort(255); TrueCur; Inside; rePDF; End;
if (kb=kbd.sn_kb1_SBYNON)or(kb=kbd.sn_kb2_SBYNON) then
                     Begin SortType:=NonType; reMDF; GlobalSort(255); TrueCur; Inside; rePDF; End;

if (kb=kbd.sn_kb1_VIDEO1)or(kb=kbd.sn_kb2_VIDEO1) then
                     AltF10Pressed;
if (kb=kbd.sn_kb1_VIDEO2)or(kb=kbd.sn_kb2_VIDEO2) then
                     CtrlF10Pressed;
if (kb=kbd.sn_kb1_LPONOFF)or(kb=kbd.sn_kb2_LPONOFF) then
                     begin CtrlF1Pressed; Exit; end;
if (kb=kbd.sn_kb1_RPONOFF)or(kb=kbd.sn_kb2_RPONOFF) then
                     begin CtrlF2Pressed; Exit; end;
if (kb=kbd.sn_kb1_NFPONOFF)or(kb=kbd.sn_kb2_NFPONOFF) then
                     begin Case focus of Left:CtrlF2Pressed; Right:CtrlF1Pressed; End; {Exit;{} end;
if (kb=kbd.sn_kb1_BPONOFF)or(kb=kbd.sn_kb2_BPONOFF) then
                     begin CtrlF1Pressed; CtrlF2Pressed; {Exit;{} end;
{ _CtrlU:  begin panellong:=0; panelhi:=panelhi div panellong end;{}


if (kb=kbd.sn_kb1_INFO)or(kb=kbd.sn_kb2_INFO) then
                     begin CtrlLPressed;{ Exit;{} end;

if (kb=kbd.sn_kb1_REREAD)or(kb=kbd.sn_kb2_REREAD) then
                     begin
                      reMDF; reInfo('cdnsfi');
                      reTrueCur;
                      {reOutside;{}
                      reInside;
                      rePDF;
                     end;

if kb= _F3 then      View(false);
if kb= _AltF3 then   Begin AltF3Pressed:=true; View(false); AltF3Pressed:=false; End;
if kb= _F4 then      Edit;
if kb= _F5 then      Begin AltF5Pressed:=false; fCopy; End;
if kb= _AltF5 then   Begin AltF5Pressed:=true; fCopy; AltF5Pressed:=false; End;
if kb= _F6 then      fMove;
if kb= _AltF6 then   Rename;
if kb= _ShF6 then    hobRename;
if kb= _F7 then      Begin
           Case PanelType of
            pcPanel: begin pcF7Pressed(pcnd,posx); end;
            trdPanel: case focus of left:trdMove(lp); right:trdMove(rp); end;
            fdiPanel: case focus of left:fdiMove(lp); right:fdiMove(rp); end;
            fddPanel: case focus of left:fddMove(lp); right:fddMove(rp); end;
            flpPanel: case focus of left:flpMove(lp,lp.flpDrive); right:flpMove(rp,rp.flpDrive); end;
           End;
          End;

if (kb=kbd.sn_kb1_LFIND)or(kb=kbd.sn_kb2_LFIND) then
                     LocalFind;
if (kb=kbd.sn_kb1_GFIND)or(kb=kbd.sn_kb2_GFIND) then
                     GlobalFind;

if kb= _F8 then      Del;
if kb= _AltF8 then   ViewHistoryCommands;
if kb= _Del then     begin
           if length(nospace(Command))>0 then
            begin
             Command:=copy(Command,1,(CommandXFrom+CommandXPos-1)-1)+
                      copy(Command,(CommandXFrom+CommandXPos-1)+1,255);
{             if (CommandXFrom<>1) then inc(CommandXPos);{}
            end
           else if Del_F8 then Del;
          end;

if kb= _F9 then      Begin
           Case PanelType of
            pcPanel:  if place=left then MakeImages(lp) else MakeImages(rp);
            trdPanel: trdLabel;
            fdiPanel: fdiLabel;
            fddPanel: fddLabel;
            flpPanel: flpLabel(flpDrive);
           End;
          End;
if kb= _CtrlF9 then  Begin
           makeboot:=true;
           Case PanelType of
            pcPanel:  if place=left then MakeImages(lp) else MakeImages(rp);
            trdPanel:  if place=left then trdMakeImage(lp,true) else trdMakeImage(rp,true);
            fdiPanel:  if place=left then fdiMakeImage(lp,true) else fdiMakeImage(rp,true);
            fddPanel:  if place=left then fddMakeImage(lp,true) else fddMakeImage(rp,true);
           End;
           makeboot:=false;
           reMDF;
           TrueCur; Inside;{}
           reInfo('cbdnsfi');
           rePDF;
          End;

{if kb= _F10 then     snDone(false);{}

if kb= _Up then
          Begin
           {HideCur;{}
           dec(f);
          End;
if kb= _Down then
          Begin
           {HideCur;{}
           inc(f);
          End;
if kb= _Left then
          Begin
           {HideCur;{}
           if LShift or RShift then Dec(CommandXPos) else dec(f,PanelHi);
          End;
if kb= _Right then
          Begin
           {HideCur;{}
           if LShift or RShift then Inc(CommandXPos) else inc(f,PanelHi);
          End;
if kb=  _PgUp then
          Begin
           {HideCur;{}
           dec(f,PanelHi*Columns-1);
          End;
if kb=  _PgDn then
          Begin
           {HideCur;{}
           inc(f,PanelHi*Columns-1);
          End;
if kb=  _Home then
          Begin
           {HideCur;{}
           if LShift or RShift then begin CommandXFrom:=1; CommandXPos:=1; end else
            begin
             from:=1; f:=1;
            end;
          End;
if kb=  _End then
          Begin
           {HideCur;{}
           if LShift or RShift then begin CommandXFrom:=255; CommandXPos:=255; end else
            begin
             from:=tdirs+tfiles-Columns*PanelHi+1;
             f:=Columns*PanelHi;
            end;
          End;

if kb=  _Enter then  if LShift or RShift then ShiftEnter else Enter;


if kb=  _CtrlPgUp then CtrlPgUp;
if kb=  _CtrlPgDn then CtrlPgDn;

if (kb=kbd.sn_kb1_PCOLUMNS)or(kb=kbd.sn_kb2_PCOLUMNS) then
          Begin
           case Columns of 2:Columns:=3; 3:Columns:=2; end;
           Build('12'); TrueCur; Inside; pcPDF(from);
          End;
if kb=  _Space then  if nospace(Command)='' then Begin Insert; kb:=0; End;
if kb=  _CtrlEnter then
          Begin
           if PanelType=pcPanel then
            BEGIN
             if nospace(TrueName(Index))<>'..' then
             if (command[length(command)]<>'\')and(command[length(command)]<>' ')and(nospace(command)<>'')
               then command:=command+' '+TrueName(Index)+' '
               else command:=command+TrueName(Index)+' ';
             CommandXFrom:=255; CommandXPos:=255;
            END;
          End;
if kb=  _CtrlOpScob then
          Begin
           if (command[length(command)]<>' ')and(nospace(command)<>'')
             then command:=command+' '+lp.pcnd
             else command:=command+lp.pcnd;
           CommandXFrom:=255; CommandXPos:=255;
          End;
if kb=  _CtrlClScob then
          Begin
           if (command[length(command)]<>' ')and(nospace(command)<>'')
             then command:=command+' '+rp.pcnd
             else command:=command+rp.pcnd;
           CommandXFrom:=255; CommandXPos:=255;
          End;
{end;{}

if (chr(lo(kb)) in [#32..'Ô'])and
   (hi(kb) in [0..$d,$10..$1b,$1e..$29,$2b..$35,$39]) then
 begin
  Command:=copy(Command,1,(CommandXFrom+CommandXPos-1)-1)+chr(lo(kb))+
           copy(Command,(CommandXFrom+CommandXPos-1),255);
  Inc(CommandXPos);
  PutCmdLine;
 end;
if chr(lo(kb)) in [#8] then
 begin
  Command:=copy(Command,1,(CommandXFrom+CommandXPos-1)-2)+
           copy(Command,(CommandXFrom+CommandXPos-1),255);
  Dec(CommandXPos);
  PutCmdLine;
 end;

if tdirs+tfiles>Columns*PanelHi then n:=Columns*PanelHi else n:=tdirs+tfiles;
if f>n then begin inc(from,f-n); f:=n; end;
if f<1 then begin dec(from,1-f); f:=1; end;
if from>tdirs+tfiles-Columns*PanelHi+1 then from:=tdirs+tfiles-Columns*PanelHi+1;
if from<1 then from:=1;

Outside;
Info('bn');
PDF;

if Moused then MouseOff;{}
GoTo LOOP;
End;





Begin
lp.posx:=1; rp.posx:=41;
lp.posy:=1; rp.posy:=1;

lp.Columns:=3; rp.Columns:=3;
lp.InfoLines:=3; rp.InfoLines:=3;

lp.NameLine:=true; rp.NameLine:=true;

lp.PanelType:=pcPanel; rp.PanelType:=pcPanel;
lp.SortType:=extType; rp.SortType:=extType;

lp.focused:=false;
rp.focused:=false;

lp.f:=1; lp.from:=1;
rp.f:=1; rp.from:=1;

lp.Place:=left;
rp.Place:=right;
End.