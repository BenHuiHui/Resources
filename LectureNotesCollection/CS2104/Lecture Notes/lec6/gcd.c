#include <stdio.h>
int eax,ebx,ecx,edx,esi,edi,ebp,esp;
unsigned char M[10000];
void exec(void) {
    esp -= 4 ; *(int*)&M[esp] = 144 ; // push 144
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[0] = ecx ; // pop x
    esp -= 4 ; *(int*)&M[esp] = 60 ; // push 60
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[4] = ecx ; // pop y
Lwhile0:
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push x
    ecx = *(int*)&M[4] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push y
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    if ( eax != ecx ) goto Lwhilebody0;
    goto Lendwhile0;
Lwhilebody0:
    // start of if-then-else statement
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push x
    ecx = *(int*)&M[4] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push y
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    if ( eax < ecx ) goto Lthen1;
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push x
    ecx = *(int*)&M[4] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push y
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    eax -= ecx ;
    esp -= 4 ; *(int*)&M[esp] = eax ; // push result of -
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[0] = ecx ; // pop x
    goto Lendif1;
Lthen1:
    ecx = *(int*)&M[4] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push y
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push x
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    eax -= ecx ;
    esp -= 4 ; *(int*)&M[esp] = eax ; // push result of -
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[4] = ecx ; // pop y
Lendif1:
    goto Lwhile0;
Lendwhile0:
{}}

int main() {
    esp = 10000 ;
    exec();
    printf("y=%d\n",*(int*)&M[4]);
    printf("x=%d\n",*(int*)&M[0]);
    return 0;
}
