        org     #8000
buffer  equ     #a000
colbuff equ     #b000
        xor     a
        out     (254),a
        ld      hl,#4000
        ld      de,#4001
        ld      bc,6912
        ld      (hl),a
        ldir
        ld      a,7
        ld      (23624),a
        ld      (23693),a
boldfnt ld      hl,15616
        ld      de,40000
        ld      bc,768
        push    de
bold1   ld      a,(hl)
        srl     a
        or      (hl)
        and     %01010111
        ld      (de),a
        inc     hl
        inc     de
        dec     c
        jr      nz,bold1
        djnz    bold1
        pop     hl
        dec     h
        ld      (23606),hl
        ld      hl,txt1
        ld      a,12
        call    scroll
        ld      hl,txt2
        ld      a,13
        call    scroll
        ld      hl,15360
        ld      (23606),hl
        ei:halt
        di
buum    ld      hl,code
LLFF38  ld      bc,#FFFD
        ld      a,(hl)
        inc     hl
        inc     a
        jr      nz,LLFF69
        ld      e,(hl)
        inc     hl
LLFF42  ld      b,(hl)
LLFF43  djnz    LLFF43
        ld      bc,#FFFD
        ld      a,#02
        out     (c),a
        in      a,(c)
        add     a,#0C
        ld      b,#BF
        out     (c),a
        jr      nz,LLFF63
        ld      b,#FF
        ld      a,#03
        out     (c),a
        in      a,(c)
        inc     a
        ld      b,#BF
        out     (c),a
LLFF63  dec     e
        jr      nz,LLFF42
        inc     hl
        jr      LLFF38
LLFF69  dec     a
        jr      z,next       ;exit
        out     (c),a
        ld      b,#BF
        ld      a,(hl)
        inc     hl
        out     (c),a
        jr      LLFF38
next    ld      b,#e0
repit   push    bc
BEGIN   ld      a,-3
        ;-3 -7 -11
START   LD      HL,#5ac0
        LD      B,64  ;52
CICLE   ld      (hl),a
        INC     L
        DJNZ    CICLE
        inc     A
        cp      7+1
        JP      NZ,START
        pop     bc
        djnz    repit
        ld      hl,#5ac0
        ld      de,#5ac0+1
        ld      bc,#20
        push    bc
        ld      a,6
        ld      (hl),a
        ldir
        pop     bc
        ld      a,3
        ld      (hl),a
        ldir
        im      1
        ei
        halt
        ld      a,(23560)
        cp      "s"
        jp      z,svetrk
        halt
        ld      a,(23560)
        cp      "S"
        jp      z,svetrk
        ret
svetrk  ld      a,2
        out     (#fe),a
        ld      hl,buffer
        push    hl
        ld      de,#0000
        ld      bc,#1005
        call    #3d13
        xor     a
        out     (#fe),a
        ld      hl,mycpyrt
        ld      de,buffer+#850
        ld      bc,8*3
        ldir
        pop     hl
        ld      de,#0100
        ld      bc,#1006
        call    #3d13
        ret
scroll  ld     (y+1),a
        ld     (t+1),hl
        ld     b,31
cicle1  ld     a,22
        rst    16
y       ld     a,0
        rst    16
        ld     a,b
        rst    16
        ld     a,16
        rst    16
        ld     a,r
        and    7
        rst    16
        ld     a,17
        rst    16
        xor    a
        rst    16
        ld     a,32
        sub    b
t       ld     hl,txt1
        push   bc
        ld     b,a
cicle   ld     a,(hl)
        cp     0
        jr     nz,contin
        pop    bc
        ret
contin  rst    16
        inc    hl
        djnz   cicle
        pop    bc
        dec    b
        jr     cicle1
code    db    #07,#3D,#03,#00
        db    #02,#20,#0C,#80
        db    #06,#10,#09,#11
        db    #0d,#01,#FF,#FF
        db    #FF,#00,#3C
mycpyrt db   "TRAKcopy"
        db   "by DENYA"
        db   "soft '97"
txt1 db "  DENYA PRESENT!!!      "
     db 0
txt2 db "new OVER-boot FROM 0trk 9sec "
     db 0
