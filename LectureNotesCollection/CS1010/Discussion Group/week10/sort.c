#include <stdio.h>
#define ARR_SZIE 6

void insertion_sort(int arr[], int size){
    int i,j,t;

    // note i should start from 1 cuz the first element is sorted
    for(i = 1;i<size;i++){
        t = arr[i];
        for(j = i; j > 0 && arr[j-1] > t; j--){
            arr[j] = arr[j-1];
        }   
        // the termintion position of j is the place to insert the variable
        arr[j] = t;
    }   
}

void selection_sort(int arr[],int size){
    int i,j,min,min_idx;
    
    for(i = 0;i<size;i++){
        min = arr[i]; min_idx = i;
        for(j = i+1;j<size;j++){
            if(arr[j] < min){
                min = arr[j];
                min_idx = j;
            }
        }

        arr[min_idx] = arr[i];
        arr[i] = min;
    }
}

void bubble_sort(int arr[],int size){
    int i,hasSwap,t;
    do{
        hasSwap = 0;
        for(i = 1;i < size; i++){
            if(arr[i-1] > arr[i]){
                t = arr[i-1]; arr[i-1] = arr[i]; arr[i] = t;
                hasSwap = 1;
            }
        }
    }while(hasSwap);
}

// print out teh given array (with size) within one line
void print_array(int arr[], int size){
    int i;
    for(i = 0;i< size;i++)  printf("%d ",arr[i]);
    printf("\n");
}

int main(){
    int arr[] = {4,7,2,6,8,5},i;
    
    printf("before sorting, the array is: ");
    print_array(arr,ARR_SZIE);

    bubble_sort(arr,ARR_SZIE);

    printf("after sorting, the array is: ");
    print_array(arr,ARR_SZIE);

    return 0;
}
