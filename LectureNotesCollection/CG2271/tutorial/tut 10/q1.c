
// global variables
int eax, ebx, ecx, edx, esi, edi;
int esp = 10000; ebp = 10000;
unsigned char M[10000];

// note that the __cdecl

/*
    int x = 1;
    while(n>0){
        x += f(n);
        n--;
    }
    return x;
*/

// variable number of arguments TODO: check it here
// int printf(*a,...)

//


// put function here
__stdcall void exec(){
    f:
    esp -= 4; *(int*)&M[esp] = ebp;
    ebp = esp;
    esp -= 4;   // space for local variable
    *(int*)&M[ebp-4] = 1;
    again:
    if(*(int*)&M[ebp+8] <= 0) goto while_end;
    // call f(n)
    eax = *(int*)&M[ebp+8];
    esp -= 4; *(int*)&M[esp] = eax;  // push n
    esp -= 4; *(int*)&M[esp] = (int*)&&return_addr1;
    goto f;
    return_addr1:
    *(int*)&M[ebp-4] = eax; // the res is stored in eax
    eax = *(int*)&M[ebp+8];
    eax += 1;
    *(int*)&M[ebp+8] = eax; // n++
    goto again;
    end_f:
    // finish f, clean up and return
    eax = *(int*)&M[ebp-4];
    // then clean up
    esp += 4;   // clean up the local variable
    esp +=
}

int main(){

	// initialization

	// execution
	exec();

	// output result

	getchar();
	return 0;
}
