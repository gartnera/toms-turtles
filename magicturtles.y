
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "helpers.h"


typedef struct 
{
 int ival;
 char str[2048];
}tstruct ; 

#define YYSTYPE  tstruct 

int lp=1;
int lpcurr;
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
%token  colorstring
%token  number
%token  right
%token  left
%token	turtle
%token  num
%token	startdo
%token	enddo
%token  math
%%


PROGRAM
   : hatch ';' INSTINCTLIST DECLERATIONLIST COMMANDLIST soup ';' 
	   { 
			printf("#!/usr/bin/env python\n");
			printf("import turtle\n\n");
			printf("class MyTurtle(turtle.Turtle):\n");

			//add instincts
			printf("%s",$3.str);
			//dump decs
			printf("%s",$4.str);
			//dump commands
			printf("%s",$5.str);
			//closing turtle command
			printf("turtle.done()\n");
	   }
   ;

INSTINCTLIST
	: INSTINCTLIST INSTINCT
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	|	
		{
			strcpy($$.str,"");
		}
	;

INSTINCT
	: instinct name ';' INSTINCTCOMMANDLIST endinstinct ';'	
		{
			strcpy($$.str, "\tdef ");
			strcat($$.str,$2.str);
			strcat($$.str,"(self):\n");
			strcat($$.str,$4.str);
			strcat($$.str,"\n");
		}
	;

INSTINCTCOMMANDLIST
	: INSTINCTCOMMANDLIST INSTINCTCOMMAND	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	| INSTINCTCOMMAND	
		{
			strcpy( $$.str, $1.str);
		}
	;
	
DECLERATIONLIST
	: TURTLEDECLERATIONLIST NUMDECLERATIONLIST 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	;

TURTLEDECLERATIONLIST
	: TURTLEDECLERATIONLIST TURTLEDECLERATION 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	| TURTLEDECLERATION 
		{
			strcpy( $$.str, $1.str);
		}
	;
TURTLEDECLERATION
	: turtle name ';' 
		{
			strcpy( $$.str, $2.str);
			strcat( $$.str, " = MyTurtle()\n");
			/*
			strcat( $$.str, " = MyTurtle('");
			strcat( $$.str, $2.str);
			strcat( $$.str, "')\n");
			*/
		}
	;
NUMDECLERATIONLIST
	: NUMDECLERATIONLIST NUMDECLERATION 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	| 
		{
			strcpy( $$.str, "");
		}
	;
NUMDECLERATION
	: num name ';' 
		{
			strcpy( $$.str, $2.str);
			strcat( $$.str, " = 0\n");
		}
;

COMMANDLIST
	: COMMANDLIST NAMEDCOMMAND 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	|	
		{
			strcpy( $$.str, "");
		}
	;

NAMEDCOMMAND
	: name COMMAND
		{
			sprintf($$.str, "%s.%s", $1.str, $2.str);
		}
	| startdo EXPRESSION ';' COMMANDLIST enddo ';'
		{
			lpcurr=lp++;
			replace($4.str);
			sprintf($$.str, "for tmp%d in range (0,%s):\n%s", lpcurr, $2.str,$4.str);
		}
	;
INSTINCTCOMMAND
	: COMMAND
		{
			sprintf($$.str, "\t\tself.%s", $1.str);
		}
	;

COMMAND
	: forward EXPRESSION ';' 	
		{
			sprintf($$.str, "%s(%s)\n", $1.str, $2.str);
		}
	| left	EXPRESSION ';' 	
		{
			sprintf($$.str, "%s(%s)\n", $1.str, $2.str);
		}
	| right EXPRESSION ';' 	
		{
			sprintf($$.str, "%s(%s)\n", $1.str, $2.str);
		}	
	| writeword ';'
		{
			strcpy( $$.str, "pendown()\n");
		}
	| color colorstring ';'	
		{
			sprintf($$.str, "%s(\"%s\")\n", $1.str, $2.str);
		}
	| notrail	';'	
		{
			strcpy($$.str, "penup()\n");
		}
	|  instinct	name ';'
		{
			//currently doesn't check if instinct exists
			sprintf($$.str, "%s()\n", $2.str);
		} 
	;

EXPRESSION
    : EXPRESSION math FACTOR
        {
            sprintf($$.str, "%s %s %s", $1.str, $2.str, $3.str);
        }
    | FACTOR
        {
            sprintf($$.str, "%s", $1.str);
        }
    ;

FACTOR
    : number
        {
            sprintf($$.str, "%s", $1.str);
        }
    | name
        {
            sprintf($$.str, "%s", $1.str);
        }
    | '(' EXPRESSION ')'
        {
            sprintf($$.str, "(%s)", $2.str);
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
