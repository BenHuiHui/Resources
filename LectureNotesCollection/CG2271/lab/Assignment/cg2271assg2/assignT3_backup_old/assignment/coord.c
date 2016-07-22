/*
 * coord.c
 *
 * Created: 21/10/2011 8:36:30 AM
 *  Author: dcstanc
 */ 
#define F_CPU	16000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdlib.h>

#include "coord.h"
#include "kernel.h"

OSSignal *queueblockedtask;
/* ======================================= */
/* Critical section management             */
/* ======================================= */
inline void enterCritical()
{
	cli();
}

inline void leaveCritical()
{
	sei();
}

/* ======================================= */
/* Semaphore routines                      */
/* ======================================= */

#ifdef OSIncludeSema

// Creates a semaphore with initial value initval
OSSignal *OSmakeSema(int initval)
{
	// assume initval < 20
	
	
	OSSignal *sema = OSmakeQ(20, sizeof(int));
	sema->count = initval;
	sema->head = initval;
	
	return sema;
}

// Takes a semaphore. Blocks if semaphore is 0.
void OSSemPend(OSSignal *sema)
{
	//if block condition
	//enq blocked task to another queue to keep track of blocked task
	//OSSwapTask();
	OSdeq(sema);
	
	/*
	while(sema->semaphore == 0)
	{
		//block
	}	
	sema->semaphore--;
	*/
}

// Posts a semaphore.
void OSSemPost(OSSignal *sema)
{
	OSenq(sema, 0);
	/*enterCritical();
	if (queueblockedtask->count != 0)
	{
		OSUnblockTask(queueblockedtask->q);
		queueblockedtask->count--;
	}
	leaveCritical();*/
	//if blocked task queue not empty
	//unblocked & execute task
	//sema->semaphore++;
}


#endif

/* ======================================= */
/* Queue routines                          */
/* ======================================= */

#ifdef OSIncludeQueues

// qsize=number of elements in the queue. esize=size of each element. So calling makeQ(10, sizeof(int)) would produce a queue of 10 elements, 
// with each element being the size of an integer.
OSSignal *OSmakeQ(int qsize, int esize)
{
	OSSignal *tmp;
	
	tmp = (OSSignal *) malloc(sizeof(OSSignal));
	if(tmp != NULL)
	{
		tmp->q = (char *) calloc((size_t) qsize, (size_t) esize);
		if(tmp->q)
		{
			tmp->head = 0;
			tmp->tail = 0;
			tmp->count = 0;
			tmp->size = qsize;
		}
		else
		{
			free(tmp);
			tmp = NULL;
		}
	}
	
	return tmp;
}

// Inserts item into queue q
void OSenq(OSSignal *q, void *item)
{
	//Block if full
	//OSSemPend(&(q->empty));
	//OSSemPend(&(q->mutex));
	//
	
	
	/*while(q->count == q->size)
	{
		 //block
	}*/
	 while(1)
	 {
		 enterCritical();
		 if (q->count < q->size)
		 {
			 break;
		 }
		 leaveCritical();
		 //SWAP;	 
	 }
	
	//enterCritical();
	/*if(q->count == q->size)
	{
		OSenq(queueblockedtask, (void*) OSBlockTask());
		_delay_ms(55);
		leaveCritical();
		//
	}*/
	
	//not full, add an item
	//(q->q + (sizeof(int) * q->head)) = item;
	q->q[q->head] = (int) item;
	q->head = (q->head + 1) % q->size;
	q->count++;
	leaveCritical();
	//post sema
	//OSSemPost(&(q->mutex));
	//OSSemPost(&(q->full));
}

// Removes and returns item from head of queue. Process blocks if queue is empty.
void *OSdeq(OSSignal *q)
{
	
	//block if empty
	//OSSemPend(&(q->full));
	//OSSemPend(&(q->mutex));
	
	/*	while(q->count == 0)
	{
		 //block
	}*/
	
	//if block condition
	//enq blocked task to another queue to keep track of blocked task
	//OSSwapTask();
	while(1)
	 {
		 enterCritical();
		 if (q->count > 0)
		 {
			 break;
		 }
		 leaveCritical();
		 //SWAP;
	 }
	
	//enterCritical();
	/*if (q->count == 0)
	{
		OSenq(queueblockedtask, (void*) OSBlockTask());
		_delay_ms(55);
		leaveCritical();
		//_delay_ms(55);
	}*/
	
	//dequeue
	int ret = q->q[q->tail]; //*(q->q + sizeof(int) * q->tail);
	q->tail = (q->tail+1)%q->size;
	q->count--;
	

	leaveCritical();
	
	//OSSemPost(&(q->mutex));
	//OSSemPost(&(q->empty));
	
	return (void*)ret; //not sure...
}

// Destroys the queue
void *OSdestroyQ(OSSignal *queue)
{
	if(queue)
	{
		if(queue->q)
		{
			free(queue->q);
		}
		
		free(queue);
	}
}

void OScreateQblockedTask()
{
	queueblockedtask = OSmakeQ(100, sizeof(int));
}

#endif