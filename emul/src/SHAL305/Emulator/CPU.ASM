;**************************************************************************
;
;Эмуляция Z80
;
;**************************************************************************

IDEAL
INCLUDE "MAINASM.INC"
PUBLIC _ModifyPointRm,_ModifyPointTr,_ModifyPointRV,_TableOp
PUBLIC _ModifyPointTRm,_ModifyPointTTr,_ModifyPointTRV

DATASEG
;Таблицы адресов подпрограмм обработки комманд процессора
_TableOp	DD OFFSET ONop,OFFSET Op01,OFFSET Op02,OFFSET Op03,OFFSET Op04,OFFSET Op05,OFFSET Op06,OFFSET Op07,OFFSET Op08,OFFSET Op09,OFFSET Op0A,OFFSET Op0B,OFFSET Op0C,OFFSET Op0D,OFFSET Op0E,OFFSET Op0F
		DD OFFSET Op10,OFFSET Op11,OFFSET Op12,OFFSET Op13,OFFSET Op14,OFFSET Op15,OFFSET Op16,OFFSET Op17,OFFSET Op18,OFFSET Op19,OFFSET Op1A,OFFSET Op1B,OFFSET Op1C,OFFSET Op1D,OFFSET Op1E,OFFSET Op1F
		DD OFFSET Op20,OFFSET Op21,OFFSET Op22,OFFSET Op23,OFFSET Op24,OFFSET Op25,OFFSET Op26,OFFSET Op27,OFFSET Op28,OFFSET Op29,OFFSET Op2A,OFFSET Op2B,OFFSET Op2C,OFFSET Op2D,OFFSET Op2E,OFFSET Op2F
		DD OFFSET Op30,OFFSET Op31,OFFSET Op32,OFFSET Op33,OFFSET Op34,OFFSET Op35,OFFSET Op36,OFFSET Op37,OFFSET Op38,OFFSET Op39,OFFSET Op3A,OFFSET Op3B,OFFSET Op3C,OFFSET Op3D,OFFSET Op3E,OFFSET Op3F
		DD OFFSET ONop,OFFSET Op41,OFFSET Op42,OFFSET Op43,OFFSET Op44,OFFSET Op45,OFFSET Op46,OFFSET Op47,OFFSET Op48,OFFSET ONop,OFFSET Op4A,OFFSET Op4B,OFFSET Op4C,OFFSET Op4D,OFFSET Op4E,OFFSET Op4F
		DD OFFSET Op50,OFFSET Op51,OFFSET ONop,OFFSET Op53,OFFSET Op54,OFFSET Op55,OFFSET Op56,OFFSET Op57,OFFSET Op58,OFFSET Op59,OFFSET Op5A,OFFSET ONop,OFFSET Op5C,OFFSET Op5D,OFFSET Op5E,OFFSET Op5F
		DD OFFSET Op60,OFFSET Op61,OFFSET Op62,OFFSET Op63,OFFSET ONop,OFFSET Op65,OFFSET Op66,OFFSET Op67,OFFSET Op68,OFFSET Op69,OFFSET Op6A,OFFSET Op6B,OFFSET Op6C,OFFSET ONop,OFFSET Op6E,OFFSET Op6F
		DD OFFSET Op70,OFFSET Op71,OFFSET Op72,OFFSET Op73,OFFSET Op74,OFFSET Op75,OFFSET Op76,OFFSET Op77,OFFSET Op78,OFFSET Op79,OFFSET Op7A,OFFSET Op7B,OFFSET Op7C,OFFSET Op7D,OFFSET Op7E,OFFSET ONop
		DD OFFSET Op80,OFFSET Op81,OFFSET Op82,OFFSET Op83,OFFSET Op84,OFFSET Op85,OFFSET Op86,OFFSET Op87,OFFSET Op88,OFFSET Op89,OFFSET Op8A,OFFSET Op8B,OFFSET Op8C,OFFSET Op8D,OFFSET Op8E,OFFSET Op8F
		DD OFFSET Op90,OFFSET Op91,OFFSET Op92,OFFSET Op93,OFFSET Op94,OFFSET Op95,OFFSET Op96,OFFSET Op97,OFFSET Op98,OFFSET Op99,OFFSET Op9A,OFFSET Op9B,OFFSET Op9C,OFFSET Op9D,OFFSET Op9E,OFFSET Op9F
		DD OFFSET OpA0,OFFSET OpA1,OFFSET OpA2,OFFSET OpA3,OFFSET OpA4,OFFSET OpA5,OFFSET OpA6,OFFSET OpA7,OFFSET OpA8,OFFSET OpA9,OFFSET OpAA,OFFSET OpAB,OFFSET OpAC,OFFSET OpAD,OFFSET OpAE,OFFSET OpAF
		DD OFFSET OpB0,OFFSET OpB1,OFFSET OpB2,OFFSET OpB3,OFFSET OpB4,OFFSET OpB5,OFFSET OpB6,OFFSET OpB7,OFFSET OpB8,OFFSET OpB9,OFFSET OpBA,OFFSET OpBB,OFFSET OpBC,OFFSET OpBD,OFFSET OpBE,OFFSET OpBF
		DD OFFSET OpC0,OFFSET OpC1,OFFSET OpC2,OFFSET OpC3,OFFSET OpC4,OFFSET OpC5,OFFSET OpC6,OFFSET OpC7,OFFSET OpC8,OFFSET OpC9,OFFSET OpCA,OFFSET OpCB,OFFSET OpCC,OFFSET OpCD,OFFSET OpCE,OFFSET OpC7
		DD OFFSET OpD0,OFFSET OpD1,OFFSET OpD2,OFFSET OpD3,OFFSET OpD4,OFFSET OpD5,OFFSET OpD6,OFFSET OpC7,OFFSET OpD8,OFFSET OpD9,OFFSET OpDA,OFFSET OpDB,OFFSET OpDC,OFFSET OpDD,OFFSET OpDE,OFFSET OpC7
		DD OFFSET OpE0,OFFSET OpE1,OFFSET OpE2,OFFSET OpE3,OFFSET OpE4,OFFSET OpE5,OFFSET OpE6,OFFSET OpC7,OFFSET OpE8,OFFSET OpE9,OFFSET OpEA,OFFSET OpEB,OFFSET OpEC,OFFSET OpED,OFFSET OpEE,OFFSET OpC7
		DD OFFSET OpF0,OFFSET OpF1,OFFSET OpF2,OFFSET OpF3,OFFSET OpF4,OFFSET OpF5,OFFSET OpF6,OFFSET OpC7,OFFSET OpF8,OFFSET OpF9,OFFSET OpFA,OFFSET OpFB,OFFSET OpFC,OFFSET OpFD,OFFSET OpFE,OFFSET OpC7
TableOpCB	DD OFFSET OpCB00,OFFSET OpCB01,OFFSET OpCB02,OFFSET OpCB03,OFFSET OpCB04,OFFSET OpCB05,OFFSET OpCB06,OFFSET OpCB07,OFFSET OpCB08,OFFSET OpCB09,OFFSET OpCB0A,OFFSET OpCB0B,OFFSET OpCB0C,OFFSET OpCB0D,OFFSET OpCB0E,OFFSET OpCB0F
		DD OFFSET OpCB10,OFFSET OpCB11,OFFSET OpCB12,OFFSET OpCB13,OFFSET OpCB14,OFFSET OpCB15,OFFSET OpCB16,OFFSET OpCB17,OFFSET OpCB18,OFFSET OpCB19,OFFSET OpCB1A,OFFSET OpCB1B,OFFSET OpCB1C,OFFSET OpCB1D,OFFSET OpCB1E,OFFSET OpCB1F
		DD OFFSET OpCB20,OFFSET OpCB21,OFFSET OpCB22,OFFSET OpCB23,OFFSET OpCB24,OFFSET OpCB25,OFFSET OpCB26,OFFSET OpCB27,OFFSET OpCB28,OFFSET OpCB29,OFFSET OpCB2A,OFFSET OpCB2B,OFFSET OpCB2C,OFFSET OpCB2D,OFFSET OpCB2E,OFFSET OpCB2F
		DD OFFSET OpCB30,OFFSET OpCB31,OFFSET OpCB32,OFFSET OpCB33,OFFSET OpCB34,OFFSET OpCB35,OFFSET OpCB36,OFFSET OpCB37,OFFSET OpCB38,OFFSET OpCB39,OFFSET OpCB3A,OFFSET OpCB3B,OFFSET OpCB3C,OFFSET OpCB3D,OFFSET OpCB3E,OFFSET OpCB3F
		DD OFFSET BtB01h,OFFSET BtC01h,OFFSET BtD01h,OFFSET BtE01h,OFFSET BtH01h,OFFSET BtL01h,OFFSET BtM01h,OFFSET BtA01h
		DD OFFSET BtB02h,OFFSET BtC02h,OFFSET BtD02h,OFFSET BtE02h,OFFSET BtH02h,OFFSET BtL02h,OFFSET BtM02h,OFFSET BtA02h
		DD OFFSET BtB04h,OFFSET BtC04h,OFFSET BtD04h,OFFSET BtE04h,OFFSET BtH04h,OFFSET BtL04h,OFFSET BtM04h,OFFSET BtA04h
		DD OFFSET BtB08h,OFFSET BtC08h,OFFSET BtD08h,OFFSET BtE08h,OFFSET BtH08h,OFFSET BtL08h,OFFSET BtM08h,OFFSET BtA08h
		DD OFFSET BtB10h,OFFSET BtC10h,OFFSET BtD10h,OFFSET BtE10h,OFFSET BtH10h,OFFSET BtL10h,OFFSET BtM10h,OFFSET BtA10h
		DD OFFSET BtB20h,OFFSET BtC20h,OFFSET BtD20h,OFFSET BtE20h,OFFSET BtH20h,OFFSET BtL20h,OFFSET BtM20h,OFFSET BtA20h
		DD OFFSET BtB40h,OFFSET BtC40h,OFFSET BtD40h,OFFSET BtE40h,OFFSET BtH40h,OFFSET BtL40h,OFFSET BtM40h,OFFSET BtA40h
		DD OFFSET BtB80h,OFFSET BtC80h,OFFSET BtD80h,OFFSET BtE80h,OFFSET BtH80h,OFFSET BtL80h,OFFSET BtM80h,OFFSET BtA80h
		DD OFFSET RsB0FEh,OFFSET RsC0FEh,OFFSET RsD0FEh,OFFSET RsE0FEh,OFFSET RsH0FEh,OFFSET RsL0FEh,OFFSET OpCB86,OFFSET RsA0FEh
		DD OFFSET RsB0FDh,OFFSET RsC0FDh,OFFSET RsD0FDh,OFFSET RsE0FDh,OFFSET RsH0FDh,OFFSET RsL0FDh,OFFSET OpCB8E,OFFSET RsA0FDh
		DD OFFSET RsB0FBh,OFFSET RsC0FBh,OFFSET RsD0FBh,OFFSET RsE0FBh,OFFSET RsH0FBh,OFFSET RsL0FBh,OFFSET OpCB96,OFFSET RsA0FBh
		DD OFFSET RsB0F7h,OFFSET RsC0F7h,OFFSET RsD0F7h,OFFSET RsE0F7h,OFFSET RsH0F7h,OFFSET RsL0F7h,OFFSET OpCB9E,OFFSET RsA0F7h
		DD OFFSET RsB0EFh,OFFSET RsC0EFh,OFFSET RsD0EFh,OFFSET RsE0EFh,OFFSET RsH0EFh,OFFSET RsL0EFh,OFFSET OpCBA6,OFFSET RsA0EFh
		DD OFFSET RsB0DFh,OFFSET RsC0DFh,OFFSET RsD0DFh,OFFSET RsE0DFh,OFFSET RsH0DFh,OFFSET RsL0DFh,OFFSET OpCBAE,OFFSET RsA0DFh
		DD OFFSET RsB0BFh,OFFSET RsC0BFh,OFFSET RsD0BFh,OFFSET RsE0BFh,OFFSET RsH0BFh,OFFSET RsL0BFh,OFFSET OpCBB6,OFFSET RsA0BFh
		DD OFFSET RsB07Fh,OFFSET RsC07Fh,OFFSET RsD07Fh,OFFSET RsE07Fh,OFFSET RsH07Fh,OFFSET RsL07Fh,OFFSET OpCBBE,OFFSET RsA07Fh
		DD OFFSET StB01h,OFFSET StC01h,OFFSET StD01h,OFFSET StE01h,OFFSET StH01h,OFFSET StL01h,OFFSET OpCBC6,OFFSET StA01h
		DD OFFSET StB02h,OFFSET StC02h,OFFSET StD02h,OFFSET StE02h,OFFSET StH02h,OFFSET StL02h,OFFSET OpCBCE,OFFSET StA02h
		DD OFFSET StB04h,OFFSET StC04h,OFFSET StD04h,OFFSET StE04h,OFFSET StH04h,OFFSET StL04h,OFFSET OpCBD6,OFFSET StA04h
		DD OFFSET StB08h,OFFSET StC08h,OFFSET StD08h,OFFSET StE08h,OFFSET StH08h,OFFSET StL08h,OFFSET OpCBDE,OFFSET StA08h
		DD OFFSET StB10h,OFFSET StC10h,OFFSET StD10h,OFFSET StE10h,OFFSET StH10h,OFFSET StL10h,OFFSET OpCBE6,OFFSET StA10h
		DD OFFSET StB20h,OFFSET StC20h,OFFSET StD20h,OFFSET StE20h,OFFSET StH20h,OFFSET StL20h,OFFSET OpCBEE,OFFSET StA20h
		DD OFFSET StB40h,OFFSET StC40h,OFFSET StD40h,OFFSET StE40h,OFFSET StH40h,OFFSET StL40h,OFFSET OpCBF6,OFFSET StA40h
		DD OFFSET StB80h,OFFSET StC80h,OFFSET StD80h,OFFSET StE80h,OFFSET StH80h,OFFSET StL80h,OFFSET OpCBFE,OFFSET StA80h
TableOpED	DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET OpED40,OFFSET OpED41,OFFSET OpED42,OFFSET OpED43,OFFSET OpED44,OFFSET OpED45,OFFSET OpED46,OFFSET OpED47,OFFSET OpED48,OFFSET OpED49,OFFSET OpED4A,OFFSET OpED4B,OFFSET OpED44,OFFSET OpC9,OFFSET OpED46,OFFSET OpED4F
		DD OFFSET OpED50,OFFSET OpED51,OFFSET OpED52,OFFSET OpED53,OFFSET OpED44,OFFSET OpED45,OFFSET OpED56,OFFSET OpED57,OFFSET OpED58,OFFSET OpED59,OFFSET OpED5A,OFFSET OpED5B,OFFSET OpED44,OFFSET OpC9,OFFSET OpED5E,OFFSET OpED5F
		DD OFFSET OpED60,OFFSET OpED61,OFFSET OpED62,OFFSET Op22,OFFSET OpED44,OFFSET OpED45,OFFSET OpED46,OFFSET OpED67,OFFSET OpED68,OFFSET OpED69,OFFSET OpED6A,OFFSET Op2A,OFFSET OpED44,OFFSET OpC9,OFFSET OpED46,OFFSET OpED6F
		DD OFFSET OpED70,OFFSET OpED71,OFFSET OpED72,OFFSET OpED73,OFFSET OpED44,OFFSET OpED45,OFFSET OpED56,OFFSET ONop,OFFSET OpED78,OFFSET OpED79,OFFSET OpED7A,OFFSET OpED7B,OFFSET OpED44,OFFSET OpC9,OFFSET OpED5E,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET OpEDA0,OFFSET OpEDA1,OFFSET OpEDA2,OFFSET OpEDA3,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET OpEDA8,OFFSET OpEDA9,OFFSET OpEDAA,OFFSET OpEDAB,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET OpEDB0,OFFSET OpEDB1,OFFSET OpEDB2,OFFSET OpEDB3,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET OpEDB8,OFFSET OpEDB9,OFFSET OpEDBA,OFFSET OpEDBB,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
		DD OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop,OFFSET ONop
TableOpII	DD OFFSET ONop,OFFSET Op01,OFFSET Op02,OFFSET Op03,OFFSET Op04,OFFSET Op05,OFFSET Op06,OFFSET Op07,OFFSET Op08,OFFSET OpII09,OFFSET Op0A,OFFSET Op0B,OFFSET Op0C,OFFSET Op0D,OFFSET Op0E,OFFSET Op0F
		DD OFFSET Op10,OFFSET Op11,OFFSET Op12,OFFSET Op13,OFFSET Op14,OFFSET Op15,OFFSET Op16,OFFSET Op17,OFFSET Op18,OFFSET OpII19,OFFSET Op1A,OFFSET Op1B,OFFSET Op1C,OFFSET Op1D,OFFSET Op1E,OFFSET Op1F
		DD OFFSET Op20,OFFSET OpII21,OFFSET OpII22,OFFSET OpII23,OFFSET OpII24,OFFSET OpII25,OFFSET OpII26,OFFSET Op27,OFFSET Op28,OFFSET OpII29,OFFSET OpII2A,OFFSET OpII2B,OFFSET OpII2C,OFFSET OpII2D,OFFSET OpII2E,OFFSET Op2F
		DD OFFSET Op30,OFFSET Op31,OFFSET Op32,OFFSET Op33,OFFSET OpII34,OFFSET OpII35,OFFSET OpII36,OFFSET Op37,OFFSET Op38,OFFSET OpII39,OFFSET Op3A,OFFSET Op3B,OFFSET Op3C,OFFSET Op3D,OFFSET Op3E,OFFSET Op3F
		DD OFFSET ONop,OFFSET Op41,OFFSET Op42,OFFSET Op43,OFFSET OpII44,OFFSET OpII45,OFFSET OpII46,OFFSET Op47,OFFSET Op48,OFFSET ONop,OFFSET Op4A,OFFSET Op4B,OFFSET OpII4C,OFFSET OpII4D,OFFSET OpII4E,OFFSET Op4F
		DD OFFSET Op50,OFFSET Op51,OFFSET ONop,OFFSET Op53,OFFSET OpII54,OFFSET OpII55,OFFSET OpII56,OFFSET Op57,OFFSET Op58,OFFSET Op59,OFFSET Op5A,OFFSET ONop,OFFSET OpII5C,OFFSET OpII5D,OFFSET OpII5E,OFFSET Op5F
		DD OFFSET OpII60,OFFSET OpII61,OFFSET OpII62,OFFSET OpII63,OFFSET ONop,OFFSET OpII65,OFFSET OpII66,OFFSET OpII67,OFFSET OpII68,OFFSET OpII69,OFFSET OpII6A,OFFSET OpII6B,OFFSET OpII6C,OFFSET ONop,OFFSET OpII6E,OFFSET OpII6F
		DD OFFSET OpII70,OFFSET OpII71,OFFSET OpII72,OFFSET OpII73,OFFSET OpII74,OFFSET OpII75,OFFSET Op76,OFFSET OpII77,OFFSET Op78,OFFSET Op79,OFFSET Op7A,OFFSET Op7B,OFFSET OpII7C,OFFSET OpII7D,OFFSET OpII7E,OFFSET ONop
		DD OFFSET Op80,OFFSET Op81,OFFSET Op82,OFFSET Op83,OFFSET OpII84,OFFSET OpII85,OFFSET OpII86,OFFSET Op87,OFFSET Op88,OFFSET Op89,OFFSET Op8A,OFFSET Op8B,OFFSET OpII8C,OFFSET OpII8D,OFFSET OpII8E,OFFSET Op8F
		DD OFFSET Op90,OFFSET Op91,OFFSET Op92,OFFSET Op93,OFFSET OpII94,OFFSET OpII95,OFFSET OpII96,OFFSET Op97,OFFSET Op98,OFFSET Op99,OFFSET Op9A,OFFSET Op9B,OFFSET OpII9C,OFFSET OpII9D,OFFSET OpII9E,OFFSET Op9F
		DD OFFSET OpA0,OFFSET OpA1,OFFSET OpA2,OFFSET OpA3,OFFSET OpIIA4,OFFSET OpIIA5,OFFSET OpIIA6,OFFSET OpA7,OFFSET OpA8,OFFSET OpA9,OFFSET OpAA,OFFSET OpAB,OFFSET OpIIAC,OFFSET OpIIAD,OFFSET OpIIAE,OFFSET OpAF
		DD OFFSET OpB0,OFFSET OpB1,OFFSET OpB2,OFFSET OpB3,OFFSET OpIIB4,OFFSET OpIIB5,OFFSET OpIIB6,OFFSET OpB7,OFFSET OpB8,OFFSET OpB9,OFFSET OpBA,OFFSET OpBB,OFFSET OpIIBC,OFFSET OpIIBD,OFFSET OpIIBE,OFFSET OpBF
		DD OFFSET OpC0,OFFSET OpC1,OFFSET OpC2,OFFSET OpC3,OFFSET OpC4,OFFSET OpC5,OFFSET OpC6,OFFSET OpC7,OFFSET OpC8,OFFSET OpC9,OFFSET OpCA,OFFSET OpIICB,OFFSET OpCC,OFFSET OpCD,OFFSET OpCE,OFFSET OpC7
		DD OFFSET OpD0,OFFSET OpD1,OFFSET OpD2,OFFSET OpD3,OFFSET OpD4,OFFSET OpD5,OFFSET OpD6,OFFSET OpC7,OFFSET OpD8,OFFSET OpD9,OFFSET OpDA,OFFSET OpDB,OFFSET OpDC,OFFSET OpDD,OFFSET OpDE,OFFSET OpC7
		DD OFFSET OpE0,OFFSET OpIIE1,OFFSET OpE2,OFFSET OpIIE3,OFFSET OpE4,OFFSET OpIIE5,OFFSET OpE6,OFFSET OpC7,OFFSET OpE8,OFFSET OpIIE9,OFFSET OpEA,OFFSET OpEB,OFFSET OpEC,OFFSET OpED,OFFSET OpEE,OFFSET OpC7
		DD OFFSET OpF0,OFFSET OpF1,OFFSET OpF2,OFFSET OpF3,OFFSET OpF4,OFFSET OpF5,OFFSET OpF6,OFFSET OpC7,OFFSET OpF8,OFFSET OpIIF9,OFFSET OpFA,OFFSET OpFB,OFFSET OpFC,OFFSET OpFD,OFFSET OpFE,OFFSET OpC7
TableOpIICB	DD OFFSET OpIICB00,OFFSET OpIICB00,OFFSET OpIICB00,OFFSET OpIICB00,OFFSET OpIICB00,OFFSET OpIICB00,OFFSET OpIICB06,OFFSET OpIICB07,OFFSET OpIICB08,OFFSET OpIICB08,OFFSET OpIICB08,OFFSET OpIICB08,OFFSET OpIICB08,OFFSET OpIICB08,OFFSET OpIICB0E,OFFSET OpIICB0F
		DD OFFSET OpIICB10,OFFSET OpIICB10,OFFSET OpIICB10,OFFSET OpIICB10,OFFSET OpIICB10,OFFSET OpIICB10,OFFSET OpIICB16,OFFSET OpIICB17,OFFSET OpIICB18,OFFSET OpIICB18,OFFSET OpIICB18,OFFSET OpIICB18,OFFSET OpIICB18,OFFSET OpIICB18,OFFSET OpIICB1E,OFFSET OpIICB1F
		DD OFFSET OpIICB20,OFFSET OpIICB20,OFFSET OpIICB20,OFFSET OpIICB20,OFFSET OpIICB20,OFFSET OpIICB20,OFFSET OpIICB26,OFFSET OpIICB27,OFFSET OpIICB28,OFFSET OpIICB28,OFFSET OpIICB28,OFFSET OpIICB28,OFFSET OpIICB28,OFFSET OpIICB28,OFFSET OpIICB2E,OFFSET OpIICB2F
		DD OFFSET OpIICB30,OFFSET OpIICB30,OFFSET OpIICB30,OFFSET OpIICB30,OFFSET OpIICB30,OFFSET OpIICB30,OFFSET OpIICB36,OFFSET OpIICB37,OFFSET OpIICB38,OFFSET OpIICB38,OFFSET OpIICB38,OFFSET OpIICB38,OFFSET OpIICB38,OFFSET OpIICB38,OFFSET OpIICB3E,OFFSET OpIICB3F
		DD OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h,OFFSET BtI01h
		DD OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h,OFFSET BtI02h
		DD OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h,OFFSET BtI04h
		DD OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h,OFFSET BtI08h
		DD OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h,OFFSET BtI10h
		DD OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h,OFFSET BtI20h
		DD OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h,OFFSET BtI40h
		DD OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h,OFFSET BtI80h
		DD OFFSET OpIICB80,OFFSET OpIICB80,OFFSET OpIICB80,OFFSET OpIICB80,OFFSET OpIICB80,OFFSET OpIICB80,OFFSET OpIICB86,OFFSET OpIICB87,OFFSET OpIICB88,OFFSET OpIICB88,OFFSET OpIICB88,OFFSET OpIICB88,OFFSET OpIICB88,OFFSET OpIICB88,OFFSET OpIICB8E,OFFSET OpIICB8F
		DD OFFSET OpIICB90,OFFSET OpIICB90,OFFSET OpIICB90,OFFSET OpIICB90,OFFSET OpIICB90,OFFSET OpIICB90,OFFSET OpIICB96,OFFSET OpIICB97,OFFSET OpIICB98,OFFSET OpIICB98,OFFSET OpIICB98,OFFSET OpIICB98,OFFSET OpIICB98,OFFSET OpIICB98,OFFSET OpIICB9E,OFFSET OpIICB9F
		DD OFFSET OpIICBA0,OFFSET OpIICBA0,OFFSET OpIICBA0,OFFSET OpIICBA0,OFFSET OpIICBA0,OFFSET OpIICBA0,OFFSET OpIICBA6,OFFSET OpIICBA7,OFFSET OpIICBA8,OFFSET OpIICBA8,OFFSET OpIICBA8,OFFSET OpIICBA8,OFFSET OpIICBA8,OFFSET OpIICBA8,OFFSET OpIICBAE,OFFSET OpIICBAF
		DD OFFSET OpIICBB0,OFFSET OpIICBB0,OFFSET OpIICBB0,OFFSET OpIICBB0,OFFSET OpIICBB0,OFFSET OpIICBB0,OFFSET OpIICBB6,OFFSET OpIICBB7,OFFSET OpIICBB8,OFFSET OpIICBB8,OFFSET OpIICBB8,OFFSET OpIICBB8,OFFSET OpIICBB8,OFFSET OpIICBB8,OFFSET OpIICBBE,OFFSET OpIICBBF
		DD OFFSET OpIICBC0,OFFSET OpIICBC0,OFFSET OpIICBC0,OFFSET OpIICBC0,OFFSET OpIICBC0,OFFSET OpIICBC0,OFFSET OpIICBC6,OFFSET OpIICBC7,OFFSET OpIICBC8,OFFSET OpIICBC8,OFFSET OpIICBC8,OFFSET OpIICBC8,OFFSET OpIICBC8,OFFSET OpIICBC8,OFFSET OpIICBCE,OFFSET OpIICBCF
		DD OFFSET OpIICBD0,OFFSET OpIICBD0,OFFSET OpIICBD0,OFFSET OpIICBD0,OFFSET OpIICBD0,OFFSET OpIICBD0,OFFSET OpIICBD6,OFFSET OpIICBD7,OFFSET OpIICBD8,OFFSET OpIICBD8,OFFSET OpIICBD8,OFFSET OpIICBD8,OFFSET OpIICBD8,OFFSET OpIICBD8,OFFSET OpIICBDE,OFFSET OpIICBDF
		DD OFFSET OpIICBE0,OFFSET OpIICBE0,OFFSET OpIICBE0,OFFSET OpIICBE0,OFFSET OpIICBE0,OFFSET OpIICBE0,OFFSET OpIICBE6,OFFSET OpIICBE7,OFFSET OpIICBE8,OFFSET OpIICBE8,OFFSET OpIICBE8,OFFSET OpIICBE8,OFFSET OpIICBE8,OFFSET OpIICBE8,OFFSET OpIICBEE,OFFSET OpIICBEF
		DD OFFSET OpIICBF0,OFFSET OpIICBF0,OFFSET OpIICBF0,OFFSET OpIICBF0,OFFSET OpIICBF0,OFFSET OpIICBF0,OFFSET OpIICBF6,OFFSET OpIICBF7,OFFSET OpIICBF8,OFFSET OpIICBF8,OFFSET OpIICBF8,OFFSET OpIICBF8,OFFSET OpIICBF8,OFFSET OpIICBF8,OFFSET OpIICBFE,OFFSET OpIICBFF
Registers	DD OFFSET _EmuTable.DataCPU.RegB,OFFSET _EmuTable.DataCPU.RegC
		DD OFFSET _EmuTable.DataCPU.RegD,OFFSET _EmuTable.DataCPU.RegE
		DD OFFSET _EmuTable.DataCPU.RegH,OFFSET _EmuTable.DataCPU.RegL
_IntLen		DD 1

UDATASEG
IncDecDataFlag	DB 200h DUP (?) ;Значение флагов для команд INC и DEC
_IntSource	DD ? ;Источник прерываний
FlashUse	DD ? ;Инткремент счетчика мигания
FlashDetect	DD ? ;Счетчик мигания: старший бит включен = инверсия
CountIntPass	DD ?
_LimCountMulti	DD ?
CounterInt	DB ? ;Счетчик прерывания
_ExitIfInt	DB ? ;Выход при прерывании
		DB ?,? ;;ALIGN

RgPC EQU edi
RgSP EQU esi
RgAF EQU edx
RgHL EQU [_EmuTable.DataCPU.RegHL]
RgDE EQU [_EmuTable.DataCPU.RegDE]
RgBC EQU [_EmuTable.DataCPU.RegBC]
RgWHL EQU [WORD _EmuTable.DataCPU.RegHL]
RgWDE EQU [WORD _EmuTable.DataCPU.RegDE]
RgWBC EQU [WORD _EmuTable.DataCPU.RegBC]
RgII EQU [DWORD ebp]
RgB EQU [_EmuTable.DataCPU.RegB]
RgC EQU [_EmuTable.DataCPU.RegC]
RgD EQU [_EmuTable.DataCPU.RegD]
RgE EQU [_EmuTable.DataCPU.RegE]
RgH EQU [_EmuTable.DataCPU.RegH]
RgL EQU [_EmuTable.DataCPU.RegL]
RgA EQU dh
RgF EQU dl
RgIL EQU [BYTE ebp]
RgIH EQU [BYTE ebp+1]

CODESEG
;Вычисление абсолютного адреса
MACRO AbsAdrSpec Reg
		mov	Reg,ebx
		shr	Reg,0Eh
		and	bh,03Fh
		add	ebx,[(_EmuTable.SpecSeg)+Reg*4]
ENDM

MACRO ReadBytCom
		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
ENDM

;Чтение двухбайтового операнда (адреса)
MACRO ReadComAdr
		mov	ebx,edi
		mov	eax,edi
		shr	ebx,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+ebx*4]
		inc	di
		mov	bl,[eax]
		mov	ebp,edi
		mov	eax,edi
		shr	ebp,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+ebp*4]
		inc	di
		mov	bh,[eax]
ENDM

MACRO WrMemRet
		sub	ebx,OFFSET _SpecRAM+14000h
		mov	eax,ebx
		and	ah,07Fh
		cmp	eax,01B00h
		jc	WritBytScr_
@@Ret:		ret
ENDM

MACRO WrMemCont Reg
LOCAL @@Cont
		sub	ebx,OFFSET _SpecRAM+14000h
IFIDN <Reg>,<eax>
		mov	ebp,ebx
		and	ebp,0FFFF7FFFh
		cmp	ebp,01B00h
ELSE
		mov	eax,ebx
		and	ah,07Fh
		cmp	eax,01B00h
ENDIF
		jnc	@@Cont
IFDIF <Reg>,<>
		push	Reg
ENDIF
		call	WritBytScr_
IFDIF <Reg>,<>
		pop	Reg
ENDIF
@@Cont:
ENDM

MACRO ReadIndex
;Чтение смещения и вычисление абсолютного адреса
		ReadBytCom
		movsx	ebx,[BYTE ebx]
		add	ebx,[ebp]
		and	ebx,0FFFFh
ENDM

MACRO MainCicleCPU Type,Num
		mov	ebx,edi
IFDIF <Type>,<Tr>
		cmp	bh,03Dh
		jz	@@&Type&Set
ELSE
		cmp	bh,040h
		jnc	@@TrSet
ENDIF
IF Num
@@&Type&Code:
ENDIF
		AbsAdrSpec eax
		inc	di
		inc	cl
		mov	al,[ebx]
		call	[_TableOp+eax*4]
IF Num
_ModifyPoint&Type=$+2
		cmp	[DWORD LARGE 0000h],000h
IFIDN <Type>,<RV>
		jnz	@@InterruptVGA
		push	edx
		mov	edx,003DAh
		in	al,dx
		pop	edx
		test	al,008h
		jnz	@@IntVidPort
ELSE
		jnz	@@Interrupt
ENDIF
ENDIF
ENDM

MACRO MainCicleCPUTrace Type
@@T&Type&CicleMain:
	mov	ebx,edi
IFDIF <Type>,<Tr>
	cmp	bh,03Dh
	jz	@@T&Type&Set
ELSE
	cmp	bh,040h
	jnc	@@TTrSet
ENDIF
@@T&Type&Code:
	AbsAdrSpec eax
	mov	al,[ebx]
	mov	ebx,[_PrFirst+P_CPU*4]
	test	ebx,ebx
	jz	@@T&Type&TraceOk
@@T&Type&CicleCPU:
	call	[ebx+Prc.Pr]
	mov	ebx,[ebx+Prc.Next]
	test	ebx,ebx
	jnz	@@T&Type&CicleCPU
@@T&Type&TraceOk:
	inc	di
	inc	cl
	call	[_TableOp+eax*4]
	test	[_EmuTable.Flags],MASK IntWait
	jnz	@@WaitInt
_ModifyPointT&Type=$+2
	cmp	[DWORD LARGE 0000h],000h
IFIDN <Type>,<RV>
	jnz	@@InterruptVGA
	push	edx
	mov	edx,003DAh
	in	al,dx
	pop	edx
	test	al,008h
	jz	@@T&Type&CicleMain
	jmp	@@IntVidPort
ELSE
	jz	@@T&Type&CicleMain
	jmp	@@Interrupt
ENDIF
ENDM

ALIGN 4
PROC MainCPU_ NEAR
;Эмуляция Z80
	pushad
	mov	edx,003CEh
	mov	al,008h
	out	dx,al
	mov	edx,[_EmuTable.DataCPU.RegAF]
	mov	edi,[_EmuTable.DataCPU.RegPC]
	mov	esi,[_EmuTable.DataCPU.RegSP]
	mov	cl,[_EmuTable.DataCPU.RegR]
	mov	ch,dl
@@Start:
	test	[_EmuTable.Flags],MASK IntWait
	jnz	@@WaitInt
	test	[_EmuTable.Flags],MASK Trace
	jnz	@@StartTrace
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jz	@@TrCicleMain
	cmp	[_IntSource],002h
	jz	@@RVCicleMain
@@RmCicleMain:
	MainCicleCPU Rm,1
	MainCicleCPU Rm,0
	MainCicleCPU Rm,0
	MainCicleCPU Rm,0
	mov	eax,[_SlowData]
	sub	[_SlowDataCanc],eax
	jnc	@@RmCicleMain
	mov	eax,[_SlowDataCanc]
@@RmCicleSlow:
	inc	eax
	jnz	@@RmCicleSlow
	mov	[_SlowDataCanc],eax
	jmp	@@RmCicleMain
@@RmSet:
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+04000h
	jnz	@@RmCode
	mov	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jmp	@@TrCode
@@RVCicleMain:
	MainCicleCPU RV,1
	MainCicleCPU RV,0
	MainCicleCPU RV,0
	MainCicleCPU RV,0
	mov	eax,[_SlowData]
	sub	[_SlowDataCanc],eax
	jnc	@@RVCicleMain
	mov	eax,[_SlowDataCanc]
@@RVCicleSlow:
	inc	eax
	jnz	@@RVCicleSlow
	mov	[_SlowDataCanc],eax
	jmp	@@RVCicleMain
@@RVSet:
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+04000h
	jnz	@@RVCode
	mov	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jmp	@@TrCode
@@TrCicleMain:
	MainCicleCPU Tr,1
	MainCicleCPU Tr,0
	MainCicleCPU Tr,0
	MainCicleCPU Tr,0
	mov	eax,[_SlowDataTR]
	sub	[_SlowDataCanc],eax
	jnc	@@TrCicleMain
	mov	eax,[_SlowDataCanc]
@@TrCicleSlow:
	inc	eax
	jnz	@@TrCicleSlow
	mov	[_SlowDataCanc],eax
	jmp	@@TrCicleMain
@@TrSet:
	call	SetMemory_
	cmp	[_IntSource],002h
	jz	@@RVCode
	jmp	@@RmCode

@@StartTrace:
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jz	@@TTrCicleMain
	cmp	[_IntSource],002h
	jz	@@TRVCicleMain

	MainCicleCPUTrace Rm
@@TRmSet:
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+04000h
	jnz	@@TRmCode
	mov	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jmp	@@TTrCode

	MainCicleCPUTrace RV
@@TRVSet:
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+04000h
	jnz	@@TRVCode
	mov	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jmp	@@TTrCode

	MainCicleCPUTrace Tr
@@TTrSet:
	call	SetMemory_
	cmp	[_IntSource],002h
	jz	@@TRVCode
	jmp	@@TRmCode

@@WaitInt:
	cmp	[_IntSource],002h
	jnz	@@Interrupt
	push	edx
	mov	edx,003DAh
	in	al,dx
	pop	edx
	test	al,008h
	jz	@@Interrupt

@@IntVidPort:
	mov	eax,[_PntIntDetect]
	or	[BYTE eax+3],021h
	jmp	@@Interrupt

@@InterruptVGA:
	mov	eax,[_PntIntDetect] ;Проверка на обратный ход луча
	test	[BYTE eax+3],020h
	jz	@@Interrupt
	push	eax edx
	mov	edx,003DAh
	in	al,dx
	test	al,008h
	pop	edx eax
	jnz	@@IntRetraceOk
	and	[BYTE eax+3],0DFh
@@IntRetraceOk:
	test	[DWORD eax],0DFFFFFFFh
	jz	@@Start

@@Interrupt:
	mov	eax,[_PntIntDetect]

	test	[BYTE eax+3],080h ;Проверка на прерывание таймера
	jz	@@IntTimerOk
	cmp	[_ExitIfInt],000h ;Проверка на измерение скорости
	jnz	@@InterruptOut
	and	[BYTE eax+3],07Fh
	mov	ebx,012h
	call	SoundAY_
	mov	ebx,[FlashUse]
	add	[FlashDetect],ebx
	jc	@@Flash
	jno	@@FlashOk
@@Flash:
	pushad
	mov	edx,003CFh
	mov	ebx,OFFSET _SpecRAM+15800h-1
	mov	esi,OFFSET TableScreen+1800h*8-8
	call	FlashScreenSet
	mov	ebx,OFFSET _SpecRAM+1D800h-1
	mov	esi,OFFSET TableScreen+1B00h*8+1800h*8-8
	call	FlashScreenSet
	popad
@@FlashOk:
	dec	[CountIntPass]
	mov	ebx,[_LimCountMulti]
	test	ebx,[CountIntPass]
	jnz	@@IntTimerOk
	cmp	[_IntSource],001h
	jz	@@IntTimerOk
	jc	@@SetInt
	cmp	[_EmuTable.SpecSeg],OFFSET _SpecROM+08000h
	jnz	@@IntTimerOk
@@SetInt:
	or	[BYTE eax+3],001h
@@IntTimerOk:

	test	[BYTE eax+3],040h ;Проверка на кадровое прерывание
	jz	@@IntVerticalOk
	and	[BYTE eax+3],0BFh
	cmp	[_IntSource],001h	;;;?
	jnz	@@IntVerticalOk
	or	[BYTE eax+3],001h
@@IntVerticalOk:

@@TestMaskInt:
	test	[BYTE eax+3],001h ;Проверка на маскируемое прерывание
	jz	@@IntOutside

	cmp	[CounterInt],000h
	jnz	@@INT

	mov	[_DevDetect],000h
	mov	al,[BYTE _IntLen]
	mov	[CounterInt],al

@@INT:
	and	[_EmuTable.Flags],NOT MASK IntLast
	cmp	[CounterInt],001h
	jnz	@@IntLastOk
	or	[_EmuTable.Flags],MASK IntLast
@@IntLastOk:
	mov	ebx,[_PrFirst+P_INT*4]
	test	ebx,ebx
	jz	@@IntOk
	push	eax
@@Cicle_INT:
	push	ebx ecx edx esi edi
	call	[ebx+Prc.Pr]
	pop	edi esi edx ecx ebx
	test	ah,ah
	jnz	@@IntAfter
	mov	ebx,[ebx+Prc.Next]
	test	ebx,ebx
	jnz	@@Cicle_INT
	pop	eax
@@IntOk:

;Подсчет длительности импульса прерываний
	dec	[CounterInt]
	jnz	@@IntCont
	mov	eax,[_PntIntDetect]
	and	[BYTE eax+3],0FEh
@@IntCont:

;Проверка триггера прерываний
	cmp	[_EmuTable.DataCPU.IFF1],000h
	jz	@@IntAfterPush

;Переход команды останова
	add	di,[_EmuTable.DataCPU.Halt]
	mov	[BYTE _EmuTable.DataCPU.Halt],000h

;Вызов обработчика прерывания
	mov	eax,000000038h
	call	RstProc
	cmp	[_EmuTable.DataCPU.IM],002h
	jnz	@@IntCallOk
	mov	ebx,0FFh
	mov	bh,[_EmuTable.DataCPU.RegI]
	AbsAdrSpec eax
	mov	al,[ebx]
	sub	ebx,ebx
	mov	bh,[_EmuTable.DataCPU.RegI]
	inc	bh
	AbsAdrSpec edi
	mov	ah,[ebx]
	mov	edi,eax
@@IntCallOk:

@@IntAfterPush:
	push	eax
	mov	ebx,[_PrFirst+P_ITP*4]
	test	ebx,ebx
	jz	@@ItPOk
@@Cicle_ITP:
	push	ebx ecx edx esi edi
	call	[ebx+Prc.Pr]
	pop	edi esi edx ecx ebx
	mov	ebx,[ebx+Prc.Next]
	test	ebx,ebx
	jnz	@@Cicle_ITP
@@ItPOk:
	mov	[_EmuTable.DataCPU.IFF],00000h
@@IntAfter:
	pop	eax

@@IntOutside:
	mov	eax,[_PntIntDetect]
	test	[DWORD eax],01EFF7FFFh;;;;;
	jz	@@Start
@@InterruptOut:
	mov	[_EmuTable.DataCPU.RegPC],edi
	mov	[_EmuTable.DataCPU.RegSP],esi
	and	ecx,00000287Fh
	and	[_EmuTable.DataCPU.RegR],080h
	or	[_EmuTable.DataCPU.RegR],cl
	and	dl,0D7h
	or	dl,ch
	mov	[_EmuTable.DataCPU.RegAF],edx
@@Exit:	popad
ONop:	ret
ENDP

ALIGN 4
PROC FlashScreenSet NEAR
		mov	ecx,000000300h
@@Cicle:	cmp	[BYTE ebx+ecx],000h
		js	@@SetColorByte
		dec	ecx
		jnz	@@Cicle
		ret
@@SetColorByte:	mov	eax,0000000FFh
		out	dx,al
		mov	edi,[esi+ecx*8]
		mov	ebp,[esi+ecx*8+4]
		mov	al,[ebx+ecx]
		mov	eax,[TableColor-200h+eax*4]
		cmp	[BYTE FlashDetect+3],000h
		jns	@@ColorOk
		xchg	ah,al
@@ColorOk:	mov	[edi],al
		mov	al,[ebp]
		out	dx,al
		mov	al,[edi]
		mov	[edi],ah
		mov	al,[ebp+100h]
		out	dx,al
		mov	[edi+020h],ah
		mov	al,[ebp+200h]
		out	dx,al
		mov	[edi+040h],ah
		mov	al,[ebp+300h]
		out	dx,al
		mov	[edi+060h],ah
		mov	al,[ebp+400h]
		out	dx,al
		mov	[edi+080h],ah
		mov	al,[ebp+500h]
		out	dx,al
		mov	[edi+0A0h],ah
		mov	al,[ebp+600h]
		out	dx,al
		mov	[edi+0C0h],ah
		mov	al,[ebp+700h]
		out	dx,al
		mov	[edi+0E0h],ah
		dec	ecx
		jnz	@@Cicle
		ret
ENDP

ALIGN 4
PROC WritBytScrAdv_
		sub	ebx,OFFSET _SpecRAM+14000h
		mov	eax,ebx
		and	ah,07Fh
		cmp	eax,01B00h
		jnc	@@Ret
;Запись байта в экран
;Вход:	EBX - абсолютный адрес памяти-14000h
WritBytScr_:
		mov	eax,[_RMInt.Adr]
		cmp	[BYTE eax],001h
		jnz	@@Ret
		push	edx
		mov	edx,0000003CFh
		mov	eax,0000000FFh
		out	dx,al
		mov	al,[_SpecRAM+ebx+14000h]
		cmp	bh,000h
		js	@@SetInPageTwo
		cmp	bh,018h
		mov	ebp,[TableScreen+ebx*8]
		mov	ebx,[TableScreen+ebx*8+4]
		jnc	@@SetScrColor
@@SetScrPixel:	mov	bl,[ebx]
		and	ebx,00000000FFh
		add	bl,bl
		mov	ebx,[TableColor+ebx*2]
		jc	@@FlashPixInv
@@FlashPixOk:	mov	[ebp],bl
		out	dx,al
		mov	al,[ebp]
		mov	[ebp],bh
		mov	eax,[_SlowVPix]
		add	[_SlowDataCanc],eax
		pop	edx
@@Ret:		ret
@@FlashPixInv:	cmp	[BYTE FlashDetect+3],000h
		jns	@@FlashPixOk
		xchg	bh,bl
		jmp	@@FlashPixOk
@@SetInPageTwo:	cmp	bh,098h
		mov	ebp,[TableScreen+ebx*8-40000h+0D800h]
		mov	ebx,[TableScreen+ebx*8-40000h+0D800h+4]
		jc	@@SetScrPixel
@@SetScrColor:	add	al,al
		mov	eax,[TableColor+eax*2]
		jc	@@FlashColInv
@@FlashColOk:	mov	[ebp],al
		mov	al,[ebx]
		out	dx,al
		mov	al,[ebp]
		mov	[ebp],ah
		mov	al,[ebx+100h]
		out	dx,al
		mov	[ebp+020h],ah
		mov	al,[ebx+200h]
		out	dx,al
		mov	[ebp+040h],ah
		mov	al,[ebx+300h]
		out	dx,al
		mov	[ebp+060h],ah
		mov	al,[ebx+400h]
		out	dx,al
		mov	[ebp+080h],ah
		mov	al,[ebx+500h]
		out	dx,al
		mov	[ebp+0A0h],ah
		mov	al,[ebx+600h]
		out	dx,al
		mov	[ebp+0C0h],ah
		mov	al,[ebx+700h]
		out	dx,al
		mov	[ebp+0E0h],ah
		mov	eax,[_SlowVAttr]
		add	[_SlowDataCanc],eax
		pop	edx
		ret
@@FlashColInv:	cmp	[BYTE FlashDetect+3],000h
		jns	@@FlashColOk
		xchg	ah,al
		jmp	@@FlashColOk
ENDP

;Чтение кодов префиксных комманд
OpCB:		mov	ebx,edi
		AbsAdrSpec eax
		mov	al,[ebx]
		inc	di
		inc	cl
		jmp	[TableOpCB+eax*4]
OpED:		mov	ebx,edi
		AbsAdrSpec eax
		mov	al,[ebx]
		inc	di
		inc	cl
		jmp	[TableOpED+eax*4]
OpDD:		mov	ebp,OFFSET _EmuTable.DataCPU.RegIX
		mov	ebx,edi
		AbsAdrSpec eax
		mov	al,[ebx]
		inc	di
		inc	cl
		jmp	[TableOpII+eax*4]
OpFD:		mov	ebp,OFFSET _EmuTable.DataCPU.RegIY
		mov	ebx,edi
		AbsAdrSpec eax
		mov	al,[ebx]
		inc	di
		inc	cl
		jmp	[TableOpII+eax*4]
OpIICB:		ReadIndex
		AbsAdrSpec eax
		mov	ebp,edi
		mov	eax,edi
		shr	eax,0Eh
		and	ebp,03FFFh
		add	ebp,[(_EmuTable.SpecSeg)+eax*4]
		inc	di
		mov	al,[ebp]
		jmp	[TableOpIICB+eax*4]

;Операции относительного перехода и DJNZ
Op10:		dec	RgB
		jz	IncRet
Op18:           mov	ebx,edi
		AbsAdrSpec eax
		movsx	ebx,[BYTE ebx]
		lea	edi,[di+bx+1]
		ret
Op20:		test	dl,040h
		jz	Op18
IncRet:		inc	di
		ret
Op28:		test	dl,040h
		jnz	Op18
		inc	di
		ret
Op30:		test	dl,001h
		jz	Op18
		inc	di
		ret
Op38:		test	dl,001h
		jnz	Op18
		inc	di
		ret

;Операции абсолютного перехода
OpC2:		test	dl,040h
		jz	OpC3
		add	di,002h
		ret
OpCA:		test	dl,040h
		jnz	OpC3
		add	di,002h
		ret
OpD2:		test	dl,001h
		jz	OpC3
		add	di,002h
		ret
OpDA:		test	dl,001h
		jnz	OpC3
		add	di,002h
		ret
OpE2:		test	dl,004h
		jz	OpC3
		add	di,002h
		ret
OpEA:		test	dl,004h
		jnz	OpC3
		add	di,002h
		ret
OpF2:		test	dl,080h
		jz	OpC3
		add	di,002h
		ret
OpFA:		test	dl,080h
		jnz	OpC3
		add	di,002h
		ret
OpC3:		mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,edi
		shr	edi,0Eh
		and	bh,03Fh
		add	ebx,[(_EmuTable.SpecSeg)+edi*4]
		mov	ah,[ebx]
		mov	edi,eax
		ret
OpE9:		mov	edi,RgHL
		ret
OpIIE9:		mov	edi,[ebp]
		ret

;Возврат из подпрограммы
OpC0:		test	dl,040h
		jz	OpC9
		ret
OpC8:		test	dl,040h
		jnz	OpC9
		ret
OpD0:		test	dl,001h
		jz	OpC9
		ret
OpD8:		test	dl,001h
		jnz	OpC9
		ret
OpE0:		test	dl,004h
		jz	OpC9
		ret
OpE8:		test	dl,004h
		jnz	OpC9
		ret
OpF0:		test	dl,080h
		jz	OpC9
		ret
OpF8:		test	dl,080h
		jnz	OpC9
		ret
OpED45:         mov	al,[_EmuTable.DataCPU.IFF2]
		mov	[_EmuTable.DataCPU.IFF1],al
OpC9:		mov	ebx,esi
		AbsAdrSpec eax
		inc	si
		mov	al,[ebx]
		mov	ebx,esi
		AbsAdrSpec edi
		inc	si
		mov	ah,[ebx]
		mov	edi,eax
		ret

;Вызов подпрограмм
OpC4:		test	dl,040h
		jz	OpCD
		add	di,002h
		ret
OpCC:		test	dl,040h
		jnz	OpCD
		add	di,002h
		ret
OpD4:		test	dl,001h
		jz	OpCD
		add	di,002h
		ret
OpDC:		test	dl,001h
		jnz	OpCD
		add	di,002h
		ret
OpE4:		test	dl,004h
		jz	OpCD
		add	di,002h
		ret
OpEC:		test	dl,004h
		jnz	OpCD
		add	di,002h
		ret
OpF4:		test	dl,080h
		jz	OpCD
		add	di,002h
		ret
OpFC:		test	dl,080h
		jnz	OpCD
		add	di,002h
		ret
OpCD:		lea	eax,[di+2]
		dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont0
		mov	[ebx],ah
		WrMemCont eax
@@Cont0:	dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont1
		mov	[ebx],al
		WrMemCont
@@Cont1:	mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,edi
		AbsAdrSpec ebp
		mov	ah,[ebx]
		mov	edi,eax
		ret

;Рестарт подпрограмм ПЗУ
OpC7:		and	al,038h
RstProc:	mov	ebp,edi
		mov	edi,eax
		mov	eax,ebp
		dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont
		mov	[ebx],ah
		WrMemCont eax
@@Cont:		dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet

;Копирование регистров общего назначения
MACRO LdRR Reg0,Reg1
IFIDN <Reg0>,<RgA>
		mov	dh,Reg1
ELSEIFIDN <Reg1>,<RgA>
		mov	Reg0,dh
ELSE
		mov	al,Reg1
		mov	Reg0,al
ENDIF
		ret
ENDM
Op41:		LdRR RgB,RgC
Op42:		LdRR RgB,RgD
Op43:		LdRR RgB,RgE
Op44:		LdRR RgB,RgH
Op45:		LdRR RgB,RgL
Op47:		LdRR RgB,RgA
Op48:		LdRR RgC,RgB
Op4A:		LdRR RgC,RgD
Op4B:		LdRR RgC,RgE
Op4C:		LdRR RgC,RgH
Op4D:		LdRR RgC,RgL
Op4F:		LdRR RgC,RgA
Op50:		LdRR RgD,RgB
Op51:		LdRR RgD,RgC
Op53:		LdRR RgD,RgE
Op54:		LdRR RgD,RgH
Op55:		LdRR RgD,RgL
Op57:		LdRR RgD,RgA
Op58:		LdRR RgE,RgB
Op59:		LdRR RgE,RgC
Op5A:		LdRR RgE,RgD
Op5C:		LdRR RgE,RgH
Op5D:		LdRR RgE,RgL
Op5F:		LdRR RgE,RgA
Op60:		LdRR RgH,RgB
Op61:		LdRR RgH,RgC
Op62:		LdRR RgH,RgD
Op63:		LdRR RgH,RgE
Op65:		LdRR RgH,RgL
Op67:		LdRR RgH,RgA
Op68:		LdRR RgL,RgB
Op69:		LdRR RgL,RgC
Op6A:		LdRR RgL,RgD
Op6B:		LdRR RgL,RgE
Op6C:		LdRR RgL,RgH
Op6F:		LdRR RgL,RgA
Op78:		LdRR RgA,RgB
Op79:		LdRR RgA,RgC
Op7A:		LdRR RgA,RgD
Op7B:		LdRR RgA,RgE
Op7C:		LdRR RgA,RgH
Op7D:		LdRR RgA,RgL

;Копирование регистра общего назначения и половины индексного регистра
OpII44:		LdRR RgB,RgIH
OpII45:		LdRR RgB,RgIL
OpII4C:		LdRR RgC,RgIH
OpII4D:		LdRR RgC,RgIL
OpII54:		LdRR RgD,RgIH
OpII55:		LdRR RgD,RgIL
OpII5C:		LdRR RgE,RgIH
OpII5D:		LdRR RgE,RgIL
OpII7C:		LdRR RgA,RgIH
OpII7D:         LdRR RgA,RgIL
OpII60:		LdRR RgIH,RgB
OpII61:		LdRR RgIH,RgC
OpII62:		LdRR RgIH,RgD
OpII63:		LdRR RgIH,RgE
OpII65:		LdRR RgIH,RgIL
OpII67:		LdRR RgIH,RgA
OpII68:		LdRR RgIL,RgB
OpII69:		LdRR RgIL,RgC
OpII6A:		LdRR RgIL,RgD
OpII6B:		LdRR RgIL,RgE
OpII6C:		LdRR RgIL,RgIH
OpII6F:		LdRR RgIL,RgA

;Чтение регистра из памяти с косвенной адресацией
MACRO LdRM Reg0,Mem0
		mov	ebx,Mem0
		AbsAdrSpec eax
IFIDN <Reg0>,<RgA>
		mov	dh,[ebx]
ELSE
		mov	al,[ebx]
		mov	Reg0,al
ENDIF
		ret
ENDM
Op0A:		LdRM RgA,RgBC
Op1A:		LdRM RgA,RgDE
Op7E:		LdRM RgA,RgHL
Op46:		LdRM RgB,RgHL
Op4E:		LdRM RgC,RgHL
Op56:		LdRM RgD,RgHL
Op5E:		LdRM RgE,RgHL
Op66:		LdRM RgH,RgHL
Op6E:		LdRM RgL,RgHL

;Чтение регистра из памяти с индексной адресацией
MACRO LdRI Reg0
		ReadIndex
		AbsAdrSpec eax
IFIDN <Reg0>,<RgA>
		mov	dh,[ebx]
ELSE
		mov	al,[ebx]
		mov	Reg0,al
ENDIF
		ret
ENDM
OpII7E:		LdRI RgA
OpII46:		LdRI RgB
OpII4E:		LdRI RgC
OpII56:		LdRI RgD
OpII5E:		LdRI RgE
OpII66:		LdRI RgH
OpII6E:		LdRI RgL

;Чтение регистра из памяти с абсолютной адресацией
Op3A:		ReadComAdr
		AbsAdrSpec eax
		mov	dh,[ebx]
		ret

;Чтение регистровой пары из памяти с абсолютной адресацией
MACRO LdDbRegMemAbs Reg
		ReadComAdr
		lea	ebp,[bx+1]
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,ebp
		shr	ebp,0Eh
		and	bh,03Fh
		add	ebx,[(_EmuTable.SpecSeg)+ebp*4]
		mov	ah,[ebx]
		mov	Reg,eax
		ret
ENDM
OpED4B:		LdDbRegMemAbs RgBC
OpED5B:		LdDbRegMemAbs RgDE
Op2A:		LdDbRegMemAbs RgHL
OpED7B:		LdDbRegMemAbs RgSP
OpII2A:		mov	ebx,edi
		mov	eax,edi
		shr	ebx,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+ebx*4]
		inc	di
		push	edi
		mov	bl,[eax]
		mov	eax,edi
		shr	edi,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+edi*4]
		mov	bh,[eax]
		lea	edi,[bx+1]
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,edi
		shr	edi,0Eh
		and	bh,03Fh
		add	ebx,[(_EmuTable.SpecSeg)+edi*4]
		mov	ah,[ebx]
		pop	edi
		inc	di
		mov	RgII,eax
		ret

;Запись регистра в память с косвенной адресацией
MACRO LdMR Mem,Reg
		mov	ebx,Mem
		AbsAdrSpec eax
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
IFIDN <Reg>,<RgA>
		mov	[ebx],dh
		WrMemRet
ELSE
		mov	al,Reg
		mov	[ebx],al
		WrMemRet
ENDIF
ENDM
Op77:		LdMR RgHL,RgA
Op02:		LdMR RgBC,RgA
Op12:		LdMR RgDE,RgA
Op70:		LdMR RgHL,RgB
Op71:		LdMR RgHL,RgC
Op72:		LdMR RgHL,RgD
Op73:		LdMR RgHL,RgE
Op74:		LdMR RgHL,RgH
Op75:		LdMR RgHL,RgL

;Запись регистра в память с индексной адресацией
MACRO LdIR Reg
		ReadIndex
		AbsAdrSpec eax
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
IFIDN <Reg>,<RgA>
		mov	[ebx],dh
		WrMemRet
ELSE
		mov	al,Reg
		mov	[ebx],al
		WrMemRet
ENDIF
ENDM
OpII70:		LdIR RgB
OpII71:		LdIR RgC
OpII72:		LdIR RgD
OpII73:		LdIR RgE
OpII74:		LdIR RgH
OpII75:		LdIR RgL
OpII77:		LdIR RgA

;Запись регистра в память с абсолютной адресацией
Op32:		ReadComAdr
		AbsAdrSpec eax
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Запись регистровых пар в память с абсолютной адресацией
MACRO LdMemDbReg Reg
IFDIF <Reg>,<RgII>
		ReadComAdr
ELSE
		mov	ebx,edi
		mov	eax,edi
		shr	ebx,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+ebx*4]
		inc	di
		mov	bl,[eax]
		push	edi
		mov	eax,edi
		shr	edi,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+edi*4]
		pop	edi
		inc	di
		mov	bh,[eax]
ENDIF
		mov	eax,Reg
		push	ebx
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@HighByte
		mov	[ebx],al
		WrMemCont eax
@@HighByte:	pop	ebx
		inc	bx
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],ah
		WrMemRet
ENDM
OpED43:		LdMemDbReg RgBC
OpED53:		LdMemDbReg RgDE
Op22:		LdMemDbReg RgHL
OpED73:		LdMemDbReg RgSP
OpII22:		LdMemDbReg RgII

;Копирование аккумулятора и регистров I или R
MACRO SetFlagIR
		mov	ch,dh
		test	dh,dh
		lahf
		and	dl,001h
		and	ah,0C0h
		or	dl,ah
		or	dl,[_EmuTable.DataCPU.IFF2]
		ret
ENDM
OpED47:		mov	[_EmuTable.DataCPU.RegI],dh
		ret
OpED4F:		mov	cl,dh
		mov	[_EmuTable.DataCPU.RegR],dh
		ret
OpED57:		mov	dh,[_EmuTable.DataCPU.RegI]
		SetFlagIR
OpED5F:		mov	dh,[_EmuTable.DataCPU.RegR]
		and	dh,080h
		and	cl,07Fh
		or	dh,cl
		SetFlagIR

;Копирование регистровых пар
OpF9:		mov	esi,RgHL
		ret
OpIIF9:		mov	esi,[ebp]
		ret

;Загрузка регистровой пары непосредственным значением
MACRO LdWA Reg
		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	al,[ebx]
		mov	ebx,edi
		AbsAdrSpec ebp
		inc	di
		mov	ah,[ebx]
		mov	Reg,eax
		ret
ENDM
Op01:		LdWA RgBC
Op11:		LdWA RgDE
Op21:		LdWA RgHL
Op31:		LdWA RgSP
OpII21:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	al,[ebx]
		mov	RgIL,al
		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	al,[ebx]
		mov	RgIH,al
		ret

;Загрузка регистра непосредственным значением
MACRO LdRA Reg
		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	al,[ebx]
		mov	Reg,al
		ret
ENDM
Op3E:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	dh,[ebx]
		ret
Op06:		LdRA RgB
Op0E:		LdRA RgC
Op16:		LdRA RgD
Op1E:		LdRA RgE
Op26:		LdRA RgH
Op2E:		LdRA RgL
OpII26:		LdRA RgIH
OpII2E:		LdRA RgIL

;Запись непосредственного значения в память
Op36:		mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,RgHL
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet

OpII36:		ReadIndex
		mov	eax,edi
		inc	di
		mov	ebp,eax
		shr	ebp,0Eh
		and	ah,03Fh
		add	eax,[(_EmuTable.SpecSeg)+ebp*4]
		mov	al,[eax]
		mov	ebp,ebx
		shr	ebp,0Eh
		and	bh,03Fh
		add	ebx,[(_EmuTable.SpecSeg)+ebp*4]
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet

;Обмен регистров
Op08:		and	ch,028h
		and	dl,0D7h
		or	dl,ch
		mov	eax,[_EmuTable.DataCPU.RegAFa]
		mov	[_EmuTable.DataCPU.RegAFa],edx
		mov	edx,eax
		mov	ch,dl
		ret
OpD9:		mov	ebx,RgBC
		mov	eax,[_EmuTable.DataCPU.RegBCa]
		mov	[_EmuTable.DataCPU.RegBCa],ebx
		mov	RgBC,eax
		mov	ebx,RgDE
		mov	eax,[_EmuTable.DataCPU.RegDEa]
		mov	[_EmuTable.DataCPU.RegDEa],ebx
		mov	RgDE,eax
		mov	ebx,RgHL
		mov	eax,[_EmuTable.DataCPU.RegHLa]
		mov	[_EmuTable.DataCPU.RegHLa],ebx
		mov	RgHL,eax
		ret
OpEB:           mov	eax,RgHL
		mov	ebx,RgDE
		mov	RgHL,ebx
		mov	RgDE,eax
		ret
OpE3:		lea	ebx,[si+1]
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ah,RgH
		mov	RgH,al
		cmp	ebx,OFFSET _SpecROM
		jnc	@@LowByte
		mov	[ebx],ah
		WrMemCont
@@LowByte:	mov	ebx,esi
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ah,RgL
		mov	RgL,al
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],ah
		WrMemRet
OpIIE3:		lea	ebx,[si+1]
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ah,RgIH
		mov	RgIH,al
		cmp	ebx,OFFSET _SpecROM
		jnc	@@LowByte
		mov	[ebx],ah
		WrMemCont ebp
@@LowByte:	mov	ebx,esi
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ah,RgIL
		mov	RgIL,al
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],ah
		WrMemRet

;Увеличение регистровой пары
Op03:		inc	RgWBC
		ret
Op13:		inc	RgWDE
		ret
Op23:		inc	RgWHL
		ret
OpII23:		inc	[WORD ebp]
		ret
Op33:		inc	si
		ret

;Уменьшение регистровой пары
Op0B:		dec	RgWBC
		ret
Op1B:		dec	RgWDE
		ret
Op2B:		dec	RgWHL
		ret
OpII2B:		dec	[WORD ebp]
		ret
Op3B:		dec	si
		ret

;Увеличение регистра
MACRO IncReg Reg
		inc	Reg
		mov	al,Reg
		mov	ch,[IncDecDataFlag+eax]
		and	dl,001h
		or	dl,ch
		ret
ENDM
Op3C:		IncReg dh
Op04:		IncReg RgB
Op0C:		IncReg RgC
Op14:		IncReg RgD
Op1C:		IncReg RgE
Op24:		IncReg RgH
Op2C:		IncReg RgL
OpII24:		IncReg RgIH
OpII2C:		IncReg RgIL

;Увеличение ячейки памяти
MACRO IncMem
		AbsAdrSpec eax
		mov	al,[ebx]
		inc	al
		mov	ch,[IncDecDataFlag+eax]
		and	dl,001h
		or	dl,ch
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet
ENDM
Op34:		mov	ebx,RgHL
		IncMem
OpII34:		ReadIndex
		IncMem

;Уменьшение регистра
MACRO DecReg Reg
		dec	Reg
		mov	al,Reg
		mov	ch,[IncDecDataFlag+100h+eax]
		and	dl,001h
		or	dl,ch
		ret
ENDM
Op3D:		DecReg dh
Op05:		DecReg RgB
Op0D:		DecReg RgC
Op15:		DecReg RgD
Op1D:		DecReg RgE
Op25:		DecReg RgH
Op2D:		DecReg RgL
OpII25:		DecReg RgIH
OpII2D:		DecReg RgIL

;Уменьшение ячейки памяти
MACRO DecMem
		AbsAdrSpec eax
		mov	al,[ebx]
		dec	al
		mov	ch,[IncDecDataFlag+100h+eax]
		and	dl,001h
		or	dl,ch
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet
ENDM
Op35:		mov	ebx,RgHL
		DecMem
OpII35:		ReadIndex
		DecMem

;Сложение регистров
MACRO SetFlagAdd
		mov	ch,dh
		lahf
		mov	dl,ah
		jo	@@SetO
		and	dl,0D1h
		ret
@@SetO:		and	dl,0D1h
		or	dl,004h
		ret
ENDM

MACRO OpAdd Reg
		add	dh,Reg
		SetFlagAdd
ENDM

Op80:		OpAdd RgB
Op81:		OpAdd RgC
Op82:		OpAdd RgD
Op83:		OpAdd RgE
Op84:		OpAdd RgH
Op85:		OpAdd RgL
Op87:		OpAdd RgA
Op86:		mov	ebx,RgHL
		AbsAdrSpec eax
		OpAdd [ebx]
OpC6:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		OpAdd [ebx]
OpII84:		OpAdd RgIH
OpII85:		OpAdd RgIL
OpII86:		ReadIndex
		AbsAdrSpec eax
		OpAdd [ebx]

;Сложение регистров с учетом переноса
MACRO OpAdc Reg
		shl	dl,008h
		adc	dh,Reg
		SetFlagAdd
ENDM

Op88:		OpAdc RgB
Op89:		OpAdc RgC
Op8A:		OpAdc RgD
Op8B:		OpAdc RgE
Op8C:		OpAdc RgH
Op8D:		OpAdc RgL
Op8F:		OpAdc RgA
Op8E:		mov	ebx,RgHL
		AbsAdrSpec eax
		OpAdc [ebx]
OpCE:		mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		OpAdc [ebx]
OpII8C:		OpAdc RgIH
OpII8D:		OpAdc RgIL
OpII8E:		ReadIndex
		AbsAdrSpec eax
		OpAdc [ebx]

;Вычитание регистров
MACRO SetFlagSub
		lahf
		mov	dl,ah
		jo	@@SetO
		and	dl,0D1h
		or	dl,002h
		ret
@@SetO:		and	dl,0D1h
		or	dl,006h
		ret
ENDM

MACRO OpSub Reg
		sub	dh,Reg
		mov	ch,dh
		SetFlagSub
ENDM

Op90:		OpSub RgB
Op91:		OpSub RgC
Op92:		OpSub RgD
Op93:		OpSub RgE
Op94:		OpSub RgH
Op95:		OpSub RgL
Op97:		OpSub RgA
Op96:		mov	ebx,RgHL
		AbsAdrSpec eax
		OpSub [ebx]
OpD6:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		OpSub [ebx]
OpII95:		OpSub RgIL
OpII96:		ReadIndex
		AbsAdrSpec eax
		OpSub [ebx]
OpII94:		OpSub RgIH

;Вычитание регистров с учетом переноса
MACRO OpSbc Reg,Op
		shl	dl,008h
		sbb	dh,Reg
		mov	ch,dh
		SetFlagSub
ENDM

Op98:		OpSbc RgB
Op99:		OpSbc RgC
Op9A:		OpSbc RgD
Op9B:		OpSbc RgE
Op9C:		OpSbc RgH
Op9D:		OpSbc RgL
Op9F:		OpSbc RgA
Op9E:		mov	ebx,RgHL
		AbsAdrSpec eax
		OpSbc [ebx]
OpDE:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		OpSbc [ebx]
OpII9C:		OpSbc RgIH
OpII9D:		OpSbc RgIL
OpII9E:		ReadIndex
		AbsAdrSpec eax
		OpSbc [ebx]

;Сравнение
MACRO CmpReg Reg
		mov	ch,Reg
		cmp	dh,ch
		SetFlagSub
ENDM
OpB8:		CmpReg RgB
OpB9:		CmpReg RgC
OpBA:		CmpReg RgD
OpBB:		CmpReg RgE
OpBC:		CmpReg RgH
OpBD:		CmpReg RgL
OpBF:		mov	dl,042h
		mov	ch,dh
		ret
OpBE:		mov	ebx,RgHL
		AbsAdrSpec eax
		CmpReg [ebx]
OpFE:           mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		CmpReg [ebx]
OpIIBC:		CmpReg RgIH
OpIIBD:		CmpReg RgIL
OpIIBE:		ReadIndex
		AbsAdrSpec eax
		CmpReg [ebx]

;Логическое AND
MACRO SetFlagOrAnd
		lahf
		mov	ch,dh
		and	ah,0C4h
		mov	dl,ah
ENDM
MACRO AndA Reg
		and	dh,Reg
		SetFlagOrAnd
		or	dl,010h
		ret
ENDM
OpA0:		AndA RgB
OpA1:		AndA RgC
OpA2:		AndA RgD
OpA3:		AndA RgE
OpA4:		AndA RgH
OpA5:		AndA RgL
OpA6:		mov	ebx,RgHL
		AbsAdrSpec eax
		AndA [ebx]
OpA7:		AndA dh
OpE6:           mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		AndA [ebx]
OpIIA4:		AndA RgIH
OpIIA5:		AndA RgIL
OpIIA6:		ReadIndex
		AbsAdrSpec eax
		AndA [ebx]
;Логическое XOR
MACRO XorA Reg
		xor	dh,Reg
		SetFlagOrAnd
		ret
ENDM
OpA8:		XorA RgB
OpA9:		XorA RgC
OpAA:		XorA RgD
OpAB:		XorA RgE
OpAC:		XorA RgH
OpAD:		XorA RgL
OpAE:		mov	ebx,RgHL
		AbsAdrSpec eax
		XorA [ebx]
OpAF:		mov	edx,044h
		mov	ch,dl
		ret
OpEE:           mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		XorA [ebx]
OpIIAC:		XorA RgIH
OpIIAD:		XorA RgIL
OpIIAE:		ReadIndex
		AbsAdrSpec eax
		XorA [ebx]
;Логическое OR
MACRO OrA Reg
		or	dh,Reg
		SetFlagOrAnd
		ret
ENDM
OpB0:		OrA RgB
OpB1:		OrA RgC
OpB2:		OrA RgD
OpB3:		OrA RgE
OpB4:		OrA RgH
OpB5:		OrA RgL
OpB6:		mov	ebx,RgHL
		AbsAdrSpec eax
		OrA [ebx]
OpB7:		OrA dh
OpF6:		mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		OrA [ebx]
OpIIB4:		OrA RgIH
OpIIB5:		OrA RgIL
OpIIB6:		ReadIndex
		AbsAdrSpec eax
		OrA [ebx]

;Сложение регистровых пар
MACRO AddWord Reg0,Reg1
		mov	eax,Reg0
IFDIF <Reg0>,<Reg1>
		mov	ebx,Reg1
		add	al,bl
		adc	ah,bh
ELSE
		add	al,al
		adc	ah,ah
ENDIF
		mov	Reg0,eax
		mov	ch,ah
		lahf
		and	dl,0C4h
		and	ah,011h
		or	dl,ah
		ret
ENDM
Op29:		AddWord RgHL,RgHL
Op19:		AddWord RgHL,RgDE
Op09:		AddWord RgHL,RgBC
Op39:		AddWord RgHL,RgSP
OpII29:		AddWord RgII,RgII
OpII19:		AddWord RgII,RgDE
OpII09:		AddWord RgII,RgBC
OpII39:		AddWord RgII,RgSP

;Сложение регистровых пар с учетом переноса
MACRO AdcWord Reg
		mov	ebx,RgHL
		shl	dl,08h
IFIDN <Reg>,<RgHL>
		adc	bl,bl
		adc	bh,bh
ELSE
		mov	eax,Reg
		adc	bl,al
		adc	bh,ah
ENDIF
		mov	RgHL,ebx
		mov	ch,bh
		lahf
		jo	@@SetO
		cmp	ebx,001h
		sbb	dl,dl
		and	ah,091h
		and	dl,040h
		or	dl,ah
		ret
@@SetO:		mov	dl,004h
		cmp	ebx,001h
		sbb	al,al
		and	eax,09140h
		or	dl,ah
		or	dl,al
		ret
ENDM
OpED6A:		AdcWord RgHL
OpED5A:		AdcWord RgDE
OpED4A:		AdcWord RgBC
OpED7A:		AdcWord RgSP

MACRO SbcWord Reg
		mov	ebx,RgHL
		shl	dl,08h
IFIDN <Reg>,<RgHL>
		sbb	bl,bl
		sbb	bh,bh
ELSE
		mov	eax,Reg
		sbb	bl,al
		sbb	bh,ah
ENDIF
		mov	RgHL,ebx
		mov	ch,bh
		lahf
		jo	@@SetO
		mov	dl,002h
		cmp	ebx,001h
		sbb	al,al
		and	eax,09140h
		or	dl,ah
		or	dl,al
		ret
@@SetO:		mov	dl,006h
		cmp	ebx,001h
		sbb	al,al
		and	eax,09140h
		or	dl,ah
		or	dl,al
		ret
ENDM
OpED62:		SbcWord RgHL
OpED52:		SbcWord RgDE
OpED42:		SbcWord RgBC
OpED72:		SbcWord RgSP

;Сохранение в стеке
MACRO PushReg Reg
IFDIF <Reg>,<RgAF>
		mov	eax,Reg
ENDIF
		dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@LowByte
IFDIF <Reg>,<RgAF>
		mov	[ebx],ah
ELSE
		mov	[ebx],dh
ENDIF
		WrMemCont eax
@@LowByte:	dec	si
		mov	ebx,esi
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
IFDIF <Reg>,<RgAF>
		mov	[ebx],al
ELSE
		and	ch,028h
		and	dl,0D7h
		or	dl,ch
		mov	[ebx],dl
ENDIF
		WrMemRet
ENDM
OpF5:		PushReg RgAF
OpE5:		PushReg RgHL
OpD5:		PushReg RgDE
OpC5:		PushReg RgBC
OpIIE5:		PushReg RgII

;Чтение из стека
MACRO PopReg Reg
		mov	ebx,esi
		AbsAdrSpec eax
		inc	si
IFIDN <Reg>,<RgAF>
		mov	dl,[ebx]
		mov	ch,dl
ELSE
		mov	al,[ebx]
ENDIF
		mov	ebx,esi
		AbsAdrSpec ebp
		inc	si
IFIDN <Reg>,<RgAF>
		mov	dh,[ebx]
ELSE
		mov	ah,[ebx]
		mov	Reg,eax
ENDIF
		ret
ENDM
OpF1:		PopReg RgAF
OpE1:		PopReg RgHL
OpD1:		PopReg RgDE
OpC1:		PopReg RgBC
OpIIE1:		mov	ebx,esi
		AbsAdrSpec eax
		inc	si
		mov	al,[ebx]
		mov	RgIL,al
		mov	ebx,esi
		AbsAdrSpec eax
		inc	si
		mov	al,[ebx]
		mov	RgIH,al
		ret

;Ротация регистра A
Op07:		and	dl,0C4h
		rol	dh,01h
		adc     dl,000h
		mov	ch,dh
		ret
Op0F:		and	dl,0C4h
		ror	dh,01h
		adc	dl,000h
		mov	ch,dh
		ret
Op17:		mov	al,dl
		and	dl,0C4h
		shl	al,08h
		adc	dh,dh
		adc	dl,000h
		mov	ch,dh
		ret
Op1F:		mov	al,dl
		and	dl,0C4h
		shl	al,08h
		rcr	dh,01h
		adc	dl,000h
		mov	ch,dh
		ret

;Ротация регистра влево
MACRO WriteRotMem
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],ch
		WrMemRet
ENDM

MACRO RotateLeftReg Reg
		rol	Reg,01h
		mov	ch,Reg
		test	ch,ch
		lahf
		and	ah,0C4h
		and	ch,029h
		mov	dl,ah
		or	dl,ch
		ret
ENDM
OpCB00:		RotateLeftReg RgB
OpCB01:		RotateLeftReg RgC
OpCB02:		RotateLeftReg RgD
OpCB03:		RotateLeftReg RgE
OpCB04:		RotateLeftReg RgH
OpCB05:		RotateLeftReg RgL
OpCB07:		RotateLeftReg dh

MACRO RotateLeftMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		add	ch,ch
		adc	ch,000h
IF Reg
		mov	[ebp],ch
ENDIF
		lahf
		mov	dl,ch
		and	dl,029h
		and	ah,0C4h
		or	dl,ah
		WriteRotMem
ENDM
OpCB06:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB06:	RotateLeftMem 0
OpIICB00:	RotateLeftMem 1
OpIICB07:	mov	ch,[ebx]
		add	ch,ch
		adc	ch,000h
		lahf
		mov	dh,ch
		mov	dl,ch
		and	dl,029h
		and	ah,0C4h
		or	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Ротация регистра вправо
MACRO RotateRightReg Reg
		ror	Reg,01h
		mov	ch,Reg
		sbb	dl,dl
		test	ch,ch
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		ret
ENDM
OpCB08:		RotateRightReg RgB
OpCB09:		RotateRightReg RgC
OpCB0A:		RotateRightReg RgD
OpCB0B:		RotateRightReg RgE
OpCB0C:		RotateRightReg RgH
OpCB0D:		RotateRightReg RgL
OpCB0F:		RotateRightReg dh

MACRO RotateRightMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		ror	ch,01h
IF Reg
		mov	[ebp],ch
ENDIF
		sbb	dl,dl
		test	ch,ch
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		WriteRotMem
ENDM
OpCB0E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB0E:	RotateRightMem 0
OpIICB08:	RotateRightMem 1
OpIICB0F:	mov	ch,[ebx]
		ror	ch,01h
		sbb	dl,dl
		mov	dh,ch
		test	ch,ch
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Ротация регистра влево через перенос
MACRO RotCarLeftReg Reg
		shl	dl,08h
IFIDN <Reg>,<dh>
		adc	dh,dh
		mov	ch,dh
ELSE
		mov	ch,Reg
		adc	ch,ch
		mov	Reg,ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		ret
ENDM
OpCB10:		RotCarLeftReg RgB
OpCB11:		RotCarLeftReg RgC
OpCB12:		RotCarLeftReg RgD
OpCB13:		RotCarLeftReg RgE
OpCB14:		RotCarLeftReg RgH
OpCB15:		RotCarLeftReg RgL
OpCB17:		RotCarLeftReg dh

MACRO RotCarLeftMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		shl	dl,08h
		adc	ch,ch
IF Reg
		mov	[ebp],ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		WriteRotMem
ENDM
OpCB16:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB16:	RotCarLeftMem 0
OpIICB10:	RotCarLeftMem 1
OpIICB17:	mov	ch,[ebx]
		shl	dl,08h
		adc	ch,ch
		mov	dh,ch
		lahf
		and	ah,0C5h
		mov	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Ротация регистра вправо через перенос
MACRO RotCarRightReg Reg
		shl	dl,08h
		rcr	Reg,01h
		adc	dl,dl
		mov	ch,Reg
		test	ch,ch
		lahf
		and	ah,0C4h
		or	dl,ah
		ret
ENDM
OpCB18:		RotCarRightReg RgB
OpCB19:		RotCarRightReg RgC
OpCB1A:		RotCarRightReg RgD
OpCB1B:		RotCarRightReg RgE
OpCB1C:		RotCarRightReg RgH
OpCB1D:		RotCarRightReg RgL
OpCB1F:		RotCarRightReg dh

MACRO RotCarRightMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		shl	dl,08h
		rcr	ch,01h
IF Reg
		mov	[ebp],ch
ENDIF
		adc	dl,dl
		test	ch,ch
		lahf
		and	ah,0C4h
		or	dl,ah
		WriteRotMem
ENDM
OpCB1E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB1E:	RotCarRightMem 0
OpIICB18:	RotCarRightMem 1
OpIICB1F:	mov	ch,[ebx]
		shl	dl,08h
		rcr	ch,01h
		mov	dh,ch
		adc	dl,dl
		test	ch,ch
		lahf
		and	ah,0C4h
		or	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Сдвиг регистра влево
MACRO ShiftLeftReg Reg
IFIDN <Reg>,<dh>
		add	dh,dh
ELSE
		shl	Reg,01h
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		mov	ch,Reg
		ret
ENDM
OpCB20:		ShiftLeftReg RgB
OpCB21:		ShiftLeftReg RgC
OpCB22:		ShiftLeftReg RgD
OpCB23:		ShiftLeftReg RgE
OpCB24:		ShiftLeftReg RgH
OpCB25:		ShiftLeftReg RgL
OpCB27:		ShiftLeftReg dh

MACRO ShiftLeftMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		add	ch,ch
IF Reg
		mov	[ebp],ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		WriteRotMem
ENDM
OpCB26:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB26:	ShiftLeftMem 0
OpIICB20:	ShiftLeftMem 1
OpIICB27:	mov	ch,[ebx]
		add	ch,ch
		mov	dh,ch
		lahf
		and	ah,0C5h
		mov	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Сдвиг регистра вправо арифметический
MACRO ShAriRightReg Reg
		sar	Reg,01h
		lahf
		and	ah,0C5h
		mov	dl,ah
		mov	ch,Reg
		ret
ENDM
OpCB28:		ShAriRightReg RgB
OpCB29:		ShAriRightReg RgC
OpCB2A:		ShAriRightReg RgD
OpCB2B:		ShAriRightReg RgE
OpCB2C:		ShAriRightReg RgH
OpCB2D:		ShAriRightReg RgL
OpCB2F:		ShAriRightReg dh

MACRO ShAriRightMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		sar	ch,01h
IF Reg
		mov	[ebp],ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		WriteRotMem
ENDM
OpCB2E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB2E:	ShAriRightMem 0
OpIICB28:	ShAriRightMem 1
OpIICB2F:	mov	ch,[ebx]
		sar	ch,01h
		mov	dh,ch
		lahf
		and	ah,0C5h
		mov	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Сдвиг регистра влево и включение младшего бита
MACRO ShiftLeftSetReg Reg
IFIDN <Reg>,<dh>
		add	dh,dh
		inc	dh
		mov	ch,dh
ELSE
		mov	ch,Reg
		add	ch,ch
		inc	ch
		mov	Reg,ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		ret
ENDM
OpCB30:		ShiftLeftSetReg RgB
OpCB31:		ShiftLeftSetReg RgC
OpCB32:		ShiftLeftSetReg RgD
OpCB33:		ShiftLeftSetReg RgE
OpCB34:		ShiftLeftSetReg RgH
OpCB35:		ShiftLeftSetReg RgL
OpCB37:		ShiftLeftSetReg dh

MACRO ShiftLeftSetMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		add	ch,ch
		inc	ch
		lahf
IF Reg
		mov	[ebp],ch
ENDIF
		and	ah,0C5h
		mov	dl,ah
		WriteRotMem
ENDM
OpCB36:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB36:	ShiftLeftSetMem 0
OpIICB30:	ShiftLeftSetMem 1
OpIICB37:	mov	ch,[ebx]
		add	ch,ch
		inc	ch
		mov	dh,ch
		lahf
		and	ah,0C5h
		mov	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;Сдвиг регистра вправо логический
MACRO ShLogRightReg Reg
		shr	Reg,01h
		lahf
		and	ah,0C5h
		mov	dl,ah
		mov	ch,Reg
		ret
ENDM
OpCB38:		ShLogRightReg RgB
OpCB39:		ShLogRightReg RgC
OpCB3A:		ShLogRightReg RgD
OpCB3B:		ShLogRightReg RgE
OpCB3C:		ShLogRightReg RgH
OpCB3D:		ShLogRightReg RgL
OpCB3F:		ShLogRightReg dh

MACRO ShLogRightMem Reg
IF Reg
		and	al,003h
		mov	ebp,[Registers+eax*4]
ENDIF
		mov	ch,[ebx]
		shr	ch,01h
IF Reg
		mov	[ebp],ch
ENDIF
		lahf
		and	ah,0C5h
		mov	dl,ah
		WriteRotMem
ENDM
OpCB3E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB3E:	ShLogRightMem 0
OpIICB38:	ShLogRightMem 1
OpIICB3F:	mov	ch,[ebx]
		shr	ch,01h
		mov	dh,ch
		lahf
		and	ah,0C5h
		mov	dl,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet

;+ Проверка бита +
MACRO BitR Bit,Reg
		mov	ch,Reg
		test	ch,Bit
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		or	dl,010h
		ret
ENDM
MACRO BitOp Bit
BtB&Bit:	BitR Bit,RgB
BtC&Bit:	BitR Bit,RgC
BtD&Bit:	BitR Bit,RgD
BtE&Bit:	BitR Bit,RgE
BtH&Bit:	BitR Bit,RgH
BtL&Bit:	BitR Bit,RgL
BtA&Bit:	BitR Bit,dh
BtM&Bit:	mov	ebx,RgHL
		AbsAdrSpec eax
		test	[BYTE ebx],Bit
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		or	dl,010h
		mov	ch,dl
		ret
BtI&Bit:	test	[BYTE ebx],Bit
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		or	dl,018h
		mov	ch,dl
		ret
ENDM
		BitOp 01h
		BitOp 02h
		BitOp 04h
		BitOp 08h
		BitOp 10h
		BitOp 20h
		BitOp 40h
		BitOp 80h

;Выключение бита в регистре
MACRO ResR Bit,Reg
		and	Reg,Bit
		ret
ENDM
MACRO ResOp Bit
RsB&Bit:	ResR Bit,RgB
RsC&Bit:	ResR Bit,RgC
RsD&Bit:	ResR Bit,RgD
RsE&Bit:	ResR Bit,RgE
RsH&Bit:	ResR Bit,RgH
RsL&Bit:	ResR Bit,RgL
RsA&Bit:	ResR Bit,dh
ENDM
		ResOp 0FEh
		ResOp 0FDh
		ResOp 0FBh
		ResOp 0F7h
		ResOp 0EFh
		ResOp 0DFh
		ResOp 0BFh
		ResOp 07Fh

;Включение бита в регистре
MACRO SetR Bit,Reg
		or	Reg,Bit
		ret
ENDM
MACRO SetOp Bit
StB&Bit:	SetR Bit,RgB
StC&Bit:	SetR Bit,RgC
StD&Bit:	SetR Bit,RgD
StE&Bit:	SetR Bit,RgE
StH&Bit:	SetR Bit,RgH
StL&Bit:	SetR Bit,RgL
StA&Bit:	SetR Bit,dh
ENDM
		SetOp 01h
		SetOp 02h
		SetOp 04h
		SetOp 08h
		SetOp 10h
		SetOp 20h
		SetOp 40h
		SetOp 80h

;Включение и выключение бит в памяти
MACRO SetResMem Bit,Op
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
IF Op
		or	[BYTE ebx],Bit
ELSE
		and	[BYTE ebx],Bit
ENDIF
		WrMemRet
ENDM
MACRO SetResMemReg Bit,Op
		and	al,003h
		mov	ebp,[Registers+eax*4]
		mov	al,[ebx]
IF Op
		or	al,Bit
ELSE
		and	al,Bit
ENDIF
		mov	[ebp],al
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],al
		WrMemRet
ENDM
MACRO SetResMemRgA Bit,Op
		mov	dh,[ebx]
IF Op
		or	dh,Bit
ELSE
		and	dh,Bit
ENDIF
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Ret
		mov	[ebx],dh
		WrMemRet
ENDM

OpCB86:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB86:	SetResMem 0FEh,0
OpIICB80:	SetResMemReg 0FEh,0
OpIICB87:	SetResMemRgA 0FEh,0
OpCB8E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB8E:	SetResMem 0FDh,0
OpIICB88:	SetResMemReg 0FDh,0
OpIICB8F:	SetResMemRgA 0FDh,0
OpCB96:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB96:	SetResMem 0FBh,0
OpIICB90:	SetResMemReg 0FBh,0
OpIICB97:	SetResMemRgA 0FBh,0
OpCB9E:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICB9E:	SetResMem 0F7h,0
OpIICB98:	SetResMemReg 0F7h,0
OpIICB9F:	SetResMemRgA 0F7h,0
OpCBA6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBA6:	SetResMem 0EFh,0
OpIICBA0:	SetResMemReg 0EFh,0
OpIICBA7:	SetResMemRgA 0EFh,0
OpCBAE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBAE:	SetResMem 0DFh,0
OpIICBA8:	SetResMemReg 0DFh,0
OpIICBAF:	SetResMemRgA 0DFh,0
OpCBB6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBB6:	SetResMem 0BFh,0
OpIICBB0:	SetResMemReg 0BFh,0
OpIICBB7:	SetResMemRgA 0BFh,0
OpCBBE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBBE:	SetResMem 07Fh,0
OpIICBB8:	SetResMemReg 07Fh,0
OpIICBBF:	SetResMemRgA 07Fh,0
OpCBC6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBC6:	SetResMem 001h,1
OpIICBC0:	SetResMemReg 001h,1
OpIICBC7:	SetResMemRgA 001h,1
OpCBCE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBCE:	SetResMem 002h,1
OpIICBC8:	SetResMemReg 002h,1
OpIICBCF:	SetResMemRgA 002h,1
OpCBD6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBD6:	SetResMem 004h,1
OpIICBD0:	SetResMemReg 004h,1
OpIICBD7:	SetResMemRgA 004h,1
OpCBDE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBDE:	SetResMem 008h,1
OpIICBD8:	SetResMemReg 008h,1
OpIICBDF:	SetResMemRgA 008h,1
OpCBE6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBE6:	SetResMem 010h,1
OpIICBE0:	SetResMemReg 010h,1
OpIICBE7:	SetResMemRgA 010h,1
OpCBEE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBEE:	SetResMem 020h,1
OpIICBE8:	SetResMemReg 020h,1
OpIICBEF:	SetResMemRgA 020h,1
OpCBF6:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBF6:	SetResMem 040h,1
OpIICBF0:	SetResMemReg 040h,1
OpIICBF7:	SetResMemRgA 040h,1
OpCBFE:		mov	ebx,RgHL
		AbsAdrSpec eax
OpIICBFE:	SetResMem 080h,1
OpIICBF8:	SetResMemReg 080h,1
OpIICBFF:	SetResMemRgA 080h,1

;Ввод с порта
MACRO SetFlagInD Reg
		mov	ch,Reg
		test	Reg,Reg
		lahf
		and	dl,001h
		and	ah,0C4h
		or	dl,ah
		ret
ENDM
OpDB:           mov	ebx,edi
		inc	di
		AbsAdrSpec eax
		mov	bl,[ebx]
		mov	bh,dh
		call	PortIn_
		mov	dh,al
		ret
OpED40:		mov	ebx,RgBC
		call	PortIn_
		mov	RgB,al
		SetFlagInD al
OpED48:		mov	ebx,RgBC
		call	PortIn_
		mov	RgC,al
		SetFlagInD al
OpED50:		mov	ebx,RgBC
		call	PortIn_
		mov	RgD,al
		SetFlagInD al
OpED58:		mov	ebx,RgBC
		call	PortIn_
		mov	RgE,al
		SetFlagInD al
OpED60:		mov	ebx,RgBC
		call	PortIn_
		mov	RgH,al
		SetFlagInD al
OpED68:		mov	ebx,RgBC
		call	PortIn_
		mov	RgL,al
		SetFlagInD al
OpED70:		mov	ebx,RgBC
		call	PortIn_
		SetFlagInD al
OpED78:		mov	ebx,RgBC
		call	PortIn_
		mov	dh,al
		SetFlagInD al

;Вывод в порт
OpD3:		mov	ebx,edi
		AbsAdrSpec eax
		inc	di
		mov	bl,[ebx]
		mov	bh,dh
		mov	al,dh
		call	PortOut_
		ret
MACRO PortOutR Reg
		mov	ebx,RgBC
		mov	al,Reg
		jmp	PortOut_
ENDM
OpED41:		PortOutR bh
OpED49:		PortOutR bl
OpED51:		PortOutR RgD
OpED59:		PortOutR RgE
OpED61:		PortOutR RgH
OpED69:		PortOutR RgL
OpED79:		PortOutR RgA
OpED71:		PortOutR 0

;Копирование блока
MACRO BlCopy Dir,Cont
		mov	ebx,RgHL
		AbsAdrSpec eax
		mov	ch,[ebx]
		mov	ebx,RgDE
		AbsAdrSpec eax
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont
		mov	[ebx],ch
		WrMemCont
@@Cont:		Dir	RgWHL
		Dir	RgWDE
		dec	RgWBC
		setnz	bl
		shl	bl,02h
		test	dh,003h			;;;?
		setp	al				;;setnp???
		shl	al,05h
		xor	ch,al
		and	dl,0C1h
		or	dl,bl
IF Cont
		test	dl,004h
		jz	@@Ret
		sub	di,002h
ENDIF
@@Ret:		ret
ENDM

OpEDA0:		BlCopy inc
OpEDA8:		BlCopy dec
OpEDB0:		BlCopy inc,1
OpEDB8:		BlCopy dec,1

;Поиск байта в блоке
MACRO BlCp Dir,Cont
		mov	ebx,RgHL
		AbsAdrSpec eax
		mov	ch,dh
		sub	ch,[ebx]
		lahf
		and	dl,001h
		and	ah,0D0h
		or	dl,ah
		Dir	RgWHL
		dec	RgWBC
		setnz	ah
		shl	ah,02h
		or	dl,ah
		or	dl,002h
IF Cont
		mov	ah,dl		;;;O
		sahf
		jz	@@Ret
		jnp	@@Ret
		sub	di,002h
ENDIF
@@Ret:		ret
ENDM

OpEDA1:		BlCp inc
OpEDA9:		BlCp dec
OpEDB1:		BlCp inc,1
OpEDB9:		BlCp dec,1

;Блочный ввод/вывод
MACRO BlInOut Dir,Cont
		Dir	RgWHL
		dec	RgB
		mov	ch,RgB
		test	ch,ch
		lahf
		and	ah,0C4h
		mov	dl,ah
IF Cont
		test	dl,040h
		jnz	@@Ret
		sub	di,00002h
ENDIF
@@Ret:		ret
ENDM

MACRO BlIn Dir,Cont
		mov	ebx,RgBC
		call	PortIn_
		mov	ebx,RgHL
		AbsAdrSpec ebp
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont
		mov	[ebx],al
		WrMemCont
@@Cont:		BlInOut Dir,Cont
ENDM

MACRO BlOut Dir,Cont
		mov	ebx,RgHL
		AbsAdrSpec eax
		mov	al,[ebx]
		mov	ebx,RgBC
		call	PortOut_
		BlInOut Dir,Cont
ENDM

OpEDA2:		BlIn inc
OpEDAA:		BlIn dec
OpEDB2:		BlIn inc,1
OpEDBA:		BlIn dec,1
OpEDA3:		BlOut inc
OpEDAB:		BlOut dec
OpEDB3:		BlOut inc,1
OpEDBB:		BlOut dec,1

;Комманды работы с прерываниями
OpF3:	mov	[_EmuTable.DataCPU.IFF],00000h
	ret
OpFB:	cmp	[_EmuTable.DataCPU.IFF1],004h
	jz	@@Exit
	mov	ebx,edi
	AbsAdrSpec eax
	mov	al,[ebx]
	test	[_EmuTable.Flags],MASK Trace
	jz	@@EITraceOk
	mov	ebx,[_PrFirst+P_CPU*4]
	test	ebx,ebx
	jz	@@EITraceOk
	push	eax
@@EICicleCPU:
	push	ebx ecx edx esi edi
	call	[ebx+Prc.Pr]
	pop	edi esi edx ecx ebx
	mov	ebx,[ebx+Prc.Next]
	test	ebx,ebx
	jnz	@@EICicleCPU
	pop	eax
@@EITraceOk:
	inc	di
	inc	cl
	cmp	al,0F3h
	jz	OpF3			;;;
	call	[_TableOp+eax*4]
@@Exit:	mov	[_EmuTable.DataCPU.IFF],00404h
	ret
OpED46:		mov	[_EmuTable.DataCPU.IM],000h
		ret
OpED56:		mov	[_EmuTable.DataCPU.IM],001h
		ret
OpED5E:		mov	[_EmuTable.DataCPU.IM],002h
		ret
;Остановка
Op76:		mov	[BYTE _EmuTable.DataCPU.Halt],001h
		dec	di
		ret

;Ротация полубайтов
OpED67:		mov	ebx,RgHL
		AbsAdrSpec eax
		mov	ah,dh
		mov	al,[ebx]
		ror	ax,04h
		ror	ah,04h
		mov	dh,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont
		mov	[ebx],al
		WrMemCont
@@Cont:		SetFlagInD dh
OpED6F:		mov	ebx,RgHL
		AbsAdrSpec eax
		mov	ah,[ebx]
		mov	al,dh
		rol	al,04h
		ror	ax,04h
		mov	dh,ah
		cmp	ebx,OFFSET _SpecROM
		jnc	@@Cont
		mov	[ebx],al
		WrMemCont
@@Cont:		SetFlagInD dh

;Десятичная коррекция аккумулятора
Op27:		mov	al,dh		;;; Flag H?
		add	eax,066h
		or	dl,ah
		mov	al,dh
		mov	ah,dl
		and	dl,003h
		test	dl,002h
		jnz	@@Das
		sahf
		daa
		lahf
		and	ah,0D4h
		mov	ch,al
		or	dl,ah
		mov	dh,al
		ret
@@Das:		sahf
		das
		lahf
		and	ah,0D4h
		mov	ch,al
		or	dl,ah
		mov	dh,al
		ret

;Работа с флагом переноса
Op37:		mov	ch,dh
		and	dl,0C4h
		or	dl,001h
		ret
Op3F:		mov	ch,dh
		and	dl,0C5h
		xor	dl,001h
		test	dl,001h
		jnz	@@Ret
		or	dl,010h
@@Ret:		ret

;Инвертирование байта
Op2F:		and	dl,0C5h
		xor	edx,0FF12h
		mov	ch,dh
		ret

;Изменение знака аккумулятора
OpED44:		neg	dh
		mov	ch,dh
		SetFlagSub

PROC ResetCPU_
		mov	[_EmuTable.DataCPU.RegPC],0
		mov	[_EmuTable.DataCPU.IM],0
		mov	[_EmuTable.DataCPU.IFF],0
		mov	[BYTE _EmuTable.DataCPU.Halt],0
		mov	[CounterInt],0
		ret
ENDP

;* Инициализация таблицы инкремента/декремента *
PROC IncDecTblIni_ NEAR
		sub	ebx,ebx
@@CicleInc:	inc	bl
		lahf
		seto	al
		shl	al,02h
		and	ah,0D0h
		or	ah,al
		mov	al,bl
		and	al,028h
		or	ah,al
		mov	[IncDecDataFlag+ebx],ah
		test	ebx,ebx
		jnz	@@CicleInc
@@CicleDec:	dec	bl
		lahf
		seto	al
		shl	al,02h
		and	ah,0D0h
		or	ah,al
		mov	al,bl
		and	al,028h
		or	ah,al
		or	ah,002h
		mov	[IncDecDataFlag+100h+ebx],ah
		test	ebx,ebx
		jnz	@@CicleDec
		ret
ENDP

END
