#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include "pcomm.h"

pq_t *queue;
sem_t all_completed;

void *reader(void *p)
{
	// Read and print integers from the queue.

	int i, sum=0, val;
	printf("READER thread created\n");

	for(i=0; i<50; i++)
	{
		val=pq_get(queue);
		printf("Read %d from the queue\n", val);
		sum+=val;
	}

	printf("Final sum of numbers read from the queue is %d\n", sum);
    sem_post(&all_completed);    // finish execution, post to allow main to go on
	pthread_exit(NULL);
}

void *writer(void *p)
{
	int i, n;
	printf("Writer thread %d created\n", p);
	for(i=0; i<10; i++)
	{
		// Thread 0 will write 0 to 9, thread 1 will write 10 to 19, etc.
		n=(int) p * 10 + i;
		pq_put(queue, n);
		sleep(1);
	}
	printf("Writer thread %d exiting\n", p);
    sem_post(&all_completed);    // finish execution, post to allow main to go on
	pthread_exit(NULL);
}

int main()
{
	int i;
	pthread_t read_thread;
	pthread_t write_threads[5];

	// Create the queue
    queue=pq_create(10);    // the queue has size 10 only

    // initialize the semaphore
    sem_init(&all_completed,1,0);
file:///home/songyy/Desktop/current_module/CG2271/lab/cg2271lab7/lab7a.c

	pthread_create(&read_thread, NULL, reader, NULL);

	// Launch threads
	for(i=0; i<5; i++)
		pthread_create(&write_threads[i], NULL, writer, (void *) i);

    // wait 6 times for all programs to complete
    for(i=0; i<6; i++)    sem_wait(&all_completed);

	pq_destroy(queue);
	pthread_exit(NULL);
	return 0;
}

