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

OSSignal * sema;

// Tasks 1 and 2 will increment a global variable ctr, and every 10 increments task 1 will send the resulting value in ctr to task3 via a queue.
// Task 3 will then send it via serial to the PC. 

// In addition, do something fun and creative with this program, the serial port and the components you have. Describe it in your report. :)
void task1(void *p)
{
	while(1)
	{
		say("1\n\r");
		//_delay_ms(1000);
		//OSSemPend(sema);
	}
}

void task2(void *p)
{
	while(1)
	{
		say("2\n\r");
		//_delay_ms(500);
		//OSSemPend(sema);
	}
}

void task3(void *p)
{
	while(1)
	{
		say("3\n\r");
		_delay_ms(5000);
	}
}

void setup()
{
	DDRB |= 0b11111111;
}

int main(void)
{
	setupSerial();
	sei();
	OSInit();
	
	say("B!egin\r\n");
	
	setup();
	
	//while(1)	say("lualal\n\r");
	
	//sema = OSmakeSema(1);
	
	OSAddTask(task1,1,0);
	OSAddTask(task2,1,0);
	OSAddTask(task3,1,0);
	
	OSRun();
}
