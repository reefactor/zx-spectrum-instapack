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

void in_b_c(void); /* in b,(c) ALL in reg,(c) UNTESTED FLAGS */
void out_c_b(void); /* out(c),b */
void sbc_hl_bc(void); /* sbc hl,bc */
void ld_aXXXX_bc(void); /* ld(XXXX),bc */
void neg(void); /* neg */
void retn(void); /* retn */
void im_0(void); /* im 0 */
void ld_i_a(void); /* ld i,a */
void in_c_c(void); /* in c,(c) */
void out_c_c(void); /* out(c),c */
void adc_hl_bc(void); /* adc hl,bc */
void ld_bc_aXXXX(void); /* ld bc,(XXXX) */
void reti(void); /* reti */
void ld_r_a(void); /* ld r,a */
void in_d_c(void); /* in d,(c) */
void out_c_d(void); /* out(c),d */
void sbc_hl_de(void); /* sbc hl,de */
void ld_aXXXX_de(void); /* ld(XXXX),de */
void im_1(void); /* im 1 */
void ld_a_i(void); /* ld a,i UNTESTED */
void in_e_c(void); /* in e,(c) */
void out_c_e(void); /* out(c),e */
void adc_hl_de(void); /* adc hl,de */
void ld_de_aXXXX(void); /* ld de,(XXXX) */
void im_2(void); /* im 2 */
void ld_a_r(void); /* ld a,r extra flags untested */
void in_h_c(void); /* in h,(c) */
void out_c_h(void); /* out(c),h */
void sbc_hl_hl(void); /* sbc hl,hl */
void ld_aXXXX_hl(void); /* ld(XXXX),hl */
void rrd(void); /* rrd INCOMPLETE */
void in_l_c(void); /* in l,(c) */
void out_c_l(void); /* out(c),l */
void adc_hl_hl(void); /* adc hl,hl */
void ld_hl_aXXXX(void); /* ld hl,(XXXX) */
void rld(void); /* rld INCOMPLETE */
void in_f_c(void); /* in f,(c) */
void out_c_0(void); /* out(c),0 */
void sbc_hl_sp(void); /* sbc hl,sp */
void ld_aXXXX_sp(void); /* ld(XXXX),sp */
void in_a_c(void); /* in a,(c) */
void out_c_a(void); /* out(c),a */
void adc_hl_sp(void); /* adc hl,sp */
void ld_sp_aXXXX(void); /* ld sp,(XXXX) */
void ldi(void); /* ldi */
void cpi(void); /* cpi UNTESTED */
void ini(void); /* ini UNTESTED */
void outi(void); /* outi UNTESTED */
void ldd(void); /* ldd */
void cpd(void); /* cpd UNTESTED */
void ind(void); /* ind UNTESTED */
void outd(void); /* outd UNTESTED */
void ldir(void); /*ldir */
void cpir(void); /* cpir UNTESTED */
void inir(void); /* inir UNTESTED */
void otir(void); /* otir UNTESTED */
void lddr(void); /* lddr */
void cpdr(void); /* cpdr UNTESTED */
void indr(void); /* indr UNTESTED */
void otdr(void); /* otdr UNTESTED */
void Ill_ED(void);
void load_trap(void);

#ifndef ED_OBJ
struct
{
	void (*opcode)();
} ED[256]=
{
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	in_b_c, /* 64 */
	out_c_b,
	sbc_hl_bc,
	ld_aXXXX_bc,
	neg,
	retn,
	im_0,
	ld_i_a,
	in_c_c,
	out_c_c,
	adc_hl_bc,
	ld_bc_aXXXX,
	neg,
	reti,
	im_0,
	ld_r_a,
	in_d_c, /* 80 */
	out_c_d,
	sbc_hl_de,
	ld_aXXXX_de,
	neg,
	retn,
	im_1,
	ld_a_i,
	in_e_c,
	out_c_e,
	adc_hl_de,
	ld_de_aXXXX,
	neg,
	reti,
	im_2,
	ld_a_r,
	in_h_c, /* 96 */
	out_c_h,
	sbc_hl_hl,
	ld_aXXXX_hl,
	neg,
	retn,
	im_0,
	rrd,
	in_l_c,
	out_c_l,
	adc_hl_hl,
	ld_hl_aXXXX,
	neg,
	reti,
	im_0,
	rld,
	in_f_c, /* 112 */
	out_c_0,
	sbc_hl_sp,
	ld_aXXXX_sp,
	neg,
	retn,
	im_1,
	Ill_ED,
	in_a_c,
	out_c_a,
	adc_hl_sp,
	ld_sp_aXXXX,
	neg,
	reti,
	im_2,
	Ill_ED, /* 127 */
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	ldi, /* 160 */
	cpi,
	ini,
	outi,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	ldd,
	cpd,
	ind,
	outd,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	ldir, /* 176 */
	cpir,
	inir,
	otir,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	Ill_ED,
	lddr,
	cpdr,
	indr,
	otdr,  /* 187 */
	Ill_ED,
	Ill_ED,
	Ill_ED,
	Ill_ED, /* 191 */
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,Ill_ED,
	Ill_ED,Ill_ED,Ill_ED,open_DAT,Ill_ED,Ill_ED,Ill_ED,
	load_trap /* 255 */
};
#endif
