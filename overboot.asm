        ORG     #8000
buffer  EQU     #a000
colbuff EQU     #b000
        XOR     A
        OUT     (254),A
        LD      HL,#4000
        LD      DE,#4001
        LD      BC,6912
        LD      (HL),A
        LDIR
        LD      A,7
        LD      (23624),A
        LD      (23693),A
BOLDFNT LD      HL,15616
        LD      DE,40000
        LD      BC,768
        PUSH    DE
BOLD1   LD      A,(HL)
        SRL     A
        OR      (HL)
        AND     %01010111
        LD      (DE),A
        INC     HL
        INC     DE
        DEC     C
        JR      NZ,BOLD1
        DJNZ    BOLD1
        POP     HL
        DEC     H
        LD      (23606),HL
        LD      HL,txt1
        LD      A,12
        CALL    scroll
        LD      HL,txt2
        LD      A,13
        CALL    scroll
        LD      HL,15360
        LD      (23606),HL
        EI:HALT
        DI
buum    LD      HL,CODE
LLFF38  LD      BC,#FFFD
        LD      A,(HL)
        INC     HL
        INC     A
        JR      NZ,LLFF69
        LD      E,(HL)
        INC     HL
LLFF42  LD      B,(HL)
LLFF43  DJNZ    LLFF43
        LD      BC,#FFFD
        LD      A,#02
        OUT     (C),A
        IN      A,(C)
        ADD     A,#0C
        LD      B,#BF
        OUT     (C),A
        JR      NZ,LLFF63
        LD      B,#FF
        LD      A,#03
        OUT     (C),A
        IN      A,(C)
        INC     A
        LD      B,#BF
        OUT     (C),A
LLFF63  DEC     E
        JR      NZ,LLFF42
        INC     HL
        JR      LLFF38
LLFF69  DEC     A
        JR      Z,NEXT       ;Exit
        OUT     (C),A
        LD      B,#BF
        LD      A,(HL)
        INC     HL
        OUT     (C),A
        JR      LLFF38
NEXT    LD      B,#E0
REPIT   PUSH    BC
BEGIN   LD      A,-3
        ;-3 -7 -11
START   LD      HL,#5aC0
        LD      B,64  ;52
CICLE   LD      (HL),A
        INC     L
        DJNZ    CICLE
        INC     A
        CP      7+1
        JP      NZ,START
        POP     BC
        DJNZ    REPIT
        LD      HL,#5aC0
        LD      DE,#5aC0+1
        LD      BC,#20
        PUSH    BC
        LD      A,6
        LD      (HL),A
        LDIR
        POP     BC
        LD      A,3
        LD      (HL),A
        LDIR
        IM      1
        EI
        HALT
        LD      A,(23560)
        CP      "s"
        JP      Z,svetrk
        HALT
        LD      A,(23560)
        CP      "S"
        JP      Z,svetrk
        RET
svetrk  LD      A,2
        OUT     (#FE),A
        LD      HL,buffer
        PUSH    HL
        LD      DE,#0000
        LD      BC,#1005
        CALL    #3D13
        XOR     A
        OUT     (#FE),A
        LD      HL,CPYRT
        LD      DE,buffer+#850
        LD      BC,8*3
        LDIR
        POP     HL
        LD      DE,#0100
        LD      BC,#1006
        CALL    #3D13
        RET
scroll  LD     (y+1),A
        LD     (t+1),HL
        LD     B,31
CICLE1  LD     A,22
        RST    16
y       LD     A,0
        RST    16
        LD     A,B
        RST    16
        LD     A,16
        RST    16
        LD     A,R
        AND    7
        RST    16
        LD     A,17
        RST    16
        XOR    A
        RST    16
        LD     A,32
        SUB    B
t       LD     HL,txt1
        PUSH   BC
        LD     B,A
CICLE   LD     A,(HL)
        CP     0
        JR     NZ,contin
        POP    BC
        RET
contin  RST    16
        INC    HL
        DJNZ   CICLE
        POP    BC
        DEC    B
        JR     CICLE1
CODE    db    #07,#3D,#03,#00
        db    #02,#20,#0C,#80
        db    #06,#10,#09,#11
        db    #0d,#01,#FF,#FF
        db    #FF,#00,#3C
CPYRT   db   "TRAKcopy"
        db   "by DENYA"
        db   "soft '97"
txt1 db "  DENYA PRESENT!!!      "
     db 0
txt2 db "new OVER-boot FROM 0trk 9sec "
     db 0
