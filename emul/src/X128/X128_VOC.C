unsigned long line_counter, VOC_block_len;
unsigned long no_of_t_before_next;

unsigned long last_t_VOC_in;

UC threshold=30;
UC no_of_t_vary=0;

/* UC VOC_file_in_open, VOC_file_out_open=0, VOC_paused=1; */
/* Moved up for globalness */

word sample_rate_in;
FILE *v_in_handle, *v_out_handle; /* Wishful thinking? */
char *VOC_head="Creative Voice File"; /* Forget the 0x1A */

void process_block(void)
{
	UC block_type, temp;

	fread(&block_type,1,1,v_in_handle);
	switch(block_type)
	{
		case 0 :
			/* Window, end of file message */
			fclose(v_in_handle);
			VOC_file_in_open=0;
			break;
		case 1 :
			fread(BUFFER,1,3,v_in_handle);
			VOC_block_len=(UC)BUFFER[2];VOC_block_len<<=8;
			VOC_block_len|=(UC)BUFFER[1];VOC_block_len<<=8;
			VOC_block_len|=(UC)BUFFER[0];
			fread(BUFFER,1,2,v_in_handle);
			sample_rate_in=1000000L/(256-(UC)BUFFER[0]);
			temp=0-(UC)BUFFER[0];
			no_of_t_before_next=(temp*7)/2;
			no_of_t_before_next+=(signed char)no_of_t_vary;
			VOC_block_len-=2;
			if((UC)BUFFER[1]!=0)
			{
				/* Error, packed data */
				fclose(v_in_handle);
				VOC_file_in_open=0;
			}
			break;
		default:
			/* Error, cannot handle other blocks */
			fclose(v_in_handle);
			VOC_file_in_open=0;
			break;
	}
}

void open_VOC_input_file(void)
{
	unsigned long start_of_data;

	if(VOC_file_in_open) fclose(v_in_handle);
	if(!(v_in_handle = fopen(the_path,"rb")))
	{
		perror("Error:"); /* Surely not possible with FSL? */
		printf("File %s not present\n",the_path);
		VOC_file_in_open=0;
		return;
	}
	fread(BUFFER,1,0x19,v_in_handle);
	BUFFER[0x13]=0;
	if(strcmp(VOC_head,BUFFER))
	{
		/* I should do a window really... */
		printf("File %s is not a real VOC file!!!\n",the_path);
		VOC_file_in_open=0;
		return;
	}
	start_of_data=(UC)BUFFER[0x15];start_of_data<<=8;
	start_of_data|=(UC)BUFFER[0x14];
	fseek(v_in_handle,start_of_data,SEEK_SET);
	VOC_file_in_open=1;
	VOC_paused=0;

	process_block(); /* Work out sample rate */

	last_t_VOC_in=line_counter=0;

}

UC return_next_VOC_bit(void)
{
	static UC last_bit=0;
	UC DSP_byte;
	unsigned long bytes_passed, time_passed, current_t;

	current_t=(line_counter*t_states_per_line)+t_state;
	time_passed=current_t-last_t_VOC_in;
	bytes_passed=time_passed/no_of_t_before_next;
	if(bytes_passed)
	{
		while(bytes_passed)
		{
			if(!VOC_block_len) process_block();
			if(VOC_file_in_open) fread(&DSP_byte,1,1,v_in_handle);
			VOC_block_len--;
			bytes_passed--;
		}
		if(DSP_byte>(128+threshold))
		{
			last_bit=64;
		}
		if(DSP_byte<(128-threshold))
		{
			last_bit=0;
		}
		last_t_VOC_in=current_t;
	}
	return last_bit;
}

void VOC_options(void)
{
	static UC pos=0;
	UC done;
	char str_num[4];

	release_keyboard();
	scr_copy();

	make_box(2,3,30,19,79);
	scr_write_string(10,4,79,"VOC OPTIONS");
	scr_write_string(6,10,79,"Threshold :");
	scr_write_string(6,11,79,"No_of_t vary :");
	scr_write_string(5,17,79,"PRESS ESCAPE TO RETURN.");

	done=0;
	while(!done)
	{
		scr_write_letter(5,pos+10,121,'>');
		scr_write_string(18,10,79,"   ");
		itoa_temp(str_num,threshold);
		scr_write_string(18,10,79,str_num);
		scr_write_string(21,11,79,"   ");
		itoa_temp(str_num,no_of_t_vary);
		scr_write_string(21,11,79,str_num);
		RePaintScreen();
		switch(fsl_extend_key())
		{
			case X128_ESCAPE:
				done=2;
				break;
			case X128_UP:
				scr_write_letter(5,pos+10,79,' ');
				if(--pos==255) pos=1;
				break;
			case X128_DOWN:
				scr_write_letter(5,pos+10,79,' ');
				pos=(++pos)%2;
				break;
			case X128_LEFT:
				switch(pos)
				{
					case 0: threshold--;break;
					case 1: no_of_t_vary--;break;
					default: break;
				}
				break;
			case X128_RIGHT:
				switch(pos)
				{
					case 0: threshold++;break;
					case 1: no_of_t_vary++;break;
					default: break;
				}
				break;
			default:
				break;
		}
	}
	scr_restore();
	init_keyboard();
}
