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
#define DELAY_TIME 100


#define NULL (void *) 0

char saykBuf[LQLEN];

// Base frequency for the buzzer
int buzzer_freq = 1;
int pwm_val = 100;

void lightUpPDFor1Sec(int i){
	PORTD |= (1<<i);
	_delay_ms(DELAY_TIME);
	PORTD &= ((0b11111111)^(1<<i));
}

void task1(void *p)
{
	// Operates the buzzer
	// The base frequency is passed in through p.
	int i,delayTime;
	int remainTimes = 2;
	buzzer_freq =(int) p;
	
	// set up the port for task 1
	DDRB |= 0b00100000;

	while(1){
		delayTime = 1000/buzzer_freq;
		PORTD ^= 0b10000000;
		OSMakeAtomic();
		for(i=0; i<remainTimes; i++){
			// Write a 1 to digital pin 13
			PORTB |= 0b00100000;
			// base delay
			_delay_ms(delayTime);
			// Write a 0 to digital pin 13
			PORTB &= 0b11011111;
			// base delay to generate the low part of the wave form
			_delay_ms(delayTime);
		}
		OSLeaveAtomic();
	}
}

void task2(void *p)
{
	int val;
	
	while(1)
	{
		// Implement Task 2 logic below
		OSMakeAtomic();
		
		PORTD ^= 0b01000000;
		
		// set the channel to be 0
		//ADMUX &= 0b11111000;
		
		// temp use chanel 1 for testing
		ADMUX &= 0b11111000;
		ADMUX |= 1;
		
		// enable ADC
		ADCSRA |= 0b01000000;
		
		// wait for it to finish
		while(ADCSRA & 0x01000000);
		
		// clean ADC
		ADCSRA |= 0b00010000;
		
		// save value
		val = ADCL + 255*ADCH;
		
		// remap
		buzzer_freq = (val >> 2);
		
		OSLeaveAtomic();
		// Implement Task 2 logic above
		
		// Hand over control to the OS.
		//OSSwapTask();
	}		
}

void task3(void *p)
{
	int val;
	int min = 620;
	int max = 890;
	
	while(1)
	{
		// Implement Task 3 logic below
		OSMakeAtomic();
		PORTD ^= 0b01000000;
		// set the channel to be 1
		ADMUX &= 0b11111000;
		ADMUX |= 0b1;
		
		// enable ADC
		ADCSRA |= 0b01000000;
		
		// wait for it to finish
		while(ADCSRA & 0x01000000);
		
		// save value
		val = ADCL + 255*ADCH;
		
		if(val <= 255)	PORTD = 0b00100000;
		else PORTD = 0b00010000;
		
		// clean ADC
		ADCSRA |= 0b00010000;
		
		// remap
		pwm_val = (val >> 2);
		
		OSLeaveAtomic();
		// Implement Task 3 logic above
		
		// Hand over control to the OS.
		// OSSwapTask();
	}
}

void task4(void *ptr)
{
	// initialite the LED
	DDRB |= 0b00001000;
	
	while(1)
	{
		// Implement Task 4 logic below
		OSMakeAtomic();
		OCR2A = pwm_val;
		PORTD ^= 0b10000000;
		// Implement Task 4 logic above
		OSLeaveAtomic();
		//OSSwapTask();
	}
}

// Declare all other ISRs, etc below this line.

// I think we're not supposed to use any ISR here?
//  otherwise the OS's swap task got no use

// Declare all other ISRs, etc above this line.

void setup()
{
	// set up ADC -- commonly used by task 2 and 3
	
	// disable power reduction on the ADC
	PRR &= 0b11111110;
	// prescaler value 64 = 16M/128K; 
	// enable ADC, no interrupt;
	ADCSRA = 0b10000110;
	// set the voltage reference -- Vcc
	ADMUX &= 0b01111111;
	ADMUX |= 0b01000000;
	
	// setup PWM
	// set up PWM
	// set initial timer value
	TCNT2 = 0;
	
	// place TOP timer value to output compare register
	OCR2A = 0;
	
	
	
	// Set TCCR2A to set clear mode
	// and choose mode 1 Phase correct PWM
	TCCR2A = 0b10000001;
	TCCR2B = 0b100;	// start PWM
}		



int main()
{
	char buffer[LQLEN];
	int len = -1;
	
	while(len<0){
		hear(buffer, &len);
	}
	
	setupSerial();
	DDRD = 0b11111100;
	
	
	
	sei();
	while(1){
		PORTD ^= 0b11111100;
		_delay_ms(100);
		say("a");
	}
	
	
	/*
	int i;
	char buffer[LQLEN] = "";
	int len = -1;
	
	DDRD = 0b111111111;
	setupSerial();
	
	// while(len <=0)	hear(buffer, &len);
	// say(buffer);
	
	OSInit();
	
	setup();
	
	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	
	//OSAddTask(task1, 0, (void *) 1);
	//OSAddTask(task2, 1, NULL);
	OSAddTask(task3, 2, NULL);
	
	// Insert code to create task4 below.
	OSAddTask(task4, 3, NULL);
	
	// And start the OS!
	OSRun();
	*/
	
	while(1);
}
