

%{

typedef struct
{
 int ival;
 char str[100];
}tstruct ;

#define YYSTYPE  tstruct

#include "magicturtles.tab.h"

%}

DIGIT  [0-9]
LETER [a-zA-Z]
%%


[+\-*/%();]	return yytext[0]; /* Pass Math Operators and Semi Colons through */

hatch	{return HATCH;}
soup	{return SOUP;}
{LETER}{1,30}	{
					strcpy(yylval.str,yytext);
					return NAME;
				}
				
				
[ \t\n]     /* ignore whitespace */

<<EOF>>   yyterminate();  /* signal end of dialogue */

.        /* return yytext[0]; */

%%

