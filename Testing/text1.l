%option noyywrap
%{
    #include <stdio.h>
    // #include "YaccFile.tab.h"
%}

NUM      [0-9]+
FLOAT    [0-9]+\.[0-9]+
STRING   \"[^\"]*\"
CHAR     \'.\'
ID       [a-z]


%%
{STRING}   {
                yylval.s[0] = yyleng - 1;
                for (int i = 1; i < yylval.s[0]; i++) {
                    yylval.s[i] = yytext[i];
                }
                return CHH;
            }
"print"    { return PRINT; }
"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"string"   { return STRING; }

{ID}       { yylval.in = *yytext - 'a'; return ID; }
{NUM}      { yylval.in = atoi(yytext); return NUM_INT; }
{FLOAT}    { yylval.f1 = atof(yytext); return NUM_FLOAT; }

{CHAR}     { yylval.ch = yytext[1]; return CH; }
[/;=*+-]   { return *yytext; }
[()<>]     { return *yytext; }
[ \t\n]+   ;  // Ignore whitespace

%%
int yywrap() {
    return 1;
}

int main() {
    while (yylex() != 0); // Process input until EOF
    return 0;
}
