#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

#define NO_EXCEPTION 0
#define EXC1 1
#define EXC2 2
#define EXC3 3

struct Exc{
    int t;
} E;
//extern jmp_buf push();  // create empty exc slot on stack
//extern jmp_buf pop();   // remove exc slot from stack, but return old top

jmp_buf env;


int main(){
    //jmp_buf env;
    int i;

    i = setjmp(env);
    printf("i=%d\n",i);
    if(i != 0){
        exit(0);
    }

    longjmp(env,0); // ASK: why it still return 1 even if it's 0 here?
    printf("Does this line get printed?\n");

    return 0;
}
