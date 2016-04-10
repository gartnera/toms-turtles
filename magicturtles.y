
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
%token  colorstring
%token  number
%token  right
%token  left
%token	turtle
%token  num
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
			printf("turtle.done();");
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
			strcat( $$.str, "\n");
		}
	| INSTINCTCOMMAND	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, "\n");
		}
	;
INSTINCTCOMMAND
	: forward number ';' 	
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, $1.str);
			strcat( $$.str, "(");
			strcat( $$.str, $2.str);
			strcat( $$.str, ")");
		}
	| left number ';' 	
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, $1.str);
			strcat( $$.str, "(");
			strcat( $$.str, $2.str);
			strcat( $$.str, ")");
		}
	| right	number ';' 	
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, $1.str);
			strcat( $$.str, "(");
			strcat( $$.str, $2.str);
			strcat( $$.str, ")");
		}
	| writeword ';'			
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, "pendown");
			strcat( $$.str, "()");
		}
	| color	colorstring ';'	
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, $1.str);
			strcat( $$.str, "(\"");
			strcat( $$.str, $2.str);
			strcat( $$.str, "\")");
		}
	| notrail ';'			
		{
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, "penup");
			strcat( $$.str, "()");
		}
	| instinct	name ';'	
		{
			//currently doesn't check if instinct exists
			strcpy( $$.str, "\t\tself.");
			strcat( $$.str, $2.str);
			strcat( $$.str, "()");
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
	: COMMANDLIST COMMAND
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, $2.str);
		}
	|	
		{
			strcpy( $$.str, "");
		}
	;
COMMAND
	: name forward number ';' 	
		{
			strcat( $$.str, ".");
			strcat( $$.str, $2.str);
			strcat( $$.str, "(");
			strcat( $$.str, $3.str);
			strcat( $$.str, ");\n");
		}
	| name left	number ';' 	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, $2.str);
			strcat( $$.str, "(");
			strcat( $$.str, $3.str);
			strcat( $$.str, ");\n");
		}
	| name right number ';' 	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, $2.str);
			strcat( $$.str, "(");
			strcat( $$.str, $3.str);
			strcat( $$.str, ");\n");
		}	
	| name writeword ';'
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, "pendown");
			strcat( $$.str, "();\n");
		}
	| name color colorstring ';'	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, $2.str);
			strcat( $$.str, "(\"");
			strcat( $$.str, $3.str);
			strcat( $$.str, "\");\n");
		}
	| name notrail	';'	
		{
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, "penup");
			strcat( $$.str, "();\n");
		}
	| name instinct	name ';'
		{
			//currently doesn't check if instinct exists
			strcpy( $$.str, $1.str);
			strcat( $$.str, ".");
			strcat( $$.str, $3.str);
			strcat( $$.str, "();\n");
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

