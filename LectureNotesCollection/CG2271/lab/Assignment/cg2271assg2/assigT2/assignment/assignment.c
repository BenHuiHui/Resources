/*
 * lab 4.c
 *
 * Created: 6/7/2011 12:57:25 PM
 *  Author: dcstanc
 */ 

#define F_CPU	16000000
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "kernel.h"
#include "serial.h"
#include "coord.h"

#define DELAY_TIME 100


#define NULL (void *) 0

char saykBuf[LQLEN];

OSSignal* queue;
OSSignal* sema;

int variable = 0;

// Tasks 1 and 2 will increment a global variable ctr, and every 10 increments task 1 will send the resulting value in ctr to task3 via a queue.
// Task 3 will then send it via serial to the PC. 

// In addition, do something fun and creative with this program, the serial port and the components you have. Describe it in your report. :)
void task1(void *p)
{
	int count = 0;
	
	// test if it's running correctly
	//PORTD ^= 0b00100000;
	//while(1);
	
	while(1)
	{
		/*
		if(currentTask < -1 || currentTask>OS_NUM_TASKS){
		PORTD ^= 0b00100000;	// signal of task overflow
		//return;	// no task to swap
		}
		
		enterCritical();
		count++;
		variable++;
		if(count == 10){
			//OSenq(queue,&variable);
			//PORTD ^= 0b01000000;
		}
		leaveCritical();
		//say("0\r\n");
		//_delay_ms(100);
		*/
		// test if it's running correctly
		count ++;
		if(count % 10000 == 0)	PORTD ^= 0b00100000;
	}
}

void task2(void *p)
{
	int count = 0;
	while(1)
	{
		/*
		enterCritical();
		count++;
		variable++;
		
		if(count == 10){
			//OSenq(queue,&variable);
			count = 0;
		}
		leaveCritical();*/
		PORTD ^= 0b00000100;
	}
}

void task3(void *p)
{
	while(1)
	{
		if(queue->num != 0){
			enterCritical();
			//int res = *(int *)OSdeq(queue);
			//sprintf(saykBuf,"abx\n\r",res);
			_delay_ms(1000);
			say("lualla\n\r");
			leaveCritical();
		}
	}
}

void setup()
{
	// create a global queue
	sema = (OSSignal*)OSmakeSema(1);
	queue = (OSSignal*)OSmakeQ(MAX_QUEUE_SIZE,sizeof(char));
	
	// for testing only
	DDRD |= 0b11111100;
}


int main()
{
	//DDRD = 0b111111111;
	setupSerial();
	sei();
	
	say("hEllo ^_^!\n\r");
	_delay_ms(500);
	
	OSInit();
	
	setup();
	
	// test if the system restarts
	PORTD |= 0b10000000;
	
	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	
	OSAddTask(task1, 0, NULL);	
	OSAddTask(task2, 0, NULL);
	
	_delay_ms(1000);
	
	//OSAddTask(task2, 1, NULL);	// read for LED
	
	//OSAddTask(task3, 2, NULL);	// convert for buzzer
	
	// And start the OS
	OSRun();
	
	
	
	while(1);
}