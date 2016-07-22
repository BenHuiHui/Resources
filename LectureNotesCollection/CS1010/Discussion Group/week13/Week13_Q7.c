// Week13_Q7.c
// read some data from a file,
// number of data contained is unknown beforehand,
// therefore need to detect the end-of-file during reading.
// write all data read to another file after that.
//
// Written by: Lifeng

#include <stdio.h>
#include <stdlib.h>

#define NUM 80

void selection_sort(int arr[], int size);

int main(void)
{
	int i, n;
	int arr[NUM];  // array to hold maximum 80 values
	char infile[NUM], outfile[NUM];  // input, output file
	FILE *ifp, *ofp;  // input, output pointer

	printf("Enter input filename : ");
	scanf("%s", infile);
	printf("Enter output filename : ");
	scanf("%s", outfile);

	if ( (ifp = fopen(infile, "r")) == NULL )
	{
		printf("Cannot open file %s\n", infile);
		exit(1);
	}
	if ( (ofp = fopen(outfile, "w")) == NULL )
	{
		printf("Cannot open file %s\n", outfile);
		fclose(ifp);
		exit(1);
	}

	// read data from input file
	n=0;
	while ( fscanf(ifp, "%d", &i) == 1 )
	{
		arr[n++] = i;
	}

	// while (fscanf(ifp, "%d", &arr[n++]) == 1); -- wrong

	// sort data
	selection_sort(arr, n);

	// write data to output file
	for (i=0; i<n; i++)
		fprintf(ofp, "%d\n", arr[i]);

	fclose(ifp);
	fclose(ofp);

	return 0;
}

void selection_sort(int arr[], int size)
{
	int i, start_index, min_index, temp;

	for (start_index=0; start_index<size-1; start_index++)
	{
		min_index = start_index;
		for (i=start_index+1; i<size; i++)
			if (arr[i] < arr[min_index])
				min_index = i;

		temp = arr[start_index];
		arr[start_index] = arr[min_index];
		arr[min_index] = temp;
	}
}
