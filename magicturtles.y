
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct 
{
 int ival;
 char str[500];
}tstruct ; 

#define YYSTYPE  tstruct 

%}


%token	NAME
%token  HATCH
%token  SOUP
%%


program
   : HATCH SOUP { 
                  printf("The Lord giveth turtles and the Lord Taketh turtles away\n");
                }
   ;

%%



main ()
{
  yyparse ();
}

yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
}

