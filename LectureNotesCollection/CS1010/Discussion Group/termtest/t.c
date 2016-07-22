#include "stdio.h"      // why does it matter?

int main(void){
    int a = 1;
    printf("%d\n", ++a * (++a + a++));
    return 0;
}
