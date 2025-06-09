%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

%token NUM ID

%token INT BOOL
%token MOVE ROTATE RETURNDOCK CLEANTRASH STARTCLEAN STOPCLEAN READSENSOR
%token IF WHILE REPEAT
%token FRENTE TRAS ESQUERDA DIREITA
%token EQ GT LT
%token AND OR NOT
%token LBRACE RBRACE
%token INC DEC

%left '<' '>' EQ
%left '+' '-'
%left '*' '/'

%%

programa:
    /* vazio */
    | programa comando
;

comando:
    declaracao
    | atribuicao
    | comando_movimento
    | comando_sistema
    | comando_limpeza
    | leitura_sensor
    | comando_controle
;

declaracao:
    INT ID
    | BOOL ID
;

atribuicao:
    ID '=' expressao
    | ID INC
    | ID DEC
;

expressao:
    termo
    | expressao '+' termo
    | expressao '-' termo
;

termo:
    fator
    | termo '*' fator
    | termo '/' fator
;

fator:
    NUM
    | ID
    | '(' expressao ')'
;

condicao:
    expressao GT expressao
    | expressao LT expressao
    | expressao EQ expressao
    | NOT condicao
    | ID
;

comando_movimento:
    MOVE direcao expressao
    | ROTATE rotacao expressao
;

direcao:
    FRENTE
    | TRAS
;

rotacao:
    ESQUERDA
    | DIREITA
;

comando_sistema:
    RETURNDOCK
    | CLEANTRASH
;

comando_limpeza:
    STARTCLEAN
    | STOPCLEAN
;

leitura_sensor:
    READSENSOR expressao
;

comando_controle:
    IF condicao bloco
    | WHILE condicao bloco
    | REPEAT expressao bloco
;

bloco:
    LBRACE programa RBRACE
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

int main(int argc, char **argv) {
    printf("Bem-vindo ao parser do robô de limpeza!\n");
    yyparse();
    printf("Parsing concluído.\n");
    return 0;
}