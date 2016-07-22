// Week9_Q9.c
// read a string, use * to separate each char
//
// Written by: Lifeng

#include <stdio.h>
#include <ctype.h>
#include <string.h>

void convert_string(char *, char *);

int main(void)
{
	int len;
	char src[100], dest[200];

	fgets(src, 100, stdin);
	len = strlen(src);
	if ( src[len-1] == '\n' )
		src[len-1] = '\0';

	convert_string(src, dest);

	printf("%s\n", dest);

	return 0;
}

void convert_string(char *src, char *dest)
{
	int i = 0, j = 0;
	while (src[i])
	{
		if ( isalpha(src[i]) )
		{
			dest[j] = src[i];
			dest[j+1] = '*';
			j += 2;
		}
		i++;
	}
	dest[j-1] = 0;  // make it a string!!
}
