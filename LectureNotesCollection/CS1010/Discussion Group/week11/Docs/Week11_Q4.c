// Week11_Q4.c
// determine the largest pair of digits of a positive integer n
#include <stdio.h>

int largest_digit_pairs(int);

int main(void)
{
	int num;
	
	scanf("%d", &num);

	printf("%d\n", largest_digit_pairs(num) );

	return 0;
}

int largest_digit_pairs(int n)
{
	int val;
	if (n == 0)
		return 0;
	else
	{
		val = largest_digit_pairs(n/100);
		return n%100 > val ? n%100 : val;
	}
}
