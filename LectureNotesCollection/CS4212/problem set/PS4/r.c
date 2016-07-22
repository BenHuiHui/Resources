#include <stdio.h>
#include <stdlib.h>

int entry() asm("_entry");

int main(){
  printf("start of exec\n");
  printf("result: %d\n",entry());

  return 0;
}
