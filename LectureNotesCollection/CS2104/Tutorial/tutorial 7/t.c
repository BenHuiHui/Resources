#include <stdio.h>

int pascal(int n, int k) { 
    if ( k == 0 || k == n ) return 1;
    return pascal(n-1,k) + pascal(n-1,k-1) ; 
} 
 

int main(){
	printf("res = %d\n",pascal(10,5));
	getchar();
}
