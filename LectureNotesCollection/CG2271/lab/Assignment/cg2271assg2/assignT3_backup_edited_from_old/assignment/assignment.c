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

#define MAXINT 30005

#define  NULL ((void*) 0)

char sayBuf[QLEN];

OSSignal* queue;


int variable = 0;

// Tasks 1 and 2 will increment a global variable ctr, and every 10 increments task 1 will send the resulting value in ctr to task3 via a queue.
// Task 3 will then send it via serial to the PC. 

// In addition, do something fun and creative with this program, the serial port and the components you have. Describe it in your report. :)
void task1(void *p)
{
	while(1)
	{
		enterCritical();
		variable++;
		if(variable % 10 == 0){
			//PORTD ^= 0b10000000;
			OSenq(queue,&variable);
		} else if(variable == MAXINT){
			variable = 0;
		}
		
		leaveCritical();
	}
}

void task2(void *p)
{
	while(1)
	{
		enterCritical();
		variable++;
		if(variable % 10 == 0){
			//PORTD ^= 0b01000000;
			OSenq(queue,&variable);
		} else if(variable == MAXINT){	// avoid overflow
			variable = 0;
		}
		
		leaveCritical();
	}
}

void task3(void *p)
{
	void *addr;
	int res,i;
	while(1)
	{
		if(queue->size > 0){
			enterCritical();
			addr = OSdeq(queue);
			res = *(int*)addr;
			
			sprintf(sayBuf,"r:%d \n\r",res);
			say(sayBuf);
			_delay_ms(20);
			leaveCritical();
			//PORTD ^= 0b00100000;
		}
	}
}

void setup()
{
	// create a global queue
	queue = (OSSignal*)OSmakeQ(MAX_QUEUE_SIZE,sizeof(int));
	
	// for testing only
	DDRD |= 0b11111100;
	
	
	// signal OS running correctly
	//PORTD |= 0b00001000;
	
	variable = 0;
}




int main()
{
	setupSerial();
	
	cli();
	
	OSInit();
	
	setup();
	
	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	
	OSAddTask(task1, 0, NULL);
	
	OSAddTask(task2, 1, NULL);
	
	OSAddTask(task3, 1, NULL);
	
	// start the OS
	OSRun();
	
	while(1);
}