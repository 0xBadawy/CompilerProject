%{
	#include<stdio.h>
	int A[26];
	float B[26];
	char C[26];
	char D[26][26];
	int var[26];
	int l[26];
	int loc[26];
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
%type <in> incd
%type <in> rel
%type <in> log
%type <in> italz count

%token<in> ID
%token<ch> CH
%token<s> CHH
%token<in> NUM_INT
%token<f1> NUM_FLOAT 
%token INT FLOAT CHAR STRING PRINT FOR
%token IF THEN ELSE
%token INCREMENT DECREMENT


%nonassoc UMINS

%start s

%% 

s:  s stm
    | stm
;

stm: exp ';'
    | decl ';'
	| incd ';'
    | assm ';'
    | print ';'
    | if ';'
    | for
    | count	
;


// ------------------------------------- for loop -------------------------------------

for: FOR '('italz ';' cond ';' count')' '{' s '}'{
    int count_flag=0, cond_flag=0;
    if(l[op[1]]==1)cond_flag=1;
    if(d[2]==1){
        count_flag=1;
        if(d[0]==1)--loc[d[1]];
        else if(d[0]==2)++loc[d[1]];
    }
    if(d[2]==2){
        if(d[0]==1)--A[d[1]];
        else if(d[0]==2)++A[d[1]];
    }

	// less than and increment
    if(op[0]==1&&d[0]==1){
        if(cond_flag==1&&count_flag==1){
        int i;
        for(i=$3;loc[op[1]]<op[2];loc[d[1]]+=$7){
            
            printf("▸ Debug : loop executed %d\n", loc[d[1]]);
        }
        }
        else if(cond_flag==0 && count_flag==0){
        int i;
        for(i=$3;A[op[1]]<op[2];A[d[1]]+=$7)
            printf("▸ Debug : loop executed %d\n", A[d[1]]);
        }
        else if(cond_flag==0 && count_flag==1){
        int i;
        for(i=$3;A[op[1]]<op[2];loc[d[1]]+=$7)
            printf("▸ Debug : loop executed %d\n", loc[d[1]]);
        }
        else{
        int i;
        for(i=$3;loc[op[1]]<op[2];A[d[1]+=$7])
            printf("▸ Debug : loop executed %d\n", A[d[1]]);
        }
    }
    else if(op[0]==2 && d[0]==2){
        if(cond_flag==1&&count_flag==1){
        int i;
        for(i=$3;loc[op[1]]>op[2];loc[d[1]]-=$7)
            printf("▸ Debug : loop executed %d\n", loc[d[1]]);
        }
        else if(cond_flag==0 && count_flag==0){
        int i;
        for(i=$3;A[op[1]]>op[2];A[d[1]]-=$7)
            printf("▸ Debug : loop executed %d\n", A[d[1]]);
        }
        else if(cond_flag==0 && count_flag==1){
        int i;
        for(i=$3;A[op[1]]>op[2];loc[d[1]]-=$7)
            printf("▸ Debug : loop executed %d\n", loc[d[1]]);
        }
        else{
        int i;
        for(i=$3;loc[op[1]]>op[2];A[d[1]-=$7])
            printf("▸ Debug : loop executed %d\n", A[d[1]]);
        }
    }
}
;
// ------------------------------------- condition for loop -------------------------------------
cond: ID '<' exp {op[0]=1; op[1]=$1; op[2]=$3;}
    | ID '>' exp {op[0]=2; op[1]=$1; op[2]=$3;}
;

// ------------------------------------- counter for loop -------------------------------------
count: '+' ID '+' {
	if(l[$2]==1){
		++loc[$2];
		$$=1;
		d[0]=1;  
		d[1]=$2;
		d[2]=1;
	}
	else if(var[$2]==1){
		++A[$2];
		$$=1;
		d[0]=1;
		d[1]=$2;
		d[2]=2;	
	}
	else 
	printf("❌Error : wrong input\n");
}

|'-' ID '-' {
	if(l[$2]==1){
		--loc[$2];
		$$=1;
		d[0]=2;  
		d[1]=$2;
		d[2]=1;
	}
	else if(var[$2]==1){
		--A[$2];
		$$=1;
		d[0]=2;
		d[1]=$2;
		d[2]=2;	
	}
	else printf("❌Error : wrong input\n");
}     

|ID '+''+'{
	if(l[$1]==1){
		loc[$1]++;
		$$=1;
		d[0]=1;  
		d[1]=$1;
		d[2]=1;
	}
	else if(var[$1]==1){
		A[$1]++;
		$$=1;
		d[0]=1;
		d[1]=$1;
		d[2]=2;	
	}
	else printf("❌Error : wrong input\n");
}

|ID '-' '-'  {
	if(l[$1]==1){
		loc[$1]--;
		$$=1;
		d[0]=2;  
		d[1]=$1;
		d[2]=1;
	}
	else if(var[$1]==1){
		A[$1]--;
		$$=1;
		d[0]=2;
		d[1]=$1;
		d[2]=2;	
	}
	else printf("❌Error : wrong input\n");
}

| ID '=''+' NUM_INT{
	if(l[$1]==1){
		loc[$1]+=$4;
		$$=$4;
		d[0]=1;
		d[1]=$1;
		d[2]=1;
	}
	else if(var[$1]==1){
		A[$1]+=$4;
		$$=$4;
		d[0]=1;
		d[1]=$1;
		d[2]=2;
	}
	else printf("❌Error : variable not declared before\n");
}

| ID '=''-' NUM_INT{
	if(l[$1]==1){
		loc[$1]-=$4;
		$$=$4;
		d[0]=2;
		d[1]=$1;
		d[2]=1;
	}
	else if(var[$1]==1){
		A[$1]-=$4;
		$$=$4;
		d[0]=2;
		d[1]=$1;
		d[2]=2;
	}
	else printf("❌Error : variable not declared before\n");}
;



// ===================================== initialization =====================================
// -- intialize integer variable Ex=> int a=5; or a=5;


italz: INT ID '=' NUM_INT {
	if(l[$2]==0){
		loc[$2]=$4;
		$$=loc[$2];
		l[$2]=1;
	}
	}

| ID '=' NUM_INT {
	if(var[$1]==1){
		$$=A[$1];
		A[$1]=$3;
	}else
		printf("❌Error : wrong input\n");
}
;




// ===================================== if condition =====================================

if: IF'('log')'THEN'{'s'}'{
	if($3==1)printf("if executed"); 
	else printf("if not executed");}

| IF'('log')'THEN'{'s'}'ELSE'{'s'}' {
	if($3==1)printf("if executed");
	else printf("else executed");}
;

log:  rel'&'rel {$$=$1&&$3;}
	| rel'|'rel {$$=$1||$3;}
	| '!'rel    {$$=!$2;}
	| rel       {$$=$1;}
;


rel:  exp '>'    exp { if($1>$3) $$=1; else $$=0; }
	| exp '<'    exp { if($1<$3) $$=1; else $$=0; }
	| exp '>''=' exp { if($1>=$4) $$=1; else $$=0; }
	| exp '<''=' exp { if($1<=$4) $$=1; else $$=0; }
	| exp '=''=' exp { if($1==$4) $$=1; else $$=0; }
	| exp '!''=' exp { if($1!=$4) $$=1; else $$=0; }
;

incd: ID INCREMENT { A[$1] += 1; }
    | ID DECREMENT { A[$1] -= 1; }
    | INCREMENT ID { A[$2] += 1; }
    | DECREMENT ID { A[$2] -= 1; }
;



// ===================================== print =====================================
// -- print variable or string or character or integer or float


print: PRINT '(' ID ')'{
	if(var[$3]==1)
		printf("%d\n", A[$3]);
	else if(var[$3]==2)
		printf("%g\n", B[$3]);
	else if(var[$3]==3)
		printf("%c\n", C[$3]);
	else if(var[$3]==4){
		int x;
		for(x=1;x<D[$3][0];x++)
		printf("%c", D[$3][x]);
        printf("\n");
	}
	else if(var[$3]==0)
		printf("❌Error : variable not declared before\n");
	else
		printf("❌Error : wrong input\n");}
| PRINT '(' CHH ')' {
	int x;
	for(x=0;x<$3[0];x++)
		printf("%c", $3[x]);
    printf("\n");
    }
;





// ===================================== declaration =====================================
// -- declare variable as integer or float or character or string
// -- Ex=> int a; or float b; or char c; or string d;
// -- Ex=> int a=5; or float b=5.5; or char c='a'; or string d="hello";


decl: INT ID{
	if(var[$2]==0)
		var[$2]=1;
	else if(var[$2]==1)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}

| INT ID '=' NUM_INT{
	if(var[$2]==0){
		var[$2]=1;
		A[$2]=$4;
	}
	else if(var[$2]==1)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}        

| FLOAT ID{
	if(var[$2]==0)
		var[$2]=2;	
	else if(var[$2]==2)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}

| FLOAT ID '=' NUM_FLOAT {
	if(var[$2]==0){
		var[$2]=2;
		B[$2]=$4;
	}
	else if(var[$2]==2)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}

| CHAR ID{
	if(var[$2]==0)
		var[$2]=3;
	else if(var[$2]==3)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");} 

| CHAR ID '=' CH {
	if(var[$2]==0){
		var[$2]=3;
		C[$2]=$4;
	}
	else if(var[$2]==3)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}

| STRING ID{
	if(var[$2]==0)
		var[$2]=4;
	else if(var[$2]==4)  
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}

| STRING ID '='CHH{
	if(var[$2]==0){
		var[$2]=4;
		int i;
		for(i=0;i<$4[0];i++)
			D[$2][i]=$4[i];
	}
	else if(var[$2]==4)
		printf("❌Error : variable already declared before with the same type\n");
	else
		printf("❌Error : variable already declared before with another type\n");}
;


// ===================================== assignment =====================================
// -- assign value to variable
// -- Ex=> a=5; or b=5.5; or c='a'; or d="hello";

assm: ID '=' exp { $$=-1;
	if(var[$1]==0)
		printf("❌Error : variable is not declared before\n");
	else if(var[$1]==1)
		A[$1]=$3;
	else if(var[$1]==2)
		B[$1]=$3;
	else
		printf("❌Error : not accurate input with assignment\n");}
;


// ===================================== expression =====================================
// -- calculate expression with integer or float
// -- Ex=> a+b; or a-b; or a*b; or a/b;

exp:  exp '+' term {$$=$1+$3;}
	| exp '-' term {$$=$1-$3;}
	| term         {$$=$1;}
;


// ===================================== term =====================================
// -- calculate term with integer or float
// -- Ex=> a*b; or a/b;

term: term '*' factor {$$=$1*$3;}
    | term '/' factor {
		if($3==0)
            printf("❌Error : can not divide by zero\n");
        else
		    $$=$1/$3;
	}
    
| factor {$$=$1;}
;


// ===================================== factor =====================================
// -- calculate factor with integer or float
// -- Ex=> (a); or -a; or 5; or 5.5;

factor: '('exp')' {$$=$2;}
	| '-'factor   %prec UMINS
	| NUM_INT     {$$=$1;}
	| NUM_FLOAT   {$$=$1;}
	| ID          {
	if(var[$1]==1)
		$$=A[$1];
		else if(var[$1]==2)$$=B[$1];
		else printf("❌Error : not accurate variable\n");
	}
;

%%
int yyerror(char* s){
	printf("❌Error : syntax error in %s",s);
}
int main(){
	yyparse();
}

