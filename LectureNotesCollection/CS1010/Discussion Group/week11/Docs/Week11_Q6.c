// Week11_Q6.c
// count north-east paths

#include <stdio.h>

/* function prototype */
int count_path(int, int);

int main(void)
{
	int x, y;

	printf("Enter x and y: ");
	scanf("%d %d", &x, &y);

	printf("There are %d unique paths\n", count_path(x, y));

	return 0;
}

int count_path(int x, int y)
{
	if (x > 0 && y > 0)
		return count_path(x-1, y) + count_path(x, y-1);
	else if (x == 0)
		return 1;
	else // y == 0
		return 1;
}
