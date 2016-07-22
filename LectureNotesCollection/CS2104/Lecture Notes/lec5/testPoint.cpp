#include <stdio.h>
#include <stdlib.h>

// pointer to a function f, which returns a pointer
//  to an array of pointer of pointer
int **(*f())[10]{
	return (int **(*)[10])malloc(sizeof(int **(*)[10]));
}

int main(){
	int **(*(*p)())[10];
	// pointer to a function, which returns a 
	//   pointer
	//   of an array of pointer of pointer.
	//   the size of array is 10, 
	
	// only when one specify the size of array, it 
	// can be equal then =
	p = &f;
	
	getchar();
	return 0;
}
