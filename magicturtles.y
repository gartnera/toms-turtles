
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct 
{
 int ival;
 char str[1000];
}tstruct ; 

#define YYSTYPE  tstruct 

%}


%token	name
%token  hatch
%token  soup
%token  temp
%token	instinct
%token	endinstinct
%token	forward
%token  writeword
%token  notrail
%token  color
%token  num
%%


PROGRAM
   : hatch ';' INSTINCTLIST soup ';' { 
                }
   ;

INSTINCTLIST
	: INSTINCT INSTINCTLIST{
							strcpy( $$.str, $1.str);
							strcat( $$.str, $2.str);
							}
	|
	;

INSTINCT:
	instinct name ';' INSTINCTCOMMANDLIST endinstinct ';'	{
												printf("def %s(REPLACEWITHTURTLENAME):\n\t%s\n\n",$2.str,$4.str);
											}
	;

INSTINCTCOMMANDLIST:
	INSTINCTCOMMANDLIST INSTINCTCOMMAND	{
		strcpy( $$.str, $1.str);
		strcat( $$.str, $2.str);
		strcat( $$.str, ";");
		}
	| INSTINCTCOMMAND	{strcpy( $$.str, $1.str);strcat( $$.str, ";");}
	;
INSTINCTCOMMAND:
	  forward 	num ';' 	{strcpy( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, "REPLACEWITHTURTLENAME");
							 strcat( $$.str, ",");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| writeword ';'			{strcpy( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, "REPLACEWITHTURTLENAME");
							 strcat( $$.str, ")");
							 }
	| color		COLOR ';'	{strcpy( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, "REPLACEWITHTURTLENAME");
							 strcat( $$.str, ",");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| notrail	';'			{strcpy( $$.str, $1.str);
						     strcat( $$.str, "(");
							 strcat( $$.str, "REPLACEWITHTURTLENAME");
							 strcat( $$.str, ")");}
	| instinct	name ';'	{
							 //currently doesn't check if instinct exists
							 strcpy( $$.str, $2.str);
						     strcat( $$.str, "(");
							 strcat( $$.str, "REPLACEWITHTURTLENAME");
							 strcat( $$.str, ")");
							 }
	;

COLOR:
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

