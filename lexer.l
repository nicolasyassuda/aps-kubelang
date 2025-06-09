%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"
%}

DIGITO [0-9]
LETRA [a-zA-Z]
VAR {LETRA}({LETRA}|{DIGITO})*

%%

"int"           { return INT; }
"bool"          { return BOOL; }
"_move"         { return MOVE; }
"_rotate"       { return ROTATE; }
"_repeat"       { return REPEAT; }
"_while"        { return WHILE; }
"_if"           { return IF; }
"_returndock"   { return RETURNDOCK; }
"_cleanthrash"  { return CLEANTRASH; }
"_startclean"   { return STARTCLEAN; }
"_stopclean"    { return STOPCLEAN; }
"_readSensor"   { return READSENSOR; }

"frente"        { return FRENTE; }
"tras"          { return TRAS; }
"esquerda"      { return ESQUERDA; }
"direita"       { return DIREITA; }

"=="            { return EQ; }
"!"             { return NOT; }
"and"           { return AND; }
"or"            { return OR; }

"++"            { return INC; }
"--"            { return DEC; }

[=+\-*/]        { return yytext[0]; }

">"             { return GT; }
"<"             { return LT; }

"{"             { return LBRACE; }
"}"             { return RBRACE; }

{VAR}           { return ID; }
{DIGITO}+       { return NUM; }

[ \t\n]         ; // Ignora espaços, tabulações e quebras de linha
.               { printf("Caractere não reconhecido: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}