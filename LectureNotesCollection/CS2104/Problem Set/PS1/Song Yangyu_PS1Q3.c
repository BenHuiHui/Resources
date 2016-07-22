#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// global variables
int eax, ebx, ecx, edx, esi, edi;
unsigned char M[10000];

// assumption: the starting address of the list is stored in esi, 
// 	and the sum of the list element is stored in eax
void exec(){
	eax = 0;
	loop1:
		if(*(int*)&M[esi+4] == 0)	goto endLoop1;
		eax += *(int*)&M[esi];
		
		esi = *(int*)&M[esi+4];	// 4 for data, and 4 for address
		goto loop1;
	endLoop1:{};
}

int main(){
	memset(M,0,10000);
	
	// initialization
	// generate a list of size 10, random addressed, data value ranged 1 ~ 1000
	int address,current_address,value,start_address;
	int i = 0;
	start_address = address = rand()%5000 * 2;
	
	printf("Numbers in the list: \n");
	
	while(i<10){
		current_address = address;
		value = rand()%1000 + 1;
		if(*(int*)&M[current_address])	continue;	// this value has been assigned

		*(int*)&M[current_address] = value;
		printf("%d ",value);
		address = rand()%5000 * 2;
		*(int*)&M[current_address + 4] = address;
		i++;
	}
	*(int*)&M[current_address + 4] = 0;
	
	putchar('\n');
	
	esi = start_address;
	
	// execution
	exec();
	
	// output result
	printf("sum = %d",eax);
	
	getchar();
	return 0;
}
