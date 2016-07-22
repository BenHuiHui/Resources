#include <stdio.h>

#define BID_MAX_NUM 10002

void swap(int* x, int* y){ 
    int t = *x; 
    *x = *y; 
    *y = t;
}

int main(){
    int COE_num, bid_arr[BID_MAX_NUM],t,i,bidNum;
    int hasSwap = 1;

    printf("Number of available COEs: ");
    scanf("%d",&COE_num);

    printf("Enter bids: ");
    for(i = 0; scanf("%d",bid_arr + i), bid_arr[i]; i++);
    bidNum = i;

    hasSwap = 1;
    while(hasSwap){
        hasSwap = 0;
        for(i=1;i<bidNum;i++){
            if(bid_arr[i-1] < bid_arr[i]){
                swap(bid_arr + i - 1, bid_arr + i); 
                hasSwap = 1;
            }   
        }   
    }   
    
    // Assume: there's always a choice, and COE_num always greater than the size of array
    while(bid_arr[COE_num - 1] == bid_arr[COE_num]){
        COE_num--;
    }   
    
    printf("%d",bid_arr[COE_num-1]);

    return 0;
}
