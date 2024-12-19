%{
#include <stdio.h>

int A[26];
float B[26];
char C[26];
char D[26][26];
int var[26];
int loc[26];
int l[26];
int d[3];
%}

%union {
    int in;
    float f1;
    char ch;
    char s[26];
    int i;
}

%type <f1> stm
%type <f1> exp term factor
%type <f1> assm
%type <in> italz count
%token <in> ID 
%token <ch> CH
%token <s> CHH
%token <in> NUM_INT 
%token <f1> NUM_FLOAT 
%token INT FLOAT CHAR STRING PRINT

%start s
%%
s: s ';' stm
    | stm
    ;

stm: exp 
    | assm
    | declr
    | print
    | count
    ;

count: '+' '+' ID {
            if (l[$3] == 1) {
                ++loc[$3];
                printf("%d\n", loc[$3]);
                $$ = 1;
                d[0] = 1;
                d[1] = $3;
                d[2] = 1;
            } else if (var[$3] == 1) {
                ++A[$3];      
                printf("%d\n", A[$3]);
                $$ = 1;
                d[0] = 1;
                d[1] = $3;
                d[2] = 2;
            } else {
                printf("wrong input\n");
            }
        }
    | '-' '-' ID {
            if (l[$3] == 1) {
                --loc[$3];
                $$ = 1;
                printf("%d\n", loc[$3]);
                d[0] = 2; // Store decrement operation
                d[1] = $3;
                d[2] = 1;
            } else if (var[$3] == 1) {
                --A[$3];
                printf("%d\n", A[$3]);
                $$ = 1;

                d[0] = 2;
                d[1] = $3;
                d[2] = 2;
            } else {
                printf("wrong input\n");
            }
        }
    | ID '+' '+' {
            if (l[$1] == 1) {
                printf("%d\n", loc[$1]);
                loc[$1]++;
                $$ = 1;
                d[0] = 1; // Store increment operation
                d[1] = $1;
                d[2] = 1;
            } else if (var[$1] == 1) {
                printf("%d\n", A[$1]);
                A[$1]++;
                $$ = 1;
                d[0] = 1;
                d[1] = $1;
                d[2] = 2;
            } else {
                printf("wrong input\n");
            }
        }
    | ID '-' '-'
    ;

italz: INT ID '=' NUM_INT {
            if (l[$2] == 0) {
                loc[$2] = $4;
                $$ = loc[$2];
                l[$2] = 1;
            }
        }
    | ID '=' NUM_INT {
            if (var[$1] == 1) {
                $$ = A[$1];
                A[$1] = $3;
            } else {
                printf("wrong input\n");
            }
        }
    ;

print: PRINT '(' ID ')' {
            if (var[$3] == 1) {
                printf("%d\n", A[$3]);
            } else if (var[$3] == 2) {
                printf("%g\n", B[$3]);
            } else if (var[$3] == 3) {
                printf("%c\n", C[$3]);
            } else if (var[$3] == 4) {
                for (int i = 0; i < D[$3][0]; i++) {
                    printf("%c", D[$3][i]);
                }
            } else if (var[$3] == 0) {
                printf("variable not declared before\n");
            } else {
                printf("wrong input\n");
            }
        }
    | PRINT '(' CHH ')' {
            for (int i = 0; i < $3[0]; i++) {
                printf("%c", $3[i]);
            }
        }
    ;

declr: INT ID {
            if (var[$2] == 0) {
                var[$2] = 1;
            } else if (var[$2] == 1) {
                printf("variable already declared before with the same type\n");
            } else {
                printf("variable already declared before with another type\n");
            }
        }
    | INT ID '=' exp {
            if (var[$2] == 0) {
                var[$2] = 1;
                A[$2] = $4;
            } else if (var[$2] == 1) {
                printf("variable already declared before with the same type\n");
            } else {
                printf("variable already declared before with another type\n");
            }
        }
    ;

assm: ID '=' exp {
            $$ = -1;
            if (var[$1] == 0) {
                printf("variable is not declared before\n");
            } else if (var[$1] == 1) {
                A[$1] = $3;
            } else if (var[$1] == 2) {
                B[$1] = $3;
            } else {
                printf("not accurate input with assignment\n");
            }
        }
    ;

exp: exp '+' term { $$ = $1 + $3; }
    | exp '-' term { $$ = $1 - $3; }
    | term { $$ = $1; }
    ;

term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor {
            if ($3 == 0) {
                printf("cannot divide by zero\n");
            } else {
                $$ = $1 / $3;
            }
        }
    | factor { $$ = $1; }
    ;

factor: NUM_INT { $$ = $1; }
      | NUM_FLOAT { $$ = $1; }
      | ID {
            if (var[$1] == 1) {
                $$ = A[$1];
            } else if (var[$1] == 2) {
                $$ = B[$1];
            } else {
                printf("not accurate variable\n");
            }
        }
    ;

%%

int yyerror(char* s) {
    printf("syntax error in %s", s);
}

int main() {
    yyparse();
}
