#include <stdlib.h>
#include <stdio.h>

// name of function in the generated code
int entry() asm("_entry") ;

// array holding all variable storage
extern int var_area[] asm("__var_area") ;

// array holding pointers to variable names
//   -- variable var_area[i] has name varnameptr[i]
extern char *varnameptr[] asm("__var_ptr_area");

// array holding all array storage
extern int *arr_area[] asm("__arr_area");
// array holding pinters to variable of array
extern char *arr_name_ptr[] asm("__arr_ptr_area");
// array holding pinters to variable of array
extern int arr_size_area[] asm("__arr_size_area");

int main() {
    int i = 0,j, result ;

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
    
    for(i=0;arr_name_ptr[i] != NULL;i++){
        printf("%s =",arr_name_ptr[i]);
        for(j = 0; j < arr_size_area[i]; j++){
            printf(" %d",*(arr_area + arr_size_area[i] * i + j));
        }
        putchar('\n');
    }

    return 0;
}
