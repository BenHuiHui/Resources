#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex=PTHREAD_MUTEX_INITIALIZER;
pthread_t thread[10];

int glob;

void *child(void *t){
	// Increment glob by 1, wait for 1 sec, then increment by 1 again
	printf("Child %d entering. Glob is currently %d\n",t,glob);
	pthread_mutex_lock(&mutex);
//    printf("--- Mutex Locked for %d\n",t);
	glob++;
	sleep(1);
	glob++;
//    printf("-- Mutex Unlock for %d",t);
	pthread_mutex_unlock(&mutex);
	printf("Child %d exiting. Glob is currently %d\n",t,glob);

	// ... ...
	pthread_exit(NULL);
}

int main(){
	int i, quit=0;
	glob=0;

	for(i = 0;i < 10; i++){
//      child((void *)i);
		pthread_create(&thread[i],NULL,child,(void *) i);
	}
	
	// wait for the program
	for(i = 0;i<10;i++){
		// make sure all threads has run
        pthread_join(thread[i],NULL);
	}

	printf("Final value of glob is %d\n", glob);
	pthread_mutex_destroy(&mutex);
}
