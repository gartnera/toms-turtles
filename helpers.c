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

