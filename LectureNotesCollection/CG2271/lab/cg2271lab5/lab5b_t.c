#include <stdio.h>
#include <pthread.h>

pthread_t thread[10];

int glob;

void *child(void *t){
	// Increment glob by 1, wait for 1 sec, then increment by 1 again
	printf("Child %d entering. Glob is currently %d\n",t,glob);
	glob++;
	sleep(1);
	glob++;
	printf("Child %d exiting. Glob is currently %d\n",t,glob);

	// ... ...
	pthread_exit(NULL);
}

int main(){
	int i, quit=0;
	glob=0;

	for(i = 0;i < 10; i++){
		pthread_create(&thread[i],NULL,child,(void *) i);
	}
	
	// wait for the program
	/*
	for(i = 0;i<10;i++){
		// make sure all threads has run
		pthread_join(thread[i],NULL);
	}*/

	// ... ... code to make the program multi-threading
	printf("Final value of glob is %d\n", glob);

	// ... ... other code to be added
}
