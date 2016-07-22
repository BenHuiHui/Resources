/*
 * coord.c
 *
 * Created: 21/10/2011 8:36:30 AM
 *  Author: dcstanc
 */ 

#include <avr/io.h>

/* ======================================= */
/* Critical section management             */
/* ======================================= */
inline void enterCritical()
{
	
}

inline void leaveCritical()
{
	
}

/* ======================================= */
/* Semaphore routines                      */
/* ======================================= */

#ifdef OSIncludeSema

// Creates a semaphore with initial value initval
OSSignal *OSmakeSema(int initval)
{
	
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
	
}

// Inserts item into queue q
void OSenq(OSSignal *q, void *item)
{
	
}

// Removes and returns item from head of queue. Process blocks if queue is empty.
void *OSdeq(OSSignal *q)
{
	
}

// Destroys the queue
void *OSdestroyQ(OSSignal *q)
{
	
}


#endif