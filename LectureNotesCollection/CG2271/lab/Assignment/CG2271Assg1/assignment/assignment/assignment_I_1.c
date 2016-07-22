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
#define DELAY_TIME 100

#define NULL (void *) 0


// Base frequency for the buzzer
#define BASE_FREQ	200


void lightUpPDFor1Sec(int i){
	PORTD |= (1<<i);
	_delay_ms(DELAY_TIME);
	PORTD &= ((0b11111111)^(1<<i));
}

void task1(void *p)
{
	// Operates the buzzer
	// The base frequency is passed in through p.
	int base=(int) p;
	
	while(1)
	{

		// Implement Task 1 logic below
		lightUpPDFor1Sec(7);
		_delay_ms(DELAY_TIME);
		
		// Implement Task 1 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
	}
}

void task2(void *p)
{
	while(1)
	{
		// Implement Task 2 logic below
		lightUpPDFor1Sec(6);
		_delay_ms(DELAY_TIME);
		// Implement Task 2 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
	}		
}

void task3(void *p)
{
	while(1)
	{
		// Implement Task 3 logic below
		lightUpPDFor1Sec(5);
		_delay_ms(DELAY_TIME);
		// Implement Task 3 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
	}
}

void task4(void *ptr)
{
	while(1)
	{
		// Implement Task 4 logic below
		lightUpPDFor1Sec(4);
		// Implement Task 4 logic above
		_delay_ms(DELAY_TIME);
		// Hand over control to the OS.
		OSSwapTask();
	}		
	
}

// Declare all other ISRs, etc below this line.

// Declare all other ISRs, etc above this line.

void setup()
{
	// Set up the hardware except those used directly by the OS (e.g. Timer 0).
	DDRD = 0b11111111;
}



int main()
{
	int i;
	
	/*
	// init
	DDRD = 0b11111111;
	PORTD = 0b00000000;
	TCNT0 = 0;
	OCR0A = 100;
	TCCR0A = 0b00000010;
	TCCR0B = 0b00000011;
	TIMSK0 |= 0b10;
	
	// start timer 0
	
	sei();*/
	
	//OSInit();
	setup();
	
	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	OSAddTask(task1, 0, (void *) BASE_FREQ);
	OSAddTask(task2, 1, NULL);
	OSAddTask(task3, 2, NULL);
	OSAddTask(task4, 2, NULL);
	
	
	// Insert code to create task4 below.
	
	// And start the OS!
	OSRun();
	
	while(1);
}
