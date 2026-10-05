.op "PUSH","N","8$1 73 9$1 73"
.op "POP","N","60 72 B$1 F0 A$1"
.op "CALL","W","D4 W1"
.op "RTN","","D5"
.op "MOV","NR","8$2 A$1 9$2 B$1"
.op "MOV","NW","F8 L2 A$1 F8 H2 B$1"
.op "DO","W","DC L1"
.op "ADD16","NW","8$1 FC 01 A$1 9$1 7C 01 B$1"
.op "OP","W","D9 L1"
.op "OP2","WB","D9 L1 L2"

r7_:      equ     1
r8_:      equ     2
rA_:      equ     4
rB_:      equ     8
rC_:      equ     16
rD_:      equ     32
rF_:      equ     64
