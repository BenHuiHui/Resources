#include <stdio.h>
#include <math.h>
#include <float.h>

#define ERR (-DBL_MAX)
#define MIN (-DBL_MAX + 100)
#define EPS 0.0001

double dabs(double a){
	return (a<0)?(-a):a;
}

double solve(double func(double),double x1, double x2, double eps){
	double mid = (x1 + x2)/2;
//	printf("eps = %lf; x1 = %lf, x2 = %lf \n",eps,x1,x2);
	if(dabs(x1-x2) < eps){
		return mid;
	} else if(func(x1) * func(mid) <= 0){
		return solve(func,x1,mid,eps);
	} else if(func(x2) * func(mid) <= 0){
		return solve(func,mid,x2,eps);
	}
	return MIN;
}


void output_res(double func(double),double x1,double x2,char funcName[]){
	double res = solve(func,x1,x2,EPS);
	if(res <= MIN){
		printf("%s: no solution\n",funcName);
	} else{
		printf("%s res: %lf\n",funcName,res);
	}
}

// functions for testing
double f1(double in){
	return in*2;
}

double f2(double in){
	return 3*in*in + 2*in - 2;
}

double f3(double in){
	return 1;
}


int main(){
	double eps = 0.001;
	
	output_res(f1,-1,1,"f1");
	output_res(f2,-1,1,"f2");
	output_res(f3,-1,1,"f3");
	
	getchar();
}
