#include <pthread.h>
#include <stdlib.h>

#include "pcomm.h"

pq_t *pq_create(int size)
{
    pq_t *tmp;


    tmp=(pq_t *) malloc(sizeof(pq_t));
    
    
    if(tmp != NULL)
    {
		tmp->q = (int *) calloc((size_t) size, sizeof(int));
		if(tmp->q)
		{
		    tmp->head=0;
		    tmp->tail=0;
		    tmp->size=size;
		    tmp->count=0;

            // initialize the semaphores
            // all can share data (1), and initially no signal issued(0)
            sem_init(&(tmp->sema_full),1,0);
            sem_init(&(tmp->sema_empty),1,0);
		}
		else    // when fail to create a queue array
		{
		    free(tmp);
		    tmp=NULL;
		}
    }

    return tmp;
}

void pq_destroy(pq_t *q)
{
    if(q)
    {
		if(q->q){
            // destory the semaphore
            sem_destroy(&(q->sema_full));
            sem_destroy(&(q->sema_empty));
		    free(q->q);
        }

		free(q);
    }
}

void pq_put(pq_t *q, int b)
{
	// Wait if full.
    while(q->count == q->size){
		sem_wait(&(q->sema_full));
    }

    // No longer full. Now add in the item
    q->q[q->head]= b;
    q->head = (q->head + 1) % q->size;
    q->count++;

    // if it has an element, try to wake up get
    if(q->count == 1)   sem_post(&q->sema_empty);
}

int pq_get(pq_t *q)
{
    int ret;

	// Wait on empty -- a while loop is needed to use up all the positive posts 
    while(q->count == 0)    sem_wait(&(q->sema_empty));

    // We now have something to read.
    ret=q->q[q->tail];
    q->tail = (q->tail + 1) % q->size;
    q->count--;

    // check to wake up the put, if it's no longer full
    if(q->count == q->size -1)  sem_post(&q->sema_full);

    return ret;
}

