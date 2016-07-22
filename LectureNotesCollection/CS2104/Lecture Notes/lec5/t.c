#include <stdio.h>
int eax,ebx,ecx,edx,esi,edi,ebp,esp;
unsigned char M[10000];
void exec(void) {
    esp -= 4 ; *(int*)&M[esp] = 0 ; // push 0
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[0] = ecx ; // pop i
Lfor0:
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push i
    esp -= 4 ; *(int*)&M[esp] = 10 ; // push 10
    ecx = *(int*)&M[esp]; esp += 4;
    eax = *(int*)&M[esp]; esp += 4;
    if (eax < ecx ) goto Lforbody0;
    goto Lendfor0;
Lforbody0:
    ecx = *(int*)&M[4] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push s
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push i
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    eax += ecx ;
    esp -= 4 ; *(int*)&M[esp] = eax ; // push result of +
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[4] = ecx ; // pop s
    ecx = *(int*)&M[0] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push i
    esp -= 4 ; *(int*)&M[esp] = 1 ; // push 1
    ecx = *(int*)&M[esp] ; esp += 4 ;
    eax = *(int*)&M[esp] ; esp += 4 ;
    eax += ecx ;
    esp -= 4 ; *(int*)&M[esp] = eax ; // push result of +
    ecx = *(int*)&M[esp] ; esp += 4 ;
    *(int*)&M[0] = ecx ; // pop i
    goto Lfor0;
Lendfor0:
{}}

int main() {
    esp = 10000 ;
    exec();
    printf("s=%d\n",*(int*)&M[4]);
    printf("i=%d\n",*(int*)&M[0]);
    getchar();
    return 0;
}
