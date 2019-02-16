/**************************************************************************

Дисковые утилиты

**************************************************************************/

extern "C" unsigned char FloppyDriveTyp[2];

extern "C" unsigned Track;

extern unsigned Format;
extern "C" unsigned Drive;

extern char FileNameCopy[0x40];

extern "C" void DiskInit();

extern void DskUtilDiskToFile();
extern void DskUtilFileToDisk();

extern "C" void ProgressView();

extern "C" unsigned char IntFloppyDisk();
#pragma aux IntFloppyDisk value [al]

extern "C" unsigned char DiskDataIn();
#pragma aux DiskDataIn value [al]

extern "C" void DiskDataOut(unsigned char);
#pragma aux DiskDataOut parm [eax] modify [eax]

extern "C" unsigned DiskIntWait();
#pragma aux DiskIntWait value [eax]
