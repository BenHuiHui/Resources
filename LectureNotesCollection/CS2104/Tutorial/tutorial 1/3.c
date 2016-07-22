
// global variables
int eax, ebx, ecx, edx, esi, edi;
unsigned char M[10000];

// assumption:
	// ebx - address of the array (as int)
	// ecx - # of elements
	// results to be stored in eax
void exec(){
	// use esi as the temp address
	esi = ebx;
	
	// eax for storing the result
	eax = *(int*)esi;
	edi = 0;	// use edi as a sentinel
	
	loop:
		if(edi >= ecx)goto endloop;	// termination condition

		if((*(int*)esi) <= eax) goto endIf1;	// Buggy here.. need to do debug.
			eax = *(int*)esi;
		endIf1:{};
	
		esi += 4;	// increase by the size of int
		edi += 1;	// increase the value of sentinel
		goto loop;
	
		endloop:{};
		end:{};
}

int main(){
	// initialization
	esi = 0;
	loop1:
		if(esi > 20)goto endloop1;
		*(int*)&M[esi] = esi;
		
		esi += 4;
		goto loop1;
	endloop1:{};
	ebx = (unsigned char)&M;
	ecx = 5;
	// execution
	exec();
	
	// output result
	printf("%d\n",eax);
	
	getchar();
	return 0;
}
