%option noyywrap

%{
    #include<stdio.h>
    #include"YaccFile.tab.h"
%}

%%

"print"  { return PRINT; }
"int"    { return INT; }
"float"  { return FLOAT; }
"char"   { return CHAR; }
"string" { return STRING; }
"if"     { return IF; }
"then"   { return THEN; }
"else"   { return ELSE; }
"for"    { return FOR; }

\".+\"   { yylval.str[0] = yyleng - 1;
           int i;
           for(i = 1; i < yylval.str[0]; i++)
               yylval.str[i] = yytext[i];
           return STRING_LITERAL; }

[a-z]             { yylval.id = *yytext - 'a'; return ID; }
[0-9]+            { yylval.int_val = atoi(yytext); return NUM_INT; }
[0-9]+\.[0-9]+    { yylval.float_val = atof(yytext); return NUM_FLOAT; }
\'.\'             { yylval.char_val = yytext[1]; return CHAR_LITERAL; }
[/;=*+{}&|!<>-]   { return *yytext; }
[()]              { return *yytext; }
[ \t\n]           ;

%%