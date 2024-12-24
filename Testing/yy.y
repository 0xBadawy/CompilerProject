%{
	#include<stdio.h>
	int var[26];
	int var_int[26];
	float var_flt[26];
	char var_chr[26];
	char var_str[26][26];
%}
%union
{
	int in;
	int ascii;
	float fl;
	char ch;
	char str[26];
}
%start s

%token INT FLOAT CHAR STRING PRINT IF THEN ELSE DECREMENT
%token <in> NUM_INT
%token <fl> NUM_FLOAT
%token <in> ID
%token <ch> CH
%token <str> STR
%type <fl> exp term factor
%type <in> rel log

%nonassoc UMINUS

%% 
s: s stm
 | stm
 ;

stm: exp ';'
   | decl ';'
   | assm ';'
   | if
   | log ';'
   | rel ';'
   | incd ';'
   | print ';'
   ;

decl: INT ID	{
		if(var[$2]==0)
			var[$2]=1;
		else if (var[$2]==1)
			printf("var declared as int\n");
		else
			printf("var declares with another type\n");
			}
    | INT ID '=' exp	{
		if(var[$2]==0){
			var[$2]=1;
			var_int[$2]=$4;
			}
		else if (var[$2]==1)
			printf("var declared as int\n");
		else
			printf("var declares with another type\n");
			}
    | FLOAT ID	{
		if(var[$2]==0)
			var[$2]=2;
		else if (var[$2]==2)
			printf("var declared as float\n");
		else
			printf("var declares with another type\n");
			}
    | FLOAT ID '=' exp	{
		if(var[$2]==0){
			var[$2]=2;
			var_flt[$2]=$4;
			}
		else if (var[$2]==2)
			printf("var declared as float\n");
		else
			printf("var declares with another type\n");
			}
    | CHAR ID	{
		if(var[$2]==0)
			var[$2]=3;
		else if (var[$2]==3)
			printf("var declared as char\n");
		else
			printf("var declares with another type\n");
			}
    | CHAR ID '=' CH	{
		if(var[$2]==0){
			var[$2]=3;
			var_chr[$2]=$4;
			}
		else if (var[$2]==3)
			printf("var declared as char\n");
		else
			printf("var declares with another type\n");
			}
    | STRING ID	{
		if(var[$2]==0)
			var[$2]=4;
		else if (var[$2]==4)
			printf("var declared as string\n");
		else
			printf("var declares with another type\n");
			}
    | STRING ID '=' STR	{
		if(var[$2]==0){
			var[$2]=4;
			int i;
			for(i=0;i<$4[0];i++)
				var_str[$2][i] = $4[i];
			}
		else if (var[$2]==4)
			printf("var declared as string\n");
		else
			printf("var declares with another type\n");
			};

exp: exp '+' term	{$$=$1+$3;}
   | exp '-' term	{$$=$1-$3;}
   | term		{$$=$1;}
   ;

term: term '*' factor	{$$=$1*$3;}
    | term '/' factor	{if($3==0)
				printf("Can not divide by zero\n");
			else
				$$=$1/$3;}
    | factor	{$$=$1;}
    ;

factor: NUM_INT		{$$=$1;}
      | NUM_FLOAT	{$$=$1;}
      | '('exp')'	{$$=$2;}
      | '-' factor %prec UMINUS {$$=-$2;}
      | ID		{if(var[$1]==0)
				printf("Not declared before\n");
			else if(var[$1]==1)
				$$=var_int[$1];
			else if(var[$1]==2)
				$$=var_flt[$1];
			else
				printf("Wrong data type\n");};

assm: ID '=' exp	{if(var[$1]==0)
				printf("Not declared before\n");
			else if(var[$1]==1)
				var_int[$1]=$3;
			else if(var[$1]==2)
				var_flt[$1]=$3;
			else
				printf("Wrong data type\n");};

if: IF '(' log ')' THEN '{' s '}' {if($3==1)
                                printf("Executed if\n");
				else
				printf("Not executed if\n");}
  | IF '('log')' THEN '{'s'}' ELSE '{'s'}' {if($3==1)
                                           printf("Executed if\n");
				           else
				            printf(" Executed else\n");};

log:rel '&''&' rel      {$$=$1&&$4;}
   | rel '|''|' rel     {$$=$1||$4;}
   |'!' rel          {$$=!$2;}
   |rel              {$$=$1;} 
   ;

rel: exp '>' exp        {if($1>$3)
                           $$=1;
			 else
			   $$=0;}
      |exp '<' exp        {if($1<$3)
                            $$=1;
			   else
			     $$=0;}
      |exp '>''=' exp      {if($1>=$4)
                              $$=1;
			    else
			      $$=0;}
      |exp '<''=' exp       {if($1<=$4)
                               $$=1;
			     else
			       $$=0;}   
      |exp '=''=' exp     {if($1==$4)
                            $$=1;
			   else
			     $$=0;}
      |exp '!''=' exp     {if($1!=$4)
                              $$=1;
			   else
			      $$=0;};

incd: ID '+''+'   {if(var[$1]==0)
			printf("Variable is not declared\n");
		else if(var[$1]==1){
			printf("%d\n",var_int[$1]);
			var_int[$1]=var_int[$1]+1;}
		else	printf("Wrong data type\n");
		}

      |ID '-''-'   {if(var[$1]==0)
			printf("Variable is not declared\n");
		else if(var[$1]==1){
			printf("%d\n",var_int[$1]);
			var_int[$1]=var_int[$1]-1;}
		else	printf("Wrong data type\n"); }

      |'+''+' ID   {if(var[$3]==0)
			printf("Variable is not declared\n");
		else if(var[$3]==1){
			var_int[$3]=var_int[$3]+1;
			printf("%d\n",var_int[$3]);
			}
		else	printf("Wrong data type\n");}

      |DECREMENT ID     {if(var[$2]==0)
			printf("Variable is not declared\n");
		else if(var[$2]==1){
			var_int[$2]=var_int[$2]-1;
			printf("%d\n",var_int[$2]);
			}
		else	printf("Wrong data type\n");};

print: PRINT '(' ID ')'		{if(var[$3]==0)
					printf("Varaible is not declared\n");
				 else if(var[$3]==1)
					printf("%d\n",var_int[$3]);
				 else if(var[$3]==2)
					printf("%f\n",var_flt[$3]);
				 else if(var[$3]==3)
					printf("%c\n",var_chr[$3]);
				 else if(var[$3]==4){
					int i;
					for(i=0;i<var_str[$3][0];i++)
						printf("%c",var_str[$3][i]);
					printf("\n");}
				 else	printf("Invalid Input\n");
					}
     | PRINT '(' STR ')'	{	int i;
					for(i=0;i<$3[0];i++)
						printf("%c",$3[i]);
					printf("\n");};
%%
int yyerror(char *s)
{
	printf("syntax error in %s",s);
}
int main()
{
	yyparse();
}