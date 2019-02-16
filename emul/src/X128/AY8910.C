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
/** A few minor modifications by James McKay, to get it to  **/
/** go a bit better, and to work in x128 and under Linux.   **/
/** Or, to be more precise, to get it half working.         **/
/*************************************************************/
#define AY8910_OBJ

#include<stdio.h>
#include "x128_end.c"

#ifdef MSDOS_SYSTEM

#include <dos.h>

#ifndef __BORLANDC__
#include<i86.h>
#endif

#else

#define _disable()
#define _enable()

#endif

#include "ay8910.h"

extern UC PSG[16];
extern UC adlib_present;

UC VolA=0, VolB=0, VolC=0;
UC white_noise=1;
UC UseAdlib=1;
UC PSG_open=0;
UC Volumes[16]=
{
  0xFF,0x3F,0x3F,0x3F,0x2C,0x26,0x22,0x1D,
  0x16,0x12,0x0C,0x0A,0x07,0x05,0x02,0x00
};

#ifdef OLD_NOISE
/*** PutAdlib ****************************************/
/*** Write value V into Adlib register R.          ***/
/*****************************************************/
void PutAdlib(register UC R,register UC V)
{
  register UC J;

  outp(0x388,R);for(J=0;J<6;J++) inp(0x388);
  outp(0x389,V);for(J=0;J<35;J++) inp(0x388);
}

/*** MuteSound ***************************************/
/*** Turn all sound off.                           ***/
/*****************************************************/
void MuteSound(void)
{
  UC OldPSG7=255;

  OldPSG7=PSG[7];
  PSG[7]=255;
  PSGOut(7,255);
  PSG[7]=OldPSG7;
}

/*** InitAdlib ***************************************/
/*** Return 0 if Adlib is not found, otherwise     ***/
/*** initialize it and return 1.                   ***/
/*****************************************************/
UC InitAdlib(void)
{
  UC I,A1,A2;

  /* If Adlib is not to be used, don't initialize */
  if(!UseAdlib) return(0);

  /********* Detect if Adlib is present. *************/
  PutAdlib(0x01,0x00);    /* Delete test register    */
  PutAdlib(0x04,0x60);    /* Mask and disable timers */
  PutAdlib(0x04,0x80);    /* Reset timers            */
  A1=inp(0x388)&0xE0;     /* Read status             */
  PutAdlib(0x02,0xFF);    /* Set Timer1 to 0xFF      */
  PutAdlib(0x04,0x21);    /* Unmask and start Timer1 */
  for(I=0;I<0xC8;I++) inp(0x388);  /* Wait 80us      */
  A2=inp(0x388)&0xE0;     /* Read status             */
  PutAdlib(0x04,0x60);    /* Mask and disable timers */
  PutAdlib(0x04,0x80);    /* Reset timers            */
  if((A2!=0xC0)||A1) { UseAdlib=0;return(0); }
  /***************************************************/

  /* Allow the FM chips to control WaveForm */
  for(I=0;I<255;I++) PutAdlib(I,0x00);
  PutAdlib(0x01,0x20);
  PutAdlib(0xBD,0x20|8);

  /* Turn sound off */
  MuteSound();

  for(I=0;I<3;I++)
  {
    PutAdlib(0x20+I,0x01);
    PutAdlib(0x23+I,0x01);
    PutAdlib(0x40+I,0x18);
    PutAdlib(0x43+I,0x3F);
    PutAdlib(0x60+I,0xF0);
    PutAdlib(0x63+I,0xF0);
    PutAdlib(0x80+I,0x14);
    PutAdlib(0x83+I,0x13);
    PutAdlib(0xE0+I,0x02);
    PutAdlib(0xE3+I,0x00);
    PutAdlib(0xC0+I,0x0A);
    PutAdlib(0xB0+I,0x00);
  }
  PutAdlib(0x34,0x21);
  PutAdlib(0x54,0x3F);
  PutAdlib(0x74,0x99);
  PutAdlib(0x94,0x00);
  PutAdlib(0xF4,0x00);
  PutAdlib(0xBD,0x28);

  return(1);
}

/*** TrashAdlib **************************************/
/*** If Adlib was used then shut it down.          ***/
/*****************************************************/
void TrashAdlib(void)
{
  if(adlib_present)
  {
    MuteSound();         /* Turn off the sound      */
    PutAdlib(0x04,0x60); /* Mask and disable timers */
    PutAdlib(0x04,0x80); /* Reset timers            */
  }
}

/*** PlayA *******************************************/
/*** Play sound via PSG channel A. Called when the ***/
/*** registers related to this channel are changed ***/
/*****************************************************/
void PlayA(void)
{
  register UC J;
  register word Lath;
  register long Tune;

  if(!(PSG[7]&0x01))
  {
	PutAdlib(0x43,Volumes[VolA]);

	Lath=((word)PSG[1]<<8)|PSG[0];
	Lath&=4095; /* Only 12 bits required */
	Tune=Lath? 2345678L/Lath:1;

	for(J=0;Tune>0x0400;Tune>>=1) J++;

	PutAdlib(0xA0,Tune&0xFF);
	PutAdlib(0xB0,((Tune>>8)&0x03)|(J<<2)|0x20);
  }
  else
  {
	PutAdlib(0x43,Volumes[0]);
  }
}

/*** PlayB *******************************************/
/*** Play sound via PSG channel B. Called when the ***/
/*** registers related to this channel are changed ***/
/*****************************************************/
void PlayB(void)
{
  register UC J;
  register word Lath;
  register long Tune;

  if(!(PSG[7]&0x02))
  {
	PutAdlib(0x44,Volumes[VolB]);

	Lath=((word)PSG[3]<<8)|PSG[2];
	Lath&=4095;
	Tune=Lath? 2345678L/Lath:1;

	for(J=0;Tune>0x0400;Tune>>=1) J++;

	PutAdlib(0xA1,Tune&0xFF);
	PutAdlib(0xB1,((Tune>>8)&0x03)|(J<<2)|0x20);
  }
  else
  {
	PutAdlib(0x44,Volumes[0]);
  }
}

/*** PlayC *******************************************/
/*** Play sound via PSG channel C. Called when the ***/
/*** registers related to this channel are changed ***/
/*****************************************************/
void PlayC(void)
{
  register UC J;
  register word Lath;
  register long Tune;

  if(!(PSG[7]&0x04))
  {
	PutAdlib(0x45,Volumes[VolC]);

	Lath=((word)PSG[5]<<8)|PSG[4];
	Lath&=4095;
	Tune=Lath? 2345678L/Lath:1;

	for(J=0;Tune>0x0400;Tune>>=1) J++;

	PutAdlib(0xA2,Tune&0xFF);
	PutAdlib(0xB2,((Tune>>8)&0x03)|(J<<2)|0x20);
  }
  else
  {
	PutAdlib(0x45,Volumes[0]);
  }
}

void Set_Tone(register UC R)
{
	register UC J;
	register word Lath;
	register long Tune;

	Lath=((word)PSG[(R<<1)+1]<<8)|PSG[R<<1];
	Lath&=4095; /* Only 12 bits required */
	Tune=Lath? 2345678L/Lath:1;

	for(J=0;Tune>0x0400;Tune>>=1) J++;
	switch(R)
	{
		case 0:
		if(!(PSG[7]&1))
		{
			PutAdlib(0xA0+R,Tune&0xFF);
			PutAdlib(0xB0+R,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		if(!(PSG[7]&8))
		{
			PutAdlib(0xA7,Tune&0xFF);
			PutAdlib(0xB7,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		break;
		case 1:
		if(!(PSG[7]&2))
		{
			PutAdlib(0xA0+R,Tune&0xFF);
			PutAdlib(0xB0+R,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		if(!(PSG[7]&16))
		{
			PutAdlib(0xA7,Tune&0xFF);
			PutAdlib(0xB7,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		break;
		case 2:
		if(!(PSG[7]&4))
		{
			PutAdlib(0xA0+R,Tune&0xFF);
			PutAdlib(0xB0+R,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		if(!(PSG[7]&32))
		{
			PutAdlib(0xA7,Tune&0xFF);
			PutAdlib(0xB7,((Tune>>8)&0x03)|(J<<2)|0x20);
		}
		break;
	}
#ifdef IGNORE_BANANA
	switch(((PSG[7]>>R)&9))
	{
		case 9: /* Neither */
			break;
		case 8: /* Just Tone */
			PutAdlib(0xA0+R,Tune&0xFF);
			PutAdlib(0xB0+R,((Tune>>8)&0x03)|(J<<2)|0x20);
			break;
		case 1: /* Just Noise */
			PutAdlib(0xA7,Tune&0xFF);
			PutAdlib(0xB7,((Tune>>8)&0x03)|(J<<2)|0x20);
			break;
		case 0: /* Both */
			PutAdlib(0xA0+R,Tune&0xFF);
			PutAdlib(0xB0+R,((Tune>>8)&0x03)|(J<<2)|0x20);
			PutAdlib(0xA7,Tune&0xFF);
			PutAdlib(0xB7,((Tune>>8)&0x03)|(J<<2)|0x20);
			break;
	}
#endif
}

void Set_Vol(register UC R)
{
	register UC V;

	V=PSG[R+8];
	if(V&0x10) V=12;

	if((PSG[7]&(1<<R)))
	{
		PutAdlib(0x43+R,Volumes[0]);
	}
	else
	{
		PutAdlib(0x43+R,Volumes[V]);
	}
	if((PSG[7]&0x38)==0x38)
	{
		PutAdlib(0x54,Volumes[0]);
	}
	else
	{
		if(white_noise) PutAdlib(0x54,Volumes[V]);
	}
}


/*** ResumeSound *************************************/
/*** Resume sound after MuteSound.                 ***/
/*****************************************************/
void ResumeSound(void)
{
    PSGOut(7,PSG[7]);
}

/*** PSGOut ******************************************/
/*** Write value V into AY8910 register R.         ***/
/*** Appropriate sound routines are called as it   ***/
/*** is done.                                      ***/
/*****************************************************/

#ifdef USING_NEW_PSGOUT
void PSGOut(register UC R,register UC V)
{
  UC R2, V2;

  PSG[R]=V;
  if(PSG_open)
  {
	R2=R;
	fwrite(&R2,1,1,p_handle);
	V2=V;
	fwrite(&V2,1,1,p_handle);
  }
  if(UseAdlib)
  {
    _disable();
    switch(R)
    {
      case 7: PlayA();PlayB();PlayC();PlayNoise();break;
      case 6:
	PlayNoise();break;
      case 11: case 12:
	break; /* No envelope support yet */
      case 0: case 1: case 8:
	PlayA();break;
      case 8:
	if(PSG[8]&0x10) VolA=15; else VolA=PSG[8]&0x0F;
	PlayA();break;
      case 2: case 3: case 9:
	PlayB();break;
      case 4: case 5: case 10:
	PlayC();break;
    }
    _enable();
  }
}
#endif

void PSGOut(register UC R,register UC V)
{
  UC R2, V2;

  PSG[R]=V;
  if(PSG_open)
  {
	R2=R;
	fwrite(&R2,1,1,p_handle);
	V2=V;
	fwrite(&V2,1,1,p_handle);
  }
  if(UseAdlib)
  {
    _disable();
    switch(R)
    {
	case 0:
	case 1:
		Set_Tone(0);break;
	case 2:
	case 3:
		Set_Tone(1);break;
	case 4:
	case 5:
		Set_Tone(2);break;
	case 6: break;
	case 7: Set_Vol(0);Set_Vol(1);Set_Vol(2);break;
	case 8: Set_Vol(0);break;
	case 9: Set_Vol(1);break;
	case 10:Set_Vol(2);break;
    }
    _enable();
  }
}

#endif
