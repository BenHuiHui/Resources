#include <stdio.h>

int f(int a, int b, int c, int d){
	int x,y,z;
	x = a + b + c;
	y = b + c + d;
	printf("x=%d, y=%d. \n",x,y);
	z = y/x;
	return 2 * z;
}

int main(){
	int r = f(1,2,3,4);
	
	printf("r=%d\n",r);
	
	getch();
	return 0;
}
