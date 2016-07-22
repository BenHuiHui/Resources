// Week11_Q5.c
// reverse an integer array using recursion
#include <stdio.h>
#define NUM 5

void print_array(int [], int);
void reverse_array(int [], int);
void reverse(int [], int, int);

int main(void) 
{
	int i, size, list[NUM];

	printf("size of array? ");
	scanf("%d", &size);
	for (i=0; i<size; i++)
		scanf("%d", &list[i]);

	reverse_array(list, size);

	print_array(list, size);

	return 0;
}


// print values in array
void print_array(int arr[], int size)
{
	int i;

	for (i=0; i<size; i++)
		printf("%d ", arr[i]);
	printf("\n");
}

void reverse_array(int arr[], int size)
{
	reverse(arr, 0, size);
}

// reverse an array, {1, 2, 3} -> {3, 2, 1}
// Pre-cond: size >= 0
void reverse(int arr[], int start, int size)
{
	int swap;
	if (start >= size-1)
		return;
	else
	{
		swap = arr[size-1];
		arr[size-1] = arr[start];
		arr[start] = swap;
		reverse(arr, start+1, size-1);
	}
}
