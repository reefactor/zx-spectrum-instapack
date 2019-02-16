/******************************************/
/**                                      **/
/**         X128_ED Portable File        **/
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
#define ED_OBJ
/*#define OLD_IN*/
#include "x128_end.c"
#include "x128_def.c"
#include "x128_ed.h"

UC TAP_load(UC id_a, word start_ix, word length_de);

void in_b_c(void) /* in b,(c) ALL in reg,(c) UNTESTED FLAGS */
{
	bc.B.h=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(bc.B.h&0xA8)|(af.B.l&1)|(parity[bc.B.h]); /* 10101000 */
	if(bc.B.h) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[bc.B.h]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_b(void) /* out(c),b */
{
	out(bc.B.h,bc.B.l,bc.B.h);
	t_add(12);
}

void sbc_hl_bc(void) /* sbc hl,bc */
{
	sbc16(hl.W,bc.W);
	t_add(15);
}

void ld_aXXXX_bc(void) /* ld(XXXX),bc */
{
	wordpoke(wordpeek(pc.W),bc.W);
	pc.W+=2;
	t_add(20);
}

void neg(void) /* neg */
{
	sub8(0,af.B.h);
	t_add(8);
}

void retn(void) /* retn */
{
	iff1=iff2;
	pop(pc.W);
	t_add(14);
}

void im_0(void) /* im 0 */
{
	im=0;
	t_add(8);
}

void ld_i_a(void) /* ld i,a */
{
	ir.B.h=af.B.h;
	t_add(9);
}

void in_c_c(void) /* in c,(c) */
{
	bc.B.l=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(bc.B.l&0xA8)|(af.B.l&1)|(parity[bc.B.l]); /* 10101000 */
	if(bc.B.l) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[bc.B.l]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_c(void) /* out(c),c */
{
	out(bc.B.h,bc.B.l,bc.B.l);
	t_add(12);
}

void adc_hl_bc(void) /* adc hl,bc */
{
	adc16(hl.W,bc.W);
	t_add(15);
}

void ld_bc_aXXXX(void) /* ld bc,(XXXX) */
{
	bc.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void reti(void) /* reti */
{
	pop(pc.W);
	t_add(14);
}

void ld_r_a(void) /* ld r,a */
{
	ir.B.l=af.B.h&127;
	bit7_r=af.B.h&128;
	t_add(9);
}

void in_d_c(void) /* in d,(c) */
{
	de.B.h=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(de.B.h&0xA8)|(af.B.l&1)|(parity[de.B.h]); /* 10101000 */
	if(de.B.h) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[de.B.h]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_d(void) /* out(c),d */
{
	out(bc.B.h,bc.B.l,de.B.h);
	t_add(12);
}

void sbc_hl_de(void) /* sbc hl,de */
{
	sbc16(hl.W,de.W);
	t_add(15);
}

void ld_aXXXX_de(void) /* ld(XXXX),de */
{
	wordpoke(wordpeek(pc.W),de.W);
	pc.W+=2;
	t_add(20);
}

void im_1(void) /* im 1 */
{
	im=1;
	t_add(8);
}

void ld_a_i(void) /* ld a,i UNTESTED */
{
	af.B.h=ir.B.h;                   /* SZ-H-PNC */
	af.B.l=(af.B.h&0xA8)|(af.B.l&1); /* 10101000 */
	if(af.B.h) RES_ZF; else SET_ZF;
	if(iff2) SET_PF; else RES_PF;
	t_add(9);
}

void in_e_c(void) /* in e,(c) */
{
	de.B.l=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(de.B.l&0xA8)|(af.B.l&1)|(parity[de.B.l]); /* 10101000 */
	if(de.B.l) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[de.B.l]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_e(void) /* out(c),e */
{
	out(bc.B.h,bc.B.l,de.B.l);
	t_add(12);
}

void adc_hl_de(void) /* adc hl,de */
{
	adc16(hl.W,de.W);
	t_add(15);
}

void ld_de_aXXXX(void) /* ld de,(XXXX) */
{
	de.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void im_2(void) /* im 2 */
{
	im=2;
	t_add(8);
}

void ld_a_r(void) /* ld a,r extra flags untested */
{
	af.B.h=bit7_r|(ir.B.l&127);      /* SZ-H-PNC */
	af.B.l=(af.B.h&0xA8)|(af.B.l&1); /* 10101000 */
	if(af.B.h) RES_ZF; else SET_ZF;
	if(iff2) SET_PF; else RES_PF;
	t_add(9);
}

void in_h_c(void) /* in h,(c) */
{
	hl.B.h=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(hl.B.h&0xA8)|(af.B.l&1)|(parity[hl.B.h]); /* 10101000 */
	if(hl.B.h) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[hl.B.h]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_h(void) /* out(c),h */
{
	out(bc.B.h,bc.B.l,hl.B.h);
	t_add(12);
}

void sbc_hl_hl(void) /* sbc hl,hl */
{
	sbc16(hl.W,hl.W);
	t_add(15);
}

void ld_aXXXX_hl(void) /* ld(XXXX),hl */
{
	wordpoke(wordpeek(pc.W),hl.W);
	pc.W+=2;
	t_add(20);
}

void rrd(void) /* rrd INCOMPLETE */
{
	register UC c_hl;

	c_hl=speekb(hl.W);
	spokeb(hl.W,(c_hl>>4)|(af.B.h<<4));
	af.B.h=(c_hl&0x0F)|(af.B.h&0xF0);

	af.B.l=(af.B.h&190)|(af.B.l&1); /* Keep Cf and Set Zf to 0 */
	if(!af.B.h) SET_ZF; /* And the Sign flag is used */
	t_add(18);
}

void in_l_c(void) /* in l,(c) */
{
	hl.B.l=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(hl.B.l&0xA8)|(af.B.l&1)|(parity[hl.B.l]); /* 10101000 */
	if(hl.B.l) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[hl.B.l]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_l(void) /* out(c),l */
{
	out(bc.B.h,bc.B.l,hl.B.l);
	t_add(12);
}

void adc_hl_hl(void) /* adc hl,hl */
{
	adc16(hl.W,hl.W);
	t_add(15);
}

void ld_hl_aXXXX(void) /* ld hl,(XXXX) */
{
	hl.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void rld(void) /* rld INCOMPLETE */
{
	register UC c_hl;

	c_hl=speekb(hl.W);
	spokeb(hl.W,(c_hl<<4)|(af.B.h&0x0F));
	af.B.h=(c_hl>>4)|(af.B.h&0xF0);

	af.B.l=(af.B.h&190)|(af.B.l&1); /* Keep Cf and Set Zf to 0 */
	if(!af.B.h) SET_ZF; /* And the Sign flag is used */
	t_add(18);
}

void in_f_c(void) /* in f,(c) */
{
	af.B.l=in(bc.B.h,bc.B.l);
#ifdef OLD_IN
	if(af.B.l) RES_ZF; else SET_ZF;        /* SZ-H-PNC */
	af.B.l=(af.B.l&0xE9)|(parity[af.B.l]); /* 11101001 */
#else
	af.B.l=in_table[af.B.l]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_0(void) /* out(c),0 */
{
	out(bc.B.h,bc.B.l,0);
	t_add(12);
}

void sbc_hl_sp(void) /* sbc hl,sp */
{
	sbc16(hl.W,sp.W);
	t_add(15);
}

void ld_aXXXX_sp(void) /* ld(XXXX),sp */
{
	wordpoke(wordpeek(pc.W),sp.W);
	pc.W+=2;
	t_add(20);
}

void in_a_c(void) /* in a,(c) */
{
	af.B.h=in(bc.B.h,bc.B.l);                         /* SZ-H-PNC */
#ifdef OLD_IN
	af.B.l=(af.B.h&0xA8)|(af.B.l&1)|(parity[af.B.h]); /* 10101000 */
	if(af.B.h) RES_ZF; else SET_ZF;
#else
	af.B.l=in_table[af.B.h]|(af.B.l&1);
#endif
	t_add(12);
}

void out_c_a(void) /* out(c),a */
{
	out(bc.B.h,bc.B.l,af.B.h);
	t_add(12);
}

void adc_hl_sp(void) /* adc hl,sp */
{
	adc16(hl.W,sp.W);
	t_add(15);
}

void ld_sp_aXXXX(void) /* ld sp,(XXXX) */
{
	sp.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void ldi(void) /* ldi */
{
	spokeb(de.W,speekb(hl.W));
	de.W++;
	hl.W++;
	bc.W--;
	SET_PF;
	if(!bc.W)
	{
		af.B.l&=233; /* reset Nf,Hf,Pf */
	}
	else
	{
		af.B.l&=237; /* reset Nf,Hf */
	}
	t_add(16);
}

void cpi(void) /* cpi UNTESTED */
{
	register UC btemp;

	btemp=af.B.l&1;
	cp_sub8(speekb(hl.W),af.B.h);/* Keep Cf */
	af.B.l=(af.B.l&254)|btemp;
	hl.W++;
	bc.W--;
	if(!bc.W)
	{
		RES_PF;
	}
	else
	{
		SET_PF;
	}
	t_add(16);
}

void ini(void) /* ini UNTESTED */
{
	spokeb(hl.W,in(bc.B.h,bc.B.l));
	hl.W++;
	bc.B.h--;
	if(!bc.B.h) SET_ZF; else RES_ZF;
	SET_NF;
	t_add(16);
}

void outi(void) /* outi UNTESTED */
{
	bc.B.h--; /* Pre-decremented according to some */
	out(bc.B.h,bc.B.l,speekb(hl.W));
	hl.W++;
	if(!bc.B.h) SET_ZF; else RES_ZF;
	SET_NF;
	t_add(16);
}

void ldd(void) /* ldd */
{
	spokeb(de.W,speekb(hl.W));
	de.W--;
	hl.W--;
	bc.W--;
	SET_PF;
	if(!bc.W)
	{
		af.B.l&=233; /* reset Nf,Hf,Pf */
	}
	else
	{
		af.B.l&=237; /* reset Nf,Hf */
	}
	t_add(16);
}

void cpd(void) /* cpd UNTESTED */
{
	register UC btemp;

	btemp=af.B.l&1;
	cp_sub8(speekb(hl.W),af.B.h);/* Keep Cf */
	af.B.l=(af.B.l&254)|btemp;
	hl.W--;
	bc.W--;
	if(!bc.W)
	{
		RES_PF;
	}
	else
	{
		SET_PF;
	}
	t_add(16);
}

void ind(void) /* ind UNTESTED */
{
	spokeb(hl.W,in(bc.B.h,bc.B.l));
	hl.W--;
	bc.B.h--;
	if(!bc.B.h) SET_ZF; else RES_ZF;
	SET_NF;
	t_add(16);
}

void outd(void) /* outd UNTESTED */
{
	bc.B.h--; /* Pre-decremented according to some */
	out(bc.B.h,bc.B.l,speekb(hl.W));
	hl.W--;
	if(!bc.B.h) SET_ZF; else RES_ZF;
	SET_NF;
	t_add(16);
}

void ldir(void) /*ldir */
{
	spokeb(de.W,speekb(hl.W));
	de.W++;
	hl.W++;
	bc.W--;
	SET_PF;
	if(!bc.W)
	{
		af.B.l&=233; /* reset Nf,Hf,Pf */
		t_add(16);
	}
	else
	{
		af.B.l&=237; /* reset Nf,Hf */
		t_add(21);
		pc.W-=2;
	}
}

void cpir(void) /* cpir UNTESTED */
{
	register UC btemp;

	btemp=af.B.l&1;
	cp_sub8(speekb(hl.W),af.B.h);/* Keep Cf */
	af.B.l=(af.B.l&254)|btemp;
	hl.W++;
	bc.W--;
	if(!bc.W)
	{
		RES_PF;
		t_add(16); /* Hmmm */
		return; /* Hmmm */
	}
	else
	{
		SET_PF;
	}
	if(af.B.l&64) /* Zf=1 */
	{
		t_add(16);
	}
	else
	{
		t_add(21);
		pc.W-=2;
	}
}

void inir(void) /* inir UNTESTED */
{
	spokeb(hl.W,in(bc.B.h,bc.B.l));
	hl.W++;
	SET_NF;
	bc.B.h--;
	if(!bc.B.h)
	{
		SET_ZF;
		t_add(16);
	}
	else
	{
		RES_ZF;
		t_add(21);
		pc.W-=2;
	}
}

void otir(void) /* otir UNTESTED */
{
	bc.B.h--; /* Pre-decremented according to some */
	out(bc.B.h,bc.B.l,speekb(hl.W));
	hl.W++;
	SET_NF;
	if(!bc.B.h)
	{
		SET_ZF;
		t_add(16);
	}
	else
	{
		RES_ZF;
		t_add(21);
		pc.W-=2;
	}
}

void lddr(void) /* lddr */
{
	spokeb(de.W,speekb(hl.W));
	de.W--;
	hl.W--;
	bc.W--;
	SET_PF;
	if(!bc.W)
	{
		af.B.l&=233; /* reset Nf,Hf,Pf */
		t_add(16);
	}
	else
	{
		af.B.l&=237; /* reset Nf,Hf */
		t_add(21);
		pc.W-=2;
	}
}

void cpdr(void) /* cpdr UNTESTED */
{
	register UC btemp;

	btemp=af.B.l&1;
	cp_sub8(speekb(hl.W),af.B.h);/* Keep Cf */
	af.B.l=(af.B.l&254)|btemp;
	hl.W--;
	bc.W--;
	if(!bc.W)
	{
		RES_PF;
		t_add(16);
		return;
	}
	else
	{
		SET_PF;
	}
	if(af.B.l&64) /* Zf=1 */
	{
		t_add(16);
	}
	else
	{
		t_add(21);
		pc.W-=2;
	}
}

void indr(void) /* indr UNTESTED */
{
	spokeb(hl.W,in(bc.B.h,bc.B.l));
	hl.W--;
	SET_NF;
	bc.B.h--;
	if(!bc.B.h)
	{
		SET_ZF;
		t_add(16);
	}
	else
	{
		RES_ZF;
		t_add(21);
		pc.W-=2;
	}
}

void otdr(void) /* otdr UNTESTED */
{
	bc.B.h--; /* Pre-decremented according to some */
	out(bc.B.h,bc.B.l,speekb(hl.W));
	hl.W--;
	SET_NF;
	if(!bc.B.h)
	{
		SET_ZF;
		t_add(16);
	}
	else
	{
		RES_ZF;
		t_add(21);
		pc.W-=2;
	}
}

void Ill_ED(void)
{
/*	error_str="Illegal ED instruction";
	quit=QUIT_COMPLETELY;*/
	t_add(8);
}

void load_trap(void)
{
	word temp;

	if(pc.W!=1388)
	{
		Ill_ED();
		return;
	}
	else
	{
		if(!(TAP_load(af2.B.h,ix.W,de.W)))
		{
			af2.B.l&=191; /* RES_ZF of f' */
			af2.B.l&=254; /* RES_CF of f' */
		}
		else
		{
			af2.B.l|=64;  /* SET_ZF of f' */
		}
		temp=af.W;af.W=af2.W;af2.W=temp; /* ex af,af' */
		pc.W=1506;
	}
}
