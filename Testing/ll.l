%option noyywrap
%{
	#include<stdio.h>
	#include"y.tab.h"

%}

%%
"string"	{return STRING;}
"int"		{return INT;}
"float"		{return FLOAT;}
"char"		{return CHAR;}
"print"		{return PRINT;}
"if"		{return IF;}
"then"		{return THEN;}
"else"		{return ELSE;}

[a-zA-Z]	{yylval.ascii = *yytext - 'a'; return ID;}
[0-9]+		{yylval.in = atoi(yytext); return NUM_INT;}
[0-9]+\.[0-9]+	{yylval.fl = atof(yytext); return NUM_FLOAT;}

[-+*;/={}]	{return *yytext;}
[><!()&|]	{return *yytext;}
'\n'	 ;

\'.\'		{yylval.ch = yytext[1]; return CH;}
\".+\"		{yylval.str[0] = yyleng - 1;
			int i;
			for(i=1;i<yylval.str[0];i++)
				yylval.str[i] = yytext[i];
			return STR;
		}
"--"		{return DECREMENT;}
%%