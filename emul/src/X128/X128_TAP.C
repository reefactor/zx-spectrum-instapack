/******************************************/
/**                                      **/
/**         X128_TAP Portable File       **/
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

void strip_file(char *stringy); /* In X128_FSL.C */

void open_z80table(void)
{
	word value, value2, index;
	UC buffer[512], tempc1, tempc2;
	char filename[MAXPATH];

   strcpy(filename,"z80.tbl");
   printf("Filename:%s\n",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("\nFile %s not present\n",filename);
      quit=QUIT_COMPLETELY;
   }
   fread(&buffer,1,24,handle); /* Skip TAP header */

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			rlca_f[value]=buffer[value*2];
			rlca_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			rrca_f[value]=buffer[value*2];
			rrca_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	for(value=0;value<256;value++)
	{
		if(!index)
		{
			rla_f0[value]=buffer[value*2];
			rla_a0[value]=buffer[(value*2)+1];
		}
		else
		{
			/*rla_f1[value]=buffer[value*2];*/
			rla_a1[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	for(value=0;value<256;value++)
	{
		if(!index)
		{
			rra_f0[value]=buffer[value*2];
			rra_a0[value]=buffer[(value*2)+1];
		}
		else
		{
			/*rra_f1[value]=buffer[value*2];*/
			rra_a1[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<8;index++)
   {
	fread(&buffer,1,512,handle);
	for(value=0;value<256;value++)
	{
		daa_f[index][value]=buffer[value*2];
		daa_a[index][value]=buffer[(value*2)+1];
	}
   }

   fread(&buffer,1,512,handle);

   for(value=0;value<256;value++)
   {
	inc_f[value]=buffer[value*2];
	/*inc_a[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);

   for(value=0;value<256;value++)
   {
	dec_f[value]=buffer[value*2];
	/*dec_a[value]=buffer[(value*2)+1];*/
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			rlcr_f[value]=buffer[value*2];
			rlcr_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			rrcr_f[value]=buffer[value*2];
			rrcr_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	for(value=0;value<256;value++)
	{
		if(!index)
		{
			rlr_f0[value]=buffer[value*2];
			rlr_a0[value]=buffer[(value*2)+1];
		}
		else
		{
			rlr_f1[value]=buffer[value*2];
			rlr_a1[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	for(value=0;value<256;value++)
	{
		if(!index)
		{
			rrr_f0[value]=buffer[value*2];
			rrr_a0[value]=buffer[(value*2)+1];
		}
		else
		{
			rrr_f1[value]=buffer[value*2];
			rrr_a1[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			sla_f[value]=buffer[value*2];
			sla_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			sra_f[value]=buffer[value*2];
			sra_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			sll_f[value]=buffer[value*2];
			sll_a[value]=buffer[(value*2)+1];
		}
	}
   }

   for(index=0;index<2;index++)
   {
	fread(&buffer,1,512,handle);
	if(!index)
	{
		for(value=0;value<256;value++)
		{
			srl_f[value]=buffer[value*2];
			srl_a[value]=buffer[(value*2)+1];
		}
	}
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f0[value]=buffer[value*2];
	/*bit_a0[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f1[value]=buffer[value*2];
	/*bit_a1[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f2[value]=buffer[value*2];
	/*bit_a2[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f3[value]=buffer[value*2];
	/*bit_a3[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f4[value]=buffer[value*2];
	/*bit_a4[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f5[value]=buffer[value*2];
	/*bit_a5[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f6[value]=buffer[value*2];
	/*bit_a6[value]=buffer[(value*2)+1];*/
   }

   fread(&buffer,1,512,handle);
   for(value=0;value<256;value++)
   {
	bit_f7[value]=buffer[value*2];
	/*bit_a7[value]=buffer[(value*2)+1];*/
   }

  fclose(handle);
  for(value=0;value<256;value++)
  {
	ora_table[value]=(value&168)|parity[value];
	ora_table[0]|=64;
	xora_table[value]=(value&168)|parity[value];
	xora_table[0]|=64;
	anda_table[value]=16|(value&168)|parity[value];
	anda_table[0]|=64;
	in_table[value]=(value&168)|(parity[value]);
	in_table[0]|=64; /* Don't forget to keep old C flag */
  }
  for(value=0;value<256;value++)
  {
	add8_table[value]=(value&168)|(value?0:64); /* Just HVC to do! */
	sub8_table[value]=(value&168)|(value?0:64)|2;
	cpsub8_table[value]=(value&128)|(value?0:64)|2; /* 5 bits left.. */
  }
}

void open_rom48(void)
{
	char filename[MAXPATH];

   strcpy(filename,"48.rom");
   printf("Filename:%s\n",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("\nFile %s not present\n",filename);
      quit=QUIT_COMPLETELY;
      return;
   }
   fread(ROM[2],1,16384,handle);
   fclose(handle);
}

void open_rom128_B(void)
{
	char filename[MAXPATH];

   strcpy(filename,"zx128_1.rom");
   printf("Filename:%s\n",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("\nFile %s not present\n",filename);
      quit=QUIT_COMPLETELY;
      return;
   }
   fread(ROM[1],1,16384,handle);
   fclose(handle);
}

void open_rom128_E(void)
{
	char filename[MAXPATH];

   strcpy(filename,"zx128_0.rom");
   printf("Filename:%s\n",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("\nFile %s not present\n",filename);
      quit=QUIT_COMPLETELY;
      return;
   }
   fread(ROM[0],1,16384,handle);
   fclose(handle);
}

void open_romMF128(void)
{
	char filename[MAXPATH];

   strcpy(filename,"mf128.rom");
   printf("Filename:%s\n",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("\nFile %s not present\n",filename);
      return;
   }
   fread(ROM[3],1,8192,handle);
   memset(ROM[3]+8192,0,8192);
   fclose(handle);
}

void build_DAT_path(char *filename)
{
	word pos, temp;

	pos=strlen(filename);
	pos--;
	if(filename[pos-3]=='.')
	{
		temp=filename[pos-3];
		filename[pos-3]='\0';
		strcpy(the_dat_path,filename);
		filename[pos-3]=temp;
	}
	else
	{
#ifndef NON_WINDOWS
		printf("Warning: Could not build DAT path.\n");
#endif
	}
}

UC open_sna(void)
{
	char filename[MAXPATH];

/*#ifdef NON_WINDOWS
	release_screen();
#endif
	release_keyboard();
	printf("Enter SNA to load : ");
	scanf("%s",filename);
	if (!(handle = fopen(the_path,"rb")))
	{
		perror("Error:");
		printf("File %s not present\n",filename);
#ifdef NON_WINDOWS
		init_screen();
#endif
		init_keyboard();
		return 1;
	   }*/
   if(!(handle = fopen(the_path,"rb")))
   {
	perror("Error:");
	printf("File %s not present\n",filename);
#ifdef NON_WINDOWS
	init_screen();
#endif
	init_keyboard();
	return 1;
   }
   SLT=0;
   clean_regs();
   build_DAT_path(the_path);
   fread(&ir.B.h,1,1,handle);
   fread(&hl2.B.l,1,1,handle);
   fread(&hl2.B.h,1,1,handle);
   fread(&de2.B.l,1,1,handle);
   fread(&de2.B.h,1,1,handle);
   fread(&bc2.B.l,1,1,handle);
   fread(&bc2.B.h,1,1,handle);
   fread(&af2.B.l,1,1,handle);
   fread(&af2.B.h,1,1,handle);
   fread(&hl.B.l,1,1,handle);
   fread(&hl.B.h,1,1,handle);
   fread(&de.B.l,1,1,handle);
   fread(&de.B.h,1,1,handle);
   fread(&bc.B.l,1,1,handle);
   fread(&bc.B.h,1,1,handle);
   fread(&iy.B.l,1,1,handle);
   fread(&iy.B.h,1,1,handle);
   fread(&ix.B.l,1,1,handle);
   fread(&ix.B.h,1,1,handle);
   fread(&iff2,1,1,handle);
   if(iff2>0) iff2=1;
   iff1=iff2; /* Because reti doesn't do this any more */
   fread(&ir.B.l,1,1,handle); /* R reg */
   bit7_r=ir.B.l&128;
   ir.B.l&=127;
   fread(&af.B.l,1,1,handle);
   fread(&af.B.h,1,1,handle);
   fread(&sp.B.l,1,1,handle);
   fread(&sp.B.h,1,1,handle);
   fread(&im,1,1,handle);
   fread(&border,1,1,handle); /* Border */
   fread(RAM[5],16384,1,handle); /* 16384 */
   fread(RAM[2],16384,1,handle); /* 32768 */
   fread(RAM[0],16384,1,handle); /* 49152 */
   out(P254,border);
   mode(48);
   fclose(handle);
/*#ifdef NON_WINDOWS
	init_screen();
	init_keyboard();
#endif*/
   return 0; /* Success */
}

UC read_48k(void) /* For stinky old V1 Z80 files. */
{
	word block_len, base, addr, count, wx;
	UC page_num, byte, byte2, poker, loopr, x;

	block_len=49152;
	for(wx=0;wx<49152;wx++) {BUFFER[wx]=0;}
	fread(BUFFER,1,block_len,handle);
	out(P32765,48);
	addr=16384;

	count=0;
	base=addr;
	do{
		byte=BUFFER[count];
		count++;
		if(byte==237) /* is ED... */
		{
			byte2=BUFFER[count];
			count++;
			if (byte2==237) /* is ED ED code */
			{
				loopr=BUFFER[count];
				count++;
				poker=BUFFER[count];
				count++;
				for(x=0;x<loopr;x++)
				{
					spokeb(base,poker);
					base++;
				}
			}
			else
			{
				spokeb(base,byte); /* is ED ?? */
				base++;
				spokeb(base,byte2);
				base++;
			}
		}
		else
		{
			spokeb(base,byte); /* not ED... */
			base++;
		}
		if (((UC)BUFFER[count]==0)&&((UC)BUFFER[count+1]==237)
		&&((UC)BUFFER[count+2]==237)&&((UC)BUFFER[count+3]==0))
		{
			return 0; /* Success! (Found END marker) */
		}
		if((base>0)&&(base<16384))
		{
#ifndef NON_WINDOWS
			printf("V1 (48K BLOCK) DECOMP ERROR\n");
#endif
			return 1; /* fail */
		}
	} while (count<block_len);
	return 0;  /* Success! */
}

UC read_16k(void)
{
	word base, addr, count, wx;
	UC page_num, byte, byte2, poker, loopr, x;
	pair block_len;

	fread(&block_len.B.l,1,1,handle);
	fread(&block_len.B.h,1,1,handle);
	fread(&page_num,1,1,handle);
	for(wx=0;wx<16384;wx++) {BUFFER[wx]=0;}
	fread(BUFFER,1,block_len.W,handle);

	if(mode_128)
	{
		mem_48_lock=0;
		out(P32765,page_num-3);addr=49152;
	}
	else
	{
		out(P32765,48);
		switch(page_num)
		{
			case (4) : {addr=32768;break;}
			case (5) : {addr=49152;break;}
			case (8) : {addr=16384;break;}
			default  : {addr=49152;break;}
		}
	}
	count=0;
	base=addr;
	do{
		byte=BUFFER[count];
		count++;
		if(byte==237) /* is ED... */
		{
			byte2=BUFFER[count];
			count++;
			if (byte2==237) /* is ED ED code */
			{
				loopr=BUFFER[count];
				count++;
				poker=BUFFER[count];
				count++;
				for(x=0;x<loopr;x++)
				{
					spokeb(base,poker);
					base++;
				}
			}
			else
			{
				spokeb(base,byte); /* is ED ?? */
				base++;
				spokeb(base,byte2);
				base++;
			}
		}
		else
		{
			spokeb(base,byte); /* not ED... */
			base++;
		}
		if((base-addr)>16384)
		{
#ifndef NON_WINDOWS
			printf("V2/V3 (16K BLOCK) DECOMP ERROR\n");
#endif
			return 1; /* fail */
		}
	} while (count<block_len.W);
	return 0;  /* Success! */
}

void skip_16k(void)
{
	word wx;
	UC page_num;
	pair block_len;

	fread(&block_len.B.l,1,1,handle);
	fread(&block_len.B.h,1,1,handle);
	fread(&page_num,1,1,handle);
	for(wx=0;wx<16384;wx++) {BUFFER[wx]=0;}
	fread(BUFFER,1,block_len.W,handle);
}

UC z80_v3(word head_block)
{
	pair ptemp;
	UC btemp, flag, x;

   if(head_block==54)
   {
#ifndef NON_WINDOWS
	printf("This is a V3 :");
#endif
	fread(&pc.B.l,1,1,handle);
	fread(&pc.B.h,1,1,handle);
	fread(&hmode,1,1,handle);
	/* 0=48K,1=+IF1,2=+MGT,3=Sam,4=128K,5=+IF1,6=+MGT */
	fread(&ram_state,1,1,handle); /* ram page or sam ram rubbish */
	fread(&btemp,1,1,handle); /* contains 255 if IF1 paged (ignored) */
	fread(&flag,1,1,handle); /* bit 0=1 if R reg on,bit 1=1 if Ldir on */
	fread(&last_fffd,1,1,handle); /* last out to FFFD */
	fread(&PSG,1,16,handle); /* soundchip regs */
	for(x=0;x<16;x++) PSGOut(x,PSG[x]);
	for(x=0;x<31;x++)
	{
		fread(&btemp,1,1,handle); /* Extra V3 stuff ignored */
	}
	mode_128=0;
	switch(hmode)
	{
		case (0): /* 48K */
		{
			for (x=0;x<3;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			mode(48);
			break;
		}
		case (1): /* 48K + ignored IF1 */
		{
			for (x=0;x<3;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			mode(48);
			break;
		}
		case (2): /* 48K + ignored MGT */
		{
			for (x=0;x<3;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			mode(48);
			break;
		}
		case (3): /* Sam Ram Ignored */
		{
#ifndef NON_WINDOWS
			printf(" SAMRAM : ");
#endif
			for (x=0;x<2;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			skip_16k();
			skip_16k();
			out(P32765,48);
			if(read_16k()==1) return 1;
			mode(48);
			break;
		}
		case (4): /* 128K */
		{
			mode_128=1;
			mem_48_lock=0;
			btemp=ram_state;
			for (x=0;x<8;x++)
			{
				if(read_16k()==1) return 1;
			}
			mode(128);
			out(P32765,btemp);
			break;
		}
		case (5): /* 128K + ignored IF1 */
		{
			mode_128=1;
			mem_48_lock=0;
			btemp=ram_state;
			for (x=0;x<8;x++)
			{
				if(read_16k()==1) return 1;
			}
			mode(128);
			out(P32765,btemp);
			break;
		}
		case (6): /* 128K + ignored MGT */
		{
			mode_128=1;
			mem_48_lock=0;
			btemp=ram_state;
			for (x=0;x<8;x++)
			{
				if(read_16k()==1) return 1;
			}
			mode(128);
			out(P32765,btemp);
			break;
		}
		default:
		{
#ifndef NON_WINDOWS
			printf("File is mashed up.\n");
#endif
			return 1; /* fail */
		}
	}
	if(mode_128)
	{
#ifndef NON_WINDOWS
		printf(" 128 file\n");
#endif
	}
	else
	{
#ifndef NON_WINDOWS
		printf(" 48 file\n");
#endif
	}
	return 0; /* success! */
   }
   else
   {
#ifndef NON_WINDOWS
	printf("Length of head block was not 54 (Not V3)\n");
#endif
	return 1; /* fail V4 files not supported */
   }
}

UC z80_v2(void)
{
	pair ptemp;
	UC btemp, flag, x;

   fread(&ptemp.B.l,1,1,handle);
   fread(&ptemp.B.h,1,1,handle);
   if(ptemp.W==23)
   {
#ifndef NON_WINDOWS
	printf("This is a V2 :");
#endif
	fread(&pc.B.l,1,1,handle);
	fread(&pc.B.h,1,1,handle);
	fread(&hmode,1,1,handle); /* 0=48K,1=+IF1,2=Sam,3=128K,4=+IF1 */
	fread(&ram_state,1,1,handle); /* ram page or sam ram rubbish */
	fread(&btemp,1,1,handle); /* contains 255 if IF1 paged (ignored) */
	fread(&flag,1,1,handle); /* bit 0=1 if R reg on,bit 1=1 if Ldir on */
	fread(&last_fffd,1,1,handle); /* last out to FFFD */
	fread(&PSG,1,16,handle); /* soundchip regs */
	for(x=0;x<16;x++) PSGOut(x,PSG[x]);
	mode_128=0;
	switch(hmode)
	{
		case (0): /* 48K */
		{
			for (x=0;x<3;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			mode(48);
			break;
		}
		case (1): /* 48K + ignored IF1 */
		{
			for (x=0;x<3;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			mode(48);
			break;
		}
		case (2): /* Sam Ram Ignored */
		{
#ifndef NON_WINDOWS
			printf(" SAMRAM : ");
#endif
			for (x=0;x<2;x++)
			{
				out(P32765,48);
				if(read_16k()==1) return 1;
			}
			skip_16k();
			skip_16k();
			out(P32765,48);
			if(read_16k()==1) return 1;
			mode(48);
			break;
		}
		case (3): /* 128K */
		{
			mode_128=1;
			mem_48_lock=0;
			btemp=ram_state;
			for (x=0;x<8;x++)
			{
				if(read_16k()==1) return 1;
			}
			mode(128);
			out(P32765,btemp);
			break;
		}
		case (4): /* 128K + ignored IF1 */
		{
			mode_128=1;
			mem_48_lock=0;
			btemp=ram_state;
			for (x=0;x<8;x++)
			{
				if(read_16k()==1) return 1;
			}
			mode(128);
			out(P32765,btemp);
			break;
		}
		default:
		{
#ifndef NON_WINDOWS
			printf("File is mashed up.\n");
#endif
			return 1; /* fail */
		}
	}
	if(mode_128)
	{
#ifndef NON_WINDOWS
		printf(" 128 file\n");
#endif
	}
	else
	{
#ifndef NON_WINDOWS
		printf(" 48 file\n");
#endif
	}
	return 0; /* success! */
   }
   else
   {
	z80_v3(ptemp.W);
	return 0; /* success V3 files are supported */
   }
}

void decompress_non_DAT(char *addr, word in_length, FILE *temp_handle)
{
	word in_index;
	char *out_index;
	UC value, value2, poker, loopr, x;

	in_index=0;
	out_index=addr;
	do{
		fread(&value,1,1,temp_handle);
		in_index++;
		if(value==237) /* is ED... */
		{
			fread(&value2,1,1,temp_handle);
			in_index++;
			if (value2==237) /* is ED ED code */
			{
				fread(&loopr,1,1,temp_handle);
				in_index++;
				fread(&poker,1,1,temp_handle);
				in_index++;
				for(x=0;x<loopr;x++)
				{
					*out_index++=poker;
				}
			}
			else
			{
				*out_index++=value; /* is ED ?? */
				*out_index++=value2;
			}
		}
		else
		{
			*out_index++=value; /* not ED... */
		}
	} while (in_index<in_length);
}

UC open_z80(void)
{
	UC flag, compr, done;
	word x;
	pair data_type;
	long SLT_offset, precalc_pos;
	char filename[MAXPATH];

/*#ifdef NON_WINDOWS
	release_screen();
	release_keyboard();
#endif
   printf("Enter Z80 to load : ");
   scanf("%s",filename);
   if (!(handle = fopen(filename,"rb")))
   {
      perror("Error:");
      printf("File %s not present\n",filename);
#ifdef NON_WINDOWS
	init_screen();
	init_keyboard();
#endif
      return 1;*/ /* fail */
   /*}*/

   if (!(handle = fopen(the_path,"rb")))
   {
      perror("Error:");
      printf("File %s not present\n",the_path);
/*#ifdef NON_WINDOWS
	init_keyboard();
#endif*/
      return 1; /* fail */
   }
   clean_regs();
   build_DAT_path(the_path);
   fread(&af.B.h,1,1,handle);
   fread(&af.B.l,1,1,handle);
   fread(&bc.B.l,1,1,handle);
   fread(&bc.B.h,1,1,handle);
   fread(&hl.B.l,1,1,handle);
   fread(&hl.B.h,1,1,handle);
   fread(&pc.B.l,1,1,handle);
   fread(&pc.B.h,1,1,handle);
   fread(&sp.B.l,1,1,handle);
   fread(&sp.B.h,1,1,handle);
   fread(&ir.B.h,1,1,handle);
   fread(&ir.B.l,1,1,handle);
   ir.B.l&=127;
   fread(&flag,1,1,handle);
   if(flag==255) flag=1;
   if(flag&1) bit7_r=128; else bit7_r=0; /* set stinky bit 7 of r */
   border=(flag&14)>>1; /* border (bits 1-3) */
   /* bit 4 Samrom switched in is ignored */
   compr=(flag&32)>>5; /* 1 if it is compressed */
   fread(&de.B.l,1,1,handle);
   fread(&de.B.h,1,1,handle);
   fread(&bc2.B.l,1,1,handle);
   fread(&bc2.B.h,1,1,handle);
   fread(&de2.B.l,1,1,handle);
   fread(&de2.B.h,1,1,handle);
   fread(&hl2.B.l,1,1,handle);
   fread(&hl2.B.h,1,1,handle);
   fread(&af2.B.h,1,1,handle);
   fread(&af2.B.l,1,1,handle);
   fread(&iy.B.l,1,1,handle);
   fread(&iy.B.h,1,1,handle);
   fread(&ix.B.l,1,1,handle);
   fread(&ix.B.h,1,1,handle);
   fread(&iff1,1,1,handle); /* 1=ei */
   fread(&iff2,1,1,handle);
   fread(&flag,1,1,handle);
   im=flag&3;
   if(flag&4)
   {
	keyboard_issue=255;
   }
   else
   {
	keyboard_issue=191;
   }
   joy_type=(flag&0xC0)>>6;
#ifndef NON_WINDOWS
   printf("Joystick : ");
   switch(joy_type)
   {
	case 0 : printf("Cursor\n");break;
	case 1 : printf("Kempston\n");break;
	case 2 : printf("Sinclair 1\n");break;
	case 3 : printf("Sinclair 2\n");break;
   }
#endif
   /* bit 2 (1=issue 2 emulation) not ignored */
   /* bit 3 (1=double interrupt frequency) ignored */
   /* bit 4-5 (1=high,3=low,0 or 2=normal video sync) ignored */
   /* bit 6-7 (0=cursor,1=kempston,2=sinc1,3=sinc2) not ignored */
   if(!pc.W)
   {
	z80_v2();
   }
   else
   {
	mode(48);
	if(!compr)
	{
#ifndef NON_WINDOWS
		printf("This is a V1 48K uncompressed file.\n");
#endif
		fread(RAM[5],1,16384,handle);
		fread(RAM[2],1,16384,handle);
		fread(RAM[0],1,16384,handle);
	}
	else
	{
#ifndef NON_WINDOWS
		printf("This is a V1 48K compressed file.\n");
#endif
		read_48k(); /* decompress 48K */
	}
   }
   SLT=0;
   if(!feof(handle))
   {
	fread(BUFFER,1,3,handle);
	if(BUFFER[0]|BUFFER[1]|BUFFER[2])
	{
		SLT=0;
	}
	else
	{
		for(x=0;x<256;x++) DAT_length[x]=DAT_offset[x]=0;
		fread(BUFFER,1,strlen(ID_String),handle);
		BUFFER[strlen(ID_String)]='\0';
		if(!strcmp(BUFFER,ID_String))
		{
			done=0;
			SLT_inst_len=SLT_inst_offset=0;
			SLT_lscr_len=SLT_lscr_offset=0;
			SLT_scan_pic_len=0;
			SLT_pokes_len=SLT_pokes_offset=0;
			while(!done)
			{
				fread(BUFFER,1,8,handle);
				data_type.B.l=(UC)BUFFER[0];
				data_type.B.h=(UC)BUFFER[1];
				qtemp.B.b1=(UC)BUFFER[4];
				qtemp.B.b2=(UC)BUFFER[5];
				qtemp.B.b3=(UC)BUFFER[6];
				qtemp.B.b4=(UC)BUFFER[7];

				switch(data_type.W)
				{
				case 0: /* End Of Table */
					done=1;
					break;
				case 1: /* Level Data */
					DAT_length[(UC)BUFFER[2]]=qtemp.Q;
					break;
				case 2: /* Instructions */
					SLT_inst_len=qtemp.Q;
					break;
				case 3: /* Loading Screen */
					SLT_lscr_len=qtemp.Q;
					break;
				case 4: /* Scanned Pictures!!! */
					SLT_scan_pic_len=1;
					break;
				case 5: /* Pokes */
					SLT_pokes_len=qtemp.Q;
					break;
				default:
					break;
				}
			}
			SLT_offset=ftell(handle);
			for(x=0;x<256;x++)
			{
				if(DAT_length[x])
				{
					DAT_offset[x]=SLT_offset;
					SLT_offset+=DAT_length[x];
				}
			}
			if(SLT_inst_len)
			{
				SLT_inst_offset=SLT_offset;
				SLT_offset+=SLT_inst_len;
			}
			if(SLT_lscr_len)
			{
				SLT_lscr_offset=SLT_offset;
				SLT_offset+=SLT_lscr_len;
			}
			if(SLT_scan_pic_len)
			{
				SLT_pokes_len=0;
				/* Can't figure out offset of pokes */
			}
			if(SLT_pokes_len)
			{
				SLT_pokes_offset=SLT_offset;
				SLT_offset+=SLT_pokes_len;
			}
			SLT=1;
#ifndef NON_WINDOWS
			printf("This is a SLT file.\n");
#endif
			if(SLT_lscr_len)
			{
				release_keyboard();
				scr_copy();
				fseek(handle,SLT_lscr_offset,SEEK_SET);
				decompress_non_DAT(SP_SCREEN,(word)SLT_lscr_len,handle);
				RePaintScreen();
				done=fsl_asciiext_key(); /* Temp use */
				scr_restore();
				init_keyboard();
			}
		}
	}
   }
   fclose(handle);
/*#ifdef NON_WINDOWS
	init_screen();
	init_keyboard();
#endif*/
   out(P254,border);
   if(model_48)
   {
	for(x=0;x<16;x++) PSGOut(x,255);
   }
   return 0; /* Success */
}

void compress_16k(UC ram_page, UC z80_page)
{
	pair b_index;
	word index;
	word xx;
	UC yy, special, single_ED;

	b_index.W=single_ED=index=0;
	while(index<16384)
	{
		yy=RAM[ram_page][index];
		special=0;
		xx=1;
		while((xx<256)&&(!special))
		{
			if(index+xx<16384)
			{
				if(RAM[ram_page][index+xx]==yy)
				{
					xx++;
				}
				else
				{
					special=1;
				}
				if(xx==255) special=1;
			}
			else
			{
				/* Leave loop, reached the end */
				special=1;
			}

		}
		if(((xx>=2)&&(yy==0xED))||(xx>=5))
		{
			if(single_ED)
			{
				BUFFER[b_index.W++]=yy;
				BUFFER[b_index.W++]=0xED;
				BUFFER[b_index.W++]=0xED;
				BUFFER[b_index.W++]=xx-1;
				BUFFER[b_index.W++]=yy;
			}
			else
			{
				BUFFER[b_index.W++]=0xED;
				BUFFER[b_index.W++]=0xED;
				BUFFER[b_index.W++]=xx;
				BUFFER[b_index.W++]=yy;
			}
			index+=xx;
			single_ED=0;
		}
		else
		{
			BUFFER[b_index.W++]=yy;
			index++;
			if(yy==0xED)
			{
				single_ED=1;
			}
			else
			{
				single_ED=0;
			}
		}
	}
	fwrite(&b_index.B.l,1,1,handle);
	fwrite(&b_index.B.h,1,1,handle);
	fwrite(&z80_page,1,1,handle);
	fwrite(BUFFER,1,b_index.W,handle);
}

void copy_data_to(FILE *in_1, long len_of_data, FILE *out_1)
{
	while(len_of_data>16383)
	{
		fread(BUFFER,1,16384,in_1);
		fwrite(BUFFER,1,16384,out_1);
		len_of_data-=16384;
	}
	if(len_of_data>0)
	{
		fread(BUFFER,1,len_of_data,in_1);
		fwrite(BUFFER,1,len_of_data,out_1);
	}
}

long find_end_of_z80(FILE *t_in_handle)
{
	word temp_word;
	UC done;

	fread(BUFFER,1,32,t_in_handle);
	temp_word=(UC)BUFFER[30]|((UC)BUFFER[31]<<8);
	fread(BUFFER,1,temp_word,t_in_handle);
	/* Now at memory blocks */
	done=0;
	while(!done)
	{
		fread(BUFFER,1,3,t_in_handle);
		temp_word=(UC)BUFFER[0]|((UC)BUFFER[1]<<8);
		if((!temp_word)&&(!BUFFER[2]))
		{
			done=1; /* Test for ID_000 */
			fseek(t_in_handle,-3,SEEK_CUR);
		}
		else
		{
			fseek(t_in_handle,temp_word,SEEK_CUR);
		}
	}
	return ftell(t_in_handle);
}

void combine_z80_and_temp_file(char *the_slt_path)
{
	FILE *in_1, *out_1;
	long temp_long;

	if(!(out_1 = fopen(the_slt_path,"ab")))
	{
		/* Can't open z80 */
		return;
	}
	if(!(in_1 = fopen(the_temp_file,"rb")))
	{
		/* Can't open temp */
		fclose(in_1);
		return;
	}
	fseek(in_1,0,SEEK_END);
	temp_long=ftell(in_1);
	fseek(in_1,0,SEEK_SET);
	copy_data_to(in_1,temp_long,out_1);
	fclose(in_1);
}

UC split_slt_data(char *the_slt_path)
{
	FILE *t_in_handle, *t_out_handle;
	long temp_long, end_of_z80;

	if(!(t_in_handle = fopen(the_slt_path,"rb")))
	{
		/* Can't open old file */
		return 0;
	}
	if(!(t_out_handle = fopen(the_temp_file,"wb")))
	{
		/* Can't write dump */
		return 0;
	}

	end_of_z80=find_end_of_z80(t_in_handle);

	fseek(t_in_handle,0,SEEK_END);
	temp_long=ftell(t_in_handle)-end_of_z80;
	fseek(t_in_handle,end_of_z80,SEEK_SET);

	copy_data_to(t_in_handle,temp_long,t_out_handle);
	fclose(t_in_handle);
	fclose(t_out_handle);
	return 1;
}

void save_PSG(void)
{
	UC resolved;
	char extension[5];
	int pos;

	strcpy(extension,".psg");
	pos=strlen(the_path);
	pos--;
	while((the_path[pos]!='.')&&(pos)&&
	(the_path[pos]!='\\')&&(the_path[pos]!='/')) pos--;

	if(the_path[pos]=='.') the_path[pos]='\0'; /* If ext, then cut */
	if((strlen(the_path)-MAXPATH)>3)
	{
		strcat(the_path,(char *)extension);
	}

	if((handle = fopen(the_path,"rb"))!=NULL)
	{
		fclose(handle);
		release_keyboard();
		scr_copy();
		make_box(0,3,32,19,79);
		scr_write_string(8,4,79,"CREATE PSG FILE");
		scr_write_string(0,6,79,the_path);
		scr_write_string(8,17,79,"Overwrite (Y/N)?");
		RePaintScreen();
		resolved=0;
		while(!resolved)
		{
			switch(fsl_asciiext_key())
			{
				case X128_ESCAPE:
				case 'n':
				case 'N':
					scr_restore();
					init_keyboard();
					return;
				case 'y':
				case 'Y':
					resolved=1;
					break;
				default:
					break;
			}
		}
		scr_restore();
		init_keyboard();
	}
	if(!(p_handle = fopen(the_path,"wb")))
	{
		release_keyboard();
		scr_copy();
		make_box(2,3,29,19,79);
		scr_write_string(8,4,79,"CREATE PSG FILE");
		scr_write_string(5,10,79,"Could not create file!");
		scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
		RePaintScreen();
		while(fsl_extend_key()!=X128_ESCAPE);
		scr_restore();
		init_keyboard();
		return;
	}
	else
	{
		fwrite("PSG\032\0\0\0\0\0\0\0\0\0\0\0\0",1,16,p_handle);
	}
}

void save_z80(void)
{
	UC zero, flag, x, resolved;
	char extension[5];
	int pos;

	if(SLT)
	{
		strcpy(extension,".slt");
	}
	else
	{
		strcpy(extension,".z80");
	}
	pos=strlen(the_path);
	pos--;
	while((the_path[pos]!='.')&&(pos)&&
	(the_path[pos]!='\\')&&(the_path[pos]!='/')) pos--;

	if(the_path[pos]=='.') the_path[pos]='\0'; /* If ext, then cut */
	if((strlen(the_path)-MAXPATH)>3)
	{
		strcat(the_path,(char *)extension);
	}

	zero=0;
	if((handle = fopen(the_path,"rb"))!=NULL)
	{
		fclose(handle);
		release_keyboard();
		scr_copy();
		make_box(0,3,32,19,79);
		scr_write_string(9,4,79,"SAVE Z80 FILE");
		scr_write_string(0,6,79,the_path);
		scr_write_string(8,17,79,"Overwrite (Y/N)?");
		RePaintScreen();
		resolved=0;
		while(!resolved)
		{
			switch(fsl_asciiext_key())
			{
				case X128_ESCAPE:
				case 'n':
				case 'N':
					scr_restore();
					init_keyboard();
					return;
				case 'y':
				case 'Y':
					resolved=1;
					break;
				default:
					break;
			}
		}
		scr_restore();
		init_keyboard();
	}
	if(!(handle = fopen(the_path,"wb")))
	{
		release_keyboard();
		scr_copy();
		make_box(2,3,29,19,79);
		scr_write_string(9,4,79,"SAVE Z80 FILE");
		scr_write_string(5,10,79,"Could not create file!");
		scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
		RePaintScreen();
		while(fsl_extend_key()!=X128_ESCAPE);
		scr_restore();
		init_keyboard();
		return;
	}
	else
	{
		if((!SLT)||((SLT)&&(split_slt_data(the_sna_path)))) /* Last Z80 */
		{
		fwrite(&af.B.h,1,1,handle);
		fwrite(&af.B.l,1,1,handle);
		fwrite(&bc.B.l,1,1,handle);
		fwrite(&bc.B.h,1,1,handle);
		fwrite(&hl.B.l,1,1,handle);
		fwrite(&hl.B.h,1,1,handle);
		fwrite(&zero,1,1,handle); /* PC = 0 */
		fwrite(&zero,1,1,handle); /* V2 Rule */
		fwrite(&sp.B.l,1,1,handle);
		fwrite(&sp.B.h,1,1,handle);
		fwrite(&ir.B.h,1,1,handle);
		fwrite(&ir.B.l,1,1,handle);

		flag=32|(border<<1); /* 32 = compressed */
		if(bit7_r) flag|=1; /* bit 7 of r */
		/* bit 4 Samrom switched in is ignored (0) */
		fwrite(&flag,1,1,handle);

		fwrite(&de.B.l,1,1,handle);
		fwrite(&de.B.h,1,1,handle);
		fwrite(&bc2.B.l,1,1,handle);
		fwrite(&bc2.B.h,1,1,handle);
		fwrite(&de2.B.l,1,1,handle);
		fwrite(&de2.B.h,1,1,handle);
		fwrite(&hl2.B.l,1,1,handle);
		fwrite(&hl2.B.h,1,1,handle);
		fwrite(&af2.B.h,1,1,handle);
		fwrite(&af2.B.l,1,1,handle);
		fwrite(&iy.B.l,1,1,handle);
		fwrite(&iy.B.h,1,1,handle);
		fwrite(&ix.B.l,1,1,handle);
		fwrite(&ix.B.h,1,1,handle);
		fwrite(&iff1,1,1,handle); /* 1=ei */
		fwrite(&iff2,1,1,handle);

		flag=im|(joy_type<<6);
		if(keyboard_issue==255) flag|=4;
		/* bit 2 (1=issue 2 emulation) ignored */
		/* bit 3 (1=double interrupt frequency) ignored */
		/* bit 4-5 (1=high,3=low,0 or 2=normal video sync) ignored */
		/* bit 6-7 (0=cursor,1=kempston,2=sinc1,3=sinc2) not ignored */
		fwrite(&flag,1,1,handle);

		x=23;
		fwrite(&x,1,1,handle);
		fwrite(&zero,1,1,handle);
		fwrite(&pc.B.l,1,1,handle);
		fwrite(&pc.B.h,1,1,handle);
		if(!model_48) x=3; else x=0;
		fwrite(&x,1,1,handle);
		fwrite(&ram_state,1,1,handle);
		fwrite(&zero,1,1,handle); /* IF 1 not paged in */
		x=3;
		fwrite(&x,1,1,handle); /* R and LDIR on */
		fwrite(&last_fffd,1,1,handle);
		for(x=0;x<16;x++)
		{
			fwrite(&PSG[x],1,1,handle);
		}
		if(!model_48)
		{
			for(x=0;x<8;x++)
			{
				compress_16k(x,x+3);
			}
		}
		else
		{
			compress_16k(2,4);
			compress_16k(0,5);
			compress_16k(5,8);
		}
		fclose(handle);
		if(SLT) combine_z80_and_temp_file(the_path);
		}
		else
		{
			/* Save refused due to slt split error */
			release_keyboard();
			scr_copy();
			make_box(2,3,29,19,79);
			scr_write_string(9,4,79,"SAVE SLT FILE");
			scr_write_string(6,10,79,"Could not create SLT");
			scr_write_string(6,11,79,"because of an error");
			scr_write_string(5,12,79,"while trying to split");
			scr_write_string(7,13,79,"the original file.");
			scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
			RePaintScreen();
			while(fsl_extend_key()!=X128_ESCAPE);
			scr_restore();
			init_keyboard();
			return;
		}
	}
}

void decompress_DAT(word addr, word in_length, FILE *temp_handle)
{
	word in_index, out_index;
	UC value, value2, poker, loopr, x;

	in_index=0;
	out_index=addr;
	do{
		fread(&value,1,1,temp_handle);
		in_index++;
		if(value==237) /* is ED... */
		{
			fread(&value2,1,1,temp_handle);
			in_index++;
			if (value2==237) /* is ED ED code */
			{
				fread(&loopr,1,1,temp_handle);
				in_index++;
				fread(&poker,1,1,temp_handle);
				in_index++;
				for(x=0;x<loopr;x++)
				{
					spokeb(out_index,poker);
					out_index++;
				}
			}
			else
			{
				spokeb(out_index,value); /* is ED ?? */
				out_index++;
				spokeb(out_index,value2);
				out_index++;
			}
		}
		else
		{
			spokeb(out_index,value); /* not ED... */
			out_index++;
		}
	} while (in_index<in_length);
	hl.W+=(out_index-addr);
	de.W-=(out_index-addr);
}


UC found_and_loaded_SLT(UC level_num, FILE *temp_handle)
{
	if(DAT_length[level_num])
	{
		fseek(temp_handle,DAT_offset[level_num],SEEK_SET);
		decompress_DAT(hl.W,DAT_length[level_num],temp_handle);
		return 1;
	}
	else
	{
		return 0;
	}
}

void read_DAT(void)
{
	UC value_read;

	while(!feof(d_handle))
	{
		fread(&value_read,1,1,d_handle);
		spokeb(hl.W,value_read);
		hl.W++;
		de.W--;
	}
}

int get_length_of_pre(char *stringy)
{
/* Assumes that extension has already been stripped and that there is no
 / or \ at the end of this string */
	int pos, pre_len;

	pos=strlen(stringy);
	pos--;
	pre_len=0;
	while((stringy[pos]!='/')&&(stringy[pos]!='\\')&&(pos>=0))
	{
		pre_len++;
		pos--;
	}
	return pre_len;
}

void wtoa_temp(char *stringy, word x)
{
	char *original_point;
	word temp;

	original_point=stringy;
	temp=0;
	while(x>=10000)
	{
		x-=10000;
		temp++;
	}
	*stringy++=temp+'0';
	temp=0;
	while(x>=1000)
	{
		x-=1000;
		temp++;
	}
	*stringy++=temp+'0';
	temp=0;
	while(x>=100)
	{
		x-=100;
		temp++;
	}
	*stringy++=temp+'0';
	temp=0;
	while(x>=10)
	{
		x-=10;
		temp++;
	}
	*stringy++=temp+'0';
	*stringy++=x+'0';
	*stringy='\0';
	stringy=original_point;
}

void itoa_temp(char *stringy, UC x)
{
	char *original_point;
	UC temp;

	original_point=stringy;
	temp=0;
	if(x>=100)
	{
		temp=0;
		while(x>=100)
		{
			x-=100;
			temp++;
		}
		*stringy++=temp+'0';
	}
	if(x>=10)
	{
		temp=0;
		while(x>=10)
		{
			x-=10;
			temp++;
		}
		*stringy++=temp+'0';
	}
	else
	{
		if(temp) /* 100's but not 10's */
		{
			*stringy++='0';
		}
	}
	*stringy++=x+'0';
	*stringy='\0';
	stringy=original_point;
}

void open_SLT(void)
{
	FILE *temp_handle;
	word length;
	UC value;
	char str_num[4];

	if(!(temp_handle = fopen(the_sna_path,"rb")))
	{
		/* Couldn't open the z80 */
		release_keyboard();
		scr_copy();
		Sound_off();
		make_box(2,3,29,19,79);
		scr_write_string(5,4,79,"SLT-Z80 INTERNAL LOAD");
		scr_write_string(4,10,79,"Z80 file would not open!");
		scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
		RePaintScreen();
		while(fsl_extend_key()!=X128_ESCAPE);
		Sound_on();
		scr_restore();
		init_keyboard();
		return;
	}
	else
	{
		if(!found_and_loaded_SLT(af.B.h,temp_handle))
		{
			/* No reference in the index for that file */
			release_keyboard();
			Sound_off();
			scr_copy();
			make_box(2,3,30,19,79);
			scr_write_string(4,5,79,"SLT INTERNAL LOAD FAILED");
			scr_write_string(7,11,79,"Attempting to load");
			scr_write_string(11,12,79,"level");
			itoa_temp(str_num,af.B.h);
			scr_write_string(17,12,79,str_num);
			scr_write_string(5,14,79,"The file is not within");
			scr_write_string(9,15,79,"this SLT file.");
			scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
			RePaintScreen();
			while(fsl_extend_key()!=X128_ESCAPE);
			scr_restore();
			init_keyboard();
			Sound_on();

			fclose(temp_handle);
			return;
		}
	}
}

void open_DAT(void)
{
	char filename[MAXPATH], filename2[MAXPATH];
	char filename3[MAXPATH];
	char str_num[4];
	UC y;

	/* Concat Old_Snap + af.B.h + .DAT */
	if(SLT)
	{
		open_SLT();
		return;
	}
	itoa_temp(str_num,af.B.h);

	strcpy(filename2,the_dat_path); /* Unix filename */
	strcat(filename2,str_num);
	strcat(filename2,".dat");

	strcpy(filename,the_dat_path); /* MS-DOS filename */
	if((get_length_of_pre(filename)+strlen(str_num))>8)
	{
		filename[strlen(filename)-strlen(str_num)]='\0';
	}
	strcat(filename,str_num);
	strcat(filename,".dat");

	strcpy(filename3,the_dat_path); /* Acorn style */
	strip_file(filename3);
	strcat(filename3,str_num); /* Just the number for Acorn */

	if(!(d_handle = fopen(filename,"rb")))
	{
	filename[strlen(filename)-4]='\0';
	strcat(filename,".DAT");
	if(!(d_handle = fopen(filename,"rb")))
	{
	if(!(d_handle = fopen(filename2,"rb")))
	{
	filename2[strlen(filename2)-4]='\0';
	strcat(filename2,".DAT");
	if(!(d_handle = fopen(filename2,"rb")))
	{
	if(!(d_handle = fopen(filename3,"rb")))
	{
		release_keyboard();
		Sound_off();
		scr_copy();

		for(y=3;y<19;y++)
		{
			scr_write_string(2,y,79,"                            ");
		}
		scr_write_string(8,5,79,"DAT LOAD FAILED");
		scr_write_string(7,11,79,"Attempting to load");
		scr_write_string(11,12,79,"level");
		scr_write_string(17,12,79,str_num);
		scr_write_string(8,16,79,"PRESS ESCAPE FOR");
		scr_write_string(8,17,79,"MANUAL SELECTION");
		RePaintScreen();
		while(fsl_extend_key()!=X128_ESCAPE);

		scr_restore();
		init_keyboard();
		Sound_on();

		strcpy(the_path,filename);
		if(!(test_fsl(".dat","","")))
		{
			if(!(d_handle = fopen(the_path,"rb")))
			{
				perror("Error:");
				printf("File %s not present\n",the_path);
				printf("Warning: ED FB Load Failed.\n");
			}
			else
			{
				read_DAT(); /* OK - Typed name */
				fclose(d_handle);
			}
		}
		return;
	}
	}
	}
	}
	}
	read_DAT(); /* OK - .DAT */
	fclose(d_handle);
}

void skip_block(word length_wanted)
{
	UC buffer[512], loop, chunks;
	word loop2;

	chunks=length_wanted/512;
	for (loop=0;loop<chunks;loop++)
	{
		fread(&buffer,1,512,t_handle);
		length_wanted-=512;
		for(loop2=0;loop2<512;loop2++)
		{
			calc_checksum^=buffer[loop2];
		}
	}
	if(length_wanted) /* Any left over? */
	{
		fread(&buffer,1,length_wanted,t_handle);
		for(loop2=0;loop2<length_wanted;loop2++)
		{
			calc_checksum^=buffer[loop2];
		}
		length_wanted=0;
	}
}

void read_block(word start_ix, word length_wanted)
{
	UC buffer[512], loop, chunks;
	word loop2;

	chunks=length_wanted/512;
	for (loop=0;loop<chunks;loop++)
	{
		fread(&buffer,1,512,t_handle);
		for(loop2=0;loop2<512;loop2++)
		{
			spokeb(start_ix,buffer[loop2]);
			calc_checksum^=buffer[loop2];
			start_ix++;
			length_wanted--;
		}
	}
	if(length_wanted) /* Any left over? */
	{
		fread(&buffer,1,length_wanted,t_handle);
		for(loop2=0;loop2<length_wanted;loop2++)
		{
			spokeb(start_ix,buffer[loop2]);
			calc_checksum^=buffer[loop2];
			start_ix++;
			/*length_wanted--;*/
		}
	}
	RePaintScreen();
}

void TAP_select(void)
{
	char filename[MAXPATH];

/*#ifdef NON_WINDOWS
	release_screen();
	release_keyboard();
#endif
	fclose(t_handle);
	printf("Enter TAP to load : ");
	scanf("%s",filename);*/
	if(TAP_file_open) fclose(t_handle);
	if(!(t_handle = fopen(the_path,"rb")))
	{
		perror("Error:");
		printf("File %s not present\n",the_path);
		TAP_file_open=0;
	}
	else
	{
		TAP_file_open=1;
	}
/*#ifdef NON_WINDOWS
	init_screen();
	init_keyboard();
#endif*/
}

UC TAP_load(UC id_a, word start_ix, word length_de)
{
	pair length;
	UC id_tape, checksum;

	if(!TAP_file_open) return 0; /* fail, no file */

	if(feof(t_handle))
	{
		fseek(t_handle,0L,0); /* Back to start */
	}

	fread(&length.B.l,1,1,t_handle);
	fread(&length.B.h,1,1,t_handle);
	length.W-=2; /* Now actual Spectrum length */

	fread(&id_tape,1,1,t_handle);
	calc_checksum=id_tape;

	if(id_tape==id_a) /* Yes, the correct ID, proceed. */
	{
		if(length_de<=length.W) /* Length <= so OK */
		{
			read_block(start_ix,length_de);
			if(length_de!=length.W)
			{
				skip_block(length.W-length_de);
			}
			fread(&checksum,1,1,t_handle);
			ix.W+=length_de;
			de.W=0; /* checksum in this case? */
			if(checksum==calc_checksum)
			{
				return 1; /* success */
			}
			else
			{
				return 0; /* fail */
			}
		}
		else /* Too many bytes requested */
		{
			read_block(start_ix,length.W);
			fread(&checksum,1,1,t_handle);
			ix.W+=length.W;
			de.W=0;
			return 0; /* fail */
		}
	}
	else /* Wrong ID! */
	{
		skip_block(length.W);
		fread(&checksum,1,1,t_handle);
		return 0; /* fail */
	}
}

void TAP_rompokes(void)
{
	ROM[2][1386]=237;
	ROM[2][1387]=255;
	ROM[1][1386]=237;
	ROM[1][1387]=255;
}

void undo_TAP_rompokes(void)
{
	ROM[2][1386]=r2_1386;
	ROM[2][1387]=r2_1387;
	ROM[1][1386]=r1_1386;
	ROM[1][1387]=r1_1387;
}
