#include <stdio.h>
#include <stdlib.h>

char array[4096][2]={0};

int main(int argc, char** args){
  for(int i=0; i<4906; i++){
    array[i][0] = '0';
	array[i][1] = '0';
  }
  FILE *input;
  char ch[5];
  if(argc<2){
    printf("format: hex2rom.exe filename.hex\n");
	return 0;
  }
  input = fopen(args[1], "r");
  if(input == NULL){
    printf("cannot open file...\n");
	return 0;
  }
  while((ch[0]=getc(input))==':'){
    ch[0]=getc(input); ch[1]=getc(input); ch[2] = 0;
	int numB = strtol(ch, NULL, 16);
	ch[0]=getc(input); ch[1]=getc(input); ch[2]=getc(input); ch[3]=getc(input); ch[4] = 0;
	int rel = strtol(ch, NULL, 16);
	ch[0]=getc(input); ch[1]=getc(input); ch[2] = 0;
	int flag = strtol(ch, NULL, 16);
	if(flag == 1) break;
	for(int i=0; i<numB; i++){
		ch[0]=getc(input); ch[1]=getc(input); ch[2] = 0;
		array[rel+i][0] = ch[0]; array[rel+i][1] = ch[1];
	}
	getc(input); getc(input); getc(input);
  }
  FILE *output;
  output = fopen("romcontent.txt", "w");
  for(int i=0; i<256; i++){
    for(int j=0; j<16; j++){
	  fprintf(output, "x\"%c%c\", ", array[i*16+j][0], array[i*16+j][1]);
	}
	fprintf(output, "\n");
  }
  fclose(output);
  fclose(input);
}