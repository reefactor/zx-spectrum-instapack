{$M 27768,0,555350}
Program ZX_Spectrum_Navigator_v1_12;
Uses
      h0, Overlay,
      SafeExit,
      Crt, RV,
      Vars, Init, sn_Obj, Main, Main_Ovr;

{$O Main_Ovr.pas}
{$O Utils.pas}
{$O Init.pas}
{$O sn_Mem.pas}
{$O PC_Ovr.pas}
{$O palette.pas}
{$O zxView.pas}
{$O zxZip.pas}


{$O FDD_Ovr.pas}
{$O TRD_Ovr.pas}
{$O FDI_Ovr.pas}
{$O SCL_Ovr.pas}
{$O TAP_Ovr.pas}

{$O UserMenu.pas}
{$O sn_KBD.pas}
{$O sn_Setup.pas}
{$O trdos.pas}
{$O snViewer.pas}

{================================= INIT =====================================}
BEGIN
CheckBreak:=false; snMouse:=false;

snInit(false);
{}
{--------------------------------- LAUNCH -----------------------------------}

Case focus of
 left: lp.focused:=true;
 right: rp.focused:=true;
End;
reMDF;

if lp.PanelType<>pcPanel then if (lp.f<>0)and(lp.from<>0)and(lp.tfiles<>0) then lp.Outside;
if rp.PanelType<>pcPanel then if (rp.f<>0)and(rp.from<>0)and(rp.tfiles<>0) then rp.Outside;

lp.Build('012'); rp.Build('012');
reTrueCur; reInside;
CommandXPos:=1; CommandXFrom:=1;

Repeat
 Navigate;
 if snKernelExitCode=9 then ChangeFocus;
Until false;
{}
END.

