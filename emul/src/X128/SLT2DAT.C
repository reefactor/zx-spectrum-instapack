/******************************************/
/**                                      **/
/**         SLT2DAT.C DAT Splitter       **/
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
char *in_buffer, *out_buffer;

long DAT_length[256];
long SCR_length;

FILE *input_handle;

UC acorn_form=0;

/* Set this to 1 if compiling under DOS */
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

word decompress_DAT(word in_length)
{
	unsigned long in_index, out_index;
	UC value, value2, poker, loopr, x;

	in_index=out_index=0;
	do{
		value=in_buffer[in_index++];
		if(value==237) /* is ED... */
		{
			value2=in_buffer[in_index++];
			if (value2==237) /* is ED ED code */
			{
				loopr=in_buffer[in_index++];
				poker=in_buffer[in_index++];
				for(x=0;x<loopr;x++)
				{
					out_buffer[out_index++]=poker;
				}
			}
			else
			{
				out_buffer[out_index++]=value; /* is ED ?? */
				out_buffer[out_index++]=value2;
			}
		}
		else
		{
			out_buffer[out_index++]=value; /* not ED... */
		}
		if(out_index>65535) /* As out_buffer is 65535 */
		{
			printf("V2/V3 DECOMP ERROR\n");
			return 0; /* fail */
		}
	} while (in_index<in_length);
	return (word)out_index;  /* Success! */
}

void write_SCR(void)
{
	char temp_str[MAXPATH];
	word in_length, temp_word;
	FILE *temp_handle;

	in_length=(word)SCR_length;
	if(!in_length) return;
	clean_buffers();
	fread(in_buffer,1,in_length,input_handle);

	strcpy(temp_str,output_name);
	strcat(temp_str,".scr");
	if(!(temp_handle = fopen(temp_str,"wb")))
	{
		perror("Error:");
		printf("Warning: Could not create %s\n",temp_str);
		return;
	}
	temp_word=decompress_DAT(in_length);
	fwrite(out_buffer,1,temp_word,temp_handle);
	fclose(temp_handle);
}

void write_DAT(UC level_num)
{
	char temp_str[MAXPATH];
	word in_length, temp_word;
	FILE *temp_handle;

	in_length=(word)DAT_length[level_num];
	if(!in_length) return;
	clean_buffers();
	fread(in_buffer,1,in_length,input_handle);

	if(acorn_form)
	{
		strcpy(temp_str,"");
	}
	else
	{
		strcpy(temp_str,output_name);
	}
	add_level_num((char *)temp_str,level_num);
	if(!acorn_form) strcat(temp_str,".dat");
	if(!(temp_handle = fopen(temp_str,"wb")))
	{
		perror("Error:");
		printf("Warning: Could not create %s\n",temp_str);
		return;
	}
	temp_word=decompress_DAT(in_length);
	fwrite(out_buffer,1,temp_word,temp_handle);
	fclose(temp_handle);
}

void process_table(long feof_marker)
{
	word x, data_type;

	for(x=0;x<256;x++) DAT_length[x]=0;
	SCR_length=0;
	while(ftell(input_handle)!=feof_marker)
	{
		fread(in_buffer,1,8,input_handle);
		data_type=(UC)in_buffer[0]|((UC)in_buffer[1]<<8);
		switch(data_type)
		{
			case 0 :
				return;
			case 1 :
				DAT_length[in_buffer[2]]=(UC)in_buffer[7];
				DAT_length[in_buffer[2]]<<=8;
				DAT_length[in_buffer[2]]|=(UC)in_buffer[6];
				DAT_length[in_buffer[2]]<<=8;
				DAT_length[in_buffer[2]]|=(UC)in_buffer[5];
				DAT_length[in_buffer[2]]<<=8;
				DAT_length[in_buffer[2]]|=(UC)in_buffer[4];
				break;
			case 3 :
				SCR_length=(UC)in_buffer[7];
				SCR_length<<=8;
				SCR_length|=(UC)in_buffer[6];
				SCR_length<<=8;
				SCR_length|=(UC)in_buffer[5];
				SCR_length<<=8;
				SCR_length|=(UC)in_buffer[4];
				break;
			default:
				break; /* No others yet defined */
		}
	}
}

long find_end_of_z80(void)
{
	word temp_word;
	UC done;

	fread(in_buffer,1,32,input_handle);
	temp_word=in_buffer[30]|(in_buffer[31]<<8);
	fread(in_buffer,1,temp_word,input_handle);
	/* Now at memory blocks */
	done=0;
	while(!done)
	{
		fread(in_buffer,1,3,input_handle);
		temp_word=(UC)in_buffer[0]|((UC)in_buffer[1]<<8);
		if((!temp_word)&&(!in_buffer[2]))
		{
			done=1; /* Test for ID_000 */
			fseek(input_handle,-3,SEEK_CUR);
		}
		else
		{
			fseek(input_handle,temp_word,SEEK_CUR);
		}
	}
	return ftell(input_handle);
}

void process_and_copy_z80(void)
{
	char temp_str[MAXPATH];

	FILE *temp_handle;
	long temp_long;

	strcpy(temp_str,output_name);
	strcat(temp_str,".z80");

	if(!(temp_handle = fopen(temp_str,"wb")))
	{
		perror("Error:");
		printf("Could not create output file %s\n",temp_str);
		return;
	}
	/* Get end of Z80 file */
	temp_long=find_end_of_z80();

	fseek(input_handle,temp_long,SEEK_SET); /* Check ID String */
	fread(in_buffer,1,3,input_handle);
	if((in_buffer[0]|in_buffer[1]|in_buffer[2]))
	{
		fclose(input_handle);
		fclose(temp_handle);
		free(in_buffer);
		free(out_buffer);
		printf("This is not a SLT file, ID_000 failed!\n");
		exit(1);
	}
	fread(in_buffer,1,strlen(ID_String),input_handle);
	in_buffer[strlen(ID_String)]='\0';
	if(strcmp(in_buffer,ID_String))
	{
		fclose(input_handle);
		fclose(temp_handle);
		free(in_buffer);
		free(out_buffer);
		printf("This is not a SLT file, ID_String failed!\n");
		exit(1);
	}

	fseek(input_handle,0,SEEK_SET);
	while(temp_long>32767)
	{
		fread(in_buffer,1,32768,input_handle);
		fwrite(in_buffer,1,32768,temp_handle);
		temp_long-=32768;
	}
	if(temp_long>0)
	{
		fread(in_buffer,1,(word)temp_long,input_handle);
		fwrite(in_buffer,1,(word)temp_long,temp_handle);
	}
	fclose(temp_handle);
}

void main(int argc, char *argv[])
{
	char temp_str[MAXPATH];
	char temp_str2[MAXPATH];
	long temp_long;
	word x;

	printf("SLT2DAT DAT splitter by James McKay\n");
	if(argc==1)
	{
		printf("\nThis utility splits the SLT into a Z80 and\n");
		printf(" multiple DAT files and loading SCR.\n");
		printf("\nUsage: SLT2DAT <input.slt> <output.z80> [/dos]\n");
		printf("/dos forces MS-DOS style filenames.\n");
		printf("/acorn makes utility look for a DAT that just has");
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
	      exit(1);
	}
	else
	{
	      memset(out_buffer,0,0xFFFF);
	}
	strcpy(temp_str,input_name);
	strcpy(temp_str2,input_name);
	strcat(temp_str,".SLT");
	strcat(temp_str2,".slt");
	if(!(input_handle = fopen(temp_str,"rb")))
	{
		if(!(input_handle = fopen(temp_str2,"rb")))
		{
			perror("Error:");
			printf("\nCould not open input file %s.\n",temp_str);
			printf("Or %s\n",temp_str2);
			free(in_buffer);
			free(out_buffer);
			exit(1);
		}
	}
	fseek(input_handle,0,SEEK_END); /* Something is not quite right */
	temp_long=ftell(input_handle);  /* With feof() */
	fseek(input_handle,0,SEEK_SET);

	process_and_copy_z80();
	fread(in_buffer,1,6,input_handle); /* Skip ID_000 & ID_String */
	process_table(temp_long);
	for(x=0;x<256;x++)
	{
		write_DAT(x);
	}
	/* write instructions */
	write_SCR();
	/* write scanned pictures !!! */
	/* write pokes */
	fclose(input_handle);
	free(in_buffer);
	free(out_buffer);
}