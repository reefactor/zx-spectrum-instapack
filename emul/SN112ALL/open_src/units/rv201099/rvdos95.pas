function LFindFirst(FileSpec:pchar; Attr:word; var SRec:TLSearchRec):word;
assembler;
{ Search for files }
asm
 push ds
 lds dx,FileSpec
 les di,SRec
 mov cx,Attr
 xor si,si
 mov ax,714eh
 int 21h
 pop ds
 sbb bx,bx
 mov es:[di].TLSearchRec.Handle,ax
 and ax,bx
 mov [DosError],ax
end;

function LFindNext(var SRec:TLSearchRec):word; assembler;
{ Find next file }
asm
 mov ax,714fh
 xor si,si
 les di,SRec
 mov bx,es:[di].TLSearchRec.Handle
 int 21h
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LFindClose(var SRec:TLSearchRec):word; assembler;
{ Free search handle }
asm
 mov ax,714fh
 mov bx,es:[di].TLSearchRec.Handle
 int 21h
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;


function LTrueName(FileName:pchar; Result:pchar):word; assembler;
{ Return complete path, if relative uppercased longnames added, }
{ in buffer Result (261 bytes) }
asm
 push ds
 mov ax,7160h
 xor cx,cx
 lds si,FileName
 les di,Result
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LGetShortName(FileName:pchar; Result:pchar):word; assembler;
{ Return complete short name/path for input file/path in buffer }
{ Result (79 bytes) }
asm
 push ds
 lds si,FileName
 les di,Result
 mov ax,7160h
 mov cx,1
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;


function LGetLongName(FileName:pchar; Result:pchar):word; assembler;
{ Return complete long name/path for input file/path in buffer }
{ Result (261 bytes) }
asm
 push ds
 lds si,FileName
 les di,Result
 mov ax,7160h
 mov cx,2
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LFileSystemInfo(RootName:pchar; FSName:pchar; FSNameBufSize:word;
 var Flags,MaxFileNameLen,MaxPathLen:word):word; assembler;
{ Return File System Information, for FSName 32 bytes should be sufficient }
asm
 push ds
 lds dx,RootName
 les di,FSName
 mov cx,FSNameBufSize
 mov ax,71a0h
 int 21h
 pop ds
 les di,Flags
 mov es:[di],bx
 les di,MaxFileNameLen
 mov es:[di],cx
 les di,MaxPathLen
 mov es:[di],dx
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LTimeToDos(var LTime:comp):longint; assembler;
{ Convert 64-bit number of 100ns since 01-01-1601 UTC to local DOS format time
}{ (LTime is var to avoid putting it on the stack) }
asm
 push ds
 lds si,LTime
 xor bl,bl
 mov ax,71a7h
 int 21h
 pop ds
 mov ax,cx
 cmc
 sbb cx,cx
 and ax,cx
 and dx,cx
end;

procedure UnpackLTime(var LTime:comp; var DT:DateTime);
{ Convert 64-bit time to date/time record }
begin
 UnpackTime(LTimeToDos(LTime),DT);
end;

function LMkDir(Directory:pchar):word; assembler;
asm
 push ds
 lds dx,Directory
 mov ax,7139h
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LRmDir(Directory:pchar):word; assembler;
asm
 push ds
 lds dx,Directory
 mov ax,713ah
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LChDir(Directory:pchar):word; assembler;
asm
 push ds
 lds dx,Directory
 mov ax,713bh
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LErase(Filename:pchar):word; assembler;
asm
 push ds
 lds dx,Filename
 mov ax,7141h
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LGetAttr(Filename:pchar; var Attr:word):word; assembler;
asm
 push ds
 lds dx,Filename
 mov ax,7143h
 xor bl,bl
 int 21h
 pop ds
 les di,Attr
 mov es:[di],cx
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LSetAttr(Filename:pchar; Attr:word):word; assembler;
asm
 push ds
 lds dx,Filename
 mov ax,7143h
 mov bl,1
 mov cx,Attr
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LGetDir(Drive:byte; Result:pchar):word; assembler;
asm
 cld
 les di,Result
 mov al,Drive
 mov dl,al
 dec al
 jns @GotDrive
 mov ah,19h
 int 21h
@GotDrive:
 add al,41h
 mov ah,':'
 stosw
 mov ax,'\'
 stosw
 push ds
 push es
 pop ds
 mov si,di
 dec si
 mov ax,7147h
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

function LRename(OldFilename,NewFilename:pchar):word; assembler;
asm
 push ds
 lds dx,OldFilename
 les di,NewFilename
 mov ax,7156h
 int 21h
 pop ds
 sbb bx,bx
 and ax,bx
 mov [DosError],ax
end;

