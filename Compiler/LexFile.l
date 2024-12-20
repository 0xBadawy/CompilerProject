%option noyywrap
%{
	#include<stdio.h>
	#include"YaccFile.tab.h"
%}

%%

\".+\"     {yylval.s[0]=yyleng-1;
              int i;
             for(i=1;i<yylval.s[0];i++)
	       yylval.s[i]=yytext[i];
	       return CHH;}
"print"  {return PRINT;}
"int"   {return INT;}
"float" {return FLOAT;}
"char"  {return CHAR;}
"string" {return STRING;}
"if"   {return IF;}
"then" {return THEN;}
"else" {return ELSE;}
"for"  {return FOR;}

[a-z]     {yylval.in=*yytext-'a'; return ID;}
[0-9]+    {yylval.in=atoi(yytext); return NUM_INT;}
[0-9]+\.[0-9]+    {yylval.f1=atof(yytext); return NUM_FLOAT;}

\'.\'      {yylval.ch=yytext[1]; return CH;}
[/;=*+{}&|!<>-]   {return *yytext;}
[()]   {return *yytext;}
[ \t\n]    ;



%%