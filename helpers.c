#include <stdio.h>
#include <string.h>
#include <stdlib.h>

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

void indentBlock(char* c)
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
void indent(char * c)
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

typedef struct link
{
 char str[2048];
 int type;
 struct link * next;
}link;

link * chain = NULL;

void addlink(char * c,int t)
{
	//setup transversal
	link * current = NULL;
	
	//create a new node
	link * nn = malloc(sizeof(link));
	strcpy(nn->str,c);
	nn->type = t;
	nn->next = NULL;
	
	//if first node 
	if(chain==NULL){chain=nn;}else{
		//else transverse and add
		current=chain;
		while(current->next!=NULL){
			current=current->next;
		}
		//add nn to end;
		current->next=nn;
	}
}
int inlink(char * c){
	link * current = chain;
	while(current!=NULL){
		if(strcmp(c,current->str)==0)
			{return 1;}
		else
			{current=current->next;}
	}
	return 0;
}
int gettype(char * c){
	link * current = chain;
	while(current!=NULL){
		if(strcmp(c,current->str)==0)
			{return current->type;}
		else
			{current=current->next;}
	}
	return -1;
}