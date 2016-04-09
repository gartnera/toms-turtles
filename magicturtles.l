

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

@@.*#	{}

hatch	{return hatch;}
soup	{return soup;}
instinct {return instinct;}
endinstinct {return endinstinct;}
forward		{strcpy( yylval.str, yytext);return forward;}
write		{strcpy( yylval.str, yytext);return writeword;}
color		{return color;}
notrail		{strcpy( yylval.str, yytext);return notrail;}
{LETER}{1,30}	{
					strcpy(yylval.str,yytext);
					return name;
				}
{DIGIT}+			{	
					strcpy(yylval.str,yytext);
					return num;
				}
				


<<EOF>>   yyterminate();  /* signal end of dialogue */

[ \t\n]     /* ignore whitespace */
;	return yytext[0];
[+\-*/%()]	return yytext[0]; /* Pass Math Operators and Semi Colons through */
.        /* return yytext[0]; */

%%

