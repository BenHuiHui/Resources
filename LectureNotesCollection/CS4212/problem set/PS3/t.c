#define N 1e2
#include <stdio.h>
int main(){
	long long int i,j,s;
	i = j = s = 0;

	while(i < N){
		i++;
		while( j < N){
			j++;
			s++;
			printf("s = %lld, i = %lld, j = %lld\n",s,i,j);
		}
	}

	/*
	for(i = 0; i < N ; i++){
		for(j = 0; j < N ; j++){
			s++;
		}
	}
	*/

	printf("s = %d, i = %d\n",s,i);
	return 0;
}
