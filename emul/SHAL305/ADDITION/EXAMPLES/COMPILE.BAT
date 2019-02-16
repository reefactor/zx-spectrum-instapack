IF EXIST %1.ASM TASM /ml/m3 %1
IF EXIST %1.CPP WPP386 -3 -bt=dos4gw -ot -s %1
WLINK.EXE format os2 le dll name %1 file %1 @%1
DLL2ADD %1
