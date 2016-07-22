#include <stdlib.h>
#include <stdio.h>

// name of function in the generated code
int entry() asm("_entry") ;

// array holding all variable storage
extern int var_area[] asm("__var_area") ;

// array holding pointers to variable names
//   -- variable var_area[i] has name varnameptr[i]
extern char *varnameptr[] asm("__var_ptr_area");

int main() {
    printf("start of excu\n");
    int i = 0, result ;

    // call the function and collec its return value
    //  -- eax can be always used to return a value if needed
    result = entry() ;

    // print the result; only significant if eax has been set
    // to return something meaningful
    printf("Result = %d\n",result) ;

    // print all the variables used in the generated code
    while(varnameptr[i] != NULL) {
        printf("%s = %d\n",varnameptr[i],var_area[i]) ;
        i++ ;
    }
}
