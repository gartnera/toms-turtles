Target Language:

	Python 3

Every line must be terminated by a semi colon, even instinct declarations and loops.

Default turtle color is green.

Comment:
	
	@@ comment #

Basic structure:

	hatch;
	@@Instinct Declarations#
	@@Turtle Declarations, at least one turtle must be declared#
	@@Num Declarations#
	@@Command list#
	soup;
	
Instinct Deceleration:
	
	instinct NAME;
	@@Commands#
	endinstinct;

Turtle Deceleration:

	turtle NAME;

Num declaration:

	num NAME;
	
Num assignment:
	
	NAME is EXPRESSION;

Supported Math Operators:

	*/%+-^()
	
Available turtle commands:

	NAME left EXPRESSION;
	NAME right EXPRESSION;
	NAME write;
	NAME notrail;
	NAME forward;
	NAME instinct NAME;
	
(Ommit turtle name when creating instincts, otherwise name is required)

Turtles will be implicitly declared when a command is attempted on an undeclared turtle.
The same is not true for numbers. Referencing an undeclared number will cause a syntax error.

Loop structure:

	do NUMBER;
	@@some commands#
	enddo;