#include <stdio.h>

// return: the address of local variable a
int* t(int in){
    int a = in;
    return &a;
}

/*
int (*f(int x))(int){
    int g(int y){
        return x+y;
    }
    return &g;
}
*/

main(){
    int i=0;

    int *p = t(12);

    t(11);

    int a[10000] = {0};

    printf("Value: %d\n",*p);
    
}
