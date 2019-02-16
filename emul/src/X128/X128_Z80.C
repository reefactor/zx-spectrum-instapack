/******************************************/
/**                                      **/
/**         X128_Z80 Portable File       **/
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
#define Z80_OBJ

#include "x128_end.c"
#include "x128_def.c"
#include "x128_z80.h"

void nop(void) /* nop */
{
	t_add(4);
}

void ld_bc_XXXX(void) /* ld bc,XXXX */
{
	bc.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(10);
}

void ld_mbc_a(void) /* ld (bc),a */
{
	spokeb(bc.W,af.B.h);
	t_add(7);
}

void inc_bc(void) /* inc bc */
{
	bc.W++;
	t_add(6);
}

void inc_b(void) /* inc b TABLE UNTESTED */
{
	af.B.l=inc_f[bc.B.h]|(af.B.l&1); /* Keep Cf */
	bc.B.h++;
	t_add(4);
}

void dec_b(void) /* dec b TABLE UNTESTED */
{
	af.B.l=dec_f[bc.B.h]|(af.B.l&1); /* Keep Cf */
	bc.B.h--;
	t_add(4);
}

void ld_b_XX(void) /* ld b,XX */
{
	bc.B.h=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void rlca(void) /* rlca TABLE UNTESTED */
{
	af.B.l=rlca_f[af.B.h]|(af.B.l&196); /* Keep SZP */
	af.B.h=rlca_a[af.B.h];
	t_add(4);
}

void ex_af_af(void) /* ex af,af' */
{
	register word temp;

	temp=af.W;
	af.W=af2.W;
	af2.W=temp;
	t_add(4);
}

void add_ix_bc(void) /* add ix,bc */
{
	add16(ix.W,bc.W);
	t_add(15);
}

void add_iy_bc(void) /* add iy,bc */
{
	add16(iy.W,bc.W);
	t_add(15);
}

void add_hl_bc(void) /* add hl,bc */
{
	add16(hl.W,bc.W);
	t_add(11);
}

void ld_a_mbc(void) /* ld a,(bc) */
{
	af.B.h=speekb(bc.W);
	t_add(7);
}

void dec_bc(void) /* dec bc */
{
	bc.W--;
	t_add(6);
}

void inc_c(void) /* inc c TABLE UNTESTED */
{
	af.B.l=inc_f[bc.B.l]|(af.B.l&1); /* Keep Cf */
	bc.B.l++;
	t_add(4);
}

void dec_c(void) /* dec c TABLE UNTESTED */
{
	af.B.l=dec_f[bc.B.l]|(af.B.l&1); /* Keep Cf */
	bc.B.l--;
	t_add(4);
}

void ld_c_XX(void) /* ld c,XX */
{
	bc.B.l=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void rrca(void) /* rrca TABLE UNTESTED */
{
	af.B.l=rrca_f[af.B.h]|(af.B.l&196); /* Keep SZP */
	af.B.h=rrca_a[af.B.h];
	t_add(4);
}

void djnz_DIS(void) /* djnz DIS  */
{
	bc.B.h--;
	if(bc.B.h)
	{
		pc.W+=(signed char)speekb(pc.W)+1;
		t_add(13);
	}
	else
	{
		pc.W++;
		t_add(8);
	}
}

void ld_de_XXXX(void) /* ld de,XXXX */
{
	de.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(10);
}

void ld_mde_a(void) /* ld(de),a */
{
	spokeb(de.W,af.B.h);
	t_add(7);
}

void inc_de(void) /* inc de */
{
	de.W++;
	t_add(6);
}

void inc_d(void) /* inc d TABLE UNTESTED */
{
	af.B.l=inc_f[de.B.h]|(af.B.l&1); /* Keep Cf */
	de.B.h++;
	t_add(4);
}

void dec_d(void) /* dec d TABLE UNTESTED */
{
	af.B.l=dec_f[de.B.h]|(af.B.l&1); /* Keep Cf */
	de.B.h--;
	t_add(4);
}

void ld_d_XX(void) /* ld d,XX */
{
	de.B.h=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void rla(void) /* rla */
{
	if(!(af.B.l&1))
	{
		af.B.l=rla_f0[af.B.h]|(af.B.l&196); /* Keep SZP */
		af.B.h=rla_a0[af.B.h];
	}
	else
	{
		af.B.l=rla_f0[af.B.h]|(af.B.l&196);
		af.B.h=rla_a1[af.B.h];
	}
	t_add(4);
}

void jr_DIS(void) /* jr DIS */
{
	pc.W+=(signed char)speekb(pc.W)+1;
	t_add(12);
}

void add_ix_de(void) /* add ix,de */
{
	add16(ix.W,de.W);
	t_add(15);
}

void add_iy_de(void) /* add iy,de */
{
	add16(iy.W,de.W);
	t_add(15);
}

void add_hl_de(void) /* add hl,de */
{
	add16(hl.W,de.W);
	t_add(11);
}

void ld_a_mde(void) /* ld a,(de) */
{
	af.B.h=speekb(de.W);
	t_add(7);
}

void dec_de(void) /* dec de */
{
	de.W--;
	t_add(6);
}

void inc_e(void) /* inc e TABLE UNTESTED */
{
	af.B.l=inc_f[de.B.l]|(af.B.l&1); /* Keep Cf */
	de.B.l++;
	t_add(4);
}

void dec_e(void) /* dec e TABLE UNTESTED */
{
	af.B.l=dec_f[de.B.l]|(af.B.l&1); /* Keep Cf */
	de.B.l--;
	t_add(4);
}

void ld_e_XX(void) /* ld e,XX */
{
	de.B.l=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void rra(void) /* rra */
{
	if(!(af.B.l&1))
	{
		af.B.l=rra_f0[af.B.h]|(af.B.l&196); /* Keep SZP */
		af.B.h=rra_a0[af.B.h];
	}
	else
	{
		af.B.l=rra_f0[af.B.h]|(af.B.l&196);
		af.B.h=rra_a1[af.B.h];
	}
	t_add(4);
}

void jr_nz_DIS(void) /* jr nz,DIS */
{
	if(!(af.B.l&64))
	{
		pc.W+=(signed char)speekb(pc.W)+1;
		t_add(12);
	}
	else
	{
		pc.W++;
		t_add(7);
	}
}

void ld_ix_XXXX(void) /* ld ix,XXXX */
{
	ix.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(14);
}

void ld_iy_XXXX(void) /* ld iy,XXXX */
{
	iy.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(14);
}

void ld_hl_XXXX(void) /* ld hl,XXXX */
{
	hl.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(10);
}

void Z80ld_aXXXX_ix(void) /* ld(XXXX),ix */
{
	wordpoke(wordpeek(pc.W),ix.W);
	pc.W+=2;
	t_add(20);
}

void Z80ld_aXXXX_iy(void) /* ld(XXXX),iy */
{
	wordpoke(wordpeek(pc.W),iy.W);
	pc.W+=2;
	t_add(20);
}

void Z80ld_aXXXX_hl(void) /* ld(XXXX),hl */
{
	wordpoke(wordpeek(pc.W),hl.W);
	pc.W+=2;
	t_add(16);
}

void inc_ix(void) /* inc ix */
{
	ix.W++;
	t_add(10);
}

void inc_iy(void) /* inc iy */
{
	iy.W++;
	t_add(10);
}

void inc_hl(void) /* inc hl */
{
	hl.W++;
	t_add(6);
}

void inc_ixh(void) /* inc ixh TABLE UNTESTED */
{
	af.B.l=inc_f[ix.B.h]|(af.B.l&1); /* Keep Cf */
	ix.B.h++;
	t_add(8);
}

void inc_iyh(void) /* inc iyh TABLE UNTESTED */
{
	af.B.l=inc_f[iy.B.h]|(af.B.l&1); /* Keep Cf */
	iy.B.h++;
	t_add(8);
}

void inc_h(void) /* inc h TABLE UNTESTED */
{
	af.B.l=inc_f[hl.B.h]|(af.B.l&1); /* Keep Cf */
	hl.B.h++;
	t_add(4);
}

void dec_ixh(void) /* dec ixh TABLE UNTESTED */
{
	af.B.l=dec_f[ix.B.h]|(af.B.l&1); /* Keep Cf */
	ix.B.h--;
	t_add(8);
}

void dec_iyh(void) /* dec iyh TABLE UNTESTED */
{
	af.B.l=dec_f[iy.B.h]|(af.B.l&1); /* Keep Cf */
	iy.B.h--;
	t_add(8);
}

void dec_h(void) /* dec h TABLE UNTESTED */
{
	af.B.l=dec_f[hl.B.h]|(af.B.l&1); /* Keep Cf */
	hl.B.h--;
	t_add(4);
}

void ld_ixh_XX(void) /* ld ixh,XX */
{
	ix.B.h=speekb(pc.W);
	pc.W++;
	t_add(11);
}

void ld_iyh_XX(void) /* ld iyh,XX */
{
	iy.B.h=speekb(pc.W);
	pc.W++;
	t_add(11);
}

void ld_h_XX(void) /* ld h,XX */
{
	hl.B.h=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void daa(void) /* daa INCOMPLETE! */
{
	register UC daa_select;

	daa_select=af.B.l&19; /* HNC flags */
	if(daa_select&16) /* Hf Set (DAA) */
	{
		af.B.l=daa_f[daa_select-12][af.B.h];
		af.B.h=daa_a[daa_select-12][af.B.h];
	}
	else /* Hf not set (DAS) */
	{
		af.B.l=daa_f[daa_select][af.B.h];
		af.B.h=daa_a[daa_select][af.B.h];
	}
	t_add(4);
}

void jr_z_DIS(void) /* jr z,DIS */
{
	if((af.B.l&64))
	{
		pc.W+=(signed char)speekb(pc.W)+1;
		t_add(12);
	}
	else
	{
		pc.W++;
		t_add(7);
	}
}

void add_ix_ix(void) /* add ix,ix */
{
	add16(ix.W,ix.W);
	t_add(15);
}

void add_iy_iy(void) /* add iy,iy */
{
	add16(iy.W,iy.W);
	t_add(15);
}

void add_hl_hl(void) /* add hl,hl */
{
	add16(hl.W,hl.W);
	t_add(11);
}

void Z80ld_ix_aXXXX(void) /* ld ix,(XXXX) */
{
	ix.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void Z80ld_iy_aXXXX(void) /* ld iy,(XXXX) */
{
	iy.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(20);
}

void Z80ld_hl_aXXXX(void) /* ld hl,(XXXX) */
{
	hl.W=wordpeek(wordpeek(pc.W));
	pc.W+=2;
	t_add(16);
}

void dec_ix(void) /* dec ix */
{
	ix.W--;
	t_add(10);
}

void dec_iy(void) /* dec iy */
{
	iy.W--;
	t_add(10);
}

void dec_hl(void) /* dec hl */
{
	hl.W--;
	t_add(6);
}

void inc_ixl(void) /* inc ixl TABLE UNTESTED */
{
	af.B.l=inc_f[ix.B.l]|(af.B.l&1); /* Keep Cf */
	ix.B.l++;
	t_add(8);
}

void inc_iyl(void) /* inc iyl TABLE UNTESTED */
{
	af.B.l=inc_f[iy.B.l]|(af.B.l&1); /* Keep Cf */
	iy.B.l++;
	t_add(8);
}

void inc_l(void) /* inc l TABLE UNTESTED */
{
	af.B.l=inc_f[hl.B.l]|(af.B.l&1); /* Keep Cf */
	hl.B.l++;
	t_add(4);
}

void dec_ixl(void) /* dec ixl TABLE UNTESTED */
{
	af.B.l=dec_f[ix.B.l]|(af.B.l&1); /* Keep Cf */
	ix.B.l--;
	t_add(8);
}

void dec_iyl(void) /* dec iyl TABLE UNTESTED */
{
	af.B.l=dec_f[iy.B.l]|(af.B.l&1); /* Keep Cf */
	iy.B.l--;
	t_add(8);
}

void dec_l(void) /* dec l TABLE UNTESTED */
{
	af.B.l=dec_f[hl.B.l]|(af.B.l&1); /* Keep Cf */
	hl.B.l--;
	t_add(4);
}

void ld_ixl_XX(void) /* ld ixl,XX */
{
	ix.B.l=speekb(pc.W);
	pc.W++;
	t_add(11);
}

void ld_iyl_XX(void) /* ld iyl,XX */
{
	iy.B.l=speekb(pc.W);
	pc.W++;
	t_add(11);
}

void ld_l_XX(void) /* ld l,XX */
{
	hl.B.l=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void cpl(void) /* cpl */
{
	af.B.h^=255;
	af.B.l|=18; /* set Hf,Nf */
	copy_b53(af.B.h);
	t_add(4);
}

void jr_nc_DIS(void) /* jr nc,DIS */
{
	if(!(af.B.l&1))
	{
		pc.W+=(signed char)speekb(pc.W)+1;
		t_add(12);
	}
	else
	{
		pc.W++;
		t_add(7);
	}
}

void ld_sp_XXXX(void) /* ld sp,XXXX */
{
	sp.W=wordpeek(pc.W);
	pc.W+=2;
	t_add(10);
}

void ld_aXXXX_a(void) /* ld(XXXX),a */
{
	spokeb(wordpeek(pc.W),af.B.h);
	pc.W+=2;
	t_add(13);
}

void inc_sp(void) /* inc sp */
{
	sp.W++;
	t_add(6);
}

void inc_mix(void) /* inc(ix) TABLE UNTESTED */
{
	register UC btemp;
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	btemp=speekb(ix.W+dis);
	af.B.l=inc_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(ix.W+dis,btemp+1);
	t_add(23);
}

void inc_miy(void) /* inc(iy) TABLE UNTESTED */
{
	register UC btemp;
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	btemp=speekb(iy.W+dis);
	af.B.l=inc_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(iy.W+dis,btemp+1);
	t_add(23);
}

void inc_mhl(void) /* inc(hl) TABLE UNTESTED */
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=inc_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(hl.W,btemp+1);
	t_add(11);
}

void dec_mix(void) /* dec(ix) TABLE UNTESTED */
{
	register UC btemp;
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	btemp=speekb(ix.W+dis);
	af.B.l=dec_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(ix.W+dis,btemp-1);
	t_add(23);
}

void dec_miy(void) /* dec(iy) TABLE UNTESTED */
{
	register UC btemp;
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	btemp=speekb(iy.W+dis);
	af.B.l=dec_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(iy.W+dis,btemp-1);
	t_add(23);
}

void dec_mhl(void) /* dec(hl) TABLE UNTESTED */
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=dec_f[btemp]|(af.B.l&1); /* Keep Cf */
	spokeb(hl.W,btemp-1);
	t_add(11);
}

void ld_mix_XX(void) /* ld(ix),XX */
{
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	spokeb(ix.W+dis,speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_miy_XX(void) /* ld(iy),XX */
{
	register signed char dis;

	dis=speekb(pc.W);
	pc.W++;
	spokeb(iy.W+dis,speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_mhl_XX(void) /* ld(hl),XX */
{
	spokeb(hl.W,speekb(pc.W));
	pc.W++;
	t_add(10);
}

void scf(void) /* scf */
{
	af.B.l&=237; /* reset Hf,Nf */
	copy_b53(af.B.h);
	SET_CF;
	t_add(4);
}

void jr_c_DIS(void) /* jr c,DIS */
{
	if((af.B.l&1))
	{
		pc.W+=(signed char)speekb(pc.W)+1;
		t_add(12);
	}
	else
	{
		pc.W++;
		t_add(7);
	}
}

void add_ix_sp(void) /* add ix,sp */
{
	add16(ix.W,sp.W);
	t_add(15);
}

void add_iy_sp(void) /* add iy,sp */
{
	add16(iy.W,sp.W);
	t_add(15);
}

void add_hl_sp(void) /* add hl,sp */
{
	add16(hl.W,sp.W);
	t_add(11);
}

void ld_a_aXXXX(void) /* ld a,(XXXX) */
{
	af.B.h=speekb(wordpeek(pc.W));
	pc.W+=2;
	t_add(13);
}

void dec_sp(void) /* dec sp */
{
	sp.W--;
	t_add(6);
}

void Z80inc_a(void) /* inc a TABLE UNTESTED */
{
	af.B.l=inc_f[af.B.h]|(af.B.l&1); /* Keep Cf */
	af.B.h++;
	t_add(4);
}

void Z80dec_a(void) /* dec a TABLE UNTESTED */
{
	af.B.l=dec_f[af.B.h]|(af.B.l&1); /* Keep Cf */
	af.B.h--;
	t_add(4);
}

void ld_a_XX(void) /* ld a,XX */
{
	af.B.h=speekb(pc.W);
	pc.W++;
	t_add(7);
}

void ccf(void) /* ccf */
{
	af.B.l^=1;
	RES_NF;
	copy_b53(af.B.h);
	t_add(4);
}

void ld_b_b(void) /* ld b,b */
{
	bc.B.h=bc.B.h;
	t_add(4);
}

void ld_b_c(void) /* ld b,c */
{
	bc.B.h=bc.B.l;
	t_add(4);
}

void ld_b_d(void) /* ld b,d */
{
	bc.B.h=de.B.h;
	t_add(4);
}

void ld_b_e(void) /* ld b,e */
{
	bc.B.h=de.B.l;
	t_add(4);
}

void ld_b_ixh(void) /* ld b,ixh */
{
	bc.B.h=ix.B.h;
	t_add(8);
}

void ld_b_iyh(void) /* ld b,iyh */
{
	bc.B.h=iy.B.h;
	t_add(8);
}

void ld_b_h(void) /* ld b,h */
{
	bc.B.h=hl.B.h;
	t_add(4);
}

void ld_b_ixl(void) /* ld b,ixl */
{
	bc.B.h=ix.B.l;
	t_add(8);
}

void ld_b_iyl(void) /* ld b,iyl */
{
	bc.B.h=iy.B.l;
	t_add(8);
}

void ld_b_l(void) /* ld b,l */
{
	bc.B.h=hl.B.l;
	t_add(4);
}

void ld_b_ix(void) /* ld b,(ix+DIS) */
{
	bc.B.h=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_b_iy(void) /* ld b,(iy+DIS) */
{
	bc.B.h=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_b_hl(void) /* ld b,(hl) */
{
	bc.B.h=speekb(hl.W);
	t_add(7);
}

void ld_b_a(void) /* ld b,a */
{
	bc.B.h=af.B.h;
	t_add(4);
}

void ld_c_b(void) /* ld c,b */
{
	bc.B.l=bc.B.h;
	t_add(4);
}

void ld_c_c(void) /* ld c,c */
{
	bc.B.l=bc.B.l;
	t_add(4);
}

void ld_c_d(void) /* ld c,d */
{
	bc.B.l=de.B.h;
	t_add(4);
}

void ld_c_e(void) /* ld c,e */
{
	bc.B.l=de.B.l;
	t_add(4);
}

void ld_c_ixh(void) /* ld c,ixh */
{
	bc.B.l=ix.B.h;
	t_add(8);
}

void ld_c_iyh(void) /* ld c,iyh */
{
	bc.B.l=iy.B.h;
	t_add(8);
}

void ld_c_h(void) /* ld c,h */
{
	bc.B.l=hl.B.h;
	t_add(4);
}

void ld_c_ixl(void) /* ld c,ixl */
{
	bc.B.l=ix.B.l;
	t_add(8);
}

void ld_c_iyl(void) /* ld c,iyl */
{
	bc.B.l=iy.B.l;
	t_add(8);
}

void ld_c_l(void) /* ld c,l */
{
	bc.B.l=hl.B.l;
	t_add(4);
}

void ld_c_ix(void) /* ld c,(ix+DIS) */
{
	bc.B.l=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_c_iy(void) /* ld c,(iy+DIS) */
{
	bc.B.l=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_c_hl(void) /* ld c,(hl) */
{
	bc.B.l=speekb(hl.W);
	t_add(7);
}

void ld_c_a(void) /* ld c,a */
{
	bc.B.l=af.B.h;
	t_add(4);
}

void ld_d_b(void) /* ld d,b */
{
	de.B.h=bc.B.h;
	t_add(4);
}

void ld_d_c(void) /* ld d,c */
{
	de.B.h=bc.B.l;
	t_add(4);
}

void ld_d_d(void) /* ld d,d */
{
	de.B.h=de.B.h;
	t_add(4);
}

void ld_d_e(void) /* ld d,e */
{
	de.B.h=de.B.l;
	t_add(4);
}

void ld_d_ixh(void) /* ld d,ixh */
{
	de.B.h=ix.B.h;
	t_add(8);
}

void ld_d_iyh(void) /* ld d,iyh */
{
	de.B.h=iy.B.h;
	t_add(8);
}

void ld_d_h(void) /* ld d,h */
{
	de.B.h=hl.B.h;
	t_add(4);
}

void ld_d_ixl(void) /* ld d,ixl */
{
	de.B.h=ix.B.l;
	t_add(8);
}

void ld_d_iyl(void) /* ld d,iyl */
{
	de.B.h=iy.B.l;
	t_add(8);
}

void ld_d_l(void) /* ld d,l */
{
	de.B.h=hl.B.l;
	t_add(4);
}

void ld_d_ix(void) /* ld d,(ix+DIS) */
{
	de.B.h=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_d_iy(void) /* ld d,(iy+DIS) */
{
	de.B.h=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_d_hl(void) /* ld d,(hl) */
{
	de.B.h=speekb(hl.W);
	t_add(7);
}

void ld_d_a(void) /* ld d,a */
{
	de.B.h=af.B.h;
	t_add(4);
}

void ld_e_b(void) /* ld e,b */
{
	de.B.l=bc.B.h;
	t_add(4);
}

void ld_e_c(void) /* ld e,c */
{
	de.B.l=bc.B.l;
	t_add(4);
}

void ld_e_d(void) /* ld e,d */
{
	de.B.l=de.B.h;
	t_add(4);
}

void ld_e_e(void) /* ld e,e */
{
	de.B.l=de.B.l;
	t_add(4);
}

void ld_e_ixh(void) /* ld e,ixh */
{
	de.B.l=ix.B.h;
	t_add(8);
}

void ld_e_iyh(void) /* ld e,iyh */
{
	de.B.l=iy.B.h;
	t_add(8);
}

void ld_e_h(void) /* ld e,h */
{
	de.B.l=hl.B.h;
	t_add(4);
}

void ld_e_ixl(void) /* ld e,ixl */
{
	de.B.l=ix.B.l;
	t_add(8);
}

void ld_e_iyl(void) /* ld e,iyl */
{
	de.B.l=iy.B.l;
	t_add(8);
}

void ld_e_l(void) /* ld e,l */
{
	de.B.l=hl.B.l;
	t_add(4);
}

void ld_e_ix(void) /* ld e,(ix+DIS) */
{
	de.B.l=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_e_iy(void) /* ld e,(iy+DIS) */
{
	de.B.l=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_e_hl(void) /* ld e,(hl) */
{
	de.B.l=speekb(hl.W);
	t_add(7);
}

void ld_e_a(void) /* ld e,a */
{
	de.B.l=af.B.h;
	t_add(4);
}

void ld_ixh_b(void) /* ld ixh,b */
{
	ix.B.h=bc.B.h;
	t_add(8);
}

void ld_iyh_b(void) /* ld iyh,b */
{
	iy.B.h=bc.B.h;
	t_add(8);
}

void ld_h_b(void) /* ld h,b */
{
	hl.B.h=bc.B.h;
	t_add(4);
}

void ld_ixh_c(void) /* ld ixh,c */
{
	ix.B.h=bc.B.l;
	t_add(8);
}

void ld_iyh_c(void) /* ld iyh,c */
{
	iy.B.h=bc.B.l;
	t_add(8);
}

void ld_h_c(void) /* ld h,c */
{
	hl.B.h=bc.B.l;
	t_add(4);
}

void ld_ixh_d(void) /* ld ixh,d */
{
	ix.B.h=de.B.h;
	t_add(8);
}

void ld_iyh_d(void) /* ld iyh,d */
{
	iy.B.h=de.B.h;
	t_add(8);
}

void ld_h_d(void) /* ld h,d */
{
	hl.B.h=de.B.h;
	t_add(4);
}

void ld_ixh_e(void) /* ld ixh,e */
{
	ix.B.h=de.B.l;
	t_add(8);
}

void ld_iyh_e(void) /* ld iyh,e */
{
	iy.B.h=de.B.l;
	t_add(8);
}

void ld_h_e(void) /* ld h,e */
{
	hl.B.h=de.B.l;
	t_add(4);
}

void ld_ixh_ixh(void) /* ld ixh,ixh */
{
	ix.B.h=ix.B.h;
	t_add(8);
}

void ld_iyh_iyh(void) /* ld iyh,iyh */
{
	iy.B.h=iy.B.h;
	t_add(8);
}

void ld_h_h(void) /* ld h,h */
{
	hl.B.h=hl.B.h;
	t_add(4);
}

void ld_ixh_ixl(void) /* ld ixh,ixl */
{
	ix.B.h=ix.B.l;
	t_add(8);
}

void ld_iyh_iyl(void) /* ld iyh,iyl */
{
	iy.B.h=iy.B.l;
	t_add(8);
}

void ld_h_l(void) /* ld h,l */
{
	hl.B.h=hl.B.l;
	t_add(4);
}

void ld_h_ix(void) /* ld h,(ix+DIS) */
{
	hl.B.h=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_h_iy(void) /* ld h,(iy+DIS) */
{
	hl.B.h=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_h_hl(void) /* ld h,(hl) */
{
	hl.B.h=speekb(hl.W);
	t_add(7);
}

void ld_ixh_a(void) /* ld ixh,a */
{
	ix.B.h=af.B.h;
	t_add(8);
}

void ld_iyh_a(void) /* ld iyh,a */
{
	iy.B.h=af.B.h;
	t_add(8);
}

void ld_h_a(void) /* ld h,a */
{
	hl.B.h=af.B.h;
	t_add(4);
}

void ld_ixl_b(void) /* ld ixl,b */
{
	ix.B.l=bc.B.h;
	t_add(8);
}

void ld_iyl_b(void) /* ld iyl,b */
{
	iy.B.l=bc.B.h;
	t_add(8);
}

void ld_l_b(void) /* ld l,b */
{
	hl.B.l=bc.B.h;
	t_add(4);
}

void ld_ixl_c(void) /* ld ixl,c */
{
	ix.B.l=bc.B.l;
	t_add(8);
}

void ld_iyl_c(void) /* ld iyl,c */
{
	iy.B.l=bc.B.l;
	t_add(8);
}

void ld_l_c(void) /* ld l,c */
{
	hl.B.l=bc.B.l;
	t_add(4);
}

void ld_ixl_d(void) /* ld ixl,d */
{
	ix.B.l=de.B.h;
	t_add(8);
}

void ld_iyl_d(void) /* ld iyl,d */
{
	iy.B.l=de.B.h;
	t_add(8);
}

void ld_l_d(void) /* ld l,d */
{
	hl.B.l=de.B.h;
	t_add(4);
}

void ld_ixl_e(void) /* ld ixl,e */
{
	ix.B.l=de.B.l;
	t_add(8);
}

void ld_iyl_e(void) /* ld iyl,e */
{
	iy.B.l=de.B.l;
	t_add(8);
}

void ld_l_e(void) /* ld l,e */
{
	hl.B.l=de.B.l;
	t_add(4);
}

void ld_ixl_ixh(void) /* ld ixl,ixh */
{
	ix.B.l=ix.B.h;
	t_add(8);
}

void ld_iyl_iyh(void) /* ld iyl,iyh */
{
	iy.B.l=iy.B.h;
	t_add(8);
}

void ld_l_h(void) /* ld l,h */
{
	hl.B.l=hl.B.h;
	t_add(4);
}

void ld_ixl_ixl(void) /* ld ixl,ixl */
{
	ix.B.l=ix.B.l;
	t_add(8);
}

void ld_iyl_iyl(void) /* ld iyl,iyl */
{
	iy.B.l=iy.B.l;
	t_add(8);
}

void ld_l_l(void) /* ld l,l */
{
	hl.B.l=hl.B.l;
	t_add(4);
}

void ld_l_ix(void) /* ld l,(ix+DIS) */
{
	hl.B.l=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_l_iy(void) /* ld l,(iy+DIS) */
{
	hl.B.l=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_l_hl(void) /* ld l,(hl) */
{
	hl.B.l=speekb(hl.W);
	t_add(7);
}

void ld_ixl_a(void) /* ld ixl,a */
{
	ix.B.l=af.B.h;
	t_add(8);
}

void ld_iyl_a(void) /* ld iyl,a */
{
	iy.B.l=af.B.h;
	t_add(8);
}

void ld_l_a(void) /* ld l,a */
{
	hl.B.l=af.B.h;
	t_add(4);
}

void ld_ix_b(void) /* ld (ix+DIS),b */
{
	spokeb(ix.W+(signed char)speekb(pc.W),bc.B.h);
	pc.W++;
	t_add(19);
}

void ld_iy_b(void) /* ld (iy+DIS),b */
{
	spokeb(iy.W+(signed char)speekb(pc.W),bc.B.h);
	pc.W++;
	t_add(19);
}

void ld_hl_b(void) /* ld (hl),b */
{
	spokeb(hl.W,bc.B.h);
	t_add(7);
}

void ld_ix_c(void) /* ld (ix+DIS),c */
{
	spokeb(ix.W+(signed char)speekb(pc.W),bc.B.l);
	pc.W++;
	t_add(19);
}

void ld_iy_c(void) /* ld (iy+DIS),c */
{
	spokeb(iy.W+(signed char)speekb(pc.W),bc.B.l);
	pc.W++;
	t_add(19);
}

void ld_hl_c(void) /* ld (hl),c */
{
	spokeb(hl.W,bc.B.l);
	t_add(7);
}

void ld_ix_d(void) /* ld (ix+DIS),d */
{
	spokeb(ix.W+(signed char)speekb(pc.W),de.B.h);
	pc.W++;
	t_add(19);
}

void ld_iy_d(void) /* ld (iy+DIS),d */
{
	spokeb(iy.W+(signed char)speekb(pc.W),de.B.h);
	pc.W++;
	t_add(19);
}

void ld_hl_d(void) /* ld (hl),d */
{
	spokeb(hl.W,de.B.h);
	t_add(7);
}

void ld_ix_e(void) /* ld (ix+DIS),e */
{
	spokeb(ix.W+(signed char)speekb(pc.W),de.B.l);
	pc.W++;
	t_add(19);
}

void ld_iy_e(void) /* ld (iy+DIS),e */
{
	spokeb(iy.W+(signed char)speekb(pc.W),de.B.l);
	pc.W++;
	t_add(19);
}

void ld_hl_e(void) /* ld (hl),e */
{
	spokeb(hl.W,de.B.l);
	t_add(7);
}

void ld_ix_h(void) /* ld (ix+DIS),h */
{
	spokeb(ix.W+(signed char)speekb(pc.W),hl.B.h);
	pc.W++;
	t_add(19);
}

void ld_iy_h(void) /* ld (iy+DIS),h */
{
	spokeb(iy.W+(signed char)speekb(pc.W),hl.B.h);
	pc.W++;
	t_add(19);
}

void ld_hl_h(void) /* ld (hl),h */
{
	spokeb(hl.W,hl.B.h);
	t_add(7);
}

void ld_ix_l(void) /* ld (ix+DIS),l */
{
	spokeb(ix.W+(signed char)speekb(pc.W),hl.B.l);
	pc.W++;
	t_add(19);
}

void ld_iy_l(void) /* ld (iy+DIS),l */
{
	spokeb(iy.W+(signed char)speekb(pc.W),hl.B.l);
	pc.W++;
	t_add(19);
}

void ld_hl_l(void) /* ld (hl),l */
{
	spokeb(hl.W,hl.B.l);
	t_add(7);
}

void Z80halt(void) /* halt */
{
	halt=1;
	t_add(4);
}

void ld_ix_a(void) /* ld (ix+DIS),a */
{
	spokeb(ix.W+(signed char)speekb(pc.W),af.B.h);
	pc.W++;
	t_add(19);
}

void ld_iy_a(void) /* ld (iy+DIS),a */
{
	spokeb(iy.W+(signed char)speekb(pc.W),af.B.h);
	pc.W++;
	t_add(19);
}

void ld_hl_a(void) /* ld (hl),a */
{
	spokeb(hl.W,af.B.h);
	t_add(7);
}

void ld_a_b(void) /* ld a,b */
{
	af.B.h=bc.B.h;
	t_add(4);
}

void ld_a_c(void) /* ld a,c */
{
	af.B.h=bc.B.l;
	t_add(4);
}

void ld_a_d(void) /* ld a,d */
{
	af.B.h=de.B.h;
	t_add(4);
}

void ld_a_e(void) /* ld a,e */
{
	af.B.h=de.B.l;
	t_add(4);
}

void ld_a_ixh(void) /* ld a,ixh */
{
	af.B.h=ix.B.h;
	t_add(8);
}

void ld_a_iyh(void) /* ld a,iyh */
{
	af.B.h=iy.B.h;
	t_add(8);
}

void ld_a_h(void) /* ld a,h */
{
	af.B.h=hl.B.h;
	t_add(4);
}

void ld_a_ixl(void) /* ld a,ixl */
{
	af.B.h=ix.B.l;
	t_add(8);
}

void ld_a_iyl(void) /* ld a,iyl */
{
	af.B.h=iy.B.l;
	t_add(8);
}

void ld_a_l(void) /* ld a,l */
{
	af.B.h=hl.B.l;
	t_add(4);
}

void ld_a_ix(void) /* ld a,(ix+DIS) */
{
	af.B.h=speekb(ix.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_a_iy(void) /* ld a,(iy+DIS) */
{
	af.B.h=speekb(iy.W+(signed char)speekb(pc.W));
	pc.W++;
	t_add(19);
}

void ld_a_hl(void) /* ld a,(hl) */
{
	af.B.h=speekb(hl.W);
	t_add(7);
}

void ld_a_a(void) /* ld a,a */
{
	af.B.h=af.B.h;
	t_add(4);
}

void add_a_b(void) /* add a,b */
{
	add8(af.B.h,bc.B.h);
	t_add(4);
}

void add_a_c(void) /* add a,c */
{
	add8(af.B.h,bc.B.l);
	t_add(4);
}

void add_a_d(void) /* add a,d */
{
	add8(af.B.h,de.B.h);
	t_add(4);
}

void add_a_e(void) /* add a,e */
{
	add8(af.B.h,de.B.l);
	t_add(4);
}

void add_a_ixh(void) /* add a,ixh */
{
	add8(af.B.h,ix.B.h);
	t_add(8);
}

void add_a_iyh(void) /* add a,iyh */
{
	add8(af.B.h,iy.B.h);
	t_add(8);
}

void add_a_h(void) /* add a,h */
{
	add8(af.B.h,hl.B.h);
	t_add(4);
}

void add_a_ixl(void) /* add a,ixl */
{
	add8(af.B.h,ix.B.l);
	t_add(8);
}

void add_a_iyl(void) /* add a,iyl */
{
	add8(af.B.h,iy.B.l);
	t_add(8);
}

void add_a_l(void) /* add a,l */
{
	add8(af.B.h,hl.B.l);
	t_add(4);
}

void add_a_ix(void) /* add a,(ix+DIS) */
{
	add8(af.B.h,speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void add_a_iy(void) /* add a,(iy+DIS) */
{
	add8(af.B.h,speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void add_a_hl(void) /* add a,(hl) */
{
	add8(af.B.h,speekb(hl.W));
	t_add(7);
}

void add_a_a(void) /* add a,a */
{
	add8(af.B.h,af.B.h);
	t_add(4);
}

void adc_a_b(void) /* adc a,b */
{
	adc8(af.B.h,bc.B.h);
	t_add(4);
}

void adc_a_c(void) /* adc a,c */
{
	adc8(af.B.h,bc.B.l);
	t_add(4);
}

void adc_a_d(void) /* adc a,d */
{
	adc8(af.B.h,de.B.h);
	t_add(4);
}

void adc_a_e(void) /* adc a,e */
{
	adc8(af.B.h,de.B.l);
	t_add(4);
}

void adc_a_ixh(void) /* adc a,ixh */
{
	adc8(af.B.h,ix.B.h);
	t_add(8);
}

void adc_a_iyh(void) /* adc a,iyh */
{
	adc8(af.B.h,iy.B.h);
	t_add(8);
}

void adc_a_h(void) /* adc a,h */
{
	adc8(af.B.h,hl.B.h);
	t_add(4);
}

void adc_a_ixl(void) /* adc a,ixl */
{
	adc8(af.B.h,ix.B.l);
	t_add(8);
}

void adc_a_iyl(void) /* adc a,iyl */
{
	adc8(af.B.h,iy.B.l);
	t_add(8);
}

void adc_a_l(void) /* adc a,l */
{
	adc8(af.B.h,hl.B.l);
	t_add(4);
}

void adc_a_ix(void) /* adc a,(ix+DIS) */
{
	adc8(af.B.h,speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void adc_a_iy(void) /* adc a,(iy+DIS) */
{
	adc8(af.B.h,speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void adc_a_hl(void) /* adc a,(hl) */
{
	adc8(af.B.h,speekb(hl.W));
	t_add(7);
}

void adc_a_a(void) /* adc a,a */
{
	adc8(af.B.h,af.B.h);
	t_add(4);
}

void sub_b(void) /* sub b */
{
	sub8(af.B.h,bc.B.h);
	t_add(4);
}

void sub_c(void) /* sub c */
{
	sub8(af.B.h,bc.B.l);
	t_add(4);
}

void sub_d(void) /* sub d */
{
	sub8(af.B.h,de.B.h);
	t_add(4);
}

void sub_e(void) /* sub e */
{
	sub8(af.B.h,de.B.l);
	t_add(4);
}

void sub_ixh(void) /* sub ixh */
{
	sub8(af.B.h,ix.B.h);
	t_add(8);
}

void sub_iyh(void) /* sub iyh */
{
	sub8(af.B.h,iy.B.h);
	t_add(8);
}

void sub_h(void) /* sub h */
{
	sub8(af.B.h,hl.B.h);
	t_add(4);
}

void sub_ixl(void) /* sub ixl */
{
	sub8(af.B.h,ix.B.l);
	t_add(8);
}

void sub_iyl(void) /* sub iyl */
{
	sub8(af.B.h,iy.B.l);
	t_add(8);
}

void sub_l(void) /* sub l */
{
	sub8(af.B.h,hl.B.l);
	t_add(4);
}

void sub_ix(void) /* sub (ix+DIS) */
{
	sub8(af.B.h,speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void sub_iy(void) /* sub (iy+DIS) */
{
	sub8(af.B.h,speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void sub_hl(void) /* sub (hl) */
{
	sub8(af.B.h,speekb(hl.W));
	t_add(7);
}

void sub_a(void) /* sub a */
{
	sub8(af.B.h,af.B.h);
	t_add(4);
}

void sbc_a_b(void) /* sbc a,b */
{
	sbc8(af.B.h,bc.B.h);
	t_add(4);
}

void sbc_a_c(void) /* sbc a,c */
{
	sbc8(af.B.h,bc.B.l);
	t_add(4);
}

void sbc_a_d(void) /* sbc a,d */
{
	sbc8(af.B.h,de.B.h);
	t_add(4);
}

void sbc_a_e(void) /* sbc a,e */
{
	sbc8(af.B.h,de.B.l);
	t_add(4);
}

void sbc_a_ixh(void) /* sbc a,ixh */
{
	sbc8(af.B.h,ix.B.h);
	t_add(8);
}

void sbc_a_iyh(void) /* sbc a,iyh */
{
	sbc8(af.B.h,iy.B.h);
	t_add(8);
}

void sbc_a_h(void) /* sbc a,h */
{
	sbc8(af.B.h,hl.B.h);
	t_add(4);
}

void sbc_a_ixl(void) /* sbc a,ixl */
{
	sbc8(af.B.h,ix.B.l);
	t_add(8);
}

void sbc_a_iyl(void) /* sbc a,iyl */
{
	sbc8(af.B.h,iy.B.l);
	t_add(8);
}

void sbc_a_l(void) /* sbc a,l */
{
	sbc8(af.B.h,hl.B.l);
	t_add(4);
}

void sbc_a_ix(void) /* sbc a,(ix+DIS) */
{
	sbc8(af.B.h,speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void sbc_a_iy(void) /* sbc a,(iy+DIS) */
{
	sbc8(af.B.h,speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void sbc_a_hl(void) /* sbc a,(hl) */
{
	sbc8(af.B.h,speekb(hl.W));
	t_add(7);
}

void sbc_a_a(void) /* sbc a,a */
{
	sbc8(af.B.h,af.B.h);
	t_add(4);
}

void and_b(void) /* and b */
{
	anda(bc.B.h);
	t_add(4);
}

void and_c(void) /* and c */
{
	anda(bc.B.l);
	t_add(4);
}

void and_d(void) /* and d */
{
	anda(de.B.h);
	t_add(4);
}

void and_e(void) /* and e */
{
	anda(de.B.l);
	t_add(4);
}

void and_ixh(void) /* and ixh */
{
	anda(ix.B.h);
	t_add(8);
}

void and_iyh(void) /* and iyh */
{
	anda(iy.B.h);
	t_add(8);
}

void and_h(void) /* and h */
{
	anda(hl.B.h);
	t_add(4);
}

void and_ixl(void) /* and ixl */
{
	anda(ix.B.l);
	t_add(8);
}

void and_iyl(void) /* and iyl */
{
	anda(iy.B.l);
	t_add(8);
}

void and_l(void) /* and l */
{
	anda(hl.B.l);
	t_add(4);
}

void and_ix(void) /* and (ix+DIS) */
{
	anda(speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void and_iy(void) /* and (iy+DIS) */
{
	anda(speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void and_hl(void) /* and (hl) */
{
	anda(speekb(hl.W));
	t_add(7);
}

void and_a(void) /* and a */
{
	anda(af.B.h);
	t_add(4);
}

void xor_b(void) /* xor b */
{
	xora(bc.B.h);
	t_add(4);
}

void xor_c(void) /* xor c */
{
	xora(bc.B.l);
	t_add(4);
}

void xor_d(void) /* xor d */
{
	xora(de.B.h);
	t_add(4);
}

void xor_e(void) /* xor e */
{
	xora(de.B.l);
	t_add(4);
}

void xor_ixh(void) /* xor ixh */
{
	xora(ix.B.h);
	t_add(8);
}

void xor_iyh(void) /* xor iyh */
{
	xora(iy.B.h);
	t_add(8);
}

void xor_h(void) /* xor h */
{
	xora(hl.B.h);
	t_add(4);
}

void xor_ixl(void) /* xor ixl */
{
	xora(ix.B.l);
	t_add(8);
}

void xor_iyl(void) /* xor iyl */
{
	xora(iy.B.l);
	t_add(8);
}

void xor_l(void) /* xor l */
{
	xora(hl.B.l);
	t_add(4);
}

void xor_ix(void) /* xor (ix+DIS) */
{
	xora(speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void xor_iy(void) /* xor (iy+DIS) */
{
	xora(speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void xor_hl(void) /* xor (hl) */
{
	xora(speekb(hl.W));
	t_add(7);
}

void xor_a(void) /* xor a */
{
	xora(af.B.h);
	t_add(4);
}

void or_b(void) /* or b */
{
	ora(bc.B.h);
	t_add(4);
}

void or_c(void) /* or c */
{
	ora(bc.B.l);
	t_add(4);
}

void or_d(void) /* or d */
{
	ora(de.B.h);
	t_add(4);
}

void or_e(void) /* or e */
{
	ora(de.B.l);
	t_add(4);
}

void or_ixh(void) /* or ixh */
{
	ora(ix.B.h);
	t_add(8);
}

void or_iyh(void) /* or iyh */
{
	ora(iy.B.h);
	t_add(8);
}

void or_h(void) /* or h */
{
	ora(hl.B.h);
	t_add(4);
}

void or_ixl(void) /* or ixl */
{
	ora(ix.B.l);
	t_add(8);
}

void or_iyl(void) /* or iyl */
{
	ora(iy.B.l);
	t_add(8);
}

void or_l(void) /* or l */
{
	ora(hl.B.l);
	t_add(4);
}

void or_ix(void) /* or (ix+DIS) */
{
	ora(speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void or_iy(void) /* or (iy+DIS) */
{
	ora(speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void or_hl(void) /* or (hl) */
{
	ora(speekb(hl.W));
	t_add(7);
}

void or_a(void) /* or a */
{
	ora(af.B.h);
	t_add(4);
}

void cp_b(void) /* cp b */
{
	cp_sub8(af.B.h,bc.B.h);
	t_add(4);
}

void cp_c(void) /* cp c */
{
	cp_sub8(af.B.h,bc.B.l);
	t_add(4);
}

void cp_d(void) /* cp d */
{
	cp_sub8(af.B.h,de.B.h);
	t_add(4);
}

void cp_e(void) /* cp e */
{
	cp_sub8(af.B.h,de.B.l);
	t_add(4);
}

void cp_ixh(void) /* cp ixh */
{
	cp_sub8(af.B.h,ix.B.h);
	t_add(8);
}

void cp_iyh(void) /* cp iyh */
{
	cp_sub8(af.B.h,iy.B.h);
	t_add(8);
}

void cp_h(void) /* cp h */
{
	cp_sub8(af.B.h,hl.B.h);
	t_add(4);
}

void cp_ixl(void) /* cp ixl */
{
	cp_sub8(af.B.h,ix.B.l);
	t_add(8);
}

void cp_iyl(void) /* cp iyl */
{
	cp_sub8(af.B.h,iy.B.l);
	t_add(8);
}

void cp_l(void) /* cp l */
{
	cp_sub8(af.B.h,hl.B.l);
	t_add(4);
}

void cp_ix(void) /* cp (ix+DIS) */
{
	cp_sub8(af.B.h,speekb(ix.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void cp_iy(void) /* cp (iy+DIS) */
{
	cp_sub8(af.B.h,speekb(iy.W+(signed char)speekb(pc.W)));
	pc.W++;
	t_add(19);
}

void cp_hl(void) /* cp (hl) */
{
	cp_sub8(af.B.h,speekb(hl.W));
	t_add(7);
}

void cp_a(void) /* cp a */
{
	cp_sub8(af.B.h,af.B.h);
	t_add(4);
}

void ret_nz(void) /* ret nz */
{
	if(!(af.B.l&64))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void pop_bc(void) /* pop bc */
{
	pop(bc.W);
	t_add(10);
}

void jp_nz_XXXX(void) /* jp nz,XXXX */
{
	if(!(af.B.l&64))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void jp_XXXX(void) /* jp XXXX */
{
	pc.W=wordpeek(pc.W);
	t_add(10);
}

void call_nz_XXXX(void) /* call nz,XXXX */
{
	if(!(af.B.l&64))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void push_bc(void) /* push bc */
{
	push(bc.W);
	t_add(11);
}

void add_a_XX(void) /* add a,XX */
{
	add8(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_0(void) /* rst 0 */
{
	push(pc.W);
	pc.W=0;
	t_add(11);
}

void ret_z(void) /* ret z */
{
	if((af.B.l&64))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void ret(void) /* ret */
{
	pop(pc.W);
	t_add(10);
}

void jp_z_XXXX(void) /* jp z,XXXX */
{
	if((af.B.l&64))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void IX_CB_Pre(void);

void IY_CB_Pre(void);

void CB_Pre(void);

void call_z_XXXX(void) /* call z,XXXX */
{
	if((af.B.l&64))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void call_XXXX(void) /* call XXXX */
{
	push(pc.W+2);
	pc.W=wordpeek(pc.W);
	t_add(17);
}

void adc_a_XX(void) /* adc a,XX */
{
	adc8(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_8(void) /* rst 8 */
{
	push(pc.W);
	pc.W=8;
	t_add(11);
}

void ret_nc(void) /* ret nc */
{
	if(!(af.B.l&1))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void pop_de(void) /* pop de */
{
	pop(de.W);
	t_add(10);
}

void jp_nc_XXXX(void) /* jp nc,XXXX */
{
	if(!(af.B.l&1))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void out_XX_a(void) /* out(XX),a */
{
	out(af.B.h,speekb(pc.W),af.B.h);
	pc.W++;
	t_add(11);
}

void call_nc_XXXX(void) /* call nc,XXXX */
{
	if(!(af.B.l&1))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void push_de(void) /* push de */
{
	push(de.W);
	t_add(11);
}

void sub_XX(void) /* sub XX */
{
	sub8(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_16(void) /* rst 16 */
{
	push(pc.W);
	pc.W=16;
	t_add(11);
}

void ret_c(void) /* ret c */
{
	if((af.B.l&1))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void exx(void) /* exx */
{
	register word temp;

	temp=bc.W;
	bc.W=bc2.W;
	bc2.W=temp;
	temp=de.W;
	de.W=de2.W;
	de2.W=temp;
	temp=hl.W;
	hl.W=hl2.W;
	hl2.W=temp;
	t_add(4);
}

void jp_c_XXXX(void) /* jp c,XXXX */
{
	if((af.B.l&1))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void in_a_XX(void) /* in a,(XX) */
{
	af.B.h=in(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(11);
}

void call_c_XXXX(void) /* call c,XXXX */
{
	if((af.B.l&1))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void IX_Pre(void);

void sbc_a_XX(void) /* sbc a,XX */
{
	sbc8(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_24(void) /* rst 24 */
{
	push(pc.W);
	pc.W=24;
	t_add(11);
}

void ret_po(void) /* ret po */
{
	if(!(af.B.l&4))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void pop_ix(void) /* pop ix */
{
	pop(ix.W);
	t_add(14);
}

void pop_iy(void) /* pop iy */
{
	pop(iy.W);
	t_add(14);
}

void pop_hl(void) /* pop hl */
{
	pop(hl.W);
	t_add(10);
}

void jp_po_XXXX(void) /* jp po,XXXX */
{
	if(!(af.B.l&4))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void ex_msp_ix(void) /* ex(sp),ix */
{
	register word temp;

	temp=wordpeek(sp.W);
	wordpoke(sp.W,ix.W);
	ix.W=temp;
	t_add(23);
}

void ex_msp_iy(void) /* ex(sp),iy */
{
	register word temp;

	temp=wordpeek(sp.W);
	wordpoke(sp.W,iy.W);
	iy.W=temp;
	t_add(23);
}

void ex_msp_hl(void) /* ex(sp),hl */
{
	register word temp;

	temp=wordpeek(sp.W);
	wordpoke(sp.W,hl.W);
	hl.W=temp;
	t_add(19);
}

void call_po_XXXX(void) /* call po,XXXX */
{
	if(!(af.B.l&4))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void push_ix(void) /* push ix */
{
	push(ix.W);
	t_add(15);
}

void push_iy(void) /* push iy */
{
	push(iy.W);
	t_add(15);
}

void push_hl(void) /* push hl */
{
	push(hl.W);
	t_add(11);
}

void and_XX(void) /* and XX */
{
	anda(speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_32(void) /* rst 32 */
{
	push(pc.W);
	pc.W=32;
	t_add(11);
}

void ret_pe(void) /* ret pe */
{
	if((af.B.l&4))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void jp_ix(void) /* jp ix */
{
	pc.W=ix.W;
	t_add(8);
}

void jp_iy(void) /* jp iy */
{
	pc.W=iy.W;
	t_add(8);
}

void jp_hl(void) /* jp hl */
{
	pc.W=hl.W;
	t_add(4);
}

void jp_pe_XXXX(void) /* jp pe,XXXX */
{
	if((af.B.l&4))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void ex_de_ix(void) /* ex de,ix */
{
	register word temp;

	temp=de.W;
	de.W=ix.W;
	ix.W=temp;
	t_add(8);
}

void ex_de_iy(void) /* ex de,iy */
{
	register word temp;

	temp=de.W;
	de.W=iy.W;
	iy.W=temp;
	t_add(8);
}

void ex_de_hl(void) /* ex de,hl */
{
	register word temp;

	temp=de.W;
	de.W=hl.W;
	hl.W=temp;
	t_add(4);
}

void call_pe_XXXX(void) /* call pe,XXXX */
{
	if((af.B.l&4))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void ED_Pre(void);

void xor_XX(void) /* xor XX */
{
	xora(speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_40(void) /* rst 40 */
{
	push(pc.W);
	pc.W=40;
	t_add(11);
}

void ret_p(void) /* ret p */
{
	if(!(af.B.l&128))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void pop_af(void) /* pop af */
{
	pop(af.W);
	t_add(10);
}

void jp_p_XXXX(void) /* jp p,XXXX */
{
	if(!(af.B.l&128))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void di(void) /* di */
{
	iff1=0;
	t_add(4);
}

void call_p_XXXX(void) /* call p,XXXX */
{
	if(!(af.B.l&128))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void push_af(void) /* push af */
{
	push(af.W);
	t_add(11);
}

void or_XX(void) /* or XX */
{
	ora(speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_48(void) /* rst 48 */
{
	push(pc.W);
	pc.W=48;
	t_add(11);
}

void ret_m(void) /* ret m */
{
	if((af.B.l&128))
	{
		pop(pc.W);
		t_add(11);
	}
	else
	{
		t_add(5);
	}
}

void ld_sp_ix(void) /* ld sp,ix */
{
	sp.W=ix.W;
	t_add(10);
}

void ld_sp_iy(void) /* ld sp,iy */
{
	sp.W=iy.W;
	t_add(10);
}

void ld_sp_hl(void) /* ld sp,hl */
{
	sp.W=hl.W;
	t_add(6);
}

void jp_m_XXXX(void) /* jp m,XXXX */
{
	if((af.B.l&128))
	{
		pc.W=wordpeek(pc.W);
		t_add(10);
	}
	else
	{
		pc.W+=2;
		t_add(10); /* EEK! */
	}
}

void ei(void) /* ei */
{
	iff1=1;
	t_add(4);
}

void call_m_XXXX(void) /* call m,XXXX */
{
	if((af.B.l&128))
	{
		push(pc.W+2);
		pc.W=wordpeek(pc.W);
		t_add(17);
	}
	else
	{
		pc.W+=2;
		t_add(10);
	}
}

void IY_Pre(void);

void cp_XX(void) /* cp XX */
{
	cp_sub8(af.B.h,speekb(pc.W));
	pc.W++;
	t_add(7);
}

void rst_56(void) /* rst 56 */
{
	push(pc.W);
	pc.W=56;
	t_add(11);
}
