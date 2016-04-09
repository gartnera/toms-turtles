
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct 
{
 int ival;
 char str[2048];
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
%token  right
%token  left
%%


PROGRAM
   : hatch ';' INSTINCTLIST soup ';' { 
				printf("#!/usr/bin/env python\n");
				printf("class Turtle:\n\tdef __init__(self, name):\n\t\tself.name=name;\n\t\tself.x=0;\n\t\tself.y=0;\n");
				printf("%s",$3.str);
                }
   ;

INSTINCTLIST
	: INSTINCT INSTINCTLIST{
							strcpy( $$.str, $1.str);
							strcat( $$.str, $2.str);
							}
	|	{strcpy($$.str,"");}
	;

INSTINCT:
	instinct name ';' INSTINCTCOMMANDLIST endinstinct ';'	{
												//printf("\t\tdef %s():\n\t%s\n\n",$2.str,$4.str);
												strcpy($$.str,"\tdef ");
												strcat($$.str,$2.str);
												strcat($$.str,"():\n\t\t");
												strcat($$.str,$4.str);
												strcat($$.str,"\n\n");
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
	  forward 	num ';' 	{strcpy( $$.str, "self.");
							 strcat( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| left	 	num ';' 	{strcpy( $$.str, "self.turn");
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| right	 	num ';' 	{strcpy( $$.str, "turn");
							 strcat( $$.str, "(-");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| writeword ';'			{strcpy( $$.str, "self.");
							 strcat( $$.str, $1.str);
							 strcat( $$.str, "()");
							 }
	| color		COLOR ';'	{
							 strcpy( $$.str, "self.");
							 strcat( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| notrail	';'			{strcpy( $$.str, $1.str);
						     strcat( $$.str, "(");
							 strcat( $$.str, ")");
							 }
	| instinct	name ';'	{
							 //currently doesn't check if instinct exists
							 strcpy( $$.str, "self.");
							 strcat( $$.str, $2.str);
						     strcat( $$.str, "(");
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

