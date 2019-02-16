{$O+,F+}
Unit sn_Mem;
Interface
Type
     TSavedDeskTop=array[1..1] of byte;
Var
     SavedDeskTop:^TSavedDeskTop;
     DeskMem:word;

Procedure GetMemDesk;
Procedure SaveBkDesk;
Procedure RestBkDesk;
Procedure MemDeskDone;

procedure GetMemPCDirs;
procedure FreeMemPCDirs;


FUNCTION Dosmem : LONGINT;


Implementation
Uses
     crt, RV,
     Vars, sn_Obj;



{===========================================================================}
procedure SaveBkDesk;
var
   ix,iy,i:word;
 begin
  i:=1;
  for iy:=0 to gmaxy-1 do
   for ix:=0 to gmaxx-1 do
    begin
     SavedDeskTop^[i]:=mem[$B800:((80*iy)+ix)*2];   inc(i);
     SavedDeskTop^[i]:=mem[$B800:((80*iy)+ix)*2+1]; inc(i);
    end;
 end;



{===========================================================================}
procedure RestBkDesk;
var
   ix,iy,i:word;
 begin
  i:=1;
  for iy:=0 to gmaxy-1 do
   for ix:=0 to gmaxx-1 do
    begin
     mem[$B800:((80*iy)+ix)*2]:=SavedDeskTop^[i];   inc(i);
     mem[$B800:((80*iy)+ix)*2+1]:=SavedDeskTop^[i]; inc(i);
    end;
 end;



{===========================================================================}
procedure GetMemDesk;
var i:integer;
begin
 getmem(SavedDeskTop,DeskMem);
 i:=1;
 while i<deskmem do
  begin
   SavedDeskTop^[i]:=0;
   SavedDeskTop^[i+1]:=textattr;
   inc(i,2);
  end;
end;



{===========================================================================}
procedure MemDeskDone;
begin
 freemem(SavedDeskTop,DeskMem);
end;




{===========================================================================}
FUNCTION Dosmem : LONGINT;

Type
  MCBrec = RECORD
             location   : Char; {----'M' is normal block, 'Z' is last block }
             ProcessID,
             allocation : WORD; {----Number of 16 Bytes paragraphs allocated}
             reserved   : ARRAY[1..11] OF Byte;
           END;

  PSPrec = RECORD
             int20h,
             EndofMem        : WORD;
             Reserved1       : BYTE;
             Dosdispatcher   : ARRAY[1..5] OF BYTE;
             Int22h,
             Int23h,
             INT24h          : POINTER;
             ParentPSP       : WORD;
             HandleTable     : ARRAY[1..20] OF BYTE;
             EnvSeg          : WORD; {----Segment of Environment}
             Reserved2       : LONGINT;
             HandleTableSize : WORD;
             HandleTableAddr : POINTER;
             Reserved3       : ARRAY[1..23] OF BYTE;
             Int21           : WORD;
             RetFar          : BYTE;
             Reserved4       : ARRAY[1..9] OF BYTE;
             DefFCB1         : ARRAY[1..36] OF BYTE;
             DefFCB2         : ARRAY[1..20] OF BYTE;
             Cmdlength       : BYTE;
             Cmdline         : ARRAY[1..127] OF BYTE;
           END;

Var
  pmcb   : ^MCBrec;
  emcb   : ^MCBrec;
  psp    : ^PSPrec;
  dmem   : LONGINT;

Begin
   psp:=PTR(PrefixSeg,0);      {----PSP given by TP var                }
  pmcb:=Ptr(PrefixSeg-1,0);    {----Programs MCB 1 paragraph before PSP}
  emcb:=Ptr(psp^.envseg-1,0);  {----Environment MCB 1 paragraph before
                                    envseg                             }
  dosmem:=LONGINT(pmcb^.allocation+emcb^.allocation+1)*16;
End; {of DOSmem}



{===========================================================================}
procedure GetMemPCDirs;
begin
 getmem(lp.pcdir,MaxFiles*sizeof(pcDirRec));
 getmem(rp.pcdir,MaxFiles*sizeof(pcDirRec));

 getmem(lp.pcins,MaxFiles*sizeof(pcInsedRec));
 getmem(rp.pcins,MaxFiles*sizeof(pcInsedRec));


 getmem(lp.trddir,257*sizeof(zxDirRec));
 getmem(rp.trddir,257*sizeof(zxDirRec));

 getmem(lp.trdins,257*sizeof(zxInsedRec));
 getmem(rp.trdins,257*sizeof(zxInsedRec));

end;



{===========================================================================}
procedure FreeMemPCDirs;
begin
 freemem(lp.pcdir,MaxFiles*sizeof(pcDirRec));
 freemem(rp.pcdir,MaxFiles*sizeof(pcDirRec));

 freemem(lp.pcins,MaxFiles*sizeof(pcInsedRec));
 freemem(rp.pcins,MaxFiles*sizeof(pcInsedRec));


 freemem(lp.trddir,257*sizeof(zxDirRec));
 freemem(rp.trddir,257*sizeof(zxDirRec));

 freemem(lp.trdins,257*sizeof(zxInsedRec));
 freemem(rp.trdins,257*sizeof(zxInsedRec));

end;








{===========================================================================}
{===========================================================================}
{===========================================================================}
begin
 DeskMem:=80*50*2;
end.