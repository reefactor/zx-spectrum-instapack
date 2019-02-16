{$O+,F+}
Unit Palette;
Interface

Type
   TPal=record

   bkSBarNT, txtSBarNT,
   bkSBarST, txtSBarST,

   BkSelectedNT, TxtSelectedNT,
   BkSelectedST, TxtSelectedST,

   BkCurNT, TxtCurNT,
   BkCurST, TxtCurST,

   BkNDActive, TxtNDActive,
   BkNDPassive, TxtNDPassive,

   BkNameLine, TxtNameLine,

   BkNT, TxtNT,
   BkST, TxtST,

   BkRama, TxtRama,

   BkCurLine, TxtCurLine,

   BkBP, TxtBP,

   BkFreeLineNT, TxtFreeLineNT,
   BkFreeLineST, TxtFreeLineST,

   bkDiskLineNT, txtDiskLineNT,
   bkDiskLineST, txtDiskLineST,
   bkDiskLineR, txtDiskLineR,


   BkDir, txtDir,
   bkArc, txtArc,
   bkExe, txtExe,

   bkG1, txtG1,
   bkG2, txtG2,
   bkG3, txtG3,
   bkG4, txtG4,
   bkG5, txtG5,

   bkdRama,txtdRama,
   bkdInputNT, txtdInputNT,
   bkdInputST, txtdInputST,
   bkdLabelNT, txtdLabelNT,
   bkdLabelST, txtdLabelST,
   bkdStatic,  txtdStatic,
   bkdButtonNA,txtdButtonNA,
   bkdButtonA, txtdButtonA,
   bkdButtonShadow,txtdButtonShadow,

   bkdPoleNT,  txtdPoleNT,
   bkdPoleST,  txtdPoleST,

   bkDiskInfoNT, txtDiskInfoNT,
   bkDiskInfoST, txtDiskInfoST,

   bkMenuNT,      txtMenuNT,
   bkMenuST,      txtMenuST,
   bkMenuMarkNT,  txtMenuMarkNT,
   bkMenuMarkST,  txtMenuMarkST


   :byte;
   End;

Var

   Pal: TPal;

   group1: string;
   group2: string;
   group3: string;
   group4: string;
   group5: string;
   gexe: string;
   garc: string;


Procedure Col(ex:string; size:longint; var paper,ink:byte);
Procedure GetPalFile;{}

Implementation

uses crt,rv,clock,Vars;

procedure Col(ex:string; size:longint; var paper,ink:byte);
var s:string;
begin
ex:=';'+ex+';';
    if pos(ex,group1)<>0 then begin paper:=pal.bkg1; ink:=pal.txtg1; end;
    if pos(ex,group2)<>0 then begin paper:=pal.bkg2; ink:=pal.txtg2; end;
    if pos(ex,group3)<>0 then begin paper:=pal.bkg3; ink:=pal.txtg3; end;
    if pos(ex,group4)<>0 then begin paper:=pal.bkg4; ink:=pal.txtg4; end;
    if pos(ex,group5)<>0 then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if pos(ex,gexe)<>0 then begin paper:=pal.bkexe; ink:=pal.txtexe; end;

    if ex=';>P<;' then begin paper:=pal.bkexe; ink:=pal.txtexe; end;
    if {(ex=';>C<;')and}(size=6912) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (ex=';>B<;')and(size=6912) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;

    if pos(ex,garc)<>0 then begin paper:=pal.bkarc; ink:=pal.txtarc; end;
    if strlo(ex)=';trd;' then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
    if strlo(ex)=';tap;' then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
    if strlo(ex)=';scl;' then begin paper:=pal.bkdir; ink:=pal.txtdir; end;{}
    if strlo(ex)=';fdi;' then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
    if strlo(ex)=';fdd;' then begin paper:=pal.bkdir; ink:=pal.txtdir; end;
    if (strlo(ex)=';scr;')and(size=6912) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (strlo(ex)=';xpc;')and(size=18432) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (ex=';<C>;')and(size=6912) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (ex=';<C>;')and(size=18432) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (strlo(ex)=';$c;')and(size=6929) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
    if (strlo(ex)=';$c;')and(size=18449) then begin paper:=pal.bkg5; ink:=pal.txtg5; end;
end;

procedure GetPalFile;
var f:string; fb:file; b:byte; buf:array[0..512] of byte;
begin
 if checkdirfile(startdir+'\sn.ini')<>0 then exit;
 getprofile(startdir+'\sn.ini','Interface','Group1',f); group1:=f;
 getprofile(startdir+'\sn.ini','Interface','Group2',f); group2:=f;
 getprofile(startdir+'\sn.ini','Interface','Group3',f); group3:=f;
 getprofile(startdir+'\sn.ini','Interface','Group4',f); group4:=f;
 getprofile(startdir+'\sn.ini','Interface','Group5',f); group5:=f;
 getprofile(startdir+'\sn.ini','Interface','GroupExe',f); gexe:=f;
 getprofile(startdir+'\sn.ini','Interface','GroupArc',f); garc:=f;
 getprofile(startdir+'\sn.ini','Interface','PalleteFile',f);

 if nospace(f)='' then exit;
 if checkdirfile(startdir+'\colors\'+f)<>0 then exit;
 {$I-}
 assign(fb,startdir+'\colors\'+f); reset(fb,1); blockread(fb,buf,filesize(fb));

 b:=buf[$A5];
 pal.bknameline:=b div 16; pal.txtnameline:=b-(b div 16)*16;

 b:=buf[$55];
 pal.bkNT:=b div 16; pal.txtNT:=b-(b div 16)*16;

 b:=buf[$57];
 pal.bkST:=b div 16; pal.txtST:=b-(b div 16)*16;

 b:=buf[$57];
 pal.bkST:=b div 16; pal.txtST:=b-(b div 16)*16;

 b:=buf[$51];
 pal.bkRama:=b div 16; pal.txtRama:=b-(b div 16)*16;

 b:=buf[$77];
 pal.bkCurLine:=b div 16; pal.txtCurLine:=b-(b div 16)*16;

 b:=buf[$2];
 pal.bkSBarNT:=b div 16; pal.txtSBarNT:=b-(b div 16)*16;

 b:=buf[$4];
 pal.bkSBarST:=b div 16; pal.txtSBarST:=b-(b div 16)*16;

 b:=buf[$7C];
 pal.bkFreeLineNT:=b div 16; pal.txtFreeLineNT:=b-(b div 16)*16;

 b:=buf[$7D];
 pal.bkFreeLineST:=b div 16; pal.txtFreeLineST:=b-(b div 16)*16;

 b:=buf[$78];
 pal.bkSelectedNT:=b div 16; pal.txtSelectedNT:=b-(b div 16)*16;

 b:=buf[$79];
 pal.bkSelectedST:=b div 16; pal.txtSelectedST:=b-(b div 16)*16;

 b:=buf[$58];
 pal.bkCurNT:=b div 16; pal.txtCurNT:=b-(b div 16)*16;

 b:=buf[$59];
 pal.bkCurST:=b div 16; pal.txtCurST:=b-(b div 16)*16;

 b:=buf[$5A];
 pal.bkNDActive:=b div 16; pal.txtNDActive:=b-(b div 16)*16;

 b:=buf[$5B];
 pal.bkNDPassive:=b div 16; pal.txtNDPassive:=b-(b div 16)*16;

 b:=buf[$BA];
 pal.bkDiskLineNT:=b div 16; pal.txtDiskLineNT:=b-(b div 16)*16;

 b:=buf[$BC];
 pal.bkDiskLineST:=b div 16; pal.txtDiskLineST:=b-(b div 16)*16;

 b:=buf[$BB];
 pal.bkDiskLineR:=b div 16; pal.txtDiskLineR:=b-(b div 16)*16;

 b:=buf[$AC];
 pal.bkDir:=b div 16; pal.txtDir:=b-(b div 16)*16;

 b:=buf[$AD];
 pal.bkExe:=b div 16; pal.txtExe:=b-(b div 16)*16;

 b:=buf[$AE];
 pal.bkArc:=b div 16; pal.txtArc:=b-(b div 16)*16;

 b:=buf[$AF];
 pal.bkg1:=b div 16; pal.txtg1:=b-(b div 16)*16;

 b:=buf[$B0];
 pal.bkg2:=b div 16; pal.txtg2:=b-(b div 16)*16;

 b:=buf[$B1];
 pal.bkg3:=b div 16; pal.txtg3:=b-(b div 16)*16;

 b:=buf[$B4];
 pal.bkg4:=b div 16; pal.txtg4:=b-(b div 16)*16;

 b:=buf[$B5];
 pal.bkg5:=b div 16; pal.txtg5:=b-(b div 16)*16;

 b:=buf[$1];
 clcolour:=b;

 b:=buf[$21];
 pal.bkdRama:=b div 16; pal.txtdRama:=b-(b div 16)*16;

 b:=buf[$32];
 pal.bkdInputNT:=b div 16; pal.txtdInputNT:=b-(b div 16)*16;

 b:=buf[$33];
 pal.bkdInputST:=b div 16; pal.txtdInputST:=b-(b div 16)*16;

 b:=buf[$26];
 pal.bkdLabelNT:=b div 16; pal.txtdLabelNT:=b-(b div 16)*16;

 b:=buf[$27];
 pal.bkdLabelST:=b div 16; pal.txtdLabelST:=b-(b div 16)*16;

 b:=buf[$25];
 pal.bkdStatic:=b div 16; pal.txtdStatic:=b-(b div 16)*16;

 b:=buf[$29];
 pal.bkdButtonNA:=b div 16; pal.txtdButtonNA:=b-(b div 16)*16;

 b:=buf[$2B];
 pal.bkdButtonA:=b div 16; pal.txtdButtonA:=b-(b div 16)*16;

 b:=buf[$2E];
 pal.bkdButtonShadow:=b div 16; pal.txtdButtonShadow:=b-(b div 16)*16;

 b:=buf[$2F];
 pal.bkdPoleNT:=b div 16; pal.txtdPoleNT:=b-(b div 16)*16;

 b:=buf[$54];
 pal.bkBP:=b div 16; pal.txtBP:=b-(b div 16)*16;

 b:=buf[$30];
 pal.bkdPoleST:=b div 16; pal.txtdPoleST:=b-(b div 16)*16;

 b:=buf[$67];
 pal.bkDiskInfoNT:=b div 16; pal.txtDiskInfoNT:=b-(b div 16)*16;

 b:=buf[$66];
 pal.bkDiskInfoST:=b div 16; pal.txtDiskInfoST:=b-(b div 16)*16;

 b:=buf[$2];
 pal.bkMenuNT:=b div 16; pal.txtMenuNT:=b-(b div 16)*16;

 b:=buf[$5];
 pal.bkMenuMarkNT:=b div 16; pal.txtMenuMarkNT:=b-(b div 16)*16;

 b:=buf[$4];
 pal.bkMenuST:=b div 16; pal.txtMenuST:=b-(b div 16)*16;

 b:=buf[$7];
 pal.bkMenuMarkST:=b div 16; pal.txtMenuMarkST:=b-(b div 16)*16;

 close(fb);{}
 {$I+}
 if IOResult<>0 then;

end;
{}

Begin
pal.bknameline:=1;     pal.txtnameline:=yellow;

pal.bkRama:=1;         pal.txtRama:=11;

pal.bkNT:=1;           pal.txtNT:=lightcyan;
pal.bkST:=1;           pal.txtST:=yellow;

pal.bkCurLine:=1;      pal.txtCurLine:=lightcyan;

pal.bkFreeLineNT:=1;      pal.txtFreeLineNT:=11;
pal.bkFreeLineST:=1;      pal.txtFreeLineST:=14;

pal.bkSBarNT:=3;          pal.txtSBarNT:=0;
pal.bkSBarST:=3;          pal.txtSBarST:=14;

pal.bkSelectedNT:=1;      pal.txtSelectedNT:=14;
pal.bkSelectedST:=1;      pal.txtSelectedST:=14;

pal.BkCurNT:=cyan;        pal.txtCurNT:=0;
pal.BkCurST:=cyan;        pal.txtCurST:=yellow;

pal.bkNDactive:=3;        pal.txtNDactive:=0;
pal.bkNDpassive:=1;       pal.txtNDpassive:=11;

pal.bkDiskLineNT:=1;      pal.txtDiskLineNT:=11;
pal.bkDiskLineST:=1;      pal.txtDiskLineST:=14;
pal.bkDiskLineR:=1;       pal.txtDiskLineR:=11;


pal.bkDir:=1;             pal.txtDir:=11;
pal.bkArc:=1;             pal.txtArc:=11;
pal.bkExe:=1;             pal.txtExe:=11;

pal.bkG1:=1;              pal.txtG1:=11;
pal.bkG2:=1;              pal.txtG2:=11;
pal.bkG3:=1;              pal.txtG3:=11;
pal.bkG4:=1;              pal.txtG4:=11;
pal.bkG5:=1;              pal.txtG5:=11;

pal.bkdRama:=7;           pal.txtdRama:=0;
pal.bkdInputNT:=3;        pal.txtdInputNT:=0;
pal.bkdInputST:=0;        pal.txtdInputST:=3;
pal.bkdLabelNT:=7;        pal.txtdLabelNT:=0;
pal.bkdLabelST:=7;        pal.txtdLabelST:=0;
pal.bkdStatic:=7;         pal.txtdStatic:=0;
pal.bkdButtonNA:=7;       pal.txtdButtonNA:=0;
pal.bkdButtonA:=3;        pal.txtdButtonA:=0;
pal.bkdButtonShadow:=7;   pal.txtdButtonShadow:=0;

pal.bkdPoleNT:=7;         pal.txtdPoleNT:=0;
pal.bkdPoleST:=7;         pal.txtdPoleST:=15;

pal.bkDiskInfoNT:=1;      pal.txtDiskInfoNT:=11;
pal.bkDiskInfoST:=1;      pal.txtDiskInfoST:=14;

pal.bkBP:=1;              pal.txtBP:=11;

pal.bkMenuNT:=7;          pal.txtMenuNT:=0;
pal.bkMenuST:=7;          pal.txtMenuST:=15;
pal.bkMenuMarkNT:=1;      pal.txtMenuMarkNT:=11;
pal.bkMenuMarkST:=1;      pal.txtMenuMarkST:=15;


ClColour:=$1B;

group1:=';cpp;pas;c;asm;';
group2:=';.;doc;txt;ctl;diz;ini;cfg;!!!;lst;1st;';
group3:=';mod;mid;s3m;wav;voc;xm;stm;mpg;avi;mp3;';
group4:=';tmp;$$$;bak;';
group5:=';pcx;bmp;pic;gif;rle;ico;jpg;tga;';

gexe:=';exe;com;bat;';
garc:=';arj;zip;rar;lha;ha;arc;';
End.
