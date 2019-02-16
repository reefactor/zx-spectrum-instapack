{$O+,F+}
Unit sn_Setup;
Interface
Var sp1,sp2:string;

function Setup:boolean;

Implementation
Uses rv,Crt,Dos,
     vars, main_ovr, main, init, palette, sn_kbd, sn_obj;

Type
        TMenu=
         record
          str:string[70];
          pos:byte;
          raz:boolean;
         end;

Const
        MaxMenu=30;
Var
        menu:array[0..MaxMenu] of TMenu;
        max,linepos,lev,i,ind,tot:word;
        userout:boolean;
        m:byte;
        s,fn:string;
{============================================================================}
function Setup:boolean;

function Edit(var s:string):boolean;
begin
edit:=false;
 colour(menu_bkNT,menu_txtNT);
 scputwin(menu_bkNT,menu_txtNT,17,halfmaxy-2,64,halfmaxy-3+3);
 printself(menu_bkNT,menu_txtNT,19,halfmaxy-1,44);
 colour(menu_bkNT,menu_txtNT);
 curon;
 s:=nospaceLR(scanf(20,halfmaxy-1,s,255,42,1));
 curoff;
 restscr;

 if not scanf_esc then edit:=true;

end;


procedure Change(lv,n,f:byte);
begin
if lev=2 then
 Begin
  if n=1 then
   Begin
    if (f=1)or(f=2)or(f=3)or(f=4)or(f=5) then
     Begin
      GetProfile(fn,'Interface','Group'+strr(f),s);
      if Edit(s) then WriteProfile(fn,'Interface','Group'+strr(f),s);
      Case f of 1:Group1:=s; 2:Group2:=s; 3:Group3:=s;
                4:Group4:=s; 5:Group5:=s; End;
     End;
    if (f=6) then
     Begin
      GetProfile(fn,'Interface','GroupExe',s);
      if Edit(s) then WriteProfile(fn,'Interface','GroupExe',s);
      GExe:=s;
     End;
    if (f=7) then
     Begin
      GetProfile(fn,'Interface','GroupArc',s);
      if Edit(s) then WriteProfile(fn,'Interface','GroupArc',s);
      GArc:=s;
     End;
   End;
  if n=2 then
   Begin
    if f=1 then
     Begin
      GetProfile(fn,'Interface','Clock',s);
      if s[1]='1' then s:='0' else s:='1';
      WriteProfile(fn,'Interface','Clock',s);
      setup:=true;
     End;
    if f=2 then
     Begin
      GetProfile(fn,'Interface','NameLine',s);
      if s[1]='1' then s:='0' else s:='1';
      WriteProfile(fn,'Interface','NameLine',s);
      setup:=true;
     End;
    if f=3 then
     Begin
      GetProfile(fn,'Interface','DiskLine',s);
      if s[1]='1' then s:='0' else s:='1';
      WriteProfile(fn,'Interface','DiskLine',s);
      setup:=true;
     End;
    if f=4 then
     Begin
      GetProfile(fn,'Interface','InfoLines',s);
      m:=vall(s); inc(m); if m>3 then m:=1; s:=strr(m);
      WriteProfile(fn,'Interface','InfoLines',s);
      setup:=true;
     End;
    if f=5 then
     Begin
      GetProfile(fn,'Interface','LColumns',s);
      m:=vall(s); inc(m); if m>3 then m:=1; s:=strr(m);
      WriteProfile(fn,'Interface','LColumns',s);
      setup:=true;
     End;
    if f=6 then
     Begin
      GetProfile(fn,'Interface','RColumns',s);
      m:=vall(s); inc(m); if m>3 then m:=1; s:=strr(m);
      WriteProfile(fn,'Interface','RColumns',s);
      setup:=true;
     End;
    if f=7 then
     Begin
      GetProfile(fn,'Interface','HideCmdLine',s);
      if s[1]='1' then s:='0' else s:='1';
      WriteProfile(fn,'Interface','HideCmdLine',s);
      setup:=true;
     End;
   End;
  if n=3 then
   Begin
      GetProfile(fn,'Priory',strr(f),s);
      if Edit(s) then WriteProfile(fn,'Priory',strr(f),s);
      setup:=true;
   End;
  if n=4 then
   Begin
    if f=1 then
     Begin
      GetProfile(fn,'System','National',s);
      if strlo(s)='rus' then s:='Eng' else s:='Rus';
      WriteProfile(fn,'System','National',s);
      setup:=true;
     End;
    if f=2 then
     Begin
      GetProfile(fn,'System','Focus',s);
      if strlo(s)='left' then s:='Right' else s:='Left';
      WriteProfile(fn,'System','Focus',s);
     End;
    if f=3 then
     Begin
      GetProfile(fn,'System','LoadDesktop',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','LoadDesktop',s);
     End;
    if f=4 then
     Begin
      GetProfile(fn,'System','RestoreVideo',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','RestoreVideo',s);
      setup:=true;
     End;
    if f=5 then
     Begin
      GetProfile(fn,'System','Esc_ShowUserScr',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','Esc_ShowUserScr',s);
      setup:=true;
     End;
    if f=6 then
     Begin
      GetProfile(fn,'System','Del_F8',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','Del_F8',s);
      setup:=true;
     End;
    if f=7 then
     Begin
      GetProfile(fn,'System','BkSpUpDir',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','BkSpUpDir',s);
      setup:=true;
     End;
    if f=8 then
     Begin
      GetProfile(fn,'System','Refresh',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','Refresh',s);
      setup:=true;
     End;
    if f=9 then
     Begin
      GetProfile(fn,'System','HideHidden',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','HideHidden',s);
      setup:=true;
     End;
    if f=10 then
     Begin
      GetProfile(fn,'System','LoadStartDirs',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','LoadStartDirs',s);
     End;
    if f=11 then
     Begin
      GetProfile(fn,'System','LStartDir',s);
      if Edit(s) then WriteProfile(fn,'System','LStartDir',s);
     End;
    if f=12 then
     Begin
      GetProfile(fn,'System','RStartDir',s);
      if Edit(s) then WriteProfile(fn,'System','RStartDir',s);
     End;
    if f=13 then
     Begin
      GetProfile(fn,'System','SaveOnExit',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'System','SaveOnExit',s);
     End;
    if f=14 then
     Begin
      GetProfile(fn,'System','DiskMenuType',s);
      m:=vall(s); inc(m); if m>3 then m:=0; s:=strr(m);
      WriteProfile(fn,'System','DiskMenuType',s);
      setup:=true;
     End;
   End;
  if n=5 then
   Begin
    if f=1 then
     Begin
      GetProfile(fn,'Spectrum','AutoMove',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','AutoMove',s);
      setup:=true;
     End;
    if f=2 then
     Begin
      GetProfile(fn,'Spectrum','Execute',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','Execute',s);
      setup:=true;
     End;
    if f=3 then
     Begin
      GetProfile(fn,'Spectrum','ExecuteEmulator',s);
      if Edit(s) then WriteProfile(fn,'Spectrum','ExecuteEmulator',s);
      setup:=true;
     End;
    if f=4 then
     Begin
      GetProfile(fn,'Spectrum','HobetaStartAddr',s);
      if Edit(s) then WriteProfile(fn,'Spectrum','HobetaStartAddr',s);
      setup:=true;
     End;
    if f=5 then
     Begin
      GetProfile(fn,'Spectrum','TRDOS3',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','TRDOS3',s);
      setup:=true;
     End;
    if f=6 then
     Begin
      GetProfile(fn,'Spectrum','TRDOS3onStart',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','TRDOS3onStart',s);
      setup:=true;
     End;
    if f=7 then
     Begin
      GetProfile(fn,'Spectrum','hob2scl',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','hob2scl',s);
      setup:=true;
     End;
    if f=8 then
     Begin
      GetProfile(fn,'Spectrum','noHobNaming',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','noHobNaming',s);
      setup:=true;
     End;
    if f=9 then
     Begin
      GetProfile(fn,'Spectrum','Cat9',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','Cat9',s);
      setup:=true;
     End;
    if f=11 then
     Begin
      GetProfile(fn,'Spectrum','zxzip',s);
      if Edit(s) then WriteProfile(fn,'Spectrum','zxzip',s);
      setup:=true;
     End;
    if f=12 then
     Begin
      GetProfile(fn,'Spectrum','zxunzip',s);
      if Edit(s) then WriteProfile(fn,'Spectrum','zxunzip',s);
      setup:=true;
     End;
    if f=13 then
     Begin
      GetProfile(fn,'Spectrum','zxzip1line',s);
      menu_name[1]:='1'; menu_name[2]:='2'; menu_name[3]:='3'; menu_name[4]:='4';
      menu_name[5]:='5'; menu_name[6]:='6'; menu_name[7]:='7'; menu_total:=7; menu_visible:=7;
      menu_f:=vall(s); menu_title:='';
      m:=(ChooseItem);
      if m<>0 then WriteProfile(fn,'Spectrum','zxzip1line',strr(m));
      setup:=true;
     End;
    if f=15 then
     Begin
      GetProfile(fn,'Spectrum','LoadUp80',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','LoadUp80',s);
      setup:=true;
     End;
    if f=16 then
     Begin
      GetProfile(fn,'Spectrum','CheckMedia',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'Spectrum','CheckMedia',s);
      setup:=true;
     End;
   End;
  if n=6 then
   Begin
    if f=1 then
     Begin
      GetProfile(fn,'View','Default',s);
      if Edit(s) then WriteProfile(fn,'View','Default',s);
     End;
    if f=2 then
     Begin
      GetProfile(fn,'View','HobetaBasic',s);
      if Edit(s) then WriteProfile(fn,'View','HobetaBasic',s);
     End;
    if f=3 then
     Begin
      GetProfile(fn,'View','HobetaScreen',s);
      if Edit(s) then WriteProfile(fn,'View','HobetaScreen',s);
     End;
    if f=4 then
     Begin
      GetProfile(fn,'View','HobetaTrueScreen',s);
      if Edit(s) then WriteProfile(fn,'View','HobetaTrueScreen',s);
     End;
    if f=5 then
     Begin
      GetProfile(fn,'View','HobetaCode',s);
      if Edit(s) then WriteProfile(fn,'View','HobetaCode',s);
     End;
    if f=7 then
     Begin
      GetProfile(fn,'View','Border',s);
      if LANG=rus then
       Begin
        menu_name[1]:='Черный'; menu_name[2]:='Синий'; menu_name[3]:='Красный';
        menu_name[4]:='Пурпурный'; menu_name[5]:='Зеленый'; menu_name[6]:='Голубой';
        menu_name[7]:='Желтый'; menu_name[8]:='Белый';
       End
      else
       Begin
        menu_name[1]:='Black'; menu_name[2]:='Blue'; menu_name[3]:='Red';
        menu_name[4]:='Magenta'; menu_name[5]:='Green'; menu_name[6]:='Cyan';
        menu_name[7]:='Yellow'; menu_name[8]:='White';
       End;

      menu_total:=8; menu_visible:=8; menu_title:='';
      menu_f:=vall(s)+1;
      m:=(ChooseItem);
      if m<>0 then WriteProfile(fn,'View','Border',strr(m-1));
     End;
    if f=8 then
     Begin
      GetProfile(fn,'View','Info',s);
      if strlo(s)='1' then s:='0' else s:='1';
      WriteProfile(fn,'View','Info',s);
     End;
    if f=9 then
     Begin
      GetProfile(fn,'View','Size',s);
      m:=vall(s); inc(m); if m>4 then m:=1; s:=strr(m);
      WriteProfile(fn,'View','Size',s);
     End;
    if f=10 then
     Begin
      GetProfile(fn,'View','VideoMode',s);
      if strlo(s)='320x200' then menu_f:=1;
      if strlo(s)='640x400' then menu_f:=2;
      if strlo(s)='640x480' then menu_f:=3;
      if strlo(s)='800x600' then menu_f:=4;
      if strlo(s)='1024x768' then menu_f:=5;
      menu_name[1]:='320x200'; menu_name[2]:='640x400';
      menu_name[3]:='640x480'; menu_name[4]:='800x600';
      menu_name[5]:='1024x768'; menu_total:=5; menu_visible:=5; menu_title:='';
      m:=(ChooseItem);
      if menu_f=1 then s:='320x200';
      if menu_f=2 then s:='640x400';
      if menu_f=3 then s:='640x480';
      if menu_f=4 then s:='800x600';
      if menu_f=5 then s:='1024x768';
      if m<>0 then WriteProfile(fn,'View','VideoMode',s);
     End;
   End;
  if n=7 then
   Begin
    if f=1 then
     Begin
      GetProfile(fn,'Edit','Default',s);
      if Edit(s) then WriteProfile(fn,'Edit','Default',s);
     End;
   End;
  if n=14 then
   Begin
    if pos('...',menu[f].str)<>0 then else
     begin
      WriteProfile(fn,'Interface','PalleteFile',strlo(menu[f].str));
      UserOut:=true;
      setup:=true;
     end;
   End;
  if n=18 then
   Begin
    if pos('...',menu[f].str)<>0 then begin LoadDefaultKBD; UserOut:=true; end else
     begin
      WriteProfile(fn,'Interface','KeyboardFile',strlo(menu[f].str));
      LoadKBD;
      UserOut:=true;
     end;
   End;
 End;
{message(strr(lev)+' '+strr(n)+' '+strr(f));{}
if lev=1 then
 Begin
  if f=9 then
   Begin
    SaveDesktop(StartDir+'\sn.dsk');
    UserOut:=true;
   End;
  if f=10 then
   Begin
    snKernelExitCode:=Focus;
    LoadDesktop(StartDir+'\sn.dsk');{}
    reMDF; reTrueCur; reInside;
    Focus:=snKernelExitCode;
    GlobalRedraw;{}
    UserOut:=true;
    setup:=true;
   End;
  if f=16 then
   Begin
    SetupKBD;
   End;
  if f=17 then
   Begin
    CancelSB;
    colour(pal.bkdRama,pal.txtdRama);
    scputwin(pal.bkdRama,pal.txtdRama,27,halfmaxy-4,54,halfmaxy+0);
    if lang=rus then cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Запись раскладки ')
                else cmcentre(pal.bkdRama,pal.txtdRama,halfmaxy-4,' Save keys ');
    if lang=rus then cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'Имя файла:')
                else cmprint(pal.bkdLabelST,pal.txtdLabelST,31,halfmaxy-2,'File name:');
    printself(pal.bkdInputNT,pal.txtdInputNT,42,halfmaxy-2,8);
    colour(pal.bkdInputNT,pal.txtdInputNT); s:='';
    curon; s:=scanf(42,halfmaxy-2,'',8,8,1); curoff;
    restscr;
    s:=nospace(GetOf(s,_name));
    if s='' then exit;
    if scanf_esc then exit;
    SaveKBD(s);
    UserOut:=true;{}
   End;
 End;
end;


procedure Load(lv,n:byte);

procedure Scan(dir,mask:string);
Var DirInfo : SearchRec; i:word; fnd:boolean;
begin
FindFirst(dir+mask, Archive, DirInfo);
{ Аналог команды DIR *.PAS }
i:=1; fnd:=false;
While DosError = 0 Do
 Begin
  menu[i].str:=strhi(DirInfo.name);
  menu[i].str:=menu[i].str+space(12-length(menu[i].str));
  FindNext(DirInfo);
  Inc(i);
  if i>16 then break;
  fnd:=true;
 End;
if not fnd then exit;
tot:=i-1;
end;

begin
for i:=1 to MaxMenu do menu[i].raz:=false;

if lev=1 then
 Begin
  menu[ 8].raz:=true;
  menu[11].raz:=true;
  menu[15].raz:=true;
  if LANG=rus then
   Begin
    menu[ 1].str:='~`Г~`руппы файлов                   ';
    menu[ 2].str:='~`И~`нтерфейс                       ';
    menu[ 3].str:='~`П~`риоритеты                      ';
    menu[ 4].str:='~`С~`истемные установки             ';
    menu[ 5].str:='Спектру~`м~`                        ';
    menu[ 6].str:='П~`р~`осмотр файлов                 ';
    menu[ 7].str:='Р~`е~`дактор файлов                 ';
    menu[ 9].str:='~`З~`апомнить состояние              ';
    menu[10].str:='~`В~`осстановить состояние           ';
    menu[12].str:='~`Ц~`вета...                         ';
    menu[13].str:='Со~`х~`ранить палитру                ';
    menu[14].str:='Загрузи~`т~`ь палитру               ';
    menu[16].str:='~`К~`лавиатура...                    ';
    menu[17].str:='Сохра~`н~`ить раскладку клавиатуры   ';
    menu[18].str:='Загр~`у~`зить раскладку клавиатуры  ';
   End
  else
   Begin
    menu[ 1].str:='~`H~`ighlight groups                ';
    menu[ 2].str:='~`I~`nterface                       ';
    menu[ 3].str:='Files ~`l~`evels                    ';
    menu[ 4].str:='S~`y~`stem setup                    ';
    menu[ 5].str:='~`S~`pectrum                        ';
    menu[ 6].str:='~`V~`iewers                         ';
    menu[ 7].str:='~`E~`ditors                         ';
    menu[ 9].str:='S~`a~`ve desktop                     ';
    menu[10].str:='L~`o~`ad desktop                     ';
    menu[12].str:='~`C~`olors...                        ';
    menu[13].str:='Store ~`p~`alette                    ';
    menu[14].str:='Load palet~`t~`e                    ';
    menu[16].str:='~`K~`eyboard...                      ';
    menu[17].str:='Store keyboard layo~`u~`t            ';
    menu[18].str:='Load keyboa~`r~`d layout            ';
   End;

  tot:=18;
 End;
if lev=2 then
 Begin
  if n=1 then
   Begin
    if LANG=rus then
     Begin
      menu[1].str:='Группа ~`1~`   ';
      menu[2].str:='Группа ~`2~`   ';
      menu[3].str:='Группа ~`3~`   ';
      menu[4].str:='Группа ~`4~`   ';
      menu[5].str:='Группа ~`5~`   ';
      menu[6].str:='~`И~`сполняемые';
      menu[7].str:='~`А~`рхивы     ';
     End
    else
     Begin
      menu[1].str:='Group ~`1~`   ';
      menu[2].str:='Group ~`2~`   ';
      menu[3].str:='Group ~`3~`   ';
      menu[4].str:='Group ~`4~`   ';
      menu[5].str:='Group ~`5~`   ';
      menu[6].str:='~`E~`xecutable';
      menu[7].str:='~`A~`rchives  ';
     End;
    tot:=7;
   End;
  if n=2 then
   Begin
    if LANG=rus then menu[1].str:='~`Ч~`асы                     '
                else menu[1].str:='~`C~`lock                    ';
    GetProfile(fn,'Interface','Clock',s);
    if LANG=rus then if s='1' then menu[1].str:=menu[1].str+'  Вкл ' else menu[1].str:=menu[1].str+'  Выкл'
                else if s='1' then menu[1].str:=menu[1].str+'  On  ' else menu[1].str:=menu[1].str+'  Off ';

    if LANG=rus then menu[2].str:='Заголовок п~`а~`нелей        '
                else menu[2].str:='~`P~`anels header            ';
    GetProfile(fn,'Interface','NameLine',s);
    if LANG=rus then if s='1' then menu[2].str:=menu[2].str+'  Вкл ' else menu[2].str:=menu[2].str+'  Выкл'
                else if s='1' then menu[2].str:=menu[2].str+'  On  ' else menu[2].str:=menu[2].str+'  Off ';

    if LANG=rus then menu[3].str:='Строка ~`д~`исков            '
                else menu[3].str:='~`D~`isk line                ';
    GetProfile(fn,'Interface','DiskLine',s);
    if LANG=rus then if s='1' then menu[3].str:=menu[3].str+'  Вкл ' else menu[3].str:=menu[3].str+'  Выкл'
                else if s='1' then menu[3].str:=menu[3].str+'  On  ' else menu[3].str:=menu[3].str+'  Off ';

    if LANG=rus then menu[4].str:='Кол-во ~`и~`нф.строк         '
                else menu[4].str:='~`I~`nfo lines               ';
    GetProfile(fn,'Interface','InfoLines',s);
    menu[4].str:=menu[4].str+'  '+s[1]+'   ';

    if LANG=rus then menu[5].str:='Число колонок ~`л~`ев.панели '
                else menu[5].str:='Columns of ~`l~`eft panel    ';
    GetProfile(fn,'Interface','LColumns',s);
    menu[5].str:=menu[5].str+'  '+s[1]+'   ';

    if LANG=rus then menu[6].str:='Число колонок ~`п~`рав.панели'
                else menu[6].str:='Columns of ~`r~`ight panel   ';
    GetProfile(fn,'Interface','RColumns',s);
    menu[6].str:=menu[6].str+'  '+s[1]+'   ';

    if LANG=rus then menu[7].str:='~`С~`крывать командную строку'
                else menu[7].str:='~`H~`ide command line        ';
    GetProfile(fn,'Interface','HideCmdLine',s);
    if LANG=rus then if s='1' then menu[7].str:=menu[7].str+'  Да  ' else menu[7].str:=menu[7].str+'  Нет '
                else if s='1' then menu[7].str:=menu[7].str+'  Yes ' else menu[7].str:=menu[7].str+'  No  ';

    tot:=7;
   End;
  if n=3 then
   Begin
    if LANG=rus then
     Begin
      menu[1].str:='Уровень ~`1~`';
      menu[2].str:='Уровень ~`2~`';
      menu[3].str:='Уровень ~`3~`';
      menu[4].str:='Уровень ~`4~`';
      menu[5].str:='Уровень ~`5~`';
      menu[6].str:='Уровень ~`6~`';
      menu[7].str:='Уровень ~`7~`';
      menu[8].str:='Уровень ~`8~`';
      menu[9].str:='Уровень ~`9~`';
     End
    else
     Begin
      menu[1].str:='Level ~`1~`';
      menu[2].str:='Level ~`2~`';
      menu[3].str:='Level ~`3~`';
      menu[4].str:='Level ~`4~`';
      menu[5].str:='Level ~`5~`';
      menu[6].str:='Level ~`6~`';
      menu[7].str:='Level ~`7~`';
      menu[8].str:='Level ~`8~`';
      menu[9].str:='Level ~`9~`';
     End;
    tot:=9;
   End;
  if n=4 then
   Begin
    if LANG=rus then menu[1].str:='~`Я~`зык программы                  '
                else menu[1].str:='Progra~`m~` language                ';
    GetProfile(fn,'System','National',s);
    if LANG=rus then if strlo(s)='rus'then menu[1].str:=menu[1].str+'  Русский   'else menu[1].str:=menu[1].str+'  Английский'
                else if strlo(s)='rus'then menu[1].str:=menu[1].str+'  Russian   'else menu[1].str:=menu[1].str+'  English   ';

    if LANG=rus then menu[2].str:='~`А~`ктивная панель при старте      '
                else menu[2].str:='~`A~`ctive panel on start           ';
    GetProfile(fn,'System','Focus',s);
  if LANG=rus then if strlo(s)='right'then menu[2].str:=menu[2].str+'  Правая    'else menu[2].str:=menu[2].str+'  Левая     '
              else if strlo(s)='right'then menu[2].str:=menu[2].str+'  Right     'else menu[2].str:=menu[2].str+'  Left      ';

    if LANG=rus then menu[3].str:='~`З~`агружать Desktop при старте    '
                else menu[3].str:='Load d~`e~`sktop on start           ';
    GetProfile(fn,'System','LoadDesktop',s);
    if LANG=rus then if s='1' then menu[3].str:=menu[3].str+'  Да        ' else menu[3].str:=menu[3].str+'  Нет       '
                else if s='1' then menu[3].str:=menu[3].str+'  Yes       ' else menu[3].str:=menu[3].str+'  No        ';

    if LANG=rus then menu[4].str:='~`В~`осстанавливать видеорежим      '
                else menu[4].str:='Restore ~`v~`ideo mode              ';
    GetProfile(fn,'System','RestoreVideo',s);
    if LANG=rus then if s='1' then menu[4].str:=menu[4].str+'  Да        ' else menu[4].str:=menu[4].str+'  Нет       '
                else if s='1' then menu[4].str:=menu[4].str+'  Yes       ' else menu[4].str:=menu[4].str+'  No        ';

    if LANG=rus then menu[5].str:='ESC показать экран ~`Д~`ОС          '
                else menu[5].str:='ESC for ~`u~`ser screen             ';
    GetProfile(fn,'System','Esc_ShowUserScr',s);
    if LANG=rus then if s='1' then menu[5].str:=menu[5].str+'  Да        ' else menu[5].str:=menu[5].str+'  Нет       '
                else if s='1' then menu[5].str:=menu[5].str+'  Yes       ' else menu[5].str:=menu[5].str+'  No        ';

    if LANG=rus then menu[6].str:='DEL использовать для ~`у~`даления   '
                else menu[6].str:='DEL erases ~`f~`ile(s)              ';
    GetProfile(fn,'System','Del_F8',s);
    if LANG=rus then if s='1' then menu[6].str:=menu[6].str+'  Да        ' else menu[6].str:=menu[6].str+'  Нет       '
                else if s='1' then menu[6].str:=menu[6].str+'  Yes       ' else menu[6].str:=menu[6].str+'  No        ';

    if LANG=rus then menu[7].str:='BackSpace - вв~`е~`рх по дереву     '
                else menu[7].str:='BS - ~`g~`o to upper directory      ';
    GetProfile(fn,'System','BkSpUpDir',s);
    if LANG=rus then if s='1' then menu[7].str:=menu[7].str+'  Да        ' else menu[7].str:=menu[7].str+'  Нет       '
                else if s='1' then menu[7].str:=menu[7].str+'  Yes       ' else menu[7].str:=menu[7].str+'  No        ';

    if LANG=rus then menu[8].str:='~`О~`бновлять панели при копировании'
                else menu[8].str:='Refresh ~`w~`hile copying           ';
    GetProfile(fn,'System','Refresh',s);
    if LANG=rus then if s='1' then menu[8].str:=menu[8].str+'  Да        ' else menu[8].str:=menu[8].str+'  Нет       '
                else if s='1' then menu[8].str:=menu[8].str+'  Yes       ' else menu[8].str:=menu[8].str+'  No        ';

    if LANG=rus then menu[9].str:='~`Н~`е показывать скрытые файлы     '
                else menu[9].str:='~`H~`ide hidden files               ';
    GetProfile(fn,'System','HideHidden',s);
    if LANG=rus then if s='1' then menu[9].str:=menu[9].str+'  Да        ' else menu[9].str:=menu[9].str+'  Нет       '
                else if s='1' then menu[9].str:=menu[9].str+'  Yes       ' else menu[9].str:=menu[9].str+'  No        ';

    if LANG=rus then menu[10].str:='Панели в ~`к~`аталог при старте     '
                else menu[10].str:='Load d~`i~`rs on start              ';
    GetProfile(fn,'System','LoadStartDirs',s);
    if LANG=rus then if s='1' then menu[10].str:=menu[10].str+'  Да        ' else menu[10].str:=menu[10].str+'  Нет       '
                else if s='1' then menu[10].str:=menu[10].str+'  Yes       ' else menu[10].str:=menu[10].str+'  No        ';

    if LANG=rus then menu[11].str:='└┬При старте ~`л~`ев.панель в...                '
                else menu[11].str:='└┬~`L~`eft panel in...                          ';
    if LANG=rus then menu[12].str:=' ├При старте ~`п~`рав.панель в...               '
                else menu[12].str:=' ├~`R~`ight panel in...                         ';

    if LANG=rus then menu[13].str:=' └Сохранять при в~`ы~`ходе          '
                else menu[13].str:=' └~`S~`ave on exit                  ';
    GetProfile(fn,'System','SaveOnExit',s);
  if LANG=rus then if strlo(s)='1'then menu[13].str:=menu[13].str+'  Да        'else menu[13].str:=menu[13].str+'  Нет       '
              else if strlo(s)='1'then menu[13].str:=menu[13].str+'  Yes       'else menu[13].str:=menu[13].str+'  No        ';

    if LANG=rus then menu[14].str:='Тип меню выбора д~`и~`ска           '
                else menu[14].str:='~`C~`hange drive menu type          ';
    GetProfile(fn,'System','DiskMenuType',s);
    if (s[1]<>'1')and(s[1]<>'2')and(s[1]<>'3')and(s[1]<>'0') then
                         menu[14].str:=menu[14].str+'            ';
    if strlo(s)='0' then menu[14].str:=menu[14].str+'  SNshot    ';
    if strlo(s)='1' then menu[14].str:=menu[14].str+'  SN        ';
    if strlo(s)='2' then menu[14].str:=menu[14].str+'  DN        ';
    if strlo(s)='3' then menu[14].str:=menu[14].str+'  NC        ';

    tot:=14;
   End;
  if n=5 then
   Begin
    if LANG=rus then menu[1].str:='~`А~`втоуплотнение                '
                else menu[1].str:='Auto ~`m~`ove                     ';
    GetProfile(fn,'Spectrum','AutoMove',s);
    if LANG=rus then if strlo(s)='1' then menu[1].str:=menu[1].str+'  Да   ' else menu[1].str:=menu[1].str+'  Нет  '
                else if strlo(s)='1' then menu[1].str:=menu[1].str+'  Yes  ' else menu[1].str:=menu[1].str+'  No   ';

    if LANG=rus then menu[2].str:='~`Р~`азрешить запуск эмулятора    '
                else menu[2].str:='Enable e~`x~`ecute emulator       ';
    GetProfile(fn,'Spectrum','Execute',s);
    if LANG=rus then if strlo(s)='1' then menu[2].str:=menu[2].str+'  Да   ' else menu[2].str:=menu[2].str+'  Нет  '
                else if strlo(s)='1' then menu[2].str:=menu[2].str+'  Yes  ' else menu[2].str:=menu[2].str+'  No   ';

    if LANG=rus then menu[3].str:='~`Э~`мулятор...                          '
                else menu[3].str:='~`E~`mulator...                          ';
    if LANG=rus then menu[4].str:='~`П~`араметр Start по умолчанию   '
                else menu[4].str:='Default ~`s~`tart value           ';
    GetProfile(fn,'Spectrum','HobetaStartAddr',s);
    menu[4].str:=menu[4].str+'  '+copy(s,1,5);

    if LANG=rus then menu[5].str:='Ра~`з~`решить режим TRDOS3        '
                else menu[5].str:='Enable TRDOS~`3~` mode            ';
    GetProfile(fn,'Spectrum','TRDOS3',s);
    if LANG=rus then if strlo(s)='1' then menu[5].str:=menu[5].str+'  Да   ' else menu[5].str:=menu[5].str+'  Нет  '
                else if strlo(s)='1' then menu[5].str:=menu[5].str+'  Yes  ' else menu[5].str:=menu[5].str+'  No   ';

    if LANG=rus then menu[6].str:='~`В~`ключать TRDOS3 при старте    '
                else menu[6].str:='~`T~`RDOS3 mode on start          ';
    GetProfile(fn,'Spectrum','TRDOS3onStart',s);
    if LANG=rus then if strlo(s)='1' then menu[6].str:=menu[6].str+'  Да   ' else menu[6].str:=menu[6].str+'  Нет  '
                else if strlo(s)='1' then menu[6].str:=menu[6].str+'  Yes  ' else menu[6].str:=menu[6].str+'  No   ';

    if LANG=rus then menu[7].str:='~`К~`опирование в MSDOS в Hobeta98'
                else menu[7].str:='Make ~`H~`obeta98 while copy      ';
    GetProfile(fn,'Spectrum','hob2scl',s);
    if LANG=rus then if strlo(s)='1' then menu[7].str:=menu[7].str+'  Да   ' else menu[7].str:=menu[7].str+'  Нет  '
                else if strlo(s)='1' then menu[7].str:=menu[7].str+'  Yes  ' else menu[7].str:=menu[7].str+'  No   ';

    if LANG=rus then menu[8].str:='Раз~`д~`елять нехобетные по       '
                else menu[8].str:='~`N~`aming not hobeta files by    ';
    GetProfile(fn,'Spectrum','noHobNaming',s);
    if LANG=rus then if strlo(s)='0' then menu[8].str:=menu[8].str+'  Имени' else menu[8].str:=menu[8].str+'  Раcш.'
                else if strlo(s)='0' then menu[8].str:=menu[8].str+'  Name ' else menu[8].str:=menu[8].str+'  Ext. ';


    if LANG=rus then menu[9].str:='Количество файлов из ~`9~` сектора'
                else menu[9].str:='Directory size from ~`9~`th sector';
    GetProfile(fn,'Spectrum','Cat9',s);
    if LANG=rus then if strlo(s)='1' then menu[9].str:=menu[9].str+'  Да   ' else menu[9].str:=menu[9].str+'  Нет  '
                else if strlo(s)='1' then menu[9].str:=menu[9].str+'  Yes  ' else menu[9].str:=menu[9].str+'  No   ';

    menu[10].raz:=true;
    if LANG=rus then menu[11].str:='ZX ар~`х~`иватор...                      '
                else menu[11].str:='ZX ~`a~`rchiver...                       ';
    if LANG=rus then menu[12].str:='ZX ра~`с~`паковщик...                    '
                else menu[12].str:='ZX ~`u~`npacker...                       ';
    if LANG=rus then menu[13].str:='~`Ф~`айлов в командной строке...  '
                else menu[13].str:='~`F~`iles in command line...      ';
    GetProfile(fn,'Spectrum','zxzip1line',s);
    menu[13].str:=menu[13].str+'  '+s[1]+'    ';

    menu[14].raz:=true;

    if LANG=rus then menu[15].str:='Загружать треки после ~`8~`0      '
                else menu[15].str:='Load tracks after ~`8~`0          ';
    GetProfile(fn,'Spectrum','LoadUp80',s);
    if LANG=rus then if strlo(s)='1' then menu[15].str:=menu[15].str+'  Да   ' else menu[15].str:=menu[15].str+'  Нет  '
                else if strlo(s)='1' then menu[15].str:=menu[15].str+'  Yes  ' else menu[15].str:=menu[15].str+'  No   ';

    if LANG=rus then menu[16].str:='~`О~`пределение типа диска        '
                else menu[16].str:='~`C~`heck media                   ';
    GetProfile(fn,'Spectrum','CheckMedia',s);
    if LANG=rus then if strlo(s)='1' then menu[16].str:=menu[16].str+'  Да   ' else menu[16].str:=menu[16].str+'  Нет  '
                else if strlo(s)='1' then menu[16].str:=menu[16].str+'  Yes  ' else menu[16].str:=menu[16].str+'  No   ';


    tot:=16;
   End;
  if n=6 then
   Begin
    if LANG=rus then menu[1].str:='~`П~`о умолчанию...                 '
                else menu[1].str:='~`D~`efault...                      ';
    if LANG=rus then menu[2].str:='~`Б~`ейсик...                       '
                else menu[2].str:='B~`A~`SIC...                        ';
    if LANG=rus then menu[3].str:='Экраны ~`6~`912 байт...             '
                else menu[3].str:='Screen ~`6~`912 bytes...            ';
    if LANG=rus then menu[4].str:='Экраны ~`1~`8432 байт...            '
                else menu[4].str:='Screen ~`1~`8432 bytes...           ';
    if LANG=rus then menu[5].str:='~`К~`оды...                         '
                else menu[5].str:='~`C~`ODES...                        ';
    menu[6].raz:=true;
    if LANG=rus then menu[7].str:='~`Ц~`вет бордюра         '
                else menu[7].str:='~`B~`order color         ';
    GetProfile(fn,'View','Border',s);
    if (s[1]<>'1')and(s[1]<>'2')and(s[1]<>'3')and(s[1]<>'4')and
       (s[1]<>'5')and(s[1]<>'6')and(s[1]<>'7')and(s[1]<>'0') then
                         menu[ 7].str:=menu[ 7].str+'           ';
    if LANG=rus then
     Begin
      if strlo(s)='1' then menu[ 7].str:=menu[ 7].str+'  Синий    ';
      if strlo(s)='2' then menu[ 7].str:=menu[ 7].str+'  Красный  ';
      if strlo(s)='3' then menu[ 7].str:=menu[ 7].str+'  Пурпурный';
      if strlo(s)='4' then menu[ 7].str:=menu[ 7].str+'  Зеленый  ';
      if strlo(s)='5' then menu[ 7].str:=menu[ 7].str+'  Голубой  ';
      if strlo(s)='6' then menu[ 7].str:=menu[ 7].str+'  Желтый   ';
      if strlo(s)='7' then menu[ 7].str:=menu[ 7].str+'  Белый    ';
      if strlo(s)='0' then menu[ 7].str:=menu[ 7].str+'  Черный   ';
     End
    else
     Begin
      if strlo(s)='1' then menu[ 7].str:=menu[ 7].str+'  Blue     ';
      if strlo(s)='2' then menu[ 7].str:=menu[ 7].str+'  Red      ';
      if strlo(s)='3' then menu[ 7].str:=menu[ 7].str+'  Magenta  ';
      if strlo(s)='4' then menu[ 7].str:=menu[ 7].str+'  Green    ';
      if strlo(s)='5' then menu[ 7].str:=menu[ 7].str+'  Cyan     ';
      if strlo(s)='6' then menu[ 7].str:=menu[ 7].str+'  Yellow   ';
      if strlo(s)='7' then menu[ 7].str:=menu[ 7].str+'  While    ';
      if strlo(s)='0' then menu[ 7].str:=menu[ 7].str+'  Black    ';
     End;

    if LANG=rus then menu[8].str:='П~`о~`казывать информацию'
                else menu[8].str:='~`S~`how info            ';
    GetProfile(fn,'View','Info',s);
    if LANG=rus then if strlo(s)='1' then menu[8].str:=menu[8].str+'  Да       ' else menu[8].str:=menu[8].str+'  Нет      '
                else if strlo(s)='1' then menu[8].str:=menu[8].str+'  Yes      ' else menu[8].str:=menu[8].str+'  No       ';

    if LANG=rus then menu[9].str:='~`Р~`азмер точки         '
                else menu[9].str:='~`P~`ixel size           ';
    GetProfile(fn,'View','Size',s);
    if (s[1]<>'1')and(s[1]<>'2')and(s[1]<>'3')and(s[1]<>'4') then
                         menu[9].str:=menu[9].str+'           ';
    if LANG=rus then
     Begin
      if strlo(s)='1' then menu[ 9].str:=menu[ 9].str+'  1 пиксель';
      if strlo(s)='2' then menu[ 9].str:=menu[ 9].str+'  2 пикселя';
      if strlo(s)='3' then menu[ 9].str:=menu[ 9].str+'  3 пикселя';
      if strlo(s)='4' then menu[ 9].str:=menu[ 9].str+'  4 пикселя';
     End
    else
     Begin
      if strlo(s)='1' then menu[ 9].str:=menu[ 9].str+'  1 pixel  ';
      if strlo(s)='2' then menu[ 9].str:=menu[ 9].str+'  2 pixels ';
      if strlo(s)='3' then menu[ 9].str:=menu[ 9].str+'  3 pixels ';
      if strlo(s)='4' then menu[ 9].str:=menu[ 9].str+'  4 pixels ';
     End;

    if LANG=rus then menu[10].str:='~`С~`тартовый видеорежим '
                else menu[10].str:='~`V~`ideo mode           ';
    GetProfile(fn,'View','VideoMode',s);
    if (s<>'320x200')and(s<>'640x400')and(s<>'640x480')and(s<>'800x600')and(s<>'1024x768') then
                         menu[10].str:=menu[10].str+'           ';
    if strlo(s)='320x200'  then menu[10].str:=menu[10].str+'  320x200  ';
    if strlo(s)='640x400'  then menu[10].str:=menu[10].str+'  640x400  ';
    if strlo(s)='640x480'  then menu[10].str:=menu[10].str+'  640x480  ';
    if strlo(s)='800x600'  then menu[10].str:=menu[10].str+'  800x600  ';
    if strlo(s)='1024x768' then menu[10].str:=menu[10].str+'  1024x768 ';

    tot:=10;
   End;
  if n=7 then
   Begin
    if LANG=rus then menu[1].str:='~`П~`о умолчанию...'
                else menu[1].str:='~`D~`efault...';
    tot:=1;
   End;
  if n=14 then
   Begin
    if LANG=rus then menu[1].str:='~`П~`о умолчанию...'
                else menu[1].str:='~`D~`efault...';
    tot:=1;
    scan(StartDir+'\COLORS\','*.pal');
   End;
  if n=18 then
   Begin
    if LANG=rus then menu[1].str:='~`П~`о умолчанию...'
                else menu[1].str:='~`D~`efault...';
    tot:=1;
    scan(StartDir+'\KEYS\','*.kbd');
   End;
 End;
end;



{----------------------------------------------------------------------------}
procedure brow;
var kb:word;
    mx,my:word;
    sf,f:word;

    ft,fs:text;
    s:string;
    p:TPanel;

procedure pr;
var p1,k1,p2,k2,x,y,i:word;
begin
x:=41-length(without(menu[1].str,'~`')) div 2;
y:=halfmaxy-tot div 2 - 1;
for i:=1 to tot do
 begin
  if i<>f then begin p1:=menu_bkNT; k1:=menu_txtNT; p2:=menu_bkST; k2:=menu_txtST; end
          else begin p1:=menu_bkMarkNT; k1:=menu_txtMarkNT; p2:=menu_bkMarkST; k2:=menu_txtMarkST;end;

  if not menu[i].raz
  then StatusLineColor(p1,k1,p2,k2,x-1,y+i,' '+menu[i].str+' '){}
  else if w_twosided
       then cmprint(menu_bkNT,menu_txtNT,x-2,y+i,'╟'+fill(2+length(without(menu[1].str,'~`')),'─')+'╢')
       else cmprint(menu_bkNT,menu_txtNT,x-2,y+i,'├'+fill(2+length(without(menu[1].str,'~`')),'─')+'┤');
 end;
end;

label loop,cont,fin;
begin
Case focus of left:p:=lp; right:p:=rp; end;

if menu_bkNT<0 then      menu_bkNT     :=LightGray;
if menu_txtNT<0 then     menu_txtNT    :=Black;

if menu_bkST<0 then      menu_bkST     :=LightGray;
if menu_txtST<0 then     menu_txtST    :=White;

if menu_bkMarkNT<0 then  menu_bkMarkNT :=Blue;
if menu_txtMarkNT<0 then menu_txtMarkNT:=LightCyan;

if menu_bkMarkST<0 then  menu_bkMarkST :=Blue;
if menu_txtMarkST<0 then menu_txtMarkST:=White;

mx:=41-length(without(menu[1].str,'~`')) div 2 - 2;
my:=(halfmaxy)-tot div 2 - 1;

if w_twosided
 then scputwin(menu_bkNT,menu_txtNT,mx,my,mx+length(without(menu[1].str,'~`'))+3,my+tot+1)
 else scputwin(menu_bkNT,menu_txtNT,mx-1,my,mx+length(without(menu[1].str,'~`'))+4,my+tot+1);


f:=1;
loop:
cStatusBar(pal.bkSBarNT,pal.txtSBarNT,pal.bkSBarST,pal.txtSBarST,0,sBar[lang,p.PanelType]);
pr;
if not UserOut then kb:=keycode;
cont:
 if UserOut then kb:=_esc;
 if (kb=_esc)or(kb=_left) then
  begin
   restscr;
   if lev=1 then exit;
   dec(lev);
   load(lev,f);
   exit;
  end;
 if (kb=_enter)or(kb=_right) then
  begin
   if pos('',menu[f].str)<>0 then
    begin
     inc(lev);
     menu[lev].pos:=f;
     load(lev,f);
     brow;
    end
   else
    begin
     Change(lev,menu[lev].pos,f);
     load(lev,menu[lev].pos);
    end;
  end;

  if (chr(lo(kb)) in [#32..'я'])and
     (hi(kb) in [0..$d,$10..$1b,$1e..$29,$2b..$35,$39]) then
   begin
    for i:=1 to tot do
     begin
      if pos('~`'+chr(lo(kb))+'~`',strlo(menu[i].str))<>0 then
       Begin
        f:=i; kb:=_enter; pr; goto cont;
       End;
     end;
   end;

 if kb=_down then
  begin
   sf:=f;
   inc(f);
   while menu[f].raz do inc(f);
   if (f=tot) and menu[f].raz then f:=sf;
  end;

 if kb=_up then
  begin
   sf:=f;
   dec(f);
   while menu[f].raz do dec(f);
   if (f=1) and menu[f].raz then f:=sf;
  end;

 if kb=_home then f:=1;
 if kb=_end then f:=tot;

 if f<1 then f:=tot;
 if f>tot then f:=1;
goto loop;
fin:
restscr;
end;
{----------------------------------------------------------------------------}




Var Stemp:string;
Begin
setup:=false;
UserOut:=false;
fn:=StartDir+'\sn.ini';{}
lev:=1;

Load(lev,1);
w_twosided:=false;
Brow;
w_twosided:=true;
End;

End.