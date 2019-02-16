/******************************************/
/**                                      **/
/**         X128_CB Portable File        **/
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

extern signed char CBdis;

void rlc_b(void);
void rlc_c(void);
void rlc_d(void);
void rlc_e(void);
void rlc_h(void);
void rlc_l(void);
void rlc_ix(void);
void rlc_iy(void);
void rlc_hl(void);
void rlc_a(void);
void rrc_b(void);
void rrc_c(void);
void rrc_d(void);
void rrc_e(void);
void rrc_h(void);
void rrc_l(void);
void rrc_ix(void);
void rrc_iy(void);
void rrc_hl(void);
void rrc_a(void);
void rl_b(void);
void rl_c(void);
void rl_d(void);
void rl_e(void);
void rl_h(void);
void rl_l(void);
void rl_ix(void);
void rl_iy(void);
void rl_hl(void);
void rl_a(void);
void rr_b(void);
void rr_c(void);
void rr_d(void);
void rr_e(void);
void rr_h(void);
void rr_l(void);
void rr_ix(void);
void rr_iy(void);
void rr_hl(void);
void rr_a(void);
void sla_b(void);
void sla_c(void);
void sla_d(void);
void sla_e(void);
void sla_h(void);
void sla_l(void);
void sla_ix(void);
void sla_iy(void);
void sla_hl(void);
void CBsla_a(void);
void sra_b(void);
void sra_c(void);
void sra_d(void);
void sra_e(void);
void sra_h(void);
void sra_l(void);
void sra_ix(void);
void sra_iy(void);
void sra_hl(void);
void CBsra_a(void);
void sll_b(void);
void sll_c(void);
void sll_d(void);
void sll_e(void);
void sll_h(void);
void sll_l(void);
void sll_ix(void);
void sll_iy(void);
void sll_hl(void);
void CBsll_a(void);
void srl_b(void);
void srl_c(void);
void srl_d(void);
void srl_e(void);
void srl_h(void);
void srl_l(void);
void srl_ix(void);
void srl_iy(void);
void srl_hl(void);
void CBsrl_a(void);
void bit0_b(void);
void bit0_c(void);
void bit0_d(void);
void bit0_e(void);
void bit0_h(void);
void bit0_l(void);
void bit0_ix(void);
void bit0_iy(void);
void bit0_hl(void);
void bit0_a(void);
void bit1_b(void);
void bit1_c(void);
void bit1_d(void);
void bit1_e(void);
void bit1_h(void);
void bit1_l(void);
void bit1_ix(void);
void bit1_iy(void);
void bit1_hl(void);
void bit1_a(void);
void bit2_b(void);
void bit2_c(void);
void bit2_d(void);
void bit2_e(void);
void bit2_h(void);
void bit2_l(void);
void bit2_ix(void);
void bit2_iy(void);
void bit2_hl(void);
void bit2_a(void);
void bit3_b(void);
void bit3_c(void);
void bit3_d(void);
void bit3_e(void);
void bit3_h(void);
void bit3_l(void);
void bit3_ix(void);
void bit3_iy(void);
void bit3_hl(void);
void bit3_a(void);
void bit4_b(void);
void bit4_c(void);
void bit4_d(void);
void bit4_e(void);
void bit4_h(void);
void bit4_l(void);
void bit4_ix(void);
void bit4_iy(void);
void bit4_hl(void);
void bit4_a(void);
void bit5_b(void);
void bit5_c(void);
void bit5_d(void);
void bit5_e(void);
void bit5_h(void);
void bit5_l(void);
void bit5_ix(void);
void bit5_iy(void);
void bit5_hl(void);
void bit5_a(void);
void bit6_b(void);
void bit6_c(void);
void bit6_d(void);
void bit6_e(void);
void bit6_h(void);
void bit6_l(void);
void bit6_ix(void);
void bit6_iy(void);
void bit6_hl(void);
void bit6_a(void);
void bit7_b(void);
void bit7_c(void);
void bit7_d(void);
void bit7_e(void);
void bit7_h(void);
void bit7_l(void);
void bit7_ix(void);
void bit7_iy(void);
void bit7_hl(void);
void bit7_a(void);
void res0_b(void);
void res0_c(void);
void res0_d(void);
void res0_e(void);
void res0_h(void);
void res0_l(void);
void res0_ix(void);
void res0_iy(void);
void res0_hl(void);
void res0_a(void);
void res1_b(void);
void res1_c(void);
void res1_d(void);
void res1_e(void);
void res1_h(void);
void res1_l(void);
void res1_ix(void);
void res1_iy(void);
void res1_hl(void);
void res1_a(void);
void res2_b(void);
void res2_c(void);
void res2_d(void);
void res2_e(void);
void res2_h(void);
void res2_l(void);
void res2_ix(void);
void res2_iy(void);
void res2_hl(void);
void res2_a(void);
void res3_b(void);
void res3_c(void);
void res3_d(void);
void res3_e(void);
void res3_h(void);
void res3_l(void);
void res3_ix(void);
void res3_iy(void);
void res3_hl(void);
void res3_a(void);
void res4_b(void);
void res4_c(void);
void res4_d(void);
void res4_e(void);
void res4_h(void);
void res4_l(void);
void res4_ix(void);
void res4_iy(void);
void res4_hl(void);
void res4_a(void);
void res5_b(void);
void res5_c(void);
void res5_d(void);
void res5_e(void);
void res5_h(void);
void res5_l(void);
void res5_ix(void);
void res5_iy(void);
void res5_hl(void);
void res5_a(void);
void res6_b(void);
void res6_c(void);
void res6_d(void);
void res6_e(void);
void res6_h(void);
void res6_l(void);
void res6_ix(void);
void res6_iy(void);
void res6_hl(void);
void res6_a(void);
void res7_b(void);
void res7_c(void);
void res7_d(void);
void res7_e(void);
void res7_h(void);
void res7_l(void);
void res7_ix(void);
void res7_iy(void);
void res7_hl(void);
void res7_a(void);
void set0_b(void);
void set0_c(void);
void set0_d(void);
void set0_e(void);
void set0_h(void);
void set0_l(void);
void set0_ix(void);
void set0_iy(void);
void set0_hl(void);
void set0_a(void);
void set1_b(void);
void set1_c(void);
void set1_d(void);
void set1_e(void);
void set1_h(void);
void set1_l(void);
void set1_ix(void);
void set1_iy(void);
void set1_hl(void);
void set1_a(void);
void set2_b(void);
void set2_c(void);
void set2_d(void);
void set2_e(void);
void set2_h(void);
void set2_l(void);
void set2_ix(void);
void set2_iy(void);
void set2_hl(void);
void set2_a(void);
void set3_b(void);
void set3_c(void);
void set3_d(void);
void set3_e(void);
void set3_h(void);
void set3_l(void);
void set3_ix(void);
void set3_iy(void);
void set3_hl(void);
void set3_a(void);
void set4_b(void);
void set4_c(void);
void set4_d(void);
void set4_e(void);
void set4_h(void);
void set4_l(void);
void set4_ix(void);
void set4_iy(void);
void set4_hl(void);
void set4_a(void);
void set5_b(void);
void set5_c(void);
void set5_d(void);
void set5_e(void);
void set5_h(void);
void set5_l(void);
void set5_ix(void);
void set5_iy(void);
void set5_hl(void);
void set5_a(void);
void set6_b(void);
void set6_c(void);
void set6_d(void);
void set6_e(void);
void set6_h(void);
void set6_l(void);
void set6_ix(void);
void set6_iy(void);
void set6_hl(void);
void set6_a(void);
void set7_b(void);
void set7_c(void);
void set7_d(void);
void set7_e(void);
void set7_h(void);
void set7_l(void);
void set7_ix(void);
void set7_iy(void);
void set7_hl(void);
void set7_a(void);

#ifndef CB_OBJ
struct
{
	void (*opcode)();
} CB[256]=
{
	rlc_b,
	rlc_c,
	rlc_d,
	rlc_e,
	rlc_h,
	rlc_l,
	rlc_hl,
	rlc_a,
	rrc_b,
	rrc_c,
	rrc_d,
	rrc_e,
	rrc_h,
	rrc_l,
	rrc_hl,
	rrc_a,
	rl_b,
	rl_c,
	rl_d,
	rl_e,
	rl_h,
	rl_l,
	rl_hl,
	rl_a,
	rr_b,
	rr_c,
	rr_d,
	rr_e,
	rr_h,
	rr_l,
	rr_hl,
	rr_a,
	sla_b,
	sla_c,
	sla_d,
	sla_e,
	sla_h,
	sla_l,
	sla_hl,
	CBsla_a,
	sra_b,
	sra_c,
	sra_d,
	sra_e,
	sra_h,
	sra_l,
	sra_hl,
	CBsra_a,
	sll_b,
	sll_c,
	sll_d,
	sll_e,
	sll_h,
	sll_l,
	sll_hl,
	CBsll_a,
	srl_b,
	srl_c,
	srl_d,
	srl_e,
	srl_h,
	srl_l,
	srl_hl,
	CBsrl_a,
	bit0_b,
	bit0_c,
	bit0_d,
	bit0_e,
	bit0_h,
	bit0_l,
	bit0_hl,
	bit0_a,
	bit1_b,
	bit1_c,
	bit1_d,
	bit1_e,
	bit1_h,
	bit1_l,
	bit1_hl,
	bit1_a,
	bit2_b,
	bit2_c,
	bit2_d,
	bit2_e,
	bit2_h,
	bit2_l,
	bit2_hl,
	bit2_a,
	bit3_b,
	bit3_c,
	bit3_d,
	bit3_e,
	bit3_h,
	bit3_l,
	bit3_hl,
	bit3_a,
	bit4_b,
	bit4_c,
	bit4_d,
	bit4_e,
	bit4_h,
	bit4_l,
	bit4_hl,
	bit4_a,
	bit5_b,
	bit5_c,
	bit5_d,
	bit5_e,
	bit5_h,
	bit5_l,
	bit5_hl,
	bit5_a,
	bit6_b,
	bit6_c,
	bit6_d,
	bit6_e,
	bit6_h,
	bit6_l,
	bit6_hl,
	bit6_a,
	bit7_b,
	bit7_c,
	bit7_d,
	bit7_e,
	bit7_h,
	bit7_l,
	bit7_hl,
	bit7_a,
	res0_b,
	res0_c,
	res0_d,
	res0_e,
	res0_h,
	res0_l,
	res0_hl,
	res0_a,
	res1_b,
	res1_c,
	res1_d,
	res1_e,
	res1_h,
	res1_l,
	res1_hl,
	res1_a,
	res2_b,
	res2_c,
	res2_d,
	res2_e,
	res2_h,
	res2_l,
	res2_hl,
	res2_a,
	res3_b,
	res3_c,
	res3_d,
	res3_e,
	res3_h,
	res3_l,
	res3_hl,
	res3_a,
	res4_b,
	res4_c,
	res4_d,
	res4_e,
	res4_h,
	res4_l,
	res4_hl,
	res4_a,
	res5_b,
	res5_c,
	res5_d,
	res5_e,
	res5_h,
	res5_l,
	res5_hl,
	res5_a,
	res6_b,
	res6_c,
	res6_d,
	res6_e,
	res6_h,
	res6_l,
	res6_hl,
	res6_a,
	res7_b,
	res7_c,
	res7_d,
	res7_e,
	res7_h,
	res7_l,
	res7_hl,
	res7_a,
	set0_b,
	set0_c,
	set0_d,
	set0_e,
	set0_h,
	set0_l,
	set0_hl,
	set0_a,
	set1_b,
	set1_c,
	set1_d,
	set1_e,
	set1_h,
	set1_l,
	set1_hl,
	set1_a,
	set2_b,
	set2_c,
	set2_d,
	set2_e,
	set2_h,
	set2_l,
	set2_hl,
	set2_a,
	set3_b,
	set3_c,
	set3_d,
	set3_e,
	set3_h,
	set3_l,
	set3_hl,
	set3_a,
	set4_b,
	set4_c,
	set4_d,
	set4_e,
	set4_h,
	set4_l,
	set4_hl,
	set4_a,
	set5_b,
	set5_c,
	set5_d,
	set5_e,
	set5_h,
	set5_l,
	set5_hl,
	set5_a,
	set6_b,
	set6_c,
	set6_d,
	set6_e,
	set6_h,
	set6_l,
	set6_hl,
	set6_a,
	set7_b,
	set7_c,
	set7_d,
	set7_e,
	set7_h,
	set7_l,
	set7_hl,
	set7_a
};

struct
{
	void (*opcode)();
} CB_IX[256]=
{
	rlc_b,
	rlc_c,
	rlc_d,
	rlc_e,
	rlc_h,
	rlc_l,
	rlc_ix,
	rlc_a,
	rrc_b,
	rrc_c,
	rrc_d,
	rrc_e,
	rrc_h,
	rrc_l,
	rrc_ix,
	rrc_a,
	rl_b,
	rl_c,
	rl_d,
	rl_e,
	rl_h,
	rl_l,
	rl_ix,
	rl_a,
	rr_b,
	rr_c,
	rr_d,
	rr_e,
	rr_h,
	rr_l,
	rr_ix,
	rr_a,
	sla_b,
	sla_c,
	sla_d,
	sla_e,
	sla_h,
	sla_l,
	sla_ix,
	CBsla_a,
	sra_b,
	sra_c,
	sra_d,
	sra_e,
	sra_h,
	sra_l,
	sra_ix,
	CBsra_a,
	sll_b,
	sll_c,
	sll_d,
	sll_e,
	sll_h,
	sll_l,
	sll_ix,
	CBsll_a,
	srl_b,
	srl_c,
	srl_d,
	srl_e,
	srl_h,
	srl_l,
	srl_ix,
	CBsrl_a,
	bit0_b,
	bit0_c,
	bit0_d,
	bit0_e,
	bit0_h,
	bit0_l,
	bit0_ix,
	bit0_a,
	bit1_b,
	bit1_c,
	bit1_d,
	bit1_e,
	bit1_h,
	bit1_l,
	bit1_ix,
	bit1_a,
	bit2_b,
	bit2_c,
	bit2_d,
	bit2_e,
	bit2_h,
	bit2_l,
	bit2_ix,
	bit2_a,
	bit3_b,
	bit3_c,
	bit3_d,
	bit3_e,
	bit3_h,
	bit3_l,
	bit3_ix,
	bit3_a,
	bit4_b,
	bit4_c,
	bit4_d,
	bit4_e,
	bit4_h,
	bit4_l,
	bit4_ix,
	bit4_a,
	bit5_b,
	bit5_c,
	bit5_d,
	bit5_e,
	bit5_h,
	bit5_l,
	bit5_ix,
	bit5_a,
	bit6_b,
	bit6_c,
	bit6_d,
	bit6_e,
	bit6_h,
	bit6_l,
	bit6_ix,
	bit6_a,
	bit7_b,
	bit7_c,
	bit7_d,
	bit7_e,
	bit7_h,
	bit7_l,
	bit7_ix,
	bit7_a,
	res0_b,
	res0_c,
	res0_d,
	res0_e,
	res0_h,
	res0_l,
	res0_ix,
	res0_a,
	res1_b,
	res1_c,
	res1_d,
	res1_e,
	res1_h,
	res1_l,
	res1_ix,
	res1_a,
	res2_b,
	res2_c,
	res2_d,
	res2_e,
	res2_h,
	res2_l,
	res2_ix,
	res2_a,
	res3_b,
	res3_c,
	res3_d,
	res3_e,
	res3_h,
	res3_l,
	res3_ix,
	res3_a,
	res4_b,
	res4_c,
	res4_d,
	res4_e,
	res4_h,
	res4_l,
	res4_ix,
	res4_a,
	res5_b,
	res5_c,
	res5_d,
	res5_e,
	res5_h,
	res5_l,
	res5_ix,
	res5_a,
	res6_b,
	res6_c,
	res6_d,
	res6_e,
	res6_h,
	res6_l,
	res6_ix,
	res6_a,
	res7_b,
	res7_c,
	res7_d,
	res7_e,
	res7_h,
	res7_l,
	res7_ix,
	res7_a,
	set0_b,
	set0_c,
	set0_d,
	set0_e,
	set0_h,
	set0_l,
	set0_ix,
	set0_a,
	set1_b,
	set1_c,
	set1_d,
	set1_e,
	set1_h,
	set1_l,
	set1_ix,
	set1_a,
	set2_b,
	set2_c,
	set2_d,
	set2_e,
	set2_h,
	set2_l,
	set2_ix,
	set2_a,
	set3_b,
	set3_c,
	set3_d,
	set3_e,
	set3_h,
	set3_l,
	set3_ix,
	set3_a,
	set4_b,
	set4_c,
	set4_d,
	set4_e,
	set4_h,
	set4_l,
	set4_ix,
	set4_a,
	set5_b,
	set5_c,
	set5_d,
	set5_e,
	set5_h,
	set5_l,
	set5_ix,
	set5_a,
	set6_b,
	set6_c,
	set6_d,
	set6_e,
	set6_h,
	set6_l,
	set6_ix,
	set6_a,
	set7_b,
	set7_c,
	set7_d,
	set7_e,
	set7_h,
	set7_l,
	set7_ix,
	set7_a
};

struct
{
	void (*opcode)();
} CB_IY[256]=
{
	rlc_b,
	rlc_c,
	rlc_d,
	rlc_e,
	rlc_h,
	rlc_l,
	rlc_iy,
	rlc_a,
	rrc_b,
	rrc_c,
	rrc_d,
	rrc_e,
	rrc_h,
	rrc_l,
	rrc_iy,
	rrc_a,
	rl_b,
	rl_c,
	rl_d,
	rl_e,
	rl_h,
	rl_l,
	rl_iy,
	rl_a,
	rr_b,
	rr_c,
	rr_d,
	rr_e,
	rr_h,
	rr_l,
	rr_iy,
	rr_a,
	sla_b,
	sla_c,
	sla_d,
	sla_e,
	sla_h,
	sla_l,
	sla_iy,
	CBsla_a,
	sra_b,
	sra_c,
	sra_d,
	sra_e,
	sra_h,
	sra_l,
	sra_iy,
	CBsra_a,
	sll_b,
	sll_c,
	sll_d,
	sll_e,
	sll_h,
	sll_l,
	sll_iy,
	CBsll_a,
	srl_b,
	srl_c,
	srl_d,
	srl_e,
	srl_h,
	srl_l,
	srl_iy,
	CBsrl_a,
	bit0_b,
	bit0_c,
	bit0_d,
	bit0_e,
	bit0_h,
	bit0_l,
	bit0_iy,
	bit0_a,
	bit1_b,
	bit1_c,
	bit1_d,
	bit1_e,
	bit1_h,
	bit1_l,
	bit1_iy,
	bit1_a,
	bit2_b,
	bit2_c,
	bit2_d,
	bit2_e,
	bit2_h,
	bit2_l,
	bit2_iy,
	bit2_a,
	bit3_b,
	bit3_c,
	bit3_d,
	bit3_e,
	bit3_h,
	bit3_l,
	bit3_iy,
	bit3_a,
	bit4_b,
	bit4_c,
	bit4_d,
	bit4_e,
	bit4_h,
	bit4_l,
	bit4_iy,
	bit4_a,
	bit5_b,
	bit5_c,
	bit5_d,
	bit5_e,
	bit5_h,
	bit5_l,
	bit5_iy,
	bit5_a,
	bit6_b,
	bit6_c,
	bit6_d,
	bit6_e,
	bit6_h,
	bit6_l,
	bit6_iy,
	bit6_a,
	bit7_b,
	bit7_c,
	bit7_d,
	bit7_e,
	bit7_h,
	bit7_l,
	bit7_iy,
	bit7_a,
	res0_b,
	res0_c,
	res0_d,
	res0_e,
	res0_h,
	res0_l,
	res0_iy,
	res0_a,
	res1_b,
	res1_c,
	res1_d,
	res1_e,
	res1_h,
	res1_l,
	res1_iy,
	res1_a,
	res2_b,
	res2_c,
	res2_d,
	res2_e,
	res2_h,
	res2_l,
	res2_iy,
	res2_a,
	res3_b,
	res3_c,
	res3_d,
	res3_e,
	res3_h,
	res3_l,
	res3_iy,
	res3_a,
	res4_b,
	res4_c,
	res4_d,
	res4_e,
	res4_h,
	res4_l,
	res4_iy,
	res4_a,
	res5_b,
	res5_c,
	res5_d,
	res5_e,
	res5_h,
	res5_l,
	res5_iy,
	res5_a,
	res6_b,
	res6_c,
	res6_d,
	res6_e,
	res6_h,
	res6_l,
	res6_iy,
	res6_a,
	res7_b,
	res7_c,
	res7_d,
	res7_e,
	res7_h,
	res7_l,
	res7_iy,
	res7_a,
	set0_b,
	set0_c,
	set0_d,
	set0_e,
	set0_h,
	set0_l,
	set0_iy,
	set0_a,
	set1_b,
	set1_c,
	set1_d,
	set1_e,
	set1_h,
	set1_l,
	set1_iy,
	set1_a,
	set2_b,
	set2_c,
	set2_d,
	set2_e,
	set2_h,
	set2_l,
	set2_iy,
	set2_a,
	set3_b,
	set3_c,
	set3_d,
	set3_e,
	set3_h,
	set3_l,
	set3_iy,
	set3_a,
	set4_b,
	set4_c,
	set4_d,
	set4_e,
	set4_h,
	set4_l,
	set4_iy,
	set4_a,
	set5_b,
	set5_c,
	set5_d,
	set5_e,
	set5_h,
	set5_l,
	set5_iy,
	set5_a,
	set6_b,
	set6_c,
	set6_d,
	set6_e,
	set6_h,
	set6_l,
	set6_iy,
	set6_a,
	set7_b,
	set7_c,
	set7_d,
	set7_e,
	set7_h,
	set7_l,
	set7_iy,
	set7_a
};
#endif
