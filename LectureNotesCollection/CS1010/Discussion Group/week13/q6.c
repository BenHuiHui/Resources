#include <stdio.h>
#include <stdlib.h>
#define MXSIZE 100

int main(){
    FILE *fin = fopen("q6.in","r");
    FILE *fout = fopen("q6.out","w");
    int arr[MXSIZE];
    int n,t,i,j;

    fscanf(fin,"%d",&n);
    if(n > MXSIZE){
        fprintf(stderr,"Your input size is too large");
        exit(1);
    }

    for(i = 0; i < n;i++){
        fscanf(fin,"%d",&arr[i]);
    }
    
    for(i = 0;i<n;i++){
        for(j=i, t = arr[i]; j > 0 && t < arr[j]; j--){
            arr[j+1] = arr[j];
        }
        arr[j] = t;
    }

    for(i = 0;i < n ; i++){
        printf("%d ",arr[i]);
    }

    return 0;
}
