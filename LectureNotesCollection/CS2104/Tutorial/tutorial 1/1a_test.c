
int f(int a, int b){
	while(a!=b)
		if(a<b)
			b -= a;
		else
			a -= b;
	return a;
}

int main(){
	printf("%d",f(12,15));
	getchar();
	return 0;
}
