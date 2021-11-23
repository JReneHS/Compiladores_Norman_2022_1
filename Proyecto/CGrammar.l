
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "CGrammar.tab.h"

%}

%%
"/*"			{ comment(); }

"auto"			{ yylval.valor = strdup(yytext); return(AUTO); }
"break"			{ yylval.valor = strdup(yytext); return(BREAK); }
"case"			{ yylval.valor = strdup(yytext); return(CASE); }
"char"			{ yylval.valor = strdup(yytext); return(CHAR); }
"const"			{ yylval.valor = strdup(yytext); return(CONST); }
"continue"		{ yylval.valor = strdup(yytext); return(CONTINUE); }
"default"		{ yylval.valor = strdup(yytext); return(DEFAULT); }
"do"			{ yylval.valor = strdup(yytext); return(DO); }
"double"		{ yylval.valor = strdup(yytext); return(DOUBLE); }
"else"			{ yylval.valor = strdup(yytext); return(ELSE); }
"enum"			{ yylval.valor = strdup(yytext); return(ENUM); }
"extern"		{ yylval.valor = strdup(yytext); return(EXTERN); }
"float"			{ yylval.valor = strdup(yytext); return(FLOAT); }
"for"			{ yylval.valor = strdup(yytext); return(FOR); }
"goto"			{ yylval.valor = strdup(yytext); return(GOTO); }
"if"			{ yylval.valor = strdup(yytext); return(IF); }
"int"			{ yylval.valor = strdup(yytext); return(INT); }
"long"			{ yylval.valor = strdup(yytext); return(LONG); }
"register"		{ yylval.valor = strdup(yytext); return(REGISTER); }
"return"		{ yylval.valor = strdup(yytext); return(RETURN); }
"short"			{ yylval.valor = strdup(yytext); return(SHORT); }
"signed"		{ yylval.valor = strdup(yytext); return(SIGNED); }
"sizeof"		{ yylval.valor = strdup(yytext); return(SIZEOF); }
"static"		{ yylval.valor = strdup(yytext); return(STATIC); }
"struct"		{ yylval.valor = strdup(yytext); return(STRUCT); }
"switch"		{ yylval.valor = strdup(yytext); return(SWITCH); }
"typedef"		{ yylval.valor = strdup(yytext); return(TYPEDEF); }
"union"			{ yylval.valor = strdup(yytext); return(UNION); }
"unsigned"		{ yylval.valor = strdup(yytext); return(UNSIGNED); }
"void"			{ yylval.valor = strdup(yytext); return(VOID); }
"volatile"		{ yylval.valor = strdup(yytext); return(VOLATILE); }
"while"			{ yylval.valor = strdup(yytext); return(WHILE); }

{L}({L}|{D})*			{ yylval.valor = strdup(yytext); return(IDENTIFICADOR); }

0[xX]{H}+{IS}?			{ yylval.valor = strdup(yytext); return(CONSTANTE); }
0{D}+{IS}?				{ yylval.valor = strdup(yytext); return(CONSTANTE); }
{D}+{IS}?				{ yylval.valor = strdup(yytext); return(CONSTANTE); }
L?'(\\.|[^\\'])+'		{ yylval.valor = strdup(yytext); return(CONSTANTE); }

{D}+{E}{FS}?			{ yylval.valor = strdup(yytext); return(CONSTANTE); }
{D}*"."{D}+({E})?{FS}?	{ yylval.valor = strdup(yytext); return(CONSTANTE); }
{D}+"."{D}*({E})?{FS}?	{ yylval.valor = strdup(yytext); return(CONSTANTE); }

L?\"(\\.|[^\\"])*\"		{ yylval.valor = strdup(yytext); return(LITERAL_CADENA); }

"..."			{ yylval.valor = strdup(yytext); return(ELLIPSIS); }
">>="			{ yylval.valor = strdup(yytext); return(ASIGNACION_DER); }
"<<="			{ yylval.valor = strdup(yytext); return(ASIGNACION_IZQ); }
"+="			{ yylval.valor = strdup(yytext); return(ASIGNACION_SUM); }
"-="			{ yylval.valor = strdup(yytext); return(ASIGNACION_RES); }
"*="			{ yylval.valor = strdup(yytext); return(ASIGNACION_MUL); }
"/="			{ yylval.valor = strdup(yytext); return(ASIGNACION_DIV); }
"%="			{ yylval.valor = strdup(yytext); return(ASIGNACION_MOD); }
"&="			{ yylval.valor = strdup(yytext); return(ASIGNACION_AND); }
"^="			{ yylval.valor = strdup(yytext); return(ASIGNACION_XOR); }
"|="			{ yylval.valor = strdup(yytext); return(ASIGNACION_OR); }
">>"			{ yylval.valor = strdup(yytext); return(OP_DER); }
"<<"			{ yylval.valor = strdup(yytext); return(OP_IZQ); }
"++"			{ yylval.valor = strdup(yytext); return(OP_INC); }
"--"			{ yylval.valor = strdup(yytext); return(OP_DEC); }
"->"			{ yylval.valor = strdup(yytext); return(OP_PTR); }
"&&"			{ yylval.valor = strdup(yytext); return(OP_AND); }
"||"			{ yylval.valor = strdup(yytext); return(OP_OR); }
"<="			{ yylval.valor = strdup(yytext); return(OP_MENIG); }
">="			{ yylval.valor = strdup(yytext); return(OP_MAYIG); }
"=="			{ yylval.valor = strdup(yytext); return(OP_IGUAL); }
"!="			{ yylval.valor = strdup(yytext); return(OP_DIF); }
";"				{ yylval.valor = strdup(yytext); return(';'); }
("{"|"<%")		{ yylval.valor = strdup(yytext); return('{'); }
("}"|"%>")		{ yylval.valor = strdup(yytext); return('}'); }
","				{ yylval.valor = strdup(yytext); return(','); }
":"				{ yylval.valor = strdup(yytext); return(':'); }
"="				{ yylval.valor = strdup(yytext); return('='); }
"("				{ yylval.valor = strdup(yytext); return('('); }
")"				{ yylval.valor = strdup(yytext); return(')'); }
("["|"<:")		{ yylval.valor = strdup(yytext); return('['); }
("]"|":>")		{ yylval.valor = strdup(yytext); return(']'); }
"."				{ yylval.valor = strdup(yytext); return('.'); }
"&"				{ yylval.valor = strdup(yytext); return('&'); }
"!"				{ yylval.valor = strdup(yytext); return('!'); }
"~"				{ yylval.valor = strdup(yytext); return('~'); }
"-"				{ yylval.valor = strdup(yytext); return('-'); }
"+"				{ yylval.valor = strdup(yytext); return('+'); }
"*"				{ yylval.valor = strdup(yytext); return('*'); }
"/"				{ yylval.valor = strdup(yytext); return('/'); }
"%"				{ yylval.valor = strdup(yytext); return('%'); }
"<"				{ yylval.valor = strdup(yytext); return('<'); }
">"				{ yylval.valor = strdup(yytext); return('>'); }
"^"				{ yylval.valor = strdup(yytext); return('^'); }
"|"				{ yylval.valor = strdup(yytext); return('|'); }
"?"				{ yylval.valor = strdup(yytext); return('?'); }

[ \t\v\n\f]		{ yylval.valor = strdup(yytext); }
.			{ /* ignore bad characters */ }

%%

yywrap()
{
	return(1);
}


comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}


int column = 0;
