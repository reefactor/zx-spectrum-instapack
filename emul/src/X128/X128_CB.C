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

#define CB_OBJ

#include "x128_end.c"
#include "x128_def.c"
#include "x128_cb.h"

signed char CBdis;

void rlc_b(void)
{
	af.B.l=rlcr_f[bc.B.h];
	bc.B.h=rlcr_a[bc.B.h];
	t_add(8);
}

void rlc_c(void)
{
	af.B.l=rlcr_f[bc.B.l];
	bc.B.l=rlcr_a[bc.B.l];
	t_add(8);
}

void rlc_d(void)
{
	af.B.l=rlcr_f[de.B.h];
	de.B.h=rlcr_a[de.B.h];
	t_add(8);
}

void rlc_e(void)
{
	af.B.l=rlcr_f[de.B.l];
	de.B.l=rlcr_a[de.B.l];
	t_add(8);
}

void rlc_h(void)
{
	af.B.l=rlcr_f[hl.B.h];
	hl.B.h=rlcr_a[hl.B.h];
	t_add(8);
}

void rlc_l(void)
{
	af.B.l=rlcr_f[hl.B.l];
	hl.B.l=rlcr_a[hl.B.l];
	t_add(8);
}

void rlc_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=rlcr_f[btemp];
	spokeb(ix.W+CBdis,rlcr_a[btemp]);
	t_add(23);
}

void rlc_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=rlcr_f[btemp];
	spokeb(iy.W+CBdis,rlcr_a[btemp]);
	t_add(23);
}

void rlc_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=rlcr_f[btemp];
	spokeb(hl.W,rlcr_a[btemp]);
	t_add(15);
}

void rlc_a(void)
{
	af.B.l=rlcr_f[af.B.h];
	af.B.h=rlcr_a[af.B.h];
	t_add(8);
}

void rrc_b(void)
{
	af.B.l=rrcr_f[bc.B.h];
	bc.B.h=rrcr_a[bc.B.h];
	t_add(8);
}

void rrc_c(void)
{
	af.B.l=rrcr_f[bc.B.l];
	bc.B.l=rrcr_a[bc.B.l];
	t_add(8);
}

void rrc_d(void)
{
	af.B.l=rrcr_f[de.B.h];
	de.B.h=rrcr_a[de.B.h];
	t_add(8);
}

void rrc_e(void)
{
	af.B.l=rrcr_f[de.B.l];
	de.B.l=rrcr_a[de.B.l];
	t_add(8);
}

void rrc_h(void)
{
	af.B.l=rrcr_f[hl.B.h];
	hl.B.h=rrcr_a[hl.B.h];
	t_add(8);
}

void rrc_l(void)
{
	af.B.l=rrcr_f[hl.B.l];
	hl.B.l=rrcr_a[hl.B.l];
	t_add(8);
}

void rrc_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=rrcr_f[btemp];
	spokeb(ix.W+CBdis,rrcr_a[btemp]);
	t_add(23);
}

void rrc_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=rrcr_f[btemp];
	spokeb(iy.W+CBdis,rrcr_a[btemp]);
	t_add(23);
}

void rrc_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=rrcr_f[btemp];
	spokeb(hl.W,rrcr_a[btemp]);
	t_add(15);
}

void rrc_a(void)
{
	af.B.l=rrcr_f[af.B.h];
	af.B.h=rrcr_a[af.B.h];
	t_add(8);
}

void rl_b(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[bc.B.h];
		bc.B.h=rlr_a0[bc.B.h];
	}
	else
	{
		af.B.l=rlr_f1[bc.B.h];
		bc.B.h=rlr_a1[bc.B.h];
	}
	t_add(8);
}

void rl_c(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[bc.B.l];
		bc.B.l=rlr_a0[bc.B.l];
	}
	else
	{
		af.B.l=rlr_f1[bc.B.l];
		bc.B.l=rlr_a1[bc.B.l];
	}
	t_add(8);
}

void rl_d(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[de.B.h];
		de.B.h=rlr_a0[de.B.h];
	}
	else
	{
		af.B.l=rlr_f1[de.B.h];
		de.B.h=rlr_a1[de.B.h];
	}
	t_add(8);
}

void rl_e(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[de.B.l];
		de.B.l=rlr_a0[de.B.l];
	}
	else
	{
		af.B.l=rlr_f1[de.B.l];
		de.B.l=rlr_a1[de.B.l];
	}
	t_add(8);
}

void rl_h(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[hl.B.h];
		hl.B.h=rlr_a0[hl.B.h];
	}
	else
	{
		af.B.l=rlr_f1[hl.B.h];
		hl.B.h=rlr_a1[hl.B.h];
	}
	t_add(8);
}

void rl_l(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[hl.B.l];
		hl.B.l=rlr_a0[hl.B.l];
	}
	else
	{
		af.B.l=rlr_f1[hl.B.l];
		hl.B.l=rlr_a1[hl.B.l];
	}
	t_add(8);
}

/*void rl_ix(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(ix.W+CBdis);
	af.B.l=rlr_f[btemp][btemp2];
	spokeb(ix.W+CBdis,rlr_a[btemp][btemp2]);
	t_add(23);
}*/

void rl_ix(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(ix.W+CBdis);
		af.B.l=rlr_f0[btemp];
		spokeb(ix.W+CBdis,rlr_a0[btemp]);
	}
	else
	{
		btemp=speekb(ix.W+CBdis);
		af.B.l=rlr_f1[btemp];
		spokeb(ix.W+CBdis,rlr_a1[btemp]);
	}
	t_add(23);
}

/*void rl_iy(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(iy.W+CBdis);
	af.B.l=rlr_f[btemp][btemp2];
	spokeb(iy.W+CBdis,rlr_a[btemp][btemp2]);
	t_add(23);
}*/

void rl_iy(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(iy.W+CBdis);
		af.B.l=rlr_f0[btemp];
		spokeb(iy.W+CBdis,rlr_a0[btemp]);
	}
	else
	{
		btemp=speekb(iy.W+CBdis);
		af.B.l=rlr_f1[btemp];
		spokeb(iy.W+CBdis,rlr_a1[btemp]);
	}
	t_add(23);
}

/*void rl_hl(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(hl.W);
	af.B.l=rlr_f[btemp][btemp2];
	spokeb(hl.W,rlr_a[btemp][btemp2]);
	t_add(15);
}*/

void rl_hl(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(hl.W);
		af.B.l=rlr_f0[btemp];
		spokeb(hl.W,rlr_a0[btemp]);
	}
	else
	{
		btemp=speekb(hl.W);
		af.B.l=rlr_f1[btemp];
		spokeb(hl.W,rlr_a1[btemp]);
	}
	t_add(15);
}

/*void rl_a(void)
{
	register UC btemp;

	btemp=af.B.l&1;
	af.B.l=rlr_f[btemp][af.B.h];
	af.B.h=rlr_a[btemp][af.B.h];
	t_add(8);
}*/

void rl_a(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rlr_f0[af.B.h];
		af.B.h=rlr_a0[af.B.h];
	}
	else
	{
		af.B.l=rlr_f1[af.B.h];
		af.B.h=rlr_a1[af.B.h];
	}
	t_add(8);
}

void rr_b(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[bc.B.h];
		bc.B.h=rrr_a0[bc.B.h];
	}
	else
	{
		af.B.l=rrr_f1[bc.B.h];
		bc.B.h=rrr_a1[bc.B.h];
	}
	t_add(8);
}

void rr_c(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[bc.B.l];
		bc.B.l=rrr_a0[bc.B.l];
	}
	else
	{
		af.B.l=rrr_f1[bc.B.l];
		bc.B.l=rrr_a1[bc.B.l];
	}
	t_add(8);
}

void rr_d(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[de.B.h];
		de.B.h=rrr_a0[de.B.h];
	}
	else
	{
		af.B.l=rrr_f1[de.B.h];
		de.B.h=rrr_a1[de.B.h];
	}
	t_add(8);
}

void rr_e(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[de.B.l];
		de.B.l=rrr_a0[de.B.l];
	}
	else
	{
		af.B.l=rrr_f1[de.B.l];
		de.B.l=rrr_a1[de.B.l];
	}
	t_add(8);
}

void rr_h(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[hl.B.h];
		hl.B.h=rrr_a0[hl.B.h];
	}
	else
	{
		af.B.l=rrr_f1[hl.B.h];
		hl.B.h=rrr_a1[hl.B.h];
	}
	t_add(8);
}

void rr_l(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[hl.B.l];
		hl.B.l=rrr_a0[hl.B.l];
	}
	else
	{
		af.B.l=rrr_f1[hl.B.l];
		hl.B.l=rrr_a1[hl.B.l];
	}
	t_add(8);
}

/*void rr_ix(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(ix.W+CBdis);
	af.B.l=rrr_f[btemp][btemp2];
	spokeb(ix.W+CBdis,rrr_a[btemp][btemp2]);
	t_add(23);
}*/

void rr_ix(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(ix.W+CBdis);
		af.B.l=rrr_f0[btemp];
		spokeb(ix.W+CBdis,rrr_a0[btemp]);
	}
	else
	{
		btemp=speekb(ix.W+CBdis);
		af.B.l=rrr_f1[btemp];
		spokeb(ix.W+CBdis,rrr_a1[btemp]);
	}
	t_add(23);
}

/*void rr_iy(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(iy.W+CBdis);
	af.B.l=rrr_f[btemp][btemp2];
	spokeb(iy.W+CBdis,rrr_a[btemp][btemp2]);
	t_add(23);
}*/

void rr_iy(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(iy.W+CBdis);
		af.B.l=rrr_f0[btemp];
		spokeb(iy.W+CBdis,rrr_a0[btemp]);
	}
	else
	{
		btemp=speekb(iy.W+CBdis);
		af.B.l=rrr_f1[btemp];
		spokeb(iy.W+CBdis,rrr_a1[btemp]);
	}
	t_add(23);
}

/*void rr_hl(void)
{
	register UC btemp, btemp2;

	btemp=af.B.l&1;
	btemp2=speekb(hl.W);
	af.B.l=rrr_f[btemp][btemp2];
	spokeb(hl.W,rrr_a[btemp][btemp2]);
	t_add(15);
}*/

void rr_hl(void)
{
	register UC btemp;

	if(!(af.B.l&1))
	{
		btemp=speekb(hl.W);
		af.B.l=rrr_f0[btemp];
		spokeb(hl.W,rrr_a0[btemp]);
	}
	else
	{
		btemp=speekb(hl.W);
		af.B.l=rrr_f1[btemp];
		spokeb(hl.W,rrr_a1[btemp]);
	}
	t_add(15);
}

/*void rr_a(void)
{
	register UC btemp;

	btemp=af.B.l&1;
	af.B.l=rrr_f[btemp][af.B.h];
	af.B.h=rrr_a[btemp][af.B.h];
	t_add(8);
}*/

void rr_a(void)
{
	if(!(af.B.l&1))
	{
		af.B.l=rrr_f0[af.B.h];
		af.B.h=rrr_a0[af.B.h];
	}
	else
	{
		af.B.l=rrr_f1[af.B.h];
		af.B.h=rrr_a1[af.B.h];
	}
	t_add(8);
}

void sla_b(void)
{
	af.B.l=sla_f[bc.B.h];
	bc.B.h=sla_a[bc.B.h];
	t_add(8);
}

void sla_c(void)
{
	af.B.l=sla_f[bc.B.l];
	bc.B.l=sla_a[bc.B.l];
	t_add(8);
}

void sla_d(void)
{
	af.B.l=sla_f[de.B.h];
	de.B.h=sla_a[de.B.h];
	t_add(8);
}

void sla_e(void)
{
	af.B.l=sla_f[de.B.l];
	de.B.l=sla_a[de.B.l];
	t_add(8);
}

void sla_h(void)
{
	af.B.l=sla_f[hl.B.h];
	hl.B.h=sla_a[hl.B.h];
	t_add(8);
}

void sla_l(void)
{
	af.B.l=sla_f[hl.B.l];
	hl.B.l=sla_a[hl.B.l];
	t_add(8);
}

void sla_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=sla_f[btemp];
	spokeb(ix.W+CBdis,sla_a[btemp]);
	t_add(23);
}

void sla_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=sla_f[btemp];
	spokeb(iy.W+CBdis,sla_a[btemp]);
	t_add(23);
}

void sla_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=sla_f[btemp];
	spokeb(hl.W,sla_a[btemp]);
	t_add(15);
}

void CBsla_a(void)
{
	af.B.l=sla_f[af.B.h];
	af.B.h=sla_a[af.B.h];
	t_add(8);
}

void sra_b(void)
{
	af.B.l=sra_f[bc.B.h];
	bc.B.h=sra_a[bc.B.h];
	t_add(8);
}

void sra_c(void)
{
	af.B.l=sra_f[bc.B.l];
	bc.B.l=sra_a[bc.B.l];
	t_add(8);
}

void sra_d(void)
{
	af.B.l=sra_f[de.B.h];
	de.B.h=sra_a[de.B.h];
	t_add(8);
}

void sra_e(void)
{
	af.B.l=sra_f[de.B.l];
	de.B.l=sra_a[de.B.l];
	t_add(8);
}

void sra_h(void)
{
	af.B.l=sra_f[hl.B.h];
	hl.B.h=sra_a[hl.B.h];
	t_add(8);
}

void sra_l(void)
{
	af.B.l=sra_f[hl.B.l];
	hl.B.l=sra_a[hl.B.l];
	t_add(8);
}

void sra_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=sra_f[btemp];
	spokeb(ix.W+CBdis,sra_a[btemp]);
	t_add(23);
}

void sra_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=sra_f[btemp];
	spokeb(iy.W+CBdis,sra_a[btemp]);
	t_add(23);
}

void sra_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=sra_f[btemp];
	spokeb(hl.W,sra_a[btemp]);
	t_add(15);
}

void CBsra_a(void)
{
	af.B.l=sra_f[af.B.h];
	af.B.h=sra_a[af.B.h];
	t_add(8);
}

void sll_b(void)
{
	af.B.l=sll_f[bc.B.h];
	bc.B.h=sll_a[bc.B.h];
	t_add(8);
}

void sll_c(void)
{
	af.B.l=sll_f[bc.B.l];
	bc.B.l=sll_a[bc.B.l];
	t_add(8);
}

void sll_d(void)
{
	af.B.l=sll_f[de.B.h];
	de.B.h=sll_a[de.B.h];
	t_add(8);
}

void sll_e(void)
{
	af.B.l=sll_f[de.B.l];
	de.B.l=sll_a[de.B.l];
	t_add(8);
}

void sll_h(void)
{
	af.B.l=sll_f[hl.B.h];
	hl.B.h=sll_a[hl.B.h];
	t_add(8);
}

void sll_l(void)
{
	af.B.l=sll_f[hl.B.l];
	hl.B.l=sll_a[hl.B.l];
	t_add(8);
}

void sll_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=sll_f[btemp];
	spokeb(ix.W+CBdis,sll_a[btemp]);
	t_add(23);
}

void sll_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=sll_f[btemp];
	spokeb(iy.W+CBdis,sll_a[btemp]);
	t_add(23);
}

void sll_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=sll_f[btemp];
	spokeb(hl.W,sll_a[btemp]);
	t_add(15);
}

void CBsll_a(void)
{
	af.B.l=sll_f[af.B.h];
	af.B.h=sll_a[af.B.h];
	t_add(8);
}

void srl_b(void)
{
	af.B.l=srl_f[bc.B.h];
	bc.B.h=srl_a[bc.B.h];
	t_add(8);
}

void srl_c(void)
{
	af.B.l=srl_f[bc.B.l];
	bc.B.l=srl_a[bc.B.l];
	t_add(8);
}

void srl_d(void)
{
	af.B.l=srl_f[de.B.h];
	de.B.h=srl_a[de.B.h];
	t_add(8);
}

void srl_e(void)
{
	af.B.l=srl_f[de.B.l];
	de.B.l=srl_a[de.B.l];
	t_add(8);
}

void srl_h(void)
{
	af.B.l=srl_f[hl.B.h];
	hl.B.h=srl_a[hl.B.h];
	t_add(8);
}

void srl_l(void)
{
	af.B.l=srl_f[hl.B.l];
	hl.B.l=srl_a[hl.B.l];
	t_add(8);
}

void srl_ix(void)
{
	register UC btemp;

	btemp=speekb(ix.W+CBdis);
	af.B.l=srl_f[btemp];
	spokeb(ix.W+CBdis,srl_a[btemp]);
	t_add(23);
}

void srl_iy(void)
{
	register UC btemp;

	btemp=speekb(iy.W+CBdis);
	af.B.l=srl_f[btemp];
	spokeb(iy.W+CBdis,srl_a[btemp]);
	t_add(23);
}

void srl_hl(void)
{
	register UC btemp;

	btemp=speekb(hl.W);
	af.B.l=srl_f[btemp];
	spokeb(hl.W,srl_a[btemp]);
	t_add(15);
}

void CBsrl_a(void)
{
	af.B.l=srl_f[af.B.h];
	af.B.h=srl_a[af.B.h];
	t_add(8);
}

void bit0_b(void)
{
	af.B.l=bit_f0[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit0_c(void)
{
	af.B.l=bit_f0[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit0_d(void)
{
	af.B.l=bit_f0[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit0_e(void)
{
	af.B.l=bit_f0[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit0_h(void)
{
	af.B.l=bit_f0[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit0_l(void)
{
	af.B.l=bit_f0[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit0_ix(void)
{
	af.B.l=bit_f0[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit0_iy(void)
{
	af.B.l=bit_f0[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit0_hl(void)
{
	af.B.l=bit_f0[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit0_a(void)
{
	af.B.l=bit_f0[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit1_b(void)
{
	af.B.l=bit_f1[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit1_c(void)
{
	af.B.l=bit_f1[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit1_d(void)
{
	af.B.l=bit_f1[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit1_e(void)
{
	af.B.l=bit_f1[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit1_h(void)
{
	af.B.l=bit_f1[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit1_l(void)
{
	af.B.l=bit_f1[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit1_ix(void)
{
	af.B.l=bit_f1[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit1_iy(void)
{
	af.B.l=bit_f1[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit1_hl(void)
{
	af.B.l=bit_f1[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit1_a(void)
{
	af.B.l=bit_f1[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit2_b(void)
{
	af.B.l=bit_f2[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit2_c(void)
{
	af.B.l=bit_f2[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit2_d(void)
{
	af.B.l=bit_f2[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit2_e(void)
{
	af.B.l=bit_f2[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit2_h(void)
{
	af.B.l=bit_f2[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit2_l(void)
{
	af.B.l=bit_f2[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit2_ix(void)
{
	af.B.l=bit_f2[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit2_iy(void)
{
	af.B.l=bit_f2[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit2_hl(void)
{
	af.B.l=bit_f2[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit2_a(void)
{
	af.B.l=bit_f2[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit3_b(void)
{
	af.B.l=bit_f3[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit3_c(void)
{
	af.B.l=bit_f3[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit3_d(void)
{
	af.B.l=bit_f3[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit3_e(void)
{
	af.B.l=bit_f3[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit3_h(void)
{
	af.B.l=bit_f3[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit3_l(void)
{
	af.B.l=bit_f3[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit3_ix(void)
{
	af.B.l=bit_f3[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit3_iy(void)
{
	af.B.l=bit_f3[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit3_hl(void)
{
	af.B.l=bit_f3[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit3_a(void)
{
	af.B.l=bit_f3[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit4_b(void)
{
	af.B.l=bit_f4[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit4_c(void)
{
	af.B.l=bit_f4[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit4_d(void)
{
	af.B.l=bit_f4[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit4_e(void)
{
	af.B.l=bit_f4[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit4_h(void)
{
	af.B.l=bit_f4[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit4_l(void)
{
	af.B.l=bit_f4[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit4_ix(void)
{
	af.B.l=bit_f4[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit4_iy(void)
{
	af.B.l=bit_f4[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit4_hl(void)
{
	af.B.l=bit_f4[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit4_a(void)
{
	af.B.l=bit_f4[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit5_b(void)
{
	af.B.l=bit_f5[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit5_c(void)
{
	af.B.l=bit_f5[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit5_d(void)
{
	af.B.l=bit_f5[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit5_e(void)
{
	af.B.l=bit_f5[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit5_h(void)
{
	af.B.l=bit_f5[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit5_l(void)
{
	af.B.l=bit_f5[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit5_ix(void)
{
	af.B.l=bit_f5[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit5_iy(void)
{
	af.B.l=bit_f5[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit5_hl(void)
{
	af.B.l=bit_f5[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit5_a(void)
{
	af.B.l=bit_f5[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit6_b(void)
{
	af.B.l=bit_f6[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit6_c(void)
{
	af.B.l=bit_f6[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit6_d(void)
{
	af.B.l=bit_f6[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit6_e(void)
{
	af.B.l=bit_f6[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit6_h(void)
{
	af.B.l=bit_f6[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit6_l(void)
{
	af.B.l=bit_f6[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit6_ix(void)
{
	af.B.l=bit_f6[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit6_iy(void)
{
	af.B.l=bit_f6[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit6_hl(void)
{
	af.B.l=bit_f6[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit6_a(void)
{
	af.B.l=bit_f6[af.B.h]|(af.B.l&1);
	t_add(8);
}

void bit7_b(void)
{
	af.B.l=bit_f7[bc.B.h]|(af.B.l&1);
	t_add(8);
}

void bit7_c(void)
{
	af.B.l=bit_f7[bc.B.l]|(af.B.l&1);
	t_add(8);
}

void bit7_d(void)
{
	af.B.l=bit_f7[de.B.h]|(af.B.l&1);
	t_add(8);
}

void bit7_e(void)
{
	af.B.l=bit_f7[de.B.l]|(af.B.l&1);
	t_add(8);
}

void bit7_h(void)
{
	af.B.l=bit_f7[hl.B.h]|(af.B.l&1);
	t_add(8);
}

void bit7_l(void)
{
	af.B.l=bit_f7[hl.B.l]|(af.B.l&1);
	t_add(8);
}

void bit7_ix(void)
{
	af.B.l=bit_f7[speekb(ix.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit7_iy(void)
{
	af.B.l=bit_f7[speekb(iy.W+CBdis)]|(af.B.l&1);
	t_add(20);
}

void bit7_hl(void)
{
	af.B.l=bit_f7[speekb(hl.W)]|(af.B.l&1);
	t_add(12);
}

void bit7_a(void)
{
	af.B.l=bit_f7[af.B.h]|(af.B.l&1);
	t_add(8);
}

void res0_b(void)
{
	bc.B.h&=254;
	t_add(8);
}

void res0_c(void)
{
	bc.B.l&=254;
	t_add(8);
}

void res0_d(void)
{
	de.B.h&=254;
	t_add(8);
}

void res0_e(void)
{
	de.B.l&=254;
	t_add(8);
}

void res0_h(void)
{
	hl.B.h&=254;
	t_add(8);
}

void res0_l(void)
{
	hl.B.l&=254;
	t_add(8);
}

void res0_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&254);
	t_add(23);
}

void res0_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&254);
	t_add(23);
}

void res0_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&254);
	t_add(15);
}

void res0_a(void)
{
	af.B.h&=254;
	t_add(8);
}

void res1_b(void)
{
	bc.B.h&=253;
	t_add(8);
}

void res1_c(void)
{
	bc.B.l&=253;
	t_add(8);
}

void res1_d(void)
{
	de.B.h&=253;
	t_add(8);
}

void res1_e(void)
{
	de.B.l&=253;
	t_add(8);
}

void res1_h(void)
{
	hl.B.h&=253;
	t_add(8);
}

void res1_l(void)
{
	hl.B.l&=253;
	t_add(8);
}

void res1_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&253);
	t_add(23);
}

void res1_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&253);
	t_add(23);
}

void res1_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&253);
	t_add(15);
}

void res1_a(void)
{
	af.B.h&=253;
	t_add(8);
}

void res2_b(void)
{
	bc.B.h&=251;
	t_add(8);
}

void res2_c(void)
{
	bc.B.l&=251;
	t_add(8);
}

void res2_d(void)
{
	de.B.h&=251;
	t_add(8);
}

void res2_e(void)
{
	de.B.l&=251;
	t_add(8);
}

void res2_h(void)
{
	hl.B.h&=251;
	t_add(8);
}

void res2_l(void)
{
	hl.B.l&=251;
	t_add(8);
}

void res2_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&251);
	t_add(23);
}

void res2_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&251);
	t_add(23);
}

void res2_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&251);
	t_add(15);
}

void res2_a(void)
{
	af.B.h&=251;
	t_add(8);
}

void res3_b(void)
{
	bc.B.h&=247;
	t_add(8);
}

void res3_c(void)
{
	bc.B.l&=247;
	t_add(8);
}

void res3_d(void)
{
	de.B.h&=247;
	t_add(8);
}

void res3_e(void)
{
	de.B.l&=247;
	t_add(8);
}

void res3_h(void)
{
	hl.B.h&=247;
	t_add(8);
}

void res3_l(void)
{
	hl.B.l&=247;
	t_add(8);
}

void res3_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&247);
	t_add(23);
}

void res3_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&247);
	t_add(23);
}

void res3_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&247);
	t_add(15);
}

void res3_a(void)
{
	af.B.h&=247;
	t_add(8);
}

void res4_b(void)
{
	bc.B.h&=239;
	t_add(8);
}

void res4_c(void)
{
	bc.B.l&=239;
	t_add(8);
}

void res4_d(void)
{
	de.B.h&=239;
	t_add(8);
}

void res4_e(void)
{
	de.B.l&=239;
	t_add(8);
}

void res4_h(void)
{
	hl.B.h&=239;
	t_add(8);
}

void res4_l(void)
{
	hl.B.l&=239;
	t_add(8);
}

void res4_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&239);
	t_add(23);
}

void res4_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&239);
	t_add(23);
}

void res4_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&239);
	t_add(15);
}

void res4_a(void)
{
	af.B.h&=239;
	t_add(8);
}

void res5_b(void)
{
	bc.B.h&=223;
	t_add(8);
}

void res5_c(void)
{
	bc.B.l&=223;
	t_add(8);
}

void res5_d(void)
{
	de.B.h&=223;
	t_add(8);
}

void res5_e(void)
{
	de.B.l&=223;
	t_add(8);
}

void res5_h(void)
{
	hl.B.h&=223;
	t_add(8);
}

void res5_l(void)
{
	hl.B.l&=223;
	t_add(8);
}

void res5_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&223);
	t_add(23);
}

void res5_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&223);
	t_add(23);
}

void res5_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&223);
	t_add(15);
}

void res5_a(void)
{
	af.B.h&=223;
	t_add(8);
}

void res6_b(void)
{
	bc.B.h&=191;
	t_add(8);
}

void res6_c(void)
{
	bc.B.l&=191;
	t_add(8);
}

void res6_d(void)
{
	de.B.h&=191;
	t_add(8);
}

void res6_e(void)
{
	de.B.l&=191;
	t_add(8);
}

void res6_h(void)
{
	hl.B.h&=191;
	t_add(8);
}

void res6_l(void)
{
	hl.B.l&=191;
	t_add(8);
}

void res6_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&191);
	t_add(23);
}

void res6_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&191);
	t_add(23);
}

void res6_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&191);
	t_add(15);
}

void res6_a(void)
{
	af.B.h&=191;
	t_add(8);
}

void res7_b(void)
{
	bc.B.h&=127;
	t_add(8);
}

void res7_c(void)
{
	bc.B.l&=127;
	t_add(8);
}

void res7_d(void)
{
	de.B.h&=127;
	t_add(8);
}

void res7_e(void)
{
	de.B.l&=127;
	t_add(8);
}

void res7_h(void)
{
	hl.B.h&=127;
	t_add(8);
}

void res7_l(void)
{
	hl.B.l&=127;
	t_add(8);
}

void res7_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)&127);
	t_add(23);
}

void res7_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)&127);
	t_add(23);
}

void res7_hl(void)
{
	spokeb(hl.W,speekb(hl.W)&127);
	t_add(15);
}

void res7_a(void)
{
	af.B.h&=127;
	t_add(8);
}

void set0_b(void)
{
	bc.B.h|=1;
	t_add(8);
}

void set0_c(void)
{
	bc.B.l|=1;
	t_add(8);
}

void set0_d(void)
{
	de.B.h|=1;
	t_add(8);
}

void set0_e(void)
{
	de.B.l|=1;
	t_add(8);
}

void set0_h(void)
{
	hl.B.h|=1;
	t_add(8);
}

void set0_l(void)
{
	hl.B.l|=1;
	t_add(8);
}

void set0_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|1);
	t_add(23);
}

void set0_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|1);
	t_add(23);
}

void set0_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|1);
	t_add(15);
}

void set0_a(void)
{
	af.B.h|=1;
	t_add(8);
}

void set1_b(void)
{
	bc.B.h|=2;
	t_add(8);
}

void set1_c(void)
{
	bc.B.l|=2;
	t_add(8);
}

void set1_d(void)
{
	de.B.h|=2;
	t_add(8);
}

void set1_e(void)
{
	de.B.l|=2;
	t_add(8);
}

void set1_h(void)
{
	hl.B.h|=2;
	t_add(8);
}

void set1_l(void)
{
	hl.B.l|=2;
	t_add(8);
}

void set1_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|2);
	t_add(23);
}

void set1_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|2);
	t_add(23);
}

void set1_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|2);
	t_add(15);
}

void set1_a(void)
{
	af.B.h|=2;
	t_add(8);
}

void set2_b(void)
{
	bc.B.h|=4;
	t_add(8);
}

void set2_c(void)
{
	bc.B.l|=4;
	t_add(8);
}

void set2_d(void)
{
	de.B.h|=4;
	t_add(8);
}

void set2_e(void)
{
	de.B.l|=4;
	t_add(8);
}

void set2_h(void)
{
	hl.B.h|=4;
	t_add(8);
}

void set2_l(void)
{
	hl.B.l|=4;
	t_add(8);
}

void set2_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|4);
	t_add(23);
}

void set2_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|4);
	t_add(23);
}

void set2_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|4);
	t_add(15);
}

void set2_a(void)
{
	af.B.h|=4;
	t_add(8);
}

void set3_b(void)
{
	bc.B.h|=8;
	t_add(8);
}

void set3_c(void)
{
	bc.B.l|=8;
	t_add(8);
}

void set3_d(void)
{
	de.B.h|=8;
	t_add(8);
}

void set3_e(void)
{
	de.B.l|=8;
	t_add(8);
}

void set3_h(void)
{
	hl.B.h|=8;
	t_add(8);
}

void set3_l(void)
{
	hl.B.l|=8;
	t_add(8);
}

void set3_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|8);
	t_add(23);
}

void set3_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|8);
	t_add(23);
}

void set3_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|8);
	t_add(15);
}

void set3_a(void)
{
	af.B.h|=8;
	t_add(8);
}

void set4_b(void)
{
	bc.B.h|=16;
	t_add(8);
}

void set4_c(void)
{
	bc.B.l|=16;
	t_add(8);
}

void set4_d(void)
{
	de.B.h|=16;
	t_add(8);
}

void set4_e(void)
{
	de.B.l|=16;
	t_add(8);
}

void set4_h(void)
{
	hl.B.h|=16;
	t_add(8);
}

void set4_l(void)
{
	hl.B.l|=16;
	t_add(8);
}

void set4_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|16);
	t_add(23);
}

void set4_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|16);
	t_add(23);
}

void set4_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|16);
	t_add(15);
}

void set4_a(void)
{
	af.B.h|=16;
	t_add(8);
}

void set5_b(void)
{
	bc.B.h|=32;
	t_add(8);
}

void set5_c(void)
{
	bc.B.l|=32;
	t_add(8);
}

void set5_d(void)
{
	de.B.h|=32;
	t_add(8);
}

void set5_e(void)
{
	de.B.l|=32;
	t_add(8);
}

void set5_h(void)
{
	hl.B.h|=32;
	t_add(8);
}

void set5_l(void)
{
	hl.B.l|=32;
	t_add(8);
}

void set5_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|32);
	t_add(23);
}

void set5_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|32);
	t_add(23);
}

void set5_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|32);
	t_add(15);
}

void set5_a(void)
{
	af.B.h|=32;
	t_add(8);
}

void set6_b(void)
{
	bc.B.h|=64;
	t_add(8);
}

void set6_c(void)
{
	bc.B.l|=64;
	t_add(8);
}

void set6_d(void)
{
	de.B.h|=64;
	t_add(8);
}

void set6_e(void)
{
	de.B.l|=64;
	t_add(8);
}

void set6_h(void)
{
	hl.B.h|=64;
	t_add(8);
}

void set6_l(void)
{
	hl.B.l|=64;
	t_add(8);
}

void set6_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|64);
	t_add(23);
}

void set6_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|64);
	t_add(23);
}

void set6_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|64);
	t_add(15);
}

void set6_a(void)
{
	af.B.h|=64;
	t_add(8);
}

void set7_b(void)
{
	bc.B.h|=128;
	t_add(8);
}

void set7_c(void)
{
	bc.B.l|=128;
	t_add(8);
}

void set7_d(void)
{
	de.B.h|=128;
	t_add(8);
}

void set7_e(void)
{
	de.B.l|=128;
	t_add(8);
}

void set7_h(void)
{
	hl.B.h|=128;
	t_add(8);
}

void set7_l(void)
{
	hl.B.l|=128;
	t_add(8);
}

void set7_ix(void)
{
	spokeb(ix.W+CBdis,speekb(ix.W+CBdis)|128);
	t_add(23);
}

void set7_iy(void)
{
	spokeb(iy.W+CBdis,speekb(iy.W+CBdis)|128);
	t_add(23);
}

void set7_hl(void)
{
	spokeb(hl.W,speekb(hl.W)|128);
	t_add(15);
}

void set7_a(void)
{
	af.B.h|=128;
	t_add(8);
}
