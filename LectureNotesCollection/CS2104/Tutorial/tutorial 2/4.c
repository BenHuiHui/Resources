#include <stdio.h>


int main(int argc, char *argv[]){
	char *input = argv[1];
	
	int i=0;
	int state = 0;
	
	while(1){
		char c = input[i];
		switch(state){
		case 0:
			if(c == 'a'){
				state = 2;
			} else if(c == 'b'){
				state = 1;
			} else if(c == 0){
				// reject
				return 0;
			} else{
				state = 0;
			}
			break;
		case 1:
			if(c == 'c'){
				state = 2;
			} else if(c== 0){
				return 0
			} else{
				state = 0;
			}
		case 2:
			if(c=='d'){
				state = 3;
			} else if(c==0){
				return 0;
			} else{
				state = 0;
			}
		case 3:
			if(c == 'd'){
				state = 3;
			} else if(c == 'e'){
				state = 4;
			} else if(c == 0){
				return 0;
			} else{
				state = 0;
			}
		case 4:
			if(c == '0'){
				printf("str Matches : )");
			} else if( c == 'a'){
				
			}
		}
	}
	
	return 0;
}
