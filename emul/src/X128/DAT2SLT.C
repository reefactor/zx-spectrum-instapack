/******************************************/
/**                                      **/
/**         DAT2SLT.C DAT Combiner       **/
/**                                      **/
/**          (C) James McKay 1996        **/
/**                                      **/
/**    This software may not be used     **/
/**    for commercial reasons, the code  **/
/**    may not be modified or reused     **/
/**    without permission.               **/
/**                                      **/
/******************************************/

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* It is essential that a word is 16 bits wide and a char is 8 bits wide */

/* A quick fix for Borland */
#ifdef __BORLANDC__
#define word unsigned int
#else
#define word unsigned short
#endif

#define UC unsigned char

#define MAXPATH 300

char input_name[MAXPATH];
char output_name[MAXPATH];
char param4[MAXPATH];

char *ID_String="SLT";
char *ID_000="\0\0\0";
char *End_Of_Table="\0\0\0\0\0\0\0\0";

char *in_buffer, *out_buffer;

long DAT_offset[256];
long SLT_lscr_offset;

FILE *output_handle;

UC acorn_form=0;

/* Set this to 1 for default if compiling under DOS */
UC dos_form=1;

void clean_buffers(void)
{
	memset(in_buffer,0,0xFFFF);
	memset(out_buffer,0,0xFFFF);
}

void lower_it(char *stringy)
{
	int pos, x;

	pos=strlen(stringy);
	for(x=0;x<pos;x++)
	{
		stringy[x]=tolower(stringy[x]);
	}
}

void strip_extension(char *stringy)
{
	int pos;

	pos=strlen(stringy);
	pos--;
	while((stringy[pos]!='.')&&(pos)&&
	(stringy[pos]!='\\')&&(stringy[pos]!='/')) pos--;

	if(stringy[pos]=='.') stringy[pos]='\0'; /* If ext, then cut */
}

int get_length_of_pre(char *stringy)
{
/* Assumes that extension has already been stripped and that there is no
 / or \ at the end of this string */
	int pos, pre_len;

	if(acorn_form) return 0;
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

void add_level_num(char *stringy, UC number)
{
	char num_str[4];
	int pre_len, pos;

	itoa_temp((char *)num_str,number);
	pre_len=get_length_of_pre(stringy);
	if((dos_form)&&((pre_len+strlen(num_str))>8))
	{
		/* Snippy bits for DOS */
		pos=strlen(stringy);
		stringy[pos-strlen(num_str)]='\0';
	}
	strcat(stringy,num_str);
}

void compress_DAT(long table_offset, word total_length)
{
	word in_index, out_index, xx;
	UC yy, special, single_ED, out_lo, out_hi, zero;
	long temp_ftell;

	out_index=single_ED=in_index=0;
	while(in_index<total_length)
	{
		yy=in_buffer[in_index];
		special=0;
		xx=1;
		while((xx<256)&&(!special))
		{
			if(in_index+xx<total_length)
			{
				if(in_buffer[in_index+xx]==yy)
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
				out_buffer[out_index++]=yy;
				out_buffer[out_index++]=0xED;
				out_buffer[out_index++]=0xED;
				out_buffer[out_index++]=xx-1;
				out_buffer[out_index++]=yy;
			}
			else
			{
				out_buffer[out_index++]=0xED;
				out_buffer[out_index++]=0xED;
				out_buffer[out_index++]=xx;
				out_buffer[out_index++]=yy;
			}
			in_index+=xx;
			single_ED=0;
		}
		else
		{
			out_buffer[out_index++]=yy;
			in_index++;
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
	out_lo=out_index&0xFF;
	out_hi=(out_index&0xFF00)>>8;
	temp_ftell=ftell(output_handle);

	fseek(output_handle,table_offset,SEEK_SET); /* back to table */
	fwrite(&out_lo,1,1,output_handle);
	fwrite(&out_hi,1,1,output_handle);
	zero=0;
	fwrite(&zero,1,1,output_handle);
	fwrite(&zero,1,1,output_handle);
	fseek(output_handle,temp_ftell,SEEK_SET); /* back to end */
	fwrite(out_buffer,1,out_index,output_handle);
}

void construct_SCR_table(void)
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];

	FILE *temp_handle;
	UC temp_char;

	strcpy(temp_str,input_name);
	strcpy(temp_str2,input_name);
	strcat(temp_str,".SCR");
	strcat(temp_str2,".scr");
	if(!(temp_handle = fopen(temp_str,"rb")))
	{
		if(!(temp_handle = fopen(temp_str2,"rb")))
		{
			return;
		}
	}

	temp_char=3; /* Signify type is loading screen */
	fwrite(&temp_char,1,1,output_handle);
	temp_char=0;
	fwrite(&temp_char,1,1,output_handle);

	temp_char=0; /* Write level number */
	fwrite(&temp_char,1,1,output_handle);
	temp_char=0;
	fwrite(&temp_char,1,1,output_handle);

	SLT_lscr_offset=ftell(output_handle); /* later for length */
	fwrite(&temp_char,1,1,output_handle); /* Write null length */
	fwrite(&temp_char,1,1,output_handle); /* for the moment */
	fwrite(&temp_char,1,1,output_handle);
	fwrite(&temp_char,1,1,output_handle);

	fclose(temp_handle);
}

void construct_DAT_table(UC level_num)
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];

	FILE *temp_handle;
	UC temp_char;

	if(acorn_form)
	{
		strcpy(temp_str,"");
		strcpy(temp_str2,"");
	}
	else
	{
		strcpy(temp_str,input_name);
		strcpy(temp_str2,input_name);
	}
	add_level_num((char *)temp_str,level_num);
	add_level_num((char *)temp_str2,level_num);
	strcat(temp_str,".DAT");
	if(!acorn_form) strcat(temp_str2,".dat");
	if(!(temp_handle = fopen(temp_str,"rb")))
	{
		if(!(temp_handle = fopen(temp_str2,"rb")))
		{
			return;
		}
	}

	temp_char=1; /* Signify type is level data */
	fwrite(&temp_char,1,1,output_handle);
	temp_char=0;
	fwrite(&temp_char,1,1,output_handle);

	temp_char=level_num; /* Write level number */
	fwrite(&temp_char,1,1,output_handle);
	temp_char=0;
	fwrite(&temp_char,1,1,output_handle);

	DAT_offset[level_num]=ftell(output_handle); /* later for length */
	fwrite(&temp_char,1,1,output_handle); /* Write null length */
	fwrite(&temp_char,1,1,output_handle); /* for the moment */
	fwrite(&temp_char,1,1,output_handle);
	fwrite(&temp_char,1,1,output_handle);

	fclose(temp_handle);
}

void append_SCR(void)
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];

	FILE *temp_handle;
	long temp_long;

	strcpy(temp_str,input_name);
	strcpy(temp_str2,input_name);
	strcat(temp_str,".SCR");
	strcat(temp_str2,".scr");
	if(!(temp_handle = fopen(temp_str,"rb")))
	{
		if(!(temp_handle = fopen(temp_str2,"rb")))
		{
			return;
		}
	}
	fseek(temp_handle,0,SEEK_END);
	temp_long=ftell(temp_handle);
	fseek(temp_handle,0,SEEK_SET);
	clean_buffers();
	fread(in_buffer,1,(word)temp_long,temp_handle);
	compress_DAT(SLT_lscr_offset,(word)temp_long);
	fclose(temp_handle);
}

void append_DAT(UC level_num)
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];

	FILE *temp_handle;
	long temp_long;

	if(acorn_form)
	{
		strcpy(temp_str,"");
		strcpy(temp_str2,"");
	}
	else
	{
		strcpy(temp_str,input_name);
		strcpy(temp_str2,input_name);
	}
	add_level_num((char *)temp_str,level_num);
	add_level_num((char *)temp_str2,level_num);
	strcat(temp_str,".DAT");
	if(!acorn_form) strcat(temp_str2,".dat");
	if(!(temp_handle = fopen(temp_str,"rb")))
	{
		if(!(temp_handle = fopen(temp_str2,"rb")))
		{
			return;
		}
	}
	fseek(temp_handle,0,SEEK_END);
	temp_long=ftell(temp_handle);
	fseek(temp_handle,0,SEEK_SET);
	clean_buffers();
	fread(in_buffer,1,(word)temp_long,temp_handle);
	compress_DAT(DAT_offset[level_num],(word)temp_long);
	fclose(temp_handle);
}

void process_and_copy_z80(void)
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];

	FILE *temp_handle;
	long temp_long;

	strcpy(temp_str,input_name);
	strcpy(temp_str2,input_name);
	strcat(temp_str,".Z80");
	strcat(temp_str2,".z80");

	if(!(temp_handle = fopen(temp_str,"rb")))
	{
		if(!(temp_handle = fopen(temp_str2,"rb")))
		{
			printf("Could not open input file %s\n",temp_str);
			printf("Or %s\n",temp_str2);
			fclose(output_handle);
			exit(1);
		}
	}
	fseek(temp_handle,0,SEEK_END);
	temp_long=ftell(temp_handle);
	fseek(temp_handle,0,SEEK_SET);
	while(temp_long>32767)
	{
		fread(in_buffer,1,32768,temp_handle);
		fwrite(in_buffer,1,32768,output_handle);
		temp_long-=32768;
	}
	if(temp_long>0)
	{
		fread(in_buffer,1,(word)temp_long,temp_handle);
		fwrite(in_buffer,1,(word)temp_long,output_handle);
	}
	fclose(temp_handle);
}

void main(int argc, char *argv[])
{
	char temp_str[MAXPATH];
	int x;

	printf("DAT2SLT DAT combiner by James McKay\n");
	if(argc==1)
	{
		printf("\nThis utility combines the Z80 and it's DATs ");
		printf("into one big SLT file\nand a loading SCR.\n");
		printf("\nUsage: DAT2SLT <input.z80> <output.slt> [/dos");
		printf(" | /acorn]\n");
		printf("/dos forces MS-DOS style filenames.\n");
		printf("/acorn makes utility look for a file that just has");
		printf(" the number as the name.\n");
		exit(1);
	}
	if(argc<3)
	{
		printf("Must have input filename and output filename\n");
		exit(1);
	}
	strcpy(input_name,argv[1]);
	strcpy(output_name,argv[2]);
	strip_extension((char *)input_name);
	strip_extension((char *)output_name);
	if(argc==4)
	{
		strcpy(param4,argv[3]);
		if(param4[0]=='-') param4[0]='/';
		lower_it((char *)param4);
		if(!strcmp("/dos",param4))
		{
			dos_form=1;
			printf("Using 8 letter format\n");
		}
		else
		{
			if(!strcmp("/acorn",param4))
			{
				acorn_form=1;
				printf("Using Acorn 'no name' format.\n");
			}
			else
			{
				printf("Last parameter can only be /dos");
				printf(" or /acorn\n");
				exit(1);
			}
		}
	}
	if(!(in_buffer=(UC *)malloc(0xFFFF)))
	{
	      printf("Could not allocate input 64K memory buffer!\n");
	      exit(1);
	}
	else
	{
	      memset(in_buffer,0,0xFFFF);
	}
	if(!(out_buffer=(UC *)malloc(0xFFFF)))
	{
	      printf("Could not allocate output 64K memory buffer!\n");
	      free(in_buffer);
	      exit(1);
	}
	else
	{
	      memset(out_buffer,0,0xFFFF);
	}
	strcpy(temp_str,output_name);
	strcat(temp_str,".slt");
	if(!(output_handle = fopen(temp_str,"w+b")))
	{
		perror("Error:");
		printf("\nCould not open output file %s.\n",temp_str);
		free(in_buffer);
		free(out_buffer);
		exit(1);
	}
	process_and_copy_z80();
	fwrite(ID_000,1,3,output_handle);
	fwrite(ID_String,1,strlen(ID_String),output_handle);
	for(x=0;x<256;x++)
	{
		construct_DAT_table(x);
	}
	/* Construct Instructions */
	construct_SCR_table();
	/* Construct Scanned Pictures !!! */
	/* Construct Pokes */
	fwrite(End_Of_Table,1,8,output_handle);
	for(x=0;x<256;x++)
	{
		append_DAT(x);
	}
	/* Append Instructions.txt */
	append_SCR();
	/* Append Scanned Pictures!!! */
	/* Append Pokes */
	fclose(output_handle);
	free(in_buffer);
	free(out_buffer);
}