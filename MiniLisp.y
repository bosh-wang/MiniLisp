%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();

char var_name[100][100];
int var_value[100];
int varArrayIndex = 0;

int redefine = 0;

void yyerror(const char* message) {
    printf("syntax error\n");
};

%}

%union {
    int intVal;
    char *str;
}

%token ADD SUB MUL DIV MOD GREAT SMALL EQU 
%token AND OR NOT
%token NUMBER ID BOOL SEP
%token Left_P Right_P
%token DEFINE IF
%token PRINT_NUM PRINT_BOOL

%type <intVal> NUMBER

%type <intVal> EXP
%type <intVal> NUM_OP PLUS PLUS_EXPS MINUS MULTIPLY MULTIPLY_EXPS DIVIDE MODULUS GREATER SMALLER EQUAL EQUAL_EXPS
%type <intVal> LOGICAL_OP AND_OP AND_EXPS OR_OP OR_EXPS NOT_OP
%type <intVal> IF_EXP TEST_EXP THEN_EXP ELSE_EXP

%type <str> ID BOOL VARIABLE


%%
PROGRAM 
        : STMTS
        ;
    
STMTS
        : STMT STMTS
        | STMT
        ;

STMT 
        : EXP   
        | DEF_STMT  
        | PRINT_STMT
        ;

PRINT_STMT
        : Left_P PRINT_NUM SEP EXP Right_P {
            printf("%d\n", $4);
        }
        | Left_P PRINT_BOOL SEP EXP Right_P {
            if ($4) {
                printf("#t\n");
            }
            else {
                printf("#f\n");
            }
        }
        ;

EXP
        : BOOL {
            if ( (*(++$1)) == 116) {
                $$ = 1;
            }
            else {
                $$ = 0;
            }
        }
        | NUMBER {
            $$ = $1;
        }
        | VARIABLE {
            int i;
            for (i=0; i<=varArrayIndex; i++) {
                if (strcmp(var_name[i], $1) == 0) {
                    $$ = var_value[i];
                    break;
                }
            }
        }
        | NUM_OP        {$$ = $1;}
        | LOGICAL_OP    {$$ = $1;}
        | IF_EXP        {$$ = $1;}
        ;

NUM_OP
        : PLUS          {$$ = $1;}
        | MINUS         {$$ = $1;}
        | MULTIPLY      {$$ = $1;}
        | DIVIDE        {$$ = $1;}
        | MODULUS       {$$ = $1;}
        | GREATER       {$$ = $1;}
        | SMALLER       {$$ = $1;}
        | EQUAL         {$$ = $1;}
        ;
PLUS
        : Left_P ADD SEP EXP SEP PLUS_EXPS Right_P {
            $$ = $4 + $6;
        }
        ;
PLUS_EXPS
        : EXP SEP PLUS_EXPS {
            $$ = $1 + $3;
        }
        | EXP {
            $$ = $1;
        }
        ;

MINUS
        : Left_P SUB SEP EXP SEP EXP Right_P {
            $$ = $4 - $6;
        }
        ;

MULTIPLY
        : Left_P MUL SEP EXP SEP MULTIPLY_EXPS Right_P {
            $$ = $4 * $6;
        }
        ;
MULTIPLY_EXPS
        : EXP SEP MULTIPLY_EXPS {
            $$ = $1 * $3;
        }
        | EXP {
            $$ = $1;
        }
        ;

DIVIDE
        : Left_P DIV SEP EXP SEP EXP Right_P {
            $$ = $4 / $6;
        }
        ;

MODULUS
        : Left_P MOD SEP EXP SEP EXP Right_P {
            $$ = $4 % $6;
        }
        ;

GREATER 
        : Left_P GREAT SEP EXP SEP EXP Right_P {
            if ($4 > $6){
                $$ = 1; 
            }
            else {
                $$ = 0;
            }
        }
        ;
        
SMALLER 
        : Left_P SMALL SEP EXP SEP EXP Right_P{
            if ($4 < $6) {
                $$ = 1; 
            }
            else {
                $$ = 0;
            }
        }
        ;

EQUAL 
        : Left_P EQU SEP EXP SEP EQUAL_EXPS Right_P{
            if ($4 == $6) {
                $$ = 1;
            }
            else {
                $$ = 0;
            }
        }
        ;
EQUAL_EXPS
        : EXP SEP EQUAL_EXPS{
            if ($1 == $3) {
                $$ = 1;
            }
            else {
                $$ = 0;
            }
        }
        | EXP { 
            $$ = $1;
        }
        ;

LOGICAL_OP
        : AND_OP        {$$ = $1;}
        | OR_OP         {$$ = $1;}
        | NOT_OP        {$$ = $1;}
        ;

AND_OP
        : Left_P AND SEP EXP SEP AND_EXPS Right_P {
            $$ = ($4 & $6);
        }
        ;
AND_EXPS
        : EXP SEP AND_EXPS {
            $$ = ($1 & $3);
        }
        | EXP {
            $$ = $1;
        }
        ;

OR_OP
        : Left_P OR SEP EXP SEP OR_EXPS Right_P {
            $$ = ($4 | $6);
        }
        ;
OR_EXPS
        : EXP SEP OR_EXPS {
            $$ = ($1 | $3);
        }
        | EXP {
            $$ = $1;
        }
        ;

NOT_OP
        : Left_P NOT SEP EXP Right_P {
            $$ = !$4;
        }
        ;

DEF_STMT
        : Left_P DEFINE SEP VARIABLE SEP EXP Right_P{
            int i;
            // if (varArrayIndex != 0){
                for (i=0; i<varArrayIndex; i++) {
                    if (strcmp($4, var_name[i]) == 0) {
                        printf("This variable has been defined!\n");
                        redefine = 1;
                        break;
                    }
                }
            // }
            if (!redefine) {
                strcpy(var_name[varArrayIndex], $4);
                var_value[varArrayIndex] = $6;
                varArrayIndex++;
            }
            redefine = 0;
        }
        ;
VARIABLE
        : ID {
            strcpy($$, $1);
        }
        ;

IF_EXP
        : Left_P IF SEP TEST_EXP SEP THEN_EXP SEP ELSE_EXP Right_P{
            if ($4) {
                $$ = $6;
            }
            else {
                $$ = $8;
            }
        }
        ;
TEST_EXP
        : EXP {
            $$ = $1;
        }
        ;
THEN_EXP
        : EXP {
            $$ = $1;
        }
        ;
ELSE_EXP
        : EXP {
            $$ = $1;
        }
        ;

%%

int main(int argc, char *argv[]) {
        yyparse();

        return(0);
}
