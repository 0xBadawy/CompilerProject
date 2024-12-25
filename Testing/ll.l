%{
	#include <stdio.h>
	#include "ll.tab.h"
	
%}

%%

"print"	{return PRINT;}
"int"	{return INT;}

[0-9]+ {yylval.in=atoi(yytext),return NUM_INT;}

%%