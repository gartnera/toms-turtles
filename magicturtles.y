
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "helpers.h"

#include "helpers.h"


typedef struct 
{
 int ival;
 char str[2048];
}tstruct ; 

#define YYSTYPE  tstruct 

%}
%error-verbose


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
%token  is
%%


PROGRAM
   : hatch ';' INSTINCTLIST DECLERATIONLIST COMMANDLIST soup ';' 
	   { 
			printf("#!/usr/bin/env python\n");
			printf("import turtle\n\n");
			printf("class MyTurtle(turtle.Turtle):\n");
			printf("\tdef __init__(self):\n\t\tsuper().__init__()\n\t\tself.color(\"green\")\n");
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
			if(inlink($2.str)){
				yyerror("Attempted previously used name in instinct declaration");
			}
			else
			{
				addlink($2.str,2);
				indent($4.str);
				sprintf($$.str, "def %s(self):\n%s", $2.str, $4.str);
				indent($$.str);
			}
		}
	;

INSTINCTCOMMANDLIST
	: INSTINCTCOMMANDLIST startdo EXPRESSION ';' INSTINCTCOMMANDLIST enddo ';'
		{
			indent($5.str);
			sprintf($$.str, "%sfor i in range (0,%s):\n%s", $1.str,$3.str,$5.str);
		}
	| INSTINCTCOMMANDLIST INSTINCTCOMMAND 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	|
		{
			strcpy( $$.str, "");
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
			if(inlink($2.str))
			{
				yyerror("Error Attempted Redeclaration");
			}
			else
			{
				strcpy( $$.str, $2.str);
				strcat( $$.str, " = MyTurtle()\n");
				addlink($2.str,0);
			}
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
			if(inlink($2.str))
			{
				yyerror("Error Attempted Redeclaration");
			}
			else
			{
				strcpy( $$.str, $2.str);
				strcat( $$.str, " = 0\n");
				addlink($2.str,1);
			}
		}
;

COMMANDLIST
	: COMMANDLIST startdo EXPRESSION ';' COMMANDLIST enddo ';'
		{
			indent($5.str);
			sprintf($$.str, "%sfor i in range (0,%s):\n%s", $1.str,$3.str,$5.str);
		}
	| COMMANDLIST NAMEDCOMMAND 
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
    | COMMANDLIST VARIABLEOPERATION
        {
            sprintf($$.str, "%s%s", $1.str, $2.str);
        }
	|
		{
			strcpy( $$.str, "");
		}
	;


VARIABLEOPERATION
    : name is EXPRESSION ';'
        {
			if(inlink($1.str)){
				if(gettype($1.str)==1){
					sprintf($$.str, "%s = %s\n", $1.str, $3.str);
				}
				else
				{
					yyerror("incompatible types");
				}
			}
			else
			{
				yyerror("Num was not declared");
			}
        }
    ;

NAMEDCOMMAND
	: name COMMAND
		{
			if(inlink($1.str)){
				if(gettype($1.str)==0){
					sprintf($$.str, "%s.%s", $1.str, $2.str);
				}
				else
				{
					yyerror("Turtle command attempted on non turtle");
				}
			}
			else{
				//implicit declaration of turtles
				addlink($1.str,0);
				sprintf($$.str, "%s = MyTurtle()\n%s.%s",$1.str, $1.str, $2.str);
			}
		}
	;

INSTINCTCOMMAND
	: COMMAND
		{
			sprintf($$.str, "self.%s", $1.str);
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
			if(inlink($2.str) && (gettype($2.str)==2)){
				sprintf($$.str, "%s()\n", $2.str);
			}
			else
			{
				yyerror("Instinct Undeclared");
			}
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
			if(inlink($1.str)){
				if(gettype($1.str)==1){
					sprintf($$.str, "%s", $1.str);
				}
				else
				{
					yyerror("Used non number used in expression");
				}
			}
			else
			{
				yyerror("Used name is undeclared");
			}
        }
    | '(' EXPRESSION ')'
        {
            sprintf($$.str, "(%s)", $2.str);
        }
    ;

%%



int main ()
{
  yyparse ();
}

int yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("\terror: %s\n", s);
  exit(0);
}
