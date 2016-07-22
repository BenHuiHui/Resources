/*
 * kernel.h
 *
 * Created: 10/9/2011 12:51:20 PM
 *  Author: dcstanc
 */ 


#ifndef KERNEL_H_
#define KERNEL_H_

// ------------- Customize Below ----------------- //
#define OS_NUM_TASKS 4
#define TASK_STACK_SIZE 255

// OS Scheduler Type
// -1 - Not set
// 0 - Fixed
// 1 - RMS
// 2 - EDF

#define OS_SCHED_TYPE   -1
// ------------- Customize Above ----------------- //

void OSSwapTask();
void OSInit();
int OSAddTask(void (*taskptr)(void *), int prio, void* arg);
void OSRun();
void OSMakeAtomic();
void OSLeaveAtomic();


// Task Control Block
typedef struct ttcb
{
	int runflag; // Shows whether task has been run before or not. 0 = first time this task is being run, 
				// 1 = task has been run before and was pre-empted/surrendered control.
				 
	int prio; // Task Priority.
	void (*fptr)(void *); // Pointer to the task
	void *arg; // Argument to fptr
	long stack_ptr; // Stack pointer
	char stack[TASK_STACK_SIZE];
} TTaskBlock;


// task status
#define TASK_NEVER_RUN	0
#define TASK_PREEMPTED	1
#define TASK_BLOCKED	2


#endif /* KERNEL_H_ */