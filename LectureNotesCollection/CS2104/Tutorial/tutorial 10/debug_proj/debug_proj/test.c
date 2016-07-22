#include <stdio.h>

int stack[10000];

int* f(){
    return stack;
}

int main(){
    int *st = f();
    st[1];
}
