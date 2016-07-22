
// global variables
int eax, ebx, ecx, edx, esi, edi, ebp,esp = 10000;
unsigned char M[10000];

// put function here
void exec(){
		// initialization -- caller
		// ebp is pointing to here:
		ebp = esp;
		esp -= 4; *(int*)&M[esp] = eax;	// push eax
		esp -= 4; *(int*)&M[esp] = ecx;	// push ecx
		esp -= 4; *(int*)&M[esp] = edx;	// push edx
		esp -= 4; *(int*)&M[esp] = 4;	// push 4
		esp -= 4; *(int*)&M[esp] = 3;	// push 3
		esp -= 4; *(int*)&M[esp] = 2;	// push 2
		esp -= 4; *(int*)&M[esp] = 1;	// push 1
		eax = (int) && return_address;
		esp -= 4; *(int*)&M[esp] = eax;	// push return address
		goto f;
	return_address:
		esp += 16;	// clear arguments to the point when pushing edx
		edx = *(int*)&M[esp]; esp+=4;	// pop edx
		ecx = *(int*)&M[esp]; esp+=4;	// pop ecx
		*(int*)&M[ebp-20] = eax;		// get the result from eax first
		eax = *(int*)&M[esp]; esp+=4;	// pop eax
		goto end;
	f:
		esp -= 4; *(int *)&M[esp] = ebp;	// push ebp
		ebp = esp;
		esp -= 4; *(int *)&M[esp] = ebx;	// push ebx
		esp -= 4; *(int *)&M[esp] = edi;	// push edi
		esp -= 4; *(int *)&M[esp] = esi;	// push ebx
		esp -= 12;	// allocate 3 space for local vars
		
			// calculate x
		eax = *(int *)&M[ebp+8];	// pop arg 1
		eax += *(int *)&M[ebp+12];	// 
		eax += *(int *)&M[ebp+16];	// 
			// restore the result
		*(int *)&M[ebp-16] = eax;	// use the first free space
		
	 		// calculate y
		eax = *(int *)&M[ebp+12];
		eax += *(int *)&M[ebp+16];
		eax += *(int *)&M[ebp+20];
		*(int *)&M[ebp-20] = eax;	// use the second free space
		
			// calculate z
		eax = *(int *)&M[ebp-16];	// load x
		eax /= *(int *)&M[ebp-20];	// load y
		*(int *)&M[ebp-24] = eax;	// store in the third free space
		
		eax = 2;
		eax *= *(int *)&M[ebp-24];
		
		// finish ..., clean up here.
		esp +=12;	// clear local vars
		esi = *(int*)&M[esp]; esp += 4;	// restore esi
		edi = *(int*)&M[esp]; esp += 4;	// restore edi
		ebx = *(int*)&M[esp]; esp += 4;	// restore ebx
		ebp = *(int*)&M[esp]; esp += 4;	// restore the activation record
	end:{};
}



int main(){
	// execution
	
	printf("before exec, esp = %d\n",esp);
	exec();
	printf("after exec, esp = %d\n",esp);
	printf("value of eax=%d\n",eax);
	// output result
	
	getchar();
	return 0;
}
