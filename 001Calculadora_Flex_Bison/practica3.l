UIP [0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]
IP {UIP}"."{UIP}"."{UIP}"."{UIP}
NUMP [0-9]+
NUMN "-"{NUMP}
RNMP {NUMP}"."{NUMP}
RNMN "-"{RNMP}
IDV [_a-zA-Z][_a-zA-Z0-9]*
OPM "+"|"-"|"/"|"*"|"%"
OPD ">"|"<"
OPL "&"|"|"
KEYW "char"|"double"|"float"|"int"|"long"|"short"|"bool"

%{
    #include <stdio.h>
    #include "practica3.tab.h"
%}
%%

{IP} {
        printf("< IP , %s > ",yytext );
        return IP;
    }

{OPM} {
    printf("< OPM , %s > ",yytext);
    return OPM;
    }

{OPD} {
    printf("< OPD , %s > ", yytext);
    return OPD;
    }

{OPL} {
    printf("< OPL , %s > ", yytext);
    }

{KEYW} {
    printf("< KEYW , %s > ", yytext);
    }

{IDV} {
    printf("< VARVC , %s > ", yytext);
    }

{NUMP} {
    printf("< INTP , %s > ", yytext);
    }

{NUMN} {
    printf("< INTN , %s > ", yytext);
    }

{RNMP} {
    printf("< FLOATP , %s > ", yytext);
    }

{RNMN} {
        printf("< FLOATN , %s > ", yytext);
    }

"(" {
    printf("< OPP , %s > ", yytext);
    }

")" {
    printf("< CLP , %s > ", yytext);
    }

"{" {
    printf("< OPC , %s > ", yytext);
    }

"}" {
    printf("< CLC , %s > ", yytext);
    }

"," {
    printf("< COMM , %s > ", yytext);
    }

"=" {
    printf("< EQL , %s > ", yytext);
    }

";" {
    printf("< ENDS , %s > ", yytext);
    }

[ ]* {
    /*Ignora espacios*/
    }

.   {
    /*Ignora cualquier otro caracter no valido*/
   }

"exit()" {
    return 0;
    }
