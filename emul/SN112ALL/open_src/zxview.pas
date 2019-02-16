{$O+,F+}
Unit zxView;
Interface

Uses Dos,sGraph,rv,crt, sn_obj, main;

Type
     tscr=array[1..6144*3] of byte;

Var  zx:array[1..16] of byte;
     scr:^tscr;
     palette:array[1..768] of byte;
     ss,fName:string;

     f:file;
     ink,paper,a,b,c,d,e,pc,ic,Index,i,px,py,x0,y0:integer;
     z1,z2:byte;
     r:real;

     dub:byte;
     screen,attr,bright,zxflash,flashNow,info:boolean;

     VideoMode:word;
     key:word;


PROCEDURE SCRVIEW(fname6912,s:string);
PROCEDURE XPCVIEW(fname18432,s:string);

Implementation

Uses Vars;
Var
     p:tpanel;


Function GetBit(a,n: byte):byte;
Begin
 GetBit:=1 and (a shr n);
End;

Function SetBit(a,n:byte):byte;
Begin
 SetBit:=a or (1 shl n);
End;


{============================================================================}
{============================================================================}
{============================================================================}
PROCEDURE SCRVIEW(fname6912,s:string);

{}
Procedure PrintScr;
Begin
 x0:=(GetMaxX div 2)-(256*dub div 2)+5*dub+1; y0:=1+(GetMaxY div 2)-(192*dub div 2);
 px:=x0; py:=y0;

 for d:=1 to 3 do
  for c:=1 to 8 do
   for b:=0 to 7 do
    begin
     Index:=256*b+32*(c-1)+2048*(d-1)+1;
     e:=256*(d-1)+32*(c-1);
     for a:=1 to 32 do
      begin
       ic:=palette[a+e] and 7;
       pc:=palette[a+e] and 56; pc:=pc shr 3;
       if bright then if GetBit(palette[a+e],6)=1 then begin if ic<>0 then inc(ic,7); if pc<>0 then inc(pc,7); end;{}
       if GetBit(palette[a+e],7)=1 then{}
        Begin
         if flashNow then
          begin ink:=pc; paper:=ic; end
         else
          begin ink:=ic; paper:=pc; end;
        End
       else
        Begin ink:=ic; paper:=pc; End;

       ink:=zx[ink]; paper:=zx[paper];
       if not attr then begin ink:=0; paper:=7; end;

       for i:=0 to 7 do if GetBit(scr^[Index],i)=1 then
        begin
         PutPixel(px+8-dub*i,py,ink);
         if dub>1 then
          for z2:=0 to dub-1 do
           for z1:=0 to dub-1 do PutPixel(px+8-dub*i+z1,py+z2,ink);
        end
       else
        begin
         PutPixel(px+8-dub*i,py,paper);
         if dub>1 then
          for z2:=0 to dub-1 do
           for z1:=0 to dub-1 do PutPixel(px+8-dub*i+z1,py+z2,paper);
        end;
       inc(px,8*dub);
       inc(Index);
      end;
     inc(py,dub); px:=x0;
    end;

if info then
 begin
  a:=14-length(s);
  s:=space(a div 2)+s+space(a div 2);

  y0:=(getmaxy div 2)+(dub*192 div 2)+16;

  x0:=(getmaxx div 2)-8*(length(s) div 2);
  case bkcolor of
   black,blue,red,magenta: setcolor(7);
   green,cyan,brown,lightgray: setcolor(0);
  end;
  textxy(x0,y0,s);

  x0:=(GetMaxX div 2)+((256*dub) div 2)-5*9-(dub-1)*6;

  setcolor(lightred);
  for z1:=1 to 9 do
  line(z1+x0{+8*length(s){}, y0+16, z1+x0{+8*length(s){}+8, y0);

  setcolor(yellow);
  for z1:=1 to 9 do
  line(z1+9+x0{+8*length(s){}, y0+16, z1+9+x0{+8*length(s){}+8, y0);

  setcolor(lightgreen);
  for z1:=1 to 9 do
  line(z1+18+x0{+8*length(s){}, y0+16, z1+18+x0{+8*length(s){}+8, y0);

  setcolor(lightcyan);
  for z1:=1 to 9 do
  line(z1+27+x0{+8*length(s){}, y0+16, z1+27+x0{+8*length(s){}+8, y0);
 end
else
 begin
  x0:=(GetMaxX div 2)-(256*dub div 2);
  y0:=(getmaxy div 2)+(192*dub div 2)+16;
  setcolor(bkcolor); bar(0,y0-1,getmaxx,y0+16+1);{}
 end;

End;
{}

{}
Procedure Load;
Begin
{$I-}
 for a:=1 to 768 do palette[a]:=56;
 for a:=1 to 6144 do scr^[a]:=0;
 Assign(f,fname6912); FileMode:=0; Reset(f,1);
 if filesize(f)=6912+17 then seek(f,17);
 BlockRead(f,scr^,6144); BlockRead(f,palette,768);
 Close(f);
{$I+}
if IOResult<>0 then;
End;
{}

Label Beg,Clear,Start,Cont,loop,loop2;

BEGIN
SaveTextMode;
if CheckDirFile(fname6912)<>0 then exit;

 GetMem(scr,6144);
 Load;

 dub:=1;
 attr:=true;
 bright:=true;
 zxflash:=true;
 FlashNow:=false;
 info:=true;

 VideoMode:=v640x480x256;
 SetBkColor(7); SetColor(0);

 GetProfile(startdir+'\sn.ini','View','Border',ss);
 a:=vall(ss); if a<0 then a:=0; if a>7 then a:=7;
 SetBkColor(a);

 GetProfile(startdir+'\sn.ini','View','Info',ss);
 if nospace(ss)='1' then info:=true else info:=false;

 GetProfile(startdir+'\sn.ini','View','Size',ss);
 a:=vall(ss); if a<1 then a:=1; if a>4 then a:=4;
 dub:=a;

 GetProfile(startdir+'\sn.ini','View','VideoMode',ss);
 if ss='320x200' then VideoMode:=v320x200x256;
 if ss='640x400' then VideoMode:=v640x400x256;
 if ss='640x480' then VideoMode:=v640x480x256;
 if ss='800x600' then VideoMode:=v800x600x256;
 if ss='1024x768' then VideoMode:=v1024x768x256;

Beg:
 InitGraph(VideoMode);

    a:=45; b:=255;

    SetRGBPalette(Blue,         0,0,a);
    SetRGBPalette(Red,          a,0,0);
    SetRGBPalette(Magenta,      a,0,a);
    SetRGBPalette(Green,        0,a,0);
    SetRGBPalette(Brown,        a,a,0);
    SetRGBPalette(LightGray,    a,a,a);

    SetRGBPalette(LightBlue,    0,0,b);
    SetRGBPalette(LightRed,     b,0,0);
    SetRGBPalette(LightMagenta, b,0,b);
    SetRGBPalette(LightGreen,   0,b,0);
    SetRGBPalette(Yellow,       b,b,0);
    SetRGBPalette(White,        b,b,b);

 zx[1]:=Blue; zx[2]:=Red; zx[3]:=Magenta; zx[4]:=Green;
 zx[5]:=Cyan; zx[6]:=Brown; zx[7]:=LightGray;

 zx[8]:=LightBlue; zx[9]:=LightRed; zx[10]:=LightMagenta; zx[11]:=LightGreen;
 zx[12]:=LightCyan; zx[13]:=Yellow; zx[14]:=White;

 Case focus of
  left:  p:=lp;
  right: p:=rp;
 End;

Clear:
 ClearDevice;

Start:
 PrintScr;

loop:
r:=1;
loop2:
delay(1);
r:=r+1;
if keypressed then goto cont;
if r<1600 then goto loop2;
if zxflash then FlashNow:=not FlashNow else FlashNow:=false;
PrintScr;
goto loop;

Cont:
key:=KeyCode;
{Case key of{}
if key=PadMinus then
              begin
               if VideoMode=$105 then begin VideoMode:=$103; goto beg; end;
               if VideoMode=$103 then begin VideoMode:=$101; goto beg; end;
               if VideoMode=$101 then begin VideoMode:=$100; goto beg; end;
               if VideoMode=$100 then begin VideoMode:=$13;  goto beg; end;
               if VideoMode=$13 then goto loop;
              end;

if key=PadPlus then
              begin
               if VideoMode=$13  then begin VideoMode:=$100; goto beg; end;
               if VideoMode=$100 then begin VideoMode:=$101; goto beg; end;
               if VideoMode=$101 then begin VideoMode:=$103; goto beg; end;
               if VideoMode=$103 then begin VideoMode:=$105; goto beg; end;
               if VideoMode=$105 then goto loop;
              end;

if (key=_LowA)or(key=_UpA) then
              begin attr   :=not attr;   goto start; end;
if (key=_LowB)or(key=_UpB) then
              begin bright :=not bright; goto start; end;
if (key=_LowF)or(key=_UpF) then
              begin zxflash:=not zxflash;goto start; end;
if (key=_LowI)or(key=_UpI) then
              begin info   :=not info;   goto start; end;

if key=_PgUp then
              begin inc(dub); if dub>4 then begin dub:=4; goto loop; end else goto Clear; end;
if key=_PgDn then
              begin dec(dub); if dub<1 then begin dub:=1; goto loop; end else goto Clear; end;

if key=_Num1 then
              begin SetBkColor(Blue);      goto Clear; end;
if key=_Num2 then
              begin SetBkColor(Red);       goto Clear; end;
if key=_Num3 then
              begin SetBkColor(Magenta);   goto Clear; end;
if key=_Num4 then
              begin SetBkColor(Green);     goto Clear; end;
if key=_Num5 then
              begin SetBkColor(Cyan);      goto Clear; end;
if key=_Num6 then
              begin SetBkColor(Brown);     goto Clear; end;
if key=_Num7 then
              begin SetBkColor(LightGray); goto Clear; end;
if key=_Num0 then
              begin SetBkColor(Black);     goto Clear; end;

if (key=_Right)or(key=_Down) then
              begin
               if p.PanelType=pcPanel then
                BEGIN
                 b:=IndexOf(Focus)+1;
                 if b>p.tdirs+p.tfiles then b:=p.tdirs+p.tfiles;
                 for a:=b to p.tdirs+p.tfiles do
                  begin
                   if ((strlo(p.pcDir^[a].fext)='scr')and(p.pcDir^[a].flength=6912))or
                      ((strlo(p.pcDir^[a].fext[1])='$')and(p.pcDir^[a].flength=6912+17)){}
                   then
                    Begin
                     Case focus of
                      left:  begin
                              inc(lp.pcf,(a-IndexOf(focus)));
                              lp.Inside;
                             end;
                      right: begin
                              inc(rp.pcf,(a-IndexOf(focus)));
                              rp.Inside;
                             end;
                     End;
                     fname6912:=p.pcnd+p.TrueName(a);
                     s:=p.TrueName(a);
                     Load;
                     goto start;
                    End else if a>=p.tdirs+p.tfiles then goto loop;
                  end;
                END;
              end;

if (key=_Left)or(key=_Up) then
              begin
               if p.PanelType=pcPanel then
                BEGIN
                 for a:=IndexOf(Focus)-1 downto 1 do
                  begin
                   if  ((strlo(p.pcDir^[a].fext)='scr')and(p.pcDir^[a].flength=6912))
                        or
                       ((strlo(p.pcDir^[a].fext[1])='$')and(p.pcDir^[a].flength=6912+17))
                   then
                    Begin
                     Case focus of
                      left:  begin
                              dec(lp.pcf,(IndexOf(focus)-a));
                              lp.Inside;
                             end;
                      right: begin
                              dec(rp.pcf,(IndexOf(focus)-a));
                              rp.Inside;
                             end;
                     End;
                     fname6912:=p.pcnd+p.TrueName(a);
                     s:=p.TrueName(a);
                     Load;
                     goto start;
                    End else if a<=1 then goto loop{};

                  end;
                END;
              end;


{End;{}
CloseGraph;
RestTextMode;
flash(off);
FreeMem(scr,6144);
END;



{============================================================================}
{============================================================================}
{============================================================================}
PROCEDURE XPCVIEW(fname18432,s:string);

{}
Procedure PrintXpc;

Procedure PrintXpcAsSprite;
Begin
 Index:=1;
 x0:=(GetMaxX div 2)-(dub*256 div 2); y0:=(GetMaxY div 2)-(dub*192 div 2);
 px:=x0; py:=y0;
 for b:=1 to 192 do
  begin
   for a:=1 to 32 do
    begin
     for i:=0 to 7 do
      begin
       ic:=0;
       if GetBit(scr^[Index+0*6144],i)=1 then ic:=SetBit(ic,2);
       if GetBit(scr^[Index+1*6144],i)=1 then ic:=SetBit(ic,1);
       if GetBit(scr^[Index+2*6144],i)=1 then ic:=SetBit(ic,0);
       PutPixel(px+8-dub*i,py,ic);
       if dub>1 then
        begin
         for z2:=0 to dub-1 do
          for z1:=0 to dub-1 do PutPixel(px+8-dub*i+z1,py+z2,ic);
        end;
      end;
     inc(px,8*dub);
     inc(Index);
    end;
   inc(py,dub); px:=x0;
  end;
End;

Procedure PrintXpcAsScreen;
Begin
 Index:=1;
 x0:=(GetMaxX div 2)-(dub*256 div 2); y0:=(GetMaxY div 2)-(dub*192 div 2);
 px:=x0; py:=y0;
 for d:=1 to 3 do
 for c:=1 to 8 do
 for b:=0 to 7 do
  begin
   Index:=256*b+32*(c-1)+2048*(d-1)+1;
   for a:=1 to 32 do
    begin
     for i:=0 to 7 do
      begin
       ic:=0;
       if GetBit(scr^[Index+0*6144],i)=1 then ic:=SetBit(ic,2);
       if GetBit(scr^[Index+1*6144],i)=1 then ic:=SetBit(ic,1);
       if GetBit(scr^[Index+2*6144],i)=1 then ic:=SetBit(ic,0);
       PutPixel(px+8-dub*i,py,ic);
       if dub>1 then
        begin
         for z2:=0 to dub-1 do
          for z1:=0 to dub-1 do PutPixel(px+8-dub*i+z1,py+z2,ic);
        end;
      end;
     inc(px,8*dub);
     inc(Index);
    end;
   inc(py,dub); px:=x0;
  end;
End;


Begin

if screen then PrintXpcAsScreen else PrintXpcAsSprite;

if info then
 begin
  a:=14-length(s);
  s:=space(a div 2)+s+space(a div 2);

  y0:=(getmaxy div 2)+(dub*192 div 2)+16;

  x0:=(getmaxx div 2)-8*(length(s) div 2);
  case bkcolor of
   black,blue,red,magenta: setcolor(7);
   green,cyan,brown,lightgray: setcolor(0);
  end;
  textxy(x0,y0,s);

  x0:=(GetMaxX div 2)+((256*dub) div 2)-5*9-(dub-1)*6;;

  setcolor(lightred);
  for z1:=1 to 9 do
  line(z1+x0{+8*length(s){}, y0+16, z1+x0{+8*length(s){}+8, y0);

  setcolor(yellow);
  for z1:=1 to 9 do
  line(z1+9+x0{+8*length(s){}, y0+16, z1+9+x0{+8*length(s){}+8, y0);

  setcolor(lightgreen);
  for z1:=1 to 9 do
  line(z1+18+x0{+8*length(s){}, y0+16, z1+18+x0{+8*length(s){}+8, y0);

  setcolor(lightcyan);
  for z1:=1 to 9 do
  line(z1+27+x0{+8*length(s){}, y0+16, z1+27+x0{+8*length(s){}+8, y0);
 end
else
 begin
  x0:=(GetMaxX div 2)-(256*dub div 2);
  y0:=(getmaxy div 2)+(192*dub div 2)+16;
  setcolor(bkcolor); bar(0,y0-1,getmaxx,y0+16+1);{}
 end;

End;
{}

Procedure Load;
Begin
{$I-}
 for a:=1 to 6144*3 do scr^[a]:=0;
 Assign(f,fname18432); FileMode:=0; Reset(f,1);
 if filesize(f)=18432+17 then seek(f,17);
 BlockRead(f,scr^,6144*3); Close(f);
{$I+}
if IOResult<>0 then;
End;


Label loop,beg,start,clear;
BEGIN
SaveTextMode;
if CheckDirFile(fname18432)<>0 then exit;
 GetMem(scr,6144*3);
 Load;

 dub:=1;
 info:=true;
 screen:=false;

 VideoMode:=v640x480x256;

 GetProfile(startdir+'\sn.ini','View','Border',ss);
 a:=vall(ss); if a<0 then a:=0; if a>7 then a:=7;
 SetBkColor(a);

 GetProfile(startdir+'\sn.ini','View','Info',ss);
 if nospace(ss)='1' then info:=true else info:=false;

 GetProfile(startdir+'\sn.ini','View','Size',ss);
 a:=vall(ss); if a<1 then a:=1; if a>4 then a:=4;
 dub:=a;

 GetProfile(startdir+'\sn.ini','View','VideoMode',ss);
 if ss='320x200' then VideoMode:=v320x200x256;
 if ss='640x400' then VideoMode:=v640x400x256;
 if ss='640x480' then VideoMode:=v640x480x256;
 if ss='800x600' then VideoMode:=v800x600x256;
 if ss='1024x768' then VideoMode:=v1024x768x256;

beg:

 InitGraph(VideoMode);

    a:=45; b:=255;

    SetRGBPalette(Blue,         0,0,a);
    SetRGBPalette(Red,          a,0,0);
    SetRGBPalette(Magenta,      a,0,a);
    SetRGBPalette(Green,        0,a,0);
    SetRGBPalette(Brown,        a,a,0);
    SetRGBPalette(LightGray,    a,a,a);

    SetRGBPalette(LightBlue,    0,0,b);
    SetRGBPalette(LightRed,     b,0,0);
    SetRGBPalette(LightMagenta, b,0,b);
    SetRGBPalette(LightGreen,   0,b,0);
    SetRGBPalette(Yellow,       b,b,0);
    SetRGBPalette(White,        b,b,b);

 zx[1]:=Blue; zx[2]:=Red; zx[3]:=Magenta; zx[4]:=Green;
 zx[5]:=Cyan; zx[6]:=Brown; zx[7]:=LightGray;

 zx[8]:=LightBlue; zx[9]:=LightRed; zx[10]:=LightMagenta; zx[11]:=LightGreen;
 zx[12]:=LightCyan; zx[13]:=Yellow; zx[14]:=White;

 Case focus of
  left:  p:=lp;
  right: p:=rp;
 End;

clear:
 ClearDevice;

start:
 PrintXpc;

loop:
key:=KeyCode;
{Case key of{}
if key=PadMinus then
              begin
               if VideoMode=$105 then begin VideoMode:=$103; goto beg; end;
               if VideoMode=$103 then begin VideoMode:=$101; goto beg; end;
               if VideoMode=$101 then begin VideoMode:=$100; goto beg; end;
               if VideoMode=$100 then begin VideoMode:=$13;  goto beg; end;
               if VideoMode=$13 then goto loop;
              end;

if key=PadPlus then
              begin
               if VideoMode=$13  then begin VideoMode:=$100; goto beg; end;
               if VideoMode=$100 then begin VideoMode:=$101; goto beg; end;
               if VideoMode=$101 then begin VideoMode:=$103; goto beg; end;
               if VideoMode=$103 then begin VideoMode:=$105; goto beg; end;
               if VideoMode=$105 then goto loop;
              end;

if (key=_LowI)or(key=_UpI) then
              begin info   :=not info;   goto start; end;

if (key=_LowC)or(key=_UpC)or(key=_Space) then
              begin screen :=not screen; goto start; end;

if key=_PgUp then
              begin inc(dub); if dub>4 then begin dub:=4; goto loop; end else goto Clear; end;
if key=_PgDn then
              begin dec(dub); if dub<1 then begin dub:=1; goto loop; end else goto Clear; end;

if key=_Num1 then
              begin SetBkColor(Blue);      goto Clear; end;
if key=_Num2 then
              begin SetBkColor(Red);       goto Clear; end;
if key=_Num3 then
              begin SetBkColor(Magenta);   goto Clear; end;
if key=_Num4 then
              begin SetBkColor(Green);     goto Clear; end;
if key=_Num5 then
              begin SetBkColor(Cyan);      goto Clear; end;
if key=_Num6 then
              begin SetBkColor(Brown);     goto Clear; end;
if key=_Num7 then
              begin SetBkColor(LightGray); goto Clear; end;
if key=_Num0 then
              begin SetBkColor(Black);     goto Clear; end;

if (key=_Right)or(key=_Down) then
              begin
               if p.PanelType=pcPanel then
                BEGIN
                 b:=IndexOf(Focus)+1;
                 if b>p.tdirs+p.tfiles then b:=p.tdirs+p.tfiles;
                 for a:=b to p.tdirs+p.tfiles do
                  begin
                   if ((strlo(p.pcDir^[a].fext)='xpc')and(p.pcDir^[a].flength=18432))
                   or ((strlo(p.pcDir^[a].fext[1])='$')and(p.pcDir^[a].flength=18432+17)){}
                   then
                    Begin
                     Case focus of
                      left:  begin
                              inc(lp.pcf,(a-IndexOf(focus)));
                              lp.Inside;
                             end;
                      right: begin
                              inc(rp.pcf,(a-IndexOf(focus)));
                              rp.Inside;
                             end;
                     End;
                     fname18432:=p.pcnd+p.TrueName(a);
                     s:=p.TrueName(a);
                     Load;
                     goto start;
                    End else if a>=p.tdirs+p.tfiles then goto loop;;
                  end;
                END;
              end;

if (key=_Left)or(key=_Up) then
              begin
               if p.PanelType=pcPanel then
                BEGIN
                 for a:=IndexOf(Focus)-1 downto 1 do
                  begin
                   if ((strlo(p.pcDir^[a].fext)='xpc')and(p.pcDir^[a].flength=18432))
                   or ((strlo(p.pcDir^[a].fext[1])='$')and(p.pcDir^[a].flength=18432+17)){}
                   then
                    Begin
                     Case focus of
                      left:  begin
                              dec(lp.pcf,(IndexOf(focus)-a));
                              lp.Inside;
                             end;
                      right: begin
                              dec(rp.pcf,(IndexOf(focus)-a));
                              rp.Inside;
                             end;
                     End;
                     fname18432:=p.pcnd+p.TrueName(a);
                     s:=p.TrueName(a);
                     Load;
                     goto start;
                    End else if a<=1 then goto loop;
                  end;
                END;
              end;
{End;{}
CloseGraph;{}
RestTextMode;
flash(off);
FreeMem(scr,6144*3);
END;

Begin
End.
