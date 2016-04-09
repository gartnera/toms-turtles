
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
%token  number
%token  right
%token  left
%token	turtle
%token  num
%%


PROGRAM
   : hatch ';' INSTINCTLIST DECLERATIONLIST COMMANDLIST soup ';' { 
				printf("#!/usr/bin/env python\n");
				//basic class definition
				printf("class Turtle:\n\tdef __init__(self, name):\n\t\tself.name=name;\n\t\tself.x=0;\n\t\tself.y=0;\n");
				//loads basic functions
				printf("\tdef write(self):\n\t\tprint \"write\",self.name;\n\n\tdef notrail(self):\n\t\tprint \"notrail\",self.name;\n\n\tdef forward(self,distance):\n\t\tprint \"forward\",self.name,distance;\n\n\tdef turn(self,rotation):\n\t\tprint \"turn\",self.name,rotation;\n\n");
                //add instincts
				printf("%s",$3.str);
				//dump decs
				printf("%s",$4.str);
				//dump commands
				printf("%s",$5.str);
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
												//printf("\t\tdef %s(self):\n\t%s\n\n",$2.str,$4.str);
												strcpy($$.str,"\tdef ");
												strcat($$.str,$2.str);
												strcat($$.str,"(self):\n\t\t");
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
	  forward 	number ';' 	{strcpy( $$.str, "self.");
							 strcat( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| left	 	number ';' 	{strcpy( $$.str, "self.turn");
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")");
							 }
	| right	 	number ';' 	{strcpy( $$.str, "turn");
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
	| notrail	';'			{
							 strcpy( $$.str, "self.");
							 strcat( $$.str, $1.str);
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
DECLERATIONLIST:
	TURTLEDECLERATIONLIST NUMDECLERATIONLIST {strcpy( $$.str, $1.str);strcat( $$.str, $2.str);}
;

TURTLEDECLERATIONLIST:
	TURTLEDECLERATIONLIST TURTLEDECLERATION {
		strcpy( $$.str, $1.str);
		strcat( $$.str, $2.str);
		}
	| TURTLEDECLERATION {strcpy( $$.str, $1.str);}
;
TURTLEDECLERATION:
	turtle name ';' {strcpy( $$.str, $2.str);
				 strcat( $$.str, " = Turtle('");
				 strcat( $$.str, $2.str);
				 strcat( $$.str, "')\n");
				 }
;
NUMDECLERATIONLIST:
	NUMDECLERATIONLIST NUMDECLERATION {
		strcpy( $$.str, $1.str);
		strcat( $$.str, $2.str);
		}
	| {strcpy( $$.str, "");}
;
NUMDECLERATION:
	num name ';' {strcpy( $$.str, $2.str);
				 strcat( $$.str, " = 0\n");
				 }
;

COMMANDLIST:
	COMMANDLIST COMMAND{
		strcpy( $$.str, $1.str);
		strcat( $$.str, $2.str);
		}
	|	{strcpy( $$.str, "");}
;
COMMAND:
	name	 forward 	number ';' 	{
							 strcat( $$.str, ".");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, $3.str);
							 strcat( $$.str, ");\n");
							 }
|	name	left	number ';' 	{
							 strcpy( $$.str, $1.str);
							 strcat( $$.str, ".turn(");
							 strcat( $$.str, $3.str);
							 strcat( $$.str, ");\n");
							 }
|	name	right	number ';' 	{
							 strcpy( $$.str, $1.str);
							 strcat( $$.str, ".turn(-");
							 strcat( $$.str, $3.str);
							 strcat( $$.str, ");\n");
							 }	
| 	name	writeword	';'		{
							 strcpy( $$.str, $1.str);
							 strcat( $$.str, ".");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, "();\n");
							 }
|	name	color	COLOR	';'	{
							 strcpy( $$.str, $1.str);
							 strcat( $$.str, ".");
							 strcat( $$.str, $1.str);
							 strcat( $$.str, "(");
							 strcat( $$.str, $2.str);
							 strcat( $$.str, ")l\n");
							 }
|	name	notrail	';'			{
							 strcpy( $$.str, $1.str);
							 strcat( $$.str, ".");
							 strcat( $$.str, $2.str);
						     strcat( $$.str, "();\n");
							 }
| 	name instinct	name ';'	{
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

