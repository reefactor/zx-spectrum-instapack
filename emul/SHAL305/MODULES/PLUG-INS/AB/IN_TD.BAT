@echo off
del in_td.add > nul
WPP386 -zp=1 -bt=dos4gw -ot -s -3 in_td.cpp
WLINK.EXE format os2 le dll name in_td file in_td @in_td
DLL2ADD in_td
del in_td.obj > nul
del in_td.dll > nul
copy in_td.add c:\speccy\spectrum\modules /Y > nul
