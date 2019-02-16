Unit Sorting;
Interface

uses sn_Obj;

type CmpMinFunc=Function(var r1,r2:pcDirRec):boolean;

procedure LSortByName;
procedure LSortByExt;
procedure LSortByLen;
procedure RSortByName;
procedure RSortByExt;
procedure RSortByLen;
procedure GlobalSort(w:byte);

Implementation

uses RV,
     Vars;

type Tbe=record
          b:word;
          e:word;
         end;
var be:array[1..9] of Tbe;


Function Name(var r1,r2:pcdirRec):boolean; far;
begin
 Name:=r1.fName<r2.fName;
end;

Function Ext(var r1,r2:pcdirRec):boolean; far;
begin
 Ext:=r1.fext<r2.fext;
end;

Function Len(var r1,r2:pcdirRec):boolean; far;
begin
 Len:=r1.flength<r2.flength;
end;

Function FD(var r1,r2:pcdirRec):boolean; far;
begin
 FD:=r1.priory<r2.priory;{}
end;




Procedure LSort(t,b:integer; Cmp:CmpMinFunc);

Procedure QuickSort(l,r:integer);
var i,j:integer; x,y:pcdirRec;
begin
 i:=l;
 j:=r;
 x:=lp.pcdir^[(l+r) div 2];
 repeat
  while Cmp(lp.pcdir^[i],x) do inc(i);
  while Cmp(x,lp.pcdir^[j]) do dec(j);
  if i<=j
  then begin
        y:=lp.pcdir^[i];
        lp.pcdir^[i]:=lp.pcdir^[j];
        lp.pcdir^[j]:=y;
        inc(i);
        dec(j);
       end;
 until i>j;
 if l<j then QuickSort(l,j);
 if i<r then QuickSort(i,r);
end;

begin
 QuickSort(t,b);
end;





Procedure RSort(t,b:integer; Cmp:CmpMinFunc);

Procedure QuickSort(l,r:integer);
var i,j:integer; x,y:pcdirRec;
begin
 i:=l;
 j:=r;
 x:=rp.pcdir^[(l+r) div 2];
 repeat
  while Cmp(rp.pcdir^[i],x) do inc(i);
  while Cmp(x,rp.pcdir^[j]) do dec(j);
  if i<=j
  then begin
        y:=rp.pcdir^[i];
        rp.pcdir^[i]:=rp.pcdir^[j];
        rp.pcdir^[j]:=y;
        inc(i);
        dec(j);
       end;
 until i>j;
 if l<j then QuickSort(l,j);
 if i<r then QuickSort(i,r);
end;

begin
 QuickSort(t,b);
end;



procedure LInit;
var i:word; is,m,ms:byte;
begin
for i:=1 to 9 do begin be[i].b:=0; be[i].e:=0; end;

m:=lp.pcdir^[lp.pctdirs+1].priory; ms:=m; is:=1; i:=lp.pctdirs+2;
be[is].b:=i-1;
while i-1<lp.pctdirs+lp.pctfiles do
 begin
  m:=lp.pcdir^[i].priory;
  if ms<>m then
   begin
    ms:=m;
    be[is].e:=i-1;
    inc(is); be[is].b:=i;
   end;
  inc(i);
 end;
be[is].e:=i-1;
end;



procedure LSortByName; var a,b:integer;
procedure SortGroups(bb,e:word);
begin
LSort(bb,e,Name);{} b:=bb;
while b<=e do
 begin
  a:=b; while (b<e)and((lp.pcdir^[b+1].fname)=(lp.pcdir^[b].fname)) do inc(b);
  LSort(a,b,Ext); inc(a); inc(b);
 end;
end;

begin
LSort(1,lp.pctdirs+lp.pctfiles,FD); LSort(1,lp.pctdirs,Name); b:=1;
while b<=lp.pctdirs do
 begin
  a:=b; while (b<lp.pctdirs)and((lp.pcdir^[b+1].fname)=(lp.pcdir^[b].fname)) do inc(b);
  LSort(a,b,Ext); inc(a); inc(b);
 end;

LInit; for i:=1 to 9 do if be[i].e<>0 then SortGroups(be[i].b,be[i].e);
end;


procedure LSortByExt; var a,b,i:word;
procedure SortGroups(bb,e:word);
begin
LSort(bb,e,Ext); b:=bb;
while b<=e do
 begin
  a:=b; while (b<e)and((lp.pcdir^[b+1].fext)=(lp.pcdir^[b].fext)) do inc(b);
  LSort(a,b,Name); inc(a); inc(b);
 end;
end;

begin
LSort(1,lp.pctdirs+lp.pctfiles,FD); LSort(1,lp.pctdirs,Ext); b:=1;
while b<=lp.pctdirs do
 begin
  a:=b; while (b<lp.pctdirs)and((lp.pcdir^[b+1].fext)=(lp.pcdir^[b].fext)) do inc(b);
  LSort(a,b,Name); inc(a); inc(b);
 end;

LInit; for i:=1 to 9 do if be[i].e<>0 then SortGroups(be[i].b,be[i].e);
end;



procedure LSortByLen;
var a,b:integer;
begin
LSort(1,lp.pctdirs+lp.pctfiles,FD); LSort(1,lp.pctdirs,Ext); b:=1;
while b<=lp.pctdirs do
 begin
  a:=b; while (b<lp.pctdirs)and((lp.pcdir^[b+1].fext)=(lp.pcdir^[b].fext)) do inc(b);
  LSort(a,b,Name); inc(a); inc(b);
 end;

LSort(lp.pctdirs+1,lp.pctdirs+lp.pctfiles,Len);

b:=lp.pctdirs+1; while b<=lp.pctdirs+lp.pctfiles do
 begin
  a:=b; while (b<lp.pctdirs+lp.pctfiles)and((lp.pcdir^[b+1].flength)=(lp.pcdir^[b].flength)) do inc(b);
  LSort(a,b,Name); inc(a); inc(b);
 end;
end;



procedure LNoSort;
begin
LSort(1,lp.pctdirs+lp.pctfiles,FD);
end;




procedure RInit;
var i:word; is,m,ms:byte;
begin
for i:=1 to 9 do begin be[i].b:=0; be[i].e:=0; end;

m:=rp.pcdir^[rp.pctdirs+1].priory; ms:=m; is:=1; i:=rp.pctdirs+2;
be[is].b:=i-1;
while i-1<rp.pctdirs+rp.pctfiles do
 begin
  m:=rp.pcdir^[i].priory;
  if ms<>m then
   begin
    ms:=m;
    be[is].e:=i-1;
    inc(is); be[is].b:=i;
   end;
  inc(i);
 end;
be[is].e:=i-1;
end;





procedure RSortByName; var a,b:integer;
procedure SortGroups(bb,e:word);
begin
RSort(bb,e,Name);{} b:=bb;
while b<=e do
 begin
  a:=b; while (b<e)and((rp.pcdir^[b+1].fname)=(rp.pcdir^[b].fname)) do inc(b);
  RSort(a,b,Ext); inc(a); inc(b);
 end;
end;

begin
RSort(1,rp.pctdirs+rp.pctfiles,FD); RSort(1,rp.pctdirs,Name); b:=1;
while b<=rp.pctdirs do
 begin
  a:=b; while (b<rp.pctdirs)and((rp.pcdir^[b+1].fname)=(rp.pcdir^[b].fname)) do inc(b);
  RSort(a,b,Ext); inc(a); inc(b);
 end;

RInit; for i:=1 to 9 do if be[i].e<>0 then SortGroups(be[i].b,be[i].e);
end;


procedure RSortByExt; var a,b,i:word;
procedure SortGroups(bb,e:word);
begin
RSort(bb,e,Ext); b:=bb;
while b<=e do
 begin
  a:=b; while (b<e)and((rp.pcdir^[b+1].fext)=(rp.pcdir^[b].fext)) do inc(b);
  RSort(a,b,Name); inc(a); inc(b);
 end;
end;

begin
RSort(1,rp.pctdirs+rp.pctfiles,FD); RSort(1,rp.pctdirs,Ext); b:=1;
while b<=rp.pctdirs do
 begin
  a:=b; while (b<rp.pctdirs)and((rp.pcdir^[b+1].fext)=(rp.pcdir^[b].fext)) do inc(b);
  RSort(a,b,Name); inc(a); inc(b);
 end;

RInit;

for i:=1 to 9 do if be[i].e<>0 then SortGroups(be[i].b,be[i].e);
end;



procedure RSortByLen;
var a,b:integer;
begin
RSort(1,rp.pctdirs+rp.pctfiles,FD); RSort(1,rp.pctdirs,Ext); b:=1;
while b<=rp.pctdirs do
 begin
  a:=b; while (b<rp.pctdirs)and((rp.pcdir^[b+1].fext)=(rp.pcdir^[b].fext)) do inc(b);
  RSort(a,b,Name); inc(a); inc(b);
 end;

RSort(rp.pctdirs+1,rp.pctdirs+rp.pctfiles,Len);

b:=rp.pctdirs+1; while b<=rp.pctdirs+rp.pctfiles do
 begin
  a:=b; while (b<rp.pctdirs+rp.pctfiles)and((rp.pcdir^[b+1].flength)=(rp.pcdir^[b].flength)) do inc(b);
  RSort(a,b,Name); inc(a); inc(b);
 end;
end;



procedure RNoSort;
begin
RSort(1,rp.pctdirs+rp.pctfiles,FD);
end;





procedure GlobalSort(w:byte);
begin
case w of
left:
 case lp.sorttype of
  nametype: LSortByName;
   exttype: LSortByExt;
   lentype: LSortByLen;
   nontype: LNoSort;
 end;

right:
 case rp.sorttype of
  nametype: RSortByName;
   exttype: RSortByExt;
   lentype: RSortByLen;
   nontype: RNoSort;
 end;

255:
 begin
 case lp.sorttype of
  nametype: LSortByName;
   exttype: LSortByExt;
   lentype: LSortByLen;
   nontype: LNoSort;
 end;
 case rp.sorttype of
  nametype: RSortByName;
   exttype: RSortByExt;
   lentype: RSortByLen;
   nontype: RNoSort;
 end;
 end

end;
end;





begin
end.
