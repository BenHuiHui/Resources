
// global variables
int eax, ebx, ecx, edx, esi, edi;
int esp = 10000; int ebp = 10000;
unsigned char M[10000];

// put function here
void exec(){
	fib:
		// restore the context of the former ones
		esp -= 4; *(int*)&M[esp] = ebp;	// push ebp
		ebp = esp;
		esp -= 4; *(int*)&M[esp] = ebx;	// push ebx
		esp -= 4; *(int*)&M[esp] = edi;	// push edi
		esp -= 4; *(int*)&M[esp] = esi;	// push esi
		esp -= 8;	// allocate space for local var
		
		if(*(int*)&M[ebp+8] > 1) goto skip;
		// execute the if condition here
		eax = *(int*)&M[ebp+8];
		goto exit_fib;
	skip:
		esp -= 4; *(int *)&M[esp] = eax;	// push eax
		esp -= 4; *(int *)&M[esp] = ecx;	// push ecx
		esp -= 4; *(int *)&M[esp] = edx;	// push edx
		eax = *(int *)&M[ebp+8];	// get the value of n
		eax -= 1;
		esp -= 4; *(int *)&M[esp] = eax;	// push arg
		eax = (int) &&return_addr1;	// load return addr
		esp -= 4; *(int *)&M[esp] = eax;	// save return addr
		goto fib;
	return_addr1:
		esp += 4;	// clear arg
		edx = *(int *)&M[esp]; esp += 4;	// restore edx
		ecx = *(int *)&M[esp]; esp += 4;	// restore ecx
		*(int *)&M[ebp-16] = eax;	// the first free space
		eax = *(int *)&M[esp]; esp += 4;	// restore eax
		esp -= 4; *(int *)&M[esp] = eax;	// push eax
		esp -= 4; *(int *)&M[esp] = ecx;	// push ecx
		esp -= 4; *(int *)&M[esp] = edx;	// push edx
		eax = *(int *)&M[ebp+8];	// get arg 1
		eax -= 2;
		esp -= 4; *(int *)&M[esp] = eax;	// push n-2
		eax = (int) &&return_addr2;	// load return addr
		esp -= 4; *(int *)&M[esp] = eax;	// push return addr
		goto fib;
	return_addr2:
		esp += 4;	// clear arguments
		// restore local registor
		edx = *(int*)&M[esp]; esp +=4;	// restore edx
		ecx = *(int*)&M[esp]; esp +=4;	// restore ecx
		*(int*)&M[ebp-20] = eax;	// save y value
		eax = *(int*)&M[esp]; esp +=4;	// restore eax
		
		// load x
		eax = *(int*)&M[ebp-16];	// restore eax
		eax += *(int*)&M[ebp-20];	// add y
	exit_fib:	// exit epilogue
		esp += 8;	 //	clear local vars
		esi = *(int*)&M[esp]; esp +=4;	// restore
		edi = *(int*)&M[esp]; esp +=4;	// callee
		ebx = *(int*)&M[esp]; esp +=4;	// registers
		ebp = *(int*)&M[esp]; esp +=4;
		esp += 4; goto *(void*)&M[esp-1];	// return
}

int main(){
	
	// initialization
	
	// execution
	eax = 5;
	exec();
	
	// output result
	
	getchar();
	return 0;
}
