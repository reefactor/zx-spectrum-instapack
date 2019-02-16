/******************************************/
/**                                      **/
/**           X128_T PC C Version        **/
/**                                      **/
/**          (C) James McKay 1996        **/
/**                                      **/
/**    This software may not be used     **/
/**    for commercial reasons, the code  **/
/**    may not be modified or reused     **/
/**    without permission.               **/
/**                                      **/
/******************************************/
/**                                      **/
/** Special Guest Stars :                **/
/**                                      **/
/**  Marat Fayzullin 1995 (Unix,Ideas,AY)**/
/** Arnold Metselaar 1995 (More Unix)    **/
/******************************************/
#define MAIN_OBJ
#define NO_BUFFER
/* The H flag in the adc16 and sbc16 is assumed to be bit 12 of result */

/* Non Portable Includes */
#include <dos.h>
#include <conio.h>

#ifndef __BORLANDC__
#include <i86.h>
#endif

/* Crucial!!!! */
#include "x128_end.c" /* Has LSB/MSB info. */

#include "x128_var.c"

/* Prototypes */
#ifdef __cplusplus
    #define __CPPARGS ...
#else
    #define __CPPARGS
#endif

#define CRTC_ADDR       0x3d4   /* Base port of the CRT Controller (color) */
#define SEQU_ADDR       0x3c4   /* Base port of the Sequencer */
#define GRAC_ADDR       0x3ce   /* Base port of the Graphics Controller */

#ifdef __BORLANDC__
void interrupt (*IRQ1Old)(__CPPARGS);
#else
void (__interrupt _far *IRQ1Old)();
#endif

#ifndef OVERSCAN
#ifdef __BORLANDC__
void interrupt (*IRQtimeOld)(__CPPARGS);
#else
void (__interrupt _far *IRQtimeOld)();
#endif
#endif

void update_line(register UC linenum);
void clean_regs(void);
UC return_next_VOC_bit(void); /* In x128_voc.c */
void save_PSG(void);

/* Code */

/* Non Portable Vars and Defs */
#ifdef MSDOS_SYSTEM

#include "ay8910.h"

#ifndef OLD_NOISE

#include "x128_dsp.h"

#endif

#else
void PSGOut(UC R,UC V)
{
	PSG[R]=V;
}
#endif

void Sound_on(void)
{
#ifdef OLD_NOISE
	if(all_sound_on)
	{
		if(!model_48)
		{
			if(adlib_present)
			{
				ResumeSound();
			}
		}
		/* No need to switch on internal */
	}
#endif
}

void Sound_off(void)
{
#ifdef OLD_NOISE
	if(adlib_present)
	{
		MuteSound();
	}
	outp(0x61,inp(0x61)&0xFC);
#endif
}

#ifdef __BORLANDC__
unsigned long *SCREEN = (unsigned long *) MK_FP(0xA000,0); /* Very PC Specific! */
#else
unsigned long *SCREEN = (unsigned long *)0xA0000;
#endif

UC PCKey[59][2]= /* The rotten big map */

/*      Esc */
{{0,0},{0,0},
/*     1           2            3           4           5 */
{N1toN5,on0},{N1toN5,on1},{N1toN5,on2},{N1toN5,on3},{N1toN5,on4},
/*     0           9            8           7           6 */
{N0toN6,on4},{N0toN6,on3},{N0toN6,on2},{N0toN6,on1},{N0toN6,on0},
/* -     =    BS   TAB  */
{0,0},{0,0},{0,0},{0,0},
/*   Q          W         E           R         T     */
{QtoT,on0},{QtoT,on1},{QtoT,on2},{QtoT,on3},{QtoT,on4},
/*   P          O         I           U         Y     */
{PtoY,on4},{PtoY,on3},{PtoY,on2},{PtoY,on1},{PtoY,on0},
/* [    ]     Return    Sym Sh */
{0,0},{0,0},{EtoH,on0},{StoB,on1},
/*   A          S         D           F         G     */
{AtoG,on0},{AtoG,on1},{AtoG,on2},{AtoG,on3},{AtoG,on4},
/*   H          J         K           L     */
{EtoH,on4},{EtoH,on3},{EtoH,on2},{EtoH,on1},
/* ;    '      `   L Cap Sh     #  */
{0,0},{0,0},{0,0},{CtoV,on0},{0,0},
/*   Z          X         C           V     */
{CtoV,on1},{CtoV,on2},{CtoV,on3},{CtoV,on4},
/*   B          N         M        ,     .     /    R Cap Sh */
{StoB,on4},{StoB,on3},{StoB,on2},{0,0},{0,0},{0,0},{CtoV,on0},
/*PrS  ALT    Space     CapL */
{0,0},{0,0},{StoB,on0},{0,0}};

#ifndef OVERSCAN
/** A handler for the timer interrupt ************************/
#ifdef __BORLANDC__
void interrupt IRQtimeHandler(__CPPARGS)
#else
void __interrupt IRQtimeHandler(void)
#endif
{
	static UC in_use=0;

	if(in_use) return;
	in_use=1;
	/*_disable();*/
	int_50=1;
	outp(0x20,0x20);
	in_use=0;
	/*_enable();*/
}
#endif

/** A handler for the keyboard interrupt *********************/
#ifdef __BORLANDC__
void interrupt IRQ1Handler(__CPPARGS)
#else
void __interrupt IRQ1Handler(void)
#endif
{
  register UC Key, Key2;
  static UC c_shift=0; /* This is the host machines caps shift */
  static UC old_cs=0;

  _disable();
  Key=inp(0x60);
  Key2=Key&127;
  if(!(Key&128))
  {
	  switch(Key2)
	  {
		case 59: quit=QUIT_HELP;break;/* F1 */
		case 60: quit=QUIT_NMI;break; /* F2 */
		case 61: quit=QUIT_RESET;break;  /* F3 */
		case 62: quit=QUIT_JOY;break; /* F4 */
		case 63: quit=QUIT_LOAD;break;/* F5 */
		case 64: quit=QUIT_SAVE;break;/* F6 */
		case 65: quit=QUIT_TAP;break; /* F7 */
		case 66: if(c_shift)
			 {
				if(ULA_delay<255) ULA_delay++;
			 }
			 else
			 {
				quit=QUIT_VOC;
			 }
			 break;
		case 67: if(c_shift)
			 {
				if(ULA_delay) ULA_delay--;
			 }
			 break;
		case 68: quit=QUIT_COMPLETELY;break;
		case 87: quit=QUIT_SOUND;break; /* F11 */

		case  1: SKey[CtoV]&=on0;SKey[N1toN5]&=on0;break; /* Esc,Edit */
		case 12: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[N0toN6]&=on0;/* Underline*/
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[EtoH]&=on3;  /* Minus */
			 }
			 break;
		case 13: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[EtoH]&=on2;  /* Plus */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[EtoH]&=on1;  /* Equals */
			 }
			 break;
		case 14: SKey[CtoV]&=on0;SKey[N0toN6]&=on0;break; /* Bs,Delete*/
		case 15: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]&=on0;
					SKey[N0toN6]&=on0;break; /* Tab,Fire */
				case 1 : In31|=off4;break; /* Kempston Fire */
				case 2 : SKey[N1toN5]&=on4;break; /* 5 */
				case 3 : SKey[N0toN6]&=on0;break; /* 0 */
			 }
			 break;
		case 29: SKey[StoB]&=on1;break; /* Symbol Shift */
		case 39: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[CtoV]&=on1;/* Colon */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[PtoY]&=on1;  /* Semi Colon */
			 }
			 break;
		case 40: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[PtoY]&=on0;  /* Inverted Comma */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[N0toN6]&=on3;  /* Apostrophe */
			 }
			 break;
		case 42: SKey[CtoV]&=on0;c_shift=1;break; /* Caps Shift */
		case 51: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[QtoT]&=on3;/* Lesser Than */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[StoB]&=on3;  /* Comma */
			 }
			 break;
		case 52: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[QtoT]&=on4;  /* Greater Than */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[StoB]&=on2;  /* Full Stop */
			 }
			 break;
		case 53: if(c_shift)
			 {
				SKey[CtoV]|=off0;SKey[StoB]&=on1;SKey[CtoV]&=on3;  /* Query */
			 }
			 else
			 {
				SKey[StoB]&=on1;SKey[CtoV]&=on4;  /* Slash */
			 }
			 break;
		case 54: SKey[CtoV]&=on0;c_shift=1;break; /* Caps Shift */
		case 58: SKey[CtoV]&=on0;SKey[N1toN5]&=on1;break; /* CapsLock */
		case 72: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]&=on0;
					SKey[N0toN6]&=on3;break; /* Up Arrow */
				case 1 : In31|=off3;break; /* Kempston Up */
				case 2 : SKey[N1toN5]&=on3;break; /* 4 */
				case 3 : SKey[N0toN6]&=on1;break; /* 9 */
			 }
			 break;
		case 75: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]&=on0;
					SKey[N1toN5]&=on4;break; /* Left Arrow */
				case 1 : In31|=off1;break; /* Kempston Left */
				case 2 : SKey[N1toN5]&=on0;break; /* 1 */
				case 3 : SKey[N0toN6]&=on4;break; /* 6 */
			 }
			 break;
		case 77: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]&=on0;
					SKey[N0toN6]&=on2;break; /* Right Arrow */
				case 1 : In31|=off0;break; /* Kempston Right */
				case 2 : SKey[N1toN5]&=on1;break; /* 2 */
				case 3 : SKey[N0toN6]&=on3;break; /* 7 */
			 }
			 break;
		case 80: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]&=on0;
					SKey[N0toN6]&=on4;break; /* Down Arrow */
				case 1 : In31|=off2;break; /* Kempston Down */
				case 2 : SKey[N1toN5]&=on2;break; /* 3 */
				case 3 : SKey[N0toN6]&=on2;break; /* 8 */
			 }
			 break;
		default:
		if(Key2<59)
		{
			if(PCKey[Key2][1])
			{
				SKey[PCKey[Key2][0]]&=PCKey[Key2][1];
				/* Press the key */
			}
		}
		break;
	  }
  }
  else
  {
	switch(Key2)
	{
		case  1: SKey[CtoV]|=off0;SKey[N1toN5]|=off0;break; /* Esc,Edit */
		case 12: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[N0toN6]|=off0;SKey[CtoV]&=on0;/* Underline*/
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[EtoH]|=off3;  /* Minus */
			 }
			 break;
		case 13: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[EtoH]|=off2;SKey[CtoV]&=on0;  /* Plus */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[EtoH]|=off1;  /* Equals */
			 }
			 break;
		case 14: SKey[CtoV]|=off0;SKey[N0toN6]|=off0;break; /* Bs,Delete*/
		case 15: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]|=off0;
					SKey[N0toN6]|=off0;break; /* Tab,Fire */
				case 1 : In31&=on4;break; /* Kempston Fire */
				case 2 : SKey[N1toN5]|=off4;break; /* 5 */
				case 3 : SKey[N0toN6]|=off0;break; /* 0 */
			 }
			 break;
		case 29: SKey[StoB]|=off1;break; /* Symbol Shift */
		case 39: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[CtoV]|=off1;SKey[CtoV]&=on0;/* Colon */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[PtoY]|=off1;  /* Semi Colon */
			 }
			 break;
		case 40: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[PtoY]|=off0;SKey[CtoV]&=on0;  /* Inverted Comma */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[N0toN6]|=off3;  /* Apostrophe */
			 }
			 break;
		case 42: SKey[CtoV]|=off0;c_shift=0;break; /* Caps Shift */
		case 51: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[QtoT]|=off3;SKey[CtoV]&=on0;/* Lesser Than */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[StoB]|=off3;  /* Comma */
			 }
			 break;
		case 52: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[QtoT]|=off4;SKey[CtoV]&=on0;  /* Greater Than */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[StoB]|=off2;  /* Full Stop */
			 }
			 break;
		case 53: if(c_shift)
			 {
				SKey[StoB]|=off1;SKey[CtoV]|=off3;SKey[CtoV]&=on0;  /* Query */
			 }
			 else
			 {
				SKey[StoB]|=off1;SKey[CtoV]|=off4;  /* Slash */
			 }
			 break;
		case 54: SKey[CtoV]|=off0;c_shift=0;break; /* Caps Shift */
		case 58: SKey[CtoV]|=off0;SKey[N1toN5]|=off1;break; /* CapsLock */
		case 72: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]|=off0;
					SKey[N0toN6]|=off3;break; /* Up Arrow */
				case 1 : In31&=on3;break; /* Kempston Up */
				case 2 : SKey[N1toN5]|=off3;break; /* 4 */
				case 3 : SKey[N0toN6]|=off1;break; /* 9 */
			 }
			 break;
		case 75: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]|=off0;
					SKey[N1toN5]|=off4;break; /* Left Arrow */
				case 1 : In31&=on1;break; /* Kempston Left */
				case 2 : SKey[N1toN5]|=off0;break; /* 1 */
				case 3 : SKey[N0toN6]|=off4;break; /* 6 */
			 }
			 break;
		case 77: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]|=off0;
					SKey[N0toN6]|=off2;break; /* Right Arrow */
				case 1 : In31&=on0;break; /* Kempston Right */
				case 2 : SKey[N1toN5]|=off1;break; /* 2 */
				case 3 : SKey[N0toN6]|=off3;break; /* 7 */
			 }
			 break;
		case 80: switch(joy_type)
			 {
				case 0 :
					if(curs_caps) SKey[CtoV]|=off0;
					SKey[N0toN6]|=off4;break; /* Down Arrow */
				case 1 : In31&=on2;break; /* Kempston Down */
				case 2 : SKey[N1toN5]|=off2;break; /* 3 */
				case 3 : SKey[N0toN6]|=off2;break; /* 8 */
			 }
			 break;
		default:
		if(Key2<59)
		{
			if(PCKey[Key2][1])
			{
				SKey[PCKey[Key2][0]]|=~PCKey[Key2][1];
				/* Release the key */
			}
		}
		break;
	 }
  }
  outp(0x20,0x20);
  _enable();
}

#ifndef NO_BUFFER
#define RefreshScreen() memcpy(SCREEN,XBuf,61440);
#endif

void RePaintScreen(void)
{
	UC y;

	for(y=0;y<192;y++) update_line(y);
#ifndef NO_BUFFER
	RefreshScreen();
#endif
}

#ifndef OVERSCAN
void init_timer(void)
{
	unsigned long IFreq, Cmp;

	IFreq=50; /* Set frequency to 50hz */
	Cmp=1193180L/IFreq;
	_disable();
	IRQtimeOld=_dos_getvect(0x08);
	outp(0x43,0x36);outp(0x40,Cmp&0xFF);outp(0x40,(Cmp>>8)&0xFF);
	_dos_setvect(0x08,IRQtimeHandler);
	_enable();
}

void release_timer(void)
{
	_disable();
	_dos_setvect(0x08,IRQtimeOld); /* Restore timer IRQ   */
	outp(0x43,0x36); /* Set timer */
	outp(0x40,0x00); /* back to */
	outp(0x40,0x00); /* 18.2Hz */
	_enable();
}
#endif

void init_screen(void)
{
	UC x;
	union REGS R;

#ifdef __BORLANDC__
	R.x.ax=0x13;
	int86(0x10,&R,&R);
#else
	R.w.ax=0x13;
	int386(0x10,&R,&R);
#endif
	outp(0x3C8,0);
	for (x=0;x<16;x++)
	{
		outp(0x3C9,red[x]);
		outp(0x3C9,green[x]);
		outp(0x3C9,blue[x]);
	}
}

void release_screen(void)
{
	union REGS R;

#ifdef __BORLANDC__
	R.x.ax=0x03;
	int86(0x10,&R,&R);
#else
	R.w.ax=0x03;
	int386(0x10,&R,&R);
#endif
}

void init_keyboard(void)
{
	_disable();
	IRQ1Old=_dos_getvect(0x09);
	_dos_setvect(0x09,IRQ1Handler);
	_enable();
}

void release_keyboard(void)
{
	_disable();
	_dos_setvect(0x09,IRQ1Old); /* Restore keyboard */
	_enable();
}

#include "x128_def.c"

/* Very Non Portable FSL Stuff */

#define FNAME_SIZE 12 /* Length SHOWN on FSL */
#define UNIT_SIZE 20
#define FSL_WIN_WIDTH 20
#define FSL_WIN_START 6
#define FSL_BUFF UNIT_SIZE*2048

void get_dos_drives(void)
{
	UC drive_num;
	char *temp;
	struct diskfree_t temp_t;

	strcpy(drives[1],"A:\\");
	strcpy(drives[2],"B:\\");
	for(drive_num=3;drive_num<27;drive_num++)
	{
		if(_dos_getdiskfree(drive_num,&temp_t)!=0)
		{
			drives[drive_num][0]='\0';
		}
		else
		{
			temp[0]=drive_num+'A'-1;
			temp[1]='\0';
			strcat(temp,":\\");
			strcpy(drives[drive_num],temp);
		}
	}
}

/* Port Read Keycodes For Input String */

#define X128_ESCAPE 1
#define X128_UP 72
#define X128_DOWN 80
#define X128_LEFT 75
#define X128_RIGHT 77
#define X128_RETURN 28
#define X128_PAGE_UP 73
#define X128_PAGE_DOWN 81
#define X128_KP_MINUS 74
#define X128_KP_PLUS 78
#define X128_HOME 71
#define X128_END 79
#define X128_INSERT 82
#define X128_DELETE 83
#define X128_BACKSPACE 14

UC fsl_asciiext_key(void)
{
	UC c;

	while(!kbhit());
	c=getch();
	if((c==27)||(c==13)||(c==8)) return inp(0x60);
	if(c)
	{
		return c;
	}
	else
	{
		getch();
		return inp(0x60);
	}
}

UC fsl_extend_key(void)
{
	while(!kbhit());
	if(!getch()) getch();
	return inp(0x60);
}

#ifdef __BORLANDC__
void far disk_err_handler(void)
#else
int __far disk_err_handler(unsigned deverr, unsigned errcode, unsigned far *devhdr)
#endif
{
	_hardresume(_HARDERR_IGNORE); /* Ignore */
#ifndef __BORLANDC__
	return _HARDERR_ABORT; /* Shouldn't get here */
#endif
}

#include "x128_fsl.c"
#include "x128_tap.c"
#include "x128_voc.c"
#include "x128_cb.h"
#include "x128_ed.h"
#include "x128_z80.h"

void make_table(void)
{
	int v,x,y,z;
	pair temp;
/*      quadruple qtemp;*/

	for (y=0;y<192;y++)
	{
		vga_x_y[y]=(y+4)*80;
	}
	v=0;
	for (x=0;x<6144;x+=2048)
	{
		for (y=0;y<256;y+=32)
		{
			for (z=0;z<2048;z+=256)
			{
				spline[v]=x+y+z;
				v++;
			}
		}
	}
	for (x=0;x<256;x++)
	{
		y=x&7; /* fore */
		z=(x&56)>>3; /* back */
		if (!y) y|=8;
		if (!z) z|=8;
		if (x&64)
		{
			y=y|8;
			z=z|8;
		}
		fore_attrib[x]=y;
		back_attrib[x]=z;
	}

	for (x=0;x<16;x++)
	{
		for (y=0;y<128;y++)
		{
			if(x&1)
			{
				qtemp.B.b4=fore_attrib[y];
			}
			else
			{
				qtemp.B.b4=back_attrib[y];
			}
			if(x&2)
			{
				qtemp.B.b3=fore_attrib[y];
			}
			else
			{
				qtemp.B.b3=back_attrib[y];
			}
			if(x&4)
			{
				qtemp.B.b2=fore_attrib[y];
			}
			else
			{
				qtemp.B.b2=back_attrib[y];
			}
			if(x&8)
			{
				qtemp.B.b1=fore_attrib[y];
			}
			else
			{
				qtemp.B.b1=back_attrib[y];
			}
			vga_h_nib[x][y]=qtemp.Q;
		}
	}
	for (x=0;x<128;x++)
	{
		y=(x&7)<<3;
		z=(x&56)>>3;
		reverse_attr[x]=(x&64)|y|z;
	}
	for (x=0;x<256;x++)
	{
		calc_parity(x);
		parity[x]=(af.B.l&4);
	}
	for (x=0;x<8;x++)
	{
		SKey[x]=255;
	}
}

void update_line(register UC linenum)
{
	register word bitmap, colmap;
	register UC x, colr, attr, data;
	register unsigned long *R, border4;

	bitmap=spline[linenum];
	colmap=6144|((linenum>>3)<<5);
#ifdef NO_BUFFER
	R=SCREEN+vga_x_y[linenum];
#else
	R=(unsigned long *)(XBuf+(linenum*320));
#endif

	/*border4=ul_border4[border];
	*R++=border4;*R++=border4;*R++=border4;*R++=border4;
	*R++=border4;*R++=border4;*R++=border4;*R++=border4;*/
	memset(R,border,32);
	R+=8;

	x=32;
	do
	{
		colr=SP_SCREEN[colmap++];
		attr=colr&127;
		if ((flash_status)&&(colr>>7))
		{
			attr=reverse_attr[attr];
		}
		data=SP_SCREEN[bitmap++];
		*R++=vga_h_nib[data>>4][attr];
		*R++=vga_h_nib[data&0x0F][attr];
	} while (--x);
	memset(R,border,32);
	/**R++=border4;*R++=border4;*R++=border4;*R++=border4;
	*R++=border4;*R++=border4;*R++=border4;*R++=border4;*/
}

void parse_params(int argc, char *param[])
{
	char temp_str[MAXPATH];
	int arg_num;
	UC file_valid;

	if(quit==QUIT_COMPLETELY) return; /* Rom missing */
	arg_num=1;
	file_valid=0;
	while(arg_num<argc)
	{
		if((param[arg_num][0]=='-')||(param[arg_num][0]=='/'))
		{
			strcpy(temp_str,(char *)param[arg_num]+1);
			if(!(strcmp(temp_str,"?")))
			{
				printf("x128 V0.4 By James McKay\n");
				printf("\nOptions:\n");
				printf("/?     - This help.\n");
				printf("/128   - 128K mode.\n");
				printf("/48    - 48K mode.\n");
				printf("/quiet - Sound is off.\n");
				printf("/delay <number> - Set delay level");
				printf(" (0-65535)\n");
				printf("/frame <number> - Set frame skip");
				printf(" (0-255)\n");
				printf("/ula <number>   - Set ULA delay");
				printf(" (0-255)\n");
				printf("<filename> If the file has a .z80");
				printf(" , .sna or .slt extension it");
				printf(" will be loaded.\n");
				printf("If it is a .tap or .voc it is");
				printf(" selected.\n");
				printf("\nPress F1 when in the emulator");
				printf(" for the help screen.\n");
				release_mem();
				exit(1);
			}
			if(!(strcmp(temp_str,"128")))
			{
				if(file_valid!=1)
				{
					quit=QUIT_RESET;
					skip_reset=0;
				}
			}
			if(!(strcmp(temp_str,"48")))
			{
				if(file_valid!=1)
				{
					quit=QUIT_RESET;
					skip_reset=1;
				}
			}
			if(!(strcmp(temp_str,"delay")))
			{
				arg_num++;
				slow_down=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"DELAY")))
			{
				arg_num++;
				slow_down=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"frame")))
			{
				arg_num++;
				frame_skip=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"FRAME")))
			{
				arg_num++;
				frame_skip=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"ula")))
			{
				arg_num++;
				ULA_delay=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"ULA")))
			{
				arg_num++;
				ULA_delay=atoi(param[arg_num]);
			}
			if(!(strcmp(temp_str,"quiet")))
			{
				all_sound_on=UseAdlib=0;
			}
			if(!(strcmp(temp_str,"QUIET")))
			{
				all_sound_on=UseAdlib=0;
			}
		}
		else
		{
			strcpy(temp_str,param[arg_num]);
			if(!different_extension(".z80",temp_str))
			{
				strcpy(the_path,temp_str);
				if(!(open_z80()))
				{
					halt=0; /* Re-enable processor for new snap */
				}
				file_valid=1;
				quit=DONT_QUIT;
			}
			if(!different_extension(".slt",temp_str))
			{
				strcpy(the_path,temp_str);
				if(!(open_z80()))
				{
					halt=0; /* Re-enable processor for new snap */
				}
				file_valid=1;
				quit=DONT_QUIT;
			}
			if(!different_extension(".sna",temp_str))
			{
				strcpy(the_path,temp_str);
				if(!(open_sna()))
				{
					halt=0;
					ED[77].opcode(); /* reti */
				}
				file_valid=1;
				quit=DONT_QUIT;
			}
			if(!different_extension(".tap",temp_str))
			{
				printf("TAP files are only selected,");
				printf(" not automatically loaded.\n");
				strcpy(the_path,temp_str);
				TAP_select();
				TAP_rompokes();
				file_valid=2;
			}
			if(!different_extension(".voc",temp_str))
			{
				printf("VOC files are only selected,");
				printf(" not automatically loaded.\n");
				strcpy(the_path,temp_str);
				open_VOC_input_file();
				undo_TAP_rompokes();
				file_valid=2;
			}
			if(!file_valid)
			{
				printf("File did not have z80, sna,");
				printf(" tap, voc or slt");
				printf(" extension, so I did not know\n");
				printf("how to deal with it.\n");
			}
		}
		arg_num++;
	}
	if(file_valid==1) skip_reset=255;
}

#ifdef OVERSCAN

#define main_bit(scr_drive)   \
  register UC byte;             \
  register UC screen_up=0;        \
  UC ff=0xFF;                      \
				     \
  do{                                 \
	if(t_state>=t_states_per_line)  \
	{                                 \
		t_state-=t_states_per_line; \
		line_counter++;              \
		if(++vline==s_lines)          \
		{                               \
			vline=0;                  \
			if(++screen_up==frame_skip) \
			{                             \
				screen_up=0;            \
			}                                 \
			if(!--flash_count)                  \
			{                                     \
				flash_count=16;                 \
				flash_status^=1;                  \
			}                                           \
			if(iff1)                                    \
			{                                           \
				iff2=iff1;                          \
				iff1=halt=0;                        \
				if(im==2)                           \
				{                                   \
					push(pc.W);                 \
					ptemp.W=(ir.B.h<<8)|255;    \
					pc.W=wordpeek(ptemp.W);     \
					INC_R_REG;                  \
					t_state+=19;                \
				}                                   \
				else                                \
				{                                   \
					INC_R_REG;                  \
					rst_56();                   \
					t_state+=2;                 \
				}                                   \
			}                                           \
			if(PSG_open)                                \
			{                                           \
				fwrite(&ff,1,1,p_handle);           \
			}                                           \
		}                                                   \
		if((!screen_up)&&(vline&192))                       \
		{                                                   \
			scr_drive(vline-64);                        \
			t_state+=ULA_delay;                         \
		}                                                   \
	}                                                           \
	if(!halt)                                                   \
	{                                                           \
		INC_R_REG;                                          \
		byte=speekb(pc.W);                                  \
		pc.W++;                                             \
		Z80[byte].opcode();                                 \
	}                                                           \
	else                                                        \
	{                                                           \
		Z80[0].opcode();                                    \
	}

#else

#define main_bit(scr_drive)   \
  register UC byte;             \
  register UC screen_up=0;        \
  UC ff=0xFF;                      \
				     \
  do{                                 \
	if(int_50)                     \
	{                               \
		int_50=0; \
		release_timer(); \
		if(++screen_up==frame_skip) \
		{                             \
			screen_up=0;            \
			scr_drive();             \
		}                                  \
		if(!--flash_count)                  \
		{                                     \
			flash_count=16;                 \
			flash_status^=1;                  \
		}                                           \
		if(iff1)                                    \
		{                                           \
			iff2=iff1;                          \
			iff1=halt=0;                        \
			if(im==2)                           \
			{                                   \
				push(pc.W);                 \
				ptemp.W=(ir.B.h<<8)|255;    \
				pc.W=wordpeek(ptemp.W);     \
				INC_R_REG;                  \
			}                                   \
			else                                \
			{                                   \
				INC_R_REG;                  \
				rst_56();                   \
			}                                   \
		}                                           \
		if(PSG_open)                                \
		{                                           \
			fwrite(&ff,1,1,p_handle);           \
		}                                           \
		init_timer(); \
	}                                                   \
	if(!halt)                                                   \
	{                                                           \
		INC_R_REG;                                          \
		byte=speekb(pc.W);                                  \
		pc.W++;                                             \
		Z80[byte].opcode();                                 \
	}                                                           \
	else                                                        \
	{                                                           \
		Z80[0].opcode();                                    \
	}

#endif

#define main_bit_2 \
  }while (!quit);

void main_loop_delay(void)
{
#ifdef OVERSCAN
	main_bit(update_line);
#else
	main_bit(RePaintScreen);
#endif
	for(ptemp.W=0;ptemp.W<slow_down;ptemp.W++)
	{
		qtemp.Q+=2;
		qtemp.Q-=2;
	}
	main_bit_2;
}

void main_loop(void)
{
#ifdef OVERSCAN
	main_bit(update_line);
#else
	main_bit(RePaintScreen);
#endif
	/*if(pc.W==33354) quit=QUIT_COMPLETELY;*/
	main_bit_2;
}

void main(int argc, char *argv[])
{
  UC ULA_param=0;
  UC discard;

  error_str="No error.";

  strcpy(the_sna_path,argv[0]);
  strcpy(the_tap_path,argv[0]);
  strcpy(the_dat_path,argv[0]);
  strcpy(the_psg_path,argv[0]);
  strcpy(the_temp_file,"dump.tmp");

  grab_mem();

  _harderr(disk_err_handler);
  get_dos_drives();

  quit=QUIT_RESET;
  skip_reset=0; /* 128K mode by default */
  clean_regs();
  open_rom48();
  open_rom128_B();
  r2_1386=ROM[2][1386];
  r2_1387=ROM[2][1387];
  r1_1386=ROM[1][1386];
  r1_1387=ROM[1][1387];
  open_rom128_E();
  open_romMF128();
  make_table();
  open_z80table();

#ifdef OLD_NOISE
  adlib_present=InitAdlib();
#else
  init_DSP();
#endif
  parse_params(argc,argv);
  if(ULA_delay) ULA_param=ULA_delay; /* Got to copy ULA_delay */

  init_screen();

  init_keyboard();

  do
  {
#ifndef OLD_NOISE
	release_DSP();
#endif
	Sound_off();
	switch(quit)
	{
		case QUIT_HELP:
			help_scr();
			/* quit=DONT_QUIT; is now in help_scr() */
			break;
		case QUIT_NMI:
			iff2=iff1;
			iff1=halt=0;
			INC_R_REG;
			push(pc.W);
			pc.W=102;
			discard=in(0,191);
			t_state+=11;
			quit=DONT_QUIT;
			break;
		case QUIT_RESET:
			switch(reset_spectrum(skip_reset))
			{
				case 0:
					clean_regs();
					mode(128);
					joy_type=0;
					curs_caps=1;
					SLT=0;
					break;
				case 1:
					clean_regs();
					mode(48);
					joy_type=0;
					curs_caps=1;
					SLT=0;
					break;
				case 2:
					mode(128);
					break;
				case 3:
					mode(48);
					break;
				default:
					break;
			}
			quit=DONT_QUIT;
			skip_reset=255;
			if(ret_to_help)
			{
				ret_to_help=0;
				quit=QUIT_HELP;
			}
			break;
		case QUIT_JOY:
			joystick();
			quit=DONT_QUIT;
			if(ret_to_help)
			{
				ret_to_help=0;
				quit=QUIT_HELP;
			}
			break;
		case QUIT_LOAD:
			global_index=sna_index;
			strcpy(the_path,the_sna_path);
			if(!(test_fsl(".z80",".sna",".slt")))
			{
				if(different_extension(".sna",the_path))
				{
					if(!(open_z80()))
					{
						halt=0; /* Re-enable processor for new snap */
					}
				}
				else
				{
					if(!(open_sna()))
					{
						halt=0;
						ED[77].opcode(); /* reti */
					}
				}
			}
			strcpy(the_sna_path,the_path);
			sna_index=global_index;
			quit=DONT_QUIT;
			if(ret_to_help)
			{
				ret_to_help=0;
				quit=QUIT_HELP;
			}
			break;
		case QUIT_SAVE:
			strcpy(the_path,the_sna_path);
			if(!(input_string(4,"Save Z80/SLT File")))
			{
				save_z80();
			}
			quit=DONT_QUIT;
			if(ret_to_help)
			{
				ret_to_help=0;
				quit=QUIT_HELP;
			}
			break;
		case QUIT_TAP:
			global_index=tap_index;
			strcpy(the_path,the_tap_path);
			if(!(test_fsl(".tap",".voc","")))
			{
				if(different_extension(".voc",the_path))
				{
					TAP_select();
					TAP_rompokes();
					if(VOC_file_in_open)
					{
						VOC_file_in_open=0;
						fclose(v_in_handle);
					}
				}
				else
				{
					open_VOC_input_file();
					undo_TAP_rompokes();
				}
			}
			strcpy(the_tap_path,the_path);
			tap_index=global_index;
			quit=DONT_QUIT;
			break;
		case QUIT_VOC:
			VOC_options();
			quit=DONT_QUIT;
			break;
		case QUIT_SOUND:
			strcpy(the_path,the_psg_path);
			sound_options();
			if(!all_sound_on)
			{
				Sound_off();
				UseAdlib=0;
			}
			else
			{
				UseAdlib=adlib_present;
				Sound_on();
			}
			quit=DONT_QUIT;
			if(ret_to_help)
			{
				ret_to_help=0;
				quit=QUIT_HELP;
			}
			break;
		default:
			break;
	}
	if(quit==QUIT_HELP) continue;
	if(ULA_param)
	{
		ULA_delay=ULA_param;
		ULA_param=0;
	}
	Sound_on();
#ifndef OLD_NOISE
	init_DSP();
#endif
#ifndef OVERSCAN
	init_timer();
#endif
	if(slow_down)
	{
		main_loop_delay();
	}
	else
	{
		main_loop();
	}
#ifndef OVERSCAN
	release_timer();
#endif
  } while (quit!=QUIT_COMPLETELY);
  if(TAP_file_open) fclose(t_handle);
  if(VOC_file_in_open) fclose(v_in_handle);
  if(PSG_open) fclose(p_handle);
  release_mem();

  release_keyboard();
  release_screen();
#ifdef OLD_NOISE
  TrashAdlib();
#else
  release_DSP();
#endif
  printf("%s\n",error_str);

  /*printf("AF=%u\n",af.W);
  printf("AF'=%u\n",af2.W);

  printf("HL=%u\n",hl.W);
  printf("DE=%u\n",de.W);
  printf("BC=%u\n",bc.W);

  printf("HL'=%u\n",hl2.W);
  printf("DE'=%u\n",de2.W);
  printf("BC'=%u\n",bc2.W);

  printf("IY=%u\n",iy.W);
  printf("IX=%u\n",ix.W);*/

  printf("ULA Delay %d\n",ULA_delay);
}
