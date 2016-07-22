#include <stdio.h>

int ans[] = {2,24,480,13440,483840};

int main(){
    int n;
    while(scanf("%d",&n),n){
        printf("%d\n",ans[n-1]);
    }
    return 0;
}
