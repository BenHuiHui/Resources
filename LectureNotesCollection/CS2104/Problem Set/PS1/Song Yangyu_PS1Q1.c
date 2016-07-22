/* Write a VAL program that converts a string made up of digit characters into the unsigned 
	numeric value corresponding to that string. Your program should assume that the sting 
	resides in memory at the address pointed to by register esi, and should return the result in 
	register eax. 
 */


// global variables
int eax, ebx, ecx, edx, esi, edi;
unsigned char M[10000];

// Assumption: esi would store the starting address of the string in M; the string is a integer
// 		where each character in a digit character. The string terminates with a non-digit character
//	this program would store the integer result in eax
void exec(){
	// initializion for the for loop
	eax = 0;
	startFor1:
		if((M[esi] > '9') || (M[esi] < '0')){
			goto endFor1;
		}
		eax *= 10;
		eax += M[esi] - '0';
		esi++;
		goto startFor1;
	endFor1:{};
}

int main(){
	// testing
	
	// initialization: make M to store 12345
	edi = 0;
	startFor:
		if(edi == 5){
			goto endFor;
		}
		esi = '1';
		esi += edi;
		M[edi] = esi;
		edi++;
		goto startFor;
	endFor:{M[edi] = 0;};

	esi = 0;

	// execution
	exec();
	
	// output result
	printf("%d",eax);
	
	getchar();
	return 0;
}
