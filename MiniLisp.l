%{
#include "MiniLisp.tab.h"
#include <stdio.h>

%}

separator  [ \t\f\r]+
letter     [a-z]
digit      [0-9]

number     (0|[1-9]{digit}*|-[1-9]{digit}*)
ID         {letter}({letter}|digit|'-')*
bool       #t|#f

%%

"+"     {return ADD;}
"-"     {return SUB;}
"*"     {return MUL;}
"/"     {return DIV;}
"mod"   {return MOD;}
">"     {return GREAT;}
"<"     {return SMALL;}
"="     {return EQU;}
"and"   {return AND;}
"or"    {return OR;}
"not"   {return NOT;}

"("     {return Left_P;}
")"     {return Right_P;}

"define"    {return DEFINE;}
"if"        {return IF;}
"print-num" {return PRINT_NUM;}
"print-bool" {return PRINT_BOOL;}

{number}    {yylval.intVal = atoi(yytext); return NUMBER;}
{ID}        {yylval.str = strdup(yytext); return ID;}
{bool}      {yylval.str = strdup(yytext); return BOOL;}
{separator} {return SEP;}

\n      ;
.       {return(yytext[0]);}
%%
