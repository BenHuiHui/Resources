/*
 * Assg2.c
 *
 * Created: 20/10/2011 1:30:57 PM
 *  Author: dcstanc
 */ 
#define F_CPU	16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include "coord.h"
#include "serial.h"
#include "kernel.h"

#define NULL (void*) 0

// Tasks 1 and 2 will increment a global variable ctr, and every 10 increments task 1 will send the resulting value in ctr to task3 via a queue.
// Task 3 will then send it via serial to the PC. 

volatile int ctr;
OSSignal *queue;
OSSignal *sema1;
//OSSignal *sema2;
char buffer[20];

// In addition, do something fun and creative with this program, the serial port and the components you have. Describe it in your report. :)
void task1(void *p)
{

	while(1)
	{		
		//DET0;
		//say("task1 ");
		//ENT0;
		
		OSSemPend(sema1);
		if(ctr%10 == 0 && ctr != 0)
		{
			OSenq(queue, (void*)ctr);
			//for(int i=0; i<10; i++)
			//{
				////OSSemPost(sema2);
			//}			
		}

		//OSSemPend(sema2);
		ctr++;
		OSSemPost(sema1);
		
		//_delay_ms(20);
		
		//OSSwapTask();
	}
}

void task2(void *p)
{
	while(1)
	{
		//OSSemPend(sema2);
		OSSemPend(sema1);
		
		if(ctr % 10 == 0 && ctr != 0)
		{
			
		}	
		else
		{
			ctr++;
		}
		

		//DET0;
		//sprintf(buffer, "task2: %d\r\n", ctr);
		//say(buffer);
		//ENT0;
		
		OSSemPost(sema1);
		
		//_delay_ms(20);
		
		//OSSwapTask();
	}
}

void task3(void *p)
{
	int ctr_val;
	while(1)
	{
		
		ctr_val = (int) OSdeq(queue);
		
		//send it via serial to the PC
		cli();
		sprintf(buffer, "%d\r\n", ctr_val);
		say(buffer);
		
		sei();
		_delay_ms(15);
		
		//OSSwapTask();
	}
}


void setup()
{
	setupSerial();
	//OScreateQblockedTask();
	queue = OSmakeQ(20, sizeof(int));
	sema1 = OSmakeSema(1);
	//sema2 = OSmakeSema(10);
	//count = 0;
	ctr = 0;
}

int main(void)
{
	setup();
	OSInit();
	OSAddTask(task1, 0, NULL);
	OSAddTask(task2, 1, NULL);
	OSAddTask(task3, 2, NULL);
	say("startOS");
	OSRun();
	
}