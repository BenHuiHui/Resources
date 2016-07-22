#include <stdio.h>
#include <string.h>

int main (int argc, char *argv[])
{
	int i;
	FILE *in;
	
	char filename[50];
	if(argc < 1) return 1;
	strcpy(filename,argv[1]);
	
	in = fopen(filename,"r");
	int t,count = 0;
	while(fscanf(in,"%c",&t)!=EOF){
		count ++;
	};
	
	printf("Totla num of chars: %d\n",count);
	
	return 0;
}
