/*
 * lab 4.c
 *
 * Created: 6/7/2011 12:57:25 PM
 *  Author: dcstanc
 */ 

#define F_CPU	16000000
#include <util/delay.h>
#include <avr/io.h>
#include "kernel.h"

#define NULL (void *) 0


// Base frequency for the buzzer
#define BASE_FREQ	200

// TODO: Possibly I want to change here later
unsigned pwm_val = 240;
unsigned tune_adc_val = 0;


void task1(void *p)
{
	// Operates the buzzer
	// The base frequency is passed in through p.
	int base=(int) p;
	
	// Implement Task 1 logic below
	
	int delayTime = 1000/base/2;
	
	while(1)
	{
		/*
		// Write a 1 to digital pin 13
		PORTB |= 0b00100000;
		// base delay
		_delay_ms(delayTime);
	
		// Write a 0 to digital pin 13
		PORTB &= 0b11011111;
		// base delay to generate the low part of the wave form
		_delay_ms(delayTime);
		
		// Implement Task 1 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
		*/
	}		
}

void task2(void *p)
{
	while(1)
	{
		/*
		// Implement Task 2 logic below
		int top = 255;
		if(val > max_val){
			return top;
		} else if(val < min_val){
			return 0;
		} else{
			return (int)top * ((float)(val-min_val))/(max_val - min_val);
		}
		// Implement Task 2 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
		*/
	}
}

void task3(void *p)
{
	while(1)
	{
		
		// Implement Task 3 logic below
		
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
		
		// Implement Task 4 logic above
		
		// Hand over control to the OS.
		OSSwapTask();
	}
	
}

// Declare all other ISRs, etc below this line.

void setup()
{

}
int main()
{
	setup();
	
	OSInit();

	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	OSAddTask(task1, 0, (void *) BASE_FREQ);
	OSAddTask(task2, 1, NULL);
	OSAddTask(task3, 2, NULL);
	
	// Insert code to create task4 below.
	
	// And start the OS!
	OSRun();
}
