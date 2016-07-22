int a[] = {1,2,3,4,5};

int f(){
	return a[0] - a[1] * a[2] * (a[1] + a[2]) - a[3] << a[4];
}

int main(){
	printf("%d",f());
	getchar();
	return 0;
}
