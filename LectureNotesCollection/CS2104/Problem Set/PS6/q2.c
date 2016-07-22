#include <stdio.h>

// global variables
int eax, ebx, ecx, edx, esi, edi;
int esp = 10000; int ebp = 10000;
unsigned char M[10000];


int main(){
	esp -= 4; *(int*)&M[esp] =ebp;
	ebp  = esp; // save the ebp first

    // initialization
	esp -= 1000;    // leave space for a
	esp -= 4; *(int*)&M[esp] =ebp - 1000;    // p -> the address of a

	// push in arguments
    esp -= 4; *(int*)&M[esp] = ebp - 1004;    // &p
    esp -= 4; *(int*)&M[esp] = 4;
    esp -= 4; *(int*)&M[esp] = 1;
    esp -= 4; *(int*)&M[esp] = 2;
    esp -= 4; *(int*)&M[esp] = 3;
    // and the return address
    esp -= 4; *(int*)&M[esp] = (int)&&fun_end;
    // call the hanoi
    goto hanoi;


    // start of the function
	hanoi:
	// save ebp
	esp -= 4; *(int *)&M[esp] = ebp;
	// load the new ebp
	ebp = esp;
		// position of the variables at M:
		//	former ebp: ebp
		//	p: ebp + 24
		//	n: ebp + 20
		//	a: ebp + 16
		//	b: ebp + 12
		//	c: ebp + 8
		//	return address: ebp + 4

	if(*(int*)&M[ebp+20] == 0) goto hanoi_end;
	// on not, calling hanoi
		// push in arguments
    eax = *(int*)&M[ebp+24];    // load the address of p
	esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+20]; eax -= 1;   // load n
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+16];    // load a
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+8];    // load c
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+12];    // load b
    esp -= 4; *(int*)&M[esp] = eax;
    esp -= 4; *(int*)&M[esp] = (int)&&return_addr1;
    goto hanoi;

	return_addr1:
    eax = '0';
    eax += *(int*)&M[ebp+16];
    ebx = *(int*)&M[ebp+24];    // address of p
    ecx = ebx;
    ebx = *(int*)&M[ebx];       // dereference p
    M[ebx] = eax;       // **p = '0' + (char)a, use the space of one char only
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++
    M[ebx] = 't';       // **p = 't'
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++
    M[ebx] = 'o';       // **p = '0'
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++
    M[ebx] = ' ';       // **p = ' '
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++
    eax  = '0'; eax += *(int*)&M[ebp+12];   // '0' + (char)b
    M[ebx] = eax;       // **p = ...
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++
    M[ebx] = '\n';       // **p = '\n'
    ebx += 1; *(int*)&M[ecx] = ebx; // (*p)++

    //call hanoi again, put the arguments before calling
    // push in arguments
    eax = *(int*)&M[ebp+24];    // load p
	esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+20]; eax -= 1;   // load n
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+8];    // load c
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+12];    // load b
    esp -= 4; *(int*)&M[esp] = eax;
    eax = *(int*)&M[ebp+16];    // load a
    esp -= 4; *(int*)&M[esp] = eax;
    esp -= 4; *(int*)&M[esp] = (int)&&return_addr2; // after calling, go to end directly

    goto hanoi;
    // leave it here purposely for doing some potential cleaning after calling
    return_addr2:{}

	// the end of hanoi function, should do some clean up here
	hanoi_end:
	// no local variable to free
	// no need to restore eax~edx, esi,edi
	// restore ebp first
	ebp = *(int*)&M[esp];   esp += 4;
	// clean up the stack of passed variable, goto the return address
	esp += 24;  // 5 variables, and one return address

	goto **(int *)&M[esp - 24]; // load the return address

	fun_end:
    // load the address p
    eax = *(int*)&M[ebp - 1004];
    M[eax] = '\0';
	// printf("eax =  %d, char = %c, char val = %d",eax,M[eax],M[eax]);

	// print out the final result
	printf("%s",M + ebp - 1000);

	return 0;
}
