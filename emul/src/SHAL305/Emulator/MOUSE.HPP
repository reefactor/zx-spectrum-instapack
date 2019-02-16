/**************************************************************************

Работа с мышью

**************************************************************************/

extern "C" int MouseX;
extern "C" int MouseY;
extern "C" int MouseK;

extern "C" unsigned MouseRateX;
extern "C" unsigned MouseRateY;

extern "C" unsigned char MouseKempX;
extern "C" unsigned char MouseKempY;

/* Проверка наличия и инициализация мыши */
extern "C" void MouseInit();

/* Установка первоначальной скорости */
extern "C" void MouseSetSpdDef();

/* Установка позиции курсора */
extern "C" void MouseSet(unsigned CoorX,unsigned CoorY);
#pragma aux MouseSet parm [eax][ebx]

/* Включение курсора мыши */
extern "C" void MouseOn();

/* Выключение курсора мыши */
extern "C" void MouseOff();

/* Опрос мыши */
extern "C" void Mouse();

extern "C" void MouseSetSpec();
