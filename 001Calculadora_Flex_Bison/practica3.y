%{
    #include <stdio.h>
    #include <math.h>
    void yyerror (char *errm) {
        printf("Error %s", errm);
    }
     %}

%define api.value.type {int}
%token INTP INTN FLOATP FLOATN
%token IP OPM OPD OPL KEW VARVC
%token OPP CLP OPC CLC COMM EQL ENDS

%%

input:
     %empty
     | input line
     ;

line:
    '\n'
    | exp '\n'     { printf("%.10g\n", $1); }
    ;

exp:
    INTP                
    | INTN              
    | exp '+' exp       { $$ = $1 + $3 ;        }
    | exp '-' exp       { $$ = $1 - $3 ;        }
    | exp '*' exp       { $$ = $1 * $3 ;        }
    | exp '/' exp       { $$ = $1 / $3 ;        }
    | exp '%' exp       { $$ = $1 % $3 ;        }
    | exp '>' exp       { $$ = $1 > $3 ;        }
    | exp '<' exp       { $$ = $1 < $3 ;        }
    | exp '&' exp      { $$ = $1 && $3;        }
    | exp '|' exp      { $$ = $1 || $3;        }
    ;
%%
