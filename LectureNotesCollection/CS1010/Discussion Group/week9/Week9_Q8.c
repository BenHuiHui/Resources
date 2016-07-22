// Week9_Q8.c
// check string length by myself
#include <stdio.h>
#include <string.h>

// function prototypes
int mystrlen(char []);
int mystrlen2(char []);

int main(void)
{
	int len;
	char str[100];  // suppose at most 99 input chars

	fgets(str, 100, stdin);
	len = strlen(str);
	if ( str[len-1] == '\n' )
		str[len-1] = '\0';

	printf("length: %d\n", mystrlen(str));
	printf("length: %d\n", mystrlen2(str));

	return 0;
}

// iterative version check string length
int mystrlen(char str[])
{
	int count = 0;
	while (str[count] != '\0')
		count++;
	return count;
}

// recursive version to check string length
int mystrlen2(char str[])
{
	if (str[0] == '\0')
		return 0;
	else
		return 1 + mystrlen(str+1);
}
