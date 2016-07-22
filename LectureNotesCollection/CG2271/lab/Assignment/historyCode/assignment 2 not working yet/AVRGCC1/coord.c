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

// TODO: delete later
char buf[20];

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
	sem->qT	= 0;
}

// Takes a semaphore. Blocks if semaphore is 0.
void OSSemPend(OSSignal *sema)
{
	cli();
		
	// wrong type no use
	if(sema->type != SEMAPHORE_TYPE){
		sei();
		return;
	}
	else if(sema->num <= 0){
		// when the number of semaphore exceed the max allowed element in queue -> do nothing
		if(-(sema->num) > MAX_QUEUE_SIZE/sizeof(int)){
			sei();
			return;
		}	
		if(currentTask == -1){
			sei();
			return;
		}
		
		
		// set current task to block state, save the # of current task
		
		// set current task to block state
		taskTable[currentTask].runflag = TASK_BLOCKED;
		
		/*
		sprintf(buf,"t_id: %d XO\n\r",currentTask);
		say(buf);
		
		// then push the currentTask into queue
		*(int*)&(sema->q[sema->qT]) = currentTask;
		
		sema->qT += sizeof(int);
		if(sema->qT == MAX_QUEUE_SIZE)	sema->qT = 0;*/
		
		OSSwapTask();
	} else	sema->num --;
}

// Posts a semaphore.
void OSSemPost(OSSignal *sema)
{
	if(sema->type != SEMAPHORE_TYPE)	return;
	else if(sema->num <0){
		// pop the task from the top of the queue
		int taskToWake = *(int *)&(sema->q[sema->qH]);
		sema->qH += sizeof(int);
		if(sema->qH == MAX_QUEUE_SIZE)	sema->qH = 0;
		
		taskTable[taskToWake].runflag = TASK_PREEMPTED;
	} else	sema->num ++;
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
	if(qsize > MAX_QUEUE_SIZE)	return 0;
	
	OSSignal *sem = (OSSignal *) malloc(sizeof(OSSignal));
	sem->type	= QUEUE_TYPE;
	sem->num	= esize;
	sem->qH		= 0;
	sem->qT		= 0;
}

// Inserts item into queue q
void OSenq(OSSignal *q, void *item)
{
	int i;
	for(i = 0;i < q->num;i += sizeof(char)){
		q->q[q->qT] = *(char *)(item + i);
		q->qT += sizeof(char);
		if(q->qT == MAX_QUEUE_SIZE)	q->qT = 0;
		
		// when the queue got overflow
		else if(q->qT == q->qH)	return;
	}
}

// Removes and returns item from head of queue. Process blocks if queue is empty.
void *OSdeq(OSSignal *q)
{
	int i;
	int iniqH = q->qH;
	q->qH += q->num * sizeof(char);
	
	// error: the qH encountered the qT
	if((iniqH - q->qT) * (q->qH - q->qT) <= 0)	return 0;
	
	
	return (void *) &(q->q[iniqH]);
}

// Destroys the queue
void *OSdestroyQ(OSSignal *q)
{
	free(q);
}


#endif