// Week11_Q2.c
// sum digits in a given number
#include <stdio.h>

int sum_digits(int);

int main(void)
{
	int num;

	printf("Enter a non-negative integer: ");
	scanf("%d", &num);

	printf("Sum of its digits = %d\n", sum_digits(num));

	return 0;
}

// Return sum of digits in n
// Precond: n >= 0
int sum_digits(int n)
{
	if (n < 10)
		return n;
	else 
		return n%10 + sum_digits(n/10);
}

