#include <stdio.h>
#include <string.h>

int main(){
  char ori_name[20] = "myfile.txt";
  char basename[10] = "myfile";
  char ext[10] = ".txt";
  char newfilename[20];
  int i,j;

  FILE *fs = fopen(ori_name,"r");
  if(!fs){
    fprintf(stderr,"Sorry src file non-exist, exiting.\n");
    exit(1);
  }
  
  fseek(fs,0,SEEK_END);
  int totalsize = ftell(fs);
  int base_size = totalsize / 10;

  char *buf = malloc(base_size);

  for(i = 1; i <= 10; i++){
    rewind(fs);
    sprintf(newfilename,"%s%d%s",basename,i,ext);

    FILE *ft = fopen(newfilename,"w");
    if(!ft){
      fprintf(stderr,"Sorry cannot creat target file, exiting.\n");
      exit(1);
    }
    
    for(j = 0; j < i; j++){
      fread(buf,base_size,1,fs);
      fwrite(buf,base_size,1,ft);
    }

    fclose(ft);
  }

  free(buf);
  return 0;
}
