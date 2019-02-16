{$I-,G+}

unit sgraph;
interface

const
     v640x400x256=  $100;
     v640x480x256=  $101;
     v800x600x256=  $103;
     v1024x768x256= $105;
     v1280x1024x256=$107;
     v320x200x256=  $13;
     getmaxcolor  = 255;
     grok         = 0;
     grnoinit     = 1;
     grnofont     = 2;
     grnopcx      = 3;

     Black        = 0;
     Blue         = 1;
     Green        = 2;
     Cyan         = 3;
     Red          = 4;
     Magenta      = 5;
     Brown        = 6;
     LightGray    = 7;
     DarkGray     = 8;
     LightBlue    = 9;
     LightGreen   = 10;
     LightCyan    = 11;
     LightRed     = 12;
     LightMagenta = 13;
     Yellow       = 14;
     White        = 15;

procedure setrgbpalette (n:word;c1,c2,c3:byte);      {r,g,b}
					       {выставляет в соответствие
						одному из цветов палитры
						цвет из системной палитры}

procedure getrgbpalette (n:word;var c1,c2,c3:byte);  {r,g,b}
					       {выдает цвет системной
						палитры соответствующий
						цвету палитры}

procedure getallpalette(l:pointer);            {записывает в переменную
						типа pointer (768 байт)
						текущую палитру}

procedure setallpalette(l:pointer);            {записывает из переменной
						типа pointer (768 байт)
						цвета в текущую палитру}

procedure setEGApalette;                       {устанавливает первые 16
                                                цветов палитры соответствую-
                                                щими 16-цветному режиму}

procedure fadedown(l:pointer;v:byte);          {декрементирует все цвета
						палитры в переменной l
						(pointer 768 байт)
						на v едениц}

procedure fadeup(l:pointer;v:byte);            {инкрементирует все цвета
						палитры в переменной l
						(pointer 768 байт)
						на v едениц}

procedure initgraph(m:word);                   {инициализирует графический
						режим . параметры:
                                                v320x200x256
						v640x400x256
						v640x480x256
						v800x600x256
						v1024x768x256
                                                v1280x1024x256
						(графические режимы)}

procedure setfontbufsize(bsz:word);            {устанавливает новый размер
                                                буфера для шрифтов.По умолча
                                                нию он 62500 байт}

procedure setpcxbufsize(psz:word);             {устанавливает размер буфера
                                                для pcx файла(кэш диска).
                                                По умолчанию он 1024 байта}
procedure setgraphmode(m:word);                {то же , но после выхода
						из графического в тек-
						стовый режим}

function getgraphmode:word;                    {выдает номер графического
						режима}

procedure restorecrtmode;                      {восстанавливает бывший
						перед initgraph текстовый
						режим}

procedure closegraph;                          {закрывает графический
						 режим}

procedure setvisualpage(pg:word);              {устанавливает видимую
						видеостраницу}

procedure setactivepage(pg:word);              {устанавливает активную
						видеостраницу}

procedure scroll(sx,sy:word);                  {сдвигает экран вверх
						на sy,и влево на sx
						точек}

function getmaxx:word;                         {выдает координату самой
						правой точки}

function getmaxy:word;                         {выдает координату самой
						нижней точки}

procedure LoadPcx(nx,ny:integer;NFile:string); {загружает в активную
						видеостраницу pcx файл
						начиная с координаты nx,ny
						nfile-имя pcx ф-ла}

function installuserfont(s:string):byte;    {вставляет новый шрифт в
						реестр.возвращает номер
						шрифта}

procedure settextstyle(nf,dr,sizf:byte);

procedure setusercharsize (mulx,divx,muly,divy:word);

function textheight(sssss:string):word;

function textwidth(sssss:string):word;

procedure TextXY(x,y:word; txt:string);
procedure outtextxy(x,y:word;s:string);

procedure putpixel(x,y,col:word);

function getpixel(x,y:word):word;

procedure ellipse (okx,oky,olang1,opang1,okrx,okry:word);

procedure fillellipse(flx,fly,flxr,flyr,col3:word);
                                                  {рисует еллипс текущим
                                                   цветом и закрашивает его
                                                   цветом col3}


procedure arc (arx,ary,stangle,endangle,radius:word);

procedure sector(sex,sey,stangle,endangle,xradius,yradius:word);

procedure pieslice(sex,sey,stangle,endangle,radius,col3:word);
                                                  {рисует сектор текущим
                                                   цветом и закрашивает его
                                                   цветом col3}


procedure circle (ox,oy,radius:word);

procedure floodfill(x6,y6,color6:word);          {закрашивает область
					      текущим цветом}

procedure floodfill2(x6,y6:word);            {закрашивает область одного
					      цвета текущим цветом}
procedure line(xa,ya,mx,my:word);

procedure rectangle(xa,ya,mx,my:word);

procedure bar(xa,ya,mx,my:word);

function imagesize(xa,ya,xm,ym:word):word;

procedure getimage(xa,ya,mx,my:word;p:pointer);
					    {действует также как и в модуле
					    graph,но указывается не P^, а
					    именно P }

procedure putimage(xa,ya:word;p:pointer);   {действует также как и в модуле
					    graph,но указывается не P^, а
					    именно P а стиль всегда
					    normalput}

procedure putsprite(xa,ya:word;p:pointer);  {действует также как и в модуле
					    graph,но указывается не P^, а
					    именно P а стиль всегда
					    normalput и не выводит пикселы
					    с 0 цветом}

procedure setbkcolor(c:word);               {аналогична процедуре setcolor,
                                             но устанавливает цвет только
                                             для cleardevice(очистка екрана)}


procedure setcolor(c:word);                 {Устанавливает цвет для
                                             графических процедур,в том
                                             числе и заливки.В качестве
                                             цвета могут быть константы
                                             типа red,green,yellow,white
                                             и т.д.(они устанавливают
                                             корректный цвет только после
                                             установки палитры процедурой
                                             setEGApalette)}

procedure cleardevice;


var graphresult:byte;
var x1,y1,x7,y7,c5,c1,rx,ry,cbank,bkcolor,lsz,hsz,yres,xres:word;
var sha:char;
var nfont:array[0..1024] of byte;
var j:double;
var dr1,dr2,oldmode:byte;
var i,i1,j1:integer;
var col:array[0..768] of byte;
var bufpos,actpl,actph,x2,y2,x3,y3,c2:word;
var ocx,ocy,orx,vidp,actp,segd,ofsd,color,razmx,razmy,vs1,flc:word;
var ory,olang,opang:real;       {ellipse}
var k:array[0..8] of byte;
var ch1{число символов},fs{первый символ}:byte;
var ukt{указ на табл код}:word;
var uk:array[0..255] of word;{таблица смещений}
var sh:array[0..255] of byte;{таблица ширин}
var vs:byte;{высота символов}
var pot:^pointer;         {указатель на таблицу символов}
var ufont:byte;{указатель на номер шрифта}
var mmx,mmy,mmx1,mmy1,rrx,rry,potsz,bufsz:word;
var EGApal:array[0..47] of byte;
var buf:^pointer;
var umas:array[0..2400] of word;
var endm,startm,fc,fseg1,fofs1,muk,tseg,tofs:word;

implementation
uses dos;


procedure setfontbufsize(bsz:word);
begin
freemem(pot,potsz);getmem(pot,bsz);potsz:=bsz;
end;

procedure setpcxbufsize(psz:word);
begin
freemem(buf,bufsz);getmem(buf,psz);bufsz:=psz;
end;

procedure initgraph(m:word);assembler;
asm
     mov graphresult,0;
     mov ah,0fh;
     int 10h;
     mov oldmode,al;
     cmp m,107h;
     jnz @igs;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,1280;
     mov ry,1024;
     mov hsz,14;
     mov lsz,0;
     jmp @igy;

@igs:cmp m,13h;
     jnz @iga;
     mov ah,00h;
     mov al,13h;
     int 10h;
     mov rx,320;
     mov ry,200;
     mov hsz,0;
     mov lsz,64000;
     jmp @igy;
@iga:cmp m,100h;
     jnz @igb;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,640;
     mov ry,400;
     mov hsz,3;
     mov lsz,59392;
     jmp @igy;
@igb:cmp m,101h;
     jnz @igc;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,640;
     mov ry,480;
     mov hsz,4;
     mov lsz,45056;
     jmp @igy;
@igc:cmp m,103h;
     jnz @igd;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,800;
     mov ry,600;
     mov hsz,7;
     mov lsz,21248;
     jmp @igy;
@igd:cmp m,105h;
     jnz @ige;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,1024;
     mov ry,768;
     mov hsz,12;
     mov lsz,0;
     jmp @igy;
@ige:mov graphresult,1h;
     jmp @igz;
@igy:mov ax,4f05h;
     mov bx,0h;
     mov dx,0h;
     int 10h;
     mov cbank,0;
     mov bx,offset nfont;
     mov word ptr [bx],'il';
     mov word ptr [bx+2],'tt';
     mov word ptr [bx+4],'is';
     mov word ptr [bx+6],'pm';
     mov word ptr [bx+8],'il';
     mov word ptr [bx+10],'tt';
     mov word ptr [bx+12],'rt';
     mov word ptr [bx+14],'pi';
     mov word ptr [bx+16],'og';
     mov word ptr [bx+18],'ht';
     mov ufont,5h;
     mov actph,0;
     mov actpl,0;
@igz:
end;

procedure setcolor(c:word);assembler;
asm
mov ax,c;
mov color,ax;
end;

procedure setgraphmode(m:word);assembler;
asm
     mov ah,00h;
     mov al,03h;
     int 10h;
     mov graphresult,0;
     cmp m,13h;
     jnz @iga;
     mov ah,00h;
     mov al,13h;
     int 10h;
     mov rx,320;
     mov ry,200;
     mov hsz,0;
     mov lsz,64000;
     jmp @igy;
@iga:cmp m,100h;
     jnz @igb;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,640;
     mov ry,400;
     mov hsz,3;
     mov lsz,59392;
     jmp @igy;
@igb:cmp m,101h;
     jnz @igc;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,640;
     mov ry,480;
     mov hsz,4;
     mov lsz,45056;
     jmp @igy;
@igc:cmp m,103h;
     jnz @igd;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,800;
     mov ry,600;
     mov hsz,7;
     mov lsz,21248;
     jmp @igy;
@igd:cmp m,105h;
     jnz @ige;
     mov ax,4f02h;
     mov bx,m;
     int 10h;
     mov rx,1024;
     mov ry,768;
     mov hsz,12;
     mov lsz,0;
     jmp @igy;
@ige:mov graphresult,1h;
     jmp @igz;
@igy:mov ax,4f05h;
     mov bx,0h;
     mov dx,0h;
     int 10h;
     mov cbank,0;
@igz:
end;

procedure restorecrtmode;assembler;
asm
    mov ax,0;
    mov al,oldmode;
    int 10h;
end;

function getgraphmode:word;assembler;
asm
  mov ax,4f03h;
     int 10h;
     mov ax,bx;
end;

procedure closegraph;assembler;
asm
   call restorecrtmode;
end;

function getmaxx:word;assembler;
asm
   mov ax,rx;
   dec ax;
end;

function getmaxy:word;assembler;
asm
   mov ax,ry;
   dec ax;
end;

procedure scroll(sx,sy:word);assembler;
asm
mov ax,4f07h
mov bx,0h
mov cx,sx;
mov dx,sy;
add dx,actp;
int 10h;
end;

procedure setvisualpage(pg:word);assembler;
asm
    mov ax,ry;
    mul pg;
    mov dx,ax;
    mov vidp,ax;
    mov ax,4f07h;
    mov bx,0h;
    mov cx,0h;
    int 10h;
end;

procedure setactivepage(pg:word);assembler;
asm
mov ax,ry;
mov bx,pg;
mul bx;
mov actp,ax;
mov ax,lsz;
mul bx;
mov actpl,ax;
mov ax,hsz;
mul bx;
add ax,dx;
mov actph,ax;
end;

procedure putpix;assembler;
asm
    mov di,c1;
    mov ax,ry;
    cmp ax,y1;
    jna @@b;
    mov ax,rx;
    cmp ax,x1;
    jna @@b;
    mul y1;
    add ax,x1;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    jz @@a;
    mov ax,4f05h;
    mov bx,0h;
    int 10h;
    mov cbank,dx;
@@a:mov dx,sega000;
    mov bx,ds;
    mov ds,dx;
    mov ax,di;
    mov si,cx;
    mov [si],al;
    mov ds,bx;
@@b:

end;
procedure putpixel(x,y,col:word);assembler;
asm
    mov di,col;
    mov ax,ry;
    cmp ax,y;
    jna @@b;
    mov ax,rx;
    cmp ax,x;
    jna @@b;
    mul y;
    add ax,x;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    jz @@a;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
@@a:mov dx,sega000;
    mov bx,ds;
    mov ds,dx;
    mov ax,di;
    mov si,cx;
    mov [si],al;
    mov ds,bx;
@@b:

end;

function getpixel(x,y:word):word;assembler;
asm
    mov ax,ry;
    cmp ax,y;
    jna @@b;
    mov ax,rx;
    cmp ax,x;
    jna @@b;
    mul y;
    add ax,x;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    jz @@a;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
@@a:mov dx,sega000;
    mov bx,es;
    mov es,dx;
    mov si,cx;
    mov al,[es:si];
    mov ah,00h;
    mov es,bx;
@@b:
end;

procedure getpix;assembler;
asm
    mov ax,rx;
    mul y2;
    add ax,x2;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    jz @@a;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
@@a:mov dx,sega000;
    mov bx,es;
    mov es,dx;
    mov si,cx;
    mov cl,[es:si];
    mov ch,0h;
    mov c1,cx;
    mov es,bx;
@@b:
end;

procedure ellipse (okx,oky,olang1,opang1,okrx,okry:word);
var x22,y22:word;
begin
olang:=olang1/57.29578;opang:=(opang1+1)/57.29578;
ocx:=okx;ocy:=oky;orx:=trunc(((opang-olang)*((okrx+okry)))/6.2831853);
ory:=(opang-olang)/(orx);
x22:=trunc(int(cos (olang)*okrx)+ocx);
y22:=trunc(ocy-int(sin(olang)*okry));
for i:=0 to trunc(orx/2)+1 do begin
x1:=trunc(int(cos ((i*2)*ory+olang)*okrx)+ocx);
y1:=trunc(ocy-int(sin((i*2)*ory+olang)*okry));
if (x22<>x1) or (y22<>y1) then line (x22,y22,x1,y1);
x22:=x1;y22:=y1;
end;
end;

procedure fillellipse(flx,fly,flxr,flyr,col3:word);
var col4:word;
begin
ellipse(flx,fly,0,359,flxr,flyr);
col4:=color;color:=col3;
floodfill(flx,fly,c1);
color:=col4;
end;

procedure arc (arx,ary,stangle,endangle,radius:word);
begin
ellipse(arx,ary,stangle,endangle,radius,radius);
end;

procedure sector(sex,sey,stangle,endangle,xradius,yradius:word);
begin
ellipse(sex,sey,stangle,endangle,xradius,yradius);
x1:=trunc(int(cos (stangle/57.29578)*xradius)+sex);
y1:=trunc(sey-int(sin(stangle/57.29578)*yradius));
x2:=trunc(int(cos ((endangle+1)/57.29578)*xradius)+sex);
y2:=trunc(sey-int(sin((endangle+1)/57.29578)*yradius));
line (sex,sey,x1,y1); line (sex,sey,x2,y2);
end;

procedure pieslice(sex,sey,stangle,endangle,radius,col3:word);
var col4:word;
begin
ellipse(sex,sey,stangle,endangle,radius,radius);
x1:=trunc(int(cos (stangle/57.29578)*radius)+sex);
y1:=trunc(sey-int(sin(stangle/57.29578)*radius));
x2:=trunc(int(cos ((endangle+1)/57.29578)*radius)+sex);
y2:=trunc(sey-int(sin((endangle+1)/57.29578)*radius));
line (sex,sey,x1,y1); line (sex,sey,x2,y2);
x1:=trunc(int(cos ((stangle+((stangle+endangle)/2))/57.29578)*(radius/2))+sex);
y1:=trunc(sey-int(sin ((stangle+((stangle+endangle)/2))/57.29578)*(radius/2)));
col4:=color;color:=col3;
floodfill(x1,y1,c1);
color:=col4;
end;

var x,y,d:word;

procedure circle (ox,oy,radius:word);assembler;
asm
    mov ax,color;
    mov c1,ax;
    mov x,0;
    mov ax,radius;
    mov y,ax;
    mov ax,03;
    mov bx,radius;
    add bx,bx;
    sub ax,bx;
    mov d,ax;
@oc:mov ax,x;
    add ax,ox;
    mov x1,ax;
    mov ax,y;
    add ax,oy;
    mov y1,ax;
    call putpix;
    mov ax,oy;
    sub ax,y;
    mov y1,ax;
    call putpix;
    mov ax,ox;
    sub ax,x;
    mov x1,ax;
    call putpix;
    mov ax,oy;
    add ax,y;
    mov y1,ax;
    call putpix;
    mov ax,ox;
    add ax,y;
    mov x1,ax;
    mov ax,oy;
    add ax,x;
    mov y1,ax;
    call putpix;
    mov ax,ox;
    sub ax,y;
    mov x1,ax;
    call putpix;
    mov ax,oy;
    sub ax,x;
    mov y1,ax;
    call putpix;
    mov ax,ox;
    add ax,y;
    mov x1,ax;
    call putpix;
    cmp d,0;
    jge @oa;
    mov ax,x;
    add ax,ax;
    add ax,ax;
    add ax,6;
    add ax,d;
    mov d,ax;
    jmp @ob;
@oa:mov ax,x;
    sub ax,y;
    add ax,ax;
    add ax,ax;
    add ax,10;
    add ax,d;
    mov d,ax;
    dec y;
@ob:inc x;
    mov ax,y;
    cmp ax,x;
    jb @od;
    jmp @oc;
@od:mov ax,x;
    cmp ax,y;
end;

function imagesize(xa,ya,xm,ym:word):word;assembler;
asm
   mov ax,xm;
   sub ax,xa;
   inc ax;
   mov bx,ym;
   sub bx,ya;
   inc bx;
   mul bx;
   add ax,4;
end;

procedure getimage(xa,ya,mx,my:word;p:pointer);assembler;
asm
    push es;
    push ds;
    mov ax,sega000;
    mov es,ax;
    mov ax,mx;
    cmp ax,rx;
    jae @@c;
    mov bx,xa;
    cmp bx,rx;
    jae @@c;
    cmp ax,bx;
    jb @@x;
    sub ax,bx;
    jmp @@y;
@@x:sub bx,ax;
    mov ax,bx;
    mov bx,xa;
    xchg bx,mx;
    mov xa,bx;
@@y:inc ax;
    mov dx,my;
    cmp dx,ry;
    jae @@c;
    mov bx,ya;
    cmp bx,ry;
    jae @@c;
    cmp dx,bx;
    jb @@t;
    sub dx,bx;
    jmp @@z;
@@t:sub bx,dx;
    mov dx,bx;
    mov bx,ya;
    xchg bx,my;
    mov ya,bx;
@@z:lds si,p;
    mov [si],ax;
    inc si;
    inc si;
    mov [si],dx;
    inc si;
    inc si;
    push ds;
    mov ax,seg rx;
    mov ds,ax;
    mov ax,rx;
    mul ya;
    add ax,xa;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    je @@s;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
@@s:pop ds;
    mov di,cx;
    mov dx,[si-4];		   {dx-нач. значение счетчика,cx-счетчик}
    mov ax,[si-2];		   {ax-счетчик строк}
    mov bx,es;
    mov cx,ds;
    mov es,cx;
    mov ds,bx;
    mov cx,dx;
    xchg si,di;
    mov bx,si;                      {bx-нач. значение передатчика}
    cld;
@@b:movsb;                  {начало цикла}
    dec cx;
    jz @@k;
    cmp si,0;
    jne @@b;
    push dx;
    push ax;
    push bx;
    push ds;
    mov dx,seg cbank;
    mov ds,dx;
    mov dx,cbank;
    inc dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@k:cmp ax,0;
    jz @@c;
    dec ax;
    mov cx,dx;
    push ds;
    mov si,seg rx;
    mov ds,si;
    add bx,rx;
    pop ds;
    mov si,bx;
    ja @@b;
@@g:push dx;
    push ax;
    push bx;
    push ds;
    mov dx,seg cbank;
    mov ds,dx;
    mov dx,cbank;
    inc dx;
    mov cbank,dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@c:pop ds;
    pop es;
end;


procedure putsprite(xa,ya:word;p:pointer);assembler;
asm
    push es;
    push ds;
    mov bx,xa;
    cmp bx,rx;
    jae @@c;
    mov bx,ya;
    cmp bx,ry;
    jae @@c;
    mov ax,rx;
    mul ya;
    add ax,xa;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    mov si,ds;
    mov di,seg cbank;
    mov ds,di;
    cmp dx,cbank;
    mov ds,si;
    je @@z;
    mov ax,4f05h;
    mov bx,00h;
    mov ds,di;
    mov cbank,dx;
    mov ds,si;
    int 10h;
@@z:mov dx,sega000;
    mov es,dx;
    mov di,cx;
    lds si,p;
    mov dx,[si];
    push ds;
    mov cx,seg rx;
    mov ds,cx;
    mov cx,dx;
    add cx,xa;
    cmp cx,rx;
    pop ds;
    jae @@c;
    add si,2;		            {dx-нач. значение счетчика,cx-счетчик}
    mov ax,[si];
    push ds;
    mov cx,seg ry;
    mov ds,cx;
    mov cx,ax;
    add cx,ya;
    cmp cx,ry;
    pop ds;
    jae @@c;
    add si,2;		            {ax-счетчик строк}
    mov cx,dx;
    mov bx,di;                      {bx-нач. значение передатчика}
    cld;
@@b:push ax;
    mov al,[si];
    cmp al,0h;
    pop ax;
    jne @@n;
    inc si;
    inc di;
    jmp @@p;
@@n:movsb;                     {начало цикла}
@@p:dec cx;
    jz @@k;
    cmp di,0;
    jne @@b;
    push dx;
    push ax;
    push bx;
    push ds;
    mov ax,seg cbank;
    mov ds,ax;
    mov dx,cbank;
    inc dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@k:cmp ax,0;
    je @@c;
    dec ax;
    mov cx,dx;
    push ds;
    mov di,seg rx;
    mov ds,di;
    add bx,rx;
    pop ds;
    mov di,bx;
    jnc @@b;
@@g:push dx;
    push ax;
    push bx;
    push ds;
    mov ax,seg cbank;
    mov ds,ax;
    mov dx,cbank;
    inc dx;
    mov cbank,dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@c:pop ds;
    pop es;

end;

procedure putimage(xa,ya:word;p:pointer);assembler;
asm
    push es;
    push ds;

    mov bx,xa;
    cmp bx,rx;
    jae @@c;
    mov bx,ya;
    cmp bx,ry;
    jae @@c;
    mov ax,rx;
    mul ya;
    add ax,xa;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    mov si,ds;
    mov di,seg cbank;
    mov ds,di;
    cmp dx,cbank;
    mov ds,si;
    je @@z;
    mov ax,4f05h;
    mov bx,00h;
    mov ds,di;
    mov cbank,dx;
    mov ds,si;
    int 10h;
@@z:mov dx,sega000;
    mov es,dx;
    mov di,cx;
    lds si,p;
    mov dx,[si];
    push ds;
    mov cx,seg rx;
    mov ds,cx;
    mov cx,dx;
    add cx,xa;
    cmp cx,rx;
    pop ds;
    jae @@c;
    add si,2;		            {dx-нач. значение счетчика,cx-счетчик}
    mov ax,[si];
    push ds;
    mov cx,seg ry;
    mov ds,cx;
    mov cx,ax;
    add cx,ya;
    cmp cx,ry;
    pop ds;
    jae @@c;
    add si,2;		            {ax-счетчик строк}
    mov cx,dx;
    mov bx,di;                      {bx-нач. значение передатчика}
    cld;
@@b:movsb;                     {начало цикла}
    dec cx;
    jz @@k;
    cmp di,0;
    jne @@b;
    push dx;
    push ax;
    push bx;
    push ds;
    mov ax,seg cbank;
    mov ds,ax;
    mov dx,cbank;
    inc dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@k:cmp ax,0;
    je @@c;
    dec ax;
    mov cx,dx;
    push ds;
    mov di,seg rx;
    mov ds,di;
    add bx,rx;
    pop ds;
    mov di,bx;
    jnc @@b;
@@g:push dx;
    push ax;
    push bx;
    push ds;
    mov ax,seg cbank;
    mov ds,ax;
    mov dx,cbank;
    inc dx;
    mov cbank,dx;
    pop ds;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@c:pop ds;
    pop es;

end;


procedure bar(xa,ya,mx,my:word);assembler;
asm
    push es;
    mov ax,xa;
    cmp ax,rx;
    jae @@c;
    mov bx,ya;
    cmp bx,ry;
    jae @@c;
    mov cx,mx;
    cmp cx,rx;
    jae @@c;
    mov dx,my;
    cmp dx,ry;
    jae @@c;
    cmp cx,ax;
    jae @@x;
    mov xa,cx;
    mov mx,ax;
@@x:cmp dx,bx;
    jae @@y;
    mov ya,dx;
    mov my,bx;
@@y:mov ax,rx;
    mul ya;
    add ax,xa;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov cx,ax;
    cmp dx,cbank;
    je @@z;
    mov ax,4f05h;
    mov bx,00h;
    mov cbank,dx;
    int 10h;
@@z:mov dx,sega000;
    mov es,dx;
    mov di,cx;
    mov dx,mx;
    cmp dx,rx;
    jae @@c;
    sub dx,xa;
    mov si,my;
    cmp si,ry;
    jae @@c;
    sub si,ya;			    {dx-нач. значение счетчика,cx-счетчик}
    inc dx;
    mov cx,dx;                      {si-счетчик строк}
    mov bx,di;                      {bx-нач. значение передатчика}
    cld;
    mov ax,color;
@@b:stosb;                     {начало цикла}
    dec cx;
    jz @@k;
    cmp di,0;
    jne @@b;
    push dx;
    push ax;
    push bx;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@k:cmp si,0;
    je @@c;
    dec si;
    mov cx,dx;
    add bx,rx;
    mov di,bx;
    jnc @@b;
@@g:push dx;
    push ax;
    push bx;
    mov dx,cbank;
    inc dx;
    mov cbank,dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    pop bx;
    pop ax;
    pop dx;
    jmp @@b;
@@c:pop es;
end;

procedure line(xa,ya,mx,my:word);assembler;
var i:word;
asm
    mov ax,00h;
    mov i,ax;
    mov ax,color;
    mov c1,ax;
    mov cx,xa;
    mov x1,cx;
    cmp cx,mx;
    jbe @@a;
    sub cx,mx;
    mov al,0h;
    jmp @@b;
@@a:mov cx,mx;
    sub cx,xa;
    mov al,1h;
@@b:mov dx,ya;
    mov y1,dx;
    cmp dx,my;
    jbe @@c;
    sub dx,my;
    mov ah,0h;
    jmp @@d;
@@c:mov dx,my;
    sub dx,ya;          {dx-my}   {cx-mx}
    mov ah,1h;
@@d:mov bx,0h;        {bx-sm}   {al-x1>x0,ah-y1>y0}
    cmp cx,0;
    jne @@x;
    cmp dx,0;
    jne @@x;
    call putpix;
    jmp @@s;
@@x:push ax;
    push dx;
    mov ax,rx;
    mul y1;
    add ax,x1;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov si,ax;
    cmp dx,cbank;
    jz @ia;
    pusha;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@ia:mov dx,sega000;
    mov es,dx;
    pop dx;
    pop ax;
    cmp cx,dx;
    jnb @@e;              {mx<my}
@@m:push ax;
    mov ax,x1;
    cmp ax,rx;
    jnc @we;
    mov ax,y1;
    cmp ax,ry;
    jnc @we;
    mov ax,c1;
    mov [es:si],al;
@we:pop ax;
    add bx,cx;
    cmp dx,bx;
    ja @@f;             {sm>my ?}
    sub bx,dx;
    cmp al,1h;
    jnz @@h;            {x1>x0 ?}
    inc x1;
    add si,1;
    jnc @@f;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@f;
@@h:dec x1;
    sub si,1;
    jnc @@f;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@f:cmp ah,1h;
    jnz @@k;
    inc y1;
    add si,rx;
    jnc @@l;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@l;
@@k:dec y1;
    sub si,rx;
    jnc @@l;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@l:inc i;
    cmp dx,i;
    jnc @@m;
    JMP @@s;
@@e:push ax;
    mov ax,x1;
    cmp ax,rx;
    jnc @wl;
    mov ax,y1;
    cmp ax,ry;
    jnc @wl;
    mov ax,c1;
    mov [es:si],al;
@wl:pop ax;
    add bx,dx;
    cmp bx,cx;
    jc @@n;             {sm>my ?}
    sub bx,cx;
    cmp ah,1h;
    jne @@o;            {x1>x0 ?}
    inc y1;
    add si,rx;
    jnc @@n;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@n;
@@o:dec y1;
    sub si,rx;
    jnc @@n;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@n:cmp al,1h;
    jne @@p;
    inc x1;
    add si,1;
    jnc @@r;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@r;
@@p:dec x1;
    sub si,1;
    jnc @@r;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@r:inc i;
    cmp cx,i;
    jnc @@e;
@@s:
end;

function installuserfont(s:string):byte;assembler;
asm
    push es;
    les bx,s;
    inc bx;
    mov di,offset nfont;
    mov cl,ufont;
    mov ch,0h;
    add cx,cx;
    add cx,cx;
    add di,cx;
    mov ax,[es:bx];
    mov [di],ax;
    add bx,2h;
    add di,2h;
    mov ax,[es:bx];
    mov [di],ax;
    pop es;
    mov al,ufont;
    inc al;
    mov ufont,al;
    dec al;
end;

procedure lin;assembler;
var i:word;
asm
    mov ax,00h;
    mov i,ax;
    mov ax,color;
    mov c1,ax;
    mov cx,x2;
    mov x1,cx;
    cmp cx,x3;
    jbe @@a;
    sub cx,x3;
    mov al,0h;
    jmp @@b;
@@a:mov cx,x3;
    sub cx,x2;
    mov al,1h;
@@b:mov dx,y2;
    mov y1,dx;
    cmp dx,y3;
    jbe @@c;
    sub dx,y3;
    mov ah,0h;
    jmp @@d;
@@c:mov dx,y3;
    sub dx,y2;          {dx-my}   {cx-mx}
    mov ah,1h;
@@d:mov bx,0h;        {bx-sm}   {al-x1>x0,ah-y1>y0}
    cmp cx,0;
    jne @@x;
    cmp dx,0;
    jne @@x;
    call putpix;
    jmp @@s;
@@x:push ax;
    push dx;
    mov ax,rx;
    mul y1;
    add ax,x1;
    adc dx,0;
    add ax,actpl;
    adc dx,actph;
    mov si,ax;
    cmp dx,cbank;
    jz @ia;
    pusha;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@ia:mov dx,sega000;
    mov es,dx;
    pop dx;
    pop ax;
    cmp cx,dx;
    jnb @@e;              {mx<my}
@@m:push ax;
    mov ax,x1;
    cmp ax,rx;
    jnc @we;
    mov ax,y1;
    cmp ax,ry;
    jnc @we;
    mov ax,c1;
    mov [es:si],al;
@we:pop ax;
    add bx,cx;
    cmp dx,bx;
    ja @@f;             {sm>my ?}
    sub bx,dx;
    cmp al,1h;
    jnz @@h;            {x1>x0 ?}
    inc x1;
    add si,1;
    jnc @@f;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@f;
@@h:dec x1;
    sub si,1;
    jnc @@f;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@f:cmp ah,1h;
    jnz @@k;
    inc y1;
    add si,rx;
    jnc @@l;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@l;
@@k:dec y1;
    sub si,rx;
    jnc @@l;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@l:inc i;
    cmp dx,i;
    jnc @@m;
    JMP @@s;
@@e:push ax;
    mov ax,x1;
    cmp ax,rx;
    jnc @wl;
    mov ax,y1;
    cmp ax,ry;
    jnc @wl;
    mov ax,c1;
    mov [es:si],al;
@wl:pop ax;
    add bx,dx;
    cmp bx,cx;
    jc @@n;             {sm>my ?}
    sub bx,cx;
    cmp ah,1h;
    jne @@o;            {x1>x0 ?}
    inc y1;
    add si,rx;
    jnc @@n;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@n;
@@o:dec y1;
    sub si,rx;
    jnc @@n;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@n:cmp al,1h;
    jne @@p;
    inc x1;
    add si,1;
    jnc @@r;
    pusha;
    mov dx,cbank;
    inc dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
    jmp @@r;
@@p:dec x1;
    sub si,1;
    jnc @@r;
    pusha;
    mov dx,cbank;
    dec dx;
    mov ax,4f05h;
    mov bx,00h;
    int 10h;
    mov cbank,dx;
    popa;
@@r:inc i;
    cmp cx,i;
    jnc @@e;
@@s:
end;


procedure settextstyle(nf,dr,sizf:byte);assembler;
asm
    mov al,dr;
    mov dr2,al;
    mov graphresult,0;
    cmp sizf,200;
    jnc @sy;
    mov ah,sizf;
    mov al,00h;
    ror ax,2;
    mov razmx,ax;
    mov razmy,ax;
    mov bx,offset j;
    mov si,offset nfont;
    mov al,nf;
    mov ah,00h;
    add ax,ax;
    add ax,ax;
    add si,ax;
    mov ax,word ptr [si];
    mov word ptr [bx],ax;
    add bx,2;
    add si,2;
    mov ax,word ptr [si];
    mov word ptr [bx],ax;
    add bx,2;
    mov word ptr [bx],'c.';
    add bx,2;
    mov word ptr [bx],'rh';
    add bx,2;
    mov byte ptr [bx],00h;
    mov dx,offset j;
    mov ah,3dh;
    mov al,0h;
    int 21h;
    mov flc,ax;
    jnc @sa;
@sy:mov graphresult,2;
    jmp @sz;
@sa:mov dx,offset k;
    mov ah,3fh;
    mov bx,flc;
    mov cx,4h;
    int 21h;
    mov bx,offset k;
    cmp word ptr [bx],4b50h;
    jnz @sy;
    cmp word ptr [bx+2],0808h;
    jnz @sy;

    mov ah,42h; {seek}
    mov bx,flc;
    mov al,0;
    mov cx,0;
    mov dx,80h;
    int 21h;

    mov ah,3fh;
    mov bx,flc;
    mov cx,2h;
    mov dx,offset k;
    int 21h;
    mov bx,offset k;
    cmp byte ptr [bx],2bh;
    jnz @sy;
    mov al,[bx+1];
    mov ch1,al;
    mov ah,42h; {seek}
    mov bx,flc;
    mov al,0;
    mov cx,0;
    mov dx,84h;
    int 21h;
    mov ah,3fh;
    mov bx,flc;
    mov cx,7h;
    mov dx,offset k;
    int 21h;
    mov bx,offset k;
    mov al,[bx];
    mov fs,al;
    mov al,[bx+1];
    add ah,[bx+2];
    add ax,80h;
    mov ukt,ax;
 {*****************************************************}
    mov al,[bx+4];
    add al,1;
    mov vs,al;
{*******************************************}
    mov ah,42h; {seek}
    mov bx,flc;
    mov al,0;
    mov cx,0;
    mov dx,90h;
    int 21h;
    mov ah,3fh;
    mov bx,flc;
    mov cl,ch1;
    mov ch,00h;
    add cx,cx;
    mov dx,offset uk;
    int 21h;
    mov ah,3fh;
    mov bx,flc;
    mov cl,ch1;
    mov ch,00h;
    mov dx,offset sh;
    int 21h;
    mov ah,42h;       {seek}
    mov bx,flc;
    mov al,0;
    mov dx,ukt;
    mov cx,0h;
    int 21h;
    push ds;
    mov ah,3fh;
    mov bx,flc;
    lds dx,pot;
    mov cx,0ffffh;
    int 21h;
    pop ds;
    mov ah,3eh;
    mov bx,flc;
    int 21h;
@sz:
end;

function textheight(sssss:string):word;assembler;
asm
{textheight:=vs*razmx;}
   mov al,vs;
   mov ah,0;
   mul razmx;
   mov al,ah;
   mov ah,0;
end;

procedure setusercharsize (mulx,divx,muly,divy:word);assembler;
asm
   mov ax,mulx;
   mov dl,ah;
   mov dh,0h;
   mov ah,al;
   mov al,0h;
   div divx;
   mov razmx,ax;
   mov ax,muly;
   mov dl,ah;
   mov ah,al;
   mov dh,0h;
   mov al,0h;
   div divx;
   mov razmy,ax;
end;

function textwidth(sssss:string):word;assembler;
asm
    push es;
    mov dx,0;
    les si,sssss;
    mov cl,[es:si];
    inc si;
    mov di,offset sh;
@wa:mov al,[es:si];
    sub al,fs;
    mov ah,0;
    mov bx,di;
    add bx,ax;
    mov al,[ds:bx];
    mov ah,0;
    push dx;
    mul razmx;
    pop dx;
    mov al,ah;
    mov ah,0;
    inc si;
    add dx,ax;
    sub cl,1;
    jnz @wa;
    mov ax,dx;
    pop es;
end;

procedure flodp1;assembler;
asm
     cmp dx,cbank;
     jz @fla;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fla:mov cx,fc;
     mov ax,color;
     mov ch,al;
     mov bx,sega000;
     mov es,bx;
@flb:cmp cl,[es:si];
     jz @fma;
     add si,1;
     jnc @flx;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@flx:cmp dx,fseg1;
     jb @flb;
     jz @fly;
     jmp @flz;
@fly:cmp si,fofs1;
     jb @flb;
     jmp @flz;
@fma:cmp cl,[es:si];
     jnz @flc;
     sub si,1;
     jnc @fma;
     dec dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
     jmp @fma;
@flc:add si,1;
     jnc @fmc;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmc:mov [di],dx;
     add di,2;
     mov [di],si;
     add di,2;
@fmf:mov [es:si],ch;
     add si,1;
     jnc @fmg;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmg:cmp [es:si],cl;
     jz @fmf;
     sub si,1;
     sbb dx,0;
     mov [di],dx;
     add di,2;
     mov [di],si;
     add di,2;
     cmp di,endm;
     jnz @fmo;
     mov di,startm;
@fmo:cmp dx,fseg1;
     jb @fmh;
     ja @flz;
     cmp si,fofs1;
     jae @flz;
@fmh:add si,1;
     jnc @fmm;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmm:cmp [es:si],cl;
     jnz @fmo;
     mov [di],dx;
     add di,2;
     cmp di,endm;
     jnz @fmr;
     mov di,startm;
@fmr:mov [di],si;
     add di,2;
     cmp di,endm;
     jnz @fms;
     mov di,startm;
@fms:jmp @fmf;
@flz:

end;

procedure flodp;assembler;
asm
     cmp dx,cbank;
     jz @fla;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fla:mov cx,fc;
     mov ax,color;
     mov ch,al;
     mov bx,sega000;
     mov es,bx;
@flb:mov al,[es:si];
     cmp cl,al;
     jz @fya;
     cmp ch,al;
     jnz @fma;
@fya:add si,1;
     jnc @flx;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@flx:cmp dx,fseg1;
     jb @flb;
     jz @fly;
     jmp @flz;
@fly:cmp si,fofs1;
     jb @flb;
     jmp @flz;
@fma:cmp cl,[es:si];
     jz @flc;
     sub si,1;
     jnc @fma;
     dec dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
     jmp @fma;
@flc:add si,1;
     jnc @fmc;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmc:mov [di],dx;
     add di,2;
     mov [di],si;
     add di,2;
@fmf:mov [es:si],ch;
     add si,1;
     jnc @fmg;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmg:cmp [es:si],cl;
     jnz @fmf;
     sub si,1;
     sbb dx,0;
     mov [di],dx;
     add di,2;
     mov [di],si;
     add di,2;
     cmp di,endm;
     jnz @fmo;
     mov di,startm;
@fmo:cmp dx,fseg1;
     jb @fmh;
     ja @flz;
     cmp si,fofs1;
     jae @flz;
@fmh:add si,1;
     jnc @fmm;
     inc dx;
     mov cbank,dx;
     mov ax,4f05h;
     mov bx,00h;
     int 10h;
@fmm:cmp [es:si],cl;
     jz @fmo;
     mov [di],dx;
     add di,2;
     cmp di,endm;
     jnz @fmr;
     mov di,startm;
@fmr:mov [di],si;
     add di,2;
     cmp di,endm;
     jnz @fms;
     mov di,startm;
@fms:jmp @fmf;
@flz:


end;



procedure floodfill2(x6,y6:word);assembler;
asm
     mov ax,rx;
     cmp ax,x6;
     jbe @fpd;
     mov ax,ry;
     cmp ax,y6;
     jbe @fpd;
     mov ax,offset umas;
     mov startm,ax;
     mov muk,ax;
     mov di,ax;
     mov fofs1,ax;
     mov dx,0;
     add ax,2400;
     mov endm,ax;
     mov ax,rx;
     mul y6;
     add ax,x6;
     adc dx,0;
     add ax,actpl;
     adc dx,actph;
     mov fseg1,dx;
     mov si,ax;
     mov ax,4f05h;
     mov bx,0h;
     int 10h;
@fpf:mov ax,sega000;
     mov es,ax;
     mov al,[es:si];
     mov ah,0h;
     cmp ax,color;
     jz @fpd;
     mov fc,ax;
     call flodp1;
@fpa:mov bx,muk;
     mov dx,[bx];
     add bx,2;
     mov si,[bx];
     mov tofs,si;
     mov ax,dx;
     mov tseg,ax;
     add si,rx;
     adc dx,0;
     add bx,2;
     mov ax,[bx];
     mov fseg1,ax;
     add bx,2;
     mov ax,[bx];
     add bx,2;
     mov muk,bx;
     add ax,rx;
     mov fofs1,ax;
     adc fseg1,0;
     call flodp1;
     mov dx,tseg;
     mov si,tofs;
     sub si,rx;
     sbb dx,0;
     mov ax,rx;
     add ax,ax;
     sub fofs1,ax;
     sbb fseg1,0;
     call flodp1;
     cmp muk,di;
     jz @fpd;
     mov ax,endm;
     cmp muk,ax;
     jnz @fpb;
     mov ax,startm;
     mov muk,ax;
@fpb:cmp muk,di;
     jnz @fpa;
@fpd:
end;

procedure floodfill(x6,y6,color6:word);assembler;
asm
     mov ax,rx;
     cmp ax,x6;
     jbe @fpd;
     mov ax,ry;
     cmp ax,y6;
     jbe @fpd;
     mov ax,offset umas;
     mov startm,ax;
     mov muk,ax;
     mov di,ax;
     mov fofs1,ax;
     mov dx,0;
     add ax,2400;
     mov endm,ax;
     mov ax,rx;
     mul y6;
     add ax,x6;
     adc dx,0;
     add ax,actpl;
     adc dx,actph;
     mov fseg1,dx;
     mov si,ax;
     mov ax,4f05h;
     mov bx,0h;
     int 10h;
@fpf:mov ax,sega000;
     mov es,ax;
     mov ax,color6;
     mov fc,ax;
     mov ax,color;
     cmp [es:si],al;
     jnz @fwa;
     sub ax,color;
     inc ax;
     mov [es:si],al;
@fwa:call flodp;
@fpa:mov bx,muk;
     mov dx,[bx];
     add bx,2;
     mov si,[bx];
     mov tofs,si;
     mov ax,dx;
     mov tseg,ax;
     add si,rx;
     adc dx,0;
     add bx,2;
     mov ax,[bx];
     mov fseg1,ax;
     add bx,2;
     mov ax,[bx];
     add bx,2;
     mov muk,bx;
     add ax,rx;
     mov fofs1,ax;
     adc fseg1,0;
     call flodp;
     mov dx,tseg;
     mov si,tofs;
     sub si,rx;
     sbb dx,0;
     mov ax,rx;
     add ax,ax;
     sub fofs1,ax;
     sbb fseg1,0;
     call flodp;
     cmp muk,di;
     jz @fpd;
     mov ax,endm;
     cmp muk,ax;
     jnz @fpb;
     mov ax,startm;
     mov muk,ax;
@fpb:cmp muk,di;
     jnz @fpa;
@fpd:
end;


procedure outchar;assembler;
var segd,ofsd:word;
var x4,y4,x5,y5,y6:word;
var y11,x11,y12,x12:word;
asm
    mov x4,0;
    mov y4,0;
    mov si,offset uk;
    mov al,sha;
    sub al,fs;
    mov ah,00h;
    add ax,ax;
    add si,ax;
    mov ax,[si];
    push es;
    les bx,pot;
    add bx,ax;
    mov di,es;
    mov segd,di;
    mov ofsd,bx;
    pop es;

@bb:push es;
    mov ax,segd;
    mov es,ax;
    mov bx,ofsd;
    mov al,[es:bx];
    mov ah,00h;
    mov x5,ax;
    inc bx;
    mov al,[es:bx];
    mov y5,ax;
    mov y6,ax;
    pop es;
    test x5,80h;
    jnz @ff;
    jmp @aa;
@ff:and x5,3fh;

    test y5,40h;
    jnz @gg;
    and y5,3fh;
    jmp @gh;

@gg:
    not y5;
    and y5,3fh;
    neg y5;

@gh:add ofsd,2;
    test y6,80h;
    jnz @gl;
    jmp @gm;
@gl:mov ax,x4;
    test ax,20h;
    jz @wo;
    or ax,0ffc0h;
@wo:mov bx,razmx;
    imul bx;
    mov dh,dl;
    mov dl,ah;
    mov x11,dx;

    mov ax,y4;
    neg ax;
    imul razmy;
    mov dh,dl;
    mov dl,ah;
    mov y11,dx;

    mov ax,x5;
    test ax,20h;
    jz @wp;
    or ax,0ffc0h;
@wp:mov bx,razmx;
    imul bx;
    mov dh,dl;
    mov dl,ah;
    mov x12,dx;

    mov ax,y5;
    neg ax;
    imul razmy;
    mov dh,dl;
    mov dl,ah;
    mov y12,dx;

    cmp dr2,0;
    jnz @xr;
    mov ax,x11;
    add ax,x7;
    mov x2,ax;
    mov ax,y11;
    add ax,y7;
    mov y2,ax;
    mov ax,x12;
    add ax,x7;
    mov x3,ax;
    mov ax,y12;
    add ax,y7;
    mov y3,ax;
    call lin;
    jmp @gm;
@xr:mov ax,y7;
    sub ax,x11;
    mov y2,ax;
    mov ax,y11;
    add ax,x7;
    mov x2,ax;
    mov ax,y7;
    sub ax,x12;
    mov y3,ax;
    mov ax,y12;
    add ax,x7;

    mov x3,ax;
    call lin;

@gm:mov ax,x5;
    mov x4,ax;
    mov ax,y5;
    mov y4,ax;
    jmp @bb;

@aa:mov al,sha;
    mov ah,00h;
    sub al,fs;
    mov bx,ax;
    mov si,offset sh;
    add bx,si;
    mov al,[bx];
    mov ah,00h;

    cmp dr2,0;
    jnz @wa;
    mov bx,razmx;
    mul bx;
    mov dh,dl;
    mov dl,ah;
    add dx,x7;
    mov x7,dx;
    jmp @wb;
@wa:add dx,vs1;
    add y7,dx;
@wb:
end;

procedure outtextxy(x,y:word;s:string);assembler;
asm
    push es;
    les bx,s;
    mov cx,es;
    mov al,[es:bx];
    cmp dr2,0;
    jz @ub;
    mov ah,0h;
    add bx,ax;
    dec bx;
@ub:inc bx;
    mov ah,1;
    mov dx,x;
    cmp dr2,0;
    jz @qm;
    push ax;
    push bx;
    mov bx,dx;
    mov al,vs;
    mov ah,0h;
    mul razmy;
    mov dh,dl;
    mov dl,ah;
    add dx,bx;
    pop bx;
    pop ax;
@qm:mov x7,dx;
    mov dx,y;
    cmp dr2,0;
    jnz @qr;
    push ax;
    push bx;
    mov bx,dx;
    mov al,vs;
    mov ah,0h;
    mul razmy;
    mov dh,dl;
    mov dl,ah;
    add dx,bx;
    pop bx;
    pop ax;
    jmp @qd;
@qr:push ax;
    push bx;
    mov al,[es:bx];
    mov ah,00;
    sub al,fs;
    mov bx,ax;
    mov si,offset sh;
    add bx,si;
    mov al,[bx];
    mov ah,00h;
    mov bx,dx;
    mul razmx;
    mov dh,dl;
    mov dl,ah;
    add dx,bx;
    pop bx;
    pop ax;
@qd:mov y7,dx;
    mov dx,es;
@@a:cmp dr2,0;
    jz @az;
    push bx;
    push ax;
    dec bx;
    mov al,[es:bx];
    mov ah,00;
    sub al,fs;
    mov di,ax;
    mov si,offset sh;
    add di,si;
    mov al,[di];
    mov ah,00h;
    mov di,dx;
    mul razmx;
    mov dh,dl;
    mov dl,ah;
    mov vs1,dx;
    mov dx,di;
    pop ax;
    pop bx;

@az:push ax;
    push bx;
    push cx;
    mov cl,[es:bx];
    mov sha,cl;
    call outchar;
    pop cx;
    pop bx;
    pop ax;
    cmp dr2,0;
    jnz @rs;
    inc bx;
    jmp @rt;
@rs:dec bx;
@rt:inc ah;
    mov es,cx;
    cmp al,ah;
    jnc @@a;
    pop es;
end;


procedure TextXY(x,y:word; txt:string);
type
  pchar=array[char] of array[0..15] of byte;
var
  p:^pchar;
  c:char;
  i,j,z,b:integer;
  ad,bk:word;
  l,v,col:longint;
  rp:registers;
begin

  rp.bh:=6;
  rp.ax:=$1130;
  intr($10,rp);

  p:=ptr(rp.es,rp.bp);
  for z:=1 to length(txt) do
  begin
    c:=txt[z];
    for j:=0 to 15 do
    begin
      b:=p^[c][j];
      for i:=0 to 7 do
      begin
        if (b and 128)<>0 then v:=color else v:=bkcolor;
        putpixel(x+i,y+j,v);
        b:=b shl 1;
      end;
    end;
    inc(x,8);
  end;
end;



procedure rectangle(xa,ya,mx,my:word);assembler;
asm
    mov ax,xa;
    mov x2,ax;
    mov ax,mx;
    mov x3,ax;
    mov ax,ya;
    mov y2,ax;
    mov y3,ax;
    call lin;
    mov ax,xa;
    mov x2,ax;
    mov ax,mx;
    mov x3,ax;
    mov ax,my;
    mov y2,ax;
    mov y3,ax;
    call lin;
    mov ax,ya;
    mov y2,ax;
    mov ax,my;
    mov y3,ax;
    mov ax,xa;
    mov x2,ax;
    mov x3,ax;
    call lin;
    mov ax,ya;
    mov y2,ax;
    mov ax,my;
    mov y3,ax;
    mov ax,mx;
    mov x2,ax;
    mov x3,ax;
    call lin;

end;

procedure setbkcolor(c:word);assembler;
asm
mov ax,c;
mov bkcolor,ax;
end;

procedure cleardevice;assembler;
asm
    push es;
    mov dx,actph;
    mov cbank,dx;
    mov bx,0h;
    mov ax,4f05h;
    int 10h;
    mov cx,dx;
    mov di,actpl;
    mov bx,sega000;
    mov es,bx;
    mov ax,bkcolor;
    mov bx,hsz;
    inc bx;
    mov dx,lsz;
@@a:stosb;
    cmp di,0;
    je @@b;
    sub dx,1;
    sbb bx,0;
    jnz @@a;
    jmp @@c;
@@b:push ax;
    push bx;
    push dx;
    inc cx;
    mov dx,cx;
    mov ax,4f05h;
    mov bx,0;
    int 10h;
    mov cbank,dx;
    pop dx;
    pop bx;
    pop ax;
    jmp @@a;
@@c:pop es;
end;

procedure setrgbpalette (n:word;c1,c2,c3:byte);assembler;
asm
    mov ax,1010h;
    mov bx,n;
    mov cl,c3;
    mov ch,c2;
    mov dh,c1;
    int 10h;
end;

procedure getrgbpalette (n:word;var c1,c2,c3:byte);
var c4,c5,c6:byte;
begin
asm
    mov ax,1010h;
    mov bx,n;
    int 10h;
    mov c6,cl;
    mov c5,ch;
    mov c4,dh;
end;
c1:=c4;c2:=c5;c3:=c6;
end;

procedure setallpalette(l:pointer);assembler;
asm
mov ax,1012h;
mov bx,0h;
mov cx,256;
les dx,l;
int 10h;
end;

procedure getallpalette(l:pointer);assembler;
asm
mov ax,1017h;
mov bx,0h;
mov cx,256;
les dx,l;
int 10h;
end;

procedure fadeup(l:pointer;v:byte);assembler;
asm
    push es;
    mov dx,0300h;
    mov bl,v;
    les di,l;
@@a:mov al,[es:di];
    add al,bl;
    jnc @@b;
    mov al,0ffh;
@@b:mov [es:di],al;
    inc di;
    sub dx,1;
    jnz @@a;
    pop es;
end;

procedure fadedown(l:pointer;v:byte);assembler;
asm
    push es;
    mov dx,300h;
    mov bl,v;
    les di,l;
@@a:mov al,[es:di];
    sub al,bl;
    jnc @@b;
    mov al,0h;
@@b:mov [es:di],al;
    inc di;
    sub dx,1;
    jnz @@a;
    pop es;
end;

procedure setEGApalette;assembler;
asm
mov ax,1012h;
mov bx,0h;
mov cx,16;
mov dx,seg egapal;
mov es,dx;
mov dx,offset egapal;
int 10h;
end;

var zagpcx:array[1..130] of byte;
var povt:byte;

procedure LoadPcx(nx,ny:integer;NFile:string);assembler;
asm
     pusha;
     les bx,nfile;
     mov al,[es:bx];
     mov si,offset zagpcx;
     inc bx;
@lpa:mov cl,[es:bx];
     mov [ds:si],cl;
     inc si;
     inc bx;
     sub al,1;
     jnz @lpa;
     mov byte ptr [ds:si],0;
     mov ax,3d00h;
     mov dx,offset zagpcx;
     int 21h;
     jnc @lpb;
     jmp @lppoor;
@lpb:mov flc,ax;
     mov dx,offset zagpcx;
     mov cx,128;
     mov bx,flc;
     mov ax,3f00h;
     int 21h;
     mov bx,offset zagpcx;
     mov ax,[bx];
     cmp ax,050ah;
     jz @lpc;
     jmp @lppoor1;
@lpc:add bx,2;
     mov ax,[bx];
     cmp ax,0801h;
     jz @lpd;
     jmp @lppoor1;
@lpd:add bx,2;
     mov ax,[bx];
     mov x1,ax;
     add bx,2;
     mov ax,[bx];
     mov y1,ax;
     add bx,2;
     mov ax,[bx];
     sub ax,x1;
     mov xres,ax;
     add bx,2;
     mov ax,[bx];
     sub ax,y1;
     mov yres,ax;
     mov ax,nx;
     mov x1,ax;
     mov ax,ny;
     mov y1,ax;
     mov x2,0;
     mov y2,0;
     add bx,55;
     mov al,[bx];
     cmp al,01h;
     jz @lpg;
     jmp @lppoor1;
@lpg:mov ax,4202h;
     mov bx,flc;
     mov cx,0;
     mov dx,0;
     int 21h;
     sub ax,769;
     sbb dx,0h;
     mov cx,dx;
     mov dx,ax;
     mov bx,flc;
     mov ax,4200h;
     int 21h;
     mov dx,offset col;
     mov cx,769;
     mov bx,flc;
     mov ax,3f00h;
     int 21h;
     mov bx,offset col;
     cmp byte ptr [bx],0ch;
     jz @lpe;
     jmp @lppoor1;
@lpe:inc bx;
     mov cx,768;
@lpf:ror byte ptr [bx],2;
     inc bx;
     sub cx,1;
     jnz @lpf;
     mov dx,offset col+1;
     mov ax,ds;
     mov es,ax;
     mov ax,1012h;
     mov bx,0h;
     mov cx,256;
     int 10h;
     mov ax,4200h;
     mov bx,flc;
     mov cx,0;
     mov dx,80h;
     int 21h;
     mov povt,0;
@lpi:mov bx,flc;
     mov cx,bufsz;
     mov ax,3f00h;
     push ds;
     lds dx,buf;
     int 21h;
     pop ds;
     mov bufpos,0;
@lpx:les bx,buf;
     add bx,bufpos;
     mov ax,bufpos;
     cmp ax,bufsz;
     jz @lpi;
     mov al,[es:bx];
     inc bufpos;
     cmp povt,0;
     jz @lpk;
     mov cl,povt;
     mov ah,0h;
     mov c1,ax;
@lmd:push cx;
     call putpix;
     pop cx;
     inc x1;
     inc x2;
     mov ax,x2;
     dec ax;
     cmp ax,xres;
     jnz @lmc;
     mov ax,nx;
     mov x1,ax;
     mov x2,0;
     inc y1;
     inc y2;
     mov ax,y2;
     dec ax;
     cmp ax,yres;
     jnz @lmc;
     jmp @lppoor1;
@lmc:dec cl;
     cmp cl,0;
     jnz @lmd;
     mov povt,0;
     jmp @lpx;
@lpk:mov ah,al;
     and ah,0c0h;
     cmp ah,0c0h;
     jnz @lpy;
     and al,3fh;
     mov povt,al;
     jmp @lpx;
@lpy:mov ah,0h;
     mov c1,ax;
     call putpix;
     inc x1;
     inc x2;
     mov ax,x2;
     dec ax;
     cmp ax,xres;
     jnz @lpx;
     mov ax,nx;
     mov x1,ax;
     mov x2,0;
     inc y1;
     inc y2;
     mov ax,y2;
     dec ax;
     cmp ax,yres;
     jnz @lpx;
     jmp @lppoor1;


@lppoor1:
     mov ah,3eh;
     mov bx,flc;
     int 21h;
@lppoor:
popa;
end;

begin
getmem(pot,10);potsz:=10;
getmem(buf,10);bufsz:=10;
for i:=0 to 47 do egapal[i]:=0;
egapal[5]:=$1f;egapal[7]:=$1f;egapal[10]:=$1f;egapal[11]:=$1f;
egapal[12]:=$1f;egapal[15]:=$1f;egapal[17]:=$1f;egapal[18]:=$1f;
egapal[19]:=$1f;egapal[21]:=$1f;egapal[22]:=$1f;egapal[23]:=$1f;
egapal[24]:=$0f;egapal[25]:=$0f;egapal[26]:=$0f;egapal[29]:=$3f;
egapal[31]:=$3f;egapal[34]:=$3f;egapal[35]:=$3f;egapal[36]:=$3f;
egapal[39]:=$3f;egapal[41]:=$3f;egapal[42]:=$3f;egapal[43]:=$3f;
egapal[45]:=$3f;egapal[46]:=$3f;egapal[47]:=$3f;
end.