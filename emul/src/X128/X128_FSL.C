/******************************************/
/**                                      **/
/**         X128_FSL Portable File       **/
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

#ifdef MSDOS_SYSTEM

#ifndef __BORLANDC__

#include <direct.h>
#define EXTENDED_READDIR

#else
#include <dirent.h>
#endif

#else

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

#include <dirent.h>
#endif
#include <ctype.h>
#include <sys/stat.h>
#include <sys/types.h>

#define XDIR 1
#define XFILE 2
#define XDRIVE 3

#define NO_OF_SCR_MODE 2
char *scr_mode[NO_OF_SCR_MODE+1]=
{"Normal","Big"};

void itoa_temp(char *str_num, UC number); /* In X128_TAP.C */
void wtoa_temp(char *str_word, word number);

void scr_write_letter(UC x, UC y, UC attr, UC letter)
{
	word position;
	UC temp;

	SP_SCREEN[6144|(y*32)+x]=attr;
	position=spline[y*8]+x;
	for(temp=0;temp<8;temp++)
	{
		SP_SCREEN[position]=ROM[2][15616+((letter-' ')*8)+temp];
		position+=256;
	}
}

void scr_write_string(UC x, UC y, UC attr, char *stringy)
{
	while(stringy[0]!='\0')
	{
		scr_write_letter(x,y,attr,stringy[0]);
		stringy++;
		x++;
		if(x==32) {x=0;y++;}
	}
}

void scr_write_string_limit(UC x, UC y, UC attr, char *stringy, UC size)
{
	while((stringy[0]!='\0')&&(size))
	{
		size--;
		scr_write_letter(x,y,attr,stringy[0]);
		stringy++;
		x++;
		if(x==32) {x=0;y++;}
	}
}

void make_box(UC x1, UC y1, UC x2, UC y2, UC attr)
{
	UC x, y;

	for(x=x1;x<x2;x++)
	{
		for(y=y1;y<y2;y++)
		{
			scr_write_letter(x,y,attr,' ');
		}
	}
}

UC different_extension(char *select_string,char *filename)
{
	char *temp_str;
	word pos;
	UC len_of_ss;

	if(select_string[0]=='\0') return 1;
	pos=strlen(filename);
	len_of_ss=strlen(select_string);
	if(pos>len_of_ss)
	{
		pos-=len_of_ss;
	}
	else
	{
		return 1; /* It couldn't possibly have the extension */
	}
	temp_str=filename;
	temp_str+=pos;
	pos=0;
	while(pos<len_of_ss)
	{
		if(tolower(select_string[pos])!=tolower(temp_str[pos]))
		{
			return 1;
		}
		pos++;
	}
	return 0;
}

int sort_function( const void *a, const void *b)
{
   /*return( strcmp((char *)a,(char *)b) );*/
   int ret_val, pos, len_of_larger;
   char *aa, *bb;

   aa=(char *)a;
   bb=(char *)b;

   len_of_larger=strlen(aa);
   pos=strlen(bb);
   if(pos>len_of_larger) len_of_larger=pos;
   ret_val=pos=0;

   while((!ret_val)&&(pos<len_of_larger))
   {
	ret_val=tolower(aa[pos])-tolower(bb[pos]);
	pos++;
   }
   return ret_val;
}

sign16 get_dir(char *select_string_1, char *select_string_2, char *select_string_3)
{
  DIR *dir;
  struct dirent *ent;
  struct stat stbuf;
  char fullpath[MAXPATH];

	sign16 number_got;
	word pos, x;
	unsigned long useful;
	UC snipped, drv_num;

	int cut_point;

	number_got=snipped=0;
	pos=strlen(the_path);
	pos--;
#ifdef MSDOS_SYSTEM
	if(pos!=2)
	{
		the_path[pos]='\0'; /* Watcom */
		snipped=1;
	}
#else
	if(pos)
	{
		the_path[pos]='\0';
		snipped=1;
	}
#endif
	if ((dir = opendir(the_path)) == NULL)
	{
#ifndef NON_WINDOWS
		printf("Could not open directory\n");
		perror("Error:");
#endif
		return 32767;
	}
	if(snipped)
	{
#ifdef MSDOS_SYSTEM
		strcat(the_path,"\\"); /* Watcom */
#else
		strcat(the_path,"/");
#endif
	}

	while ((ent = readdir(dir)) != NULL)
	{
#ifndef EXTENDED_READDIR
		strcpy(FNAME+(number_got*UNIT_SIZE)+1,ent->d_name);
		number_got++;
#else
		if(ent->d_attr&_A_VOLID) continue;
		strcpy(FNAME+(number_got*UNIT_SIZE)+1,ent->d_name);
		if(ent->d_attr&_A_SUBDIR)
		{
			FNAME[number_got*UNIT_SIZE]=XDIR;
		}
		else
		{
			FNAME[number_got*UNIT_SIZE]=XFILE;
		}
		number_got++;
#endif
	}

	if (closedir(dir) != 0)
	{
#ifndef NON_WINDOWS
		printf("Warning:: Could not close directory\n");
		perror("Error:");
#endif
	}

#ifndef EXTENDED_READDIR
	strcpy(fullpath,the_path);
	cut_point=strlen(fullpath);
	for(pos=0;pos<number_got;pos++)
	{
		useful=pos*UNIT_SIZE;
		fullpath[cut_point]='\0';
		strcat(fullpath,FNAME+useful+1);
		stat((char *)fullpath,&stbuf);
		if((stbuf.st_mode & S_IFMT)==S_IFDIR)
		{
			FNAME[useful]=XDIR;
		}
		else
		{
			FNAME[useful]=XFILE;
		}
	}
#endif
	for(pos=0;pos<number_got;pos++)
	{
		useful=pos*UNIT_SIZE;
		if(FNAME[useful]==XDIR)
		{
			if(!(strcmp(FNAME+useful+1,".")))
			{
				for(x=pos;x<number_got;x++)
				{
					memcpy(FNAME+(x*UNIT_SIZE),FNAME+((x+1)*UNIT_SIZE),UNIT_SIZE);
				}
				number_got--;
				pos--;
			}
		}
		if(FNAME[useful]==XFILE)
		{
			if(different_extension(select_string_1,FNAME+useful+1)
			+different_extension(select_string_2,FNAME+useful+1)
			+different_extension(select_string_3,FNAME+useful+1)==2)
			{
				/* Do nothing */
			}
			else
			{
				/* move above stuff down one */
				for(x=pos;x<number_got;x++)
				{
					memcpy(FNAME+(x*UNIT_SIZE),FNAME+((x+1)*UNIT_SIZE),UNIT_SIZE);
				}
				number_got--;
				pos--;
			}
		}
	}
	qsort((void*)FNAME,number_got,UNIT_SIZE,sort_function);
#ifdef MSDOS_SYSTEM
	for(drv_num=1;drv_num<27;drv_num++)
	{
		if(drives[drv_num][0]!='\0')
		{
			FNAME[number_got*UNIT_SIZE]=XDRIVE;
			strcpy(FNAME+(number_got*UNIT_SIZE)+1,drives[drv_num]);
			number_got++;
		}
	}
#endif
	return number_got;
}

void scr_copy(void)
{
	old_screen=SP_SCREEN;
	memcpy(BUFFER,SP_SCREEN,6912);
	SP_SCREEN=BUFFER;
}

void scr_restore(void)
{
	SP_SCREEN=old_screen;
}

void help_scr(void)
{
	UC y, done, old_value, old_y;
	static UC value=0;
	char str_num[4], str_word[6];
	int adder;

	release_keyboard();
	scr_copy();

	make_box(2,1,30,22,79);
	old_y=y=4;
	scr_write_string(10,y-2,79,"HELP SCREEN");
	scr_write_string(5,y++,79,"F1 : This screen.");
	scr_write_string(5,y++,79,"F2 : Multiface 128.");
	scr_write_string(5,y++,79,"F3 : Select Mem.Model.");
	scr_write_string(5,y++,79,"F4 : Joystick Select.");
	scr_write_string(5,y++,79,"F5 : Load Z80/SNA/SLT.");
	scr_write_string(5,y++,79,"F6 : Save Z80/SLT File.");
	scr_write_string(5,y++,79,"F7 : Select TAP/VOC File.");
	scr_write_string(5,y,79,"Alter ULA Delay");
	itoa_temp(str_num,ULA_delay);
	scr_write_string(21,y++,79,str_num);
	scr_write_string(5,y++,79,"F8 : VOC Options.");
	scr_write_string(5,y++,79,"F10: Quit.");
	scr_write_string(5,y++,79,"F11: Sound Option");
	scr_write_string(5,y,79,"Keyboard Issue :");
	if(keyboard_issue==191)
	{
		scr_write_letter(22,y++,79,'3');
	}
	else
	{
		scr_write_letter(22,y++,79,'2');
	}
	scr_write_string(5,y,79,"Alter Screen Skip");
	scr_write_string(23,y,79,"1/");
	itoa_temp(str_num,frame_skip);
	scr_write_string(25,y++,79,str_num);
	scr_write_string(5,y,79,"Alter Slow Down");
	wtoa_temp(str_word,slow_down);
	scr_write_string(22,y++,79,str_word);
	scr_write_string(5,y+1,79,"PRESS ESCAPE TO RETURN.");
	scr_write_string(4,y+3,79,"x128 V0.5 By James McKay");
	RePaintScreen();

	done=0;
	old_value=value;
	while(!done)
	{
		scr_write_letter(4,value+old_y,121,'>');
		RePaintScreen();
		switch(fsl_extend_key())
		{
			case X128_ESCAPE:
				done=2;
				break;
			case X128_RETURN:
				adder=0;
				done=1;
				break;
			case X128_UP:
				scr_write_letter(4,value+old_y,79,' ');
				if(--value==255) value=13;
				break;
			case X128_DOWN:
				scr_write_letter(4,value+old_y,79,' ');
				value=(++value)%14;
				break;
			case X128_LEFT:
				adder=-1;
				if((value==7)||(value==12)||(value==13)) done=1;
				break;
			case X128_RIGHT:
				adder=+1;
				if((value==7)||(value==12)||(value==13)) done=1;
				break;
			case X128_PAGE_UP: case X128_KP_MINUS:
				adder=-10;
				if((value==7)||(value==12)||(value==13)) done=1;
				break;
			case X128_PAGE_DOWN: case X128_KP_PLUS:
				adder=+10;
				if((value==7)||(value==12)||(value==13)) done=1;
				break;
			default:
				break;
		}
	}
	if(done==2)
	{
		value=old_value;
		quit=DONT_QUIT; /* Not in main due to below */
	}
	else
	{
		switch(value)
		{
			case 0 : quit=QUIT_HELP;break;
			case 1 : quit=QUIT_NMI;break;
			case 2 : quit=QUIT_RESET;ret_to_help=1;break;
			case 3 : quit=QUIT_JOY;ret_to_help=1;break;
			case 4 : quit=QUIT_LOAD;ret_to_help=1;break;
			case 5 : quit=QUIT_SAVE;ret_to_help=1;break;
			case 6 : quit=QUIT_TAP;break;
			case 7 :
				ULA_delay+=adder;
				quit=QUIT_HELP;
				break;
			case 8 : quit=QUIT_VOC;break;
			case 9 : quit=QUIT_COMPLETELY;break;
			case 10: quit=QUIT_SOUND;ret_to_help=1;break;
			case 11:
				if(keyboard_issue==191)
				{
					keyboard_issue=255;
				}
				else
				{
					keyboard_issue=191;
				}
				quit=QUIT_HELP;
				break;
			case 12:
				frame_skip+=adder;
				quit=QUIT_HELP;
				break;
			case 13:
				slow_down+=adder;
				quit=QUIT_HELP;
				break;
			default:
				quit=DONT_QUIT;
				break;
		}
	}
	scr_restore();
	init_keyboard();
}

UC reset_spectrum(UC what_to_do)
{
	static UC stored_value=0;
	UC old_value, done, quit;

	if(what_to_do==255)
	{
		release_keyboard();
		scr_copy();
		make_box(2,3,30,19,79);
		scr_write_string(7,4,79,"MEMORY MODE SELECT");
		scr_write_string(6, 7,79,"Reset To 128K Mode");
		scr_write_string(6, 8,79,"Reset To 48K Mode");
		scr_write_string(6, 9,79,"128K Mode, no reset");
		scr_write_string(6,10,79,"48K Mode, no reset");
		scr_write_string(6,13,79,"Current Mode :");
		if(model_48)
		{
			scr_write_string(21,13,79,"48K.");
		}
		else
		{
			scr_write_string(21,13,79,"128K.");
		}
		scr_write_string(5,15,79,"PRESS ENTER TO SELECT.");
		scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
		done=quit=0;
		old_value=stored_value;
		while((!done)&&(!quit))
		{
			scr_write_letter(5,old_value+7,121,'>');
			RePaintScreen();
			switch(fsl_extend_key())
			{
				case X128_ESCAPE:
					quit=1;
					break;
				case X128_RETURN:
					done=1;
					break;
				case X128_UP:
					scr_write_letter(5,old_value+7,79,' ');
					if(--old_value==255) old_value=3;
					break;
				case X128_DOWN:
					scr_write_letter(5,old_value+7,79,' ');
					old_value=(++old_value)%4;
					break;
				default:
					break;
			}
		}
		scr_restore();
		init_keyboard();
		if(done)
		{
			stored_value=old_value;
			return old_value;
		}
		return 255;
	}
	else
	{
		return what_to_do;
	}
}

void joystick(void)
{
	UC old_joy_type, old_curs_caps, done, quit;

	release_keyboard();
	scr_copy();
	make_box(2,3,30,19,79);
	scr_write_string(8,4,79,"JOYSTICK SELECT");
	scr_write_string(5, 6,79,"Left/Right Caps On/Off");
	scr_write_string(6, 8,79,"Cursors Keys");
	if(curs_caps) scr_write_string(19,8,79,"(+Caps)");
	scr_write_string(6, 9,79,"Kempston (IN 31)");
	scr_write_string(6,10,79,"Sinclair 1 (1-5)");
	scr_write_string(6,11,79,"Sinclair 2 (6-0)");
	scr_write_string(5,15,79,"PRESS ENTER TO SELECT.");
	scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
	done=quit=0;
	old_joy_type=joy_type;
	old_curs_caps=curs_caps;
	while((!done)&&(!quit))
	{
		scr_write_letter(5,joy_type+8,121,'>');
		RePaintScreen();
		switch(fsl_extend_key())
		{
			case X128_ESCAPE:
				quit=1;
				break;
			case X128_RETURN:
				done=1;
				break;
			case X128_UP:
				scr_write_letter(5,joy_type+8,79,' ');
				if(--joy_type==255) joy_type=3;
				break;
			case X128_DOWN:
				scr_write_letter(5,joy_type+8,79,' ');
				joy_type=(++joy_type)%4;
				break;
			case X128_LEFT:
			case X128_RIGHT:
				curs_caps^=1;
				if(curs_caps)
				{
					scr_write_string(19,8,79,"(+Caps)");
				}
				else
				{
					scr_write_string(19,8,79,"       ");
				}
				break;
			default:
				break;
		}
	}
	if(quit)
	{
		joy_type=old_joy_type;
		curs_caps=old_curs_caps;
	}
	scr_restore();
	init_keyboard();
}

void show_bar(sign16 page_select)
{
	switch(FNAME[page_select*UNIT_SIZE])
	{
	case XDIR:
		scr_write_string_limit(FSL_WIN_START+3,1,121,FNAME+(page_select*UNIT_SIZE)+1,FNAME_SIZE);
		break;
	default:
		scr_write_string_limit(FSL_WIN_START+2,1,121,FNAME+(page_select*UNIT_SIZE)+1,FNAME_SIZE);
		break;
	}
}

void display_page(sign16 lowest, sign16 highest_found)
{
	UC x,y,spos;

	make_box(FSL_WIN_START,1,FSL_WIN_START+FSL_WIN_WIDTH,23,79);
	spos=1;
	if(lowest)
	{
		scr_write_string(13,0,48,"<MORE>");
	}
	else
	{
		scr_write_string(13,0,48,"<<<>>>");
	}
	if(lowest<highest_found-1)
	{
		scr_write_string(13,23,48,"<MORE>");
	}
	else
	{
		scr_write_string(13,23,48,"<<<>>>");
	}

	while((lowest<highest_found)&&(spos<23))
	{
		x=FSL_WIN_START+2;
		y=spos;
		switch(FNAME[lowest*UNIT_SIZE])
		{
		case XDIR   : /* Directory */
			scr_write_letter(x,y,88,'/');
			scr_write_string_limit(x+1,y,88,FNAME+(lowest*UNIT_SIZE)+1,FNAME_SIZE);
			break;
		case XFILE  : /* File */
			scr_write_string_limit(x,y,79,FNAME+(lowest*UNIT_SIZE)+1,FNAME_SIZE);
			break;
		case XDRIVE : /* Drive */
			scr_write_string_limit(x,y,40,FNAME+(lowest*UNIT_SIZE)+1,FNAME_SIZE);
			break;
		default:
			scr_write_string(x,y,7,"<ERROR>");
			break;
		}
		spos++;
		lowest++;
	}
}

void strip_file(char *stringy)
{
	UC special;
	word pos;

	pos=strlen(stringy);
	pos--;
	special=0;
	if((stringy[pos]=='/')||(stringy[pos]=='\\')) return;
	while((stringy[pos]!='/')&&(stringy[pos]!='\\')&&(!special))
	{
		stringy[pos]='\0';
		pos--;
#ifdef MSDOS_SYSTEM
		if(pos<=2)
		{
			special=1;
			stringy[1]='\0';
			strcat(stringy,":\\");
		}
#else
		if(!pos)
		{
			special=1;
			strcpy(stringy,"/");
		}
#endif
	}
}

void dot_dot(void)
{
	UC special;
	word pos, temp_len;
	char temp_str[MAXPATH];

	pos=strlen(the_path);
	pos--;
	special=0;
	strcpy(temp_str,"");
	if((the_path[pos]=='/')||(the_path[pos]=='\\')) pos--;
	while((the_path[pos]!='/')&&(the_path[pos]!='\\')&&(!special))
	{
		pos--;
		if((the_path[pos]=='/')||(the_path[pos]=='\\'))
		{
			strcpy(temp_str,(char *)the_path+pos+1);
		}
#ifdef MSDOS_SYSTEM
		if(pos<=2)
		{
			special=1;
			the_path[1]='\0';
			strcat(the_path,":\\");
		}
#else
		if(!pos)
		{
			special=1;
			strcpy(the_path,"/");
		}
#endif
	}
	temp_len=strlen(temp_str);
	if((temp_str[temp_len-1]=='/')||(temp_str[temp_len-1]=='\\'))
	{
		temp_str[temp_len-1]='\0';
	}
	strcpy(prev_dir,(char *)temp_str);
	if(!special) the_path[pos+1]='\0';
}

void dir_cat(char *addable)
{
	strcat(the_path,addable);
	strcat(the_path,"/");
}

UC input_string(UC y_i,char *title)
{
	UC x, y;
	word pos, ascii_val;

	scr_copy();
	strip_file(the_path);
	release_keyboard();

	make_box(0,y_i,32,y_i+13,79);
	scr_write_string(1,y_i+1,79,title);
	scr_write_string(0,y_i+3,79,the_path);
	y=strlen(the_path)/32;
	x=strlen(the_path)-(32*y);
	y+=y_i+3;
	scr_write_letter(x,y,127,' ');
	RePaintScreen();
	while(1)
	{
		ascii_val=fsl_asciiext_key();
		pos=strlen(the_path);
		switch(ascii_val)
		{
			case X128_ESCAPE:
				scr_restore();
				init_keyboard();
				return 1;
			case X128_BACKSPACE: case X128_DELETE:
				if(strlen(the_path)>0)
				{
					pos--;
					the_path[pos]='\0';
					scr_write_letter(x,y,79,' ');
					x--; if(x==255) {x=31;y--;}
					scr_write_letter(x,y,127,' ');
					RePaintScreen();
				}
				break;
			case X128_RETURN:
				scr_restore();
				init_keyboard();
				return 0;
			default:
				if(pos+1<MAXPATH)
				{
					the_path[pos]=(UC)(ascii_val&255);
					scr_write_letter(x,y,79,ascii_val&255);
					x++; if(x==32) {x=0;y++;}
					scr_write_letter(x,y,127,' ');
					RePaintScreen();
				}
				break;
		}
	}
}

void sound_options(void)
{
	static UC s_type=0;
	UC done, old_y, y, update;

	release_keyboard();
	scr_copy();
	done=quit=0;
	update=1;
	while((!done)&&(!quit))
	{
		if(update)
		{
			make_box(2,3,30,19,79);
			scr_write_string(9,4,79,"SOUND OPTIONS");
			old_y=y=6;
			scr_write_string(6,y,79,"Sound Is ");
			if(!all_sound_on)
			{
				scr_write_string(15,y++,79,"Off.");
			}
			else
			{
				scr_write_string(15,y++,79,"On. ");
			}
			if(!PSG_open)
			{
				scr_write_string(6,y++,79,"Create PSG File");
			}
			else
			{
				scr_write_string(6,y++,79,"Close PSG File");
			}
			scr_write_string(6,y,79,"White Noise Is ");
			if(!white_noise)
			{
				scr_write_string(21,y++,79,"Off.");
			}
			else
			{
				scr_write_string(21,y++,79,"On.");
			}
			scr_write_string(5,15,79,"PRESS ENTER TO SELECT.");
			scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");
			update=0;
		}
		scr_write_letter(5,s_type+old_y,121,'>');
		RePaintScreen();
		switch(fsl_extend_key())
		{
			case X128_ESCAPE:
				quit=1;
				break;
			case X128_RETURN:
				done=1;
				break;
			case X128_UP:
				scr_write_letter(5,s_type+old_y,79,' ');
				if(--s_type==255) s_type=2;
				break;
			case X128_DOWN:
				scr_write_letter(5,s_type+old_y,79,' ');
				s_type=(++s_type)%3;
				break;
			case X128_LEFT:
			case X128_RIGHT:
				switch(s_type)
				{
					case 0: all_sound_on^=1;break;
					case 2: white_noise^=1;break;
					default: break;
				}
				update=1;
				break;
			default:
				break;
		}
		if(done)
		{
			switch(s_type)
			{
				case 1:
					if(PSG_open)
					{
						fclose(p_handle);
						PSG_open=0;
					}
					else
					{
						scr_restore();
						init_keyboard();
						if(!(input_string(4,"Create PSG File")))
						{
							PSG_open=1;
							save_PSG();
						}
						release_keyboard();
						scr_copy();
					}
					break;
				default:
					break;
			}
			update=1;
			done=0;
		}
	}
	scr_restore();
	init_keyboard();
}

UC search_prev_dir(UC highest_found)
{
	word x;

	for(x=0;x<highest_found;x++)
	{
		if(!(strcmp(prev_dir,FNAME+(UNIT_SIZE*x)+1)))
		{
			return x;
		}
	}
	return 0;
}

sign16 find_letter(char *search_str,sign16 page_select,
		sign16 highest_found,UC *found)
{
	char other[MAXPATH];
	sign16 old_page_select, x;

	old_page_select=page_select;
	if(strlen(search_str)==1) page_select=0;
	while(page_select<highest_found)
	{
		if(FNAME[page_select*UNIT_SIZE]==XFILE)
		{
			strcpy(other,FNAME+(page_select*UNIT_SIZE)+1);
			for(x=0;x<strlen(other);x++) other[x]=tolower(other[x]);
			if(!(strncmp(search_str,other,strlen(search_str))))
			{
				*found=1;
				return page_select;
			}
		}
		page_select++;
	}
	*found=0;
	return old_page_select;
}

UC test_fsl(char *select_string_1, char *select_string_2, char *select_string_3)
{
	UC x, y, quit, chosen, reread, dotdot_prev;
	UC letter_search, found;
	sign16 highest_found, page_select, temp_index, temp_int;
	sign16 pos, temp_ps;
	char temp_str[MAXPATH], temp_str2[MAXPATH], old_prev_dir[MAXPATH];
	char search_str[MAXPATH];

	word ascii_val;

	dotdot_prev=0;
	if(!(FNAME=(UC *)malloc(FSL_BUFF)))
	{
		return 1; /* Can't Allocate Memory */
	}
	else
	{
	      memset(FNAME,0,FSL_BUFF);
	}
	release_keyboard();
	strcpy(temp_str,the_path);
	temp_index=global_index;

	strip_file(the_path);

	scr_copy();
	scr_write_string(0,0,79,select_string_1);
	scr_write_string(0,1,79,select_string_2);
	scr_write_string(0,2,79,select_string_3);
	quit=chosen=0;
	page_select=global_index;
	reread=2; /* Don't overwrite page_select */
	while((!quit)&&(!chosen))
	{
		if(reread)
		{
			temp_int=get_dir(select_string_1,select_string_2,select_string_3);
			if(temp_int!=32767)
			{
				highest_found=temp_int;
				if(dotdot_prev)
				{
					page_select=search_prev_dir(highest_found);
					reread=2;
				}
			}
			else
			{
				reread=2;
				strcpy(the_path,temp_str2);
				strcpy(prev_dir,old_prev_dir);
			}
			if(reread==1)
			{
				page_select=0;
			}
			reread=0;
		}
		display_page(page_select,highest_found);
		show_bar(page_select);
		RePaintScreen();
		letter_search=0;
		switch(ascii_val=fsl_asciiext_key())
		{
			case X128_UP:
				if(page_select) page_select--;
				break;
			case X128_DOWN:
				if(page_select<highest_found-1)
				{
					page_select++;
				}
				break;
			case X128_LEFT:
				break;
			case X128_RIGHT:
				break;
			case X128_PAGE_UP: case X128_KP_MINUS:
				page_select-=22;
				if(page_select<0) page_select=0;
				break;
			case X128_PAGE_DOWN: case X128_KP_PLUS:
				page_select+=22;
				if(page_select>=highest_found)
				{
					page_select=highest_found-1;
				}
				break;
			case X128_RETURN:
				strcpy(temp_str2,the_path);
				strcpy(old_prev_dir,prev_dir);
				dotdot_prev=0;
				switch(FNAME[page_select*UNIT_SIZE])
				{
				case XDIR   : /* Directory */
					if(!strcmp("..",FNAME+(page_select*UNIT_SIZE)+1))
					{
						dot_dot();
						dotdot_prev=1;
						reread=1;
					}
					else
					{
						if(strcmp(".",FNAME+(page_select*UNIT_SIZE)+1))
						{
							dir_cat(FNAME+(page_select*UNIT_SIZE)+1);
							reread=1;
						}
					}
					break;
				case XFILE  : /* File */
					chosen=1;
					strcat(the_path,FNAME+(page_select*UNIT_SIZE)+1);
					break;
				case XDRIVE : /* Drive */
					strcpy(the_path,FNAME+(page_select*UNIT_SIZE)+1);
					reread=1;
					break;
				default:
					break;
				}
				break;
			case X128_ESCAPE:
				quit=1;
				break;
			case X128_HOME:
				page_select=0;
				break;
			case X128_END:
				page_select=highest_found-1;
				break;
			default:
				/* Find letter */
				pos=strlen(search_str);
				search_str[pos]=tolower(ascii_val&255);
				search_str[pos+1]='\0';
				page_select=find_letter(search_str,page_select,highest_found,&found);
				if(!found)
				{
					letter_search=0; /* Failed */
				}
				else
				{
					letter_search=1;
				}
				break;
		}
		if(!letter_search)
		{
			strcpy(search_str,"");
		}
	}
	scr_restore();
	init_keyboard();
	free(FNAME);
	if(chosen)
	{
		global_index=page_select;
		return 0; /* Success */
	}
	global_index=temp_index;
	strcpy(the_path,temp_str);
	return 1; /* Aborted */
}
