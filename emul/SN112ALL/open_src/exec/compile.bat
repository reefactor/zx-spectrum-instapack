@echo off
tasm sn112.asm /m
tlink sn112.obj /t
ren sn112.com sn.com
del *.map
del *.obj