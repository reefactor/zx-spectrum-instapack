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

void nop(void); /* nop */
void ld_bc_XXXX(void); /* ld bc,XXXX */
void ld_mbc_a(void); /* ld (bc),a */
void inc_bc(void); /* inc bc */
void inc_b(void); /* inc b TABLE UNTESTED */
void dec_b(void); /* dec b TABLE UNTESTED */
void ld_b_XX(void); /* ld b,XX */
void rlca(void); /* rlca TABLE UNTESTED */
void ex_af_af(void); /* ex af,af' */
void add_ix_bc(void); /* add ix,bc */
void add_iy_bc(void); /* add iy,bc */
void add_hl_bc(void); /* add hl,bc */
void ld_a_mbc(void); /* ld a,(bc) */
void dec_bc(void); /* dec bc */
void inc_c(void); /* inc c TABLE UNTESTED */
void dec_c(void); /* dec c TABLE UNTESTED */
void ld_c_XX(void); /* ld c,XX */
void rrca(void); /* rrca TABLE UNTESTED */
void djnz_DIS(void); /* djnz DIS  */
void ld_de_XXXX(void); /* ld de,XXXX */
void ld_mde_a(void); /* ld(de),a */
void inc_de(void); /* inc de */
void inc_d(void); /* inc d TABLE UNTESTED */
void dec_d(void); /* dec d TABLE UNTESTED */
void ld_d_XX(void); /* ld d,XX */
void rla(void); /* rla */
void jr_DIS(void); /* jr DIS */
void add_ix_de(void); /* add ix,de */
void add_iy_de(void); /* add iy,de */
void add_hl_de(void); /* add hl,de */
void ld_a_mde(void); /* ld a,(de) */
void dec_de(void); /* dec de */
void inc_e(void); /* inc e TABLE UNTESTED */
void dec_e(void); /* dec e TABLE UNTESTED */
void ld_e_XX(void); /* ld e,XX */
void rra(void); /* rra */
void jr_nz_DIS(void); /* jr nz,DIS */
void ld_ix_XXXX(void); /* ld ix,XXXX */
void ld_iy_XXXX(void); /* ld iy,XXXX */
void ld_hl_XXXX(void); /* ld hl,XXXX */
void Z80ld_aXXXX_ix(void); /* ld(XXXX),ix */
void Z80ld_aXXXX_iy(void); /* ld(XXXX),iy */
void Z80ld_aXXXX_hl(void); /* ld(XXXX),hl */
void inc_ix(void); /* inc ix */
void inc_iy(void); /* inc iy */
void inc_hl(void); /* inc hl */
void inc_ixh(void); /* inc ixh TABLE UNTESTED */
void inc_iyh(void); /* inc iyh TABLE UNTESTED */
void inc_h(void); /* inc h TABLE UNTESTED */
void dec_ixh(void); /* dec ixh TABLE UNTESTED */
void dec_iyh(void); /* dec iyh TABLE UNTESTED */
void dec_h(void); /* dec h TABLE UNTESTED */
void ld_ixh_XX(void); /* ld ixh,XX */
void ld_iyh_XX(void); /* ld iyh,XX */
void ld_h_XX(void); /* ld h,XX */
void daa(void); /* daa INCOMPLETE! */
void jr_z_DIS(void); /* jr z,DIS */
void add_ix_ix(void); /* add ix,ix */
void add_iy_iy(void); /* add iy,iy */
void add_hl_hl(void); /* add hl,hl */
void Z80ld_ix_aXXXX(void); /* ld ix,(XXXX) */
void Z80ld_iy_aXXXX(void); /* ld iy,(XXXX) */
void Z80ld_hl_aXXXX(void); /* ld hl,(XXXX) */
void dec_ix(void); /* dec ix */
void dec_iy(void); /* dec iy */
void dec_hl(void); /* dec hl */
void inc_ixl(void); /* inc ixl TABLE UNTESTED */
void inc_iyl(void); /* inc iyl TABLE UNTESTED */
void inc_l(void); /* inc l TABLE UNTESTED */
void dec_ixl(void); /* dec ixl TABLE UNTESTED */
void dec_iyl(void); /* dec iyl TABLE UNTESTED */
void dec_l(void); /* dec l TABLE UNTESTED */
void ld_ixl_XX(void); /* ld ixl,XX */
void ld_iyl_XX(void); /* ld iyl,XX */
void ld_l_XX(void); /* ld l,XX */
void cpl(void); /* cpl */
void jr_nc_DIS(void); /* jr nc,DIS */
void ld_sp_XXXX(void); /* ld sp,XXXX */
void ld_aXXXX_a(void); /* ld(XXXX),a */
void inc_sp(void); /* inc sp */
void inc_mix(void); /* inc(ix) TABLE UNTESTED */
void inc_miy(void); /* inc(iy) TABLE UNTESTED */
void inc_mhl(void); /* inc(hl) TABLE UNTESTED */
void dec_mix(void); /* dec(ix) TABLE UNTESTED */
void dec_miy(void); /* dec(iy) TABLE UNTESTED */
void dec_mhl(void); /* dec(hl) TABLE UNTESTED */
void ld_mix_XX(void); /* ld(ix),XX */
void ld_miy_XX(void); /* ld(iy),XX */
void ld_mhl_XX(void); /* ld(hl),XX */
void scf(void); /* scf */
void jr_c_DIS(void); /* jr c,DIS */
void add_ix_sp(void); /* add ix,sp */
void add_iy_sp(void); /* add iy,sp */
void add_hl_sp(void); /* add hl,sp */
void ld_a_aXXXX(void); /* ld a,(XXXX) */
void dec_sp(void); /* dec sp */
void Z80inc_a(void); /* inc a TABLE UNTESTED */
void Z80dec_a(void); /* dec a TABLE UNTESTED */
void ld_a_XX(void); /* ld a,XX */
void ccf(void); /* ccf */
void ld_b_b(void); /* ld b,b */
void ld_b_c(void); /* ld b,c */
void ld_b_d(void); /* ld b,d */
void ld_b_e(void); /* ld b,e */
void ld_b_ixh(void); /* ld b,ixh */
void ld_b_iyh(void); /* ld b,iyh */
void ld_b_h(void); /* ld b,h */
void ld_b_ixl(void); /* ld b,ixl */
void ld_b_iyl(void); /* ld b,iyl */
void ld_b_l(void); /* ld b,l */
void ld_b_ix(void); /* ld b,(ix+DIS) */
void ld_b_iy(void); /* ld b,(iy+DIS) */
void ld_b_hl(void); /* ld b,(hl) */
void ld_b_a(void); /* ld b,a */
void ld_c_b(void); /* ld c,b */
void ld_c_c(void); /* ld c,c */
void ld_c_d(void); /* ld c,d */
void ld_c_e(void); /* ld c,e */
void ld_c_ixh(void); /* ld c,ixh */
void ld_c_iyh(void); /* ld c,iyh */
void ld_c_h(void); /* ld c,h */
void ld_c_ixl(void); /* ld c,ixl */
void ld_c_iyl(void); /* ld c,iyl */
void ld_c_l(void); /* ld c,l */
void ld_c_ix(void); /* ld c,(ix+DIS) */
void ld_c_iy(void); /* ld c,(iy+DIS) */
void ld_c_hl(void); /* ld c,(hl) */
void ld_c_a(void); /* ld c,a */
void ld_d_b(void); /* ld d,b */
void ld_d_c(void); /* ld d,c */
void ld_d_d(void); /* ld d,d */
void ld_d_e(void); /* ld d,e */
void ld_d_ixh(void); /* ld d,ixh */
void ld_d_iyh(void); /* ld d,iyh */
void ld_d_h(void); /* ld d,h */
void ld_d_ixl(void); /* ld d,ixl */
void ld_d_iyl(void); /* ld d,iyl */
void ld_d_l(void); /* ld d,l */
void ld_d_ix(void); /* ld d,(ix+DIS) */
void ld_d_iy(void); /* ld d,(iy+DIS) */
void ld_d_hl(void); /* ld d,(hl) */
void ld_d_a(void); /* ld d,a */
void ld_e_b(void); /* ld e,b */
void ld_e_c(void); /* ld e,c */
void ld_e_d(void); /* ld e,d */
void ld_e_e(void); /* ld e,e */
void ld_e_ixh(void); /* ld e,ixh */
void ld_e_iyh(void); /* ld e,iyh */
void ld_e_h(void); /* ld e,h */
void ld_e_ixl(void); /* ld e,ixl */
void ld_e_iyl(void); /* ld e,iyl */
void ld_e_l(void); /* ld e,l */
void ld_e_ix(void); /* ld e,(ix+DIS) */
void ld_e_iy(void); /* ld e,(iy+DIS) */
void ld_e_hl(void); /* ld e,(hl) */
void ld_e_a(void); /* ld e,a */
void ld_ixh_b(void); /* ld ixh,b */
void ld_iyh_b(void); /* ld iyh,b */
void ld_h_b(void); /* ld h,b */
void ld_ixh_c(void); /* ld ixh,c */
void ld_iyh_c(void); /* ld iyh,c */
void ld_h_c(void); /* ld h,c */
void ld_ixh_d(void); /* ld ixh,d */
void ld_iyh_d(void); /* ld iyh,d */
void ld_h_d(void); /* ld h,d */
void ld_ixh_e(void); /* ld ixh,e */
void ld_iyh_e(void); /* ld iyh,e */
void ld_h_e(void); /* ld h,e */
void ld_ixh_ixh(void); /* ld ixh,ixh */
void ld_iyh_iyh(void); /* ld iyh,iyh */
void ld_h_h(void); /* ld h,h */
void ld_ixh_ixl(void); /* ld ixh,ixl */
void ld_iyh_iyl(void); /* ld iyh,iyl */
void ld_h_l(void); /* ld h,l */
void ld_h_ix(void); /* ld h,(ix+DIS) */
void ld_h_iy(void); /* ld h,(iy+DIS) */
void ld_h_hl(void); /* ld h,(hl) */
void ld_ixh_a(void); /* ld ixh,a */
void ld_iyh_a(void); /* ld iyh,a */
void ld_h_a(void); /* ld h,a */
void ld_ixl_b(void); /* ld ixl,b */
void ld_iyl_b(void); /* ld iyl,b */
void ld_l_b(void); /* ld l,b */
void ld_ixl_c(void); /* ld ixl,c */
void ld_iyl_c(void); /* ld iyl,c */
void ld_l_c(void); /* ld l,c */
void ld_ixl_d(void); /* ld ixl,d */
void ld_iyl_d(void); /* ld iyl,d */
void ld_l_d(void); /* ld l,d */
void ld_ixl_e(void); /* ld ixl,e */
void ld_iyl_e(void); /* ld iyl,e */
void ld_l_e(void); /* ld l,e */
void ld_ixl_ixh(void); /* ld ixl,ixh */
void ld_iyl_iyh(void); /* ld iyl,iyh */
void ld_l_h(void); /* ld l,h */
void ld_ixl_ixl(void); /* ld ixl,ixl */
void ld_iyl_iyl(void); /* ld iyl,iyl */
void ld_l_l(void); /* ld l,l */
void ld_l_ix(void); /* ld l,(ix+DIS) */
void ld_l_iy(void); /* ld l,(iy+DIS) */
void ld_l_hl(void); /* ld l,(hl) */
void ld_ixl_a(void); /* ld ixl,a */
void ld_iyl_a(void); /* ld iyl,a */
void ld_l_a(void); /* ld l,a */
void ld_ix_b(void); /* ld (ix+DIS),b */
void ld_iy_b(void); /* ld (iy+DIS),b */
void ld_hl_b(void); /* ld (hl),b */
void ld_ix_c(void); /* ld (ix+DIS),c */
void ld_iy_c(void); /* ld (iy+DIS),c */
void ld_hl_c(void); /* ld (hl),c */
void ld_ix_d(void); /* ld (ix+DIS),d */
void ld_iy_d(void); /* ld (iy+DIS),d */
void ld_hl_d(void); /* ld (hl),d */
void ld_ix_e(void); /* ld (ix+DIS),e */
void ld_iy_e(void); /* ld (iy+DIS),e */
void ld_hl_e(void); /* ld (hl),e */
void ld_ix_h(void); /* ld (ix+DIS),h */
void ld_iy_h(void); /* ld (iy+DIS),h */
void ld_hl_h(void); /* ld (hl),h */
void ld_ix_l(void); /* ld (ix+DIS),l */
void ld_iy_l(void); /* ld (iy+DIS),l */
void ld_hl_l(void); /* ld (hl),l */
void Z80halt(void); /* halt */
void ld_ix_a(void); /* ld (ix+DIS),a */
void ld_iy_a(void); /* ld (iy+DIS),a */
void ld_hl_a(void); /* ld (hl),a */
void ld_a_b(void); /* ld a,b */
void ld_a_c(void); /* ld a,c */
void ld_a_d(void); /* ld a,d */
void ld_a_e(void); /* ld a,e */
void ld_a_ixh(void); /* ld a,ixh */
void ld_a_iyh(void); /* ld a,iyh */
void ld_a_h(void); /* ld a,h */
void ld_a_ixl(void); /* ld a,ixl */
void ld_a_iyl(void); /* ld a,iyl */
void ld_a_l(void); /* ld a,l */
void ld_a_ix(void); /* ld a,(ix+DIS) */
void ld_a_iy(void); /* ld a,(iy+DIS) */
void ld_a_hl(void); /* ld a,(hl) */
void ld_a_a(void); /* ld a,a */
void add_a_b(void); /* add a,b */
void add_a_c(void); /* add a,c */
void add_a_d(void); /* add a,d */
void add_a_e(void); /* add a,e */
void add_a_ixh(void); /* add a,ixh */
void add_a_iyh(void); /* add a,iyh */
void add_a_h(void); /* add a,h */
void add_a_ixl(void); /* add a,ixl */
void add_a_iyl(void); /* add a,iyl */
void add_a_l(void); /* add a,l */
void add_a_ix(void); /* add a,(ix+DIS) */
void add_a_iy(void); /* add a,(iy+DIS) */
void add_a_hl(void); /* add a,(hl) */
void add_a_a(void); /* add a,a */
void adc_a_b(void); /* adc a,b */
void adc_a_c(void); /* adc a,c */
void adc_a_d(void); /* adc a,d */
void adc_a_e(void); /* adc a,e */
void adc_a_ixh(void); /* adc a,ixh */
void adc_a_iyh(void); /* adc a,iyh */
void adc_a_h(void); /* adc a,h */
void adc_a_ixl(void); /* adc a,ixl */
void adc_a_iyl(void); /* adc a,iyl */
void adc_a_l(void); /* adc a,l */
void adc_a_ix(void); /* adc a,(ix+DIS) */
void adc_a_iy(void); /* adc a,(iy+DIS) */
void adc_a_hl(void); /* adc a,(hl) */
void adc_a_a(void); /* adc a,a */
void sub_b(void); /* sub b */
void sub_c(void); /* sub c */
void sub_d(void); /* sub d */
void sub_e(void); /* sub e */
void sub_ixh(void); /* sub ixh */
void sub_iyh(void); /* sub iyh */
void sub_h(void); /* sub h */
void sub_ixl(void); /* sub ixl */
void sub_iyl(void); /* sub iyl */
void sub_l(void); /* sub l */
void sub_ix(void); /* sub (ix+DIS) */
void sub_iy(void); /* sub (iy+DIS) */
void sub_hl(void); /* sub (hl) */
void sub_a(void); /* sub a */
void sbc_a_b(void); /* sbc a,b */
void sbc_a_c(void); /* sbc a,c */
void sbc_a_d(void); /* sbc a,d */
void sbc_a_e(void); /* sbc a,e */
void sbc_a_ixh(void); /* sbc a,ixh */
void sbc_a_iyh(void); /* sbc a,iyh */
void sbc_a_h(void); /* sbc a,h */
void sbc_a_ixl(void); /* sbc a,ixl */
void sbc_a_iyl(void); /* sbc a,iyl */
void sbc_a_l(void); /* sbc a,l */
void sbc_a_ix(void); /* sbc a,(ix+DIS) */
void sbc_a_iy(void); /* sbc a,(iy+DIS) */
void sbc_a_hl(void); /* sbc a,(hl) */
void sbc_a_a(void); /* sbc a,a */
void and_b(void); /* and b */
void and_c(void); /* and c */
void and_d(void); /* and d */
void and_e(void); /* and e */
void and_ixh(void); /* and ixh */
void and_iyh(void); /* and iyh */
void and_h(void); /* and h */
void and_ixl(void); /* and ixl */
void and_iyl(void); /* and iyl */
void and_l(void); /* and l */
void and_ix(void); /* and (ix+DIS) */
void and_iy(void); /* and (iy+DIS) */
void and_hl(void); /* and (hl) */
void and_a(void); /* and a */
void xor_b(void); /* xor b */
void xor_c(void); /* xor c */
void xor_d(void); /* xor d */
void xor_e(void); /* xor e */
void xor_ixh(void); /* xor ixh */
void xor_iyh(void); /* xor iyh */
void xor_h(void); /* xor h */
void xor_ixl(void); /* xor ixl */
void xor_iyl(void); /* xor iyl */
void xor_l(void); /* xor l */
void xor_ix(void); /* xor (ix+DIS) */
void xor_iy(void); /* xor (iy+DIS) */
void xor_hl(void); /* xor (hl) */
void xor_a(void); /* xor a */
void or_b(void); /* or b */
void or_c(void); /* or c */
void or_d(void); /* or d */
void or_e(void); /* or e */
void or_ixh(void); /* or ixh */
void or_iyh(void); /* or iyh */
void or_h(void); /* or h */
void or_ixl(void); /* or ixl */
void or_iyl(void); /* or iyl */
void or_l(void); /* or l */
void or_ix(void); /* or (ix+DIS) */
void or_iy(void); /* or (iy+DIS) */
void or_hl(void); /* or (hl) */
void or_a(void); /* or a */
void cp_b(void); /* cp b */
void cp_c(void); /* cp c */
void cp_d(void); /* cp d */
void cp_e(void); /* cp e */
void cp_ixh(void); /* cp ixh */
void cp_iyh(void); /* cp iyh */
void cp_h(void); /* cp h */
void cp_ixl(void); /* cp ixl */
void cp_iyl(void); /* cp iyl */
void cp_l(void); /* cp l */
void cp_ix(void); /* cp (ix+DIS) */
void cp_iy(void); /* cp (iy+DIS) */
void cp_hl(void); /* cp (hl) */
void cp_a(void); /* cp a */
void ret_nz(void); /* ret nz */
void pop_bc(void); /* pop bc */
void jp_nz_XXXX(void); /* jp nz,XXXX */
void jp_XXXX(void); /* jp XXXX */
void call_nz_XXXX(void); /* call nz,XXXX */
void push_bc(void); /* push bc */
void add_a_XX(void); /* add a,XX */
void rst_0(void); /* rst 0 */
void ret_z(void); /* ret z */
void ret(void); /* ret */
void jp_z_XXXX(void); /* jp z,XXXX */

void IX_CB_Pre(void);
void IY_CB_Pre(void);
void CB_Pre(void);

void call_z_XXXX(void); /* call z,XXXX */
void call_XXXX(void); /* call XXXX */
void adc_a_XX(void); /* adc a,XX */
void rst_8(void); /* rst 8 */
void ret_nc(void); /* ret nc */
void pop_de(void); /* pop de */
void jp_nc_XXXX(void); /* jp nc,XXXX */
void out_XX_a(void); /* out(XX),a */
void call_nc_XXXX(void); /* call nc,XXXX */
void push_de(void); /* push de */
void sub_XX(void); /* sub XX */
void rst_16(void); /* rst 16 */
void ret_c(void); /* ret c */
void exx(void); /* exx */
void jp_c_XXXX(void); /* jp c,XXXX */
void in_a_XX(void); /* in a,(XX) */
void call_c_XXXX(void); /* call c,XXXX */

void IX_Pre(void);

void sbc_a_XX(void); /* sbc a,XX */
void rst_24(void); /* rst 24 */
void ret_po(void); /* ret po */
void pop_ix(void); /* pop ix */
void pop_iy(void); /* pop iy */
void pop_hl(void); /* pop hl */
void jp_po_XXXX(void); /* jp po,XXXX */
void ex_msp_ix(void); /* ex(sp),ix */
void ex_msp_iy(void); /* ex(sp),iy */
void ex_msp_hl(void); /* ex(sp),hl */
void call_po_XXXX(void); /* call po,XXXX */
void push_ix(void); /* push ix */
void push_iy(void); /* push iy */
void push_hl(void); /* push hl */
void and_XX(void); /* and XX */
void rst_32(void); /* rst 32 */
void ret_pe(void); /* ret pe */
void jp_ix(void); /* jp ix */
void jp_iy(void); /* jp iy */
void jp_hl(void); /* jp hl */
void jp_pe_XXXX(void); /* jp pe,XXXX */
void ex_de_ix(void); /* ex de,ix */
void ex_de_iy(void); /* ex de,iy */
void ex_de_hl(void); /* ex de,hl */
void call_pe_XXXX(void); /* call pe,XXXX */

void ED_Pre(void);

void xor_XX(void); /* xor XX */
void rst_40(void); /* rst 40 */
void ret_p(void); /* ret p */
void pop_af(void); /* pop af */
void jp_p_XXXX(void); /* jp p,XXXX */
void di(void); /* di */
void call_p_XXXX(void); /* call p,XXXX */
void push_af(void); /* push af */
void or_XX(void); /* or XX */
void rst_48(void); /* rst 48 */
void ret_m(void); /* ret m */
void ld_sp_ix(void); /* ld sp,ix */
void ld_sp_iy(void); /* ld sp,iy */
void ld_sp_hl(void); /* ld sp,hl */
void jp_m_XXXX(void); /* jp m,XXXX */
void ei(void); /* ei */
void call_m_XXXX(void); /* call m,XXXX */

void IY_Pre(void);

void cp_XX(void); /* cp XX */
void rst_56(void); /* rst 56 */

#ifndef Z80_OBJ
struct
{
	void (*opcode)();
} Z80[256]=
{
	nop,
	ld_bc_XXXX,
	ld_mbc_a,
	inc_bc,
	inc_b,
	dec_b,
	ld_b_XX,
	rlca,
	ex_af_af,
	add_hl_bc,
	ld_a_mbc,
	dec_bc,
	inc_c,
	dec_c,
	ld_c_XX,
	rrca,
	djnz_DIS,
	ld_de_XXXX,
	ld_mde_a,
	inc_de,
	inc_d,
	dec_d,
	ld_d_XX,
	rla,
	jr_DIS,
	add_hl_de,
	ld_a_mde,
	dec_de,
	inc_e,
	dec_e,
	ld_e_XX,
	rra,
	jr_nz_DIS,
	ld_hl_XXXX,
	Z80ld_aXXXX_hl,
	inc_hl,
	inc_h,
	dec_h,
	ld_h_XX,
	daa,
	jr_z_DIS,
	add_hl_hl,
	Z80ld_hl_aXXXX,
	dec_hl,
	inc_l,
	dec_l,
	ld_l_XX,
	cpl,
	jr_nc_DIS,
	ld_sp_XXXX,
	ld_aXXXX_a,
	inc_sp,
	inc_mhl,
	dec_mhl,
	ld_mhl_XX,
	scf,
	jr_c_DIS,
	add_hl_sp,
	ld_a_aXXXX,
	dec_sp,
	Z80inc_a,
	Z80dec_a,
	ld_a_XX,
	ccf,
	ld_b_b,
	ld_b_c,
	ld_b_d,
	ld_b_e,
	ld_b_h,
	ld_b_l,
	ld_b_hl,
	ld_b_a,
	ld_c_b,
	ld_c_c,
	ld_c_d,
	ld_c_e,
	ld_c_h,
	ld_c_l,
	ld_c_hl,
	ld_c_a,
	ld_d_b,
	ld_d_c,
	ld_d_d,
	ld_d_e,
	ld_d_h,
	ld_d_l,
	ld_d_hl,
	ld_d_a,
	ld_e_b,
	ld_e_c,
	ld_e_d,
	ld_e_e,
	ld_e_h,
	ld_e_l,
	ld_e_hl,
	ld_e_a,
	ld_h_b,
	ld_h_c,
	ld_h_d,
	ld_h_e,
	ld_h_h,
	ld_h_l,
	ld_h_hl,
	ld_h_a,
	ld_l_b,
	ld_l_c,
	ld_l_d,
	ld_l_e,
	ld_l_h,
	ld_l_l,
	ld_l_hl,
	ld_l_a,
	ld_hl_b,
	ld_hl_c,
	ld_hl_d,
	ld_hl_e,
	ld_hl_h,
	ld_hl_l,
	Z80halt,
	ld_hl_a,
	ld_a_b,
	ld_a_c,
	ld_a_d,
	ld_a_e,
	ld_a_h,
	ld_a_l,
	ld_a_hl,
	ld_a_a,
	add_a_b,
	add_a_c,
	add_a_d,
	add_a_e,
	add_a_h,
	add_a_l,
	add_a_hl,
	add_a_a,
	adc_a_b,
	adc_a_c,
	adc_a_d,
	adc_a_e,
	adc_a_h,
	adc_a_l,
	adc_a_hl,
	adc_a_a,
	sub_b,
	sub_c,
	sub_d,
	sub_e,
	sub_h,
	sub_l,
	sub_hl,
	sub_a,
	sbc_a_b,
	sbc_a_c,
	sbc_a_d,
	sbc_a_e,
	sbc_a_h,
	sbc_a_l,
	sbc_a_hl,
	sbc_a_a,
	and_b,
	and_c,
	and_d,
	and_e,
	and_h,
	and_l,
	and_hl,
	and_a,
	xor_b,
	xor_c,
	xor_d,
	xor_e,
	xor_h,
	xor_l,
	xor_hl,
	xor_a,
	or_b,
	or_c,
	or_d,
	or_e,
	or_h,
	or_l,
	or_hl,
	or_a,
	cp_b,
	cp_c,
	cp_d,
	cp_e,
	cp_h,
	cp_l,
	cp_hl,
	cp_a,
	ret_nz,
	pop_bc,
	jp_nz_XXXX,
	jp_XXXX,
	call_nz_XXXX,
	push_bc,
	add_a_XX,
	rst_0,
	ret_z,
	ret,
	jp_z_XXXX,
	CB_Pre,
	call_z_XXXX,
	call_XXXX,
	adc_a_XX,
	rst_8,
	ret_nc,
	pop_de,
	jp_nc_XXXX,
	out_XX_a,
	call_nc_XXXX,
	push_de,
	sub_XX,
	rst_16,
	ret_c,
	exx,
	jp_c_XXXX,
	in_a_XX,
	call_c_XXXX,
	IX_Pre,
	sbc_a_XX,
	rst_24,
	ret_po,
	pop_hl,
	jp_po_XXXX,
	ex_msp_hl,
	call_po_XXXX,
	push_hl,
	and_XX,
	rst_32,
	ret_pe,
	jp_hl,
	jp_pe_XXXX,
	ex_de_hl,
	call_pe_XXXX,
	ED_Pre,
	xor_XX,
	rst_40,
	ret_p,
	pop_af,
	jp_p_XXXX,
	di,
	call_p_XXXX,
	push_af,
	or_XX,
	rst_48,
	ret_m,
	ld_sp_hl,
	jp_m_XXXX,
	ei,
	call_m_XXXX,
	IY_Pre,
	cp_XX,
	rst_56
};

struct
{
	void (*opcode)();
} Z80_IX[256]=
{
	nop,
	ld_bc_XXXX,
	ld_mbc_a,
	inc_bc,
	inc_b,
	dec_b,
	ld_b_XX,
	rlca,
	ex_af_af,
	add_ix_bc,
	ld_a_mbc,
	dec_bc,
	inc_c,
	dec_c,
	ld_c_XX,
	rrca,
	djnz_DIS,
	ld_de_XXXX,
	ld_mde_a,
	inc_de,
	inc_d,
	dec_d,
	ld_d_XX,
	rla,
	jr_DIS,
	add_ix_de,
	ld_a_mde,
	dec_de,
	inc_e,
	dec_e,
	ld_e_XX,
	rra,
	jr_nz_DIS,
	ld_ix_XXXX,
	Z80ld_aXXXX_ix,
	inc_ix,
	inc_ixh,
	dec_ixh,
	ld_ixh_XX,
	daa,
	jr_z_DIS,
	add_ix_ix,
	Z80ld_ix_aXXXX,
	dec_ix,
	inc_ixl,
	dec_ixl,
	ld_ixl_XX,
	cpl,
	jr_nc_DIS,
	ld_sp_XXXX,
	ld_aXXXX_a,
	inc_sp,
	inc_mix,
	dec_mix,
	ld_mix_XX,
	scf,
	jr_c_DIS,
	add_ix_sp,
	ld_a_aXXXX,
	dec_sp,
	Z80inc_a,
	Z80dec_a,
	ld_a_XX,
	ccf,
	ld_b_b,
	ld_b_c,
	ld_b_d,
	ld_b_e,
	ld_b_ixh,
	ld_b_ixl,
	ld_b_ix,
	ld_b_a,
	ld_c_b,
	ld_c_c,
	ld_c_d,
	ld_c_e,
	ld_c_ixh,
	ld_c_ixl,
	ld_c_ix,
	ld_c_a,
	ld_d_b,
	ld_d_c,
	ld_d_d,
	ld_d_e,
	ld_d_ixh,
	ld_d_ixl,
	ld_d_ix,
	ld_d_a,
	ld_e_b,
	ld_e_c,
	ld_e_d,
	ld_e_e,
	ld_e_ixh,
	ld_e_ixl,
	ld_e_ix,
	ld_e_a,
	ld_ixh_b,
	ld_ixh_c,
	ld_ixh_d,
	ld_ixh_e,
	ld_ixh_ixh,
	ld_ixh_ixl,
	ld_h_ix,
	ld_ixh_a,
	ld_ixl_b,
	ld_ixl_c,
	ld_ixl_d,
	ld_ixl_e,
	ld_ixl_ixh,
	ld_ixl_ixl,
	ld_l_ix,
	ld_ixl_a,
	ld_ix_b,
	ld_ix_c,
	ld_ix_d,
	ld_ix_e,
	ld_ix_h,
	ld_ix_l,
	Z80halt,
	ld_ix_a,
	ld_a_b,
	ld_a_c,
	ld_a_d,
	ld_a_e,
	ld_a_ixh,
	ld_a_ixl,
	ld_a_ix,
	ld_a_a,
	add_a_b,
	add_a_c,
	add_a_d,
	add_a_e,
	add_a_ixh,
	add_a_ixl,
	add_a_ix,
	add_a_a,
	adc_a_b,
	adc_a_c,
	adc_a_d,
	adc_a_e,
	adc_a_ixh,
	adc_a_ixl,
	adc_a_ix,
	adc_a_a,
	sub_b,
	sub_c,
	sub_d,
	sub_e,
	sub_ixh,
	sub_ixl,
	sub_ix,
	sub_a,
	sbc_a_b,
	sbc_a_c,
	sbc_a_d,
	sbc_a_e,
	sbc_a_ixh,
	sbc_a_ixl,
	sbc_a_ix,
	sbc_a_a,
	and_b,
	and_c,
	and_d,
	and_e,
	and_ixh,
	and_ixl,
	and_ix,
	and_a,
	xor_b,
	xor_c,
	xor_d,
	xor_e,
	xor_ixh,
	xor_ixl,
	xor_ix,
	xor_a,
	or_b,
	or_c,
	or_d,
	or_e,
	or_ixh,
	or_ixl,
	or_ix,
	or_a,
	cp_b,
	cp_c,
	cp_d,
	cp_e,
	cp_ixh,
	cp_ixl,
	cp_ix,
	cp_a,
	ret_nz,
	pop_bc,
	jp_nz_XXXX,
	jp_XXXX,
	call_nz_XXXX,
	push_bc,
	add_a_XX,
	rst_0,
	ret_z,
	ret,
	jp_z_XXXX,
	IX_CB_Pre,
	call_z_XXXX,
	call_XXXX,
	adc_a_XX,
	rst_8,
	ret_nc,
	pop_de,
	jp_nc_XXXX,
	out_XX_a,
	call_nc_XXXX,
	push_de,
	sub_XX,
	rst_16,
	ret_c,
	exx,
	jp_c_XXXX,
	in_a_XX,
	call_c_XXXX,
	IX_Pre,
	sbc_a_XX,
	rst_24,
	ret_po,
	pop_ix,
	jp_po_XXXX,
	ex_msp_ix,
	call_po_XXXX,
	push_ix,
	and_XX,
	rst_32,
	ret_pe,
	jp_ix,
	jp_pe_XXXX,
	ex_de_ix,
	call_pe_XXXX,
	ED_Pre,
	xor_XX,
	rst_40,
	ret_p,
	pop_af,
	jp_p_XXXX,
	di,
	call_p_XXXX,
	push_af,
	or_XX,
	rst_48,
	ret_m,
	ld_sp_ix,
	jp_m_XXXX,
	ei,
	call_m_XXXX,
	IY_Pre,
	cp_XX,
	rst_56
};

struct
{
	void (*opcode)();
} Z80_IY[256]=
{
	nop,
	ld_bc_XXXX,
	ld_mbc_a,
	inc_bc,
	inc_b,
	dec_b,
	ld_b_XX,
	rlca,
	ex_af_af,
	add_iy_bc,
	ld_a_mbc,
	dec_bc,
	inc_c,
	dec_c,
	ld_c_XX,
	rrca,
	djnz_DIS,
	ld_de_XXXX,
	ld_mde_a,
	inc_de,
	inc_d,
	dec_d,
	ld_d_XX,
	rla,
	jr_DIS,
	add_iy_de,
	ld_a_mde,
	dec_de,
	inc_e,
	dec_e,
	ld_e_XX,
	rra,
	jr_nz_DIS,
	ld_iy_XXXX,
	Z80ld_aXXXX_iy,
	inc_iy,
	inc_iyh,
	dec_iyh,
	ld_iyh_XX,
	daa,
	jr_z_DIS,
	add_iy_iy,
	Z80ld_iy_aXXXX,
	dec_iy,
	inc_iyl,
	dec_iyl,
	ld_iyl_XX,
	cpl,
	jr_nc_DIS,
	ld_sp_XXXX,
	ld_aXXXX_a,
	inc_sp,
	inc_miy,
	dec_miy,
	ld_miy_XX,
	scf,
	jr_c_DIS,
	add_iy_sp,
	ld_a_aXXXX,
	dec_sp,
	Z80inc_a,
	Z80dec_a,
	ld_a_XX,
	ccf,
	ld_b_b,
	ld_b_c,
	ld_b_d,
	ld_b_e,
	ld_b_iyh,
	ld_b_iyl,
	ld_b_iy,
	ld_b_a,
	ld_c_b,
	ld_c_c,
	ld_c_d,
	ld_c_e,
	ld_c_iyh,
	ld_c_iyl,
	ld_c_iy,
	ld_c_a,
	ld_d_b,
	ld_d_c,
	ld_d_d,
	ld_d_e,
	ld_d_iyh,
	ld_d_iyl,
	ld_d_iy,
	ld_d_a,
	ld_e_b,
	ld_e_c,
	ld_e_d,
	ld_e_e,
	ld_e_iyh,
	ld_e_iyl,
	ld_e_iy,
	ld_e_a,
	ld_iyh_b,
	ld_iyh_c,
	ld_iyh_d,
	ld_iyh_e,
	ld_iyh_iyh,
	ld_iyh_iyl,
	ld_h_iy,
	ld_iyh_a,
	ld_iyl_b,
	ld_iyl_c,
	ld_iyl_d,
	ld_iyl_e,
	ld_iyl_iyh,
	ld_iyl_iyl,
	ld_l_iy,
	ld_iyl_a,
	ld_iy_b,
	ld_iy_c,
	ld_iy_d,
	ld_iy_e,
	ld_iy_h,
	ld_iy_l,
	Z80halt,
	ld_iy_a,
	ld_a_b,
	ld_a_c,
	ld_a_d,
	ld_a_e,
	ld_a_iyh,
	ld_a_iyl,
	ld_a_iy,
	ld_a_a,
	add_a_b,
	add_a_c,
	add_a_d,
	add_a_e,
	add_a_iyh,
	add_a_iyl,
	add_a_iy,
	add_a_a,
	adc_a_b,
	adc_a_c,
	adc_a_d,
	adc_a_e,
	adc_a_iyh,
	adc_a_iyl,
	adc_a_iy,
	adc_a_a,
	sub_b,
	sub_c,
	sub_d,
	sub_e,
	sub_iyh,
	sub_iyl,
	sub_iy,
	sub_a,
	sbc_a_b,
	sbc_a_c,
	sbc_a_d,
	sbc_a_e,
	sbc_a_iyh,
	sbc_a_iyl,
	sbc_a_iy,
	sbc_a_a,
	and_b,
	and_c,
	and_d,
	and_e,
	and_iyh,
	and_iyl,
	and_iy,
	and_a,
	xor_b,
	xor_c,
	xor_d,
	xor_e,
	xor_iyh,
	xor_iyl,
	xor_iy,
	xor_a,
	or_b,
	or_c,
	or_d,
	or_e,
	or_iyh,
	or_iyl,
	or_iy,
	or_a,
	cp_b,
	cp_c,
	cp_d,
	cp_e,
	cp_iyh,
	cp_iyl,
	cp_iy,
	cp_a,
	ret_nz,
	pop_bc,
	jp_nz_XXXX,
	jp_XXXX,
	call_nz_XXXX,
	push_bc,
	add_a_XX,
	rst_0,
	ret_z,
	ret,
	jp_z_XXXX,
	IY_CB_Pre,
	call_z_XXXX,
	call_XXXX,
	adc_a_XX,
	rst_8,
	ret_nc,
	pop_de,
	jp_nc_XXXX,
	out_XX_a,
	call_nc_XXXX,
	push_de,
	sub_XX,
	rst_16,
	ret_c,
	exx,
	jp_c_XXXX,
	in_a_XX,
	call_c_XXXX,
	IX_Pre,
	sbc_a_XX,
	rst_24,
	ret_po,
	pop_iy,
	jp_po_XXXX,
	ex_msp_iy,
	call_po_XXXX,
	push_iy,
	and_XX,
	rst_32,
	ret_pe,
	jp_iy,
	jp_pe_XXXX,
	ex_de_iy,
	call_pe_XXXX,
	ED_Pre,
	xor_XX,
	rst_40,
	ret_p,
	pop_af,
	jp_p_XXXX,
	di,
	call_p_XXXX,
	push_af,
	or_XX,
	rst_48,
	ret_m,
	ld_sp_iy,
	jp_m_XXXX,
	ei,
	call_m_XXXX,
	IY_Pre,
	cp_XX,
	rst_56
};
#endif

#ifndef Z80_OBJ
void IX_Pre(void)
{
	register UC byte;

	INC_R_REG;
	byte=speekb(pc.W);
	pc.W++;
	Z80_IX[byte].opcode();
}

void IY_Pre(void)
{
	register UC byte;

	INC_R_REG;
	byte=speekb(pc.W);
	pc.W++;
	Z80_IY[byte].opcode();
}

void ED_Pre(void)
{
	register UC byte;

	INC_R_REG;
	byte=speekb(pc.W);
	pc.W++;
	ED[byte].opcode();
}

void IX_CB_Pre(void)
{
	register UC byte;

	CBdis=speekb(pc.W);
	pc.W++;
	byte=speekb(pc.W);
	pc.W++;
	CB_IX[byte].opcode();
}

void IY_CB_Pre(void)
{
	register UC byte;

	CBdis=speekb(pc.W);
	pc.W++;
	byte=speekb(pc.W);
	pc.W++;
	CB_IY[byte].opcode();
}

void CB_Pre(void)
{
	register UC byte;

	INC_R_REG;
	byte=speekb(pc.W);
	pc.W++;
	CB[byte].opcode();
}

void clean_regs(void)
{
	UC x;

	for(x=0;x<16;x++)
	{
		PSGOut(x,255);
	}
	iff1=iff2=bit7_r=0;
	hl.W=de.W=bc.W=0;
	hl2.W=de2.W=de2.W=0;
	ix.W=iy.W=0;
	im=1;
	ir.W=sp.W=pc.W=mf128_on=0;
	af.W=af2.W=halt=last_fffd=0;
	vline=t_state=mem_48_lock=0;
	flash_count=16;
}
#endif
