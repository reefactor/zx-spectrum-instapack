/** fMSX: portable MSX emulator ******************************/
/**                                                         **/
/**                         AY8910.c                        **/
/**                                                         **/
/** This file contains emulation of the General Instruments **/
/** AY8910 Programmable Sound generator.                    **/
/**                                                         **/
/** Copyright (C) Alex Krasivsky  1994                      **/
/**               Marat Fayzullin 1995                      **/
/**     You are not allowed to distribute this software     **/
/**     commercially. Please, notify me, if you make any    **/
/**     changes to this file.                               **/
/*************************************************************/

extern UC UseAdlib;
extern UC PSG_open;
extern UC white_noise;
extern FILE *p_handle;

#ifdef OLD_NOISE
void PutAdlib(register UC R,register UC V);
void MuteSound(void);
UC InitAdlib(void);
void TrashAdlib(void);
void PlayA(void);
void PlayB(void);
void PlayC(void);
void ResumeSound(void);
void PSGOut(register UC R,register UC V);
#endif
