/*
 * kernel.c
 *
 * Created: 6/7/2011 12:57:25 PM
 *  Author: dcstanc
 */ 


#define F_CPU	16000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "kernel.h"
#include "serial.h"

int currentTask		= -1;

// TODO: delete later
char buf[20];

// Task Control Block (TCB), which contains information on all the tasks.
TTaskBlock taskTable[OS_NUM_TASKS];


unsigned long pxCurrentTCB;
unsigned long t_stack;
char saykBuf[QLEN];


// defined by syy
int task_counter	= 0;
//int calledByOS		= 0;



// Macros to save and restore context. DO NOT CHANGE THESE!
#define portSAVE_CONTEXT()\
asm volatile (\
	"push r0	\n\t"\
	"in r0, __SREG__	\n\t"\
	"push r0	\n\t"\
	"push r1	\n\t"\
	"clr r1	\n\t"\
	"push r2	\n\t"\
	"push r3	\n\t"\
	"push r4	\n\t"\
	"push r5	\n\t"\
	"push r6	\n\t"\
	"push r7	\n\t"\
	"push r8	\n\t"\
	"push r9	\n\t"\
	"push r10	\n\t"\
	"push r11	\n\t"\
	"push r12	\n\t"\
	"push r13	\n\t"\
	"push r14	\n\t"\
	"push r15	\n\t"\
	"push r16	\n\t"\
	"push r17	\n\t"\
	"push r18	\n\t"\
	"push r19	\n\t"\
	"push r20	\n\t"\
	"push r21	\n\t"\
	"push r22	\n\t"\
	"push r23	\n\t"\
	"push r24	\n\t"\
	"push r25	\n\t"\
	"push r26	\n\t"\
	"push r27	\n\t"\
	"push r28	\n\t"\
	"push r29	\n\t"\
	"push r30	\n\t"\
	"push r31	\n\t"\
	"in r26, __SP_L__	\n\t"\
	"in r27, __SP_H__	\n\t"\
	"sts pxCurrentTCB+1, r27	\n\t"\
	"sts pxCurrentTCB, r26	\n\t": : :\
);

#define portRESTORE_CONTEXT()\
asm volatile (\
	"out __SP_L__, %A0	\n\t"\
	"out __SP_H__, %B0	\n\t"\
	"pop r31	\n\t"\
	"pop r30	\n\t"\
	"pop r29	\n\t"\
	"pop r28	\n\t"\
	"pop r27	\n\t"\
	"pop r26	\n\t"\
	"pop r25	\n\t"\
	"pop r24	\n\t"\
	"pop r23	\n\t"\
	"pop r22	\n\t"\
	"pop r21	\n\t"\
	"pop r20	\n\t"\
	"pop r19	\n\t"\
	"pop r18	\n\t"\
	"pop r17	\n\t"\
	"pop r16	\n\t"\
	"pop r15	\n\t"\
	"pop r14	\n\t"\
	"pop r13	\n\t"\
	"pop r12	\n\t"\
	"pop r11	\n\t"\
	"pop r10	\n\t"\
	"pop r9	\n\t"\
	"pop r8	\n\t"\
	"pop r7	\n\t"\
	"pop r6	\n\t"\
	"pop r5	\n\t"\
	"pop r4	\n\t"\
	"pop r3	\n\t"\
	"pop r2	\n\t"\
	"pop r1	\n\t"\
	"pop r0	\n\t"\
	"out __SREG__, r0\n\t"\
	"pop r0	\n\t": : "r" (pxCurrentTCB):\
	);

void runTaskFirstTime(int i){
	cli();
	currentTask = i;
	taskTable[currentTask].runflag = 1;
    
	pxCurrentTCB = (unsigned long)(taskTable[currentTask].stack + TASK_STACK_SIZE - 1);
	
    asm volatile ("\n\t"\
                  "lds r26, pxCurrentTCB \n\t"\
                  "lds r27, pxCurrentTCB+1 \n\t"\
                  "out __SP_L__, r26 \n\t"\
                  "out __SP_H__, r27 \n\t"\
                  );
	sei();
    taskTable[currentTask].fptr(taskTable[currentTask].arg);
}



void OSMakeAtomic()
{
	// Disables interrupts to create an atomic section.
	cli();
	//TIMSK0 &= 0b11111101;
}

void OSLeaveAtomic()
{
	// Leaves atomic section by re-enabling interrupts.
	sei();
	//TIMSK0 |= 0b10;
}

// DO NOT modify this!
void OSSwapTask() __attribute__ ((naked));

int findNextTask()
{
	int i;
	// Apply scheduling algorithm to find next task to run, and returns the index number of that task.
	// Note that OS_NUM_TASKS in kernel.h is the MAXIMUM number of tasks that can be created, not the actual number
	// created. So OS_NUM_TASKS can be 10 although in actual fact only 4 tasks were created. You should pick only amongst
	// these 4 tasks.
	//say("finding task\n\r");
	for(i = currentTask + 1; i< task_counter; i++){
		if(taskTable[i].runflag == TASK_BLOCKED)	continue;
		else	return i;
	}
	
	for(i=0; i< currentTask; i++){
		if(taskTable[i].runflag == TASK_BLOCKED)	continue;
		else	return i;
	}
	
	return -1;	// unsuccessful
}


void OSSwapTask()
 {
	// assumption: when this method is being called, there's always a running task; otherwise it would do nothing
	if(currentTask < 0)	return;
	
	// Call findNextTask to decide which task to run next.
	int taskNum = findNextTask();
	
	sprintf(buf,"n#:%d \n\r",taskNum);
	say(buf);
	
	if(taskNum < 0){
		//say("minus\n\r");
		return;	// no task to swap
	}		
	cli();
	// Save the context of the current task, and copy the task stack pointer to the task's entry in the Task Control Block (tcb).
	portSAVE_CONTEXT();
	
	// save the current stack pointer
	taskTable[currentTask].stack_ptr = pxCurrentTCB;
	
	// update the "currentTask" to be the next task to run
	currentTask = taskNum;
	
	TTaskBlock *t = &taskTable[currentTask];
	sei();
	
	if(t->runflag){	// has been run
		// get the stack pointer saved
		cli();
		pxCurrentTCB = taskTable[currentTask].stack_ptr;
		portRESTORE_CONTEXT();
		sei();
	}else{	// never run -> then run
		runTaskFirstTime(currentTask);
	}
	
	// Do not modify the line below!	
	asm("ret");
}

// ISR for the timer. IMPLEMENT ONLY IN PART 2!


ISR(TIMER0_COMPA_vect, ISR_NAKED)
{
	cli();
	
	OSSwapTask();
	
	// Do not change this!
	asm("reti");
	sei();
}


void OSInit()
{ 
	// Initialize all OS state variables, hardware used DIRECTLY by the OS, etc etc. Do not initialize variables or hardware
	// used by the application. Only those used by the OS.
	int i;
	
	// initialize timer 0
	TCNT0 = 0; OCR0A = 100;
	TCCR0A = 0b00000010;
	TCCR0B = 0b00000101;
}

// First argument is a pointer to the task's function code, the second is a priority number (0=highest priority)
// and the 3rd argument is an argument that will be passed to the task function the first time it is run.
// E.g. OSAddTask(task1, 0, (void *) 5) causes a task called task1 to be created with priority 0, and the integer
// 5 is passed to task1 when it is first called. See app.c to fully understand how OSAddTask is used.
int OSAddTask(void (*taskptr)(void *), int prio, void* arg)
{
	// Adds a new entry to the TCB. Returns a -1 if # of tasks > OS_NUM_TASKS. Note that OS_NUM_TASKS is the MAXIMUM
	// number of tasks that can be created, not the actual number.
	if(task_counter >= OS_NUM_TASKS)	return -1;
	TTaskBlock *t = &taskTable[task_counter++];
	t->fptr = taskptr;
	t->prio = prio;
	t->arg = arg;
	t->runflag = 0;
	
	return 0;
}

void OSRun()
{
	// start timer 0
	TIMSK0 |= 0b10;
	// enable global interrupt
	sei();
	
	// Starts by executing the first task
	currentTask = 0;
	runTaskFirstTime(currentTask);
}
