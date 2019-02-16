/******************************************/
/**                                      **/
/**         X128_VAR Portable File       **/
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

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXPATH 200

#define DONT_QUIT 0
#define QUIT_HELP 1
#define QUIT_NMI 2
#define QUIT_RESET 3
#define QUIT_JOY  4
#define QUIT_LOAD 5
#define QUIT_SAVE 6
#define QUIT_TAP  7
#define QUIT_VOC  8
#define QUIT_COMPLETELY 10
#define QUIT_SOUND 11

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

#define P254 0,254
#define P32765 127,253

/* pair and quadruple defined in x128_end.c */

pair af,bc,de,hl,ir,ix,iy,pc,sp,af2,bc2,de2,hl2;
UC bit7_r;
char *error_str;

UC im=1, int_50=0;
UC iff1, iff2, halt, flash_status, quit=0;
UC hmode=0;
UC border=7;

UC joy_type=0;
UC In31=0;
UC curs_caps=1;

unsigned long ul_border4[8]=
{0x00000000,0x01010101,0x02020202,0x03030303,
 0x04040404,0x05050505,0x06060606,0x07070707};

UC flash_count=16;
word vline=0;
UC ram_state=16, mf128_on=0, mode_128=0, keyboard_issue=191;
word t_state=0;
UC t_states_per_line=228;
word s_lines=311;
UC ULA_delay, ret_to_help, skip_reset=0;
UC frame_skip=1;
word slow_down=0;
word mwtemp;

UC mem_48_lock, model_48, adlib_present=0, all_sound_on=1, old_254;
UC pending_254;

pair ptemp;
quadruple qtemp;

UC PSG[16];
UC last_fffd;

FILE *handle, *t_handle, *d_handle, *p_handle;

UC VOC_file_in_open, VOC_file_out_open=0, VOC_paused=1;
char drives[27][4];

int global_index=0;
int sna_index, tap_index, dat_index=0;

UC r1_1386, r1_1387, r2_1386, r2_1387;

char the_path[MAXPATH], the_sna_path[MAXPATH];
char the_tap_path[MAXPATH], the_dat_path[MAXPATH];
char prev_dir[MAXPATH], the_temp_file[MAXPATH];
char the_psg_path[MAXPATH];

UC calc_checksum, TAP_file_open=0;

char *ID_String="SLT";
long DAT_offset[256];
long DAT_length[256];
UC SLT=0;
long SLT_inst_len, SLT_inst_offset=0;
long SLT_lscr_len, SLT_lscr_offset=0;
long SLT_scan_pic_len=0;
long SLT_pokes_len, SLT_pokes_offset=0;

word vga_x_y[192]; /* the list of VGA line addresses (indented) in X mode */

#ifdef SCALE2
unsigned long vga_h_nib0[16][128];
unsigned long vga_h_nib1[16][128];
#else
unsigned long vga_h_nib[16][128];
#endif

UC reverse_attr[128];

UC fore_attrib[256];
UC back_attrib[256];
UC parity[256];    /* All the parity for all possibilities (0 or 4) */
word spline[192];  /* spectrum offset to the start of a line */

UC  ormask[8]={1,2,4,8,16,32,64,128};

UC   red[16]={0, 0,55,57, 0, 0,52,50,0, 0,60,63, 0, 0,63,63};
UC green[16]={0, 0, 0, 0,53,53,52,50,0, 0, 0, 0,60,63,63,63};
UC  blue[16]={0,40, 0,45, 0,53, 0,50,0,43, 0,55, 0,63, 0,63};

/* Z80 Table Arrays */
/*UC rlca_f[2][256];
UC rlca_a[2][256];
UC rrca_f[2][256];
UC rrca_a[2][256];*/

UC rlca_f[256];
UC rlca_a[256];
UC rrca_f[256];
UC rrca_a[256];

/*UC rla_f[2][256];
UC rla_a[2][256];
UC rra_f[2][256];
UC rra_a[2][256];*/

UC rla_f0[256];
/*UC rla_f1[256];*/
UC rla_a0[256];
UC rla_a1[256];
UC rra_f0[256];
/*UC rra_f1[256];*/
UC rra_a0[256];
UC rra_a1[256];

UC daa_f[8][256];
UC daa_a[8][256];

UC inc_f[256];
/*UC inc_a[256];*/
UC dec_f[256];
/*UC dec_a[256];*/

/*UC rlcr_f[2][256];
UC rlcr_a[2][256];
UC rrcr_f[2][256];
UC rrcr_a[2][256];*/

UC rlcr_f[256];
UC rlcr_a[256];
UC rrcr_f[256];
UC rrcr_a[256];

/*UC rlr_f[2][256];
UC rlr_a[2][256];
UC rrr_f[2][256];
UC rrr_a[2][256];*/

UC rlr_f0[256];
UC rlr_f1[256];
UC rlr_a0[256];
UC rlr_a1[256];
UC rrr_f0[256];
UC rrr_f1[256];
UC rrr_a0[256];
UC rrr_a1[256];

/*UC sla_f[2][256];
UC sla_a[2][256];
UC sra_f[2][256];
UC sra_a[2][256];
UC sll_f[2][256];
UC sll_a[2][256];
UC srl_f[2][256];
UC srl_a[2][256];*/

UC sla_f[256];
UC sla_a[256];
UC sra_f[256];
UC sra_a[256];
UC sll_f[256];
UC sll_a[256];
UC srl_f[256];
UC srl_a[256];

UC bit_f0[256];
/*UC bit_a0[256];*/
UC bit_f1[256];
/*UC bit_a1[256];*/
UC bit_f2[256];
/*UC bit_a2[256];*/
UC bit_f3[256];
/*UC bit_a3[256];*/
UC bit_f4[256];
/*UC bit_a4[256];*/
UC bit_f5[256];
/*UC bit_a5[256];*/
UC bit_f6[256];
/*UC bit_a6[256];*/
UC bit_f7[256];
/*UC bit_a7[256];*/

UC ora_table[256];
UC xora_table[256];
UC anda_table[256];
UC in_table[256];
UC add8_table[256];
UC sub8_table[256];
UC cpsub8_table[256];

/* defs for keyboard */

#define StoB 0 /* Space to B */
#define EtoH 1 /* Enter to H */
#define PtoY 2
#define N0toN6 3 /* 0 to 6 */
#define N1toN5 4 /* 1 to 5 */
#define QtoT 5
#define AtoG 6
#define CtoV 7 /* Caps shift to V */

#define off0 1
#define on0  254
#define off1 2
#define on1  253
#define off2 4
#define on2  251
#define off3 8
#define on3  247
#define off4 16
#define on4  239

UC *RAM[8]={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
UC *ROM[4]={NULL,NULL,NULL,NULL};
UC *SRAMR[8]={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};
UC *SRAMW[8]={NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL};

UC *DUMMY_MEM=NULL;
UC *ROM48=NULL;
UC *SP_SCREEN=NULL;
UC *old_screen=NULL;

UC CONTENDED[8];

UC *BUFFER=NULL;
#ifndef NO_BUFFER
UC *XBuf=NULL;
#endif
UC *FNAME=NULL;

UC SKey[8]; /* The 8 keyboard bytes for the Spectrum */
