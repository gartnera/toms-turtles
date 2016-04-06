
go: lex.yy.c magicturtles.tab.c 
	gcc magicturtles.tab.c lex.yy.c -lfl -ly -o go 

lex.yy.c: magicturtles.l
	flex -i magicturtles.l

magicturtles.tab.c: magicturtles.y
	bison -dv magicturtles.y

clean:
	rm -f lex.yy.c 
	rm -f magicturtles.output
	rm -f magicturtles.tab.h
	rm -f magicturtles.tab.c
	rm -f go 

