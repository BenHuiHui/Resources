#include <iostream>

using namespace std;

void printArray(int *arr, int startIndex, int endIndex){
	int i;
	for(i=startIndex; i<=endIndex; i++){
		cout<<arr[i]<<" ";
	}
	cout<<"\n";
}

void bubbleSort(int *arr, int startIndex, int endIndex){
	int i, j, temp;

	for(i=endIndex; i > startIndex; i--){
		for(j=startIndex; j < i; i++){
			if(arr[j] > arr[j+1]){
				temp = arr[j];
				arr[j] = arr[j+1];
				arr[j+1] = temp;
			}
		}
	}
}

int main(int argc, char* argv[]){
	int data[] = {45,2,33,11,5,9,7,21,10,67,99,123,42,81,100,54};
	
	cout<<"our numbers:\n";
	printArray(data, 0, 15);
	cout<<"\n\n\n";

	bubbleSort(data, 0, 15);

	cout<<"after sorting:\n";
	printArray(data, 0, 15);
	cout<<endl;

	system("PAUSE");
	return 0;
}