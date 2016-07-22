#include <stdio.h>

int fib(int n){
	int x, y;
	if(n <= 1)	return n;
	x = fib(n-1);
	y = fib(n-2);
	return x+y;
}

int main(){
	printf("fib(5) = %d\n",fib(5));
	
	getchar();
	return 0;
}
