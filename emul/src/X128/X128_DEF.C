/******************************************/
/**                                      **/
/**         X128_DEF Portable File       **/
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
/**  Marat Fayzullin 1995 (Unix & Ideas) **/
/** Arnold Metselaar 1995 (More Unix)    **/
/******************************************/
#define NO_POTATO /* New core routines not verified yet */

#define SET_CF_P ptemp.B.l|=1   /* set Cf */
#define RES_CF_P ptemp.B.l&=254 /* reset Cf */

#define SET_NF_P ptemp.B.l|=2   /* set Nf */
#define RES_NF_P ptemp.B.l&=253 /* reset Nf */

#define SET_PF_P ptemp.B.l|=4   /* set Pf */
#define RES_PF_P ptemp.B.l&=251 /* reset Pf */

#define SET_3F_P ptemp.B.l|=8   /* set bit 3 of F */
#define RES_3F_P ptemp.B.l&=247 /* reset bit 3 of F */

#define SET_HF_P ptemp.B.l|=16  /* set Hf */
#define RES_HF_P ptemp.B.l&=239 /* reset Hf */

#define SET_5F_P ptemp.B.l|=32  /* set bit 5 of F */
#define RES_5F_P ptemp.B.l&=223 /* reset bit 5 of F */

#define SET_ZF_P ptemp.B.l|=64  /* set Zf */
#define RES_ZF_P ptemp.B.l&=191 /* reset Zf */

#define SET_SF_P ptemp.B.l|=128 /* set Sf */
#define RES_SF_P ptemp.B.l&=127 /* reset Sf */

#define INC_R_REG \
	ir.B.l++

#ifdef OVERSCAN
#define spokeb(oset,bpval) \
	mwtemp=oset>>13; \
	SRAMW[mwtemp][oset&0x1FFF]=bpval; \
	if((CONTENDED[mwtemp]) \
	&&(!(t_state>>7))&&(vline&192)) t_state+=4;
/* The 'if' is Spectrum specific, if you are using this code for
another Z80 thingy, do not include that line.  It is an attempt at
emulating the mem write delay in ULA contended memory */
#else
#define spokeb(oset,bpval) \
	SRAMW[oset>>13][oset&0x1FFF]=bpval;

#endif

#define speekb(oset) \
	SRAMR[oset>>13][oset&0x1FFF]

#define wordpoke(oset,wpval) \
	ptemp.W=wpval;         \
	spokeb(oset,ptemp.B.l);  \
	spokeb(oset+1,ptemp.B.h);

#define wordpeek(oset) \
	((speekb(oset))|(speekb(oset+1)<<8))

#define push(wpval) \
	sp.W-=2; \
	wordpoke(sp.W,wpval);

#define pop(wpval) \
	wpval=wordpeek(sp.W); \
	sp.W+=2;

#define copy_b53(btemp) \
	af.B.l=(af.B.l&215)|(btemp&40);

#ifdef NO_POTATO

/* Keep SZ Depends 543 Keep P Res NC */
#define add16(first,second) \
	qtemp.Q=(unsigned long)first+(unsigned long)second; \
	first=qtemp.W.w1; \
	af.B.l=(af.B.l&0xC4)|(qtemp.B.b2&0x38); \
	if (!qtemp.B.b3) RES_CF; else SET_CF;

#else

#define add16(first,second) \
	qtemp.Q=(unsigned long)first+(unsigned long)second; \
	first=qtemp.W.w1; \
	af.B.l=(af.B.l&0xC4)|(qtemp.B.b2&0x38) \
	|(qtemp.B.b3);

#endif

#ifdef NO_POTATO

/* Keep S Res Z Depends 543 Res PNC */
#define adc16(first,second) \
	qtemp.Q=(unsigned long)first+(unsigned long)second+(af.B.l&1); \
	af.B.l=(qtemp.B.b2&0xB8); \
	if (!qtemp.B.b3) RES_CF; else SET_CF; \
	if (qtemp.W.w1) RES_ZF; else SET_ZF; \
	if(((first^qtemp.W.w1)>>15)&&(!((first^second)>>15))) SET_PF; else RES_PF; \
	hl.W=qtemp.W.w1;

#else

#define adc16(first,second) \
	qtemp.Q=(unsigned long)first+(unsigned long)second+(af.B.l&1); \
	af.B.l=(qtemp.B.b2&0xB8)|(qtemp.B.b3) \
	|((((first^qtemp.W.w1)>>15)&&(!(first^second)>>15))?4:0) \
	|(qtemp.W.w1?0:64); \
	hl.W=qtemp.W.w1;

#endif

#ifdef NO_POTATO

/* Keep S Res Z Depends 543 Res P Set N Res C */
#define sbc16(first,second) \
	qtemp.Q=(unsigned long)first-(unsigned long)second-(af.B.l&1); \
	af.B.l=(qtemp.B.b2&0xB8)|2; \
	if (!qtemp.B.b4) RES_CF; else SET_CF; \
	if (qtemp.W.w1) RES_ZF; else SET_ZF;  \
	if(((first^qtemp.W.w1)>>15)&&(!((second^qtemp.W.w1)>>15))) SET_PF; else RES_PF; \
	hl.W=qtemp.W.w1;

#else

#define sbc16(first,second) \
	qtemp.Q=(unsigned long)first-(unsigned long)second-(af.B.l&1); \
	af.B.l=(qtemp.B.b2&0xB8)|(qtemp.B.b4>>7)|2 \
	|((((first^qtemp.W.w1)>>15)&&(!(second^qtemp.W.w1)>>15))?4:0) \
	|(qtemp.W.w1?0:64); \
	hl.W=qtemp.W.w1;

#endif

/*#undef NO_POTATO*/
#ifdef NO_POTATO

#define add8(Lo,Pls) \
	ptemp.W=Lo+Pls; \
	if (!ptemp.B.h) \
	{            \
		ptemp.B.h=ptemp.B.l; \
		RES_CF_P;        \
	}                      \
	else                   \
	{                      \
		ptemp.B.h=ptemp.B.l; \
		SET_CF_P;        \
	}                      \
	RES_NF_P;                \
	if (ptemp.B.h) RES_ZF_P; else SET_ZF_P; \
	if ((Lo^Pls^ptemp.B.h)&16) SET_HF_P; else RES_HF_P; \
	if (((Lo^ptemp.B.h)>>7)&&(!((Lo^Pls)>>7))) SET_PF_P; else RES_PF_P; \
	af.W=ptemp.W;

#else

#define add8(Lo,Pls) \
	ptemp.W=Lo+Pls; \
	af.B.l=ptemp.B.h|((((Lo^ptemp.B.l)>>7)&&(!(Lo^Pls)>>7))?4:0) \
	|add8_table[ptemp.B.l]|((Lo^Pls^ptemp.B.l)&16); \
	af.B.h=ptemp.B.l;

#endif

#ifdef NO_POTATO

#define sub8(Lo,Mns) \
	ptemp.W=Lo-Mns; \
	if (!ptemp.B.h)     \
	{                       \
		ptemp.B.h=ptemp.B.l;  \
		RES_CF_P;         \
	}                       \
	else                    \
	{                       \
		ptemp.B.h=ptemp.B.l;  \
		SET_CF_P;         \
	}                       \
	SET_NF_P;                 \
	if (ptemp.B.h) RES_ZF_P; else SET_ZF_P; \
	if ((Lo^Mns^ptemp.B.h)&16) SET_HF_P; else RES_HF_P; \
	if (((Lo^ptemp.B.h)>>7)&&(!((Mns^ptemp.B.h)>>7))) SET_PF_P; else RES_PF_P; \
	af.W=ptemp.W;

#else

#define sub8(Lo,Mns) \
	ptemp.W=Lo-Mns; \
	af.B.l=(ptemp.B.h>>7) \
	|((((Lo^ptemp.B.l)>>7)&&(!(Mns^ptemp.B.l)>>7))?4:0) \
	|sub8_table[ptemp.B.l]|((Lo^Mns^ptemp.B.l)&16); \
	af.B.h=ptemp.B.l;

#endif

#ifdef NO_POTATO

#define adc8(Lo,Pls) \
	ptemp.W=Lo+Pls+(af.B.l&1); \
	if (!ptemp.B.h) \
	{            \
		ptemp.B.h=ptemp.B.l; \
		RES_CF_P;        \
	}                      \
	else                   \
	{                      \
		ptemp.B.h=ptemp.B.l; \
		SET_CF_P;        \
	}                      \
	RES_NF_P;                \
	if (ptemp.B.h) RES_ZF_P; else SET_ZF_P; \
	if ((Lo^Pls^ptemp.B.h)&16) SET_HF_P; else RES_HF_P; \
	if (((Lo^ptemp.B.h)>>7)&&(!((Lo^Pls)>>7))) SET_PF_P; else RES_PF_P; \
	af.W=ptemp.W;

#define sbc8(Lo,Mns)                 \
	ptemp.W=Lo-Mns-(af.B.l&1);   \
	if (!ptemp.B.h)              \
	{                            \
		ptemp.B.h=ptemp.B.l; \
		RES_CF_P;            \
	}                            \
	else                         \
	{                            \
		ptemp.B.h=ptemp.B.l; \
		SET_CF_P;            \
	}                            \
	SET_NF_P;                    \
	if (ptemp.B.h) RES_ZF_P; else SET_ZF_P; \
	if((Lo^Mns^ptemp.B.h)&16) SET_HF_P; else RES_HF_P; \
	if(((Lo^ptemp.B.h)>>7)&&(!((Mns^ptemp.B.h)>>7))) SET_PF_P; else RES_PF_P; \
	af.W=ptemp.W;

#else

#define adc8(Lo,Pls) \
	ptemp.W=Lo+Pls+(af.B.l&1); \
	af.B.l=ptemp.B.h|((((Lo^ptemp.B.l)>>7)&&(!(Lo^Pls)>>7))?4:0) \
	|add8_table[ptemp.B.l]|((Lo^Pls^ptemp.B.l)&16); \
	af.B.h=ptemp.B.l;

#define sbc8(Lo,Mns) \
	ptemp.W=Lo-Mns-(af.B.l&1); \
	af.B.l=(ptemp.B.h>>7) \
	|((((Lo^ptemp.B.l)>>7)&&(!(Mns^ptemp.B.l)>>7))?4:0) \
	|sub8_table[ptemp.B.l]|((Lo^Mns^ptemp.B.l)&16); \
	af.B.h=ptemp.B.l;

#endif

#ifdef NO_POTATO

#define cp_sub8(Lo,Mns) \
	ptemp.W=Lo-Mns; \
	af.B.l=(Mns&40)|(ptemp.B.l&215)|2; \
	if (ptemp.B.l) RES_ZF; else SET_ZF; \
	if (!ptemp.B.h) RES_CF; else SET_CF; \
	if((Lo^Mns^ptemp.B.l)&16) SET_HF; else RES_HF; \
	if(((Lo^ptemp.B.l)>>7)&&(!((Mns^ptemp.B.l)>>7))) SET_PF; else RES_PF;

#else

#define cp_sub8(Lo,Mns) \
	ptemp.W=Lo-Mns; \
	af.B.l=(ptemp.B.h>>7) \
	|((((Lo^ptemp.B.l)>>7)&&(!(Mns^ptemp.B.l)>>7))?4:0) \
	|cpsub8_table[ptemp.B.l]|(Mns&40) \
	|((Lo^Mns^ptemp.B.l)&16);

#endif

#ifdef MAIN_OBJ
void calc_parity(UC btemp)
{
	pair temp;
	UC lop,par;

	if(!btemp)
	{
		SET_PF;
	}
	else
	{
		lop=par=0;
		temp.W=(word)btemp;
		do
		{
			temp.W<<=1;
			if(temp.B.h&1) par++;
			lop++;
		} while (lop<8);
		if (par&1) RES_PF; else SET_PF;
	}
}

void out(register UC port_hi,register UC port_lo,register UC byte)
{
	register UC btemp;

	if(!(port_lo&1)) /* ULA (ie border and 48K sound) */
	{
		/*t_state++;*/
		border=byte&7;
		if(!all_sound_on) return;
		if(!((old_254^byte)&16)) return;
		old_254=byte&16;
#ifdef OLD_NOISE
#ifdef OLD_48K
#ifdef MSDOS_SYSTEM
		if(!(old_254=byte&16))
		{
			outp(0x61,(inp(0x61)&0xFC));
		}
		else
		{
			outp(0x61,(inp(0x61)&0xFC)|2);
		}
#endif
#ifdef LINUX
		if(!(old_254=byte&16))
		{
			outp(0x61,(inp(0x61)&0xFC));
		}
		else
		{
			outp(0x61,(inp(0x61)&0xFC)|2);
		}
#endif
#else
		if(!(old_254=byte&16))
		{
			while(inp(0x22C)&128);
			outp(0x22C,0x10);
			while(inp(0x22C)&128);
			outp(0x22C,96);
		}
		else
		{
			while(inp(0x22C)&128);
			outp(0x22C,0x10);
			while(inp(0x22C)&128);
			outp(0x22C,159);

		}
#endif
#endif
		return;
	}
	if(port_lo==253)
	{
		btemp=port_hi>>6;
		if(btemp==0x01)
		{
			if(!mem_48_lock)
			{
				ram_state=byte;
				SRAMW[6]=SRAMR[6]=RAM[ram_state&7];
				SRAMW[7]=SRAMR[7]=SRAMR[6]+8192;
				CONTENDED[6]=CONTENDED[7]=ram_state&4;
				if(ram_state&8)
				{
					SP_SCREEN=RAM[7];
				}
				else
				{
					SP_SCREEN=RAM[5];
				}
				if(!mf128_on)
				{
					SRAMW[0]=SRAMW[1]=DUMMY_MEM;
					if(ram_state&16)
					{
						SRAMR[0]=ROM48;
						SRAMR[1]=SRAMR[0]+8192;

					}
					else
					{
						SRAMR[0]=ROM[0];
						SRAMR[1]=SRAMR[0]+8192;
					}
				}
				if(ram_state&32)
				{
					mem_48_lock=1;
					if(!mf128_on)
					{
						SRAMR[0]=ROM48;
						SRAMR[1]=SRAMR[0]+8192;
						SRAMW[0]=SRAMW[1]=DUMMY_MEM;
					}
					SRAMW[6]=SRAMR[6]=RAM[0];
					SRAMW[7]=SRAMR[7]=SRAMR[6]+8192;
					CONTENDED[6]=CONTENDED[7]=0;
				}
				/*t_state+=2;*/
			}
			return;
		}
		if(btemp==0x02)
		{
			if(!model_48)
			{
				PSGOut(last_fffd,byte);
			}
			return;
		}
		if(btemp==0x03)
		{
			last_fffd=byte&15; /* Transparent to 48K */
			return;
		}
	}
}

UC in(register UC port_hi, register UC port_lo)
{
	register UC returnable;
	UC temp_char;

	if(!(port_lo&1)) /* ULA (ie Keys) */
	{
		/*t_state++;*/
		returnable=keyboard_issue;
		if(!(port_hi&128))
		{
			returnable&=SKey[StoB];
		}
		if(!(port_hi&64))
		{
			returnable&=SKey[EtoH];
		}
		if(!(port_hi&32))
		{
			returnable&=SKey[PtoY];
		}
		if(!(port_hi&16))
		{
			returnable&=SKey[N0toN6];
		}
		if(!(port_hi&8))
		{
			returnable&=SKey[N1toN5];
		}
		if(!(port_hi&4))
		{
			returnable&=SKey[QtoT];
		}
		if(!(port_hi&2))
		{
			returnable&=SKey[AtoG];
		}
		if(!(port_hi&1))
		{
			returnable&=SKey[CtoV];
		}
		if((VOC_file_in_open)&&(!VOC_paused))
		{
			returnable^=return_next_VOC_bit();
		}
		return returnable;
	}
	if(!(port_lo&0x20)) return In31; /* Kempston, Rui's bit */
	switch(port_lo)
	{
		case  63: /* Mf 128 Page Out */
		{
			if(mf128_on)
			{
				mf128_on=0;
				temp_char=mem_48_lock;
				mem_48_lock=0;
				out(P32765,ram_state);
				mem_48_lock=temp_char;
			}
			return 255;
		}
		case 191: /* Mf 128 Page In */
		{
			mf128_on=1;
			SRAMR[0]=ROM[3];
			SRAMW[1]=SRAMR[1]=SRAMR[0]+8192;
			if(ram_state&8)
			{
				return 255;
			}
			return 127;
		}
		case 253: /* Ay-3-8912 */
		{
			if((port_hi>>6)==0x03)
			{
				return PSG[last_fffd];
			}
			return 255;
		}
		default: /* Vertical Retrace (not on +3 or +2A) */
		{
			if(vline&192) /* Colour of paper on screen */
			{
				return SP_SCREEN[6144|(((vline-64)&248)<<2)];
			}
			else
			{
				return 255; /* Retrace */
			}
		}
	}
}
#else
void calc_parity(UC btemp);
void out(register UC port_hi,register UC port_lo,register UC byte);
UC in(register UC port_hi, register UC port_lo);
#endif

/*#define ora(bval) \
	af.B.h|=bval; \
	af.B.l=(af.B.h&232)|parity[af.B.h]; \
	if(!af.B.h) SET_ZF; else RES_ZF;

#define xora(bval) \
	af.B.h^=bval; \
	af.B.l=(af.B.h&232)|parity[af.B.h];  \
	if(!af.B.h) SET_ZF; else RES_ZF;*/

/*#define anda(bval) \
	af.B.h&=bval;\
	af.B.l=16|(af.B.h&232)|parity[af.B.h]; \
	if(!af.B.h) SET_ZF; else RES_ZF;*/

#define ora(bval) \
	af.B.h|=bval; \
	af.B.l=ora_table[af.B.h];

#define xora(bval) \
	af.B.h^=bval; \
	af.B.l=xora_table[af.B.h];

#define anda(bval) \
	af.B.h&=bval; \
	af.B.l=anda_table[af.B.h];

#ifdef MAIN_OBJ
void mode(UC mode_num)
{
	switch(mode_num)
	{
		case 48 :
			ROM48=ROM[2];
			out(P32765,48);
			s_lines=312;
			t_states_per_line=224;
			model_48=1;
			break;
		case 128:
			ROM48=ROM[1];
			out(P32765,0);
			s_lines=311;
			t_states_per_line=228;
			model_48=0;
			break;
		default:
			break;
	}
	ULA_delay=0;
}

void grab_mem(void)
{
	UC x;

	for(x=0;x<8;x++)
	{
		if (!(RAM[x]=(UC *)malloc(0x4000)))
		{
		      printf("Spectrum RAM %d Arg!\n",x);
		      quit=QUIT_COMPLETELY;
		}
		else
		{
		      memset(RAM[x],0,0x4000);
		}
	}
	SRAMW[2]=SRAMR[2]=RAM[5];SRAMW[3]=SRAMR[3]=RAM[5]+8192;
	CONTENDED[2]=CONTENDED[3]=1;
	SRAMW[4]=SRAMR[4]=RAM[2];SRAMW[5]=SRAMR[5]=RAM[2]+8192;
	CONTENDED[4]=CONTENDED[5]=0;
	SRAMW[6]=SRAMR[6]=RAM[0];SRAMW[7]=SRAMR[7]=RAM[0]+8192;
	CONTENDED[6]=CONTENDED[7]=0;
	for(x=0;x<4;x++)
	{
		if (!(ROM[x]=(UC *)malloc(0x4000)))
		{
		      printf("Spectrum ROM %d Arg!\n",x);
		      quit=QUIT_COMPLETELY;
		}
		else
		{
		      memset(ROM[x],0,0x4000);
		}
	}
	ROM48=ROM[1];
	if(!(DUMMY_MEM=(UC *)malloc(0x2000)))
	{
	      printf("DUMMY_MEM Arg!\n");
	      quit=QUIT_COMPLETELY;
	}
	else
	{
	      memset(DUMMY_MEM,0,0x2000);
	}
	SRAMR[0]=ROM[1];SRAMR[1]=SRAMR[0]+8192;
	SRAMW[0]=SRAMW[1]=DUMMY_MEM;
	CONTENDED[0]=CONTENDED[1]=0;
	SP_SCREEN=RAM[5];
	if(!(BUFFER=(UC *)malloc(0xC000)))
	{
	      printf("Z80 Buffer Arg!\n");
	      quit=QUIT_COMPLETELY;
	}
	else
	{
	      memset(BUFFER,0,0xC000);
	}
#ifndef NO_BUFFER
	if(!(XBuf=(UC *)malloc(61440)))
	{
	      printf("XBuf Arg!\n");
	      quit=QUIT_COMPLETELY;
	}
	else
	{
	      memset(XBuf,0,61440);
	}
#endif
}

void release_mem(void)
{
	UC x;

	for(x=0;x<8;x++)
	{
		free(RAM[x]);
	}
	for(x=0;x<4;x++)
	{
		free(ROM[x]);
	}
	free(BUFFER);
#ifndef NO_BUFFER
	free(XBuf);
#endif
	free(DUMMY_MEM);
}
#endif
