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
    int op[3];
%}

%union
{
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
%token INT FLOAT CHAR STRING PRINT FOR

%start s

%%

s: s stm
    | stm
    ;

stm: exp ';'
    | assm ';'
    | declr ';'
    | print ';'
    | count
    | for
    ;

for: FOR '(' italz ';' cond ';' count ')' '{' s '}'
    {
        int count_flag = 0;
        int cond_flag = 0;
        
        if (l[op[1]] == 1)
            cond_flag = 1;
        
        if (d[2] == 1)
        {
            count_flag = 1;
            if (d[0] == 1)
                --loc[d[1]];
            else if (d[0] == 2)
                ++loc[d[1]];
        }

        if (d[2] == 2)
        {
            if (d[0] == 1)
                --A[d[1]];
            else if (d[0] == 2)
                ++A[d[1]];
        }

        if (op[0] == 1 && d[0] == 1) // less than and increment
        {
            if (cond_flag == 1 && count_flag == 1)
            {
                int i;
                for (i = $3; loc[op[1]] < op[2]; loc[d[1]] += $7)
                    printf("loop executed %d\n", i);
            }
            else if (cond_flag == 0 && count_flag == 0)
            {
                int i;
                for (i = $3; A[op[1]] < op[2]; A[d[1]] += $7)
                    printf("loop executed %d\n", i);
            }
            else if (cond_flag == 0 && count_flag == 1)
            {
                int i;
                for (i = $3; A[op[1]] < op[2]; loc[d[1]] += $7)
                    printf("loop executed %d\n", i);
            }
            else
            {
                int i;
                for (i = $3; loc[op[1]] < op[2]; A[d[1]] += $7)
                    printf("loop executed %d\n", i);
            }
        }
        else if (op[0] == 2 && d[0] == 2) // greater than and decrement
        {
            if (cond_flag == 1 && count_flag == 1)
            {
                int i;
                for (i = $3; loc[op[1]] > op[2]; loc[d[1]] -= $7)
                    printf("loop executed %d\n", i);
            }
            else if (cond_flag == 0 && count_flag == 0)
            {
                int i;
                for (i = $3; A[op[1]] > op[2]; A[d[1]] -= $7)
                    printf("loop executed %d\n", i);
            }
            else if (cond_flag == 0 && count_flag == 1)
            {
                int i;
                for (i = $3; A[op[1]] > op[2]; loc[d[1]] -= $7)
                    printf("loop executed %d\n", i);
            }
            else
            {
                int i;
                for (i = $3; loc[op[1]] > op[2]; A[d[1]] -= $7)
                    printf("loop executed %d\n", i);
            }
        }
    }
;

cond: ID '<' exp { op[0] = 1; op[1] = $1; op[2] = $3; }
    | ID '>' exp { op[0] = 2; op[1] = $1; op[2] = $3; }
;

count: '+' ID '+' 
    {
        if (l[$2] == 1)
        {
            ++loc[$2];
            printf("%d\n", loc[$2]);
            $$ = 1;
            d[0] = 1; 
            d[1] = $2;
            d[2] = 1;
        }
        else if (var[$2] == 1)
        {
            ++A[$2];
            printf("%d\n", A[$2]);
            $$ = 1;
            d[0] = 1;
            d[1] = $2;
            d[2] = 2;
        }
        else
            printf("wrong input\n");
    }
| '-' ID '-'
    {
        if (l[$2] == 1)
        {
            --loc[$2];
            $$ = 1;
            printf("%d\n", loc[$2]);
            d[0] = 2; // mean store increment operation
            d[1] = $2;
            d[2] = 1;
        }
        else if (var[$2] == 1)
        {
            --A[$2];
            printf("%d\n", A[$2]);
            $$ = 1;
            d[0] = 2;
            d[1] = $2;
            d[2] = 2;
        }
        else
            printf("wrong input\n");
    }
| ID '++'
    {
        if (l[$1] == 1)
        {
            printf("%d\n", loc[$1]);
            loc[$1]++;
            $$ = 1;
            d[0] = 1; // mean store increment operation
            d[1] = $1;
            d[2] = 1;
        }
        else if (var[$1] == 1)
        {
            printf("%d\n", A[$1]);
            A[$1]++;
            $$ = 1;
            d[0] = 1;
            d[1] = $1;
            d[2] = 2;
        }
        else
            printf("wrong input\n");
    }
| ID '--'
    {
        if (l[$1] == 1)
        {
            printf("%d\n", loc[$1]);
            loc[$1]--;
            $$ = 1;
            d[0] = 2; 
            d[1] = $1;
            d[2] = 1;
        }
        else if (var[$1] == 1)
        {
            printf("%d\n", A[$1]);
            A[$1]--;
            $$ = 1;
            d[0] = 2;
            d[1] = $1;
            d[2] = 2;
        }
        else
            printf("wrong input\n");
    }
| ID '=' '+' NUM_INT
    {
        if (l[$1] == 1)
        {
            loc[$1] += $4;
            $$ = $4;
            d[0] = 1;
            d[1] = $1;
            d[2] = 1;
        }
        else if (var[$1] == 1)
        {
            A[$1] += $4;
            $$ = $4;
            d[0] = 1;
            d[1] = $1;
            d[2] = 2;
        }
        else
            printf("variable not declared before\n");
    }
| ID '=' '-' NUM_INT
    {
        if (l[$1] == 1)
        {
            loc[$1] -= $4;
            $$ = $4;
            d[0] = 2;
            d[1] = $1;
            d[2] = 1;
        }
        else if (var[$1] == 1)
        {
            A[$1] -= $4;
            $$ = $4;
            d[0] = 2;
            d[1] = $1;
            d[2] = 2;
        }
        else
            printf("variable not declared before\n");
    }
;

italz: INT ID '=' NUM_INT
    {
        if (l[$2] == 0)
        {
            loc[$2] = $4;
            $$ = loc[$2];
            l[$2] = 1;
        }
    }
| ID '=' NUM_INT
    {
        if (var[$1] == 1)
        {
            $$ = A[$1];
            A[$1] = $3;
        }
        else
            printf("wrong input\n");
    }
;

print: PRINT '(' ID ')'
    {
        if (var[$3] == 1) // print(a) string a="hello" D[0][hello]  
            printf("%d\n", A[$3]);
        else if (var[$3] == 2)
            printf("%g\n", B[$3]);
        else if (var[$3] == 3)
            printf("%c\n", C[$3]);
        else if (var[$3] == 4)
        {
            int i;
            for (i = 0; i < D[$3][0]; i++)
                printf("%c", D[$3][i]);
        }
        else if (var[$3] == 0)
            printf("variable not declared before\n");
        else
            printf("wrong input\n");
    }
| PRINT '(' CHH ')'
    {
        int i;
        for (i = 0; i < $3[0]; i++)
            printf("%c", $3[i]);
    }
;

declr: INT ID
    {
        if (var[$2] == 0)
            var[$2] = 1;
        else if (var[$2] == 1)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| INT ID '=' exp
    {
        if (var[$2] == 0)
        {
            var[$2] = 1;
            A[$2] = $4;
        }
        else if (var[$2] == 1)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| FLOAT ID
    {
        if (var[$2] == 0)
        {
            var[$2] = 2;
        }
        else if (var[$2] == 2)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| FLOAT ID '=' exp
    {
        if (var[$2] == 0)
        {
            var[$2] = 2;
            B[$2] = $4;
        }
        else if (var[$2] == 2)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| CHAR ID
    {
        if (var[$2] == 0)
            var[$2] = 3;
        else if (var[$2] == 3)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| CHAR ID '=' CH
    {
        if (var[$2] == 0)
        {
            var[$2] = 3;
            C[$2] = $4;
        }
        else if (var[$2] == 3)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| STRING ID
    {
        if (var[$2] == 0)
            var[$2] = 4;
        else if (var[$2] == 4)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
| STRING ID '=' CHH
    {
        if (var[$2] == 0)
        {
            var[$2] = 4;
            strcpy(D[$2], $4);
        }
        else if (var[$2] == 4)
            printf("variable already declared before with the same type\n");
        else
            printf("variable already declared before with another type\n");
    }
;

%%

int main()
{
    yyparse();
    return 0;
}

int yyerror(char *s)
{
    printf("error: %s\n", s);
    return 0;
}
