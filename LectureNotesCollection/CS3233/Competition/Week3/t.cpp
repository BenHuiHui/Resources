#include <iostream>
#include <cstdio>

using namespace std;

int main(){
    int n = 0x9e;
    printf("res: %x",n ^ (1<<0)) ;//((~( 1<<3 ) )));

    return 0;
}
