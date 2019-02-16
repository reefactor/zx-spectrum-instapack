/******************************************/
/**                                      **/
/**       X128_END Configuration File    **/
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
#define OVERSCAN
#define OLD_48K
#define OLD_NOISE
#define LSB_FIRST
#define MSDOS_SYSTEM
#define NON_WINDOWS

#define UC unsigned char

#ifdef __BORLANDC__
#define word unsigned int
#define sign16 signed int
#else
#define word unsigned short
#define sign16 signed short
#endif

#ifdef LINUX

#include<unistd.h>
#include<asm/io.h>

#define outp(val1,val2) outb(val2,val1)
#define inp(val) inb(val)

#else

#ifndef MSDOS_SYSTEM

#ifdef AY8910_OBJ
void outp(word val1,UC val2) {};
UC inp(word val1) {};
#endif

#endif

#endif

#ifdef OVERSCAN
#define t_add(val) t_state+=val
#else
#define t_add(val)
#endif

#define SET_CF af.B.l|=1   /* set Cf */
#define RES_CF af.B.l&=254 /* reset Cf */

#define SET_NF af.B.l|=2   /* set Nf */
#define RES_NF af.B.l&=253 /* reset Nf */

#define SET_PF af.B.l|=4   /* set Pf */
#define RES_PF af.B.l&=251 /* reset Pf */

#define SET_3F af.B.l|=8   /* set bit 3 of F */
#define RES_3F af.B.l&=247 /* reset bit 3 of F */

#define SET_HF af.B.l|=16  /* set Hf */
#define RES_HF af.B.l&=239 /* reset Hf */

#define SET_5F af.B.l|=32  /* set bit 5 of F */
#define RES_5F af.B.l&=223 /* reset bit 5 of F */

#define SET_ZF af.B.l|=64  /* set Zf */
#define RES_ZF af.B.l&=191 /* reset Zf */

#define SET_SF af.B.l|=128 /* set Sf */
#define RES_SF af.B.l&=127 /* reset Sf */

typedef union
{
#ifdef LSB_FIRST
	struct {UC l,h;} B;
#else
	struct {UC h,l;} B;
#endif
	word W;
} pair;

typedef union
{
#ifdef LSB_FIRST
	struct {UC b1,b2,b3,b4;} B;
	struct {word w1,w2;} W;
#else
	struct {UC b4,b3,b2,b1;} B;
	struct {word w2,w1;} W;
#endif
	unsigned long Q;
} quadruple;

extern pair af,bc,de,hl,ir,ix,iy,pc,sp,af2,bc2,de2,hl2;
extern pair ptemp;
extern quadruple qtemp;
extern word mwtemp;

extern UC bit7_r, halt;
extern UC iff1, iff2, im, int_50;
extern UC parity[256];

extern char *error_str;
extern word t_state;

extern word vline;

extern UC rlca_f[256];
extern UC rlca_a[256];
extern UC rrca_f[256];
extern UC rrca_a[256];

/*UC rla_f[2][256];
UC rla_a[2][256];
UC rra_f[2][256];
UC rra_a[2][256];*/

extern UC rla_f0[256];
/*UC rla_f1[256];*/
extern UC rla_a0[256];
extern UC rla_a1[256];
extern UC rra_f0[256];
/*UC rra_f1[256];*/
extern UC rra_a0[256];
extern UC rra_a1[256];

extern UC daa_f[8][256];
extern UC daa_a[8][256];

extern UC inc_f[256];
/*UC inc_a[256];*/
extern UC dec_f[256];
/*UC dec_a[256];*/

/*UC rlcr_f[2][256];
UC rlcr_a[2][256];
UC rrcr_f[2][256];
UC rrcr_a[2][256];*/

extern UC rlcr_f[256];
extern UC rlcr_a[256];
extern UC rrcr_f[256];
extern UC rrcr_a[256];

/*UC rlr_f[2][256];
UC rlr_a[2][256];
UC rrr_f[2][256];
UC rrr_a[2][256];*/

extern UC rlr_f0[256];
extern UC rlr_f1[256];
extern UC rlr_a0[256];
extern UC rlr_a1[256];
extern UC rrr_f0[256];
extern UC rrr_f1[256];
extern UC rrr_a0[256];
extern UC rrr_a1[256];

/*UC sla_f[2][256];
UC sla_a[2][256];
UC sra_f[2][256];
UC sra_a[2][256];
UC sll_f[2][256];
UC sll_a[2][256];
UC srl_f[2][256];
UC srl_a[2][256];*/

extern UC sla_f[256];
extern UC sla_a[256];
extern UC sra_f[256];
extern UC sra_a[256];
extern UC sll_f[256];
extern UC sll_a[256];
extern UC srl_f[256];
extern UC srl_a[256];

extern UC bit_f0[256];
/*UC bit_a0[256];*/
extern UC bit_f1[256];
/*UC bit_a1[256];*/
extern UC bit_f2[256];
/*UC bit_a2[256];*/
extern UC bit_f3[256];
/*UC bit_a3[256];*/
extern UC bit_f4[256];
/*UC bit_a4[256];*/
extern UC bit_f5[256];
/*UC bit_a5[256];*/
extern UC bit_f6[256];
/*UC bit_a6[256];*/
extern UC bit_f7[256];
/*UC bit_a7[256];*/

extern UC ora_table[256];
extern UC xora_table[256];
extern UC anda_table[256];
extern UC in_table[256];
extern UC add8_table[256];
extern UC sub8_table[256];
extern UC cpsub8_table[256];

extern UC *SRAMR[8];
extern UC *SRAMW[8];
extern UC CONTENDED[8];
