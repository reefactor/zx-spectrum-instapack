/****************************************************************************

                           FDI Support v0.03

Copyright 2000 Alex Baskakov aka RAIN, 2:5025/3.55, alex_baskakov@newmail.ru

****************************************************************************/

#pragma pack(1)
#define PATHLEN 256
#include "emudata.h"

unsigned char *DiskBuf;

static char FileName[4][PATHLEN];
char Path[4][PATHLEN];
unsigned Handle[4]={0,0,0,0};
unsigned ReadOnly[4];

//unsigned FormatDatLen=0x1;
unsigned Ready=0x1;
unsigned ReadIndexTrack=0x1;

static unsigned char DskIndex[5]={0,0,0,0,0};

// Состояние диска
// Биты 0-1 - номер дисковода
// Бит 2 - форматирован
// Бит 6 - защита записи
// Бит 7 - статус инициализирован
static unsigned char DskStatus=0x00;

static byte DskIndexCounter;
static int CntData;
static int DskDataSize;
static byte DskCountDatLost;
static byte CntReady;

//=================================================== Функции работы с файлами
// Открытие файла
unsigned FileOpen(char *Name);
#pragma aux FileOpen=\
    "mov ax,0x3d02"\
    "xor ecx,ecx"\
    "int 0x21"\
    "jnc $"\
    "xor eax,eax"\
    "$:"\
    modify [eax ecx] parm [edx] value [eax]
unsigned FileOpenReadOnly(char *Name);
#pragma aux FileOpenReadOnly=\
    "mov ax,0x3d00"\
    "xor ecx,ecx"\
    "int 0x21"\
    "jnc $"\
    "xor eax,eax"\
    "$:"\
    modify [eax ecx] parm [edx] value [eax]
// Создание файла
unsigned FileCreate(char *Name);
#pragma aux FileCreate=\
    "mov ah,0x3C"\
    "xor ecx,ecx"\
    "int 0x21"\
    modify [eax ecx] parm [edx] value [eax]
// Чтение файла
unsigned FileRead(void *Buf,unsigned Size,unsigned Handle);
#pragma aux FileRead=\
    "mov ah,0x3f"\
    "int 0x21"\
    modify [eax] parm [edx][ecx][ebx] value [eax]
// Запись файла
void FileSave(void *Buf,unsigned Size,unsigned Handle);
#pragma aux FileSave=\
    "mov ah,0x40"\
    "int 0x21"\
    modify [eax] parm [edx][ecx][ebx]
// Закрытие файла
void FileClose(unsigned Handle);
#pragma aux FileClose=\
    "mov ah,0x3E"\
    "int 0x21"\
    modify [eax] parm [ebx]
// SEEK файла
unsigned LSeek(unsigned Handle,unsigned Ptr,byte Type);
#pragma aux LSeek=\
    "push eax"\
    "mov al,cl"\
    "pop dx"\
    "pop cx"\
    "mov ah,0x42"\
    "int 0x21"\
    "push dx"\
    "push ax"\
    "pop ebx"\
    modify [eax edx ecx] parm [ebx] [eax] [ecx] value [ebx]

EmuData *EmuTable;
unsigned Id;

// Описание
char _DSC[]=".FDI Support v0.03";

// Строки для интерфейса
char TxtOk[]="\1OK";
char TxtCancel[]="Ca\1ncel";
char TxtBrowse[]="Browse";

// Клавиша вызова
unsigned Key=0x5; //F12

byte SecNum=0;

static void WorkMenu(void);

struct CnTxt CtFileName[4]={FileName[0],PATHLEN,
                            FileName[1],PATHLEN,
                            FileName[2],PATHLEN,
                            FileName[3],PATHLEN};

char TxtKey[]="Key:\nF7\nF8\nF9\nF10\nF11\nF12";
static const char *CKey[]={"F7","F8","F9","F10","F11","F12"};
struct CnTbl CgKey={&Key,CKey,sizeof CKey/sizeof(char*)};

// Таблица конфигурации
static struct CfgS Cfg[]=
{
    TTbl,"FDI_Key=",&CgKey,
    TTxt,"FDI_A=",&CtFileName[0],
    TTxt,"FDI_B=",&CtFileName[1],
    TTxt,"FDI_C=",&CtFileName[2],
    TTxt,"FDI_D=",&CtFileName[3]
};

struct CfgDat _CFG={Cfg,sizeof Cfg/sizeof(CfgS)}; // Данные о конфигурации

/*--------------------------FDI Header------------------------*/
struct _fdi_head{
        char sig[3];
        unsigned char read_only;
        unsigned short cyl_count;
        unsigned short sides_count;
        unsigned short text_offset;
        unsigned short data_offset;
        unsigned short extra_size;
};

struct _sec_head{
        unsigned char c,h,r,n;
        unsigned char flags;
        unsigned short offs;
};

struct _trk_head{
        long offs;
        unsigned short reserved;
        unsigned char sex;
        struct _sec_head *sec;
};

struct _fdi_head fdi[4];
struct _trk_head *ftrk[4];

void _SET() {

    if ( DiskBuf == 0 )
    {
        EmuTable->TextMode();
        EmuTable->MessageBox(0x4f,"Error: Can't allocate startup memory","");
        EmuTable->SpecMode();
        return;
    }

    void *Pnt=EmuTable->WinCreate(29,4,23,17,0x9F);
    EmuTable->WinTitle(Pnt,_DSC,0xF0);
    EmuTable->WinText(Pnt,2,2,"Alex Baskakov, 2000");
    EmuTable->SetRadio(Pnt,8,4,TxtKey,&CgKey);
    EmuTable->SetButton(Pnt,5,14,TxtCancel,12,0);
    EmuTable->SetButton(Pnt,5,12,TxtOk,12,1);
    if (EmuTable->WinExe(Pnt)) EmuTable->WinResult(Pnt);
    EmuTable->WinRemove(Pnt);
}

//отделение пути от полного имени файла
void GetPath(char *src,char *dst)
{
    char *SlPos=dst;

    *dst=0;
    while ( *src )
    {
        if ( *src == '\\' ) SlPos=dst;
        *dst++=*src++;
    }
    *SlPos=0;
}

//пришивание пути к относительному имени файла
void MakeFullName(char *Name,char *Path)
{
    char *src;
    char *dst;

    src=Name;
    while ( *src ) if ( (*src++) == ':' ) return; //если путь полный - возврат

    src=Path; dst=Name;
    while ( *Path ) *Path++;
    *Path++='\\';
    *Path=0;
    while ( *Name ) *Path++=*Name++;
    *Path=0;
    while ( *src ) *dst++=*src++;
    *dst=0;
}

void FreeFDIMem(char DriveNumber)
{
    int i;
    if ( ftrk[DriveNumber] )
    {
        for(i=0; i<(fdi[DriveNumber].cyl_count * fdi[DriveNumber].sides_count); ++i)
            if (ftrk[DriveNumber][i].sec) EmuTable->MemFree(ftrk[DriveNumber][i].sec);
        EmuTable->MemFree(ftrk[DriveNumber]);
        ftrk[DriveNumber]=0;
    }
}

int OpenFDI(char DriveNumber)
{
    int i;
    int err=0;

//  EmuTable->MessageBox(0x4f,"Opening file: ",FileName[DriveNumber]);

    if ( (Handle[DriveNumber] = FileOpen(FileName[DriveNumber])) == 0 )
    {
        if ( (Handle[DriveNumber] = FileOpenReadOnly(FileName[DriveNumber])) == 0 )
           {
           EmuTable->MessageBox(0x4f,"Error Open File:",FileName[DriveNumber]);
           return 0;
           }
        else ReadOnly[DriveNumber]=1;
    }
    else ReadOnly[DriveNumber]=0;

    FileRead(&fdi[DriveNumber],sizeof(struct _fdi_head),Handle[DriveNumber]);

    if ( fdi[DriveNumber].sig[0]!='F' || fdi[DriveNumber].sig[1]!='D' || fdi[DriveNumber].sig[2]!='I')
    {
        EmuTable->MessageBox(0x4f,"Bad Header File: ",FileName[DriveNumber]);
        return 0;
    }

    if (ReadOnly[DriveNumber]) fdi[DriveNumber].read_only=1;
    else ReadOnly[DriveNumber]=(unsigned char)fdi[DriveNumber].read_only;

    LSeek(Handle[DriveNumber],sizeof(struct _fdi_head)+fdi[DriveNumber].extra_size,0);

    if ( (ftrk[DriveNumber] = (_trk_head*) EmuTable->MemAlloc(sizeof(struct _trk_head) * fdi[DriveNumber].cyl_count * fdi[DriveNumber].sides_count)) == 0 )
    {
        EmuTable->MessageBox(0x4f,"Can't allocate memory for track info","");
        return 0;
    }

    for(i=0; i<(fdi[DriveNumber].cyl_count * fdi[DriveNumber].sides_count); ++i)
    {
        FileRead(&(ftrk[DriveNumber][i]), sizeof(struct _trk_head) - sizeof(struct _sec_head *),Handle[DriveNumber]);

        if (ftrk[DriveNumber][i].sex)
        {
            if ( (ftrk[DriveNumber][i].sec = (_sec_head*) EmuTable->MemAlloc(sizeof(struct _sec_head) * ftrk[DriveNumber][i].sex)) == 0 )
                err=1;
            else  FileRead(ftrk[DriveNumber][i].sec,sizeof(struct _sec_head) * ftrk[DriveNumber][i].sex,Handle[DriveNumber]);
        }
        else ftrk[DriveNumber][i].sec=0;

    }

    if ( err == 1)
    {
        EmuTable->MessageBox(0x4f,"Can't allocate sector memory","");
        FreeFDIMem(DriveNumber);
        return 0;
    }

    DskStatus=(unsigned char)((ReadOnly[EmuTable->VG.System&0x03]<<6)|0x84);

    return 1;
}

//ВГ crc
word crc(byte *mem, word size, byte first)
{
byte bit7D, bit7E, D=0xb2, E=0x30;
int i,j;

D^=first;
for(i=0;i<size;i++)
{
if (i) D^=mem[i-1];
for(j=0;j<8;j++)
    {
    bit7E=(byte)((E&128)>>7);
    E=(byte)(E<<1);
    bit7D=(byte)((D&128)>>7);
    D=(byte)(D<<1);
    D|=bit7E;
    if (bit7D) {D^=0x10; E^=0x21;}
    }
}
return ((word)(D)<<8)+E;
}

static void SetStateStep() {
        if (EmuTable->VG.RegTrack<0)
                EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=EmuTable->VG.RegTrack=0;
        if (EmuTable->VG.RegTrack>79)
                EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=EmuTable->VG.RegTrack=79;
        EmuTable->VG.RegStatus=(byte)(DskStatus&0x40);
        if (EmuTable->VG.RegCom&0x08) EmuTable->VG.RegStatus|=0x20;
        if (!EmuTable->VG.RegTrack) EmuTable->VG.RegStatus|=0x04;
                //// Биты 7,3,4
};

byte _VG_(void) {
        int a,b,c,i,j;
        word CRC; int crcIndex;

        if (!Handle[EmuTable->VG.System&3]) return 0;

        DskStatus&=0xbc;
        DskStatus|=(unsigned char)(ReadOnly[EmuTable->VG.System&0x03]<<6);
        DskStatus|=(unsigned char)(EmuTable->VG.System&0x03);

        if (EmuTable->VG.RegStatus&0x01&&!--DskCountDatLost) EmuTable->VG.RegStatus=0x04;
        if (CntReady) if (!--CntReady) EmuTable->VG.RegStatus=0x03;

        switch (EmuTable->VG.OperIO) {
         case 0x0: // Чтение состояния
                EmuTable->VG.DataIO=EmuTable->VG.RegStatus;
                if (EmuTable->VG.RegCom&0x80) break;
                if (--DskIndexCounter&0xE) EmuTable->VG.DataIO|=0x02;
                break;
         case 0x1: // Запись команды
                if (EmuTable->VG.RegStatus&0x01) {
                ////Принудительное прерывание
                } else {
                        if ((EmuTable->VG.DataIO&0xF0)==0xD0) return 1;
                        switch ((EmuTable->VG.RegCom=EmuTable->VG.DataIO)>>4) {
                         case 0x0: // Восстановление
                                EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=EmuTable->VG.RegTrack=0;
                                EmuTable->VG.StepDirect=-1;
                                SetStateStep();
                                break;
                         case 0x1: // Поиск
                                EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=EmuTable->VG.RegTrack=EmuTable->VG.RegData;
                                if (EmuTable->VG.RegData-EmuTable->VG.RegTrack<0) EmuTable->VG.StepDirect=-1;
                                if (EmuTable->VG.RegData-EmuTable->VG.RegTrack>0) EmuTable->VG.StepDirect=1;
                                SetStateStep();
                                break;
                         case 0x2:
                         case 0x3: // Шаг
                                if (EmuTable->VG.StepDirect==-1) goto StepRear;
                         case 0x4:
                         case 0x5: // Шаг вперед
                                if (EmuTable->VG.RegTrack)
                                        EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=++EmuTable->VG.RegTrack;
                                EmuTable->VG.StepDirect=1;
                                SetStateStep();
                                break;
                         case 0x6:
                         case 0x7: // Шаг назад
                                StepRear:
                                if (EmuTable->VG.RegTrack)
                                        EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]=--EmuTable->VG.RegTrack;
                                EmuTable->VG.StepDirect=-1;
                                SetStateStep();
                                break;
                         case 0x8:
                         case 0x9: // Чтение сектора
                                /*
                                OpReadSector:
                                if (EmuTable->VG.RegSect>0x10||
                                        EmuTable->VG.RegTrack!=EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]||
                                        (!(DskStatus&0x04))) goto OpNotFound;
                                fseek(Str,DiskPosition(EmuTable->VG.RegSect-1),SEEK_SET);
                                if (!fread(DiskBuf,0x100,1,Str)) goto OpContSum;
                                DskDataSize=0x00FF;
                                EmuTable->VG.RegData=DiskBuf[0];
                                goto OpCom;
                                */
                                OpReadSector:
                                if (EmuTable->VG.RegTrack!=EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]||
                                        (!(DskStatus&0x04))) goto OpNotFound;
                                a=(EmuTable->VG.TrackReal[EmuTable->VG.System&3]<<1) |
                                        ((byte)((EmuTable->VG.System&0x10)>>4)^1);
                                for (i=0;i<ftrk[EmuTable->VG.System&0x3][a].sex;i++)
                                {
                                if ( ftrk[EmuTable->VG.System&0x3][a].sec[i].r == EmuTable->VG.RegSect ) {c=i; break;}
                                }
                                if (i==ftrk[EmuTable->VG.System&0x3][a].sex)
                                        goto OpNotFound;
                                b=((int)ftrk[EmuTable->VG.System&0x3][a].sec[c].flags & 0x3f) * 128;
                                if (b==0) goto OpNotFound;

                                LSeek(Handle[EmuTable->VG.System&0x3],
                                 (long)fdi[EmuTable->VG.System&0x3].data_offset +
                                 ftrk[EmuTable->VG.System&0x3][a].offs +
                                 ftrk[EmuTable->VG.System&0x3][a].sec[c].offs,0);

                                FileRead(DiskBuf,b,Handle[EmuTable->VG.System&0x3]);

                                DskDataSize=b-1;
                                EmuTable->VG.RegData=DiskBuf[0];
                                goto OpCom;
                         case 0xA:
                         case 0xB: // Запись сектора
                                /*
                                OpWriteSector:
                                if (DskStatus&0x40) goto OpWrProt;
                                if (EmuTable->VG.RegSect>0x10||
                                        EmuTable->VG.RegTrack!=EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]||
                                        (!(DskStatus&0x04))) goto OpNotFound;
                                DskDataSize=0x0100;
                                goto OpCom;
                                */
                                OpWriteSector:
                                if (DskStatus&0x40) goto OpWrProt;
                                if (EmuTable->VG.RegTrack!=EmuTable->VG.TrackReal[EmuTable->VG.System&0x03]||
                                        (!(DskStatus&0x04))) goto OpNotFound;
                                a=(EmuTable->VG.TrackReal[EmuTable->VG.System&3]<<1) |
                                        ((byte)((EmuTable->VG.System&0x10)>>4)^1);
                                for (i=0;i<ftrk[EmuTable->VG.System&0x3][a].sex;i++)
                                if ( ftrk[EmuTable->VG.System&0x3][a].sec[i].r
                                        == EmuTable->VG.RegSect ) {c=i; break;}
                                if (i==ftrk[EmuTable->VG.System&0x3][a].sex)
                                        goto OpNotFound;
                                b=((int)ftrk[EmuTable->VG.System&0x3][a].sec[c].flags & 0x3f) * 128;
                                if (b==0) goto OpNotFound;

                                LSeek(Handle[EmuTable->VG.System&0x3],
                                 (long)fdi[EmuTable->VG.System&0x3].data_offset +
                                 ftrk[EmuTable->VG.System&0x3][a].offs +
                                 ftrk[EmuTable->VG.System&0x3][a].sec[c].offs,0);

                                DskDataSize=b;
                                goto OpCom;
                         case 0xC: // Чтение адреса
                                DskIndex[0]=ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sec[SecNum].h;
                                //DskIndex[0]=(byte)((EmuTable->VG.System&0x10)>>4);
                                DskIndex[1]=ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sec[SecNum].r;
                                DskIndex[2]=ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sec[SecNum].n;
                                CRC=crc(DskIndex, 4, ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sec[SecNum].c);
                                DskIndex[3]=(byte)CRC;
                                DskIndex[4]=(byte)(CRC>>8);
                                if (++SecNum>ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sex) SecNum=0;
                                DskDataSize=5;
                                EmuTable->VG.RegData=1;
                                //EmuTable->VG.RegData=EmuTable->VG.TrackReal[EmuTable->VG.System&3];
                                //if (ReadIndexTrack) EmuTable->VG.RegData=EmuTable->VG.RegTrack;
                                if (ReadIndexTrack) EmuTable->VG.RegData=ftrk[EmuTable->VG.System&0x3][EmuTable->VG.TrackReal[EmuTable->VG.System&3]].sec[SecNum].c;
                                goto OpCom;
                         case 0xE: // Чтение дорожки
                                a=(EmuTable->VG.TrackReal[EmuTable->VG.System&3]<<1) | ((byte)((EmuTable->VG.System&0x10)>>4)^1);
                                DskDataSize=0;
                                for (i=0;i<ftrk[EmuTable->VG.System&0x3][a].sex;i++)
                                 {
                                 b=((int)ftrk[EmuTable->VG.System&0x3][a].sec[i].flags & 0x3f) * 128;
                                 //-------------- адресные маркеры
                                 for(j=0; j<50; j++) DiskBuf[DskDataSize++]=0x4e; //первый пробел
                                 for(j=0; j<12; j++) DiskBuf[DskDataSize++]=0x00;
                                 for(j=0; j<3; j++) DiskBuf[DskDataSize++]=0xa1; //часть синхроимпульса
                                 DiskBuf[DskDataSize++]=0xfe; //адресная метка
                                 DiskBuf[DskDataSize++]=ftrk[EmuTable->VG.System&0x3][a].sec[i].c;
                                 crcIndex=DskDataSize;
                                 DiskBuf[DskDataSize++]=ftrk[EmuTable->VG.System&0x3][a].sec[i].h;
                                 DiskBuf[DskDataSize++]=ftrk[EmuTable->VG.System&0x3][a].sec[i].r;
                                 DiskBuf[DskDataSize++]=ftrk[EmuTable->VG.System&0x3][a].sec[i].n;
                                 CRC=crc(&DiskBuf[crcIndex], 4, DiskBuf[crcIndex-1]);
                                 DiskBuf[DskDataSize++]=(byte)CRC;
                                 DiskBuf[DskDataSize++]=(byte)(CRC>>8);
                                 for(j=0; j<22; j++) DiskBuf[DskDataSize++]=0x4e; //второй пробел
                                 for(j=0; j<12; j++) DiskBuf[DskDataSize++]=0x00;
                                 for(j=0; j<3; j++) DiskBuf[DskDataSize++]=0xa1; //init crc
                                 DiskBuf[DskDataSize++]=0xfb; //пойдут данные:
                                 LSeek(Handle[EmuTable->VG.System&0x3],
                                  (long)fdi[EmuTable->VG.System&0x3].data_offset +
                                  ftrk[EmuTable->VG.System&0x3][a].offs +
                                  ftrk[EmuTable->VG.System&0x3][a].sec[i].offs,0);
                                 FileRead(&DiskBuf[DskDataSize],b,Handle[EmuTable->VG.System&0x3]);
                                 crcIndex=DskDataSize;
                                 DskDataSize+=b;
                                 CRC=crc(&DiskBuf[crcIndex+1], b, DiskBuf[crcIndex]);
                                 DiskBuf[DskDataSize++]=(byte)CRC;
                                 DiskBuf[DskDataSize++]=(byte)(CRC>>8);
                                 for(j=0; j<54; j++) DiskBuf[DskDataSize++]=0x4e;
                                 }
                                DskDataSize--;
                                EmuTable->VG.RegData=DiskBuf[0];
                                goto OpCom;
                         case 0xF: // Запись дорожки
                                goto OpWrProt;
                                /*
                                if (DskStatus&0x40) goto OpWrProt;
                                DskDataSize=FormatDatLen;
                                goto OpCom;
                                */
                        }
                };
                break;
         case 0x2: // Чтение номера дорожки
                EmuTable->VG.DataIO=EmuTable->VG.RegTrack;
                break;
         case 0x3: // Запись номера дорожки
                if (!(EmuTable->VG.RegStatus&0x01)) EmuTable->VG.RegTrack=EmuTable->VG.DataIO;
                break;
         case 0x4: // Чтение номера сектора
                EmuTable->VG.DataIO=EmuTable->VG.RegSect;
                break;
         case 0x5: // Запись номера сектора
                if (!(EmuTable->VG.RegStatus&0x01)) EmuTable->VG.RegSect=EmuTable->VG.DataIO;
                break;
         case 0x6: // Чтение данных
                if (EmuTable->VG.RegStatus&0x01) {
                        switch (EmuTable->VG.RegCom>>4) {
                         case 0x8:
                         case 0x9: // Чтение данных команды "Чтение сектора"
                                EmuTable->VG.DataIO=EmuTable->VG.RegData;
                                DskCountDatLost=0x10;
                                if (CntData<DskDataSize) EmuTable->VG.RegData=DiskBuf[0x01+CntData++];
                                else {
                                        if (EmuTable->VG.RegCom&0x10) {
                                                EmuTable->VG.RegSect++;
                                                goto OpReadSector;
                                        } else goto OpOk;
                                }
                                break;
                         case 0xC: // Чтение данных команды "Чтение адреса"
                                EmuTable->VG.DataIO=EmuTable->VG.RegData;
                                DskCountDatLost=0x10;
                                if (CntData<DskDataSize) EmuTable->VG.RegData=DskIndex[CntData++];
                                else goto OpOk;
                                break;
                         case 0xE: // Чтение данных команды "Чтение дорожки"
                                EmuTable->VG.DataIO=EmuTable->VG.RegData;
                                DskCountDatLost=0x10;
                                if (CntData<DskDataSize) EmuTable->VG.RegData=DiskBuf[0x01+CntData++];
                                else goto OpOk;
                                break;
                        }
                } else {
                        EmuTable->VG.DataIO=EmuTable->VG.RegData;
                };
                break;
         case 0x7: // Запись данных
                if (EmuTable->VG.RegStatus&0x01) {
                        switch (EmuTable->VG.RegCom>>4) {
                         case 0xA:
                         case 0xB: // Запись данных команды "Запись сектора"
                                DiskBuf[CntData++]=EmuTable->VG.RegData=EmuTable->VG.DataIO;
                                DskCountDatLost=0x10;
                                if (CntData>=DskDataSize) {
                                        FileSave(DiskBuf,DskDataSize,Handle[EmuTable->VG.System&0x3]);
                                        if (EmuTable->VG.RegCom&0x10) {
                                                EmuTable->VG.RegSect++;
                                                goto OpWriteSector;
                                        } else goto OpOk;
                                }
                                break;
                         /*
                         case 0xF: // Запись данных команды "Запись дорожки"
                                EmuTable->VG.RegData=EmuTable->VG.DataIO;
                                DskCountDatLost=0x10;
                                if (++CntData>=DskDataSize) {
                                        memset(DiskBuf,0,sizeof DiskBuf);
                                        if (DskStatus&0x04) {
                                                fseek(Str,DiskPosition(0),SEEK_SET);
                                                for (int i=0;i<0x10&&fwrite(DiskBuf,0x100,1,Str);i++);
                                        } else {
                                                if (!(Str=fopen(DskFileName,wbp))) goto OpOk;
                                                for (int i=0;i<0xA00&&fwrite(DiskBuf,0x100,1,Str);i++);
                                                DskStatus|=0x4;
                                        }
                                        goto OpOk;
                                }
                                break;
                        */
                        }
                } else {
                        EmuTable->VG.RegData=EmuTable->VG.DataIO;
                };
                break;
         case 0x8: {// Чтение сигналов Intrq и Drq
                unsigned char IntrqDrq=0xBF;
                if (EmuTable->VG.RegStatus&0x01) IntrqDrq=0x3F;
                if (EmuTable->VG.RegStatus&0x02) IntrqDrq=0x7F;
                EmuTable->VG.DataIO=IntrqDrq;
                break;
         }
         case 0x9: // Запись системного регистра контроллера дисководов
                if (EmuTable->VG.RegStatus&0x01&&EmuTable->VG.RegCom&0x80) goto OpContSum;
                EmuTable->VG.System=EmuTable->VG.DataIO;
                /*
                if ((EmuTable->VG.System^DskStatus)&0x03) {
                        DiskVG(0xB);
                        DiskVG(0xA);
                }
                */
                break;
         case 0xA: {// Инициализация диска
                /*
                if (DskStatus&0x80) return 1;
                DskStatus=(unsigned char)(EmuTable->VG.System&0x03);
                //DskFileName=EmuTable->Disks[DskStatus];
                //int Attr=GetFileAttr(DskFileName);
                int Attr=ReadOnly[DskStatus];
                DskStatus|=(unsigned char)((Attr)<<6);
                DskStatus|=0x04;
                DskStatus|=0x80;
                */
                /*
                if (Attr!=-1) {
                        Attr&=0x01;
                        DskStatus|=(Attr)<<6;
                        const char *AcsS=rbp;
                        if (Attr) AcsS=rb;
                        if (Str=fopen(DskFileName,AcsS)) DskStatus|=0x04;
                }
                DskStatus|=0x80;
                */
                break;
         }
         case 0xB: // Снятие диска
         /*
                if (!(DskStatus&0x80)) return;
                if (DskStatus&0x04) fclose(Str);
                DskStatus=0x00;
         */
                break;
         case 0xC: // Reset ВГ93
                EmuTable->VG.RegStatus=0x24;
                EmuTable->VG.RegCom=0x00;
                EmuTable->VG.RegTrack=0x00;
                EmuTable->VG.RegSect=0x01;
                EmuTable->VG.RegData=0x00;
                EmuTable->VG.System=0x3C;
                EmuTable->VG.StepDirect=0xFF;
                /*
                if (DskStatus&0x80&&DskStatus&0x03) {
                        DiskVG(0xB);
                        DiskVG(0xA);
                }
                */
                break;
        }
        return 1;
        OpOk: // Успешное завершение
                EmuTable->VG.RegStatus=0x00;
                return 1;
        OpWrProt: // Защита записи
                EmuTable->VG.RegStatus=0x40;
                return 1;
        OpNotFound: // Сектор не найден
                EmuTable->VG.RegStatus=0x10;
                return 1;
        OpContSum: // Ошибка контрольной суммы
                EmuTable->VG.RegStatus=0x08;
                return 1;
        OpCom: // Старт команды
                DskCountDatLost=0x00;
                CntData=0x0000;
                EmuTable->VG.RegStatus=0x03;
                if (!Ready) {
                        EmuTable->VG.RegStatus=0x01;
                        CntReady=0x10;
                }
                return 1;
}

/*
void DiskVG(byte Oper) {
        EmuTable->VG.OperIO=Oper;
        if (Oper==0xA) ChDir(DskPth);
        if (PrFirst[P_VG_]) {
                Proc *PPnt=PrFirst[P_VG_];
                do if (((unsigned char(__pragma("ProgVG") *)())PPnt->Pr)()) goto ExitP;
                while (PPnt=PPnt->Next);
        }
        DskVG();
        ExitP:
        if (Oper==0xA) ChDir(StPth);
        CallAddition(PrFirst[P_VGP]);
}
*/

static void WorkMenu()
{
    int Result=-1;
    char i;

    if ( DiskBuf == 0 )
    {
        EmuTable->TextMode();
        EmuTable->MessageBox(0x4f,"Error: Can't allocate startup memory","");
        EmuTable->SpecMode();
        return;
    }

    EmuTable->TextMode();

    void *Pnt=EmuTable->WinCreate(4,2,70,21,0x9F);
    EmuTable->WinHelp(Pnt,62,5,"FDI - disk images originaly supported by UKV emulator.");

    EmuTable->WinTitle(Pnt,_DSC,0xF0);

    EmuTable->WinText(Pnt,3,2,"(c) Alex Baskakov. Voronezh, Russia, 2000. FidoNet: 2:5025/3.55");
    EmuTable->WinText(Pnt,6,3,"Based on sources by: Sergey Erokhin/ESL, Nikolay Shalaev");

    EmuTable->WinText(Pnt,56,5,"Read Only");
    EmuTable->SetCheckBox(Pnt,56,6,"Disk A",&ReadOnly[0]);
    EmuTable->SetCheckBox(Pnt,56,9,"Disk B",&ReadOnly[1]);
    EmuTable->SetCheckBox(Pnt,56,12,"Disk C",&ReadOnly[2]);
    EmuTable->SetCheckBox(Pnt,56,15,"Disk D",&ReadOnly[3]);

    void *TxtPntD=EmuTable->SetInputTxt(Pnt,4,14,35,"Drive \1D",&CtFileName[3]);
    void *TxtPntC=EmuTable->SetInputTxt(Pnt,4,11,35,"Drive \1C",&CtFileName[2]);
    void *TxtPntB=EmuTable->SetInputTxt(Pnt,4,8,35,"Drive \1B",&CtFileName[1]);
    void *TxtPntA=EmuTable->SetInputTxt(Pnt,4,5,35,"Drive \1A",&CtFileName[0]);

    EmuTable->SetButton(Pnt,41,15,TxtBrowse,12,5);
    EmuTable->SetButton(Pnt,41,12,TxtBrowse,12,4);
    EmuTable->SetButton(Pnt,41,9,TxtBrowse,12,3);
    EmuTable->SetButton(Pnt,41,6,TxtBrowse,12,2);

    EmuTable->SetButton(Pnt,39,18,TxtCancel,12,0);
    EmuTable->SetButton(Pnt,23,18,TxtOk,12,1);

    while ( (Result != 0) && (Result != 1) )
    {
        Result=EmuTable->WinExe(Pnt);
        switch(Result)
        {
        case 2: GetPath(FileName[0],Path[0]);
                EmuTable->FileBox(TxtPntA,"*.fdi",Path[0]); break;
        case 3: GetPath(FileName[1],Path[1]);
                EmuTable->FileBox(TxtPntB,"*.fdi",Path[1]); break;
        case 4: GetPath(FileName[2],Path[2]);
                EmuTable->FileBox(TxtPntC,"*.fdi",Path[2]); break;
        case 5: GetPath(FileName[3],Path[3]);
                EmuTable->FileBox(TxtPntD,"*.fdi",Path[3]); break;
        }
        EmuTable->WinResult(Pnt);
    }

    for(i=0;i<4;i++) if ((Path[i][0])&&(FileName[i][0])) MakeFullName(FileName[i],Path[i]);

    EmuTable->WinRemove(Pnt);
    if ( Result == 1 ) //OK button
    {
        for(i=0;i<4;i++)
        {
           if (Handle[i])
              {
              LSeek(Handle[i],3,0);
              FileSave(&ReadOnly[i],1,Handle[i]);
              FileClose(Handle[i]);
              FreeFDIMem(i);
              Handle[i]=0;
              }
           if (FileName[i][0]!=0) if (!OpenFDI(i)) Handle[i]=0;
        }
    }
    EmuTable->SetSpec();
}

void _INS(void) {
        int i,j,drive=0;

        for(i=1; i<EmuTable->ArgC; i++)
        if ((EmuTable->ArgV[i][1]=='F')||(EmuTable->ArgV[i][1]=='f'))
        if (EmuTable->ArgV[i][0]=='-')
        {
        j=2;
        while (EmuTable->ArgV[i][j])
              {
              FileName[drive][j-2]=EmuTable->ArgV[i][j];
              j++;
              }
        while (j<PATHLEN) FileName[drive][j++]=0;
        drive++;
        if (drive==4) break;
        }

        for(i=0; i<4; i++)
        {
        Handle[i]=0;
        if (FileName[i][0]!=0) if (!OpenFDI((char)i)) Handle[i]=0;
        }

}

void _INI(EmuData *Pnt,unsigned IdN) {
        EmuTable=Pnt;
        Id=IdN;
        DiskBuf=(byte *)EmuTable->MemAlloc(16384);
}

void _UNI() {
    if (DiskBuf) EmuTable->MemFree(DiskBuf);
    for(char i=0; i<4; i++) if (Handle[i])
                     {
                     FileClose(Handle[i]);
                     FreeFDIMem(i);
                     Handle[i]=0;
                     }
}

void _F7_() {if (Key==0) WorkMenu();}
void _F8_() {if (Key==1) WorkMenu();}
void _F9_() {if (Key==2) WorkMenu();}
void _F10() {if (Key==3) WorkMenu();}
void _F11() {if (Key==4) WorkMenu();}
void _F12() {if (Key==5) WorkMenu();}
//////////////////////////////////////////////////////////////////////////////
//                        00:10:52 24.03.00 Alex Baskakov, 2:5025/3.55@FidoNet