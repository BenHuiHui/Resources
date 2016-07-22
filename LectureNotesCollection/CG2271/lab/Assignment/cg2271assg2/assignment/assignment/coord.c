/*
 * coord.c
 *
 * Created: 21/10/2011 8:36:30 AM
 *  Author: dcstanc
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "coord.h"
#include "kernel.h"

extern int currentTask;
extern TTaskBlock taskTable[];

OSSignal* q_sema;

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
	OSSignal *sem = (OSSignal *) malloc(sizeof(OSSignal));
	sem->type	= SEMAPHORE_TYPE;
	sem->num	= initval;
	sem->qH		= 0;
	sem->size	= 0;
}

// Takes a semaphore. Blocks if semaphore is 0.
void OSSemPend(OSSignal *sema)
{
	
}

// Posts a semaphore.
void OSSemPost(OSSignal *sema)
{
	
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
	// when cannot hold such a huge queue
	if(qsize * esize > MAX_QUEUE_SIZE)	return 0;
	
	OSSignal *res = (OSSignal *) malloc(sizeof(OSSignal));
	res->type	= QUEUE_TYPE;
	res->num	= esize;
	res->qH		= 0;
	res->size	= 0;
}

// Inserts item into queue q
void OSenq(OSSignal *q, void *item)
{
	int i, currentPos;
	while(q->size >= MAX_QUEUE_SIZE/q->num - 1){
		// block
		taskTable[currentTask].runflag = TASK_BLOCKED;
		OSSwapTask();
	}
	
	cli();
	
	for(i = 0, currentPos = q->qH + q->num * q->size ;i < q->num;i += sizeof(char),currentPos+= sizeof(char)){
		if(currentPos == MAX_QUEUE_SIZE)	currentPos = 0;
		q->q[currentPos] = *(char *)(item + i);
	}
	
	q->size++;
	sei();
}

// Removes and returns item from head of queue. Process blocks if queue is empty.
void *OSdeq(OSSignal *q)
{
	int i;
	int iniqH = q->qH;
	
	// when the queue is empty
	while(q->size == 0){
		
		taskTable[currentTask].runflag = TASK_BLOCKED;
		OSSwapTask();
	}
	
	cli();
	q->qH += q->num * sizeof(char);
	q->qH %= MAX_QUEUE_SIZE;
	
	return (void *) &(q->q[iniqH]);
}

// Destroys the queue
void *OSdestroyQ(OSSignal *q)
{
	free(q);
}


#endif