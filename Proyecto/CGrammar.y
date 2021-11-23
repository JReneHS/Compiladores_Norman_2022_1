%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	void yyerror(char *mensaje){
		printf("ERROR: %s\n", mensaje);
		exit(0);
	}
%}

%union
{
	char *valor;
}

%token <valor> IDENTIFICADOR CONSTANTE LITERAL_CADENA SIZEOF
%token <valor> OP_PTR OP_INC OP_DEC OP_IZQ OP_DER OP_MENIG OP_MAYIG OP_IGUAL OP_DIF
%token <valor> OP_AND OP_OR ASIGNACION_MUL ASIGNACION_DIV ASIGNACION_MOD ASIGNACION_SUM
%token <valor> ASIGNACION_RES ASIGNACION_IZQ ASIGNACION_DER ASIGNACION_AND
%token <valor> ASIGNACION_XOR ASIGNACION_OR ';' '{' '}' ',' ':' '=' '(' ')' '[' ']'
%token <valor> '.' '&' '!' '~' '-' '+' '*' '/' '%' '<' '>' '^' '|' '?'  

%token <valor> TYPEDEF EXTERN STATIC AUTO REGISTER
%token <valor> CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token <valor> STRUCT UNION ENUM ELLIPSIS

%token <valor> CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%type <valor> expresion_primaria
%type <valor> expresion_postfija
%type <valor> lista_expresiones_argumentos
%type <valor> expresion_unaria
%type <valor> operador_unario
%type <valor> expresion_cast
%type <valor> expresion_multiplicativa
%type <valor> expresion_aditiva
%type <valor> expresion_cambio
%type <valor> expresion_relacional
%type <valor> expresion_igualdad
%type <valor> expresion_and
%type <valor> expresion_or_exclusivo
%type <valor> expresion_or_inclusivo
%type <valor> expresion_logica_and
%type <valor> expresion_logica_or
%type <valor> expresion_condicional
%type <valor> expresion_asignacion
%type <valor> operador_asignacion
%type <valor> expresion
%type <valor> expresion_constante
%type <valor> declaracion
%type <valor> especificador_declaracion
%type <valor> lista_declaradores_inicializacion
%type <valor> declarador_inicializacion
%type <valor> especificador_clase_almacenamiento
%type <valor> especificador_tipo
%type <valor> especificador_estructura_o_union
%type <valor> estructura_o_union
%type <valor> lista_declaraciones_estructura
%type <valor> declaracion_estructura
%type <valor> lista_calificadores_especificador
%type <valor> lista_declaradores_estructura
%type <valor> declarador_estructura
%type <valor> especificador_enum
%type <valor> lista_enumeradores
%type <valor> enumerador
%type <valor> calificador_tipo
%type <valor> declarador
%type <valor> declarador_directo
%type <valor> puntero
%type <valor> lista_calificadores_tipo
%type <valor> lista_parametros_tipo
%type <valor> lista_parametros
%type <valor> declaracion_parametro
%type <valor> lista_identificadores
%type <valor> declarador_abstracto
%type <valor> declarador_abstracto_directo
%type <valor> inicializador
%type <valor> lista_inicializadores
%type <valor> afirmacion
%type <valor> afirmacion_etiquetada
%type <valor> afirmacion_compuesta
%type <valor> lista_declaraciones
%type <valor> lista_afirmaciones
%type <valor> afirmacion_expresion
%type <valor> afirmacion_seleccion
%type <valor> afirmacion_iteracion
%type <valor> afirmacion_salto
%type <valor> unidad_traduccion
%type <valor> declaracion_externa
%type <valor> definicion_funcion 
%type <valor> nombre_tipo



%start unidad_traduccion
%%

expresion_primaria
	: IDENTIFICADOR {$$ = $1;}
	| CONSTANTE 	{$$ = $1;}
	| LITERAL_CADENA {$$ = $1;}
	| '(' expresion ')' {$$=$2;}
	;

expresion_postfija
	: expresion_primaria {$$ = $1;}
	| expresion_postfija '[' expresion ']'	{strcat($1,"[");strcat($1,$3);strcat($1,"]");$$=$1;}
	| expresion_postfija '(' ')' 			{strcat($1,"()");$$ = $1;}
	| expresion_postfija '(' lista_expresiones_argumentos ')'		{strcat($1,"(");strcat($1,$3);strcat($1,")");$$=$1;}
	| expresion_postfija '.' IDENTIFICADOR    	{strcat($1,".");strcat($1,$3);$$=$1;}
	| expresion_postfija OP_PTR IDENTIFICADOR   {strcat($1," ");strcat($1,$2);strcat($1," ");strcat($1,$3);$$=$1;}
	| expresion_postfija OP_INC	{strcat($1," ");strcat($1,$2);$$=$1;}
	| expresion_postfija OP_DEC	{strcat($1," ");strcat($1,$2);$$=$1;}
	;

lista_expresiones_argumentos
	: expresion_asignacion {$$ =$1;}
	| lista_expresiones_argumentos ',' expresion_asignacion	{strcat($1,", ");strcat($1,$3);$$=$1;}
	;

expresion_unaria
	: expresion_postfija	{$$ = $1;}
	| OP_INC expresion_unaria	{strcat($1," ");strcat($1,$2);$$=$1;}
	| OP_DEC expresion_unaria	{strcat($1," ");strcat($1,$2);$$=$1;}
	| operador_unario expresion_cast 	{strcat($1," ");strcat($1,$2);$$=$1;}
	| SIZEOF expresion_unaria 	{strcat($1," ");strcat($1,$2);$$=$1;}
	| SIZEOF '(' nombre_tipo ')'	{strcat($1,"( ");strcat($1,$2);strcat($1," )");$$=$1;}
	;

operador_unario
	: '&'	{$$=$1;}
	| '*'	{$$=strdup($1);}
	| '+'	{$$=$1;}
	| '-'	{$$=$1;}
	| '~'	{$$=$1;}
	| '!'	{$$=$1;}
	;

expresion_cast
	: expresion_unaria {$$=$1;}
	| '(' nombre_tipo ')' expresion_cast {strcat($1,$2);strcat($1,$3);strcat($1,$4);$$=$1;}
	;

expresion_multiplicativa
	: expresion_cast 	{$$=$1;}
	| expresion_multiplicativa '*' expresion_cast 	{strcat($1," * ");strcat($1,$3);$$=$1;}
	| expresion_multiplicativa '/' expresion_cast 	{strcat($1," / ");strcat($1,$3);$$=$1;}
	| expresion_multiplicativa '%' expresion_cast 	{strcat($1," % ");strcat($1,$3);$$=$1;}
	;

expresion_aditiva
	: expresion_multiplicativa {$$=$1;}
	| expresion_aditiva '+' expresion_multiplicativa 	{strcat($1," + ");strcat($1,$3);$$=$1;}
	| expresion_aditiva '-' expresion_multiplicativa 	{strcat($1," - ");strcat($1,$3);$$=$1;}
	;

expresion_cambio
	: expresion_aditiva 	{$$=$1;}
	| expresion_cambio OP_IZQ expresion_aditiva 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	| expresion_cambio OP_DER expresion_aditiva 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_relacional
	: expresion_cambio 	{$$=$1;}
	| expresion_relacional '<' expresion_cambio 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	| expresion_relacional '>' expresion_cambio 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	| expresion_relacional OP_MENIG expresion_cambio 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	| expresion_relacional OP_MAYIG expresion_cambio 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_igualdad
	: expresion_relacional 	{$$ = $1;}
	| expresion_igualdad OP_IGUAL expresion_relacional 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	| expresion_igualdad OP_DIF expresion_relacional 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_and
	: expresion_igualdad 	{$$=$1;}
	| expresion_and '&' expresion_igualdad 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_or_exclusivo
	: expresion_and {$$=$1;}
	| expresion_or_exclusivo '^' expresion_and 	{strcat($1," ^ ");strcat($1,$3);$$=$1;}
	;

expresion_or_inclusivo
	: expresion_or_exclusivo {$$=$1;}
	| expresion_or_inclusivo '|' expresion_or_exclusivo {strcat($1," | ");strcat($1,$3);$$=$1;}
	;

expresion_logica_and
	: expresion_or_inclusivo 	{$$=$1;}
	| expresion_logica_and OP_AND expresion_or_inclusivo 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_logica_or
	: expresion_logica_and 	{$$=$1;}
	| expresion_logica_or OP_OR expresion_logica_and 	{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

expresion_condicional
	: expresion_logica_or 	{$$=$1;}
	| expresion_logica_or '?' expresion ':' expresion_condicional 	{strcat($1," ");strcat($1,$2);$$=$1;}
	;

expresion_asignacion
	: expresion_condicional 	{$$=$1;}
	| expresion_unaria operador_asignacion expresion_asignacion {strcat($1,$2);strcat($1,$3);$$=$1;}
	;

operador_asignacion
	: '=' {$$ =$1;}
	| ASIGNACION_MUL 	{$$=$1;}
	| ASIGNACION_DIV 	{$$=$1;}
	| ASIGNACION_MOD 	{$$=$1;}
	| ASIGNACION_SUM 	{$$=$1;}
	| ASIGNACION_RES 	{$$=$1;}
	| ASIGNACION_IZQ 	{$$=$1;}
	| ASIGNACION_DER 	{$$=$1;}
	| ASIGNACION_AND 	{$$=$1;}
	| ASIGNACION_XOR 	{$$=$1;}
	| ASIGNACION_OR 	{$$=$1;}
	;

expresion
	: expresion_asignacion 	{$$=$1;}
	| expresion ',' expresion_asignacion 	{strcat($1,", ");strcat($1,$3);$$=$1;}
	;

expresion_constante
	: expresion_condicional 	{$$=$1;}
	;

declaracion
	: especificador_declaracion ';' 	{char *tmp=strdup($1);strcpy($1,"\n\t*Declaracion: ");strcat($1,tmp);strcat($1,";");;$$=$1;}
	| especificador_declaracion lista_declaradores_inicializacion ';' 	{char *tmp=strdup($1);strcpy($1,"\n\t*Declaracion: ");strcat($1,tmp);strcat($1," ");strcat($1,$2);strcat($1,";");$$=$1;}
	;

especificador_declaracion
	: especificador_clase_almacenamiento 	{$$=$1;}
	| especificador_clase_almacenamiento especificador_declaracion 	{strcat($1,$2);$$=$1;}
	| especificador_tipo 	{$$=$1;} 
	| especificador_tipo especificador_declaracion 	{strcat($1,$2);$$=$1;}
	| calificador_tipo 	{$$=$1;}
	| calificador_tipo especificador_declaracion 	{strcat($1,$2);$$=$1;}
	;

lista_declaradores_inicializacion
	: declarador_inicializacion 	{$$=$1;}
	| lista_declaradores_inicializacion ',' declarador_inicializacion {strcat($1," , ");strcat($1,$3);$$=$1;}
	;

declarador_inicializacion
	: declarador 	{$$=$1;}
	| declarador '=' inicializador 		{strcat($1," = ");strcat($1,$3);$$=$1;} 
	;

especificador_clase_almacenamiento
	: TYPEDEF 	{$$=$1;}
	| EXTERN 	{$$=$1;}
	| STATIC 	{$$=$1;}
	| AUTO 		{$$=$1;}
	| REGISTER 	{$$=$1;}
	;

especificador_tipo
	: VOID 		{$$=$1;}
	| CHAR 		{$$=$1;}
	| SHORT 	{$$=$1;}
	| INT 		{$$=$1;}
	| LONG 		{$$=$1;}
	| FLOAT 	{$$=$1;}
	| DOUBLE 	{$$=$1;}
	| SIGNED 	{$$=$1;}
	| UNSIGNED 	{$$=$1;}
	| especificador_estructura_o_union 		{$$=$1;}
	| especificador_enum 		{$$=$1;}
	;

especificador_estructura_o_union
	: estructura_o_union IDENTIFICADOR '{' lista_declaraciones_estructura '}' 	{strcat($1,$2);strcat($1,"{");strcat($1,$4);strcat($1,"}");$$=$1;} 	
	| estructura_o_union '{' lista_declaraciones_estructura '}' 	{strcat($1,3);$$=$1;}
	| estructura_o_union IDENTIFICADOR 		{strcat($1,$2);$$=$1;}
	;

estructura_o_union
	: STRUCT 	{$$=$1;}
	| UNION 	{$$=$1;}
	;
 
lista_declaraciones_estructura
	: declaracion_estructura 	{$$=$1;}
	| lista_declaraciones_estructura declaracion_estructura 	{strcat($1,$2);$$=$1;}
	;

declaracion_estructura
	: lista_calificadores_especificador lista_declaradores_estructura ';' {strcat($1,$2);strcat($1,";");$$=$1;}
	;

lista_calificadores_especificador
	: especificador_tipo lista_calificadores_especificador 		{strcat($1,$2);$$=$1;}
	| especificador_tipo 	{$$=$1;}
	| calificador_tipo lista_calificadores_especificador 		{strcat($1,$2);$$=$1;}
	| calificador_tipo 		{$$=$1;}
	;

lista_declaradores_estructura
	: declarador_estructura {$$=$1;}
	| lista_declaradores_estructura ',' declarador_estructura {strcat($1,",");strcat($1,$3);$$=$1;}
	;

declarador_estructura
	: declarador 	{$$=$1;}
	| ':' expresion_constante 		{strcat($1,$2);$$=$1;}
	| declarador ':' expresion_constante 		{strcat($1,":");strcat($1,$3);$$=$1;}
	;

especificador_enum
	: ENUM '{' lista_enumeradores '}' {strcat($1,"{");strcat($1,$3);strcat($1,"}");$$=$1;} 
	| ENUM IDENTIFICADOR '{' lista_enumeradores '}' 	{strcat($1,$2);strcat($1,"{");strcat($1,$4);strcat($1,"}");$$=$1;}
	| ENUM IDENTIFICADOR 	{strcat($1,$2);$$=$1;}
	;

lista_enumeradores
	: enumerador 	{$$=$1;}
	| lista_enumeradores ',' enumerador 	{strcat($1,",");strcat($1,$3);$$=$1;}
	;

enumerador
	: IDENTIFICADOR {$$=$1;}
	| IDENTIFICADOR '=' expresion_constante 		{strcat($1,"=");strcat($1,$3);$$=$1;}
	;

calificador_tipo
	: CONST 		{$$=$1;}
	| VOLATILE 		{$$=$1;}
	;

declarador
	: puntero declarador_directo 	{strcat($1,$2);$$=$1;}
	| declarador_directo 	{$$=$1;}
	;

declarador_directo
	: IDENTIFICADOR 	{$$=$1;}
	| '(' declarador ')' 			{strcat($1,"(");strcat($1,$3);strcat($1,")");$$=$1;} 					
	| declarador_directo '[' expresion_constante ']'		{strcat($1,"[");strcat($1,$3);strcat($1,"]");$$=$1;}
	| declarador_directo '[' ']' 			{strcat($1,$2);$$=$1;}
	| declarador_directo '(' lista_parametros_tipo ')' 			{strcat($1,"(");strcat($1,$3);strcat($1,")");$$=$1;}		
	| declarador_directo '(' lista_identificadores ')' 			{strcat($1,"(");strcat($1,$3);strcat($1,")");$$=$1;}
	| declarador_directo '(' ')' 			{$$=$1;}
	;

puntero
	: '*' 		{$$=$1;}
	| '*' lista_calificadores_tipo 			{strcat($1,$2);$$=$1;}
	| '*' puntero  		{strcat($1,$2);$$=$1;}
	| '*' lista_calificadores_tipo puntero 		{strcat($1,$2);strcat($1,$3);$$=$1;}
	;

lista_calificadores_tipo
	: calificador_tipo  		{$$=$1;}
	| lista_calificadores_tipo calificador_tipo  		{strcat($1,$2);$$=$1;}
	;


lista_parametros_tipo
	: lista_parametros  		{$$=$1;}
	| lista_parametros ',' ELLIPSIS  		{strcat($1,",");strcat($1,$3);$$=$1;}
	;

lista_parametros
	: declaracion_parametro  		{$$=$1;}
	| lista_parametros ',' declaracion_parametro  		{strcat($1,",");strcat($1,$3);$$=$1;}
	;

declaracion_parametro
	: especificador_declaracion declarador 				{strcat($1,$2);$$=$1;}
	| especificador_declaracion declarador_abstracto 	{strcat($1,$2);$$=$1;}
	| especificador_declaracion 		{$$=$1;}
	;

lista_identificadores
	: IDENTIFICADOR  		{$$=$1;}
	| lista_identificadores ',' IDENTIFICADOR  			{strcat($1,",");strcat($1,$3);$$=$1;}
	;

nombre_tipo
	: lista_calificadores_especificador 		{$$=$1;}
	| lista_calificadores_especificador declarador_abstracto 		{strcat($1,$2);$$=$1;}
	;

declarador_abstracto
	: puntero 	 	{$$=$1;}
	| declarador_abstracto_directo  	{$$=$1;}
	| puntero declarador_abstracto_directo  		{strcat($1,$2);$$=$1;}
	;

declarador_abstracto_directo
	: '(' declarador_abstracto ')'  		{strcat($1,"(");strcat($1,$3);strcat($1,")");$$=$1;} 
	| '[' ']'  			{strcat($1,$2);$$=$1;}
	| '[' expresion_constante ']' 					{strcat($1,"[");strcat($1,$3);strcat($1,"]");$$=$1;}
	| declarador_abstracto_directo '[' ']' 			{strcat($1,"[]");$$=$1;}
	| declarador_abstracto_directo '[' expresion_constante ']' 		{strcat($1,3);$$=$1;} 
	| '(' ')' 			
	| '(' lista_parametros_tipo ')' 			{$$=$2;}
	| declarador_abstracto_directo '(' ')' 		{$$=$1;}
	| declarador_abstracto_directo '(' lista_parametros_tipo ')' 		{strcat($1,$3);$$=$1;}
	;

inicializador
	: expresion_asignacion {$$=$1;}
	| '{' lista_inicializadores '}' {$$=$2;}
	| '{' lista_inicializadores ',' '}'		{$$=$2;}
	;

lista_inicializadores
	: inicializador  		{$$=$1;}
	| lista_inicializadores ',' inicializador {strcat($1,",");strcat($1,$3);$$=$1;}
	;

afirmacion
	: afirmacion_etiquetada {char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion etiquetada: ");strcat($1,tmp);$$=$1;}
	| afirmacion_compuesta 	{char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion compuesta ");strcat($1,tmp);$$=$1;}
	| afirmacion_expresion 	{char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion de expresion: ");strcat($1,tmp);$$=$1;}
	| afirmacion_seleccion 	{char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion de seleccion: ");strcat($1,tmp);$$=$1;}
	| afirmacion_iteracion 	{char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion de iteracion: ");strcat($1,tmp);$$=$1;}
	| afirmacion_salto 		{char *tmp=strdup($1);strcpy($1,"\n\t*Afirmacion de salto: ");strcat($1,tmp);$$=$1;}
	;

afirmacion_etiquetada
	: IDENTIFICADOR ':' afirmacion 		{strcat($1,":");strcat($1,$3);$$=$1;}
	| CASE expresion_constante ':' afirmacion 		{strcat($1,"$2");strcat($1,":");strcat($1,$3);$$=$1;}
	| DEFAULT ':' afirmacion  			{strcat($1,":");strcat($1,$3);$$=$1;}
	;

afirmacion_compuesta
	: '{' '}'
	| '{' lista_afirmaciones '}' 	{$$=$2;}
	| '{' lista_declaraciones '}' 	{$$=$2;}
	| '{' lista_declaraciones lista_afirmaciones '}' {strcat($2,$3);$$=$2;}
	;

lista_declaraciones
	: declaracion 		{$$=$1;}
	| lista_declaraciones declaracion 		{;strcat($1,$2);$$=$1;}
	;

lista_afirmaciones
	: afirmacion 		{$$=$1;}
	| lista_afirmaciones afirmacion 		{strcat($1,$2);$$=$1;}
	;

afirmacion_expresion
	: ';' 
	| expresion ';' 		{strcat($1,";");$$=$1;}  			
	;

afirmacion_seleccion
	: IF '(' expresion ')' afirmacion 			{$$=$1;}
	| IF '(' expresion ')' afirmacion ELSE afirmacion 		{strcat($1,$6);$$=$1;}
	| SWITCH '(' expresion ')' afirmacion 		{$$=$1;}
	;

afirmacion_iteracion
	: WHILE '(' expresion ')' afirmacion 				{$$=$1;}
	| DO afirmacion WHILE '(' expresion ')' ';' 		{strcat($1,$3);$$=$1;}
	| FOR '(' afirmacion_expresion afirmacion_expresion ')' afirmacion 			{$$=$1;}
	| FOR '(' afirmacion_expresion afirmacion_expresion expresion ')' afirmacion 		{$$=$1;}
	;

afirmacion_salto
	: GOTO IDENTIFICADOR ';' 	{$$=$1;}
	| CONTINUE ';'				{$$=$1;}
	| BREAK ';'					{$$=$1;}
	| RETURN ';' 				{$$=$1;}
	| RETURN expresion ';'		{$$=$1;}
	;

unidad_traduccion
	: declaracion_externa 		{$$=$1;}
	| unidad_traduccion declaracion_externa 	{strcat($1,$2);$$=$1;}
	;

declaracion_externa
	: definicion_funcion 		{$$=$1;}
	| declaracion 				{$$=$1;}
	;

definicion_funcion
	: especificador_declaracion declarador lista_declaraciones afirmacion_compuesta {printf("Especificador de delcaración: %s\nDeclarador: %s\n Lista de declaraciones:%s\nAfirmacion compuesta:\n%s\n", $1,$2,$3,$4);}
	| especificador_declaracion declarador afirmacion_compuesta {printf("Especificador de delcaración: %s\nDeclarador: %s\nAfirmacion compuesta:\n%s\n", $1,$2,$3);}
	| declarador lista_declaraciones afirmacion_compuesta {printf("Declarador: %s\n Lista de declaraciones:%s\nAfirmacion compuesta:\n%s\n", $1,$2,$3);}
	| declarador afirmacion_compuesta {printf("Declarador: %s\nAfirmacion compuesta:\n%s\n", $1,$2);}
	;

%%
