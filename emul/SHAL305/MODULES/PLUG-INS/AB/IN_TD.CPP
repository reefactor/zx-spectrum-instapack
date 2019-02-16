/****************************************************************************

                           TeleDisk Support v0.01

Copyright 2000 Alex Baskakov aka RAIN, 2:5025/3.55, alex_baskakov@newmail.ru

****************************************************************************/
#pragma pack(1)
#define PATHLEN 256
#include "emudata.h"
#include "tdx.h"

byte *DiskBuf;

static char FileName[4][PATHLEN];
static char prevFileName[4][PATHLEN];
static char Path[4][PATHLEN];
unsigned Handle[4]={0,0,0,0};
static char tdFileName[PATHLEN];
byte memErr=0;

//unsigned FormatDatLen=0x1;
unsigned Ready=0x1;
unsigned ReadIndexTrack=0x1;

static byte DskIndex[5]={0,0,0,0,0};

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
    "mov ax,0x3d00"\
    "xor ecx,ecx"\
    "int 0x21"\
    "jnc $"\
    "xor eax,eax"\
    "$:"\
    modify [eax ecx] parm [edx] value [eax]
// Создание файла
/*
unsigned FileCreate(char *Name);
#pragma aux FileCreate=\
    "mov ah,0x3C"\
    "xor ecx,ecx"\
    "int 0x21"\
    modify [eax ecx] parm [edx] value [eax]
*/
// Чтение файла
unsigned FileRead(void *Buf,unsigned Size,unsigned Handle);
#pragma aux FileRead=\
    "mov ah,0x3f"\
    "int 0x21"\
    "jnc $"\
    "xor eax,eax"\
    "$:"\
    modify [eax] parm [edx][ecx][ebx] value [eax]
// Запись файла
/*
void FileSave(void *Buf,unsigned Size,unsigned Handle);
#pragma aux FileSave=\
    "mov ah,0x40"\
    "int 0x21"\
    modify [eax] parm [edx][ecx][ebx]
*/
// Закрытие файла
void FileClose(unsigned Handle);
#pragma aux FileClose=\
    "mov ah,0x3E"\
    "int 0x21"\
    modify [eax] parm [ebx]
// SEEK файла
/*
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
*/
EmuData *EmuTable;
unsigned Id;

// Описание
char _DSC[]=".TD Support v0.01";

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
    TTbl,"TeleDisk_Key=",&CgKey,
    TTxt,"TeleDisk_A=",&CtFileName[0],
    TTxt,"TeleDisk_B=",&CtFileName[1],
    TTxt,"TeleDisk_C=",&CtFileName[2],
    TTxt,"TeleDisk_D=",&CtFileName[3]
};

struct CfgDat _CFG={Cfg,sizeof Cfg/sizeof(CfgS)}; // Данные о конфигурации

/*--------------------------FDI Header------------------------*/
/*
struct _fdi_head{
        char sig[3];
        unsigned char read_only;
        unsigned short cyl_count;
        unsigned short sides_count;
        unsigned short text_offset;
        unsigned short data_offset;
        unsigned short extra_size;
};
*/
struct _sec_head{
        unsigned char c,h,r,n;
        unsigned char flags;
        byte* offs;
};

struct _trk_head{
//        long offs;
//        unsigned short reserved;
        unsigned char sex;
        struct _sec_head *sec;
};

//struct _fdi_head fdi[4];
struct _trk_head *ftrk[4];

//--------------------------------------------------------------------teledisk
void tdxAlloc(void)
{
if ( (text_buf = (byte*) EmuTable->MemAlloc(sizeof(byte) * (N+F-1))) == 0 ) memErr++;
if ( (freq = (word*) EmuTable->MemAlloc(sizeof(word) * (T+1))) == 0 ) memErr++;
if ( (prnt = (short*) EmuTable->MemAlloc(sizeof(short) * (T+N_CHAR))) == 0 ) memErr++;
if ( (son = (short*) EmuTable->MemAlloc(sizeof(short) * T)) == 0 ) memErr++;
if ( (tmpBuf = (u8 *)EmuTable->MemAlloc(2*257+F)) == 0 ) memErr++;
if ( (packedSec = (u8 *)EmuTable->MemAlloc(0x4002)) == 0 ) memErr++;
if ( (readCache = (u8 *)EmuTable->MemAlloc(32768)) == 0 ) memErr++;
}

bool isPacked;
ImageHdr imgHdr;
word noTrks;
unsigned td; //handle

// функция копирования блока памяти
void CopyMemory(void *Destination,  void *Source, dword Length);
#pragma aux CopyMemory = \
  " mov eax,ecx " \
  " shr ecx,2   " \
  " rep movsd   " \
  " mov ecx,eax " \
  " and ecx,3   " \
  " rep movsb   " \
  parm [edi][esi][ecx] modify [eax esi edi ecx];

extern  void    movefwd(char *dst, char *src, unsigned len);
#pragma aux     movefwd =  \
        0x06            /* push es   */\
        0x8e 0xc2       /* mov es,dx */\
        0x51            /* push ecx  */\
        0xc1 0xe9 0x02  /* shr ecx,2 */\
        0xf3 0xa5       /* rep movsd */\
        0x59            /* pop ecx   */\
        0x83 0xe1 0x03  /* and ecx,3 */\
        0xf3 0xa4       /* rep movsb */\
        0x07            /* pop es    */\
        parm [dx edi] [esi] [ecx] \
        modify exact [edi esi ecx];
extern  void    movebwd(char *dst, char *src, unsigned len);
#pragma aux     movebwd =  \
        0x06            /* push es */\
        0x8e 0xc2       /* mov es,dx */\
        0xfd            /* std */\
        0x4e            /* dec esi */\
        0x4f            /* dec edi */\
        0xd1 0xe9       /* shr ecx,1 */\
        0x66 0xf3 0xa5  /* rep movsw */\
        0x11 0xc9       /* adc ecx,ecx */\
        0x46            /* inc esi */\
        0x47            /* inc edi */\
        0x66 0xf3 0xa4  /* rep movsb */\
        0x07            /* pop es */\
        0xfc            /* cld */\
        parm [dx edi] [esi] [ecx] \
        modify exact [edi esi ecx];

void MoveMemory(char *to, char *from, dword len )
{
        if( from == to ) {
            return;
        }
        if( from < to  &&  from + len > to ) {  /* if buffers are overlapped*/
            movebwd(( to + len ) - 1, ( from + len ) - 1, len );
        } else {
            movefwd( to, from, len );
        }

}

u16 calculateCRC16(u8* buf, u16 size)
{
  u16 crc = 0;
  while(size--) crc = (crc>>8) ^ crcTab[(crc&0xff) ^ *buf++];
  return ((crc&0xff)<<8) | (crc>>8);
}

// переход к следующему тому
bool nextVolume(void)
{
  word i;
  FileClose(td);
  // меняем расширение
  for(i=0; i<PATHLEN; i++) if (!tdFileName[i]) {tdFileName[i-1]++; break;}
  td=FileOpen(tdFileName);
  if (td == 0) return false;

  ImageHdr tmpHdr;
  u32 tmp;

  tmp=FileRead(&tmpHdr,sizeof(ImageHdr),td);
  if(tmp != sizeof(ImageHdr)) return false;
  if(tmpHdr.crc == calculateCRC16((u8*)&tmpHdr, sizeof(ImageHdr)-2) &&
     tmpHdr.id[0]    == imgHdr.id[0] &&
     tmpHdr.id[1]    == imgHdr.id[1] &&
     tmpHdr.volumeId == imgHdr.volumeId &&
     tmpHdr.volume   == imgHdr.volume + 1)
  {
    CopyMemory(&imgHdr, &tmpHdr, sizeof(ImageHdr));
    return true;
  }
  else
  {
    FileClose(td);
    return false;
  }
}

bool readBlock(u8* buf, u16 size, u16* realSize)
{
  while(1)
  {
    *realSize=FileRead(buf, size, td);
    if(*realSize == size)
      return true;
    else
    {
      buf += *realSize;
      size -= *realSize;
      if(!nextVolume()) return false;
    }
  }
}

word readCacheIndex;
word readCacheLen;

/*
short readChar(void)
{
  u8 b;
  if(readBlock((u8*)&b, 1))
    return b;
  else
    return -1;
}
*/

short readChar(void)
{
  if (readCacheIndex==readCacheLen)
  {
  readBlock((u8*)readCache,32768UL,&readCacheLen);
  if (readCacheLen)
       {
       readCacheIndex=1;
       return readCache[0];
       }
  else
       {
       readCacheIndex=0;
       return -1;
       }
  }
  else return readCache[readCacheIndex++];
}

short r;

void StartHuff(void)
{
  short i, j;

  for (i = 0; i < N_CHAR; i++) {
    freq[i] = 1;
    son[i] = i + T;
    prnt[i + T] = i;
  }
  i = 0; j = N_CHAR;
  while (j <= R) {
    freq[j] = freq[i] + freq[i + 1];
    son[j] = i;
    prnt[i] = prnt[i + 1] = j;
    i += 2; j++;
  }
  freq[T] = 0xffff;
  prnt[R] = 0;

  for (i = 0; i < N - F; i++) text_buf[i] = ' ';
  r = N - F;
}

u16 getbuf;
u8  getlen;

short GetBit(void)      /* get one bit */
{
  short i;

  while(getlen <= 8)
  {
    if((i = readChar()) == -1) i = 0;
    getbuf |= i << (8 - getlen);
    getlen += 8;
  }
  i = getbuf;
  getbuf <<= 1;
  getlen--;
  return (i < 0);
}

short GetByte(void)     /* get one byte */
{
  unsigned i;

  while (getlen <= 8)
  {
    if((i = readChar()) == -1) i = 0;
    getbuf |= i << (8 - getlen);
    getlen += 8;
  }
  i = getbuf;
  getbuf <<= 8;
  getlen -= 8;
  return i >> 8;
}

/* reconstruction of tree */
void reconst(void)
{
  short i, j, k;
  u16 f, l;

  /* collect leaf nodes in the first half of the table */
  /* and replace the freq by (freq + 1) / 2. */
  j = 0;
  for(i = 0; i < T; i++)
  {
    if(son[i] >= T)
    {
      freq[j] = (freq[i] + 1) / 2;
      son[j] = son[i];
      j++;
    }
  }
  /* begin constructing tree by connecting sons */
  for(i = 0, j = N_CHAR; j < T; i += 2, j++)
  {
    k = i + 1;
    f = freq[j] = freq[i] + freq[k];
    for(k = j - 1; f < freq[k]; k--);
    k++;
    l = (j - k) * 2;
    MoveMemory((char *)&freq[k + 1], (char *)&freq[k], l);
    freq[k] = f;
    MoveMemory((char *)&son[k + 1], (char *)&son[k], l);
    son[k] = i;
  }
  /* connect prnt */
  for (i = 0; i < T; i++)
  {
    if ((k = son[i]) >= T)
    {
      prnt[k] = i;
    }
    else
    {
      prnt[k] = prnt[k + 1] = i;
    }
  }
}

/* increment frequency of given code by one, and update tree */

void update(int c)
{
  short i, j, k, l;

  if(freq[R] == MAX_FREQ) reconst();

  c = prnt[c + T];
  do
  {
    k = ++freq[c];

    /* if the order is disturbed, exchange nodes */
    if (k > freq[l = c + 1])
    {
      while (k > freq[++l]);
      l--;
      freq[c] = freq[l];
      freq[l] = k;

      i = son[c];
      prnt[i] = l;
      if (i < T) prnt[i + 1] = l;

      j = son[l];
      son[l] = i;

      prnt[j] = c;
      if (j < T) prnt[j + 1] = c;
      son[c] = j;

      c = l;
    }
  }while ((c = prnt[c]) != 0);  /* repeat up to root */
}

int DecodeChar(void)
{
  u16 c;

  c = son[R];

  /* travel from root to leaf, */
  /* choosing the smaller child node (son[]) if the read bit is 0, */
  /* the bigger (son[]+1} if 1 */
  while(c < T)
  {
    c += GetBit();
    c = son[c];
  }
  c -= T;
  update(c);
  return c;
}

int DecodePosition(void)
{
  u16 i, j, c;

  /* recover upper 6 bits from table */
  i = GetByte();
  c = (u16)d_code[i] << 6;
  j = d_len[i];

  /* read lower 6 bits verbatim */
  j -= 2;
  while (j--)
  {
    i = (i << 1) + GetBit();
  }
  return c | (i & 0x3f);
}

u16 unLZH_internal(u8* buf, u16 textsize)
{
  short  i, j, k, c;
  u16  count;

  for(count = 0; count < textsize; )
  {
    c = DecodeChar();
    if(c < 256)
    {
      *buf++ = c;
      text_buf[r++] = c;
      r &= (N - 1);
      count++;
    }
    else
    {
      i = (r - DecodePosition() - 1) & (N - 1);
      j = c - 255 + THRESHOLD;
      for (k = 0; k < j; k++)
      {
        c = text_buf[(i + k) & (N - 1)];
        *buf++ = c;
        text_buf[r++] = c;
        r &= (N - 1);
        count++;
      }
    }
  }
  return count;
}

u16 oldSize;
u8* oldPtr;

bool unLZH(u8* buf, u16 size)
{
  if(oldSize < size)
  {
    u16 realSize = unLZH_internal(oldPtr, size);
    oldSize += realSize;
  }
  CopyMemory(buf, tmpBuf, size);
  oldSize -= size;
  MoveMemory((char *)tmpBuf, (char *) (tmpBuf+size), oldSize);
  oldPtr = tmpBuf+oldSize;

  return true;
}

bool read(u8* buf, u16 size)
{
  u16 noUseForThisVariable;
  if(isPacked)
   return unLZH(buf, size);
  else
    return readBlock(buf, size, &noUseForThisVariable);
}

//----------------------------------------------------------------------plugin
void _SET() {

    if (memErr)
    {
        EmuTable->TextMode();
        EmuTable->MessageBox(0x4f,"Error: Can't allocate startup memory","");
        EmuTable->SpecMode();
        return;
    }

    void *Pnt=EmuTable->WinCreate(29,4,23,17,0x8F);
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
    int i,j;
    if ( ftrk[DriveNumber] )
    {
        for(i=0; i<166; i++) if (ftrk[DriveNumber][i].sec)
        {
        for(j=0; j<ftrk[DriveNumber][i].sex; j++) EmuTable->MemFree(ftrk[DriveNumber][i].sec[j].offs);
        EmuTable->MemFree(ftrk[DriveNumber][i].sec);
        }
        EmuTable->MemFree(ftrk[DriveNumber]);
        ftrk[DriveNumber]=0;
    }
}

int OpenTD(char DriveNumber)
{
//  int i;
  int err=0;
  bool result = false;

//  EmuTable->MessageBox(0x4f,"Opening file: ",FileName[DriveNumber]);

  if ( (td = FileOpen(FileName[DriveNumber])) == 0 )
           {
           EmuTable->MessageBox(0x4f,"Error Open File:",FileName[DriveNumber]);
           return 0;
           }

  u32 realSize;
  realSize=FileRead(&imgHdr, sizeof(struct ImageHdr), td);

  //check version
  if(imgHdr.crc != calculateCRC16((u8*)&imgHdr, sizeof(ImageHdr)-2)) return false;
  if(imgHdr.version < 10 || imgHdr.version > 21) return false;
  while(1) {
  if(imgHdr.id[0] == 't' && imgHdr.id[1] == 'd' && imgHdr.version >= 20) break;
  if(imgHdr.id[0] == 'T' && imgHdr.id[1] == 'D') break;
  return false;
  }

  isPacked = false;
  if(imgHdr.id[0] == 't' && imgHdr.id[1] == 'd')
  {
    StartHuff();
    isPacked = true;
  }

  oldSize = 0;
  oldPtr = tmpBuf;
  getbuf = 0;
  getlen = 0;
  noTrks = 0;

  void *Pnt=EmuTable->WinCreate(14,10,54,7,0x78);
  EmuTable->WinTitle(Pnt,"Unpacking",0xF0);
  EmuTable->WinText(Pnt,2,2,"Head: 0 ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙");
  EmuTable->WinText(Pnt,2,3,"Head: 1 ∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙");
  EmuTable->WinText(Pnt,2,4,"        ┌┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬┬");
  EmuTable->WinText(Pnt,2,5,"Cylinder│0       │20       │40       │60       │80");

  readCacheIndex=readCacheLen=0;

  if(imgHdr.trk_den & 0x80)
  {
    ImageInfo info;
    /*
    if ( (info.text=(char *)EmuTable->MemAlloc(0x248) )==0 ) {
           EmuTable->MessageBox(0x4f,"Can't allocate memory for image info!","");
           return 0;
           }
    */
    read((u8*)&info, 10);
    read((u8*)&info.text[0], info.textSize);
    if(info.crc != calculateCRC16((u8*)&info.textSize, info.textSize+8)) goto error;
  }

    if ( (ftrk[DriveNumber] = (_trk_head*) EmuTable->MemAlloc(sizeof(struct _trk_head) * 166UL * imgHdr.noSides)) == 0 ) {
           EmuTable->MessageBox(0x4f,"Can't allocate memory for track header!","");
           return 0;
           }

  while(1)
  {
    TrkHdr trkHdr;
    u16 trkNum;
    read((u8*)&trkHdr, sizeof(TrkHdr));
    if(trkHdr.noSecs == 0xFF) break;
    if(trkHdr.crc != (u8)calculateCRC16((u8*)&trkHdr, sizeof(TrkHdr)-1)) goto error;

    trkNum = trkHdr.cyl<<1 | trkHdr.head;
    ftrk[DriveNumber][trkNum].sex=trkHdr.noSecs;
    if ( (ftrk[DriveNumber][trkNum].sec = (_sec_head*) EmuTable->MemAlloc(sizeof(struct _sec_head) * trkHdr.noSecs)) == 0 ) {
           EmuTable->MessageBox(0x4f,"Can't allocate memory for sector headers!","");
           return 0;
           }

    //progress bar
    EmuTable->WinText(Pnt,10+(trkHdr.cyl>>1),2+trkHdr.head,trkHdr.cyl&1?"█":"▌");

    for(int s = trkHdr.noSecs; s > 0; --s)
    {
      SecHdr secHdr;
      read((u8*)&secHdr, sizeof(SecHdr));
      u16 crc = calculateCRC16((u8*)&secHdr, sizeof(SecHdr)-1);
      if((!(secHdr.type & 0xF8)) == (!(secHdr.flag & 0x30)))
      {
        short secSize;
        read((u8*)&secSize, sizeof(secSize));
        read(packedSec, secSize);
        //u8* sec = imageBuf + sectorSize*(16*trkNum + secHdr.num-1);

        ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].c=secHdr.cyl;
        ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].h=secHdr.head;
        ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].r=secHdr.num;
        ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].n=secHdr.type;
        if ( (ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].offs = (byte *) EmuTable->MemAlloc((1<<secHdr.type)*128UL)) == 0 ) {
           EmuTable->MessageBox(0x4f,"Can't allocate memory for sector data!","");
           return 0;
           }
        u8* sec=ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].offs;
        ftrk[DriveNumber][trkNum].sec[trkHdr.noSecs-s].flags=(1<<secHdr.type);

        //if(secHdr.num > 0 && secHdr.num < 17 && secHdr.type == 1)
        //{
        //masks[trkNum] |= 1<<(secHdr.num-1);
          switch(packedSec[0])
          {
            case 0:
                      CopyMemory(sec, packedSec+1, secSize-1);
                      break;
            case 1:
                      {
                        u16 noWords = *(u16*)(packedSec+1);
                        u8 lo = packedSec[3];
                        u8 hi = packedSec[4];
                        for(u16 i = 0; i < noWords; ++i)
                        {
                          sec[2*i]   = lo;
                          sec[2*i+1] = hi;
                        }
                      }
                      break;
            case 2:
                      {
                        u8* from = packedSec+1;
                        u8* to = sec;
                        secSize--;
                        do
                        {
                          u8 type = *from++;
                          --secSize;
                          if(type == 0)
                          {
                            u8 noBytes = *from++;
                            --secSize;
                            secSize -= noBytes;
                            while(noBytes--) *to++ = *from++;
                          }
                          if(type == 1)
                          {
                            u8 noWords = *from++;
                            --secSize;
                            u8 lo = *from++;
                            u8 hi = *from++;
                            secSize -= 2;
                            while(noWords--)
                            {
                              *to++ = lo;
                              *to++ = hi;
                            }
                          }
                          if(type > 1) goto error;
                        } while(secSize > 0);
                      }
                      break;
            default:
                      goto error;
          }
        //}
        crc = calculateCRC16(sec, (1<<secHdr.type)*128UL);

      }
      if(secHdr.crc != (u8)crc) goto error;
    }
    noTrks++;
    if(noTrks >= 166) break;
  }
  result = true;
error:
  FileClose(td);
  EmuTable->WinRemove(Pnt);
  DskStatus=0xc4;
  Handle[DriveNumber]=1;
  return result;
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

                                /*
                                LSeek(Handle[EmuTable->VG.System&0x3],
                                 (long)fdi[EmuTable->VG.System&0x3].data_offset +
                                 ftrk[EmuTable->VG.System&0x3][a].offs +
                                 ftrk[EmuTable->VG.System&0x3][a].sec[c].offs,0);
                                FileRead(DiskBuf,b,Handle[EmuTable->VG.System&0x3]);
                                */
                                CopyMemory(DiskBuf,ftrk[EmuTable->VG.System&0x3][a].sec[c].offs,b);

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
                                goto OpWrProt;
                                //if (DskStatus&0x40) goto OpWrProt;
                                /*
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
                                */
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
                                 /*
                                 LSeek(Handle[EmuTable->VG.System&0x3],
                                  (long)fdi[EmuTable->VG.System&0x3].data_offset +
                                  ftrk[EmuTable->VG.System&0x3][a].offs +
                                  ftrk[EmuTable->VG.System&0x3][a].sec[i].offs,0);
                                 FileRead(&DiskBuf[DskDataSize],b,Handle[EmuTable->VG.System&0x3]);
                                 */
                                 CopyMemory(&DiskBuf[DskDataSize],ftrk[EmuTable->VG.System&0x3][a].sec[i].offs,b);
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
                         /*
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
    char i,reopen; int j;

    if ( DiskBuf == 0 )
    {
        EmuTable->TextMode();
        EmuTable->MessageBox(0x4f,"Error: Can't allocate startup memory","");
        EmuTable->SpecMode();
        return;
    }

    EmuTable->TextMode();

    void *Pnt=EmuTable->WinCreate(4,2,70,21,0x8F);
    EmuTable->WinHelp(Pnt,66,5,".TD - disk images originaly supported by TeleDisk utility.");

    EmuTable->WinTitle(Pnt,_DSC,0xF0);

    EmuTable->WinText(Pnt,3,2,"(c) Alex Baskakov. Voronezh, Russia, 2000. FidoNet: 2:5025/3.55");
    EmuTable->WinText(Pnt,6,3,"Based on sources by: HalfElf, ESL, Nikolay Shalaev, Sybase");

    EmuTable->WinText(Pnt,56,5,"Read Only");
    EmuTable->WinText(Pnt,56,6,"[X] Disk A");
    EmuTable->WinText(Pnt,56,9,"[X] Disk B");
    EmuTable->WinText(Pnt,56,12,"[X] Disk C");
    EmuTable->WinText(Pnt,56,15,"[X] Disk D");

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
                EmuTable->FileBox(TxtPntA,"*.td?",Path[0]); break;
        case 3: GetPath(FileName[1],Path[1]);
                EmuTable->FileBox(TxtPntB,"*.td?",Path[1]); break;
        case 4: GetPath(FileName[2],Path[2]);
                EmuTable->FileBox(TxtPntC,"*.td?",Path[2]); break;
        case 5: GetPath(FileName[3],Path[3]);
                EmuTable->FileBox(TxtPntD,"*.td?",Path[3]); break;
        }
        EmuTable->WinResult(Pnt);
    }

    for(i=0;i<4;i++) if ((Path[i][0])&&(FileName[i][0])) MakeFullName(FileName[i],Path[i]);

    EmuTable->WinRemove(Pnt);
    if ( Result == 1 ) //OK button
    {
        for(i=0;i<4;i++)
        {
           if (FileName[i][0]!=0)
           {
           j=0;
           if (prevFileName[i][j]) reopen=0; else reopen=1;
           while (FileName[i][++j])
           if (prevFileName[i][j]!=FileName[i][j]) reopen=1;

           if (reopen)
              {
              if (Handle[i])
                 {
                 FreeFDIMem(i);
                 Handle[i]=0;
                 }
              CopyMemory(prevFileName[i],FileName[i],255);
              if (!OpenTD(i)) Handle[i]=0;
              }
           }
        }
    }
    EmuTable->SetSpec();
}

void _INS(void) {
        int i,j,drive=0;

        for(i=0; i<4; i++) prevFileName[i][0]=0;
        for(i=1; i<EmuTable->ArgC; i++)
        if ((EmuTable->ArgV[i][1]=='T')||(EmuTable->ArgV[i][1]=='t'))
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
        if (FileName[i][0]!=0) if (!OpenTD((char)i)) Handle[i]=0; else CopyMemory(prevFileName[i],FileName[i],255);

        }

}

void _INI(EmuData *Pnt,unsigned IdN) {
        EmuTable=Pnt;
        Id=IdN;
        DiskBuf=(byte *)EmuTable->MemAlloc(16384);
        tdxAlloc();
}

void _UNI() {
    if (DiskBuf) EmuTable->MemFree(DiskBuf);
    if (text_buf) EmuTable->MemFree(text_buf);
    if (freq) EmuTable->MemFree(freq);
    if (prnt) EmuTable->MemFree(prnt);
    if (son) EmuTable->MemFree(son);
    if (tmpBuf) EmuTable->MemFree(tmpBuf);
    if (packedSec) EmuTable->MemFree(packedSec);
    if (readCache) EmuTable->MemFree(readCache);
    for(char i=0; i<4; i++) if (Handle[i])
                     {
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
//                        23:54:20 23.03.00 Alex Baskakov, 2:5025/3.55@FidoNet