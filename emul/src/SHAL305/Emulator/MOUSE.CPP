/**************************************************************************

Работа с мышью

**************************************************************************/

#include "main.hpp"
#include "mouse.hpp"

int MouseX=0x0;
int MouseY=0x0;
int MouseK=0x0;

unsigned MouseRateX=0x64;
unsigned MouseRateY=0x64;

static unsigned StRatX;
static unsigned StRatY;

// Присутствие мыши
static unsigned char MousePresent=0x00;

/* Установка скорости перемещения мыши */
static void MouseSetSpeed(unsigned RateX,unsigned RateY) {
	if (!MousePresent) return;
	ri.bx=RateX;
	ri.cx=RateY;
	ri.ax=0x001A;
	IntRealMode(0x33);
}

/* Проверка наличия и инициализация мыши */
void MouseInit() {
	ri.ax=0x0000;
	IntRealMode(0x33);
	if (ri.ax!=(unsigned short)0xFFFF) return;
	if (MousePresent) return;
	MousePresent=0x01;
	ri.ax=0x001B;
	IntRealMode(0x33);
	StRatX=ri.bx;
	StRatY=ri.cx;
}

/* Установка первоначальной скорости */
void MouseSetSpdDef() {
	if (!MousePresent) return;
	MouseSetSpeed(StRatX,StRatY);
}

/* Установка позиции курсора */
void MouseSet(unsigned CoorX,unsigned CoorY) {
	if (!MousePresent) return;
	ri.ax=0x0004;
	ri.cx=CoorX;
	ri.dx=CoorY;
	IntRealMode(0x33);
}

/* Включение курсора мыши */
void MouseOn() {
	if (!MousePresent) return;
	ri.ax=0x0001;
	IntRealMode(0x33);
}

/* Выключение курсора мыши */
void MouseOff() {
	if (!MousePresent) return;
	ri.ax=0x0002;
	IntRealMode(0x33);
}

/* Опрос мыши */
void Mouse() {
	if (!MousePresent) return;
	ri.ax=0x0003;
	IntRealMode(0x33);
	MouseX=ri.cx;
	MouseY=ri.dx;
	MouseK=ri.bx;
}

void MouseSetSpec() {
	if (!(unsigned char)((unsigned char)MouseType&MousePresent)) return;
	ri.ax=0x0007;
	ri.cx=0x0000;
	ri.dx=0x09FF;
	IntRealMode(0x33);
	ri.ax=0x0008;
	ri.cx=0x0000;
	ri.dx=0x04FF;
	IntRealMode(0x33);
	MouseSet(0x200+MouseKempX,0x200+MouseKempY);
	MouseSetSpeed(StRatX*MouseRateX/0x64,StRatY*MouseRateY/0x64);
}
