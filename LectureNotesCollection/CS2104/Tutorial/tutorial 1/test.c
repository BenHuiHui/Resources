int main(){
	int c = 0x7fffffff;
	printf("%d\n",c);
	c <<= 1;
	printf("%d\n",c);
	c <<= 100;
	printf("%d\n",c);
	getchar();
	return 0;
}
