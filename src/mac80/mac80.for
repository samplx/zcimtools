C*********************************************************************  10001000
C                                                                       10001050
C                INTEL 8080 MACRO ASSEMBLER                             10001100
C                          MAC80                                        10001150
C                       VERSION 3.0                                     10001200
C                        NOV  1978                                      10001250
C                                                                       10001300
C                COPYRIGHT (C) 1974                                     10001350
C                INTEL CORPORATION                                      10001400
C                3065 BOWERS AVENUE                                     10001450
C                SANTA CLARA, CALIFORNIA 95051                          10001500
C                                                                       10001550
C*********************************************************************  10001600
C                                                                       10001650
C        ABSTRACT:                                                      10001700
C                                                                       10001750
C        THIS PROGRAM PERFORMS ASSEMBLY OF  SOURCE  PROGRAMS  FOR       10001800
C        THE  INTEL  8080  MICROCOMPUTER.   IN ADDITION TO THE 78       10001850
C        BASIC MACHINE INSTRUCTIONS, THIS ASSEMBLER IMPLEMENTS 12       10001900
C        PSEUDO  INSTRUCTIONS TO SIMPLIFY ASSEMBLY AND EXTEND THE       10001950
C        POWER OF THE ASSEMBLER.  THIS ASSEMBLER ALLOWS  THE  USE       10002000
C        OF  EXPRESSIONS  OF  ARBITRARY  COMPLEXITY  WHEREVER  AN       10002050
C        EXPRESSION FIELD OCCURS IN  AN  INSTRUCTION,  HENCE  THE       10002100
C        INSTRUCTION                                                    10002150
C                                                                       10002200
C        MVI (3*4/2 OR 43 + 6) AND 7, LABEL*36                          10002250
C                                                                       10002300
C        IS LEGAL, IF NOT NECESSARILY MEANINGFUL.                       10002350
C                                                                       10002400
C        THE MACRO ...  ENDM CONSTRUCTS ALLOW THE USER TO  CREATE       10002450
C        HIS OWN PSEUDO INSTRUCTIONS, USUALLY A SEQUENCE OF BASIC       10002500
C        CPU INSTRUCTIONS, TO PERFORM OFTEN REPEATED SEQUENCES IN       10002550
C        A CONCISE AND EASILY UNDERSTOOD FORM.  THE IF ...  ENDIF       10002600
C        CONSTRUCTS  ALLOW  THE  USER  TO  TAILOR  A   PARTICULAR       10002650
C        ASSEMBLY TO VARIOUS OPTIONS, SO THAT VARIOUS VERSIONS OF       10002700
C        A PROGRAMMING SYSTEM MAY BE MAINTAINED  AS  ONE  PROGRAM       10002750
C        WITH ASSEMBLY TIME OPTIONS.                                    10002800
C                                                                       10002850
C        ENVIRONMENT:                                                   10002900
C                                                                       10002950
C        THIS PROGRAM REQUIRES A HOST PROCESSOR WITH A WORD  SIZE       10003000
C        OF   32  BITS  OR  GREATER,  AN  ANSI  STANDARD  FORTRAN       10003050
C        COMPILER, AND A MINIMUM OF 2 SEQUENTIAL INPUT FILES  AND       10003100
C        4   SEQUENTIAL  OUTPUT  FILES.   THIS  PROGRAM  NORMALLY       10003150
C        REQUIRES ABOUT 11K WORDS OF PROCESSOR MEMORY FOR PROGRAM       10003200
C        AND DATA.                                                      10003250
C                                                                       10003300
C        NOTES TO THE INSTALLER:                                        10003350
C                                                                       10003400
C        THIS PROGRAM IS  WRITTEN  WITH  EVERY  ATTEMPT  MADE  TO       10003450
C        INSURE   TRANSPORTABILITY   BETWEEN   DIFFERENT  FORTRAN       10003500
C        ENVIRONMENTS.  WHEREVER  POSSIBLE,  ONLY  THOSE  FORTRAN       10003550
C        CONSTRUCTS  THAT  EXHIBITED NO AMBIGUITY WERE USED, EVEN       10003600
C        WHEN EXECUTION SPEED HAD TO BE SACRIFICED.   THE  ENTIRE       10003650
C        PROGRAM  HAS BEEN VERIFIED BY A FORTRAN VERIFIER PROGRAM       10003700
C        TO LOCATE AND EXPUNGE ANY CONSTRUCTS THAT ARE CONSIDERED       10003750
C        'EXTENSIONS' OF THE ASA FORTRAN STANDARD, X3.9-1966.           10003800
C                                                                       10003850
C        THERE ARE CERTAIN OPERATIONS WHICH ARE  CLOSELY  RELATED       10003900
C        TO  THE  I/O  SYSTEM  AND THE HOST MACHINE WORD SIZE FOR       10003950
C        WHICH CERTAIN ASSUMPTIONS HAD TO BE MADE.  THESE ARE  AS       10004000
C        FOLLOWS:                                                       10004050
C                                                                       10004100
C        1) A MINIMUM WORD SIZE OF 32 BITS IS REQUIRED.                 10004150
C                                                                       10004200
C        2) IT IS ASSUMED  THAT  A  CHARACTER  READ  IN  FROM  AN       10004250
C        EXTERNAL  FILE  VIA A FORTRAN 'A1' FORMAT STATEMENT, HAS       10004300
C        THE SAME INTERNAL REPRESENTATION AS A CHARACTER DECLARED       10004350
C        IN A '1H' CONSTRUCT IN A DATA STATEMENT.                       10004400
C                                                                       10004450
C        3) IT IS ASSUMED THAT THE  TARGET  FORTRAN  INSTALLATION       10004500
C        HAS  SEVERAL  DEFAULT  LOGICAL  UNITS  THAT MAY BE READ,       10004550
C        WRITTEN, AND REWOUND WITHOUT RECOURSE TO EXPLICIT  'OPEN       10004600
C        FILE'  OR  'CLOSE  FILE' STATEMENTS, SINCE THESE ARE NOT       10004650
C        COVERED IN THE FORTRAN STANDARD.  IN THE  IMPLEMENTATION       10004700
C        OF THIS PROGRAM DISTRIBUTED, THESE DEFAULT FILES ARE:          10004750
C                                                                       10004800
C        INPUT                                                          10004850
C                                                                       10004900
C        LOGICAL UNIT 5 = INTERNAL CHANNEL 1 (TERMINAL)                 10004950
C        LOGICAL UNIT 20 = INTERNAL CHANNEL 2 (SOURCE INPUT)            10005000
C        OUTPUT                                                         10005050
C                                                                       10005100
C        LOGICAL UNIT 5 = INTERNAL CHANNEL 1 (TERMINAL)                 10005150
C        LOGICAL UNIT 21 = INTERNAL CHANNEL 2 (OBJECT CODE)             10005200
C        LOGICAL UNIT 22 = INTERNAL CHANNEL 3 (LIST)                    10005250
C        LOGICAL UNIT 23 = INTERNAL CHANNEL 4 (DEBUG USE ONLY)          10005300
C                                                                       10005350
C        THESE INTERNAL CHANNEL NUMBERS  MAY  BE  MAPPED  TO  ANY       10005400
C        DESIRED  LOGICAL  UNITS AVAILABLE BY CHANGING THE VALUES       10005450
C        OF THE VARIABLES IN THE COMMON BLOCK  'IODEV'  THAT  ARE       10005500
C        SET  IN  THE  BLOCK DATA SUBPROGRAM.  THESE ARE THE ONLY       10005550
C        MODIFICATIONS THAT SHOULD HAVE  TO  BE  MADE  TO  EFFECT       10005600
C        INSTALLATION ON A GIVEN SYSTEM.                                10005650
C                                                                       10005700
C        A LIST OF CHANNEL USAGE AND REQUIRED ATTRIBUTES FOLLOWS:       10005750
C                                                                       10005800
C        INPUT, INPUT CHANNEL 2                                         10005850
C                                                                       10005900
C        THIS IS THE NOMINAL  SOURCE  INPUT  FILE.   IT  IS  READ       10005950
C        ACCORDING TO A FORTRAN '120A1' FORMAT AND, SINCE THIS IS       10006000
C        A TWO PASS ASSEMBLER, IT MUST BE REWINDABLE.                   10006050
C                                                                       10006100
C        LIST, OUTPUT CHANNEL 3                                         10006150
C                                                                       10006200
C        THIS IS THE NOMINAL LIST OUTPUT  FILE.   IT  IS  WRITTEN       10006250
C        ACCORDING   TO   A  VARIABLE  'A1'  FORMAT,  UP  TO  132       10006300
C        CHARACTERS.                                                    10006350
C                                                                       10006400
C        HEX, OUTPUT CHANNEL 2                                          10006450
C                                                                       10006500
C        THIS IS THE NOMINAL HEXADECIMAL OBJECT CODE OUTPUT FILE.       10006550
C        IT IS WRITTEN ACCORDING TO A VARIABLE 'A1' FORMAT, UP TO       10006600
C        132 CHARACTERS.                                                10006650
C                                                                       10006700
C        TTYI, INPUT CHANNEL 1                                          10006750
C                                                                       10006800
C        THIS  IS  THE  NOMINAL  CONSOLE  INPUT  STREAM.   IT  IS       10006850
C        INTENDED THAT RUNTIME OPTIONS '$ COMMANDS' BE INPUT FROM       10006900
C        THIS DEVICE AND INPUT DIRECTED TO 'INPUT'  WHEN  OPTIONS       10006950
C        HAVE BEEN ENTERED.                                             10007000
C                                                                       10007050
C        TTYO, OUTPUT CHANNEL 1                                         10007100
C                                                                       10007150
C        THIS IS THE NOMINAL  CONSOLE  OUTPUT  STREAM,  USED  FOR       10007200
C        ECHOING INPUT FROM TTYI.                                       10007250
C                                                                       10007300
C        ERLOG, OUTPUT CHANNEL 4                                        10007350
C                                                                       10007400
C        OPTIONAL ERROR DIAGNOSTIC FILE,  TO  BE  USED  ONLY  FOR       10007450
C        DEBUGGING THE ASSEMBLER.                                       10007500
C                                                                       10007550
C        MACHINE DEPENDENT EXECUTION TIME REDUCTION PROCEDURES          10007600
C                                                                       10007650
C        THERE ARE SEVERAL LOCATIONS WITHIN  THIS  PROGRAM  WHICH       10007700
C        MAY BE SPEEDED GREATLY BY SUBSTITUTING MACHINE DEPENDENT       10007750
C        CODE  FOR  THE  PORTABLE  (ALBEIT  SLOW)  CODE  THAT  IS       10007800
C        DISTRIBUTED IN THIS PROGRAM.                                   10007850
C                                                                       10007900
C        SOME POSSIBLE AREAS ARE:                                       10007950
C                                                                       10008000
C        THE ROUTINES ANDF,NOTF,ORF, AND XORF PERFORM  FULL  WORD       10008050
C        (30  BITS)  LOGICAL  OPERATIONS.   IF  YOUR  SYSTEM  HAS       10008100
C        LIBRARY  ROUTINES  WHICH  PERFORM  THE  SAME   FUNCTION,       10008150
C        REPLACE THE ONES DISTRIBUTED.                                  10008200
C                                                                       10008250
C        THE INTEGER FUNCTION RIGHT RETURNS THE N RIGHTMOST  BITS       10008300
C        OF  THE FIRST ARGUMENT, IT COULD BE REPLACED BY AN 'AND'       10008350
C        OPERATION.                                                     10008400
C                                                                       10008450
C        SHR AND SHL  PERFORM  LOGICAL  (NO  SIGN  EXTEND)  SHIFT       10008500
C        OPERATIONS  AND  MAY  ALSO  BE  REPLACED  BY APPROPRIATE       10008550
C        SYSTEM ROUTINES.                                               10008600
C                                                                       10008650
C        IN THE ROUTINE 'GNC', THE DO LOOP 230 IS USED TO CONVERT       10008700
C        THE EXTERNAL CHARACTER SET TO AN INTERNAL FORM.  IT DOES       10008750
C        THIS BY A TEDIOUS (BUT PORTABLE) TABLE LOOKUP.   IF  THE       10008800
C        INSTALLER  KNOWS  THE  INTERNAL  REPRESENTATION  OF  THE       10008850
C        CHARACTER SET IN A MACHINE WORD,  HE  CAN  SUBSTITUTE  A       10008900
C        SHIFT,  MASK,  AND  INDEXING OPERATION FOR THIS LOOP AND       10008950
C        GREATLY REDUCE EXECUTION TIME.                                 10009000
C                                                                       10009050
C        A WORD OF CAUTION:                                             10009100
C                                                                       10009150
C        THE SEQUENCE NUMBERS ON THIS FILE (COL  73-80)  WILL  BE       10009200
C        USED  BY  ALL  FORTHCOMING  PATCHES TO THIS PROGRAM.  IT       10009250
C        WOULD BE WISE TO RETAIN THE  SEQUENCE  NUMBERS  AND  NOT       10009300
C        RESEQUENCE THIS FILE.                                          10009350
C                                                                       10009400
C        SUBPROGRAM DICTIONARY:                                         10009450
C                                                                       10009500
C        THE FOLLOWING IS A LIST OF ALL ASSEMBLER SUBROUTINES AND       10009550
C        FUNCTIONS   WITH   THEIR  RESPECTIVE  STARTING  SEQUENCE       10009600
C        NUMBERS.                                                       10009650
C                                                                       10009700
C       LIST OF FUNCTIONS AND SUBROUTINES                               10010000
C       WITH STARTING SEQUENCE NUMBERS                                  10011000
C                                                                       10012000
C  11340000        INTEGER FUNCTION ANDF(II,JJ)                         10013000
C  11365000        SUBROUTINE APPEND(STRING,LENGTH)                     10014000
C  11391000        SUBROUTINE BACKUP                                    10015000
C  11439000        SUBROUTINE CONID(I1,JK)                              10017000
C  11454000        INTEGER FUNCTION CONNUM(CHAR)                        10018000
C  11516000        SUBROUTINE DDUMP                                     10019000
C  11561000        SUBROUTINE DUMPIT                                    10020000
C  11614000        SUBROUTINE ENTER(IDN,VALUE,TYPE,LEVEL,ADDR)          10021000
C  11682000        SUBROUTINE ENTERB                                    10022000
C  11723000        SUBROUTINE ERROR(ERRTYP)                             10023000
C  11763000        INTEGER FUNCTION EVAL(VSTACK,TSTACK,LSTACK,STATE)    10024000
C  11856000        SUBROUTINE EXITB                                     10025000
C  11898020        SUBROUTINE FILTER                                    10025500
C  11906000        INTEGER FUNCTION GET(ADDR)                           10026000
C  11932000        INTEGER FUNCTION GNC(IIIII)                          10027000
C  12170170        SUBROUTINE HASHB                                     10027100
C  12178000        SUBROUTINE ICON(I1,JK,IBUF)                          10028000
C  12213000        INTEGER FUNCTION IDENT(IH,CHAR,LEN)                  10029000
C  12252000        SUBROUTINE INUM(VALUE,BASE,LENGTH,IBUF,I1)           10030000
C  12291000        SUBROUTINE LOOKUP(IDN,ADDR,TYPE,LEVEL)               10031000
C  12356000        SUBROUTINE MACDMP(MACNAM,ADDR)                       10032000
C  12449000        INTEGER FUNCTION ORF(II,JJ)                          10033000
C  12474000        SUBROUTINE OUTPUT(CHAN)                              10034000
C  12552000        INTEGER FUNCTION NOTF(II)                            10035000
C  12571000        SUBROUTINE NUMBER(VALUE,BASE,LENGTH)                 10036000
C  12589000        LOGICAL FUNCTION OPSRCH(IH,IDN,OPVAL,OPTYPE)         10037000
C  12629000        SUBROUTINE P1DUMP                                    10038000
C  12722000        SUBROUTINE P2DUMP(PAGE,TITLE,TLEN)                   10039000
C  12818000        SUBROUTINE PAD(CHAR,LEN)                             10040000
C  12834000        SUBROUTINE PARVAL(VSTACK,TSTACK,LSTACK)              10041000
C  12940000        INTEGER FUNCTION POP(STACK)                          10042000
C  12975000        SUBROUTINE PUSH(STACK,VALUE,STKSIZ)                  10043000
C  13014000        SUBROUTINE PUT(VALUE,ADDR)                           10044000
C  13043000        SUBROUTINE RANGE(VALUE)                              10045000
C  13073000        INTEGER FUNCTION RIGHT(I,J)                          10046000
C  13092000        INTEGER FUNCTION SHL(VALUE,COUNT)                    10047000
C  13105000        INTEGER FUNCTION SHR(VALUE,COUNT)                    10048000
C  13118000        INTEGER FUNCTION SP(STACK)                           10049000
C  13132000        SUBROUTINE STKDMP(STKN,STACK)                        10050000
C  13169080        SUBROUTINE SYBLD(LOC,IVAL,ITYPE,IM,IR)               10050010
C  13169310        SUBROUTINE SYBRK(LOC,IVAL,ITYPE,IM,IR)               10050020
C  13177000        SUBROUTINE SYMDMP                                    10051000
C  13253000        SUBROUTINE TFORM(PAGE,TITLE,TLEN)                    10052000
C  13313000        INTEGER FUNCTION TOS(STACK)                          10053000
C  13330000        SUBROUTINE VNUM(II)                                  10054000
C  13349000        INTEGER FUNCTION XORF(II,JJ)                         10055000
C                                                                       10056000
C       BEGIN NONVARIANT (ASSEMBLER INDEPENDENT) DECLARATIONS           10057000
C                                                                       10058000
      EXTERNAL RANGE
       INTEGER VERS                                                     10059000
       COMMON /VER/ VERS                                                10060000
C                                                                       10061000
       INTEGER VSTKN(4),OSTKN(4),TSTKN(4),GSTKN(4),ASTKN(4)             10062000
       INTEGER BOTSTK(4),PTRSTK(4),PRMSTK(4),XPNSTK(4),LSTKN(4)         10063000
       COMMON /DEBUG/ VSTKN,OSTKN,TSTKN,GSTKN,ASTKN,                    10064000
     1 BOTSTK,PTRSTK,PRMSTK,XPNSTK,LSTKN                                10065000
C                                                                       10066000
       INTEGER IBUF(120),IBP,IBE                                        10067000
       COMMON /SOURCE/ IBUF,IBP,IBE                                     10068000
C                                                                       10069000
       INTEGER IFSUP                                                    10070000
       COMMON /IFS/ IFSUP                                               10071000
C                                                                       10072000
       INTEGER OBUF,OBP                                                 10073000
       COMMON /OUTBUF/ OBUF(132),OBP                                    10074000
C                                                                       10075000
       INTEGER ERCODE                                                   10076000
       COMMON /ERRCD/ ERCODE                                            10077000
C                                                                       10078000
       INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                   10079000
       INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                         10080000
       INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                            10081000
       COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,                10082000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   10083000
C                                                                       10084000
       INTEGER IPASS,BLKLVL                                             10085000
       COMMON /PASS/ IPASS,BLKLVL                                       10086000
C                                                                       10087000
       COMMON /MAX/ MAXMEM                                              10088000
C                                                                       10089000
       INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                           10090000
       COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                    10091000
C                                                                       10092000
       INTEGER CONTRL(64)                                               10093000
       COMMON /CNTRL/ CONTRL                                            10094000
C                                                                       10095000
        INTEGER LWR(64),UPR(64)                                         10095020
        COMMON /BNDS/ LWR,UPR                                           10095040
C                                                                       10095060
       INTEGER ASMB(31),ASMBL,ERMSG(10),ERML,ERTOT(17),ERTL,PAGES(6)    10096000
       INTEGER BEGIN(13)                                                10096500
       COMMON /MSG/ ASMB,ASMBL,ERML,ERMSG,ERTOT,ERTL,PAGES,BEGIN        10097000
C                                                                       10098000
       INTEGER GNC,POP,SHL,SHR,EVAL,CONNUM,IDENT                        10099000
       INTEGER ANDF,ORF,XORF,NOTF,RIGHT,TOS,SP,GET                      10100000
       INTEGER XFRADR,CHKSUM,DEPTH                                      10100100
C                                                                       10101000
       LOGICAL MACDEF,ITSNIF,MACCAL,PRNFLG,LSTCTL,MACROD,ENDIFS         10102000
       COMMON /MACROS/ MACDEF                                           10103000
C                                                                       10104000
       INTEGER                                                          10105000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          10106000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     10107000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        10108000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     10109000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        10110000
C                                                                       10111000
       COMMON /CSET/                                                    10112000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          10113000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     10114000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        10115000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     10116000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        10117000
C                                                                       10118000
       INTEGER IOTRAN(64),ASCII(64)                                     10119000
       COMMON /PORTA/ IOTRAN,ASCII                                      10120000
C                                                                       10121000
       LOGICAL BFST                                                     10121050
       INTEGER BINBUF(16),BINRAD,BINRCL,BINORG                          10121100
       COMMON /BBUF/ BINBUF,BINRAD,BINRCL,BINORG,BFST                   10121200
C                                                                       10121300
       INTEGER TOKEN,LC,CHAR,PRINTN,PAGE,DLEVEL                         10122000
       INTEGER IDN,ADDR,TYPE,LEVEL,VALUE,LEN,PTR                        10123000
       INTEGER MACNAM,STATE,MACBOD,MACSUB,PRMNO                         10124000
C                                                                       10125000
       LOGICAL ASSEMB,SRCPRN,PRINTV,ENDF,OPSRCH                         10126000
C                                                                       10127000
       INTEGER VSTACK(69),OSTACK(69),TSTACK(69),ASTACK(10),GSTACK(6)    10128000
       INTEGER LSTACK(10)                                               10129000
       INTEGER VSTKL,OSTKL,TSTKL,ASTKL,GSTKL,LSTKL                      10130000
       INTEGER PRODN(64)                                                10131000
       INTEGER TITLE(65),TLEN                                           10131050
CC                                                                      **TEST**
C       COMMON /VST/ VSTACK,VSTKL                                       **TEST**
C                                                                       10131100
       COMMON /PREC/ INPPRC(64),NARGS(64),NONVAR                        10131210
C                                                                       10131220
C       BEGIN VARIANT (ASSEMBLER DEPENDENT) DECLARATIONS                10131250
C                                                                       10131300
       INTEGER OPTAB(194),OPTL                                          10131450
       COMMON /OPCODE/ OPTAB,OPTL                                       10131500
C                                                                       10131550
       EQUIVALENCE (GSTACK(1),GSTKL),(GSTACK(2),I1)                     10132000
       EQUIVALENCE (GSTACK(3),I2),(GSTACK(4),STATE)                     10133000
       EQUIVALENCE (GSTACK(5),VALUE),(GSTACK(6),TOKEN)                  10134000
C                                                                       10135000
       DATA PRODN(1)/00/,PRODN(2)/00/,PRODN(3)/00/                      10136000
       DATA PRODN(4)/00/,PRODN(5)/00/,PRODN(6)/00/                      10137000
       DATA PRODN(7)/00/,PRODN(8)/00/,PRODN(9)/01/                      10138000
       DATA PRODN(10)/02/,PRODN(11)/03/,PRODN(12)/04/                   10139000
       DATA PRODN(13)/05/,PRODN(14)/06/,PRODN(15)/00/                   10140000
       DATA PRODN(16)/08/,PRODN(17)/00/,PRODN(18)/00/                   10141000
       DATA PRODN(19)/00/,PRODN(20)/00/,PRODN(21)/00/                   10142000
       DATA PRODN(22)/00/,PRODN(23)/00/,PRODN(24)/00/                   10143000
       DATA PRODN(25)/00/,PRODN(26)/00/,PRODN(27)/19/                   10144000
       DATA PRODN(28)/00/,PRODN(29)/00/,PRODN(30)/00/                   10145000
       DATA PRODN(31)/00/,PRODN(32)/00/,PRODN(33)/00/                   10146000
       DATA PRODN(34)/00/,PRODN(35)/00/,PRODN(36)/00/                   10147000
       DATA PRODN(37)/00/,PRODN(38)/00/,PRODN(39)/00/                   10148000
       DATA PRODN(40)/00/,PRODN(41)/00/,PRODN(42)/00/                   10149000
       DATA PRODN(43)/00/,PRODN(44)/00/,PRODN(45)/00/                   10150000
       DATA PRODN(46)/00/,PRODN(47)/00/,PRODN(48)/00/                   10151000
       DATA PRODN(49)/00/,PRODN(50)/00/,PRODN(51)/00/                   10152000
       DATA PRODN(52)/00/,PRODN(53)/00/,PRODN(54)/00/                   10153000
       DATA PRODN(55)/00/,PRODN(56)/00/,PRODN(57)/00/                   10154000
       DATA PRODN(58)/00/,PRODN(59)/00/,PRODN(60)/00/                   10155000
       DATA PRODN(61)/07/,PRODN(62)/00/,PRODN(63)/20/                   10156000
       DATA PRODN(64)/00/                                               10157000
C                                                                       10157100
C       ASSEMBLER OPERATOR PRECEDENCE TABLE                             10158000
C                                                                       10159000
C       TOKEN   INPUT   STACK   SYMBOL                                  10160000
C                                                                       10161000
C       01      11      03      (                                       10162000
C       02      03      03      )                                       10163000
C       03      10      10      *                                       10164000
C       04      09      09      +                                       10165000
C       05      03      03      ,                                       10166000
C       06      09      09      -                                       10167000
C       07      01      01      <END OF LINE>                           10168000
C       08      10      10      /                                       10169000
C       09      09      09      <UNARY +>                               10170000
C       10      08      08      NOT                                     10171000
C       11      09      09      <UNARY ->                               10172000
C       12      07      07      AND                                     10173000
C       13      06      06      OR                                      10174000
C       14      06      06      XOR                                     10175000
C       15      10      10      MOD                                     10176000
C       16      10      10      SHL                                     10177000
C       17      10      10      SHR                                     10178000
C       18      01      01      <START OF LINE>                         10179000
C       19      00      00      :                                       10180000
C       20      04      04      <MACRO EXPANSION END>                   10181000
C       21      04      04      DB                                      10182000
C       22      04      04      DS                                      10183000
C       23      04      04      DW                                      10184000
C       24      04      04      END                                     10185000
C       25      04      04      EQU                                     10186000
C       26      04      04      IF                                      10187000
C       27      04      04      ENDIF                                   10188000
C       28      04      04      ORG                                     10189000
C       29      04      04      SET                                     10190000
C       30      04      04      TITLE                                   10191000
C       31      00      00      MACRO                                   10192000
C       32      04      04      <FORMAL MACRO PARAMETERS>               10193000
C       33      04      04      ENDM                                    10194000
C       34      04      04      <MACRO CALL>                            10195000
C       35      04      04      <ACTUAL MACRO PARAMETERS>               10196000
C       ...                                                             10197000
C       55      04      04      <LOAD INDEX HEAD>                       10198000
C       56      04      04      <INDEX REFERENCE INSTRUCTION>           10199000
C       57      04      04      <INDEXED INSTRUCTION>                   10200000
C       58      04      04      <REGISTER INSTRUCTION>                  10201000
C       59      04      04      <IMMEDIATE INSTRUCTION>                 10202000
C       60      04      04      <MOVE IMMEDIATE HEAD>                   10203000
C       61      04      04      <REGISTER REFERENCE INSTRUCTION>        10204000
C       62      04      04      <MOVE REGISTER HEAD>                    10205000
C       63      04      04      <BRANCH INSTRUCTION>                    10206000
C       64      04      04      <ZERO OPERAND INSTRUCTION>              10207000
C                                                                       10208000
C       BEGIN NONVARIANT CODE                                           10209000
C                                                                       10210000
C     THE FOLLOWING SCANNER COMMANDS ARE DEFINED:                       10211000
C                                                                       10211100
C     ERROR COUNT                                         (01)          10212000
C                                                                       10212100
C     PASS 1 LISTING    (1=PRINT)                         (N1)          10212100
C     PRINT IF-SKIPPED LINES   (0=PRINT)                  (N2)          10212200
C     PRINT MACRO EXPANSION    (0=PRINT)                  (N3)          10212300
C     PRINT LIST CONTROL STATEMENTS  (0=PRINT)            (N4)          10212310
C     GENERATE OBJECT CODE IF ERROR  (1=GENERATE)         (N5)          10212320
C     INHIBIT OBJECT CODE GENERATION (1=INHIBIT)          (N6)          10212330
C     NUMBER OF LINES PER PAGE                            (N7)          10212340
C     BNPF TOGGLE (1=HEX, 0=BNPF)                         (CB)          10212500
C     COUNT = I          BEGIN LINE COUNT AT I            (CC)          10213000
C     DEBUG                                               (CD)          10214000
C     ERROR LOG FILE                                      (CE)          10215000
C     FORM FEED PRINT DEVICE                              (CF)          10216000
C     INPUT = I                                           (CI)          10217000
C     LEFTMARGIN = I                                      (CL)          10218000
C     MACRO DEBUG DUMP                                    (CM)          10219000
C     OUTPUT = I                                          (CO)          10220000
C     PRINT (T OR F)                                      (CP)          10221000
C     QUICK DUMP OF SYMBOL TABLE (DEBUG MODE)             (CQ)          10222000
C     RIGHTMARGIN = I                                     (CR)          10223000
C     SYMBOLS                                             (CS)          10224000
C     TEST (DUMP SYMBOL TABLE TO HEX FILE FOR INTERP/80)  (CT)          10225000
C     WIDTH = I                                           (CW)          10226000
C                                                                       10227000
C       EXECUTABLE CODE                                                 10228000
C                                                                       10229000
       ASMB(28) = VERS/10 + N0                                          10230000
       ASMB(30) = MOD(VERS,10) + N0                                     10231000
C                                                                       10232000
C       SET CONTRL ARRAY                                                10233000
C                                                                       10234000
       DO 100 I = 1,64                                                  10235000
         CONTRL(I) = -1                                                 10236000
100    CONTINUE                                                         10237000
C                                                                       10238000
       CONTRL(N1) = 0                                                   10239000
       CONTRL(N2) = 0                                                   10239300
       CONTRL(N3) = 0                                                   10239400
       CONTRL(N4) = 0                                                   10239410
       CONTRL(N5) = 0                                                   10239420
       CONTRL(N6) = 0                                                   10239430
       CONTRL(N7) = 51                                                  10239440
       CONTRL(CB) = 1                                                   10239500
       CONTRL(CC) = 0                                                   10240000
       CONTRL(CF) = 1                                                   10243000
       CONTRL(CI) = 1                                                   10244000
       CONTRL(CL) = 1                                                   10245000
       CONTRL(CM) = 0                                                   10246000
       CONTRL(CO) = 1                                                   10247000
       CONTRL(CP) = 1                                                   10248000
       CONTRL(CR) = 80                                                  10250000
       CONTRL(CS) = 1                                                   10251000
       CONTRL(CT) = 0                                                   10252000
       CONTRL(CW) = 120                                                 10253000
C                                                                       10254000
       CALL HASHB                                                       10254100
       BFST = .FALSE.                                                   10254150
       TLEN = 0                                                         10254200
       OBP = 0                                                          10255000
       OBUF(1) = BLK                                                    10256000
       TOKEN = 18                                                       10257000
       ASSEMB = .TRUE.                                                  10258000
       SRCPRN = .FALSE.                                                 10259000
       BINRCL = 0                                                       10260000
       BINORG = 0                                                       10260100
       VSTKL = 69                                                       10261000
       OSTKL = 69                                                       10262000
       TSTKL = 69                                                       10263000
       ASTKL = 10                                                       10264000
       GSTKL = 6                                                        10265000
       LSTKL = 10                                                       10266000
       IBP = 2                                                          10267000
       IBE = 1                                                          10268000
       IPASS = 0                                                        10269000
       PAGE = 0                                                         10270000
       XFRADR = 0                                                       10270100
       CALL APPEND(ASMB,ASMBL)                                          10271000
       CALL OUTPUT(1)                                                   10272000
       CALL OUTPUT(1)                                                   10273000
C                                                                       10274000
C       START NEXT PASS                                                 10275000
C                                                                       10276000
110    CONTINUE                                                         10277000
       IFSUP = 65535                                                    10278000
       BLKLVL = 0                                                       10279000
       DLEVEL = 0                                                       10280000
       IPASS = IPASS + 1                                                10281000
       CALL ENTERB                                                      10282000
       MACDEF = .FALSE.                                                 10283000
       CONTRL(1) = 0                                                    10284000
       ASTACK(1) = 1                                                    10285000
       LC = 0                                                           10286000
       PRINTN = 0                                                       10287000
       ENDF = .FALSE.                                                   10288000
C                                                                       10289000
C       START NEXT LINE                                                 10290000
C                                                                       10291000
120    CONTINUE                                                         10292000
       PRINTV = .FALSE.                                                 10293000
       ITSNIF = .FALSE.                                                 10293100
       MACCAL = .FALSE.                                                 10293200
       PRNFLG = .TRUE.                                                  10293300
       LSTCTL = .FALSE.                                                 10293400
       MACROD = .FALSE.                                                 10293500
       ENDIFS = .FALSE.                                                 10293600
       OSTACK(1) = 1                                                    10294000
       VSTACK(1) = 1                                                    10295000
       TSTACK(1) = 1                                                    10296000
       LSTACK(1) = 1                                                    10297000
       CALL PUSH(OSTACK,18,OSTKL)                                       10298000
C                                                                       10299000
C       GET NEXT TOKEN                                                  10300000
C                                                                       10301000
130    CONTINUE                                                         10302000
       CHAR = GNC(0)                                                    10303000
C                                                                       10304000
C       TEST FOR BLANK AND TAB                                          10305000
C                                                                       10306000
       IF (CHAR.EQ.BLK.OR.CHAR.EQ.TAB) GO TO 130                        10307000
C                                                                       10308000
C       TEST FOR NUMERIC                                                10309000
C                                                                       10310000
       IF (CHAR.GE.N0.AND.CHAR.LE.N9) GO TO 190                         10311000
C                                                                       10312000
C       TEST FOR ALPHABETIC                                             10313000
C                                                                       10314000
       IF (CHAR.GE.QUES.AND.CHAR.LE.CZ) GO TO 200                       10315000
C                                                                       10316000
C       TEST FOR APOSTROPHE                                             10317000
C                                                                       10318000
       IF (CHAR.EQ.TIC) GO TO 240                                       10319000
C                                                                       10320000
C       TEST FOR DOLLAR SIGN                                            10321000
C                                                                       10322000
       IF (CHAR.EQ.DOLLAR) GO TO 310                                    10323000
C                                                                       10324000
C       TEST FOR SEMICOLON                                              10325000
C                                                                       10326000
       IF (CHAR.EQ.SEMI) GO TO 180                                      10327000
C                                                                       10328000
C       TEST FOR OPERATOR                                               10329000
C                                                                       10330000
140    CONTINUE                                                         10331000
       CHAR = PRODN(CHAR+1)                                             10332000
       IF (CHAR.EQ.0) GO TO 170                                         10333000
C                                                                       10334000
C       CHECK FOR <UNARY +> AND <UNARY ->                               10335000
C                                                                       10336000
       IF (CHAR.NE.4.AND.CHAR.NE.6) GO TO 160                           10337000
         IF (TOKEN.EQ.0.OR.TOKEN.EQ.2) GO TO 150                        10338000
           CHAR = CHAR + 5                                              10339000
150      CONTINUE                                                       10340000
160    CONTINUE                                                         10341000
       TOKEN = CHAR                                                     10342000
       GO TO 320                                                        10343000
C                                                                       10344000
C       INPUT ERROR                                                     10345000
C                                                                       10346000
170    CONTINUE                                                         10347000
       CALL ERROR(CI)                                                   10348000
       GO TO 130                                                        10349000
C                                                                       10350000
C       SKIP COMMENT                                                    10351000
C                                                                       10352000
180    CONTINUE                                                         10353000
       IF (.NOT.MACDEF) IBP = IBE                                       10353100
       CHAR = GNC(0)                                                    10354000
       IF (CHAR.EQ.EOL) GO TO 140                                       10355000
       GO TO 180                                                        10356000
C                                                                       10357000
C**********                                                             10358000
C                                                                       10359000
C       CONVERT NUMERIC STRING                                          10360000
C                                                                       10361000
C**********                                                             10362000
C                                                                       10363000
190    CONTINUE                                                         10364000
       VALUE = CONNUM(CHAR)                                             10365000
       CALL PUSH(VSTACK,VALUE,VSTKL)                                    10366000
       CALL PUSH(TSTACK,80,TSTKL)                                       10367000
       IF (TOKEN.EQ.0) CALL ERROR(CE)                                   10368000
       TOKEN = 0                                                        10369000
       GO TO 130                                                        10370000
C                                                                       10371000
C**********                                                             10372000
C                                                                       10373000
C       COLLECT IDENTIFIER AND LOOKUP IN SYMBOL TABLE                   10374000
C                                                                       10375000
C**********                                                             10376000
C                                                                       10377000
200    CONTINUE                                                         10378000
       LOOKL = MACPTR(BLKLVL+1) - 2                                     10378100
       IDN = IDENT(IH,CHAR,LEN)                                         10379000
C                                                                       10380000
C       LOOKUP IDENTIFIER IN OPCODE TABLE                               10381000
C                                                                       10382000
       IF (.NOT.OPSRCH(IH,IDN,VALUE,TYPE)) GO TO 210                    10383000
       TOKEN = TYPE                                                     10384000
       IF (TOKEN.LE.NONVAR) GO TO 320                                   10385000
       I2 = TOS(OSTACK)                                                 10386000
       IF (I2.NE.1.AND.I2.NE.18) CALL ERROR(CQ)                         10387000
       CALL PUSH(VSTACK,VALUE,VSTKL)                                    10388000
       CALL PUSH(TSTACK,80,TSTKL)                                       10389000
       CALL PUSH(LSTACK,0,LSTKL)                                        10390000
       GO TO 320                                                        10391000
C                                                                       10392000
C       LOOK UP USER SYMBOLS                                            10393000
C                                                                       10394000
210    CONTINUE                                                         10395000
C                                                                       10396000
C       0 - UNDEFINED                                                   10397000
C       1 - SET                                                         10398000
C       2 - ABSOLUTE                                                    10399000
C       3 - FORMAL PARAMETER                                            10400000
C       4 - MACRO NAME                                                  10401000
C       80 - ABSOLUTE VALUE                                             10402000
C       81 - MACHINE INSTRUCTION                                        10403000
C       82 - STRING                                                     10404000
C                                                                       10405000
       CALL LOOKUP(IDN,ADDR,TYPE,LEVEL)                                 10406000
        IF (TYPE.NE.4) GO TO 215                                        10406100
           IF (SP(VSTACK).NE.1) CALL ERROR(CF)                          10406200
           VSTACK(1) = 1                                                10406300
           TSTACK(1) = 1                                                10406400
215     CONTINUE                                                        10406500
       IF (TOKEN.EQ.0) CALL ERROR(CE)                                   10407000
       TOKEN = 0                                                        10408000
       CALL PUSH(VSTACK,LEVEL,VSTKL)                                    10409000
       CALL PUSH(VSTACK,ADDR,VSTKL)                                     10410000
       CALL PUSH(VSTACK,IDN,VSTKL)                                      10411000
       CALL PUSH(TSTACK,TYPE,TSTKL)                                     10412000
C                                                                       10413000
C       CHECK FOR FORMAL PARAMETER                                      10414000
C                                                                       10415000
       IF (TYPE.NE.3.OR.IPASS.EQ.2) GO TO 220                           10416000
         MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1)-LEN                        10417000
         CALL SYBRK(ADDR+1,VALUE,ITYPE,IM,IR)                           10418000
         CALL PUT(FORMAL,MACPTR(BLKLVL+1))                              10419000
         MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1)+1                          10420000
         CALL PUT(VALUE,MACPTR(BLKLVL+1))                               10421000
         MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1)+1                          10422000
         SYMAX = MACPTR(BLKLVL+1)/5 + 1                                 10423000
220    CONTINUE                                                         10424000
C                                                                       10425000
C       CHECK FOR MACRO CALL                                            10426000
C                                                                       10427000
       IF (TYPE.NE.4) GO TO 130                                         10428000
         TOKEN = 34                                                     10429000
         GO TO 320                                                      10430000
C230    CONTINUE                                                        10431000
C       GO TO 130                                                       10432000
C                                                                       10433000
C**********                                                             10434000
C                                                                       10435000
C       COLLECT STRING AND COUNT LENGTH                                 10436000
C                                                                       10437000
C**********                                                             10438000
C                                                                       10439000
240    CONTINUE                                                         10440000
       LEN = 0                                                          10441000
250    CONTINUE                                                         10442000
         CHAR = GNC(0)                                                  10443000
         IF (CHAR.EQ.EOL) GO TO 300                                     10444000
         IF (CHAR.EQ.TIC) GO TO 270                                     10445000
260      CONTINUE                                                       10446000
         CALL PUSH(VSTACK,CHAR,VSTKL)                                   10447000
         LEN = LEN + 1                                                  10448000
       GO TO 250                                                        10449000
270    CONTINUE                                                         10450000
       CHAR = GNC(0)                                                    10451000
       IF (CHAR.EQ.TIC) GO TO 260                                       10452000
280    CONTINUE                                                         10453000
       CALL BACKUP                                                      10454000
       IF (TOKEN.EQ.0) CALL ERROR(CE)                                   10455000
       TOKEN = 0                                                        10456000
       IF (LEN.EQ.0) GO TO 290                                          10457000
         CALL PUSH(VSTACK,LEN,VSTKL)                                    10458000
         CALL PUSH(TSTACK,82,VSTKL)                                     10459000
290    CONTINUE                                                         10460000
       GO TO 130                                                        10461000
300    CONTINUE                                                         10462000
       CALL ERROR(CB)                                                   10462100
       GO TO 280                                                        10463000
C                                                                       10464000
C**********                                                             10465000
C                                                                       10466000
C       $ IS THE CURRENT VALUE OF THE LOCATION COUNTER                  10467000
C                                                                       10468000
C**********                                                             10469000
C                                                                       10470000
310    CONTINUE                                                         10471000
       CALL PUSH(VSTACK,LC,VSTKL)                                       10471100
       CALL PUSH(TSTACK,80,TSTKL)                                       10472000
       IF (TOKEN.EQ.0) CALL ERROR(CE)                                   10473000
       TOKEN = 0                                                        10474000
       GO TO 130                                                        10475000
C                                                                       10476000
C       FINITE STATE PRECEDENCE MACHINE                                 10477000
C       DECIDE WHETHER TO STACK OR REDUCE                               10478000
C                                                                       10479000
320    CONTINUE                                                         10480000
       I1 = INPPRC(TOKEN)                                               10481000
       IF (TOKEN.EQ.1) I1 = 11                                          10482000
       STATE = POP(OSTACK)                                              10483000
       I2 = INPPRC(STATE)                                               10484000
       IF (I1.GT.I2) GO TO 340                                          10485000
         IF (STATE.NE.18) GO TO 330                                     10486000
           STATE = TOKEN                                                10487000
           CALL PUSH(OSTACK,18,OSTKL)                                   10488000
330      CONTINUE                                                       10489000
         GO TO 350                                                      10490000
C                                                                       10491000
C       STACK OPERATOR                                                  10492000
C                                                                       10493000
340    CONTINUE                                                         10494000
         CALL PUSH(OSTACK,STATE,OSTKL)                                  10495000
         CALL PUSH(OSTACK,TOKEN,OSTKL)                                  10496000
       GO TO 130                                                        10497000
C                                                                       10498000
C       REDUCE STACK                                                    10499000
C                                                                       10500000
350    CONTINUE                                                         10501000
       I1 = NARGS(STATE)                                                10502000
C                                                                       10503000
360    CONTINUE                                                         10519000
C                                                                       10520000
C       POP PROPER NUMBER OF ARGUMENTS FROM VSTACK,                     10521000
C       CONVERT ACCORDING TO TYPE SPECIFIED IN TSTACK,                  10522000
C       AS REQUIRED BY THIS STATE.                                      10523000
C                                                                       10524000
       GO TO (390,380,370),I1                                           10525000
C                                                                       10526000
C                                                                       10527000
C                                                                       10528000
370    CONTINUE                                                         10529000
       I2 = EVAL(VSTACK,TSTACK,LSTACK,STATE)                            10529100
380    CONTINUE                                                         10530000
       I1 = EVAL(VSTACK,TSTACK,LSTACK,STATE)                            10530100
C                                                                       10531000
390    CONTINUE                                                         10532000
C                                                                       10533000
400    CONTINUE                                                         10549000
C                                                                       10550000
C       NOTE:                                                           10551000
C               THIS BRANCH TABLE MUST BE MODIFIED                      10552000
C               TO CONFORM TO THE NUMBER OF PRODUCTIONS                 10553000
C               IN ANY NEW ASSEMBLER GENERATED                          10554000
C                                                                       10555000
       GO TO (                                                          10556000
     1 1000,2000,3000,4000,5000,                                        10557000
     1 6000,7000,8000,9000,10000,                                       10558000
     1 11000,12000,13000,14000,15000,                                   10559000
     1 16000,17000,18000,19000,20000,                                   10560000
     1 21000,22000,23000,24000,25000,                                   10561000
     1 26000,27000,28000,29000,30000,                                   10562000
     1 31000,32000,33000,34000,35000,                                   10563000
     1 36000,36000,36000,36000,36000,                                   10563100
     1 36000,36000,36000,36000,36000,                                   10563200
     1 36000,36000,36000,36000,36000,                                   10563300
     1 36000,36000,36000,36000,                                         10563400
     1 55000,56000,57000,58000,59000,                                   10564000
     1 60000,61000,62000,63000,64000),STATE                             10565000
C                                                                       10566000
C       COMPLETE STATES 3,4,6,8,9,10,11,12,13,14,15,16,17               10567000
C                                                                       10568000
500    CONTINUE                                                         10569000
       CALL PUSH(TSTACK,80,TSTKL)                                       10570000
       CALL PUSH(VSTACK,I1,VSTKL)                                       10571000
       GO TO 320                                                        10572000
C                                                                       10573000
C       STATE 1, SYMBOL = (                                             10574000
C                                                                       10575000
1000   CONTINUE                                                         10576000
       IF (TOKEN.EQ.2) GO TO 130                                        10577000
       CALL ERROR(CB)                                                   10578000
       GO TO 320                                                        10579000
C                                                                       10580000
C       STATE 2, SYMBOL = )                                             10581000
C                                                                       10582000
2000   CONTINUE                                                         10583000
       CALL ERROR(CB)                                                   10584000
       GO TO 320                                                        10585000
C                                                                       10586000
C       STATE 3, SYMBOL = *                                             10587000
C                                                                       10588000
3000   CONTINUE                                                         10589000
       I1 = I1 * I2                                                     10590000
       GO TO 500                                                        10591000
C                                                                       10592000
C       STATE 4, SYMBOL = +                                             10593000
C                                                                       10594000
4000   CONTINUE                                                         10595000
       I1 = I1 + I2                                                     10596000
       GO TO 500                                                        10597000
C                                                                       10598000
C       STATE 5, SYMBOL = ,                                             10599000
C                                                                       10600000
5000   CONTINUE                                                         10601000
       GO TO 320                                                        10602000
C                                                                       10603000
C       STATE 6, SYMBOL = -                                             10604000
C                                                                       10605000
6000   CONTINUE                                                         10606000
       I1 = I1 - I2 + 65536                                             10607000
       I1 = RIGHT(I1,16)                                                10608000
       GO TO 500                                                        10609000
C                                                                       10610000
C       STATE 7, SYMBOL = <END OF LINE>                                 10611000
C                                                                       10612000
7000   CONTINUE                                                         10613000
         IF (IPASS.EQ.1.AND.CONTRL(N1).EQ.0) GO TO 7180                 10614000
           LEN = SP(TSTACK)                                             10615000
           IF (LEN.LT.2) GO TO 7020                                     10616000
             DO 7010 I = 2,LEN                                          10617000
               IF (TSTACK(I).NE.81) CALL ERROR(CQ)                      10618000
7010         CONTINUE                                                   10619000
7020       CONTINUE                                                     10620000
           LEN = SP(VSTACK)                                             10621000
           PTR = 2                                                      10622000
           IF (LEN.LT.PTR.OR.IPASS.EQ.1.OR.IFSUP.EQ.0) GO TO 7050       10623000
             IF (BINRCL.EQ.0) BINRAD = LC                               10624000
             DO 7040 I = PTR,LEN                                        10625000
               IF (BINRCL.LT.16) GO TO 7030                             10626000
                 IF (CONTRL(N6) .EQ. 0)  CALL DUMPIT                    10627000
                 BINRCL = 0                                             10628000
                 BINRAD = LC + I - PTR                                  10629000
7030           CONTINUE                                                 10630000
               BINRCL = BINRCL + 1                                      10631000
               BINBUF(BINRCL) = VSTACK(I)                               10632000
7040         CONTINUE                                                   10633000
7050       CONTINUE                                                     10634000
           SRCPRN = .FALSE.                                             10635000
7060       CONTINUE                                                     10636000
             IF (CONTRL(CC).GE.CONTRL(N7)) CALL TFORM(PAGE,TITLE,TLEN)  10637000
             IF ( (CONTRL(N3) .NE. 0 .AND. MACXPN(BLKLVL+1) .NE. 0      10637100
     1            .AND. .NOT. MACCAL)                                   10637200
     2                         .OR.                                     10637300
     3           ((CONTRL(N2).NE.0) .AND. (IFSUP .EQ. 0) .AND.          10637400
     4             ((.NOT.ITSNIF).OR.(ITSNIF.AND.TOS(ASTACK).EQ.0)))    10637500
     5                         .OR.                                     10637600
     6            (CONTRL(N4) .NE. 0 .AND. LSTCTL)  )                   10637620
     7               PRNFLG = .FALSE.                                   10637640
              IF (CONTRL(N2).NE.0 .AND. MACDEF)                         **TEST**
     1           PRNFLG = .TRUE.                                        **TEST**
             IF (.NOT. PRNFLG)   GO TO 7105                             10637700
             CONTRL(CC) = CONTRL(CC) + 1                                10638000
             OBP = 1                                                    10639000
             CALL PAD(ERCODE,1)                                         10640000
             OBP = 3                                                    10641000
             IF (PRINTV.OR.LEN.GE.2.AND.IFSUP.NE.0)                     10642000
     1        CALL NUMBER(PRINTN,16,4)                                  10643000
             OBP = 8                                                    10644000
             IF (.NOT. MACDEF .AND. IFSUP .EQ. 0 .AND. ENDIFS           10645000
     1         .AND. DLEVEL .EQ. 0)  GO TO 7065                         10645050
C                                                                       10645100
             IF (.NOT. ITSNIF .AND. .NOT. MACCAL .AND. .NOT. MACROD     10645200
     1           .AND. DLEVEL .GT. 0)  CALL NUMBER(DLEVEL,10,1)         10645300
C                                                                       10645400
             IF ((ITSNIF .OR. MACCAL .OR. MACROD) .AND. DLEVEL .GT. 1)  10645500
     1         CALL NUMBER(DLEVEL-1,10,1)                               10645600
C                                                                       10645700
7065         CONTINUE                                                   10645800
             OBP = 10                                                   10646000
7070         CONTINUE                                                   10647000
             IF (PTR.GT.LEN) GO TO 7080                                 10648000
               IF (IFSUP.NE.0) CALL NUMBER(VSTACK(PTR),16,2)            10649000
               PTR = PTR + 1                                            10650000
               PRINTN = PRINTN + 1                                      10651000
               IF (MOD(PTR,4).NE.2) GO TO 7070                          10652000
7080         CONTINUE                                                   10653000
             OBP = 18                                                   10654000
             IF (MACXPN(BLKLVL+1).EQ.0) GO TO 7090                      10655000
               IF (.NOT. MACCAL) CALL PAD(PLUS,1)                       10656000
               IF (MACCAL .AND. MACXPN(BLKLVL+1) .GT. 1)                10656100
     1           CALL PAD(PLUS,1)                                       11065200
7090         CONTINUE                                                   10657000
             IF (SRCPRN) GO TO 7100                                     10658000
               OBP = 19                                                 10659000
               CALL APPEND(IBUF,IBE-1)                                  10660000
               IBE = IBP - 1                                            10661000
               SRCPRN = .TRUE.                                          10662000
7100         CONTINUE                                                   10663000
           CALL OUTPUT(CONTRL(CO))                                      10664000
           IF (PTR.LE.LEN) GO TO 7060                                   10665000
7105       CONTINUE                                                     10665100
           PRINTV = .FALSE.                                             10666000
           PRINTN = LC + LEN - 1                                        10667000
           IF (ASSEMB) GO TO 7180                                       10668000
C                                                                       10668100
C      DON'T WRITE OBJECT CODE IF ERRORS WERE ENCOUNTERED               10668200
C      AND $5=0, OR $6=1.                                               10668300
C                                                                       10668400
           IF (CONTRL(1) .GT. 0 .AND. CONTRL(N5) .EQ. 0                 10668500
     1       .OR. CONTRL(N6) .GT. 0)  GO TO 7115                        10668600
             CALL DUMPIT                                                10669000
             BINRAD = BINRAD/256 + 1                                    10669010
             BINRAD = BINRAD*256                                        10669020
             BINRCL = 0                                                 10669060
             CALL DUMPIT                                                10669080
             CALL PUSH(VSTACK,CONTRL(CP),VSTKL)                         10669100
             IF (CONTRL(CB).EQ.0) GO TO 7110                            10669200
C                                                                       10669300
C     WRITE END-OF-FILE RECORD                                          10669400
C                                                                       10669500
             CALL PAD(BLK,1)                                            10670000
             CALL PAD(COLON,1)                                          10671000
             CALL NUMBER(0,16,2)                                        10672000
             CALL NUMBER(XFRADR,16,4)                                   10672100
             CALL NUMBER(1,16,2)                                        10672200
             CHKSUM = RIGHT(MOD(65536-(XFRADR+1),256),8)                10672300
             CALL NUMBER(CHKSUM,16,2)                                   10672400
             CONTRL(CP) = 1                                             10674000
             CALL OUTPUT(2)                                             10675000
7110         CONTINUE                                                   10675100
             CALL PAD(BLK,1)                                            10675200
             CALL PAD(DOLLAR,1)                                         10675300
             CALL OUTPUT(2)                                             10675400
             CONTRL(CP) = POP(VSTACK)                                   10676000
C                                                                       10677000
C       PRINT ERROR COUNT                                               10678000
C                                                                       10679000
7115         CONTINUE                                                   10679100
             CALL PAD(BLK,1)                                            10680000
             IF (CONTRL(1).GT.0) GO TO 7120                             10681000
               CALL APPEND(ERTOT,ERTL)                                  10682000
7120         CONTINUE                                                   10683000
             IF (CONTRL(1).NE.1) GO TO 7130                             10684000
               CALL PAD(N1,1)                                           10685000
               CALL APPEND(ERTOT(3),ERTL-3)                             10686000
7130         CONTINUE                                                   10687000
             IF (CONTRL(1).LE.1) GO TO 7140                             10688000
               CALL VNUM(CONTRL(1))                                     10689000
               CALL APPEND(ERTOT(3),ERTL-2)                             10690000
7140         CONTINUE                                                   10691000
             DO 7150 I = 1,OBP                                          10692000
               VSTACK(I+1) = OBUF(I)                                    10693000
7150         CONTINUE                                                   10694000
             VSTACK(1) = OBP                                            10695000
             CALL OUTPUT(CONTRL(CO))                                    10696000
             IF (CONTRL(CO).EQ.1) GO TO 7160                            10697000
               CALL APPEND(VSTACK(2),VSTACK(1))                         10698000
               CALL PUSH(VSTACK,CONTRL(CP),VSTKL)                       10699000
               CONTRL(CP) = 1                                           10700000
               CALL OUTPUT(1)                                           10701000
               CONTRL(CP) = POP(VSTACK)                                 10702000
7160         CONTINUE                                                   10703000
C                                                                       10704000
C       PASS 2 SYMBOL DUMP                                              10705000
C                                                                       10706000
             IF (CONTRL(CS).EQ.0) GO TO 7170                            10707000
               CALL TFORM(PAGE,TITLE,TLEN)                              10708000
               CALL P2DUMP(PAGE,TITLE,TLEN)                             10709000
7170         CONTINUE                                                   10710000
C                                                                       10711000
C       EXIT ASSEMBLER                                                  10712000
C                                                                       10713000
             CALL EXIT                                                  10714000
C                                                                       10715000
C                                                                       10716000
C                                                                       10717000
7180     CONTINUE                                                       10718000
         ERCODE = BLK                                                   10719000
         IF (IFSUP.NE.0) LC = LC + SP(VSTACK) - 1                       10720000
         PRINTN = LC                                                    10721000
         IF (.NOT.ENDF) GO TO 120                                       10722000
C                                                                       10723000
C       REWIND INPUT DEVICE PRIOR TO PASS 2                             10724000
C                                                                       10725000
         REWIND INPUT                                                   10726000
C                                                                       10726100
C       SEND 'BEGIN PASS 2' MESSAGE                                     10726200
C                                                                       10726300
C        CALL PUSH(VSTACK,CONTRL(CP),VSTKL)                             **TEST**
C        CONTRL(CP) = 1                                                 **TEST**
         BEGIN(13) = N2                                                 10726400
         CALL APPEND(BEGIN,13)                                          10726500
         CALL OUTPUT(1)                                                 10726600
         CALL OUTPUT(1)                                                 10726700
C        CONTRL(CP) = POP(VSTACK)                                       **TEST**
C                                                                       10727000
C       PASS 1 SYMBOL DUMP                                              10728000
C                                                                       10729000
         IF (CONTRL(CT).NE.0) CALL P1DUMP                               10730000
         CONTRL(1) = 0                                                  10731000
         CALL TFORM(PAGE,TITLE,TLEN)                                    10732000
         GO TO 110                                                      10733000
C                                                                       10734000
C       STATE 8, SYMBOL = /                                             10735000
C                                                                       10736000
8000   CONTINUE                                                         10737000
       IF (I2.EQ.0) GO TO 500                                           10737100
       I1 = I1 / I2                                                     10738000
       GO TO 500                                                        10739000
C                                                                       10740000
C       STATE 9, SYMBOL = <UNARY +>                                     10741000
C                                                                       10742000
9000   CONTINUE                                                         10743000
       GO TO 500                                                        10744000
C                                                                       10745000
C       STATE 10, SYMBOL = NOT                                          10746000
C                                                                       10747000
10000  CONTINUE                                                         10748000
       I1 = NOTF(I1)                                                    10749000
       I1 = RIGHT(I1,16)                                                10750000
       GO TO 500                                                        10751000
C                                                                       10752000
C       STATE 11, SYMBOL = <UNARY ->                                    10753000
C                                                                       10754000
11000  CONTINUE                                                         10755000
       I1 = 65536 - I1                                                  10756000
       GO TO 500                                                        10757000
C                                                                       10758000
C       STATE 12, SYMBOL = AND                                          10759000
C                                                                       10760000
12000  CONTINUE                                                         10761000
       I1 = ANDF(I1,I2)                                                 10762000
       GO TO 500                                                        10763000
C                                                                       10764000
C       STATE 13, SYMBOL = OR                                           10765000
C                                                                       10766000
13000  CONTINUE                                                         10767000
       I1 = ORF(I1,I2)                                                  10768000
       GO TO 500                                                        10769000
C                                                                       10770000
C       STATE 14, SYMBOL = XOR                                          10771000
C                                                                       10772000
14000  CONTINUE                                                         10773000
       I1 = XORF(I1,I2)                                                 10774000
       GO TO 500                                                        10775000
C                                                                       10776000
C       STATE 15, SYMBOL = MOD                                          10777000
C                                                                       10778000
15000  CONTINUE                                                         10779000
       IF (I2.EQ.0) GO TO 500                                           10779100
       I1 = MOD(I1,I2)                                                  10780000
       GO TO 500                                                        10781000
C                                                                       10782000
C       STATE 16, SYMBOL = SHL                                          10783000
C                                                                       10784000
16000  CONTINUE                                                         10785000
       IF (I2.GE.16) I1 = 0                                             10786000
       I1 = SHL(I1,I2)                                                  10787000
       I1 = RIGHT(I1,16)                                                10788000
       GO TO 500                                                        10789000
C                                                                       10790000
C       STATE 17, SYMBOL = SHR                                          10791000
C                                                                       10792000
17000  CONTINUE                                                         10793000
       I1 = RIGHT(I1,16)                                                10794000
       IF (I2.EQ.0) GO TO 500                                           10794100
       I1 = SHR(I1,I2)                                                  10795000
       GO TO 500                                                        10796000
C                                                                       10797000
C       STATE 18, SYMBOL = <START OF LINE>                              10798000
C                                                                       10799000
18000  CONTINUE                                                         10800000
       GO TO 26000                                                      10801000
C                                                                       10802000
C       STATE 19, SYMBOL = :                                            10803000
C                                                                       10804000
19000  CONTINUE                                                         10805000
       IF (SP(OSTACK).NE.2.OR.SP(TSTACK).NE.2) GO TO 19090              10806000
         VALUE = LC                                                     10808000
         TYPE = POP(TSTACK)                                             10809000
         IDN = POP(VSTACK)                                              10810000
         ADDR = POP(VSTACK)                                             10811000
         LEVEL = POP(VSTACK)                                            10812000
         IF (IFSUP.EQ.0) GO TO 130                                      10813000
         IF (IPASS.EQ.1) GO TO 19020                                    10814000
           IF (GNC(0).EQ.COLON) GO TO 19010                             10815000
             CALL BACKUP                                                10816000
19010      CONTINUE                                                     10817000
19020    CONTINUE                                                       10818000
         IF (IPASS.EQ.2) GO TO 19080                                    10819000
           CHAR = GNC(0)                                                10820000
           IF (TYPE.NE.0) GO TO 19060                                   10821000
             TYPE = 2                                                   10822000
             IF (CHAR.NE.COLON) GO TO 19040                             10823000
               DO 19030 I = 2,BLKLVL                                    10824000
                 SYMBOT(I+1) = SYMBOT(I+1) + 2                          10825000
19030          CONTINUE                                                 10826000
               LEVEL = 1                                                10827000
               GO TO 19050                                              10828000
19040        CONTINUE                                                   10829000
             CALL BACKUP                                                10830000
             LEVEL = BLKLVL                                             10831000
19050        CONTINUE                                                   10832000
             CALL ENTER(IDN,VALUE,TYPE,LEVEL,ADDR)                      10833000
             GO TO 130                                                  10834000
19060      CONTINUE                                                     10835000
           IF (TYPE.NE.2) GO TO 19070                                   10836000
             IF (CHAR.EQ.COLON.AND.LEVEL.EQ.1) GO TO 130                10837000
             LEVEL = BLKLVL                                             10838000
             CALL ENTER(IDN,VALUE,TYPE,LEVEL,ADDR)                      10839000
19070      CONTINUE                                                     10840000
           CALL BACKUP                                                  10841000
           GO TO 130                                                    10842000
19080    CONTINUE                                                       10843000
         IF (IPASS.EQ.2.AND.SYMAX.GT.FREMEM-2) CALL ERROR(CT)           10843010
         PRINTV = .TRUE.                                                10844000
         CALL SYBRK(ADDR+1,J,ITYPE,IM,IR)                               10845000
         J = J * 64 + ITYPE                                             10845100
         IF (J.NE.VALUE*64+2) CALL ERROR(CP)                            10846000
         GO TO 130                                                      10847000
19090  CONTINUE                                                         10848000
       CALL ERROR(CE)                                                   10849000
       VSTACK(1) = 1                                                    10850000
       TSTACK(1) = 1                                                    10851000
       GO TO 130                                                        10852000
C                                                                       10853000
C       STATE 20, SYMBOL = <MACRO EXPANSION END>                        10854000
C                                                                       10855000
20000  CONTINUE                                                         10856000
       CALL EXITB                                                       10857000
       DLEVEL = DLEVEL - 1                                              10858000
       IBP = IBE + 1                                                    10859000
       GO TO 130                                                        10860000
C                                                                       10861000
C       STATE 21, SYMBOL = DB                                           10862000
C                                                                       10863000
21000  CONTINUE                                                         10864000
       IF (TOS(TSTACK).EQ.82) GO TO 21010                               10865000
         VALUE = EVAL(VSTACK,TSTACK,LSTACK,STATE)                       10866000
         CALL RANGE(VALUE)                                              10867000
         CALL PUSH(VSTACK,VALUE,VSTKL)                                  10868000
         CALL PUSH(TSTACK,81,TSTKL)                                     10869000
         GO TO 21030                                                    10870000
21010  CONTINUE                                                         10871000
       TYPE = POP(TSTACK)                                               10872000
       LEN = POP(VSTACK)                                                10873000
       IF (LEN.EQ.0) GO TO 21030                                        10874000
         PTR = SP(VSTACK) - LEN + 1                                     10875000
         LEN = PTR + LEN - 1                                            10876000
         DO 21020 I2 = PTR,LEN                                          10877000
           CHAR = VSTACK(I2)                                            10878000
           VSTACK(I2) = ASCII(CHAR+1)                                   10879000
           CALL PUSH(TSTACK,81,TSTKL)                                   10880000
21020    CONTINUE                                                       10881000
21030  CONTINUE                                                         10882000
       IF (TOKEN.NE.5) GO TO 320                                        10883000
       CALL PUSH(OSTACK,21,OSTKL)                                       10884000
       GO TO 130                                                        10885000
C                                                                       10886000
C       STATE 22, SYMBOL = DS                                           10887000
C                                                                       10888000
22000  CONTINUE                                                         10889000
       IF (IFSUP.EQ.0) GO TO 320                                        10889100
       PRINTV =.TRUE.                                                   10890000
       PRINTN = LC                                                      10891000
       IF (I1.GE.0.AND.I1+LC.LE.MAXMEM+1) GO TO 22010                   10892000
         CALL ERROR(CV)                                                 10893000
         GO TO 320                                                      10894000
22010  CONTINUE                                                         10895000
       LC = LC + I1                                                     10896000
        IF (IPASS.EQ.1 .OR. CONTRL(N6).GT.0 .OR.                        10896500
     1    (CONTRL(1).GT.0 .AND. CONTRL(N5).EQ.0) )  GO TO 320           10896510
        CALL DUMPIT                                                     10897000
         BINRAD = LC                                                    10898000
         CALL DUMPIT                                                    10899000
       GO TO 320                                                        10900000
C                                                                       10901000
C       STATE 23, SYMBOL = DW                                           10902000
C                                                                       10903000
23000  CONTINUE                                                         10904000
       I1 = RIGHT(I1,16)                                                10905000
       I2 = MOD(I1,256)                                                 10906000
       I1 = SHR(I1,8)                                                   10907000
       CALL PUSH(VSTACK,I2,VSTKL)                                       10908000
       CALL PUSH(VSTACK,I1,VSTKL)                                       10909000
       CALL PUSH(TSTACK,81,TSTKL)                                       10910000
       CALL PUSH(TSTACK,81,TSTKL)                                       10911000
       IF (TOKEN.NE.5) GO TO 320                                        10912000
       CALL PUSH(OSTACK,23,OSTKL)                                       10913000
       GO TO 130                                                        10914000
C                                                                       10915000
C       STATE 24, SYMBOL = END                                          10916000
C                                                                       10917000
24000  CONTINUE                                                         10918000
       IF (IPASS.EQ.2) ASSEMB =.FALSE.                                  10919000
       ENDF = .TRUE.                                                    10920000
       IF (SP(ASTACK).NE.1) CALL ERROR(CN)                              10921000
       IF (I1 .LT. 0) GO TO 24010                                       10921010
       I1 = RIGHT(I1,16)                                                10921020
       PRINTV = .TRUE.                                                  10921030
       PRINTN = I1                                                      10921040
       IF (I1 .GT. MAXMEM) CALL ERROR(CA)                               10921050
       XFRADR = I1                                                      10921060
24010  CONTINUE                                                         10921070
       IF (.NOT.MACDEF) GO TO 320                                       10921200
         CALL PUSH(OSTACK,33,OSTKL)                                     10921400
           GO TO 320                                                    10921600
C                                                                       10922000
C       STATE 25, SYMBOL = EQU                                          10923000
C                                                                       10924000
25000  CONTINUE                                                         10925000
       IF (SP(OSTACK).NE.2.OR.SP(TSTACK).NE.2) GO TO 25030              10926000
         VALUE = I1                                                     10928000
         TYPE = POP(TSTACK)                                             10929000
         IDN = POP(VSTACK)                                              10930000
         ADDR = POP(VSTACK)                                             10931000
         LEVEL = POP(VSTACK)                                            10932000
         IF (IFSUP.EQ.0) GO TO 320                                      10933000
         IF (IPASS.EQ.2) GO TO 25020                                    10934000
           IF (TYPE.NE.0.AND.BLKLVL.NE.LEVEL) GO TO 25010               10935000
           IF (TYPE.NE.0) GO TO 25020                                   10936000
25010      CONTINUE                                                     10937000
             TYPE = 2                                                   10938000
             CALL ENTER(IDN,VALUE,TYPE,BLKLVL,ADDR)                     10939000
25020    CONTINUE                                                       10940000
         IF (IPASS.EQ.2.AND.SYMAX.GT.FREMEM-2) CALL ERROR(CT)           10940010
         PRINTV = .TRUE.                                                10941000
         PRINTN = VALUE                                                 10942000
         CALL SYBRK(ADDR+1,J,ITYPE,IM,IR)                               10943000
         J = J * 64 + ITYPE                                             10943500
         IF (J.NE.VALUE*64+2) CALL ERROR(CP)                            10944000
         GO TO 320                                                      10945000
25030  CONTINUE                                                         10946000
       VSTACK(1) = 1                                                    10947000
       TSTACK(1) = 1                                                    10948000
       CALL ERROR(CE)                                                   10949000
       GO TO 320                                                        10950000
C                                                                       10951000
C       STATE 26, SYMBOL = IF                                           10952000
C                                                                       10953000
26000  CONTINUE                                                         10954000
       ITSNIF = .TRUE.                                                  10954100
       DLEVEL = DLEVEL + 1                                              10955000
       VSTACK(1) = 1                                                    10956000
       TSTACK(1) = 1                                                    10957000
       CALL PUSH(ASTACK,IFSUP,ASTKL)                                    10958000
       IF (IFSUP.EQ.0) GO TO 320                                        10959000
       IFSUP = RIGHT(I1,16)                                             10960000
       IF (IFSUP.NE.0) IFSUP = 65535                                    10961000
       GO TO 320                                                        10962000
C                                                                       10963000
C       STATE 27, SYMBOL = ENDIF                                        10964000
C                                                                       10965000
27000  CONTINUE                                                         10966000
       ENDIFS = .TRUE.                                                  10966100
       IF (SP(ASTACK).GE.2) GO TO 27010                                 10966100
         CALL ERROR(CN)                                                 10966200
         ASTACK(1) = 1                                                  10966300
         CALL PUSH(ASTACK,65535,ASTKL)                                  10966400
         DLEVEL = 1                                                     10966500
27010  CONTINUE                                                         10966600
       DLEVEL = DLEVEL - 1                                              10967000
       IFSUP = POP(ASTACK)                                              10969000
       GO TO 320                                                        10970000
C                                                                       10971000
C       STATE 28, SYMBOL = ORG                                          10972000
C                                                                       10973000
28000  CONTINUE                                                         10974000
       IF (IFSUP.EQ.0) GO TO 320                                        10974100
       PRINTV =.TRUE.                                                   10975000
       PRINTN = I1                                                      10976000
       IF (I1.GT.MAXMEM) CALL ERROR(CA)                                 10977000
       I1 = RIGHT(I1,16)                                                10978000
       LC = I1                                                          10979000
       IF (IPASS.EQ.1 .OR. CONTRL(N6).GT.0 .OR.                         10979500
     1   (CONTRL(1).GT.0 .AND.CONTRL(N5).EQ.0) )  GO TO 320             10979510
         CALL DUMPIT                                                    10980000
         BINRAD = LC                                                    10981000
         CALL DUMPIT                                                    10982000
       GO TO 320                                                        10983000
C                                                                       10984000
C       STATE 29, SYMBOL = SET                                          10985000
C                                                                       10986000
29000  CONTINUE                                                         10987000
       IF (SP(OSTACK).NE.2.OR.SP(TSTACK).NE.2) GO TO 29040              10988000
         VALUE = I1                                                     10990000
         TYPE = POP(TSTACK)                                             10991000
         IDN = POP(VSTACK)                                              10992000
         ADDR = POP(VSTACK)                                             10993000
         LEVEL = POP(VSTACK)                                            10994000
         IF (IFSUP.EQ.0) GO TO 320                                      10995000
         IF (IPASS.EQ.2) GO TO 29020                                    10996000
           IF (TYPE.NE.0) GO TO 29010                                   10997000
             TYPE = 1                                                   10998000
             CALL ENTER(IDN,VALUE,TYPE,BLKLVL,ADDR)                     10999000
             PRINTV = .TRUE.                                            11000000
             PRINTN = VALUE                                             11000500
29010      CONTINUE                                                     11001000
29020    CONTINUE                                                       11001500
         IF (IPASS.EQ.2.AND.SYMAX.GT.FREMEM-2) CALL ERROR(CT)           11001510
           IF (TYPE.EQ.1) GO TO 29030                                   11002000
             CALL ERROR(CM)                                             11003000
             GO TO 320                                                  11004000
29030      CONTINUE                                                     11005000
         PRINTV = .TRUE.                                                11007000
         PRINTN = VALUE                                                 11008000
         CALL SYBRK(ADDR+1,IVAL,ITYPE,IM,IR)                            11009000
         CALL SYBLD(ADDR+1,VALUE,1,IM,IR)                               11010000
         GO TO 320                                                      11011000
29040  CONTINUE                                                         11012000
       CALL ERROR(CE)                                                   11013000
       VSTACK(1) = 1                                                    11014000
       TSTACK(1) = 1                                                    11015000
       GO TO 320                                                        11016000
C                                                                       11017000
C       STATE 30, SYMBOL = TITLE                                        11018000
C                                                                       11019000
30000  CONTINUE                                                         11020000
       LSTCTL = .TRUE.                                                  11020100
       TYPE = TOS(TSTACK)                                               11021000
       IF (TYPE.EQ.82) GO TO 30010                                      11022000
         VALUE = EVAL(VSTACK,TSTACK,LSTACK,STATE)                       11023000
         CALL RANGE(VALUE)                                              11024000
         CALL PUSH(VSTACK,VALUE,VSTKL)                                  11025000
         CALL PUSH(TSTACK,81,TSTKL)                                     11026000
         GO TO 30040                                                    11027000
30010  CONTINUE                                                         11028000
         TYPE = POP(TSTACK)                                             11029000
         LEN = POP(VSTACK)                                              11030000
         IF (LEN.EQ.0) GO TO 30030                                      11031000
           DO 30020 I2 = 1,LEN                                          11032000
             CALL PUSH(TSTACK,81,TSTKL)                                 11033000
30020      CONTINUE                                                     11034000
30030    CONTINUE                                                       11035000
30040  CONTINUE                                                         11036000
       IF (TOKEN.NE.7) GO TO 30090                                      11037000
         IF (IFSUP.EQ.0) GO TO 30080                                    11038000
           IF (IPASS.EQ.1.AND.TLEN.NE.0) GO TO 30060                    11039000
             LEN = SP(VSTACK) - 1                                       11040000
             DO 30050 TLEN = 1,LEN                                      11041000
               TITLE(TLEN) = VSTACK(TLEN+1)                             11042000
30050        CONTINUE                                                   11043000
             TLEN = LEN                                                 11044000
30060      CONTINUE                                                     11045000
30070     CONTINUE                                                      11045500
30080    CONTINUE                                                       11051000
         IF (IFSUP .NE. 0 .AND. CONTRL(CC) .NE. 0)                      11051100
     $        CALL TFORM(PAGE,TITLE,TLEN)                               11051200
         VSTACK(1) = 1                                                  11052000
         TSTACK(1) = 1                                                  11053000
         GO TO 320                                                      11054000
30090  CONTINUE                                                         11055000
       IF (TOKEN.NE.5) CALL ERROR(CF)                                   11056000
       CALL PUSH(OSTACK,30,OSTKL)                                       11057000
       GO TO 130                                                        11058000
C                                                                       11059000
C       STATE 31, SYMBOL = MACRO                                        11060000
C                                                                       11061000
31000  CONTINUE                                                         11062000
       TYPE = POP(TSTACK)                                               11063000
       MACNAM = POP(VSTACK)                                             11064000
       ADDR = POP(VSTACK)                                               11065000
       LEVEL = POP(VSTACK)                                              11066000
       MACROD = .TRUE.                                                  11066100
       IF (IPASS.EQ.1) GO TO 31010                                      11067000
         TOKEN = 7                                                      11068000
         VSTACK(1) = 1                                                  11069000
         TSTACK(1) = 1                                                  11070000
         CALL PUSH(OSTACK,26,OSTKL)                                     11071000
         CALL PUSH(VSTACK,0,VSTKL)                                      11072000
         CALL PUSH(TSTACK,80,TSTKL)                                     11073000
         GO TO 320                                                      11074000
31010  CONTINUE                                                         11075000
       CALL ENTERB                                                      11076000
       PRMNO = 1                                                        11077000
       CALL PUSH(OSTACK,32,OSTKL)                                       11078000
       GO TO 130                                                        11079000
C                                                                       11080000
C       STATE 32, SYMBOL = <FORMAL MACRO PARAMETERS>                    11081000
C       SUCESSOR STATE TO STATES 31 AND 32                              11082000
C                                                                       11083000
32000  CONTINUE                                                         11084000
       IF (SP(TSTACK).LT.2) GO TO 32020                                 11086000
         TYPE = POP(TSTACK)                                             11087000
         IF (TYPE.NE.0) CALL ERROR(CF)                                  11088000
         IDN = POP(VSTACK)                                              11089000
         ADDR = POP(VSTACK)                                             11090000
         LEVEL = POP(VSTACK)                                            11091000
         IF (IFSUP.EQ.0) GO TO 32010                                    11092000
           CALL ENTER(IDN,PRMNO,3,BLKLVL,ADDR)                          11093000
           PRMNO = PRMNO + 1                                            11094000
32010    CONTINUE                                                       11096000
32020  CONTINUE                                                         11097000
       IF (TOKEN.EQ.5) GO TO 32030                                      11098000
         MACDEF = .TRUE.                                                11099000
         MACBOD = SYMAX                                                 11100000
         MACPTR(BLKLVL+1) = SYMAX*5                                     11101000
         SYMAX = SYMAX + 1                                              11102000
         CALL PUSH(OSTACK,26,OSTKL)                                     11103000
         CALL PUSH(VSTACK,0,VSTKL)                                      11104000
         CALL PUSH(TSTACK,80,TSTKL)                                     11105000
         GO TO 320                                                      11106000
32030  CONTINUE                                                         11107000
       CALL PUSH(OSTACK,32,OSTKL)                                       11108000
       GO TO 130                                                        11109000
C                                                                       11110000
C       STATE 33, SYMBOL = ENDM                                         11111000
C                                                                       11112000
33000  CONTINUE                                                         11113000
       IF (BLKLVL.LE.1.OR.IPASS.NE.1) GO TO 33100                       11114000
33010  CONTINUE                                                         11117000
       PTR = LOOKL                                                      11118000
33020  CONTINUE                                                         11119000
       IF (GET(PTR).NE.TAB.AND.GET(PTR).NE.BLK) GO TO 33030             11120000
         PTR = PTR - 1                                                  11121000
         GO TO 33020                                                    11122000
33030  CONTINUE                                                         11123000
       IF (GET(PTR).EQ.EOL) GO TO 33040                                 11124000
         PTR = PTR + 1                                                  11125000
         CALL PUT(EOL,PTR)                                              11126000
33040  CONTINUE                                                         11127000
       PTR = PTR + 1                                                    11128000
       CALL PUT(TERM,PTR)                                               11129000
       PTR = PTR + 1                                                    11130000
       CALL PUT(EOL,PTR)                                                11131000
       MACPTR(BLKLVL+1) = PTR + 1                                       11132000
       SYMAX = MACPTR(BLKLVL+1)/5 + 1                                   11133000
       I1 = SYMAX-1                                                     11134000
       KJ = SYMAX-1                                                     11135100
       DO 33050 I2 = MACBOD,KJ                                          11136000
         SYMTAB(FREMEM) = SYMTAB(I1)                                    11137000
         SYMTAB(I1) = 0                                                 11138000
         I1 = I1 - 1                                                    11139000
         FREMEM = FREMEM-1                                              11140000
33050  CONTINUE                                                         11141000
       LINKP = POP(SYMBOT)                                              11142000
       SYMTAB(LINKP) = 0                                                11143000
       SYMAX = LINKP + 1                                                11144000
       CALL ENTER(MACNAM,FREMEM+1,4,1,ADDR)                             11145000
       BLKLVL = SP(SYMBOT) - 1                                          11146000
       I = POP(MACPTR)                                                  11147000
       I = POP(MACPRM)                                                  11148000
       I = POP(MACXPN)                                                  11149000
       IF (CONTRL(CM).NE.0) CALL MACDMP(MACNAM,ADDR)                    11150000
33100  CONTINUE                                                         11151500
       CALL PUSH(OSTACK,27,OSTKL)                                       11152000
       MACDEF = .FALSE.                                                 11153000
       GO TO 320                                                        11154000
C                                                                       11155000
C       STATE 34, SYMBOL = <MACRO CALL>                                 11156000
C                                                                       11157000
34000  CONTINUE                                                         11158000
       IF (TOKEN.EQ.31) GO TO 320                                       11159000
       MACCAL = .TRUE.                                                  11159100
       IF (IFSUP.EQ.0) GO TO 34010                                      11160000
         CALL ENTERB                                                    11161000
         DLEVEL = DLEVEL + 1                                            11162000
         MACPRM(BLKLVL+1) = SYMAX*5                                     11163000
         MACSUB = SYMAX                                                 11164000
34010  CONTINUE                                                         11165000
       CALL PUSH(OSTACK,35,OSTKL)                                       11166000
       GO TO 320                                                        11167000
C                                                                       11168000
C       STATE 35, SYMBOL = <ACTUAL MACRO PARAMETERS>                    11169000
C       SUCCESSOR STATE TO STATES 34 AND 35                             11170000
C                                                                       11171000
35000  CONTINUE                                                         11172000
       IF (SP(TSTACK).GE.3) GO TO 35010                                 11173000
         CALL PUSH(TSTACK,80,TSTKL)                                     11173100
         CALL PUSH(VSTACK,0,VSTKL)                                      11173200
35010  CONTINUE                                                         11173300
       IF (IFSUP.NE.0) GO TO 35020                                      11174000
         VSTACK(1) = 1                                                  11175000
         TSTACK(1) = 1                                                  11176000
         GO TO 35030                                                    11177000
35020  CONTINUE                                                         11178000
       CALL PARVAL(VSTACK,TSTACK,LSTACK)                                11179000
35030  CONTINUE                                                         11181000
       IF (TOKEN.NE.7) GO TO 35060                                      11182000
         IF (IFSUP.EQ.0) GO TO 35050                                    11183000
           CALL PUT(PTERM,MACPRM(BLKLVL+1))                             11184000
           MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                      11185000
           SYMAX = MACPRM(BLKLVL+1)/5 + 1                               11186000
           I1 = SYMAX - 1                                               11187000
           KJ = SYMAX-1                                                 11187100
           DO 35040 I2 = MACSUB,KJ                                      11188000
             SYMTAB(FREMEM) = SYMTAB(I1)                                11189000
             SYMTAB(I1) = 0                                             11190000
             I1 = I1 - 1                                                11191000
             FREMEM = FREMEM - 1                                        11192000
35040      CONTINUE                                                     11193000
           SYMAX = MACSUB                                               11194000
           MACPRM(BLKLVL+1) = FREMEM+1                                  11195000
           MACXPN(BLKLVL+1) = 1                                         11196000
           TYPE = POP(TSTACK)                                           11197000
           MACNAM = POP(VSTACK)                                         11198000
           ADDR = POP(VSTACK)                                           11199000
           CALL SYBRK(ADDR+1,IVAL,ITYPE,IM,IR)                          11200000
           CALL SYBLD(ADDR+1,IVAL,ITYPE,IM,0)                           11201000
           ADDR = IVAL                                                  11201100
           MACPTR(BLKLVL+1) = ADDR * 5                                  11202000
           LEVEL = POP(VSTACK)                                          11203000
35050    CONTINUE                                                       11205000
         VSTACK(1) = 1                                                  11206000
         TSTACK(1) = 1                                                  11207000
         GO TO 320                                                      11208000
35060  CONTINUE                                                         11209000
       IF (TOKEN.NE.5) CALL ERROR(CF)                                   11210000
       CALL PUSH(OSTACK,35,OSTKL)                                       11211000
       GO TO 130                                                        11212000
C                                                                       11212100
C       NULL STATES, 36 THROUGH 54                                      11212200
C                                                                       11212300
36000  CONTINUE                                                         11212400
       CALL ERROR(QUES)                                                 11212500
       GO TO 130                                                        11212600
C                                                                       11213000
C       BEGIN VARIANT CODE                                              11214000
C                                                                       11215000
C       STATE 55, SYMBOL = <LOAD INDEX HEAD>                            11216000
C                                                                       11217000
55000  CONTINUE                                                         11218000
       I3 = ANDF(I2,6)                                                  11219000
       IF (I3.NE.I2) CALL ERROR(CR)                                     11220000
       I2 = SHL(I3,3)                                                   11221000
       I2 = RIGHT(I2,16)                                                11222000
       I1 = ORF(I1,I2)                                                  11223000
       CALL PUSH(VSTACK,I1,VSTKL)                                       11224000
       CALL PUSH(TSTACK,80,TSTKL)                                       11225000
       CALL PUSH(OSTACK,63,OSTKL)                                       11226000
       IF (TOKEN.EQ.5) GO TO 130                                        11227000
       CALL ERROR(CF)                                                   11228000
       GO TO 320                                                        11229000
C                                                                       11230000
C       STATE 56, SYMBOL = <INDEX REFERENCE INSTRUCTION>                11231000
C                                                                       11232000
56000  CONTINUE                                                         11233000
       I3 = ANDF(I2,6)                                                  11234000
       IF (I3.NE.I2) CALL ERROR(CR)                                     11235000
       I2 = SHL(I3,3)                                                   11236000
       I1 = ORF(I1,I2)                                                  11237000
       GO TO 64000                                                      11238000
C                                                                       11239000
C       STATE 57, SYMBOL = <INDEXED INSTRUCTION>                        11240000
C                                                                       11241000
57000  CONTINUE                                                         11242000
       IF (I2.NE.0.AND.I2.NE.2) CALL ERROR(CR)                          11243000
       I2 = SHL(I2,3)                                                   11244000
       I1 = ORF(I1,I2)                                                  11245000
       GO TO 64000                                                      11246000
C                                                                       11247000
C       STATE 58, SYMBOL = <REGISTER INSTRUCTION>                       11248000
C                                                                       11249000
58000  CONTINUE                                                         11250000
       IF (I2.GT.7) CALL ERROR(CR)                                      11251000
       I2 = RIGHT(I2,3)                                                 11252000
       IF (I1.EQ.112.AND.I2.EQ.6) CALL ERROR(CR)                        11253000
       I1 = ORF(I1,I2)                                                  11254000
       GO TO 64000                                                      11255000
C                                                                       11256000
C       STATE 59, SYMBOL = <IMMEDIATE INSTRUCTION>                      11257000
C                                                                       11258000
59000  CONTINUE                                                         11259000
       CALL PUSH(VSTACK,I1,VSTKL)                                       11260000
       CALL PUSH(TSTACK,81,TSTKL)                                       11261000
       LEN = POP(LSTACK) + 1                                            11262000
       CALL PUSH(LSTACK,LEN,LSTKL)                                      11263000
       I1 = I2                                                          11264000
       GO TO 64000                                                      11265000
C                                                                       11266000
C       STATE 60, SYMBOL = <MOVE IMMEDIATE HEAD>                        11267000
C                                                                       11268000
60000  CONTINUE                                                         11269000
       IF (I2.GT.7) CALL ERROR(CR)                                      11270000
       I2 = RIGHT(I2,3)                                                 11271000
       I2 = SHL(I2,3)                                                   11272000
       I1 = ORF(I1,I2)                                                  11273000
       CALL PUSH(VSTACK,I1,VSTKL)                                       11274000
       CALL PUSH(TSTACK,80,TSTKL)                                       11275000
       CALL PUSH(OSTACK,59,OSTKL)                                       11276000
       IF (TOKEN.EQ.5) GO TO 130                                        11277000
       CALL ERROR(CF)                                                   11278000
       GO TO 320                                                        11279000
C                                                                       11280000
C       STATE 61, SYMBOL = <REGISTER REFERENCE INSTRUCTION>             11281000
C                                                                       11282000
61000  CONTINUE                                                         11283000
       IF (I2.GT.7) CALL ERROR(CR)                                      11284000
       I2 = RIGHT(I2,3)                                                 11285000
       I2 = SHL(I2,3)                                                   11286000
       I1 = ORF(I1,I2)                                                  11287000
       GO TO 64000                                                      11288000
C                                                                       11289000
C       STATE 62, SYMBOL = <MOVE REGISTER HEAD>                         11290000
C                                                                       11291000
62000  CONTINUE                                                         11292000
       IF (I2.GT.7) CALL ERROR(CR)                                      11293000
       I2 = RIGHT(I2,3)                                                 11294000
       I2 = SHL(I2,3)                                                   11295000
       I1 = ORF(I1,I2)                                                  11296000
       CALL PUSH(VSTACK,I1,VSTKL)                                       11297000
       CALL PUSH(TSTACK,80,TSTKL)                                       11298000
       CALL PUSH(OSTACK,58,OSTKL)                                       11299000
       IF (TOKEN.EQ.5) GO TO 130                                        11300000
       CALL ERROR(CF)                                                   11301000
       GO TO 320                                                        11302000
C                                                                       11303000
C       STATE 63, SYMBOL = <BRANCH INSTRUCTION>                         11304000
C                                                                       11305000
63000  CONTINUE                                                         11306000
       I3 = I1                                                          11307000
       IF (I2.GT.MAXMEM) CALL ERROR(CA)                                 11308000
       I2 = RIGHT(I2,16)                                                11309000
       I1 = SHR(I2,8)                                                   11310000
       I2 = RIGHT(I2,8)                                                 11311000
       CALL PUSH(VSTACK,I3,VSTKL)                                       11312000
       CALL PUSH(TSTACK,81,TSTKL)                                       11313000
       LEN = POP(LSTACK) + 2                                            11314000
       CALL PUSH(LSTACK,LEN,LSTKL)                                      11315000
       CALL PUSH(VSTACK,I2,VSTKL)                                       11316000
       CALL PUSH(TSTACK,81,TSTKL)                                       11317000
C                                                                       11318000
C       STATE 64, SYMBOL = <ZERO OPERAND INSTRUCTION>                   11319000
C       COMPLETE STATES 56,57,58,59,61,63                               11320000
C                                                                       11321000
64000  CONTINUE                                                         11322000
       CALL RANGE(I1)                                                   11323000
       CALL PUSH(VSTACK,I1,VSTKL)                                       11324000
       CALL PUSH(TSTACK,81,TSTKL)                                       11325000
       LEN = POP(LSTACK) + 1                                            11326000
       CALL PUSH(LSTACK,LEN,LSTKL)                                      11327000
       GO TO 320                                                        11328000
C                                                                       11329000
C                                                                       11330000
C                                                                       11331000
       END                                                              11332000
C                                                                       11333000
C**********                                                             11334000
C                                                                       11335000
C       LOGICAL AND FUNCTION, (MAXIMUM 30 BITS)                         11336000
C                                                                       11337000
C**********                                                             11338000
C                                                                       11339000
        INTEGER FUNCTION ANDF(II,JJ)                                    11340000
C                                                                       11341000
        I = II                                                          11342000
        J = JJ                                                          11343000
        JK = 1                                                          11344000
        ANDF = 0                                                        11345000
        DO 1 K  = 1,30                                                  11346000
            KK = 0                                                      11347000
            MM = MOD(I,2)                                               11348000
            NN = MOD(J,2)                                               11349000
            IF (MM.EQ.1.AND.NN.EQ.1) KK = 1                             11350000
            I = I/2                                                     11351000
            J = J/2                                                     11352000
            ANDF = ANDF + KK * JK                                       11353000
            JK = JK + JK                                                11354000
1       CONTINUE                                                        11355000
        RETURN                                                          11356000
        END                                                             11357000
C                                                                       11358000
C**********                                                             11359000
C                                                                       11360000
C       APPEND - APPEND A STRING TO THE OUTPUT BUFFER                   11361000
C                                                                       11362000
C**********                                                             11363000
C                                                                       11364000
        SUBROUTINE APPEND(STRING,LENGTH)                                11365000
C                                                                       11366000
        INTEGER STRING,LENGTH                                           11367000
        DIMENSION STRING(1)                                             11368000
C                                                                       11369000
        INTEGER OBUF,OBP                                                11370000
        COMMON /OUTBUF/ OBUF(132),OBP                                   11371000
C                                                                       11372000
        INTEGER SHL                                                     11373000
C                                                                       11374000
        I2 = 132 - OBP                                                  11375000
        IF (I2.GE.LENGTH) I2 = LENGTH                                   11376000
        IF (I2.LT.1) RETURN                                             11377000
        DO 10 I1 = 1,I2                                                 11378000
          OBP = OBP + 1                                                 11379000
          OBUF(OBP) = STRING(I1)                                        11380000
10      CONTINUE                                                        11381000
        RETURN                                                          11382000
        END                                                             11383000
C                                                                       11384000
C**********                                                             11385000
C                                                                       11386000
C       BACKUP SCANNER POINTERS                                         11387000
C                                                                       11388000
C**********                                                             11389000
C                                                                       11390000
        SUBROUTINE BACKUP                                               11391000
C                                                                       11392000
        INTEGER IBUF(120),IBP,IBE                                       11393000
        COMMON /SOURCE/ IBUF,IBP,IBE                                    11394000
C                                                                       11395000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11396000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11397000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11398000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11399000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11400000
C                                                                       11401000
        INTEGER IPASS,BLKLVL                                            11402000
        COMMON /PASS/ IPASS,BLKLVL                                      11403000
C                                                                       11404000
        LOGICAL MACDEF                                                  11405000
        COMMON /MACROS/ MACDEF                                          11406000
C                                                                       11407000
        IBP = IBP - 1                                                   11408000
        IF (.NOT.MACDEF) RETURN                                         11409000
        MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1) - 1                         11410000
        RETURN                                                          11411000
        END                                                             11412000
C                                                                       11432000
C**********                                                             11433000
C                                                                       11434000
C       CONVERT ENCODED IDENTIFIER TO OUTPUT                            11435000
C                                                                       11436000
C**********                                                             11437000
C                                                                       11438000
        SUBROUTINE CONID(I1,JK)                                         11439000
C                                                                       11440000
        INTEGER IBUF(5)                                                 11441000
C                                                                       11442000
        CALL ICON(I1,JK,IBUF)                                           11443000
        CALL APPEND(IBUF,5)                                             11444000
        RETURN                                                          11445000
        END                                                             11446000
C                                                                       11447000
C**********                                                             11448000
C                                                                       11449000
C       CONVERT NUMERIC STRING                                          11450000
C                                                                       11451000
C**********                                                             11452000
C                                                                       11453000
        INTEGER FUNCTION CONNUM(CHAR)                                   11454000
C                                                                       11455000
        INTEGER GNC                                                     11456000
C                                                                       11457000
        INTEGER                                                         11458000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11459000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11460000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11461000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11462000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11463000
C                                                                       11464000
        COMMON /CSET/                                                   11465000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11466000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11467000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11468000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11469000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11470000
C                                                                       11471000
        INTEGER RADIX,CHAR,DIGIT,PTR                                    11472000
        INTEGER ARRAY(20)                                               11473000
        INTEGER RIGHT                                                   11473050
        LOGICAL OVFL                                                    11473100
C                                                                       11474000
        PTR = 1                                                         11475000
10      CONTINUE                                                        11476000
          OVFL = .TRUE.                                                 11476100
          ARRAY(PTR) = CHAR                                             11477000
          IF (PTR.GE.18) GO TO 15                                       11478000
            PTR = PTR + 1                                               11478100
            OVFL = .FALSE.                                              11478200
15        CONTINUE                                                      11478300
          CHAR = GNC(0)                                                 11479000
          IF (N0.LE.CHAR.AND.CHAR.LE.N9) GO TO 10                       11480000
          IF (CA.LE.CHAR.AND.CHAR.LE.CZ) GO TO 10                       11481000
        CALL BACKUP                                                     11482000
        IF (OVFL) CALL ERROR(CV)                                        11482100
        PTR = PTR - 1                                                   11483000
        CHAR = ARRAY(PTR)                                               11484000
        PTR = PTR - 1                                                   11485000
        RADIX = 0                                                       11486000
        IF (CHAR.EQ.CO.OR.CHAR.EQ.CQ) RADIX = 8                         11487000
        IF (CHAR.EQ.CB) RADIX = 2                                       11488000
        IF (CHAR.EQ.CH) RADIX = 16                                      11489000
        IF (CHAR.EQ.CD) RADIX = 10                                      11490000
        IF (RADIX.NE.0) GO TO 20                                        11491000
          RADIX = 10                                                    11492000
          PTR = PTR + 1                                                 11493000
20      CONTINUE                                                        11494000
        CONNUM = 0                                                      11495000
        DO 40 I = 1,PTR                                                 11496000
          DIGIT = 17                                                    11497000
          CHAR = ARRAY(I)                                               11498000
          IF (N0.LE.CHAR.AND.CHAR.LE.N9) DIGIT = CHAR - N0              11499000
          IF (CA.LE.CHAR.AND.CHAR.LE.CF) DIGIT = CHAR - N7              11500000
          IF (DIGIT.LT.RADIX) GO TO 30                                  11501000
            CALL ERROR(CI)                                              11502000
            DIGIT = 0                                                   11503000
30        CONTINUE                                                      11504000
          CONNUM = CONNUM * RADIX + DIGIT                               11505000
          KK = CONNUM                                                   11505050
          CONNUM = RIGHT(KK,16)                                         11505060
          IF (CONNUM.NE.KK) CALL ERROR(CV)                              11505100
40      CONTINUE                                                        11506000
        RETURN                                                          11507000
        END                                                             11508000
C                                                                       11509000
C**********                                                             11510000
C                                                                       11511000
C       DUMP CONTROL PARAMETERS TO LIST                                 11512000
C                                                                       11513000
C**********                                                             11514000
C                                                                       11515000
        SUBROUTINE DDUMP                                                11516000
C                                                                       11517000
        INTEGER CONTRL(64)                                              11518000
        COMMON /CNTRL/ CONTRL                                           11519000
C                                                                       11520000
        INTEGER                                                         11521000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11522000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11523000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11524000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11525000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11526000
C                                                                       11527000
        COMMON /CSET/                                                   11528000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11529000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11530000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11531000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11532000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11533000
C                                                                       11534000
        CALL OUTPUT(CONTRL(CO))                                         11535000
        K = 0                                                           11536000
        DO 30 I = 1,64                                                  11537000
          IF (CONTRL(I).LT.0) GO TO 20                                  11538000
            CALL PAD(BLK,1)                                             11539000
            CALL PAD(DOLLAR,1)                                          11540000
            CALL PAD(I,1)                                               11541000
            CALL PAD(EQUAL,1)                                           11542000
            CALL VNUM(CONTRL(I))                                        11543000
            K = K + 1                                                   11544000
            IF (K.NE.2) GO TO 10                                        11545000
              CALL OUTPUT(CONTRL(CO))                                   11546000
              K = 0                                                     11547000
10          CONTINUE                                                    11548000
20        CONTINUE                                                      11549000
30      CONTINUE                                                        11550000
        IF (K.NE.0) CALL OUTPUT(CONTRL(CO))                             11551000
        RETURN                                                          11552000
        END                                                             11553000
C                                                                       11554000
C**********                                                             11555000
C                                                                       11556000
C       DUMP HEXADECIMAL CODE TO FILE 2                                 11557000
C                                                                       11558000
C**********                                                             11559000
C                                                                       11560000
        SUBROUTINE DUMPIT                                               11561000
C                                                                       11562000
        INTEGER CONTRL(64)                                              11563000
        COMMON /CNTRL/ CONTRL                                           11564000
C                                                                       11565000
        INTEGER                                                         11566000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11567000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11568000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11569000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11570000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11571000
C                                                                       11572000
        COMMON /CSET/                                                   11573000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11574000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11575000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11576000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11577000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11578000
C                                                                       11579000
        INTEGER OBUF,OBP                                                11580000
        COMMON /OUTBUF/ OBUF(132),OBP                                   11581000
C                                                                       11582000
        LOGICAL BFST                                                    11582100
        INTEGER BINBUF(16),BINRAD,BINRCL,BINORG                         11583000
        COMMON /BBUF/ BINBUF,BINRAD,BINRCL,BINORG,BFST                  11583100
C                                                                       11583200
        INTEGER RIGHT,CHKSUM                                            11584000
C                                                                       11585000
        JJ = CONTRL(CP)                                                 11585100
        CONTRL(CP) = 1                                                  11585200
         IF (CONTRL(CB).NE.0) GO TO 15                                  11585210
5         CONTINUE                                                      11585220
           IF (BINRAD.LE.BINORG) GO TO 10                               11585230
           IF (BFST) GO TO 8                                            11585250
             BINORG = BINRAD/256 * 256                                  11585260
             BFST = .TRUE.                                              11585270
             GO TO 5                                                    11585280
8          CONTINUE                                                     11585290
            CALL VNUM(BINORG)                                           11585304
            CALL PAD(BLK,1)                                             11585305
            CALL PAD(CB,1)                                              11585306
            CALL PAD(CN,8)                                              11585307
            CALL PAD(CF,1)                                              11585308
            CALL OUTPUT(2)                                              11585309
            BINORG = BINORG + 1                                         11585310
          GO TO 5                                                       11585311
10        CONTINUE                                                      11585312
15      CONTINUE                                                        11585313
        BINORG = BINRAD + BINRCL                                        11585314
        IF (BINRCL.EQ.0) GO TO 200                                      11585315
        IF (CONTRL(CB).NE.0) GO TO 80                                   11585316
            KK = 0                                                      11586020
            OBP = 1                                                     11586030
             DO 60 I = 1,BINRCL                                         11586040
              IF (KK.EQ.0) CALL VNUM(BINRAD)                            11586050
              BINRAD = BINRAD + 1                                       11586060
              CALL PAD(BLK,1)                                           11586070
              CALL PAD(CB,1)                                            11586080
              DO 30 J = 1,8                                             11586090
                JK = BINBUF(I)/(2**(8-J))                               11586100
                JK = MOD(JK,2)                                          11586110
                IF (JK.EQ.1) CALL PAD(CP,1)                             11586120
                IF (JK.EQ.0) CALL PAD(CN,1)                             11586130
30            CONTINUE                                                  11586140
              CALL PAD(CF,1)                                            11586150
              CALL PAD(BLK,1)                                           11586160
              KK = KK + 1                                               11586170
              IF (KK.NE.4) GO TO 40                                     11586180
                KK = 0                                                  11586190
                CALL OUTPUT(2)                                          11586200
                OBP = 1                                                 11586210
40            CONTINUE                                                  11586220
60          CONTINUE                                                    11586230
            IF (KK.NE.0) CALL OUTPUT(2)                                 11586231
            GO TO 200                                                   11586232
80        CONTINUE                                                      11586240
          OBP = 1                                                       11587000
          CALL PAD(COLON,1)                                             11588000
          CALL NUMBER(BINRCL,16,2)                                      11589000
          CHKSUM = BINRCL + BINRAD/256 + MOD(BINRAD,256)                11590000
          CALL NUMBER(BINRAD,16,4)                                      11591000
          CALL NUMBER(0,16,2)                                           11592000
          DO 100 I = 1,BINRCL                                           11593000
            CHKSUM = CHKSUM + BINBUF(I)                                 11594000
            CALL NUMBER(BINBUF(I),16,2)                                 11595000
100       CONTINUE                                                      11596000
          CHKSUM = RIGHT(CHKSUM,8)                                      11597000
          CHKSUM = MOD((256-CHKSUM),256)                                11598000
          CALL NUMBER(CHKSUM,16,2)                                      11599000
          II = CONTRL(CP)                                               11600000
          CONTRL(CP) = 1                                                11601000
          CALL OUTPUT(2)                                                11602000
          CONTRL(CP) = II                                               11603000
200     CONTINUE                                                        11604000
        CONTRL(CP) = JJ                                                 11604100
        BINRCL = 0                                                      11604500
        RETURN                                                          11605000
        END                                                             11606000
C                                                                       11607000
C**********                                                             11608000
C                                                                       11609000
C       CREATE SYMBOL TABLE ENTRY                                       11610000
C                                                                       11611000
C**********                                                             11612000
C                                                                       11613000
        SUBROUTINE ENTER(IDN,VALUE,TYPE,LEVEL,ADDR)                     11614000
C                                                                       11615000
        INTEGER                                                         11616000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11617000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11618000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11619000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11620000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11621000
C                                                                       11622000
        COMMON /CSET/                                                   11623000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11624000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11625000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11626000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11627000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11628000
C                                                                       11629000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11630000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11631000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11632000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11633000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11634000
C                                                                       11635000
        INTEGER IPASS,BLKLVL                                            11636000
        COMMON /PASS/ IPASS,BLKLVL                                      11637000
C                                                                       11638000
        INTEGER IDN,VALUE,TYPE,LEVEL                                    11639000
        INTEGER ADDR,LOWER,UPPER                                        11640000
C                                                                       11641000
        IF (SYMAX.GT.FREMEM-2) GO TO 70                                 11642000
          LINK = SYMBOT(LEVEL+1)                                        11643000
          LOWER = LINK + 1                                              11644000
          UPPER = LINK + SYMTAB(LINK) - 2                               11645000
          ADDR = LOWER                                                  11646000
          IF (SYMTAB(LINK).EQ.1) GO TO 50                               11647000
          IF (IDN.LT.SYMTAB(LOWER)) GO TO 50                            11648000
          ADDR = UPPER + 2                                              11649000
          IF (IDN.GT.SYMTAB(UPPER)) GO TO 50                            11650000
          IF (SYMTAB(LINK).EQ.3) GO TO 40                               11651000
            DO 30 I = LOWER,UPPER,2                                     11652000
              ADDR = I+2                                                11653000
              IF (SYMTAB(I).EQ.IDN) GO TO 40                            11653100
              IF (SYMTAB(I).LT.IDN.AND.IDN.LT.SYMTAB(I+2)) GO TO 50     11654000
30          CONTINUE                                                    11655000
40          CONTINUE                                                    11656000
          CALL SYBRK(ADDR-1,IVAL,ITYPE,IM,IR)                           11656100
          CALL SYBLD(ADDR-1,IVAL,ITYPE,MULTI,IR)                        11656200
          RETURN                                                        11656300
50        CONTINUE                                                      11657000
C                                                                       11658000
C       INSERT SYMBOL                                                   11659000
C                                                                       11660000
          DO 60 LL = ADDR,SYMAX                                         11661000
            NVAL = SYMAX - LL + ADDR                                    11662000
            SYMTAB(NVAL+2) = SYMTAB(NVAL)                               11663000
60        CONTINUE                                                      11664000
          SYMAX = SYMAX + 2                                             11665000
          SYMTAB(ADDR) = IDN                                            11666000
          CALL SYBLD(ADDR+1,VALUE,TYPE,0,REFBIT)                        11667000
          SYMTAB(LINK) = SYMTAB(LINK) + 2                               11668000
          IF (LINKP.GE.ADDR) LINKP = LINKP + 2                          11669000
          RETURN                                                        11670000
70      CONTINUE                                                        11671000
        CALL ERROR(CT)                                                  11672000
        RETURN                                                          11673000
        END                                                             11674000
C                                                                       11675000
C**********                                                             11676000
C                                                                       11677000
C       ENTER A SYMBOL TABLE (LEXICAL) BLOCK                            11678000
C                                                                       11679000
C**********                                                             11680000
C                                                                       11681000
        SUBROUTINE ENTERB                                               11682000
C                                                                       11683000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11684000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11685000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11686000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11687000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11688000
C                                                                       11689000
        INTEGER IPASS,BLKLVL                                            11690000
        COMMON /PASS/ IPASS,BLKLVL                                      11691000
C                                                                       11692000
        INTEGER SP                                                      11693000
C                                                                       11694000
        IF (BLKLVL.NE.0) GO TO 10                                       11695000
          LINKP = 1                                                     11696000
          SYMBOT(1) = 1                                                 11697000
          MACXPN(1) = 1                                                 11698000
          MACPTR(1) = 1                                                 11699000
          MACPRM(1) = 1                                                 11700000
          GO TO 15                                                      11701000
10      CONTINUE                                                        11702000
        LINKP = LINKP + SYMTAB(LINKP)                                   11703000
15      CONTINUE                                                        11704000
        CALL PUSH(MACPRM,0,MAXNP)                                       11705000
        CALL PUSH(MACPTR,0,MAXNP)                                       11706000
        CALL PUSH(MACXPN,0,MAXNP)                                       11707000
        CALL PUSH(SYMBOT,LINKP,MAXNP)                                   11708000
        BLKLVL = SP(SYMBOT) - 1                                         11709000
        IF (IPASS.NE.1.OR.BLKLVL.EQ.1) GO TO 20                         11710000
          SYMTAB(LINKP) = 1                                             11711000
          SYMAX = LINKP + 1                                             11712000
20      CONTINUE                                                        11713000
        RETURN                                                          11714000
        END                                                             11715000
C                                                                       11716000
C**********                                                             11717000
C                                                                       11718000
C       ERROR                                                           11719000
C                                                                       11720000
C**********                                                             11721000
C                                                                       11722000
        SUBROUTINE ERROR(ERRTYP)                                        11723000
C                                                                       11724000
        INTEGER ERRTYP                                                  11725000
C                                                                       11726000
        INTEGER IFSUP                                                   11727000
        COMMON /IFS/ IFSUP                                              11728000
C                                                                       11729000
        INTEGER ERCODE                                                  11730000
        COMMON /ERRCD/ ERCODE                                           11731000
C                                                                       11732000
        INTEGER                                                         11733000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11734000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11735000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11736000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11737000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11738000
C                                                                       11739000
        COMMON /CSET/                                                   11740000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11741000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11742000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11743000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11744000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11745000
C                                                                       11746000
        INTEGER CONTRL(64)                                              11747000
        COMMON /CNTRL/ CONTRL                                           11748000
C                                                                       11749000
        IF (ERCODE.NE.BLK) RETURN                                       11750000
        IF (IFSUP.EQ.0) RETURN                                          11751000
        CONTRL(1) = CONTRL(1) + 1                                       11752000
        ERCODE = ERRTYP                                                 11753000
        RETURN                                                          11754000
        END                                                             11755000
C                                                                       11756000
C**********                                                             11757000
C                                                                       11758000
C       EVAL - GET VALUE OF SYMBOL AT TOP OF VSTACK                     11759000
C                                                                       11760000
C**********                                                             11761000
C                                                                       11762000
        INTEGER FUNCTION EVAL(VSTACK,TSTACK,LSTACK,STATE)               11763000
C                                                                       11764000
        INTEGER VSTACK(1),TSTACK(1),LSTACK(1),STATE                     11765000
C                                                                       11766000
        INTEGER POP,SHL,IDN,ADDR,LEVEL,TOS,SP                           11767000
C                                                                       11768000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11769000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11770000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11771000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11772000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11773000
C                                                                       11774000
        INTEGER CONTRL(64)                                              11775000
        COMMON /CNTRL/ CONTRL                                           11776000
C                                                                       11777000
        INTEGER IOTRAN(64),ASCII(64)                                    11778000
        COMMON /PORTA/ IOTRAN,ASCII                                     11779000
C                                                                       11780000
        INTEGER                                                         11781000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11782000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11783000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11784000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11785000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11786000
C                                                                       11787000
        COMMON /CSET/                                                   11788000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11789000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11790000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11791000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11792000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11793000
C                                                                       11794000
        IF (SP(TSTACK).GE.2) GO TO 5                                    11794100
        IF (STATE .EQ. 24) GO TO 1                                      11794110
C-------THAT STATEMENT ALLOWS AN END PSEUDO WITH NO OPERAND             11794120
          CALL ERROR(CF)                                                11794200
          EVAL = 0                                                      11794300
          RETURN                                                        11794400
1         CONTINUE                                                      11794410
          EVAL = -1                                                     11794420
          RETURN                                                        11794430
5       CONTINUE                                                        11794500
        I = POP(TSTACK)                                                 11795000
        IF (I.LT.80) GO TO 40                                           11796000
          I = I - 79                                                    11797000
          GO TO (10,20,30), I                                           11798000
C                                                                       11799000
C       ABSOLUTE VALUE, TYPE = 80                                       11800000
C                                                                       11801000
10          CONTINUE                                                    11802000
            EVAL = POP(VSTACK)                                          11803000
            RETURN                                                      11804000
C                                                                       11805000
C       MACHINE INSTRUCTION, TYPE = 81                                  11806000
C                                                                       11807000
20          CONTINUE                                                    11808000
            LEN = POP(LSTACK)                                           11809000
25          CONTINUE                                                    11810000
              EVAL = POP(VSTACK)                                        11811000
              IF (LEN.LE.1) RETURN                                      11812000
              I = POP(TSTACK)                                           11813000
              LEN = LEN - 1                                             11814000
            GO TO 25                                                    11815000
C                                                                       11816000
C       STRING, TYPE = 82                                               11817000
C                                                                       11818000
30          CONTINUE                                                    11819000
            I = POP(VSTACK)                                             11820000
            IF (I.LE.2) GO TO 34                                        11821000
              KJ = I-2                                                  11821900
              DO 32 K = 1,KJ                                            11822000
                J = POP(VSTACK)                                         11823000
32            CONTINUE                                                  11824000
              CALL ERROR(CV)                                            11825000
34          CONTINUE                                                    11826000
            EVAL = POP(VSTACK)                                          11827000
            EVAL = ASCII(EVAL+1)                                        11828000
            IF (I.EQ.1) RETURN                                          11829000
            I = POP(VSTACK)                                             11830000
            EVAL = EVAL + 256 * ASCII(I+1)                              11831000
            RETURN                                                      11832000
C                                                                       11833000
C       IDENTIFIER, TYPE = 0,1,2,3,...                                  11834000
C                                                                       11835000
40      CONTINUE                                                        11836000
          IDN = POP(VSTACK)                                             11837000
          ADDR = POP(VSTACK)                                            11838000
          LEVEL = POP(VSTACK)                                           11839000
          IF (I.NE.0) GO TO 41                                          11840000
            EVAL = 0                                                    11841000
            CALL ERROR(CU)                                              11842000
            RETURN                                                      11843000
41        CONTINUE                                                      11844000
          CALL SYBRK(ADDR+1,EVAL,ITYPE,IM,IR)                           11845000
          CALL SYBLD(ADDR+1,EVAL,ITYPE,IM,0)                            11846000
          RETURN                                                        11847000
        END                                                             11848000
C                                                                       11849000
C**********                                                             11850000
C                                                                       11851000
C       EXIT A SYMBOL TABLE (LEXICAL) BLOCK                             11852000
C                                                                       11853000
C**********                                                             11854000
C                                                                       11855000
        SUBROUTINE EXITB                                                11856000
C                                                                       11857000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11858000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11859000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11860000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11861000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11862000
C                                                                       11863000
        INTEGER IPASS,BLKLVL                                            11864000
        COMMON /PASS/ IPASS,BLKLVL                                      11865000
C                                                                       11866000
        INTEGER                                                         11867000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11868000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11869000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11870000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11871000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11872000
C                                                                       11873000
        COMMON /CSET/                                                   11874000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11875000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11876000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11877000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11878000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11879000
C                                                                       11880000
        INTEGER PTR,LEN,GET,POP,TOS,SP                                  11881000
C                                                                       11882000
        PTR = TOS(MACPRM) * 5                                           11883000
20      CONTINUE                                                        11884000
          LEN = GET(PTR)                                                11885000
          IF (LEN.EQ.PTERM) GO TO 30                                    11886000
          PTR = PTR + LEN + 1                                           11887000
        GO TO 20                                                        11888000
30      CONTINUE                                                        11889000
        FREMEM = PTR/5                                                  11890000
        I = POP(MACPTR)                                                 11891000
        I = POP(MACPRM)                                                 11892000
        I = POP(MACXPN)                                                 11893000
        I = POP(SYMBOT)                                                 11894000
        BLKLVL = SP(SYMBOT) - 1                                         11895000
        RETURN                                                          11896000
        END                                                             11897000
C                                                                       11898000
C**********                                                             11898040
C                                                                       11898060
C       THIS ROUTINE PERFORMS A PRE-SCAN OF                             11898080
C       THE SWITCH LIST, FLAGS ERRORS AND                               11898100
C       TERMINATES THE EXECUTION IF NECESSARY                           11898120
C                                                                       11898140
C**********                                                             11898160
C                                                                       11898180
       SUBROUTINE FILTR                                                 11898182
C                                                                       11898184
        INTEGER PTR,CNPTR,VAL,KK                                        11898200
        LOGICAL PASS                                                    11898210
C                                                                       11898220
        INTEGER LWR(64),UPR(64)                                         11898240
        COMMON /BNDS/ LWR,UPR                                           11898260
C                                                                       11898270
        INTEGER IBUF(120),IBP,IBE                                       11898280
        COMMON /SOURCE/IBUF,IBP,IBE                                     11898285
C                                                                       11898290
        INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                          11898300
        COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                   11898320
C                                                                       11898340
        INTEGER CONTRL(64)                                              11898360
        COMMON /CNTRL/ CONTRL                                           11898380
C                                                                       11898390
        INTEGER IOTRAN(64),ASCII(64)                                    11898400
        COMMON /PORTA/ IOTRAN,ASCII                                     11898405
C                                                                       11898410
       INTEGER                                                          11898420
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11898440
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11898460
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11898480
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11898500
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11898520
C                                                                       11898540
       COMMON /CSET/                                                    11898560
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11898580
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11898600
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11898620
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11898640
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11898660
C                                                                       11898680
C                                                                       11898700
        PASS = .TRUE.                                                   11898720
        PTR = 1                                                         11898730
100     CONTINUE                                                        11898740
          KK = -1                                                       11898750
105       CONTINUE                                                      11898760
        IF (IBUF(PTR).EQ.EOL) GO TO 170                                 11898770
        IF (IBUF(PTR).EQ.DOLLAR) GO TO 110                              11898780
        IF (IBUF(PTR).EQ.BLK)  GO TO 107                                11898790
          PTR = PTR + 1                                                 11898800
          GO TO 180                                                     11898810
107     CONTINUE                                                        11898820
          PTR = PTR + 1                                                 11898830
          GO TO 105                                                     11898840
110     CONTINUE                                                        11898850
        PTR = PTR + 1                                                   11898860
        IF (IBUF(PTR).EQ.EOL) GO TO 170                                 11898870
        CNPTR = IBUF(PTR)                                               11898880
C                                                                       11898900
C       LOOK FOR <$>,<EOL>,<=>                                          11898920
C                                                                       11898940
120     CONTINUE                                                        11898960
        PTR = PTR + 1                                                   11898980
        IF (IBUF(PTR).EQ.DOLLAR) GO TO 150                              11899000
        IF (IBUF(PTR).EQ.EQUAL) GO TO 120                               11899040
        IF (IBUF(PTR).EQ.BLK) GO TO 120                                 11899060
        IF (IBUF(PTR).EQ.EOL) GO TO 150                                 11899065
C                                                                       11899190
C       CONVERT NUMBER                                                  11899200
C                                                                       11899220
        KK = 0                                                          11899240
140     CONTINUE                                                        11899260
        VAL = IBUF(PTR)                                                 11899280
        IF (VAL.EQ.DOLLAR.OR.VAL.EQ.EOL.OR.VAL.EQ.BLK) GO TO 150        11899300
        IF (VAL.LT.N0.OR.VAL.GT.N9) GO TO 180                           11899320
          KK = KK*10 + (VAL-N0)                                         11899340
          PTR = PTR + 1                                                 11899360
          GO TO 140                                                     11899380
C                                                                       11899390
C       CHECK SWITCH RANGES                                             11899400
C                                                                       11899410
150     CONTINUE                                                        11899420
        IF (CNPTR.EQ.DOLLAR) GO TO 170                                  11899430
        IF (CONTRL(CNPTR).LT.0) GO TO 190                               11899460
        IF (KK.EQ.-1) GO TO 160                                         11899470
        IF (KK.GT.UPR(CNPTR)) GO TO 185                                 11899480
        IF (LWR(CNPTR).GT.KK) GO TO 185                                 11899490
          GO TO 170                                                     11899500
160     CONTINUE                                                        11899520
        IF (LWR(CNPTR).EQ.0.AND.UPR(CNPTR).EQ.1) GO TO 170              11899540
          GO TO 195                                                     11899560
170     CONTINUE                                                        11899600
        IF (IBUF(PTR).NE.EOL) GO TO 100                                 11899620
          IF (PASS) RETURN                                              11899640
            WRITE(TTYO,380)                                             11899650
            STOP                                                        11899660
C               ILLEGAL VALUE                                           11899680
180     CONTINUE                                                        11899700
          WRITE(TTYO,300) IOTRAN(CNPTR+1)                               11899720
          GO TO 200                                                     11899740
C               OUT OF RANGE                                            11899760
185     CONTINUE                                                        11899780
          WRITE(TTYO,320) IOTRAN(CNPTR+1),LWR(CNPTR),UPR(CNPTR)         11899800
          GO TO 200                                                     11899820
C               DOES NOT EXIST                                          11899840
190     CONTINUE                                                        11899860
          WRITE(TTYO,340) IOTRAN(CNPTR+1)                               11899880
          GO TO 200                                                     11899900
C               VALUE REQUIRED                                          11899920
195     CONTINUE                                                        11899940
          WRITE(TTYO,360) IOTRAN(CNPTR+1)                               11899960
200     CONTINUE                                                        11899980
        PASS = .FALSE.                                                  11900000
          GO TO 100                                                     11900020
300     FORMAT(1X,8H SWITCH ,A1,24H IN ERROR: ILLEGAL VALUE)            11900060
320     FORMAT(1X,8H SWITCH ,A1,24H IN ERROR: OUT OF RANGE ,            11900080
     1      I3,4H TO ,I3)                                               11900090
340     FORMAT(1X,8H SWITCH ,A1,25H IN ERROR: DOES NOT EXIST)           11900100
360     FORMAT(1X,8H SWITCH ,A1,25H IN ERROR: VALUE REQUIRED)           11900120
380     FORMAT(1X,21H EXECUTION TERMINATED)                             11900140
        END                                                             11900160
C                                                                       11900180
C**********                                                             11900200
C                                                                       11900220
C       GET MACRO TEXT FROM STORAGE                                     11901000
C       PACKED 5 CHAR/WORD, 6 BITS EACH, RIGHT JUSTIFIED                11902000
C                                                                       11903000
C**********                                                             11904000
C                                                                       11905000
        INTEGER FUNCTION GET(ADDR)                                      11906000
C                                                                       11907000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11908000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11909000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11910000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11911000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11912000
C                                                                       11913000
        INTEGER WORD,FIELD,ADDR,SHIFTC,SHR                              11914000
C                                                                       11915000
        WORD = ADDR/5                                                   11916000
        FIELD = MOD(ADDR,5)                                             11917000
        SHIFTC = 24-6*FIELD                                             11918000
        GET = SYMTAB(WORD)                                              11919000
        GET = SHR(GET,SHIFTC)                                           11920000
        GET = MOD(GET,64)                                               11921000
        RETURN                                                          11922000
        END                                                             11923000
C                                                                       11924000
C**********                                                             11925000
C                                                                       11926000
C       GNC - GET NEXT CHARACTER FROM INPUT AND                         11927000
C         TRANSLATE TO INTERNAL CODE                                    11928000
C                                                                       11929000
C**********                                                             11930000
C                                                                       11931000
        INTEGER FUNCTION GNC(IIIII)                                     11932000
C                                                                       11933000
        INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                          11934000
        COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                   11935000
C                                                                       11936000
        INTEGER IOTRAN(64),ASCII(64)                                    11937000
        COMMON /PORTA/ IOTRAN,ASCII                                     11938000
C                                                                       11939000
        INTEGER CONTRL(64)                                              11940000
        COMMON /CNTRL/ CONTRL                                           11941000
C                                                                       11942000
        LOGICAL MACDEF                                                  11943000
        COMMON /MACROS/ MACDEF                                          11944000
C                                                                       11945000
        INTEGER IPASS,BLKLVL                                            11946000
        COMMON /PASS/ IPASS,BLKLVL                                      11947000
C                                                                       11948000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  11949000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        11950000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           11951000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               11952000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   11953000
C                                                                       11954000
        INTEGER                                                         11955000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11956000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11957000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11958000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11959000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11960000
C                                                                       11961000
        COMMON /CSET/                                                   11962000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          11963000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     11964000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        11965000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     11966000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        11967000
C                                                                       11968000
        INTEGER IBUF(120),IBP,IBE                                       11969000
        COMMON /SOURCE/ IBUF,IBP,IBE                                    11970000
C                                                                       11971000
        INTEGER UNIT,FIRST,LAST,GET,PTR,LEN,PRMNO                       11972000
        INTEGER I,II,J,JJ,K,KK,L                                        11973000
C                                                                       11973010
        INTEGER BLANK                                                   11973900
        INTEGER ASMB(31),ASMBL,ERMSG(10),ERML,ERTOT(17),ERTL,PAGES(6)   11973910
        INTEGER BEGIN(13)                                               11974000
        COMMON /MSG/ ASMB,ASMBL,ERML,ERMSG,ERTOT,ERTL,PAGES,BEGIN       11974010
C                                                                       11974020
        DATA BLANK/1H /                                                 11974100
C       DATA BEGIN(1)/0/,BEGIN(2)/34/,BEGIN(3)/37/                      11975000
C       DATA BEGIN(4)/39/,BEGIN(5)/41/,BEGIN(6)/46/                     11975100
C       DATA BEGIN(7)/0/,BEGIN(8)/48/,BEGIN(9)/33/                      11975200
C       DATA BEGIN(10)/51/,BEGIN(11)/51/,BEGIN(12)/0/                   11975300
C       DATA BEGIN(13)/17/                                              11975400
C                                                                       **TEST**
C       INTEGER VSTACK(69),VSTKL                                        **TEST**
C       COMMON /VST/ VSTACK,VSTKL                                       **TEST**
C                                                                       11976000
10      CONTINUE                                                        11977000
        IF (IBP.GT.IBE) GO TO 120                                       11978000
          GNC = IBUF(IBP)                                               11979000
          IBP = IBP + 1                                                 11980000
          IF ((.NOT.MACDEF).OR.IPASS.EQ.2) GO TO 30                     11981000
            CALL PUT(GNC,MACPTR(BLKLVL+1))                              11982000
            MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1) + 1                     11983000
            SYMAX = MACPTR(BLKLVL+1) / 5 + 1                            11984000
            IF (SYMAX.LE.FREMEM-1) GO TO 20                             11985000
              CALL ERROR(CT)                                            11986000
              SYMAX = FREMEM - 1                                        11987000
              MACPTR(BLKLVL+1) = SYMAX * 5                              11988000
20          CONTINUE                                                    11989000
30        CONTINUE                                                      11990000
          RETURN                                                        12031000
C                                                                       12032000
C       GET NEXT LINE                                                   12033000
C                                                                       12034000
120     CONTINUE                                                        12035000
        IF (MACXPN(BLKLVL+1).EQ.0) GO TO 140                            12036000
C                                                                       12037000
C       MACRO EXPANSION, GET TEXT FROM MEMORY                           12038000
C                                                                       12039000
          IBP = 1                                                       12040000
          IBE = 1                                                       12041000
130       CONTINUE                                                      12042000
            IBUF(IBE) = GET(MACPTR(BLKLVL+1))                           12043000
            MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1) + 1                     12044000
C                                                                       12044005
C  CHECK FOR MACRO PARAMETER SUBSTITUTION                               12044006
C                                                                       12044007
            IF (IBUF(IBE).NE.FORMAL) GO TO 138                          12044020
              PRMNO = GET(MACPTR(BLKLVL+1))                             12044040
              MACPTR(BLKLVL+1) = MACPTR(BLKLVL+1) + 1                   12044060
              PTR = MACPRM(BLKLVL+1) * 5                                12044080
132           CONTINUE                                                  12044100
                LEN = GET(PTR)                                          12044120
                IF (LEN.EQ.PTERM) GO TO 130                             12044140
                PTR = PTR + 1                                           12044160
                IF (PRMNO.EQ.1) GO TO 134                               12044180
                PTR = PTR + LEN                                         12044200
                PRMNO = PRMNO - 1                                       12044220
                GO TO 132                                               12044240
134           CONTINUE                                                  12044260
              LEN = LEN - 1                                             12044280
              DO 136 I = 1,LEN                                          12044300
                IBUF(IBE) = GET(PTR)                                    12044320
                PTR = PTR + 1                                           12044340
                IF (IBE.LT.120) IBE = IBE + 1                           12044360
136           CONTINUE                                                  12044380
              GO TO 130                                                 12044400
138         CONTINUE                                                    12044420
            IF (IBUF(IBE).EQ.EOL) GO TO 260                             12045000
            IF (IBE.LT.120) IBE = IBE + 1                               12046000
          GO TO 130                                                     12047000
140     CONTINUE                                                        12048000
C                                                                       12049000
C       GET TEXT FROM INPUT DEVICE                                      12050000
C                                                                       12051000
        FIRST = CONTRL(CL)                                              12052000
        LAST = CONTRL(CR)                                               12053000
        UNIT = CONTRL(CI)                                               12054000
        IF (UNIT.GT.0.AND.UNIT.LT.3) GO TO 160                          12055000
          WRITE(TTYO,150)                                               12056000
150       FORMAT (28H ILLEGAL INPUT SPECIFICATION)                      12057000
          STOP                                                          12058000
160     CONTINUE                                                        12059000
        GO TO (170,190), UNIT                                           12060000
C                                                                       12061000
C       TERMINAL INPUT STREAM                                           12062000
C                                                                       12063000
170     CONTINUE                                                        12064000
        READ(TTYI,180) IBUF                                             12065000
180     FORMAT(120A1)                                                   12066000
        GO TO 200                                                       12067000
C                                                                       12068000
C       FILE INPUT STREAM                                               12069000
C                                                                       12070000
190     CONTINUE                                                        12071000
        READ(INPUT,180) IBUF                                            12072000
200     CONTINUE                                                        12073000
C                                                                       12074000
C       STRIP TRAILING BLANKS                                           12075000
C                                                                       12076000
        DO 210 I = 1,LAST                                               12077000
          IBE = LAST + 1 - I                                            12078000
          IF (IBUF(IBE).NE.BLANK) GO TO 220                             12079000
210     CONTINUE                                                        12080000
220     CONTINUE                                                        12081000
        LAST = IBE                                                      12082000
        IBP = 1                                                         12083000
C                                                                       12084000
C       CONVERT TO INTERNAL CHARACTER SET, ALSO SHIFT OFF               12085000
C       CHARACTERS CHOPPED BY LEFTMARGIN                                12086000
C                                                                       12087000
        IBE = 0                                                         12088000
        DO 250 I = FIRST,LAST                                           12089000
          IBE = IBE + 1                                                 12090000
          DO 230 J = 1,64                                               12091000
            JJ = J - 1                                                  12092000
            IF (IBUF(I).EQ.IOTRAN(J)) GO TO 240                         12093000
230       CONTINUE                                                      12094000
          JJ = 0                                                        12095000
240       CONTINUE                                                      12096000
          IBUF(IBE) = JJ                                                12097000
250     CONTINUE                                                        12098000
        IBE = IBE + 1                                                   12099000
        IBUF(IBE) = EOL                                                 12100000
C                                                                       12101000
C       PROCESS '$' RUN OPTIONS                                         12102000
C                                                                       12103000
260     CONTINUE                                                        12104000
        IF (IBUF(IBP).NE.DOLLAR) GO TO 380                              12105000
           IF (.NOT.MACDEF) GO TO 262                                   12106000
C                                                                       12107000
C       DEFER PROCESSING OF CONTRL COMMANDS UNTIL MACRO EXPANSION       12108000
C                                                                       12109000
            GNC = SEMI                                                  12110000
            RETURN                                                      12111000
262     CONTINUE                                                        12111010
           IF (IBP.EQ.1) CALL FILTR                                     12111020
264       CONTINUE                                                      12112000
          IBE = IBP - 1                                                 12113000
          IBP = IBP + 1                                                 12114000
          J = IBUF(IBP)                                                 12115000
          IF (J.EQ.BLK) GO TO 360                                       12117000
          IF (J.NE.DOLLAR) GO TO 270                                    12118000
            CALL DDUMP                                                  12119000
            IBP = IBP + 1                                               12120000
            GO TO 360                                                   12121000
270       CONTINUE                                                      12122000
          IBP = IBP +1                                                  12122100
C                                                                       12123000
C       SEARCH FOR '$',EOL, OR '='                                      12124000
C                                                                       12125000
280       CONTINUE                                                      12126000
          IF (IBUF(IBP).EQ.EOL) GO TO 285                               12127000
          IF (IBUF(IBP).NE.DOLLAR) GO TO 300                            12128000
285       CONTINUE                                                      12129000
            IF (CONTRL(J).GT.1.OR.CONTRL(J).LT.0) GO TO 290             12130000
              CONTRL(J) = 1 - CONTRL(J)                                 12131000
              GO TO 260                                                 12132000
290         CONTINUE                                                    12133000
            GO TO 260                                                   12134000
300       CONTINUE                                                      12135000
          IF (IBUF(IBP).NE.EQUAL) GO TO 370                             12136000
            IBP = IBP + 1                                               12137000
310         CONTINUE                                                    12138000
            IF (IBUF(IBP).NE.BLK) GO TO 320                             12139000
              IBP = IBP + 1                                             12140000
              GO TO 310                                                 12141000
320         CONTINUE                                                    12142000
            K = 0                                                       12143000
330         CONTINUE                                                    12144000
            L = IBUF(IBP)                                               12145000
            IF (L.LT.N0.OR.L.GT.N9) GO TO 340                           12146000
              K = K * 10 + (L - N0)                                     12147000
              IBP = IBP + 1                                             12148000
              GO TO 330                                                 12149000
340         CONTINUE                                                    12150000
            IF (CONTRL(J).LT.0) GO TO 360                               12151000
              IF (J.NE.CI) GO TO 355                                    12152000
                IF (K.EQ.CONTRL(CI)) GO TO 350                          12153000
C                 CALL PUSH(VSTACK,CONTRL(CP),VSTKL)                    **TEST**
C                 CONTRL(CP) = 1                                        **TEST**
                  CALL APPEND(BEGIN,13)                                 12154000
                  CALL OUTPUT(1)                                        12155000
                  CALL OUTPUT(1)                                        12156000
C                 CONTRL(CP) = POP(VSTACK)                              **TEST**
350             CONTINUE                                                12157000
355           CONTINUE                                                  12158000
              CONTRL(J) = K                                             12159000
360         CONTINUE                                                    12160000
            IF (IBUF(IBP).EQ.EOL) GO TO 10                              12161000
            IF (IBUF(IBP).EQ.DOLLAR) GO TO 260                          12162000
              IBP = IBP + 1                                             12163000
              GO TO 360                                                 12164000
370       CONTINUE                                                      12165000
          IBP = IBP + 1                                                 12166000
          GO TO 280                                                     12167000
380     CONTINUE                                                        12168000
        GO TO 10                                                        12169000
        END                                                             12170000
C                                                                       12170100
C**********                                                             12170110
C                                                                       12170120
C       INITIALIZE OPCODE HASH TABLE                                    12170130
C                                                                       12170140
C**********                                                             12170150
C                                                                       12170160
        SUBROUTINE HASHB                                                12170170
C                                                                       12170180
        INTEGER OPTAB(194),OPTL                                         12170190
        COMMON /OPCODE/ OPTAB,OPTL                                      12170200
C                                                                       12170210
        INTEGER BUCKET(256)                                             12170220
        COMMON /HASHT/ BUCKET                                           12170230
C                                                                       12170240
C       FILL BUCKETS WITH INITIAL VALUE                                 12170270
C                                                                       12170280
        DO 10 I = 1,256                                                 12170290
          BUCKET(I) = 0                                                 12170300
10      CONTINUE                                                        12170310
C                                                                       12170320
C       GENERATE HASH FOR EACH OPCODE, LINK TOGETHER                    12170330
C                                                                       12170340
        DO 30 I = 1,OPTL,2                                              12170350
          IH = 0                                                        12170360
          KJ = OPTAB(I)                                                 12170370
          DO 20 J = 1,5                                                 12170380
            IH = IH + MOD(KJ,64)                                        12170390
            KJ = KJ/64                                                  12170400
20        CONTINUE                                                      12170410
          IH = MOD(IH,255) + 1                                          12170420
          INDEX = BUCKET(IH)                                            12170440
          OPTAB(I+1) = 256*OPTAB(I+1) + INDEX                           12170460
          BUCKET(IH) = I                                                12170490
30      CONTINUE                                                        12170500
        RETURN                                                          12170520
        END                                                             12170530
C                                                                       12171000
C**********                                                             12172000
C                                                                       12173000
C       CONVERT ENCODED IDENTIFIER TO INTERNAL BUFFER                   12174000
C                                                                       12175000
C**********                                                             12176000
C                                                                       12177000
        SUBROUTINE ICON(I1,JK,IBUF)                                     12178000
C                                                                       12179000
        INTEGER                                                         12180000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12181000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12182000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12183000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12184000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12185000
C                                                                       12186000
        COMMON /CSET/                                                   12187000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12188000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12189000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12190000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12191000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12192000
C                                                                       12193000
        INTEGER RIGHT,SHR,IBUF(5)                                       12194000
C                                                                       12195000
        JK = 0                                                          12196000
        DO 10 J = 1,5                                                   12197000
          I3 = 30-6*J                                                   12198000
          I3 = SHR(I1,I3)                                               12199000
          I3 = RIGHT(I3,6)                                              12200000
          IF (I3.NE.BLK) JK = JK + 1                                    12201000
          IBUF(J) = I3                                                  12202000
10      CONTINUE                                                        12203000
        RETURN                                                          12204000
        END                                                             12205000
C                                                                       12206000
C**********                                                             12207000
C                                                                       12208000
C       COLLECT IDENTIFIER                                              12209000
C                                                                       12210000
C**********                                                             12211000
C                                                                       12212000
        INTEGER FUNCTION IDENT(IH,CHAR,LEN)                             12213000
C                                                                       12214000
        INTEGER GNC,CHAR                                                12215000
C                                                                       12216000
        INTEGER                                                         12217000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12218000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12219000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12220000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12221000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12222000
C                                                                       12223000
        COMMON /CSET/                                                   12224000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12225000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12226000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12227000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12228000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12229000
C                                                                       12230000
        IDENT = 0                                                       12231000
        IH = 0                                                          12231100
        LEN = 0                                                         12232000
10      IF (IDENT.LT.16777216) IDENT = IDENT * 64 + CHAR                12233000
          LEN = LEN + 1                                                 12234000
          IH = IH + CHAR                                                12234100
          CHAR = GNC(0)                                                 12235000
          IF (CHAR.GE.QUES.AND.CHAR.LE.CZ) GO TO 10                     12236000
          IF (CHAR.GE.N0.AND.CHAR.LE.N9) GO TO 10                       12237000
          CALL BACKUP                                                   12238000
20      IF (IDENT.GE.16777216) GO TO 30                                 12239000
          IDENT = IDENT * 64 + BLK                                      12240000
          GO TO 20                                                      12241000
30      CONTINUE                                                        12242000
        IH = MOD(IH,255) + 1                                            12242100
        RETURN                                                          12243000
        END                                                             12244000
C                                                                       12245000
C**********                                                             12246000
C                                                                       12247000
C       INUM - CONVERT BINARY NUMBER TO STRING                          12248000
C                                                                       12249000
C**********                                                             12250000
C                                                                       12251000
        SUBROUTINE INUM(VALUE,BASE,LENGTH,IBUF,I1)                      12252000
C                                                                       12253000
        INTEGER VALUE,BASE,LENGTH                                       12254000
C                                                                       12255000
        INTEGER IBUF(1),IVALUE                                          12256000
C                                                                       12257000
        INTEGER                                                         12258000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12259000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12260000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12261000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12262000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12263000
C                                                                       12264000
        COMMON /CSET/                                                   12265000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12266000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12267000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12268000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12269000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12270000
C                                                                       12271000
        I1 = LENGTH                                                     12272000
        IF (I1.GT.20) I1 = 20                                           12273000
        IVALUE = VALUE                                                  12274000
        DO 10 I2 = 1,I1                                                 12275000
          I3 = I1 + 1 - I2                                              12276000
          I4 = MOD(IVALUE,BASE) + N0                                    12277000
          IF (I4.GT.N9) I4 = I4 + 7                                     12278000
          IVALUE = IVALUE / BASE                                        12279000
          IBUF(I3) = I4                                                 12280000
10      CONTINUE                                                        12281000
        RETURN                                                          12282000
        END                                                             12283000
C                                                                       12284000
C**********                                                             12285000
C                                                                       12286000
C       LOOK UP USER DEFINED IDENTIFIER                                 12287000
C                                                                       12288000
C**********                                                             12289000
C                                                                       12290000
        SUBROUTINE LOOKUP(IDN,ADDR,TYPE,LEVEL)                          12291000
C                                                                       12292000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  12293000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        12294000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           12295000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               12296000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   12297000
C                                                                       12298000
        INTEGER IPASS,BLKLVL                                            12299000
        COMMON /PASS/ IPASS,BLKLVL                                      12300000
C                                                                       12301000
        INTEGER                                                         12302000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12303000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12304000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12305000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12306000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12307000
C                                                                       12308000
        COMMON /CSET/                                                   12309000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12310000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12311000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12312000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12313000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12314000
C                                                                       12315000
        INTEGER IDN,ADDR,TYPE,LEVEL                                     12316000
        INTEGER LOWER,UPPER                                             12317000
C                                                                       12318000
C       SEARCH INNERMOST BLOCK FIRST, THEN BLOCK 1                      12319000
C                                                                       12320000
        TYPE = 0                                                        12321000
        LEVEL = BLKLVL                                                  12322000
        ADDR = 0                                                        12323000
10      CONTINUE                                                        12324000
          LINK = SYMBOT(LEVEL+1)                                        12325000
          LOWER = LINK + 1                                              12326000
          UPPER = LINK + SYMTAB(LINK) - 2                               12327000
          IF (SYMTAB(LINK).EQ.1) GO TO 60                               12328000
          IF (IDN.LT.SYMTAB(LOWER)) GO TO 60                            12329000
          IF (IDN.GT.SYMTAB(UPPER)) GO TO 60                            12330000
          ADDR = LOWER                                                  12331000
          IF (IDN.EQ.SYMTAB(LOWER)) GO TO 50                            12332000
          ADDR = UPPER                                                  12333000
          IF (IDN.EQ.SYMTAB(UPPER)) GO TO 50                            12334000
            DO 30 I = LOWER,UPPER,2                                     12335000
              ADDR = I                                                  12336000
              IF (IDN.EQ.SYMTAB(I)) GO TO 50                            12337000
30          CONTINUE                                                    12338000
            GO TO 60                                                    12339000
50          CONTINUE                                                    12340000
            CALL SYBRK(ADDR+1,IVAL,TYPE,IM,IR)                          12341000
            IF (IM.NE.0) CALL ERROR(CM)                                 12342000
            RETURN                                                      12343000
60        CONTINUE                                                      12344000
          IF (LEVEL.EQ.1) RETURN                                        12345000
          LEVEL = 1                                                     12346000
          GO TO 10                                                      12347000
        END                                                             12348000
C                                                                       12349000
C**********                                                             12350000
C                                                                       12351000
C       LIST MACRO BODY FROM STORAGE                                    12352000
C                                                                       12353000
C**********                                                             12354000
C                                                                       12355000
        SUBROUTINE MACDMP(MACNAM,ADDR)                                  12356000
C                                                                       12357000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  12358000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        12359000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           12360000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               12361000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   12362000
C                                                                       12363000
        INTEGER CONTRL(64)                                              12364000
        COMMON /CNTRL/ CONTRL                                           12365000
C                                                                       12366000
        INTEGER                                                         12367000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12368000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12369000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12370000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12371000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12372000
C                                                                       12373000
        COMMON /CSET/                                                   12374000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12375000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12376000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12377000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12378000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12379000
C                                                                       12380000
        INTEGER MACNAM,LOC,PTR,CHAR,GET,ADDR                            12381000
        INTEGER MACHDR(15),MACHDL                                       12381100
        INTEGER FREHED(9),FREEL                                         12381200
        INTEGER HDR(15),LEN                                             12381300
C                                                                       12382000
C       'DUMP OF MACRO '                                                12383000
C                                                                       12384000
        DATA MACHDL /15/                                                12385000
        DATA MACHDR(1)/0/,MACHDR(2)/36/,MACHDR(3)/53/                   12386000
        DATA MACHDR(4)/45/,MACHDR(5)/48/,MACHDR(6)/0/                   12387000
        DATA MACHDR(7)/47/,MACHDR(8)/38/,MACHDR(9)/0/                   12387100
        DATA MACHDR(10)/45/,MACHDR(11)/33/,MACHDR(12)/35/               12387200
        DATA MACHDR(13)/50/,MACHDR(14)/47/,MACHDR(15)/0/                12387300
C                                                                       12388000
C       'FREMEM = '                                                     12389000
C                                                                       12390000
        DATA FREEL /9/                                                  12391000
        DATA FREHED(1)/38/,FREHED(2)/50/,FREHED(3)/37/                  12392000
        DATA FREHED(4)/45/,FREHED(5)/37/,FREHED(6)/45/                  12392500
        DATA FREHED(7)/0/,FREHED(8)/29/,FREHED(9)/0/                    12393000
C                                                                       12394000
C       ' LOC  PTR  TEXT'                                               12395000
C                                                                       12395100
        DATA LEN /15/                                                   12396000
        DATA HDR(1)/0/,HDR(2)/44/,HDR(3)/47/                            12397000
        DATA HDR(4)/35/,HDR(5)/0/,HDR(6)/0/                             12397500
        DATA HDR(7)/48/,HDR(8)/52/,HDR(9)/50/                           12398000
        DATA HDR(10)/0/,HDR(11)/0/,HDR(12)/52/                          12398500
        DATA HDR(13)/37/,HDR(14)/56/,HDR(15)/52/                        12399000
C                                                                       12400000
        CALL OUTPUT(CONTRL(CM))                                         12401000
        CALL APPEND(MACHDR,MACHDL)                                      12402000
        CALL CONID(MACNAM,IX)                                           12403000
        CALL PAD(BLK,1)                                                 12404000
        CALL APPEND(FREHED,FREEL)                                       12405000
        CALL NUMBER(FREMEM,10,4)                                        12406000
        CALL OUTPUT(CONTRL(CM))                                         12407000
        CALL OUTPUT(CONTRL(CM))                                         12408000
        CALL APPEND(HDR,LEN)                                            12409000
        CALL OUTPUT(CONTRL(CM))                                         12410000
        CALL OUTPUT(CONTRL(CM))                                         12411000
        CALL SYBRK(ADDR+1,LOC,ITYPE,IM,IR)                              12412000
        PTR = LOC * 5                                                   12413000
10      CONTINUE                                                        12414000
          CALL PAD(BLK,1)                                               12415000
          CALL NUMBER(LOC,10,4)                                         12416000
          CALL PAD(BLK,1)                                               12417000
          CALL NUMBER(PTR,10,5)                                         12418000
          CALL PAD(BLK,2)                                               12419000
20        CONTINUE                                                      12420000
            CHAR = GET(PTR)                                             12421000
            PTR = PTR + 1                                               12422000
            LOC = PTR/5                                                 12423000
            IF (CHAR.NE.TERM) GO TO 30                                  12424000
              CALL PAD(MINUS,3)                                         12425000
              CALL OUTPUT(CONTRL(CM))                                   12426000
              RETURN                                                    12427000
30          CONTINUE                                                    12428000
            IF (CHAR.NE.FORMAL) GO TO 40                                12429000
              CALL PAD(PERCT,1)                                         12430000
              CHAR = GET(PTR)                                           12431000
              PTR = PTR + 1                                             12432000
              CALL NUMBER(CHAR,10,2)                                    12433000
              GO TO 20                                                  12434000
40          CONTINUE                                                    12435000
            CALL PAD(CHAR,1)                                            12436000
            IF (CHAR.NE.EOL) GO TO 20                                   12437000
            LOC = PTR / 5                                               12438000
            CALL OUTPUT(CONTRL(CM))                                     12439000
        GO TO 10                                                        12440000
        END                                                             12441000
C                                                                       12442000
C**********                                                             12443000
C                                                                       12444000
C       LOGICAL OR FUNCTION, (MAXIMUM 30 BITS)                          12445000
C                                                                       12446000
C**********                                                             12447000
C                                                                       12448000
        INTEGER FUNCTION ORF(II,JJ)                                     12449000
C                                                                       12450000
        I = II                                                          12451000
        J = JJ                                                          12452000
        JK = 1                                                          12453000
        ORF = 0                                                         12454000
        DO 1 K  = 1,30                                                  12455000
            KK = 0                                                      12456000
            MM = MOD(I,2)                                               12457000
            NN = MOD(J,2)                                               12458000
            IF (MM.EQ.1.OR.NN.EQ.1) KK = 1                              12459000
            I = I/2                                                     12460000
            J = J/2                                                     12461000
            ORF = ORF + KK * JK                                         12462000
            JK = JK + JK                                                12463000
1       CONTINUE                                                        12464000
        RETURN                                                          12465000
        END                                                             12466000
C                                                                       12467000
C**********                                                             12468000
C                                                                       12469000
C       OUTPUT - OUTPUT A LINE                                          12470000
C                                                                       12471000
C**********                                                             12472000
C                                                                       12473000
        SUBROUTINE OUTPUT(CHAN)                                         12474000
C                                                                       12475000
        INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                          12476000
        COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                   12477000
C                                                                       12478000
        INTEGER CONTRL(64)                                              12479000
        COMMON /CNTRL/ CONTRL                                           12480000
C                                                                       12481000
        INTEGER IOTRAN(64),ASCII(64)                                    12482000
        COMMON /PORTA/ IOTRAN,ASCII                                     12483000
C                                                                       12484000
        INTEGER                                                         12485000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12486000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12487000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12488000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12489000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12490000
C                                                                       12491000
        COMMON /CSET/                                                   12492000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12493000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12494000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12495000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12496000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12497000
C                                                                       12498000
        INTEGER CHAN                                                    12499000
        INTEGER I,K                                                     12500000
C                                                                       12501000
        INTEGER OBUF,OBP                                                12502000
        COMMON /OUTBUF/ OBUF(132),OBP                                   12503000
C                                                                       12504000
        IF (CHAN.GT.0.AND.CHAN.LT.5) GO TO 100                          12505000
          WRITE(TTYO,50)                                                12506000
50        FORMAT(29H ILLEGAL OUTPUT SPECIFICATION)                      12507000
          STOP                                                          12508000
100     CONTINUE                                                        12509000
        IF (OBP.GT.CONTRL(CW)) OBP = CONTRL(CW)                         12510000
        IF (CONTRL(CP).EQ.0) GO TO 450                                  12511000
          DO 150 I = 1,OBP                                              12512000
            K = OBUF(I)+1                                               12513000
            OBUF(I) = IOTRAN(K)                                         12514000
150       CONTINUE                                                      12515000
          GO TO(200,250,300,350),CHAN                                   12516000
C                                                                       12517000
C       TERMINAL OUTPUT STREAM                                          12518000
C                                                                       12519000
200         WRITE(TTYO,400)(OBUF(I),I = 1,OBP)                          12520000
            GO TO 450                                                   12521000
C                                                                       12522000
C       HEXADECIMAL OBJECT CODE FILE STREAM                             12523000
C                                                                       12524000
250         WRITE(HEX,400)(OBUF(I),I = 1,OBP)                           12525000
            GO TO 450                                                   12526000
C                                                                       12527000
C       LISTING FILE STREAM                                             12528000
C                                                                       12529000
300         WRITE(LIST,400)(OBUF(I),I = 1,OBP)                          12530000
            GO TO 450                                                   12531000
C                                                                       12532000
C       TEST MODE LOG FILE                                              12533000
C                                                                       12534000
350         WRITE(ERLOG,400)(OBUF(I),I = 1,OBP)                         12535000
            GO TO 450                                                   12536000
400       FORMAT(132A1)                                                 12537000
450     CONTINUE                                                        12538000
        IF (OBP.LT.1) OBP = 1                                           12538100
        DO 500 I = 1,OBP                                                12539000
          OBUF(I) = BLK                                                 12540000
500     CONTINUE                                                        12541000
        OBP = 0                                                         12542000
        RETURN                                                          12543000
        END                                                             12544000
C                                                                       12545000
C**********                                                             12546000
C                                                                       12547000
C       LOGICAL NOT FUNCTION, (MAXIMUM 30 BITS)                         12548000
C                                                                       12549000
C**********                                                             12550000
C                                                                       12551000
        INTEGER FUNCTION NOTF(II)                                       12552000
C                                                                       12553000
        I = II                                                          12554000
        JK = 1                                                          12555000
        NOTF = 0                                                        12556000
        DO 1 K  = 1,30                                                  12557000
            NOTF = NOTF + (1-MOD(I,2)) * JK                             12558000
            I = I/2                                                     12559000
            JK = JK + JK                                                12560000
1       CONTINUE                                                        12561000
        RETURN                                                          12562000
        END                                                             12563000
C                                                                       12564000
C**********                                                             12565000
C                                                                       12566000
C       NUMBER - CONVERT BINARY NUMBER TO STRING                        12567000
C                                                                       12568000
C**********                                                             12569000
C                                                                       12570000
        SUBROUTINE NUMBER(VALUE,BASE,LENGTH)                            12571000
C                                                                       12572000
        INTEGER VALUE,BASE,LENGTH                                       12573000
C                                                                       12574000
        INTEGER IBUF(20)                                                12575000
C                                                                       12576000
        CALL INUM(VALUE,BASE,LENGTH,IBUF,I1)                            12577000
        CALL APPEND(IBUF,I1)                                            12578000
        RETURN                                                          12579000
        END                                                             12580000
C                                                                       12581000
C**********                                                             12582000
C                                                                       12583000
C       OPCODE AND OPERATOR TABLE LOOKUP                                12584000
C       RETURN FUNCTION VALUE = TRUE IF MATCH IS FOUND                  12585000
C                                                                       12586000
C**********                                                             12587000
C                                                                       12588000
        LOGICAL FUNCTION OPSRCH(IH,IDN,OPVAL,OPTYPE)                    12589000
C                                                                       12590000
        INTEGER OPTAB(194),OPTL                                         12591000
        COMMON /OPCODE/ OPTAB,OPTL                                      12592000
C                                                                       12592100
        INTEGER BUCKET(256)                                             12592200
        COMMON /HASHT/ BUCKET                                           12592300
C                                                                       12593000
        INTEGER OPVAL,OPTYPE                                            12594000
C                                                                       12595000
        OPSRCH = .FALSE.                                                12596000
C                                                                       12597000
        INDEX = BUCKET(IH)                                              12599000
10      CONTINUE                                                        12600000
          IF (INDEX.EQ.0) RETURN                                        12601000
          IF (IDN.EQ.OPTAB(INDEX)) GO TO 20                             12602000
          INDEX = MOD(OPTAB(INDEX+1),256)                               12603000
          GO TO 10                                                      12604000
C                                                                       12612000
C       FOUND A MATCH                                                   12613000
C                                                                       12614000
20      CONTINUE                                                        12615000
        OPSRCH = .TRUE.                                                 12616000
        OPVAL = OPTAB(INDEX+1)/256                                      12617000
        OPTYPE = MOD(OPVAL,100)                                         12618000
        OPVAL = OPVAL/100                                               12619000
        RETURN                                                          12620000
        END                                                             12621000
C                                                                       12622000
C**********                                                             12623000
C                                                                       12624000
C       PASS 1 SYMBOL TABLE DUMP TO HEX FILE FOR INTERP                 12625000
C                                                                       12626000
C**********                                                             12627000
C                                                                       12628000
        SUBROUTINE P1DUMP                                               12629000
C                                                                       12630000
        INTEGER OBUF,OBP                                                12631000
        COMMON /OUTBUF/ OBUF(132),OBP                                   12632000
C                                                                       12633000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  12634000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        12635000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           12636000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               12637000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   12638000
C                                                                       12639000
        INTEGER CONTRL(64)                                              12640000
        COMMON /CNTRL/ CONTRL                                           12641000
C                                                                       12642000
        INTEGER GNC,POP,SHL,SHR,VALUE,CONNUM                            12643000
        INTEGER ANDF,ORF,XORF,NOTF,RIGHT,TOS                            12644000
C                                                                       12645000
        INTEGER                                                         12646000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12647000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12648000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12649000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12650000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12651000
C                                                                       12652000
        COMMON /CSET/                                                   12653000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12654000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12655000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12656000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12657000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12658000
C                                                                       12659000
C       'BLOCKXX'                                                       12660000
C                                                                       12661000
        INTEGER BLOCK(5)                                                12662000
        DATA BLOCK(1)/34/,BLOCK(2)/44/,BLOCK(3)/47/                     12663000
        DATA BLOCK(4)/35/,BLOCK(5)/43/                                  12663100
C                                                                       12664000
C       PASS 1 SYMBOL DUMP                                              12665000
C                                                                       12666000
        LEVEL = 1                                                       12667000
        LINK1 = 1                                                       12668000
        NO = 1                                                          12669000
10      CONTINUE                                                        12670000
          CALL PAD(BLK,1)                                               12671000
          CALL NUMBER(NO,10,3)                                          12672000
          CALL PAD(BLK,1)                                               12673000
          NO = NO + 1                                                   12674000
          CALL APPEND(BLOCK,5)                                          12675000
          CALL NUMBER(LEVEL,10,2)                                       12676000
          CALL PAD(BLK,1)                                               12677000
          CALL NUMBER(0,10,1)                                           12678000
          II = CONTRL(CP)                                               12679000
          CONTRL(CP) = 1                                                12680000
          CALL OUTPUT(2)                                                12681000
          CONTRL(CP) = II                                               12682000
          LINK = SYMTAB(LINK1) + LINK1                                  12683000
          IF (SYMTAB(LINK1).EQ.1) GO TO 30                              12684000
            KI = LINK1+1                                                12684100
            KJ = LINK-2                                                 12684200
            DO 20 I = KI,KJ,2                                           12685000
              I1 = SYMTAB(I)                                            12686000
              CALL SYBRK(I+1,I2,ITYPE,IM,IR)                            12687000
              CALL PAD(BLK,1)                                           12691000
              CALL NUMBER(NO,10,3)                                      12692000
              CALL PAD(BLK,1)                                           12693000
              NO = NO + 1                                               12694000
              CALL CONID(I1,IX)                                         12695000
              CALL PAD(BLK,1)                                           12696000
              CALL NUMBER(I2,16,4)                                      12697000
              CALL PAD(CH,1)                                            12698000
              II = CONTRL(CP)                                           12699000
              CONTRL(CP) = 1                                            12700000
              CALL OUTPUT(2)                                            12701000
              CONTRL(CP) = II                                           12702000
20          CONTINUE                                                    12703000
30        CONTINUE                                                      12704000
          LINK1 = LINK                                                  12705000
          LEVEL = LEVEL + 1                                             12706000
          IF (LINK.LT.SYMAX.AND.SYMTAB(LINK).NE.0) GO TO 10             12707000
        CALL PAD(DOLLAR,1)                                              12708000
        II = CONTRL(CP)                                                 12709000
        CONTRL(CP) = 1                                                  12710000
        CALL OUTPUT(2)                                                  12711000
        CONTRL(CP) = II                                                 12712000
        RETURN                                                          12713000
        END                                                             12714000
C                                                                       12715000
C**********                                                             12716000
C                                                                       12717000
C       PASS 2 SYMBOL TABLE DUMP TO LISTING                             12718000
C                                                                       12719000
C**********                                                             12720000
C                                                                       12721000
        SUBROUTINE P2DUMP(PAGE,TITLE,TLEN)                              12722000
C                                                                       12722100
        INTEGER PAGE,TLEN,TITLE(TLEN)                                   12722200
C                                                                       12723000
        INTEGER OBUF,OBP                                                12724000
        COMMON /OUTBUF/ OBUF(132),OBP                                   12725000
C                                                                       12726000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  12727000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        12728000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           12729000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               12730000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   12731000
C                                                                       12732000
        INTEGER CONTRL(64)                                              12733000
        COMMON /CNTRL/ CONTRL                                           12734000
C                                                                       12735000
        INTEGER SHR,RIGHT                                               12736000
C                                                                       12737000
        INTEGER                                                         12738000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12739000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12740000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12741000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12742000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12743000
C                                                                       12744000
        COMMON /CSET/                                                   12745000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12746000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12747000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12748000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12749000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12750000
C                                                                       12751000
        INTEGER SYMH(36),SYMHL                                          12752000
C                                                                       12753000
C       '       SYMBOL TABLE'                                           12754000
C                                                                       12755000
        DATA SYMHL /36/                                                 12756000
        DATA SYMH(1)/0/,SYMH(2)/0/,SYMH(3)/0/,SYMH(4)/0/                12756100
        DATA SYMH(5)/0/,SYMH(6)/0/,SYMH(7)/0/,SYMH(8)/0/                12756200
        DATA SYMH(9)/0/,SYMH(10)/0/,SYMH(11)/0/,SYMH(12)/0/             12756300
        DATA SYMH(13)/0/,SYMH(14)/0/,SYMH(15)/0/,SYMH(16)/0/            12756400
        DATA SYMH(17)/0/,SYMH(18)/0/,SYMH(19)/0/,SYMH(20)/0/            12756500
        DATA SYMH(21)/0/,SYMH(22)/0/,SYMH(23)/0/,SYMH(24)/0/            12756600
        DATA SYMH(25)/51/,SYMH(26)/57/,SYMH(27)/45/                     12756700
        DATA SYMH(28)/34/,SYMH(29)/47/,SYMH(30)/44/                     12756800
        DATA SYMH(31)/0/,SYMH(32)/52/,SYMH(33)/33/                      12756900
        DATA SYMH(34)/34/,SYMH(35)/44/,SYMH(36)/37/                     12757000
C                                                                       12758000
C       PASS 2 SYMBOL DUMP                                              12759000
C                                                                       12760000
        CALL APPEND(SYMH,SYMHL)                                         12761000
        CONTRL(CC) = 0                                                  12761100
        CALL OUTPUT(CONTRL(CO))                                         12762000
        CALL OUTPUT(CONTRL(CO))                                         12763000
        CONTRL(CC) = CONTRL(CC) + 2                                     12763100
        DO 5 L = 1,SYMHL                                                12763200
          TITLE(L) = SYMH(L)                                            12763300
5       CONTINUE                                                        12763400
        TLEN = SYMHL                                                     1276350
        LINK1 = 1                                                       12764000
        LEVEL = 1                                                       12765000
10      CONTINUE                                                        12766000
          OBP = 2                                                       12767000
          KK = 0                                                        12768000
          CALL PAD(STAR,1)                                              12769000
          CALL PAD(BLK,1)                                               12770000
          CALL NUMBER(LEVEL,10,2)                                       12771000
          LEVEL = LEVEL + 1                                             12772000
          CALL OUTPUT(CONTRL(CO))                                       12773000
          CALL OUTPUT(CONTRL(CO))                                       12774000
          CONTRL(CC) = CONTRL(CC) + 2                                   12774100
          OBP = 2                                                       12775000
          LINK = SYMTAB(LINK1)+LINK1                                    12776000
          IF (SYMTAB(LINK1).EQ.1) GO TO 30                              12777000
            KI = LINK1+1                                                12777100
            KJ = LINK-2                                                 12777200
            DO 20 I = KI,KJ,2                                           12778000
              I1 = SYMTAB(I)                                            12780000
              CALL SYBRK(I+1,I2,ITYPE,IM,IR)                            12781000
              CALL CONID(I1,IX)                                         12786000
              CALL APPEND(SYMH,2)                                       12787000
              CALL NUMBER(I2,16,4)                                      12788000
              I2 = BLK                                                  12793000
              IF (IR.NE.0) I2 = STAR                                    12794000
              CALL APPEND(SYMH,1)                                       12795000
              CALL PAD(I2,1)                                            12796000
              CALL APPEND(SYMH,4)                                       12797000
              KK = KK + 1                                               12798000
              IF (KK.NE.4) GO TO 20                                     12799000
              KK = 0                                                    12800000
              CALL OUTPUT(CONTRL(CO))                                   12801000
              CONTRL(CC) = CONTRL(CC) + 1                               12801100
              IF (CONTRL(CC).GE.CONTRL(N7)) CALL TFORM(PAGE,TITLE,TLEN) 12801200
              OBP = 2                                                   12802000
20          CONTINUE                                                    12803000
30        CONTINUE                                                      12804000
          LINK1 = LINK                                                  12805000
          IF (KK.NE.0) CALL OUTPUT(CONTRL(CO))                          12806000
          IF (KK.NE.0) CONTRL(CC) = CONTRL(CC) + 1                      12806100
          CALL OUTPUT(CONTRL(CO))                                       12807000
          CONTRL(CC) = CONTRL(CC) + 1                                   12807100
          IF(CONTRL(CC).GE.CONTRL(N7)) CALL TFORM(PAGE,TITLE,TLEN)      12807200
          IF (LINK.LT.SYMAX.AND.SYMTAB(LINK).NE.0) GO TO 10             12808000
        RETURN                                                          12809000
        END                                                             12810000
C                                                                       12811000
C**********                                                             12812000
C                                                                       12813000
C       PAD OUTPUT LINE WITH CHARACTERS                                 12814000
C                                                                       12815000
C**********                                                             12816000
C                                                                       12817000
        SUBROUTINE PAD(CHAR,LEN)                                        12818000
C                                                                       12819000
          INTEGER CHAR,LEN,LOC(1)                                       12820000
C                                                                       12821000
          LOC(1) = CHAR                                                 12821100
        DO 10 I = 1,LEN                                                 12822000
          CALL APPEND(LOC,1)                                            12823000
10      CONTINUE                                                        12824000
        RETURN                                                          12825000
        END                                                             12826000
C                                                                       12827000
C**********                                                             12828000
C                                                                       12829000
C       CONVERT OPERAND ON VSTACK TO ACTUAL MACRO PARAMETER             12830000
C                                                                       12831000
C**********                                                             12832000
C                                                                       12833000
        SUBROUTINE PARVAL(VSTACK,TSTACK,LSTACK)                         12834000
C                                                                       12835000
        INTEGER VSTACK(1),TSTACK(1),LSTACK(1)                           12836000
C                                                                       12837000
        INTEGER POP,IDN,ADDR,LEVEL,TOS,EVAL                             12838000
        INTEGER I,LEN,IBUF(5),SP                                        12839000
C                                                                       12840000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  12841000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        12842000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           12843000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               12844000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   12845000
C                                                                       12846000
        INTEGER IPASS,BLKLVL                                            12847000
        COMMON /PASS/ IPASS,BLKLVL                                      12848000
C                                                                       12849000
        INTEGER                                                         12850000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12851000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12852000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12853000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12854000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12855000
C                                                                       12856000
        COMMON /CSET/                                                   12857000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12858000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12859000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12860000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12861000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12862000
C                                                                       12863000
        I = POP(TSTACK)                                                 12864000
        IF (I.LT.80) GO TO 80                                           12865000
          I = I - 79                                                    12866000
          GO TO (10,30,60), I                                           12867000
C                                                                       12868000
C       ABSOLUTE VALUE, TYPE = 80                                       12869000
C                                                                       12870000
10          CONTINUE                                                    12871000
            CALL INUM(POP(VSTACK),16,5,IBUF,LEN)                        12872000
            CALL PUT(7,MACPRM(BLKLVL+1))                                12873000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12874000
            DO 20 J = 1,5                                               12875000
              CALL PUT(IBUF(J),MACPRM(BLKLVL+1))                        12876000
              MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                   12877000
20          CONTINUE                                                    12878000
            CALL PUT(CH,MACPRM(BLKLVL+1))                               12879000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12880000
            CALL PUT(PTERM,MACPRM(BLKLVL+1))                            12881000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12882000
            SYMAX = MACPRM(BLKLVL+1) / 5 + 1                            12883000
            RETURN                                                      12884000
C                                                                       12885000
C       MACHINE INSTRUCTION, TYPE = 81                                  12886000
C                                                                       12887000
30          CONTINUE                                                    12888000
            LEN = POP(LSTACK)                                           12889000
35          CONTINUE                                                    12890000
              IF (LEN.LE.1) GO TO 10                                    12891000
              I = POP(TSTACK)                                           12892000
              I = POP(VSTACK)                                           12893000
              LEN = LEN - 1                                             12894000
            GO TO 35                                                    12895000
C                                                                       12896000
C       STRING, TYPE = 82                                               12897000
C                                                                       12898000
60          CONTINUE                                                    12899000
            LEN = POP(VSTACK)                                           12900000
            CALL PUT(LEN+1,MACPRM(BLKLVL+1))                            12901000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12902000
            I = SP(VSTACK)-LEN+1                                        12903000
            DO 70 J = 1,LEN                                             12904000
              CALL PUT(VSTACK(I),MACPRM(BLKLVL+1))                      12905000
              MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                   12906000
              K = POP(VSTACK)                                           12907000
              I = I + 1                                                 12908000
70          CONTINUE                                                    12909000
            CALL PUT(PTERM,MACPRM(BLKLVL+1))                            12910000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12911000
            SYMAX = MACPRM(BLKLVL+1) / 5 + 1                            12912000
          RETURN                                                        12913000
C                                                                       12914000
C       IDENTIFIER, TYPE = 0,1,2,3,...                                  12915000
C                                                                       12916000
80      CONTINUE                                                        12917000
          IDN = POP(VSTACK)                                             12918000
          ADDR = POP(VSTACK)                                            12919000
          LEVEL = POP(VSTACK)                                           12920000
          CALL ICON(IDN,LEN,IBUF)                                       12921000
          CALL PUT(LEN+1,MACPRM(BLKLVL+1))                              12922000
          MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                       12923000
          DO 90 J = 1,LEN                                               12924000
            CALL PUT(IBUF(J),MACPRM(BLKLVL+1))                          12925000
            MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                     12926000
90        CONTINUE                                                      12927000
          CALL PUT(PTERM,MACPRM(BLKLVL+1))                              12928000
          MACPRM(BLKLVL+1) = MACPRM(BLKLVL+1) + 1                       12929000
          SYMAX = MACPRM(BLKLVL+1) / 5 + 1                              12930000
          RETURN                                                        12931000
        END                                                             12932000
C                                                                       12933000
C**********                                                             12934000
C                                                                       12935000
C       RETURN AND POP TOP OF STACK                                     12936000
C                                                                       12937000
C**********                                                             12938000
C                                                                       12939000
        INTEGER FUNCTION POP(STACK)                                     12940000
C                                                                       12941000
        INTEGER                                                         12942000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12943000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12944000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12945000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12946000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12947000
C                                                                       12948000
        COMMON /CSET/                                                   12949000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12950000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12951000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12952000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12953000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12954000
C                                                                       12955000
        INTEGER STACK(1)                                                12956000
C                                                                       12957000
        I = STACK(1)                                                    12958000
        IF (I.EQ.1) GO TO 10                                            12959000
          POP = STACK(I)                                                12960000
          STACK(1) = I - 1                                              12961000
          RETURN                                                        12962000
10      CONTINUE                                                        12963000
        CALL ERROR(CN)                                                  12964000
        POP = 0                                                         12965000
        RETURN                                                          12966000
        END                                                             12967000
C                                                                       12968000
C**********                                                             12969000
C                                                                       12970000
C       PUSH ON STACK                                                   12971000
C                                                                       12972000
C**********                                                             12973000
C                                                                       12974000
        SUBROUTINE PUSH(STACK,VALUE,STKSIZ)                             12975000
C                                                                       12976000
        INTEGER STACK(1),VALUE,STKSIZ,RIGHT                             12977000
C                                                                       12978000
        INTEGER CONTRL(64)                                              12979000
        COMMON /CNTRL/ CONTRL                                           12980000
C                                                                       12981000
        INTEGER                                                         12982000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12983000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12984000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12985000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12986000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12987000
C                                                                       12988000
        COMMON /CSET/                                                   12989000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          12990000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     12991000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        12992000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     12993000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        12994000
C                                                                       12995000
        I = STACK(1)                                                    12996000
        IF (I.GE.STKSIZ) GO TO 10                                       12997000
          I = I + 1                                                     12998000
          STACK(I) = VALUE                                              12999000
          STACK(1) = I                                                  13000000
          RETURN                                                        13001000
10      CONTINUE                                                        13002000
        CALL ERROR(CS)                                                  13003000
        RETURN                                                          13004000
        END                                                             13005000
C                                                                       13006000
C**********                                                             13007000
C                                                                       13008000
C       PUT MACRO TEXT INTO STORAGE                                     13009000
C       PACKED FIVE CHAR/WORD, 6 BITS EACH, RIGHT JUSTIFIED             13010000
C                                                                       13011000
C**********                                                             13012000
C                                                                       13013000
        SUBROUTINE PUT(VALUE,ADDR)                                      13014000
C                                                                       13015000
        INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                  13016000
        INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                        13017000
        INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                           13018000
        COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,               13019000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   13020000
C                                                                       13021000
        INTEGER ADDR,VALUE,WORD,FIELD,SHIFTC,MASK,TEMP1,TEMP2           13022000
        INTEGER SHL,NOTF,ANDF,ORF                                       13023000
C                                                                       13024000
        WORD = ADDR/5                                                   13025000
        FIELD = MOD(ADDR,5)                                             13026000
        SHIFTC = 24-6*FIELD                                             13027000
        MASK = SHL(63,SHIFTC)                                           13028000
        MASK = NOTF(MASK)                                               13029000
        TEMP1 = SHL(VALUE,SHIFTC)                                       13030000
        TEMP2 = SYMTAB(WORD)                                            13031000
        TEMP2 = ANDF(TEMP2,MASK)                                        13032000
        SYMTAB(WORD) = ORF(TEMP2,TEMP1)                                 13033000
        RETURN                                                          13034000
        END                                                             13035000
C                                                                       13036000
C**********                                                             13037000
C                                                                       13038000
C       TRIM 16 BIT QUANTITIES TO FIT IN AN 8 BIT FIELD                 13039000
C                                                                       13040000
C**********                                                             13041000
C                                                                       13042000
        SUBROUTINE RANGE(VALUE)                                         13043000
C                                                                       13044000
        INTEGER VALUE,RIGHT                                             13045000
C                                                                       13046000
        INTEGER                                                         13047000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13048000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13049000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13050000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13051000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13052000
C                                                                       13053000
        COMMON /CSET/                                                   13054000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13055000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13056000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13057000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13058000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13059000
C                                                                       13060000
        I = VALUE/256                                                   13061000
        VALUE = RIGHT(VALUE,8)                                          13062000
        IF (I.NE.0.AND.I.NE.255) CALL ERROR(CV)                         13063000
        RETURN                                                          13064000
        END                                                             13065000
C                                                                       13066000
C**********                                                             13067000
C                                                                       13068000
C       GET RIGHT-MOST BITS, (UP TO 16)                                 13069000
C                                                                       13070000
C**********                                                             13071000
C                                                                       13072000
        INTEGER FUNCTION RIGHT(I,J)                                     13073000
C                                                                       13074000
        INTEGER POWER(16)                                               13075000
C                                                                       13076000
        DATA POWER(1)/2/,POWER(2)/4/,POWER(3)/8/                        13077000
        DATA POWER(4)/16/,POWER(5)/32/,POWER(6)/64/                     13077500
        DATA POWER(7)/128/,POWER(8)/256/,POWER(9)/512/                  13078000
        DATA POWER(10)/1024/,POWER(11)/2048/,POWER(12)/4096/            13078500
        DATA POWER(13)/8192/,POWER(14)/16384/,POWER(15)/32768/          13079000
        DATA POWER(16)/65536/                                           13079500
C                                                                       13080000
        JK = POWER(J)                                                   13081000
        RIGHT = MOD(I,JK)                                               13082000
        RETURN                                                          13083000
        END                                                             13084000
C                                                                       13085000
C**********                                                             13086000
C                                                                       13087000
C       SHL - LOGICAL SHIFT LEFT                                        13088000
C                                                                       13089000
C**********                                                             13090000
C                                                                       13091000
        INTEGER FUNCTION SHL(VALUE,COUNT)                               13092000
C                                                                       13093000
        INTEGER VALUE,COUNT                                             13094000
40      SHL = VALUE * 2**COUNT                                          13095000
        RETURN                                                          13096000
        END                                                             13097000
C                                                                       13098000
C**********                                                             13099000
C                                                                       13100000
C       SHR - LOGICAL SHIFT RIGHT                                       13101000
C                                                                       13102000
C**********                                                             13103000
C                                                                       13104000
        INTEGER FUNCTION SHR(VALUE,COUNT)                               13105000
C                                                                       13106000
        INTEGER VALUE,COUNT                                             13107000
        SHR = VALUE / 2**COUNT                                          13108000
        RETURN                                                          13109000
        END                                                             13110000
C                                                                       13111000
C**********                                                             13112000
C                                                                       13113000
C       RETURN STACK POINTER                                            13114000
C                                                                       13115000
C**********                                                             13116000
C                                                                       13117000
        INTEGER FUNCTION SP(STACK)                                      13118000
C                                                                       13119000
        INTEGER STACK(1)                                                13120000
C                                                                       13121000
        SP = STACK(1)                                                   13122000
        RETURN                                                          13123000
        END                                                             13124000
C                                                                       13125000
C**********                                                             13126000
C                                                                       13127000
C       DEBUG DUMP OF WORK STACKS                                       13128000
C                                                                       13129000
C**********                                                             13130000
C                                                                       13131000
C                                                                       13133000
C                                                                       13136000
C                                                                       13143000
C                                                                       13150000
C                                                                       13152000
C                                                                       13169010
C**********                                                             13169020
C                                                                       13169030
C       CONSTRUCT A SYMBOL TABLE ENTRY FROM ITS COMPONENTS              13169040
C                                                                       13169050
C**********                                                             13169060
C                                                                       13169070
       SUBROUTINE SYBLD(LOC,IVAL,ITYPE,IM,IR)                           13169080
C                                                                       13169090
       INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                   13169100
       INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                         13169110
       INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                            13169120
       COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,                13169130
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   13169140
C                                                                       13169150
       INTEGER TEMP                                                     13169160
C                                                                       13169170
       TEMP = IVAL*64+ITYPE                                             13169180
       IF (IM.NE.0) TEMP = TEMP + MULTI                                 13169190
       IF (IR.NE.0) TEMP = TEMP + REFBIT                                13169200
       SYMTAB(LOC) = TEMP                                               13169210
       RETURN                                                           13169220
       END                                                              13169230
C                                                                       13169240
C**********                                                             13169250
C                                                                       13169260
C       SEPARATE A SYMBOL TABLE ENTRY INTO ITS CONSTITUENT PARTS        13169270
C                                                                       13169280
C**********                                                             13169290
C                                                                       13169300
       SUBROUTINE SYBRK(LOC,IVAL,ITYPE,IM,IR)                           13169310
C                                                                       13169320
       INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                   13169330
       INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                         13169340
       INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                            13169350
       COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,                13169360
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   13169370
C                                                                       13169380
       INTEGER TEMP,ANDF,RIGHT                                          13169390
C                                                                       13169400
       TEMP = SYMTAB(LOC)                                               13169410
       ITYPE = RIGHT(TEMP,6)                                            13169420
       IVAL = RIGHT(TEMP/64,16)                                         13169430
       IM = ANDF(TEMP,MULTI)                                            13169440
       IR = ANDF(TEMP,REFBIT)                                           13169450
       RETURN                                                           13169460
       END                                                              13169470
C                                                                       13170000
C**********                                                             13171000
C                                                                       13172000
C       SYMBOL TABLE DUMP                                               13173000
C                                                                       13174000
C**********                                                             13175000
C                                                                       13176000
C                                                                       13178000
C                                                                       13181000
C                                                                       13187000
C                                                                       13194000
C                                                                       13201000
C                                                                       13204000
C                                                                       13206000
C                                                                       13211000
C                                                                       13246000
C**********                                                             13247000
C                                                                       13248000
C       GENERATE TOP OF FORM ON OUTPUT FILE                             13249000
C                                                                       13250000
C**********                                                             13251000
C                                                                       13252000
        SUBROUTINE TFORM(PAGE,TITLE,TLEN)                               13253000
C                                                                       13254000
        INTEGER ASMB(31),ASMBL,ERMSG(10),ERML,ERTOT(17),ERTL,PAGES(6)   13255000
        INTEGER BEGIN(13)                                               13255100
        COMMON /MSG/ ASMB,ASMBL,ERML,ERMSG,ERTOT,ERTL,PAGES,BEGIN       13256000
C                                                                       13257000
        INTEGER OBUF,OBP                                                13258000
        COMMON /OUTBUF/ OBUF(132),OBP                                   13259000
C                                                                       13260000
        INTEGER                                                         13261000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13262000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13263000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13264000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13265000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13266000
C                                                                       13267000
        COMMON /CSET/                                                   13268000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13269000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13270000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13271000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13272000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13273000
C                                                                       13274000
        INTEGER CONTRL(64)                                              13275000
        COMMON /CNTRL/ CONTRL                                           13276000
C                                                                       13277000
        INTEGER PAGE,TITLE(1),TLEN                                      13278000
        INTEGER*2 BUFLEN                                               
        PARAMETER(BUFLEN=9)
        INTEGER TIMBUF(BUFLEN),HOUR,MIN
C                                                                       13279000
        INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                          13279100
        COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                   13279200
C                                                                       13279300
        IF (CONTRL(CP) .EQ. 0) GO TO 1003                               13279400
        PAGE = PAGE + 1                                                 13280000
        IF (CONTRL(CF).NE.0) GO TO 30                                   13281000
          LL = (CONTRL(N7) + 11) - CONTRL(CC)                           13282000
          IF (PAGE.EQ.1) LL = 6                                         13283000
          DO 10 I = 1,LL                                                13284000
            CALL OUTPUT(CONTRL(CO))                                     13285000
10        CONTINUE                                                      13286000
30      CONTINUE                                                        13287000
        IF (CONTRL(CF).EQ.0) GO TO 40                                   13288000
          CALL PAD(N1,1)                                                13289000
          CALL OUTPUT(CONTRL(CO))                                       13290000
40      CONTINUE                                                        13291000
        CALL APPEND(ASMB,ASMBL)                                         13292000
        CALL PAD(BLK,6)                                                 13295010
        CALL APPEND(ERMSG,ERML)                                         13296000
        CALL VNUM(CONTRL(1))                                            13297000
        CALL PAD(BLK,6)                                                 13297010
        CALL OUTPUT(CONTRL(CO))                                         13297040
C       CALL TIMDAT(TIMBUF,BUFLEN)                                      13297042
C1001   FORMAT(1H+,54X,B'##',':',B'##',2X,A2,2('/',A2))                 13297050
 1001   FORMAT(1H+,54X,I2.2,':',I2.2,2X,2(I2.2,'/'),I4.4)
        ITRLY=TIME()
        CALL LTIME(ITRLY,TIMBUF)
        HOUR = TIMBUF(3)
        MIN = TIMBUF(2)
        TIMBUF(6) = TIMBUF(6)+1900
        IF (CONTRL(CO) .EQ. 2) GO TO 1002                               13297080
        IF (CONTRL(CO) .EQ. 1)                                          13297090
     +    WRITE(TTYO,1001) HOUR,MIN,TIMBUF(5)+1,TIMBUF(4),TIMBUF(6)
        IF (CONTRL(CO) .EQ. 3) WRITE(LIST,1001)                         13297100
     +    HOUR,MIN,TIMBUF(5)+1,TIMBUF(4),TIMBUF(6)                      13297102
        CALL PAD(PLUS,1)                                                13297110
        CALL PAD(BLK,85)                                                13297120
1002    CONTINUE                                                        13297130
        CALL APPEND(PAGES,6)                                            13298000
        CALL VNUM(PAGE)                                                 13299000
        CALL OUTPUT(CONTRL(CO))                                         13300000
        CALL PAD(BLK,6)                                                 13300010
        CALL APPEND(TITLE,TLEN)                                         13300020
        CALL OUTPUT(CONTRL(CO))                                         13301000
        CALL OUTPUT(CONTRL(CO))                                         13301100
        CALL OUTPUT(CONTRL(CO))                                         13302000
1003    CONTINUE                                                        13303100
        CONTRL(CC) = 0                                                  13303000
        RETURN                                                          13304000
        END                                                             13305000
C                                                                       13306000
C**********                                                             13307000
C                                                                       13308000
C       RETURN TOP OF STACK                                             13309000
C                                                                       13310000
C**********                                                             13311000
C                                                                       13312000
        INTEGER FUNCTION TOS(STACK)                                     13313000
C                                                                       13314000
        INTEGER STACK(1)                                                13315000
C                                                                       13316000
        I = STACK(1)                                                    13317000
        TOS = 0                                                         13318000
        IF (I.EQ.1) RETURN                                              13319000
        TOS = STACK(I)                                                  13320000
        RETURN                                                          13321000
        END                                                             13322000
C                                                                       13323000
C**********                                                             13324000
C                                                                       13325000
C       COMPUTE SIZE OF NUMBER AND OUTPUT                               13326000
C                                                                       13327000
C**********                                                             13328000
C                                                                       13329000
        SUBROUTINE VNUM(II)                                             13330000
C                                                                       13331000
        JJ = 7                                                          13332000
        IF (II.LT.1000000) JJ = 6                                       13333000
        IF (II.LT.100000) JJ = 5                                        13334000
        IF (II.LT.10000) JJ = 4                                         13335000
        IF (II.LT.1000) JJ = 3                                          13336000
        IF (II.LT.100) JJ = 2                                           13337000
        IF (II.LT.10) JJ = 1                                            13338000
        CALL NUMBER(II,10,JJ)                                           13339000
        RETURN                                                          13340000
        END                                                             13341000
C                                                                       13342000
C**********                                                             13343000
C                                                                       13344000
C       LOGICAL XOR FUNCTION, (MAXIMUM 30 BITS)                         13345000
C                                                                       13346000
C**********                                                             13347000
C                                                                       13348000
        INTEGER FUNCTION XORF(II,JJ)                                    13349000
C                                                                       13350000
        INTEGER ORF,ANDF,NOTF                                           13351000
        I1 = ORF(II,JJ)                                                 13352000
        I2 = ANDF(II,JJ)                                                13353000
        I2 = NOTF(I2)                                                   13354000
        XORF = ANDF(I1,I2)                                              13355000
        RETURN                                                          13356000
        END                                                             13357000
C                                                                       13358000
C**********                                                             13359000
C                                                                       13360000
C       ASSEMBLER DATA FOR 8080 VERSION                                 13361000
C                                                                       13362000
C**********                                                             13363000
C                                                                       13364000
      BLOCK DATA                                                        13365000
C                                                                       13366000
      INTEGER VERS                                                      13367000
      COMMON /VER/ VERS                                                 13368000
C                                                                       13369000
      INTEGER VSTKN(4),OSTKN(4),TSTKN(4),GSTKN(4),ASTKN(4)              13370000
      INTEGER BOTSTK(4),PTRSTK(4),PRMSTK(4),XPNSTK(4),LSTKN(4)          13371000
      COMMON /DEBUG/ VSTKN,OSTKN,TSTKN,GSTKN,ASTKN,                     13372000
     1 BOTSTK,PTRSTK,PRMSTK,XPNSTK,LSTKN                                13373000
C                                                                       13374000
      INTEGER INPUT,LIST,HEX,TTYI,TTYO,ERLOG                            13375000
      COMMON /IODEV/ INPUT,LIST,HEX,TTYI,TTYO,ERLOG                     13376000
C                                                                       13377000
      INTEGER                                                           13378000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13379000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13380000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13381000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13382000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13383000
C                                                                       13384000
      COMMON /CSET/                                                     13385000
     1 BLK,EXC,QUOTE,NUMB,DOLLAR,PERCT,AMP,TIC,OPAR,CPAR,STAR,          13386000
     1 PLUS,COMMA,MINUS,PERIOD,SLASH,N0,N1,N2,N3,N4,N5,N6,N7,N8,N9,     13387000
     1 COLON,SEMI,LBRACK,EQUAL,RBRACK,QUES,AT,CA,CB,CC,CD,CE,CF,        13388000
     1 CG,CH,CI,CJ,CK,CL,CM,CN,CO,CP,CQ,CR,CS,CT,CU,CV,CW,CX,CY,CZ,     13389000
     1 TAB,EOL,FORMAL,TERM,PTERM                                        13390000
C                                                                       13391000
      INTEGER IOTRAN(64),ASCII(64)                                      13392000
      COMMON /PORTA/ IOTRAN,ASCII                                       13393000
C                                                                       13394000
      INTEGER ASMB(31),ASMBL,ERMSG(10),ERML,ERTOT(17),ERTL,PAGES(6)     13395000
      INTEGER BEGIN(13)                                                 13395100
      COMMON /MSG/ ASMB,ASMBL,ERML,ERMSG,ERTOT,ERTL,PAGES,BEGIN         13396000
C                                                                       13397000
      INTEGER LWR(64),UPR(64)                                           13397050
      COMMON /BNDS/ LWR,UPR                                             13397100
C                                                                       13397150
      COMMON /PREC/ INPPRC(64),NARGS(64),NONVAR                         13398000
C                                                                       13399000
      COMMON /MAX/ MAXMEM                                               13400000
C                                                                       13401000
      INTEGER SYMTAB(1750),SYMAX,REFBIT,MULTI,FREMEM                    13402000
      INTEGER SYMBOT(10),MACXPN(10),MACPTR(10)                          13403000
      INTEGER MACPRM(10),LINKP,MAXNP,SYMSIZ                             13404000
      COMMON /SYMBOL/ SYMTAB,SYMAX,REFBIT,MULTI,FREMEM,                 13405000
     1 SYMBOT,MACXPN,MACPTR,MACPRM,LINKP,MAXNP,SYMSIZ                   13406000
C                                                                       13407000
      INTEGER OPTAB(194),OPTL                                           13408000
      COMMON /OPCODE/ OPTAB,OPTL                                        13409000
C                                                                       13410000
      DATA VERS /30/                                                    13411000
C                                                                       13412000
C       'VAL '                                                          13413000
C                                                                       13414000
      DATA VSTKN(1)/54/,VSTKN(2)/33/,VSTKN(3)/44/,VSTKN(4)/0/           13415000
C                                                                       13416000
C       'OP  '                                                          13417000
C                                                                       13418000
      DATA OSTKN(1)/47/,OSTKN(2)/48/,OSTKN(3)/0/,OSTKN(4)/0/            13419000
C                                                                       13420000
C       'TYPE'                                                          13421000
C                                                                       13422000
      DATA TSTKN(1)/52/,TSTKN(2)/57/,TSTKN(3)/48/,TSTKN(4)/37/          13423000
C                                                                       13424000
C       'VAR '                                                          13425000
C                                                                       13426000
      DATA GSTKN(1)/54/,GSTKN(2)/33/,GSTKN(3)/50/,GSTKN(4)/0/           13427000
C                                                                       13428000
C       'IFS '                                                          13429000
C                                                                       13430000
      DATA ASTKN(1)/41/,ASTKN(2)/38/,ASTKN(3)/51/,ASTKN(4)/0/           13431000
C                                                                       13432000
C       'BOT '                                                          13433000
C                                                                       13434000
      DATA BOTSTK(1)/34/,BOTSTK(2)/47/,BOTSTK(3)/52/,BOTSTK(4)/0/       13435000
C                                                                       13436000
C       'XPN '                                                          13437000
C                                                                       13438000
      DATA XPNSTK(1)/56/,XPNSTK(2)/48/,XPNSTK(3)/46/,XPNSTK(4)/0/       13439000
C                                                                       13440000
C       'PTR '                                                          13441000
C                                                                       13442000
      DATA PTRSTK(1)/48/,PTRSTK(2)/52/,PTRSTK(3)/50/,PTRSTK(4)/0/       13443000
C                                                                       13444000
C       'PRM '                                                          13445000
C                                                                       13446000
      DATA PRMSTK(1)/48/,PRMSTK(2)/50/,PRMSTK(3)/45/,PRMSTK(4)/0/       13447000
C                                                                       13448000
C       'LEN '                                                          13449000
C                                                                       13450000
      DATA LSTKN(1)/44/,LSTKN(2)/37/,LSTKN(3)/46/,LSTKN(4)/0/           13451000
C                                                                       13452000
      DATA INPUT / 7/,LIST / 8/,HEX / 9/,TTYI /1/                       13453000
      DATA TTYO  /2/,ERLOG /20/
C                                                                       13454000
      DATA                                                              13455000
     1 BLK /0/,EXC /1/,QUOTE /2/,NUMB /3/,DOLLAR /4/,PERCT /5/,         13456000
     1 AMP /6/,TIC /7/,OPAR /8/,CPAR /9/,STAR /10/,PLUS /11/,           13457000
     1 COMMA /12/,MINUS /13/,PERIOD /14/,SLASH /15/,N0 /16/,N1 /17/,    13458000
     1 N2 /18/,N3 /19/,N4 /20/,N5 /21/,N6 /22/,N7 /23/,N8 /24/,N9 /25/, 13459000
     1 COLON /26/,SEMI /27/,LBRACK /28/,EQUAL /29/,RBRACK /30/,         13460000
     1 QUES /31/,AT /32/,CA /33/,CB /34/,CC /35/,CD /36/,CE /37/,       13461000
     1 CF /38/,CG /39/,CH /40/,CI /41/,CJ /42/,CK /43/,CL /44/,         13462000
     1 CM /45/,CN /46/,CO /47/,CP /48/,CQ /49/,CR /50/,CS /51/,         13463000
     1 CT /52/,CU /53/,CV /54/,CW /55/,CX /56/,CY /57/,CZ /58/,         13464000
     1 TAB /59/,EOL /60/,FORMAL /61/,TERM /62/,PTERM /63/               13465000
C                                                                       13466000
      DATA IOTRAN(1)/1H /,IOTRAN(2)/1H!/,IOTRAN(3)/1H"/                 13467000
      DATA IOTRAN(4)/1H#/,IOTRAN(5)/1H$/,IOTRAN(6)/1H%/                 13468000
      DATA IOTRAN(7)/1H&/,IOTRAN(8)/1H'/,IOTRAN(9)/1H(/                 13469000
      DATA IOTRAN(10)/1H)/,IOTRAN(11)/1H*/,IOTRAN(12)/1H+/              13470000
      DATA IOTRAN(13)/1H,/,IOTRAN(14)/1H-/,IOTRAN(15)/1H./              13471000
      DATA IOTRAN(16)/1H//,IOTRAN(17)/1H0/,IOTRAN(18)/1H1/              13472000
      DATA IOTRAN(19)/1H2/,IOTRAN(20)/1H3/                              13473000
      DATA IOTRAN(21)/1H4/,IOTRAN(22)/1H5/,IOTRAN(23)/1H6/              13474000
      DATA IOTRAN(24)/1H7/,IOTRAN(25)/1H8/,IOTRAN(26)/1H9/              13475000
      DATA IOTRAN(27)/1H:/,IOTRAN(28)/1H;/,IOTRAN(29)/1H</              13476000
      DATA IOTRAN(30)/1H=/,IOTRAN(31)/1H>/,IOTRAN(32)/1H?/              13477000
      DATA IOTRAN(33)/1H@/,IOTRAN(34)/1HA/,IOTRAN(35)/1HB/              13478000
      DATA IOTRAN(36)/1HC/,IOTRAN(37)/1HD/,IOTRAN(38)/1HE/              13479000
      DATA IOTRAN(39)/1HF/,IOTRAN(40)/1HG/,IOTRAN(41)/1HH/              13480000
      DATA IOTRAN(42)/1HI/,IOTRAN(43)/1HJ/,IOTRAN(44)/1HK/              13481000
      DATA IOTRAN(45)/1HL/,IOTRAN(46)/1HM/,IOTRAN(47)/1HN/              13482000
      DATA IOTRAN(48)/1HO/,IOTRAN(49)/1HP/,IOTRAN(50)/1HQ/              13483000
      DATA IOTRAN(51)/1HR/,IOTRAN(52)/1HS/,IOTRAN(53)/1HT/              13484000
      DATA IOTRAN(54)/1HU/,IOTRAN(55)/1HV/,IOTRAN(56)/1HW/              13485000
      DATA IOTRAN(57)/1HX/,IOTRAN(58)/1HY/,IOTRAN(59)/1HZ/              13486000
      DATA IOTRAN(60)/1H        /,IOTRAN(61)/1H /,IOTRAN(62)/1H /       13487000
      DATA IOTRAN(63)/1H /,IOTRAN(64)/1H /                              13488000
C                                                                       13489000
      DATA ASCII(1)/32/,ASCII(2)/33/,ASCII(3)/34/,ASCII(4)/35/          13490000
      DATA ASCII(5)/36/,ASCII(6)/37/,ASCII(7)/38/,ASCII(8)/39/          13491000
      DATA ASCII(9)/40/,ASCII(10)/41/,ASCII(11)/42/,ASCII(12)/43/       13492000
      DATA ASCII(13)/44/,ASCII(14)/45/,ASCII(15)/46/,ASCII(16)/47/      13493000
      DATA ASCII(17)/48/,ASCII(18)/49/,ASCII(19)/50/,ASCII(20)/51/      13494000
      DATA ASCII(21)/52/,ASCII(22)/53/,ASCII(23)/54/,ASCII(24)/55/      13495000
      DATA ASCII(25)/56/,ASCII(26)/57/,ASCII(27)/58/,ASCII(28)/59/      13496000
      DATA ASCII(29)/60/,ASCII(30)/61/,ASCII(31)/62/,ASCII(32)/63/      13497000
      DATA ASCII(33)/64/,ASCII(34)/65/,ASCII(35)/66/,ASCII(36)/67/      13498000
      DATA ASCII(37)/68/,ASCII(38)/69/,ASCII(39)/70/,ASCII(40)/71/      13499000
      DATA ASCII(41)/72/,ASCII(42)/73/,ASCII(43)/74/,ASCII(44)/75/      13500000
      DATA ASCII(45)/76/,ASCII(46)/77/,ASCII(47)/78/,ASCII(48)/79/      13501000
      DATA ASCII(49)/80/,ASCII(50)/81/,ASCII(51)/82/,ASCII(52)/83/      13502000
      DATA ASCII(53)/84/,ASCII(54)/85/,ASCII(55)/86/,ASCII(56)/87/      13503000
      DATA ASCII(57)/88/,ASCII(58)/89/,ASCII(59)/90/,ASCII(60)/09/      13504000
      DATA ASCII(61)/0/,ASCII(62)/0/,ASCII(63)/0/,ASCII(64)/0/          13505000
C                                                                       13506000
C       ' 8080 MACRO ASSEMBLER, VER X.X '                               13507000
C                                                                       13508000
      DATA ASMBL /31/                                                   13509000
      DATA ASMB(1)/0/,ASMB(2)/24/,ASMB(3)/16/,ASMB(4)/24/               13510000
      DATA ASMB(5)/16/,ASMB(6)/0/,ASMB(7)/45/,ASMB(8)/33/               13511000
      DATA ASMB(9)/35/,ASMB(10)/50/,ASMB(11)/47/,ASMB(12)/0/            13512000
      DATA ASMB(13)/33/,ASMB(14)/51/,ASMB(15)/51/,ASMB(16)/37/          13513000
      DATA ASMB(17)/45/,ASMB(18)/34/,ASMB(19)/44/,ASMB(20)/37/          13514000
      DATA ASMB(21)/50/,ASMB(22)/12/,ASMB(23)/0/,ASMB(24)/54/           13515000
      DATA ASMB(25)/37/,ASMB(26)/50/,ASMB(27)/0/,ASMB(28)/0/            13516000
      DATA ASMB(29)/14/,ASMB(30)/0/,ASMB(31)/0/                         13517000
      DATA PAGES(1)/0/,PAGES(2)/48/,PAGES(3)/33/                        13518000
      DATA PAGES(4)/39/,PAGES(5)/37/,PAGES(6)/0/                        13519000
        DATA BEGIN(1)/0/,BEGIN(2)/34/,BEGIN(3)/37/
        DATA BEGIN(4)/39/,BEGIN(5)/41/,BEGIN(6)/46/
        DATA BEGIN(7)/0/,BEGIN(8)/48/,BEGIN(9)/33/
        DATA BEGIN(10)/51/,BEGIN(11)/51/,BEGIN(12)/0/
        DATA BEGIN(13)/17/
C                                                                       13520000
C         CONTROL COMMAND RANGE ARRAYS                                  13520010
C                                                                       13520020
      DATA UPR(1)/-1/,UPR(2)/-1/,UPR(3)/-1/,UPR(4)/-1/                  13520040
      DATA UPR(5)/-1/,UPR(6)/-1/,UPR(7)/-1/,UPR(8)/-1/                  13520060
      DATA UPR(9)/-1/,UPR(10)/-1/,UPR(11)/-1/,UPR(12)/-1/               13520080
      DATA UPR(13)/-1/,UPR(14)/-1/,UPR(15)/-1/,UPR(16)/-1/              13520100
      DATA UPR(17)/1/,UPR(18)/1/,UPR(19)/1/,UPR(20)/1/                  13520120
      DATA UPR(21)/ 1/,UPR(22)/ 1/,UPR(23)/60/,UPR(24)/-1/              13520140
      DATA UPR(25)/-1/,UPR(26)/-1/,UPR(27)/-1/,UPR(28)/-1/              13520160
      DATA UPR(29)/-1/,UPR(30)/-1/,UPR(31)/-1/,UPR(32)/-1/              13520180
      DATA UPR(33)/-1/,UPR(34)/1/,UPR(35)/-1/,UPR(36)/-1/               13520200
      DATA UPR(37)/-1/,UPR(38)/1/,UPR(39)/-1/,UPR(40)/-1/               13520220
      DATA UPR(41)/2/,UPR(42)/-1/,UPR(43)/-1/,UPR(44)/132/              13520240
      DATA UPR(45)/3/,UPR(46)/-1/,UPR(47)/3/,UPR(48)/1/                 13520260
      DATA UPR(49)/3/,UPR(50)/132/,UPR(51)/1/,UPR(52)/1/                13520280
      DATA UPR(53)/-1/,UPR(54)/-1/,UPR(55)/132/,UPR(56)/-1/             13520300
      DATA UPR(57)/-1/,UPR(58)/1/,UPR(59)/-1/,UPR(60)/-1/               13520320
      DATA UPR(61)/-1/,UPR(62)/-1/,UPR(63)/-1/,UPR(64)/-1/              13520340
C                                                                       13520360
      DATA LWR(1)/-1/,LWR(2)/-1/,LWR(3)/-1/,LWR(4)/-1/                  13520380
      DATA LWR(5)/-1/,LWR(6)/-1/,LWR(7)/-1/,LWR(8)/-1/                  13520400
      DATA LWR(9)/-1/,LWR(10)/-1/,LWR(11)/-1/,LWR(12)/-1/               13520420
      DATA LWR(13)/-1/,LWR(14)/-1/,LWR(15)/-1/,LWR(16)/-1/              13520440
      DATA LWR(17)/0/,LWR(18)/0/,LWR(19)/0/,LWR(20)/0/                  13520460
      DATA LWR(21)/0/,LWR(22)/ 0/,LWR(23)/ 1/,LWR(24)/-1/               13520480
      DATA LWR(25)/-1/,LWR(26)/-1/,LWR(27)/-1/,LWR(28)/-1/              13520500
      DATA LWR(29)/-1/,LWR(30)/-1/,LWR(31)/-1/,LWR(32)/-1/              13520520
      DATA LWR(33)/-1/,LWR(34)/0/,LWR(35)/-1/,LWR(36)/-1/               13520540
      DATA LWR(37)/-1/,LWR(38)/0/,LWR(39)/-1/,LWR(40)/-1/               13520560
      DATA LWR(41)/1/,LWR(42)/-1/,LWR(43)/-1/,LWR(44)/1/                13520580
      DATA LWR(45)/0/,LWR(46)/-1/,LWR(47)/1/,LWR(48)/0/                 13520600
      DATA LWR(49)/0/,LWR(50)/1/,LWR(51)/0/,LWR(52)/0/                  13520620
      DATA LWR(53)/1/,LWR(54)/-1/,LWR(55)/1/,LWR(56)/-1/                13520640
      DATA LWR(57)/-1/,LWR(58)/0/,LWR(59)/-1/,LWR(60)/-1/               13520660
      DATA LWR(61)/-1/,LWR(62)/-1/,LWR(63)/-1/,LWR(64)/-1/              13520680
C                                                                       13520700
C       ' ERRORS = '                                                    13521000
C                                                                       13522000
      DATA ERML /10/                                                    13523000
      DATA ERMSG(1)/0/,ERMSG(2)/37/,ERMSG(3)/50/,ERMSG(4)/50/           13524000
      DATA ERMSG(5)/47/,ERMSG(6)/50/,ERMSG(7)/51/,ERMSG(8)/0/           13525000
      DATA ERMSG(9)/29/,ERMSG(10)/0/                                    13526000
C                                                                       13527000
C       'NO PROGRAM ERRORS'                                             13528000
C                                                                       13529000
      DATA ERTL /17/                                                    13530000
      DATA ERTOT(1)/46/,ERTOT(2)/47/,ERTOT(3)/0/,ERTOT(4)/48/           13531000
      DATA ERTOT(5)/50/,ERTOT(6)/47/,ERTOT(7)/39/,ERTOT(8)/50/          13532000
      DATA ERTOT(9)/33/,ERTOT(10)/45/,ERTOT(11)/0/,ERTOT(12)/37/        13533000
      DATA ERTOT(13)/50/,ERTOT(14)/50/,ERTOT(15)/47/,ERTOT(16)/50/      13534000
      DATA ERTOT(17)/51/                                                13535000
C                                                                       13536000
      DATA MAXMEM /65535/                                               13537000
C                                                                       13538000
      DATA NONVAR /35/                                                  13539000
C                                                                       13540000
C       NONVARIANT PRECEDENCE TABLE                                     13541000
C                                                                       13542000
      DATA INPPRC(1)/03/,INPPRC(2)/03/,INPPRC(3)/10/,INPPRC(4)/09/      13543000
      DATA INPPRC(5)/03/,INPPRC(6)/09/,INPPRC(7)/01/,INPPRC(8)/10/      13544000
      DATA INPPRC(9)/09/,INPPRC(10)/08/,INPPRC(11)/09/,INPPRC(12)/07/   13545000
      DATA INPPRC(13)/06/,INPPRC(14)/06/,INPPRC(15)/10/,INPPRC(16)/10/  13546000
      DATA INPPRC(17)/10/,INPPRC(18)/01/,INPPRC(19)/00/,INPPRC(20)/04/  13547000
      DATA INPPRC(21)/04/,INPPRC(22)/04/,INPPRC(23)/04/,INPPRC(24)/04/  13548000
      DATA INPPRC(25)/04/,INPPRC(26)/04/,INPPRC(27)/04/,INPPRC(28)/04/  13549000
      DATA INPPRC(29)/04/,INPPRC(30)/04/,INPPRC(31)/00/,INPPRC(32)/04/  13550000
      DATA INPPRC(33)/04/,INPPRC(34)/04/,INPPRC(35)/04/                 13551000
C                                                                       13552000
C       VARIANT, OR ASSEMBLER-DEPENDENT PRECEDENCE TABLE                13553000
C                                                                       13554000
      DATA INPPRC(55)/04/,INPPRC(56)/04/,INPPRC(57)/04/                 13555000
      DATA INPPRC(58)/04/,INPPRC(59)/04/,INPPRC(60)/04/                 13556000
      DATA INPPRC(61)/04/,INPPRC(62)/04/,INPPRC(63)/04/                 13557000
      DATA INPPRC(64)/04/                                               13558000
C                                                                       13559000
C       NONVARIANT NUMBER OF ARGUMENTS TABLE                            13560000
C                                                                       13561000
      DATA NARGS(1)/1/,NARGS(2)/1/,NARGS(3)/3/,NARGS(4)/3/              13562000
      DATA NARGS(5)/1/,NARGS(6)/3/,NARGS(7)/1/,NARGS(8)/3/              13563000
      DATA NARGS(9)/2/,NARGS(10)/2/,NARGS(11)/2/,NARGS(12)/3/           13564000
      DATA NARGS(13)/3/,NARGS(14)/3/,NARGS(15)/3/,NARGS(16)/3/          13565000
      DATA NARGS(17)/3/,NARGS(18)/1/,NARGS(19)/1/,NARGS(20)/1/          13566000
      DATA NARGS(21)/1/,NARGS(22)/2/,NARGS(23)/2/,NARGS(24)/2/          13567000
      DATA NARGS(25)/2/,NARGS(26)/2/,NARGS(27)/1/,NARGS(28)/2/          13568000
      DATA NARGS(29)/2/,NARGS(30)/1/,NARGS(31)/1/,NARGS(32)/1/          13569000
      DATA NARGS(33)/1/,NARGS(34)/1/,NARGS(35)/1/                       13570000
C                                                                       13571000
C       VARIANT, OR ASSEMBLER-DEPENDENT NUMBER OF ARGUMENTS TABLE       13572000
C                                                                       13573000
      DATA NARGS(55)/3/,NARGS(56)/3/,NARGS(57)/3/                       13574000
      DATA NARGS(58)/3/,NARGS(59)/3/,NARGS(60)/3/                       13575000
      DATA NARGS(61)/3/,NARGS(62)/3/,NARGS(63)/3/                       13576000
      DATA NARGS(64)/2/                                                 13577000
C                                                                       13578000
C       8080 OPCODES, OPERATORS, AND PSEUDOS                            13579000
C                                                                       13580000
C         SYMBOL     VALUE     TYPE                                     13581000
C                                                                       13582000
C           ACI         206       59                                    13583000
C           ADC         136       58                                    13584000
C           ADD         128       58                                    13585000
C           ADI         198       59                                    13586000
C           ANA         160       58                                    13587000
C           AND           0       12                                    13588000
C           ANI         230       59                                    13589000
C           CALL        205       63                                    13590000
C           CC          220       63                                    13591000
C           CM          252       63                                    13592000
C           CMA          47       64                                    13593000
C           CMC          63       64                                    13594000
C           CMP         184       58                                    13595000
C           CNC         212       63                                    13596000
C           CNZ         196       63                                    13597000
C           CP          244       63                                    13598000
C           CPE         236       63                                    13599000
C           CPI         254       59                                    13600000
C           CPO         228       63                                    13601000
C           CZ          204       63                                    13602000
C           DAA          39       64                                    13603000
C           DAD           9       56                                    13604000
C           DB            0       21                                    13605000
C           DCR           5       61                                    13606000
C           DCX          11       56                                    13607000
C           DI          243       64                                    13608000
C           DS            0       22                                    13609000
C           DW            0       23                                    13610000
C           EI          251       64                                    13611000
C           END           0       24                                    13612000
C           ENDIF         0       27                                    13613000
C           ENDM          0       33                                    13614000
C           EQU           0       25                                    13615000
C           HLT         118       64                                    13616000
C           IF            0       26                                    13617000
C           IN          219       59                                    13618000
C           INR           4       61                                    13619000
C           INX           3       56                                    13620000
C           JC          218       63                                    13621000
C           JM          250       63                                    13622000
C           JMP         195       63                                    13623000
C           JNC         210       63                                    13624000
C           JNZ         194       63                                    13625000
C           JP          242       63                                    13626000
C           JPE         234       63                                    13627000
C           JPO         226       63                                    13628000
C           JZ          202       63                                    13629000
C           LDA          58       63                                    13630000
C           LDAX         10       57                                    13631000
C           LHLD         42       63                                    13632000
C           LXI           1       55                                    13633000
C           MACRO         0       31                                    13634000
C           MOD           0       15                                    13635000
C           MOV          64       62                                    13636000
C           MVI           6       60                                    13637000
C           NOP           0       64                                    13638000
C           NOT           0       10                                    13639000
C           OR            0       13                                    13640000
C           ORA         176       58                                    13641000
C           ORG           0       28                                    13642000
C           ORI         246       59                                    13643000
C           OUT         211       59                                    13644000
C           PCHL        233       64                                    13645000
C           POP         193       56                                    13646000
C           PUSH        197       56                                    13647000
C           RAL          23       64                                    13648000
C           RAR          31       64                                    13649000
C           RC          216       64                                    13650000
C           RET         201       64                                    13651000
C           RLC           7       64                                    13652000
C           RM          248       64                                    13653000
C           RNC         208       64                                    13654000
C           RNZ         192       64                                    13655000
C           RP          240       64                                    13656000
C           RPE         232       64                                    13657000
C           RPO         224       64                                    13658000
C           RRC          15       64                                    13659000
C           RST         199       61                                    13660000
C           RZ          200       64                                    13661000
C           SBB         152       58                                    13662000
C           SBI         222       59                                    13663000
C           SET           0       29                                    13664000
C           SHL           0       16                                    13665000
C           SHLD         34       63                                    13666000
C           SHR           0       17                                    13667000
C           SPHL        249       64                                    13668000
C           STA          50       63                                    13669000
C           STAX          2       57                                    13670000
C           STC          55       64                                    13671000
C           SUB         144       58                                    13672000
C           SUI         214       59                                    13673000
C           TITLE         0       30                                    13674000
C           XCHG        235       64                                    13675000
C           XOR           0       14                                    13676000
C           XRA         168       58                                    13677000
C           XRI         238       59                                    13678000
C           XTHL        227       64                                    13679000
C                                                                       13680000
      DATA OPTAB(  1)/ 562991104/,OPTAB(  2)/     20659/                13681000
      DATA OPTAB(  3)/ 563228672/,OPTAB(  4)/     13658/                13682000
      DATA OPTAB(  5)/ 563232768/,OPTAB(  6)/     12858/                13683000
      DATA OPTAB(  7)/ 563253248/,OPTAB(  8)/     19859/                13684000
      DATA OPTAB(  9)/ 565841920/,OPTAB( 10)/     16058/                13685000
      DATA OPTAB( 11)/ 565854208/,OPTAB( 12)/        12/                13686000
      DATA OPTAB( 13)/ 565874688/,OPTAB( 14)/     23059/                13687000
      DATA OPTAB( 15)/ 596036352/,OPTAB( 16)/     20563/                13688000
      DATA OPTAB( 17)/ 596377600/,OPTAB( 18)/     22063/                13689000
      DATA OPTAB( 19)/ 598999040/,OPTAB( 20)/     25263/                13690000
      DATA OPTAB( 21)/ 599134208/,OPTAB( 22)/      4764/                13691000
      DATA OPTAB( 23)/ 599142400/,OPTAB( 24)/      6364/                13692000
      DATA OPTAB( 25)/ 599195648/,OPTAB( 26)/     18458/                13693000
      DATA OPTAB( 27)/ 599404544/,OPTAB( 28)/     21263/                13694000
      DATA OPTAB( 29)/ 599498752/,OPTAB( 30)/     19663/                13695000
      DATA OPTAB( 31)/ 599785472/,OPTAB( 32)/     24463/                13696000
      DATA OPTAB( 33)/ 599937024/,OPTAB( 34)/     23663/                13697000
      DATA OPTAB( 35)/ 599953408/,OPTAB( 36)/     25459/                13698000
      DATA OPTAB( 37)/ 599977984/,OPTAB( 38)/     22863/                13699000
      DATA OPTAB( 39)/ 602406912/,OPTAB( 40)/     20463/                13700000
      DATA OPTAB( 41)/ 612765696/,OPTAB( 42)/      3964/                13701000
      DATA OPTAB( 43)/ 612777984/,OPTAB( 44)/       956/                13702000
      DATA OPTAB( 45)/ 612892672/,OPTAB( 46)/        21/                13703000
      DATA OPTAB( 47)/ 613359616/,OPTAB( 48)/       561/                13704000
      DATA OPTAB( 49)/ 613384192/,OPTAB( 50)/      1156/                13705000
      DATA OPTAB( 51)/ 614727680/,OPTAB( 52)/     24364/                13706000
      DATA OPTAB( 53)/ 617349120/,OPTAB( 54)/        22/                13707000
      DATA OPTAB( 55)/ 618397696/,OPTAB( 56)/        23/                13708000
      DATA OPTAB( 57)/ 631504896/,OPTAB( 58)/     25164/                13709000
      DATA OPTAB( 59)/ 632963072/,OPTAB( 60)/        24/                13710000
      DATA OPTAB( 61)/ 632965734/,OPTAB( 62)/        27/                13711000
      DATA OPTAB( 63)/ 632965952/,OPTAB( 64)/        33/                13712000
      DATA OPTAB( 65)/ 633819136/,OPTAB( 66)/        25/                13713000
      DATA OPTAB( 67)/ 682835968/,OPTAB( 68)/     11864/                13714000
      DATA OPTAB( 69)/ 697827328/,OPTAB( 70)/        26/                13715000
      DATA OPTAB( 71)/ 699924480/,OPTAB( 72)/     21959/                13716000
      DATA OPTAB( 73)/ 700129280/,OPTAB( 74)/       461/                13717000
      DATA OPTAB( 75)/ 700153856/,OPTAB( 76)/       356/                13718000
      DATA OPTAB( 77)/ 713818112/,OPTAB( 78)/     21863/                13719000
      DATA OPTAB( 79)/ 716439552/,OPTAB( 80)/     25063/                13720000
      DATA OPTAB( 81)/ 716636160/,OPTAB( 82)/     19563/                13721000
      DATA OPTAB( 83)/ 716845056/,OPTAB( 84)/     21063/                13722000
      DATA OPTAB( 85)/ 716939264/,OPTAB( 86)/     19463/                13723000
      DATA OPTAB( 87)/ 717225984/,OPTAB( 88)/     24263/                13724000
      DATA OPTAB( 89)/ 717377536/,OPTAB( 90)/     23463/                13725000
      DATA OPTAB( 91)/ 717418496/,OPTAB( 92)/     22663/                13726000
      DATA OPTAB( 93)/ 719847424/,OPTAB( 94)/     20263/                13727000
      DATA OPTAB( 95)/ 747769856/,OPTAB( 96)/      5863/                13728000
      DATA OPTAB( 97)/ 747773440/,OPTAB( 98)/      1057/                13729000
      DATA OPTAB( 99)/ 748865792/,OPTAB(100)/      4263/                13730000
      DATA OPTAB(101)/ 753045504/,OPTAB(102)/       155/                13731000
      DATA OPTAB(103)/ 763772079/,OPTAB(104)/        31/                13732000
      DATA OPTAB(105)/ 767442944/,OPTAB(106)/        15/                13733000
      DATA OPTAB(107)/ 767516672/,OPTAB(108)/      6462/                13734000
      DATA OPTAB(109)/ 769298432/,OPTAB(110)/       660/                13735000
      DATA OPTAB(111)/ 784269312/,OPTAB(112)/        64/                13736000
      DATA OPTAB(113)/ 784285696/,OPTAB(114)/        10/                13737000
      DATA OPTAB(115)/ 801636352/,OPTAB(116)/        13/                13738000
      DATA OPTAB(117)/ 801771520/,OPTAB(118)/     17658/                13739000
      DATA OPTAB(119)/ 801796096/,OPTAB(120)/        28/                13740000
      DATA OPTAB(121)/ 801804288/,OPTAB(122)/     24659/                13741000
      DATA OPTAB(123)/ 802635776/,OPTAB(124)/     21159/                13742000
      DATA OPTAB(125)/ 814648064/,OPTAB(126)/     23364/                13743000
      DATA OPTAB(127)/ 817823744/,OPTAB(128)/     19356/                13744000
      DATA OPTAB(129)/ 819411456/,OPTAB(130)/     19756/                13745000
      DATA OPTAB(131)/ 847691776/,OPTAB(132)/      2364/                13746000
      DATA OPTAB(133)/ 847716352/,OPTAB(134)/      3164/                13747000
      DATA OPTAB(135)/ 848035840/,OPTAB(136)/     21664/                13748000
      DATA OPTAB(137)/ 848773120/,OPTAB(138)/     20164/                13749000
      DATA OPTAB(139)/ 850538496/,OPTAB(140)/       764/                13750000
      DATA OPTAB(141)/ 850657280/,OPTAB(142)/     24864/                13751000
      DATA OPTAB(143)/ 851062784/,OPTAB(144)/     20864/                13752000
      DATA OPTAB(145)/ 851156992/,OPTAB(146)/     19264/                13753000
      DATA OPTAB(147)/ 851443712/,OPTAB(148)/     24064/                13754000
      DATA OPTAB(149)/ 851595264/,OPTAB(150)/     23264/                13755000
      DATA OPTAB(151)/ 851636224/,OPTAB(152)/     22464/                13756000
      DATA OPTAB(153)/ 852111360/,OPTAB(154)/      1564/                13757000
      DATA OPTAB(155)/ 852443136/,OPTAB(156)/     19961/                13758000
      DATA OPTAB(157)/ 854065152/,OPTAB(158)/     20064/                13759000
      DATA OPTAB(159)/ 864690176/,OPTAB(160)/     15258/                13760000
      DATA OPTAB(161)/ 864718848/,OPTAB(162)/     22259/                13761000
      DATA OPTAB(163)/ 865550336/,OPTAB(164)/        29/                13762000
      DATA OPTAB(165)/ 866304000/,OPTAB(166)/        16/                13763000
      DATA OPTAB(167)/ 866306304/,OPTAB(168)/      3463/                13764000
      DATA OPTAB(169)/ 866328576/,OPTAB(170)/        17/                13765000
      DATA OPTAB(171)/ 868387584/,OPTAB(172)/     24964/                13766000
      DATA OPTAB(173)/ 869404672/,OPTAB(174)/      5063/                13767000
      DATA OPTAB(175)/ 869408256/,OPTAB(176)/       257/                13768000
      DATA OPTAB(177)/ 869412864/,OPTAB(178)/      5564/                13769000
      DATA OPTAB(179)/ 869670912/,OPTAB(180)/     14458/                13770000
      DATA OPTAB(181)/ 869699584/,OPTAB(182)/     21459/                13771000
      DATA OPTAB(183)/ 883378981/,OPTAB(184)/        30/                13772000
      DATA OPTAB(185)/ 948865472/,OPTAB(186)/     23564/                13773000
      DATA OPTAB(187)/ 952049664/,OPTAB(188)/        14/                13774000
      DATA OPTAB(189)/ 952766464/,OPTAB(190)/     16858/                13775000
      DATA OPTAB(191)/ 952799232/,OPTAB(192)/     23859/                13776000
      DATA OPTAB(193)/ 953322240/,OPTAB(194)/     22764/                13777000
C                                                                       13778000
      DATA OPTL /194/                                                   13779000
C                                                                       13781000
      DATA SYMTAB(1)/21/                                                13782000
      DATA SYMTAB(2)/553648128/,SYMTAB(3)/        449/                  13783000
      DATA SYMTAB(4)/570425344/,SYMTAB(5)/          1/                  13784000
      DATA SYMTAB(6)/587202560/,SYMTAB(7)/         65/                  13785000
      DATA SYMTAB(8)/603979776/,SYMTAB(9)/        129/                  13786000
      DATA SYMTAB(10)/620756992/,SYMTAB(11)/      193/                  13787000
      DATA SYMTAB(12)/671088640/,SYMTAB(13)/      257/                  13788000
      DATA SYMTAB(14)/738197504/,SYMTAB(15)/      321/                  13789000
      DATA SYMTAB(16)/754974720/,SYMTAB(17)/      385/                  13790000
      DATA SYMTAB(18)/818900992/,SYMTAB(19)/      385/                  13791000
      DATA SYMTAB(20)/868220928/,SYMTAB(21)/      385/                  13792000
C                                                                       13793000
      DATA SYMAX /22/                                                   13794000
      DATA FREMEM /1750/                                                13795000
      DATA SYMSIZ /1750/                                                13796000
      DATA MAXNP /10/                                                   13797000
      DATA REFBIT /16777216/                                            13798000
      DATA MULTI /8388608/                                              13799000
C                                                                       13800000
C                                                                       13801000
C                                                                       13802000
      END                                                               13803000
