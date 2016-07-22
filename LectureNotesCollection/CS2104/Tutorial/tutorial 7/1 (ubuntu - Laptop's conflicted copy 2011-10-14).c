#include <stdio.h>
#define STACK_MAX 10000

// global variables
int eax, ebx, ecx, edx, esi, edi,ebp;
int esp = STACK_MAX;
unsigned char M[STACK_MAX];

// assume n is stored in eax, and k is stored in ebx
// the result is stored in eax
void exec(){
	ecx = (eax == 0);
	edx = (eax == ebx);
	ecx |= edx;
	if(ecx) goto exe_if;
	goto exe_else;
	exe_if:
		eax = 1;
		goto end;
	
	exe_else:
		// first recursive call
			// save the register value
		esp -= 4; *(int *)&M[esp] = eax;
		esp -= 4; *(int *)&M[esp] = ecx;	// first argu
		esp -= 4; *(int *)&M[esp] = edx;	// second argu
			// load the return address to eax
		eax = (int) &&first_recur_return;
		esp -= 4; *(int *)&M[esp] = eax;	// push return address
		
		
	first_recur_return:{};	// the return address of the first recursive call	
	end:{};
}

int main(){
	
	// initialization
	
	// execution
	exec();
	
	// output result
	
	getchar();
	return 0;
}

