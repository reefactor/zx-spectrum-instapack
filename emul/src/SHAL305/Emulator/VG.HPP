/**************************************************************************

Эмуляция контроллера дисководов

**************************************************************************/

extern unsigned FormatDatLen;
extern unsigned Ready;
extern unsigned ReadIndexTrack;

extern "C" void __pragma("ProcVG") DiskVG(byte);
