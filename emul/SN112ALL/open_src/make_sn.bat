@echo off
copy *.pas out\*.pas                   >nul
copy units\*.pas out\*.pas             >nul
copy units\*.tpu out\*.tpu             >nul
copy units\rv201099\*.pas out\*.pas    >nul
copy units\rv201099\*.obj out\*.obj    >nul
cd out
bpc -b -$g+ -$l- -$k- -$s- -$m27768,0,555350 sn.pas
copy /b sn.exe+sn.ovr sn.prg
del *.pas
del *.tpu
del *.exe
del *.ovr
del *.obj
cd ..\exec
call compile.bat
cd ..
copy exec\sn.com out\sn.com            >nul
del exec\sn.com
cd out
@echo *********************************************************
@echo * Ловите в \OUT только что скомпиленные SN.COM и SN.PRG *
@echo *********************************************************
