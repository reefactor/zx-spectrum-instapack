@echo off
del in_fdi.add > nul
WPP386 -zp=1 -3 -bt=dos4gw -ot -s in_fdi.cpp
WLINK.EXE format os2 le dll name in_fdi file in_fdi @in_fdi > nul
DLL2ADD in_fdi
del in_fdi.obj > nul
del in_fdi.dll > nul
copy in_fdi.add c:\speccy\spectrum\modules /Y > nul

