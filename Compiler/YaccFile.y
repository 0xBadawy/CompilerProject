%{
    #include<stdio.h>
    int int_vars[26];
    float float_vars[26];
    char char_vars[26];
    char string_vars[26][26];
    int var_types[26];
    int int_locals[26];
    int local_vars[26];
    int loop_vars[3];
    int cond_ops[3];
%}

%union
{
    int int_val;
    float float_val;
    char char_val;
    char str[26];
    int id;
}

%type <float_val> statement expression term factor
%type <float_val> assignment
%type <int_val> increment_decrement relation logical initialization counter

%token <int_val> ID
%token <char_val> CHAR_LITERAL
%token <str> STRING_LITERAL
%token <int_val> NUM_INT
%token <float_val> NUM_FLOAT 
%token INT FLOAT CHAR STRING PRINT FOR
%token IF THEN ELSE

%nonassoc UMINS

%start program

%% 

program: program statement
    | statement
;

statement: expression ';'
    | assignment ';'
    | declaration ';'
    | print_stmt ';'
    | if_stmt ';'
    | counter
    | for_loop
;

for_loop: FOR '(' initialization ';' condition ';' counter ')' '{' program '}' {
    int count_flag = 0, cond_flag = 0;
    if(local_vars[cond_ops[1]] == 1) cond_flag = 1;
    if(loop_vars[2] == 1) {
        count_flag = 1;
        if(loop_vars[0] == 1) --local_vars[loop_vars[1]];
        else if(loop_vars[0] == 2) ++local_vars[loop_vars[1]];
    }
    if(loop_vars[2] == 2) {
        if(loop_vars[0] == 1) --int_vars[loop_vars[1]];
        else if(loop_vars[0] == 2) ++int_vars[loop_vars[1]];
    }

    if(cond_ops[0] == 1 && loop_vars[0] == 1) {
        if(cond_flag == 1 && count_flag == 1) {
            int i;
            for(i = $3; local_vars[cond_ops[1]] < cond_ops[2]; local_vars[loop_vars[1]] += $7)
                printf("loop executed %d\n", local_vars[loop_vars[1]]);
        } else if(cond_flag == 0 && count_flag == 0) {
            int i;
            for(i = $3; int_vars[cond_ops[1]] < cond_ops[2]; int_vars[loop_vars[1]] += $7)
                printf("loop executed %d\n", int_vars[loop_vars[1]]);
        } else if(cond_flag == 0 && count_flag == 1) {
            int i;
            for(i = $3; int_vars[cond_ops[1]] < cond_ops[2]; local_vars[loop_vars[1]] += $7)
                printf("loop executed %d\n", local_vars[loop_vars[1]]);
        } else {
            int i;
            for(i = $3; local_vars[cond_ops[1]] < cond_ops[2]; int_vars[loop_vars[1]] += $7)
                printf("loop executed %d\n", int_vars[loop_vars[1]]);
        }
    } else if(cond_ops[0] == 2 && loop_vars[0] == 2) {
        if(cond_flag == 1 && count_flag == 1) {
            int i;
            for(i = $3; local_vars[cond_ops[1]] > cond_ops[2]; local_vars[loop_vars[1]] -= $7)
                printf("loop executed %d\n", local_vars[loop_vars[1]]);
        } else if(cond_flag == 0 && count_flag == 0) {
            int i;
            for(i = $3; int_vars[cond_ops[1]] > cond_ops[2]; int_vars[loop_vars[1]] -= $7)
                printf("loop executed %d\n", int_vars[loop_vars[1]]);
        } else if(cond_flag == 0 && count_flag == 1) {
            int i;
            for(i = $3; int_vars[cond_ops[1]] > cond_ops[2]; local_vars[loop_vars[1]] -= $7)
                printf("loop executed %d\n", local_vars[loop_vars[1]]);
        } else {
            int i;
            for(i = $3; local_vars[cond_ops[1]] > cond_ops[2]; int_vars[loop_vars[1]] -= $7)
                printf("loop executed %d\n", int_vars[loop_vars[1]]);
        }
    }
}
;

condition: ID '<' expression { cond_ops[0] = 1; cond_ops[1] = $1; cond_ops[2] = $3; }
    | ID '>' expression { cond_ops[0] = 2; cond_ops[1] = $1; cond_ops[2] = $3; }
;

counter: '+' ID '+' {
    if(local_vars[$2] == 1) {
        ++local_vars[$2];
        printf("%d\n", local_vars[$2]);
        $$ = 1;
        loop_vars[0] = 1;
        loop_vars[1] = $2;
        loop_vars[2] = 1;
    } else if(var_types[$2] == 1) {
        ++int_vars[$2];
        printf("%d\n", int_vars[$2]);
        $$ = 1;
        loop_vars[0] = 1;
        loop_vars[1] = $2;
        loop_vars[2] = 2;    
    } else 
        printf("wrong input\n");
}

| '-' ID '-' {
    if(local_vars[$2] == 1) {
        --local_vars[$2];
        $$ = 1;
        printf("%d\n", local_vars[$2]);
        loop_vars[0] = 2;
        loop_vars[1] = $2;
        loop_vars[2] = 1;
    } else if(var_types[$2] == 1) {
        --int_vars[$2];
        printf("%d\n", int_vars[$2]);
        $$ = 1;
        loop_vars[0] = 2;
        loop_vars[1] = $2;
        loop_vars[2] = 2;    
    } else printf("wrong input\n");
}     

| ID '++' {
    if(local_vars[$1] == 1) {
        printf("%d\n", local_vars[$1]);
        local_vars[$1]++;
        $$ = 1;
        loop_vars[0] = 1;
        loop_vars[1] = $1;
        loop_vars[2] = 1;
    } else if(var_types[$1] == 1) {
        printf("%d\n", int_vars[$1]);
        int_vars[$1]++;
        $$ = 1;
        loop_vars[0] = 1;
        loop_vars[1] = $1;
        loop_vars[2] = 2;    
    } else printf("wrong input\n");
}

| ID '--'  {
    if(local_vars[$1] == 1) {
        printf("%d\n", local_vars[$1]);
        local_vars[$1]--;
        $$ = 1;
        loop_vars[0] = 2;
        loop_vars[1] = $1;
        loop_vars[2] = 1;
    } else if(var_types[$1] == 1) {
        printf("%d\n", int_vars[$1]);
        int_vars[$1]--;
        $$ = 1;
        loop_vars[0] = 2;
        loop_vars[1] = $1;
        loop_vars[2] = 2;    
    } else printf("wrong input\n");
}

| ID '=' '+' NUM_INT {
    if(local_vars[$1] == 1) {
        local_vars[$1] += $4;
        $$ = $4;
        loop_vars[0] = 1;
        loop_vars[1] = $1;
        loop_vars[2] = 1;
    } else if(var_types[$1] == 1) {
        int_vars[$1] += $4;
        $$ = $4;
        loop_vars[0] = 1;
        loop_vars[1] = $1;
        loop_vars[2] = 2;
    } else printf("variable not declared before\n");
}

| ID '=' '-' NUM_INT {
    if(local_vars[$1] == 1) {
        local_vars[$1] -= $4;
        $$ = $4;
        loop_vars[0] = 2;
        loop_vars[1] = $1;
        loop_vars[2] = 1;
    } else if(var_types[$1] == 1) {
        int_vars[$1] -= $4;
        $$ = $4;
        loop_vars[0] = 2;
        loop_vars[1] = $1;
        loop_vars[2] = 2;
    } else printf("variable not declared before\n");
}
;

initialization: INT ID '=' NUM_INT {
    if(local_vars[$2] == 0) {
        local_vars[$2] = $4;
        $$ = local_vars[$2];
        local_vars[$2] = 1;
    }
}

| ID '=' NUM_INT {
    if(var_types[$1] == 1) {
        $$ = int_vars[$1];
        int_vars[$1] = $3;
    } else
        printf("wrong input\n");
}
;

if_stmt: IF '(' logical ')' THEN '{' program '}' {
    if($3 == 1) printf("if executed"); 
    else printf("if not executed");
}

| IF '(' logical ')' THEN '{' program '}' ELSE '{' program '}' {
    if($3 == 1) printf("if executed");
    else printf("else executed");
}
;

logical: relation '&' relation { $$ = $1 && $3; }
    | relation '|' relation { $$ = $1 || $3; }
    | '!' relation { $$ = !$2; }
    | relation { $$ = $1; }
;

relation: expression '>' expression { if($1 > $3) $$ = 1; else $$ = 0; }
    | expression '<' expression { if($1 < $3) $$ = 1; else $$ = 0; }
    | expression ">=" expression { if($1 >= $3) $$ = 1; else $$ = 0; }
    | expression "<=" expression { if($1 <= $3) $$ = 1; else $$ = 0; }
    | expression "==" expression { if($1 == $3) $$ = 1; else $$ = 0; }
    | expression "!=" expression { if($1 != $3) $$ = 1; else $$ = 0; }
;

increment_decrement:
    ID '++' { int_vars[$1] += 1; }
    | ID '--' { int_vars[$1] -= 1; }
    | '++' ID { int_vars[$2] += 1; }
    | '--' ID { int_vars[$2] -= 1; }
;

print_stmt: PRINT '(' ID ')' {
    if(var_types[$3] == 1)
        printf("%d", int_vars[$3]);
    else if(var_types[$3] == 2)
        printf("%g", float_vars[$3]);
    else if(var_types[$3] == 3)
        printf("%c", char_vars[$3]);
    else if(var_types[$3] == 4) {
        int x;
        for(x = 1; x < string_vars[$3][0]; x++)
            printf("%c", string_vars[$3][x]);
    } else if(var_types[$3] == 0)
        printf("variable not declared before");
    else
        printf("wrong input");
}

| PRINT '(' STRING_LITERAL ')' {
    int x;
    for(x = 0; x < $3[0]; x++)
        printf("%c", $3[x]);
}
;

declaration: INT ID {
    if(var_types[$2] == 0)
        var_types[$2] = 1;
    else if(var_types[$2] == 1)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}

| INT ID '=' NUM_INT {
    if(var_types[$2] == 0) {
        var_types[$2] = 1;
        int_vars[$2] = $4;
    } else if(var_types[$2] == 1)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");        
}        

| FLOAT ID {
    if(var_types[$2] == 0)
        var_types[$2] = 2;    
    else if(var_types[$2] == 2)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}

| FLOAT ID '=' NUM_FLOAT {
    if(var_types[$2] == 0) {
        var_types[$2] = 2;
        float_vars[$2] = $4;
    } else if(var_types[$2] == 2)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}

| CHAR ID {
    if(var_types[$2] == 0)
        var_types[$2] = 3;
    else if(var_types[$2] == 3)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
} 

| CHAR ID '=' CHAR_LITERAL {
    if(var_types[$2] == 0) {
        var_types[$2] = 3;
        char_vars[$2] = $4;
    } else if(var_types[$2] == 3)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}

| STRING ID {
    if(var_types[$2] == 0)
        var_types[$2] = 4;
    else if(var_types[$2] == 4)  
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}

| STRING ID '=' STRING_LITERAL {
    if(var_types[$2] == 0) {
        var_types[$2] = 4;
        int i;
        for(i = 0; i < $4[0]; i++)
            string_vars[$2][i] = $4[i];
    } else if(var_types[$2] == 4)
        printf("variable already declared before with the same type\n");
    else
        printf("variable already declared before with another type\n");
}
;

assignment: ID '=' expression { $$ = -1;
    if(var_types[$1] == 0)
        printf("variable is not declared before\n");
    else if(var_types[$1] == 1)
        int_vars[$1] = $3;
    else if(var_types[$1] == 2)
        float_vars[$1] = $3;
    else
        printf("not accurate input with assignment\n");
}
;

expression: expression '+' term { $$ = $1 + $3; }
    | expression '-' term { $$ = $1 - $3; }
    | term { $$ = $1; }
;

term: term '*' factor { $$ = $1 * $3; }
    | term '/' factor {
        if($3 == 0)
            printf("can not divide by zero\n");
        else
            $$ = $1 / $3;
    }
    | factor { $$ = $1; }
;

factor: '(' expression ')' { $$ = $2; }
    | '-' factor %prec UMINS { $$ = -$2; }
    | NUM_INT { $$ = $1; }
    | NUM_FLOAT { $$ = $1; }
    | ID {
        if(var_types[$1] == 1)
            $$ = int_vars[$1];
        else if(var_types[$1] == 2)
            $$ = float_vars[$1];
        else
            printf("not accurate variable\n");
    }
;

%%

int yyerror(char* s) {
    printf("syntax error in %s", s);
    return 0;
}

int main() {
    yyparse();
    return 0;
}