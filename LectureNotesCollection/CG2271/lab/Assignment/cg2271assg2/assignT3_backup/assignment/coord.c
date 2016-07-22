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

#define  NULL ((void*) 0)

extern int currentTask;
extern TTaskBlock taskTable[];
extern int task_counter;

OSSignal* q_sema_full;
OSSignal* q_sema_empty;

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
	if(!sem){	// when the space allocation is not successful
		PORTD |= 0b00010000;	// signal error
		return NULL;
	}
	
	sem->type	= SEMAPHORE_TYPE;
	sem->num	= initval;	// the (-num) is qsize; when num >= 0, qsize = 0
	sem->esize	= sizeof(int);	// store the task id
	sem->size	= OS_NUM_TASKS;	// the maximum is the number of tasks system has
	sem->start	= calloc(sem->size,sem->esize);
	
	if(!(sem->start)){	// when the space allocation is not successful
		free(sem);
		PORTD |= 0b00010000;	// signal error
		return NULL;
	}
	
	sem->head	= sem->start;
	
	return sem;
}

// Takes a semaphore. Blocks if semaphore is 0.
void OSSemPend(OSSignal *sema)
{
	enterCritical();
	
	// wrong type no use
	if(sema == NULL || sema->type != SEMAPHORE_TYPE){
		leaveCritical();
		return;
	}
	
	if(sema->num <= 0){
		// the queue used in the semaphore would be always less than the maximum
		// but check to avoid overflow
		if(-(sema->num) >= sema->size){
			PORTD |= 0b00010000;	// signal error
			leaveCritical();
			return;
		} else if(currentTask == -1){	// when possibly os not run
			PORTD |= 0b00010000;	// signal error
			leaveCritical();
			return;
		}
		
		// set current task to block state, save the # of current task
		
		
		//while(sema->num);
		taskTable[currentTask].sem_counter  = 1;	// signal this to be blocked
		leaveCritical();
		while(taskTable[currentTask].sem_counter);	// buzy waiting
		
		/*
		// current blocked by this semaphore
		taskTable[currentTask].sem_counter++;
		
		unsigned shift = 
			(unsigned)(sema->head - sema->start + (-sema->num * sema->esize)) %
			(unsigned)(sema->size * sema->esize);
		void *currentPos = sema->start + shift;
		
		// then push the currentTask id into queue
		*(int*)(currentPos) = currentTask;
		
		sema->num--;

		OSSwapTask();*/
	} else (sema->num)--;
	
	leaveCritical();
}

// Posts a semaphore.
void OSSemPost(OSSignal *sema)
{
	enterCritical();
	
	// wrong type no use
	if(sema == NULL || sema->type != SEMAPHORE_TYPE){
		leaveCritical();
		return;
	}
	
	if(sema->num < 0){	// only when queue has element
		if(currentTask == -1){	// when possibly os not run
			//PORTD |= 0b00010000;	// signal error	TODO
			leaveCritical();
			return;
		}
		
		// release one semaphore
		int i,max,index;
		for(i = 0,max = -1, index = -1;i<task_counter;i++){
			if(taskTable[i].sem_counter && taskTable[i].skipedTimes > max){
				index = i;
			}
		}
		
		// release this i
		taskTable[index].sem_counter = 0;
		sema->num++;
		
		/*
		// pop the element from the head
		int taskId = *(int*)sema->head;
		
		// decrease the counter because of current semaphore
		taskTable[taskId].sem_counter--;
		
		// then update the queue
		sema->num++;
		
		sema->head += sema->esize;
		if(sema->head == sema->start + (-sema->num * sema->esize) ){
			sema->head = sema->start;
		}
		*/
		OSSwapTask();
	} else{
		// set an upper limit to avoid overflow
		if(sema->num <= 10000)	(sema->num)++;
	}
	
	leaveCritical();
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
	// use the q_sema
	if(q_sema_empty == NULL)	q_sema_empty = (OSSignal*)OSmakeSema(0);
	if(q_sema_full == NULL)		q_sema_full  = (OSSignal*)OSmakeSema(0);
	if(q_sema_empty == NULL	||	q_sema_full == NULL){	// semaphore creation failed
		PORTD |= 0b00010000;
		return NULL;
	}
	
	OSSignal *que = (OSSignal *) malloc(sizeof(OSSignal));
	if(!que){	// when the space allocation is not successful
		PORTD |= 0b00010000;	// signal error
		return NULL;
	}
	
	que->type	= QUEUE_TYPE;
	que->num	= 0;	// initially empty
	que->esize	= esize;	// store the task id
	que->size	= qsize;	// the maximum is the number of tasks system has
	que->start	= calloc(que->size,que->esize);
	
	if(!(que->start)){	// when the space allocation is not successful
		free(que);
		PORTD |= 0b00010000;	// signal error
		return NULL;
	}
	
	que->head	= que->start;
	
	return que;
}

// Inserts item into queue q
void OSenq(OSSignal *q, void *item)
{
	enterCritical();
	
	// wrong type no use
	if(q == NULL || q->type != QUEUE_TYPE){
		leaveCritical();
		return;
	}
	
	while(q->num == q->size){	// queue full
		//leaveCritical();	// can let others to run here
		OSSemPend(q_sema_full);
		enterCritical();	// but after the pend, would go back to run
	}
	
	unsigned shift = 
		(unsigned)(q->head - q->start + (q->num * q->esize)) %
		(unsigned)(q->size * q->esize);
	void *currentPos = q->start + shift;
	
	// then copy the element into queue
	for(int i=0;i< q->esize; i++){
		*(char*)(currentPos + i) = *(char*)(item + i);
	}
		
	q->num++;
	
	// produced one
	OSSemPost(q_sema_empty);
	
	leaveCritical();
}

// Removes and returns item from head of queue. Process blocks if queue is empty.
void *OSdeq(OSSignal *q)
{
	enterCritical();
	
	// wrong type no use
	if(q == NULL || q->type != QUEUE_TYPE){
		leaveCritical();
		return;
	}
	
	while(q->num <= 0){	// queue empty
		leaveCritical();	// can let others to run here
		OSSemPend(q_sema_empty);
		enterCritical();	// but after the pend, would go back to run
	}

	void* res = q->head;
	
	q->head += q->esize;
	if(q->head == q->start + (q->num * q->esize) ){
		q->head = q->start;
	}
	
	q->num--;
	
	// consumed one
	OSSemPost(q_sema_full);
	
	leaveCritical();
	return res;
}

// Destroys the queue
void *OSdestroyQ(OSSignal *q)
{
	enterCritical();
	if(q != NULL){
		if(q->start != NULL)	free(q->start);
		free(q);
	}
	leaveCritical();
}


#endif