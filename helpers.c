#include <stdio.h>
#include <string.h>

void shiftRight(char* c)
{
	int len;
	char* end;

	//+1 to include null terminator in shift
	len = strlen(c) + 1;

	for (end = c + len; end != c; --end)
	{
		*end = *(end - 1);
	}

}

void indent(char* c)
{
	shiftRight(c);
	c[0] = '\t';
	++c;

	while (c = strchr(c, '\t'))
	{
		shiftRight(c);
		c[0] = '\t';
		c += 2;
	}
}
void addsingletab(char * c)
{
	shiftRight(c);
	c[0]='\t';
}
void replace(char * c)
{
	int len;
	char *end;
	//start at end of string and read for new lines
	len = strlen(c);
	//skip first new line and terminating character
	for (end = c + len-1; end != c; end--)
	{
		//if next character is newline add a tab here
		if(*(end-1) == 10){
			addsingletab(end);
		}
	}
	//always add tab to the beginning
	addsingletab(c);
}