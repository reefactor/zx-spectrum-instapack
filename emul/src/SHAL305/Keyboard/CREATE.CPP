#include <fstream.h>
#include <iostream.h>
#include <stdio.h>
#include <stdlib.h>

void Fatal(char* Mes0,char* Mes1="") {
	cout<<Mes0<<Mes1;
	exit(1);
}

void main() {
	ofstream StrC("KEYBOARD.CPP");
	if (!StrC) Fatal("Error create cpp file");
	StrC<<"unsigned char KeyHelpPict[]={";
	char Line[]="KEYBOARD.BMP";
	FILE *StrB=fopen(Line,"rb");
	if (!StrB) Fatal("Error open file: ",Line);
	unsigned char Buf[0x50];
	fread(Buf,0x36,1,StrB);
	unsigned StartBitMap=*(unsigned*)(Buf+0xA);
	for (int a=0;a<250;a++) {
		fseek(StrB,StartBitMap+(249-a)*0x50,SEEK_SET);
		fread(Buf,sizeof Buf,1,StrB);
		for (int i=0;i<sizeof Buf;i++) StrC<<((unsigned int)(Buf[i]))<<',';
		StrC<<"\\\n";
	}
	StrC<<"};\n";
	fclose(StrB);
}
