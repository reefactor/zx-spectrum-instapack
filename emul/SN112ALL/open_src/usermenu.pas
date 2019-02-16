{$O+,F+}
unit UserMenu;
interface

procedure CallUserMenu;

implementation

Uses
        Crt, Dos, rv, vars, Main_Ovr;
Type
        TMenu=
         record
          str:string[70];
          pos:word;
          raz:boolean;
          curpos:word;
         end;

Const
        MaxMenu=30;
Var
        menu:array[0..MaxMenu] of TMenu;
        max,linepos,lev,i,ind,tot:word;
        userout:boolean;

procedure CallUserMenu;

function Load(lp:word):boolean;
var f:text; s,t:string;
begin
Load:=true;
 for i:=0 to maxmenu do begin menu[i].str:=''; menu[i].pos:=0; menu[i].raz:=false; menu[i].curpos:=0; end;

 ind:=1; linepos:=1; max:=1; menu[0].str:='';
 if CheckDirFile('sn.mnu')=0 then assign(f,'sn.mnu')
                             else assign(f,startdir+'\sn.mnu');
 if CheckDirFile(startdir+'\sn.mnu')<>0 then
  begin
   Load:=false;
   exit;
  end;
 {$i-}
 filemode:=2; reset(f);

 ReadLn(f,s);
 if nospaceLR(s)<>'; ZX Spectrum Navigator Menu file' then
  begin
   close(f);
   Load:=false;
   exit;
  end;
 close(f);

 reset(f);
 for i:=1 to lp do begin ReadLn(f,s); inc(linepos); end;

 while (not EOF(f))and(IOResult=0) do
  begin
   ReadLn(f,s); s:=nospaceLR(s);
   if (s[1]='>')and(vall(s[2])<lev) then break;
   if (s[1]='>')and(vall(s[2])>lev)and(menu[ind-1].str[length(menu[ind-1].str)]<>'')
     then menu[ind-1].str:=menu[ind-1].str+'  ';
   if (s[1]='>')and(vall(s[2])=lev) then
    begin
     delete(s,1,2); if s[1]=' ' then delete(s,1,1);
     if nospace(s)='' then menu[ind].raz:=true else
      begin
       s:=nospaceR(s); t:='';
       for i:=1 to length(s) do if s[i]='~' then t:=t+'~`' else t:=t+s[i];
       menu[ind].str:=t;
       menu[ind].pos:=linepos;

       t:=nospaceR(without(menu[ind].str,'~`'));
       if length(t)>max then max:=length(t);
      end;
     inc(ind);
     if ind>MaxMenu then break;
    end;
   inc(linepos);
  end;
 close(f);
 tot:=ind-1;
{$I+}
 for i:=1 to tot do
   if length(without(menu[i].str,'~`'))>max then max:=length(without(menu[i].str,'~`'));{}

 for i:=1 to tot do
  begin
   menu[i].str:=sRexpand(menu[i].str,max+(length(menu[i].str)-length(without(menu[i].str,'~`'))));
   if pos('',menu[i].str)<>0 then
    begin
     delete(menu[i].str,pos('',menu[i].str),1);
     menu[i].str:=menu[i].str+'';
    end;
  end;

end;
{----------------------------------------------------------------------------}
procedure brow;
var kb:word;
    mx,my:word;
    sf,f:word;

    ft,fs:text;
    s:string;

procedure pr;
var p1,k1,p2,k2,x,y,i:word;
begin
x:=41-length(without(menu[1].str,'~`')) div 2;
y:=halfmaxy-2-tot div 2;
for i:=1 to tot do
 begin
  if i<>f then begin p1:=menu_bkNT; k1:=menu_txtNT; p2:=menu_bkST; k2:=menu_txtST; end
          else begin p1:=menu_bkMarkNT; k1:=menu_txtMarkNT; p2:=menu_bkMarkST; k2:=menu_txtMarkST;end;

  if not menu[i].raz
  then StatusLineColor(p1,k1,p2,k2,x-1,y+i,' '+menu[i].str+' '){}
  else if w_twosided
       then cmprint(menu_bkNT,menu_txtNT,x-2,y+i,'Ç'+fill(2+length(without(menu[1].str,'~`')),'Ä')+'¶')
       else cmprint(menu_bkNT,menu_txtNT,x-2,y+i,'Ã'+fill(2+length(without(menu[1].str,'~`')),'Ä')+'´');
 end;
end;

label loop,cont,fin;
begin
if menu_bkNT<0 then      menu_bkNT     :=LightGray;
if menu_txtNT<0 then     menu_txtNT    :=Black;

if menu_bkST<0 then      menu_bkST     :=LightGray;
if menu_txtST<0 then     menu_txtST    :=White;

if menu_bkMarkNT<0 then  menu_bkMarkNT :=Blue;
if menu_txtMarkNT<0 then menu_txtMarkNT:=LightCyan;

if menu_bkMarkST<0 then  menu_bkMarkST :=Blue;
if menu_txtMarkST<0 then menu_txtMarkST:=White;

mx:=41-length(without(menu[1].str,'~`')) div 2 - 2;
my:=halfmaxy-2-tot div 2 - 0;

if w_twosided
 then scputwin(menu_bkNT,menu_txtNT,mx,my,mx+length(without(menu[1].str,'~`'))+3,my+tot+1)
 else scputwin(menu_bkNT,menu_txtNT,mx-1,my,mx+length(without(menu[1].str,'~`'))+4,my+tot+1);


f:=1;
loop:
pr;
if not UserOut then kb:=keycode;
cont:
 if UserOut then kb:=_esc;
 if kb=_esc then
  begin
   restscr;
   if lev=1 then exit;
   dec(lev);
   load(menu[lev].curpos);
   exit;
  end;
 if kb=_enter then
  begin
   if pos('',menu[f].str)<>0 then
    begin
     menu[lev].curpos:=menu[1].pos;
     inc(lev);
     load(menu[f].pos);
     brow;
    end
   else
    begin
     menu[0].str:=TempDir+strlo(GetOf(startnum,_name))+'.bat';
     assign(ft,menu[0].str);
     if CheckDirFile('sn.mnu')=0 then assign(fs,'sn.mnu')
                                 else assign(fs,startdir+'\sn.mnu');
      rewrite(ft); reset(fs);

      for i:=1 to menu[f].pos do readln(fs,s); s:=' ';

      while s[1]<>'>' do
       begin
        readln(fs,s);
        s:=nospaceLR(s);
        if s[1]<>'>' then writeln(ft,s);
        if EOF(fs) then break;
       end;
      {
      writeln(ft,'@'+menu[0].str[1]+':');
      writeln(ft,'@cd '+getof(menu[0].str,_dir));
      writeln(ft,'@del '+menu[0].str);
      {}
      close(ft); close(fs);
      UserOut:=true;
      command:=menu[0].str;
      DoExec(command,false);
    end;
  end;

  if (chr(lo(kb)) in [#32..'ï'])and
     (hi(kb) in [0..$d,$10..$1b,$1e..$29,$2b..$35,$39]) then
   begin
    for i:=1 to tot do
     begin
      if pos('~`'+chr(lo(kb))+'~`',strlo(menu[i].str))<>0 then
       Begin
        f:=i; kb:=_enter; goto cont;
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

Begin
userout:=false;
lev:=1; if not Load(1) then exit;
w_twosided:=false;{}
brow;
w_twosided:=true;{}
filedelete(menu[0].str);
End;

End.