#include <stdio.h>
#define STACK_MAX 10000

// global variables
int eax, ebx, ecx, edx, esi, edi,ebp;
int esp = STACK_MAX;
unsigned char M[STACK_MAX];

// assume n is stored in eax, and k is stored in ebx
// the result is stored in eax
void exec(){
	pascal:	// mark the start of the function
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
		// load the return address to edi - for save_context to use
		edi = (int) &&first_recur_return;
	first_recur_return:	// the return address of the first recursive call
		
		// second recursive call
	second_recur_return:
		
			// save the register value again
	goto end;	// suppose to be the end of this function

	save_context:	// assumption: edi stores the return address.
		// save the register value
		esp -= 4; *(int *)&M[esp] = eax;	// push eax - first argument
			// save the esp to esi to restore this later
		esi = esp;
		esp -= 4; *(int *)&M[esp] = ebx;	// push ebx - second argument
		esp -= 4; *(int *)&M[esp] = ecx;	// push ecx
		esp -= 4; *(int *)&M[esp] = edx;	// push edx
			// save the return address
		esp -= 4; *(int *)&M[esp] = edi;	// push return address
			// load the argument to the register
		eax = *(int *)&M[esi];
		esi -= 4; ebx = *(int *)&M[esi];
			// then go to the start of this function
		goto pascal;
	
	load_context:	// assumption: edi stores the goto address.
		esi = esp; esp += 4; // save the position of the return address in the stack
		if(esp > STACK_MAX)	return;	// return when no more stack to pop
		edx = *(int *)&M[esp]; esp += 4; // pop edx
		ecx = *(int *)&M[esp]; esp += 4; // pop ecx
		ebx = *(int *)&M[esp]; esp += 4; // pop ebx
		eax = *(int *)&M[esp]; esp += 4; // pop eax

		goto * *(void *)&M[esi];	// goto the saved address
	end:
		// goto the saved address
		goto load_context;
}

int main(){
	
	// initialization
	
	// execution
	exec();
	
	// output result
	
	getchar();
	return 0;
}

