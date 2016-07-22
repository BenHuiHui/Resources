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
#define BUZZ_MIN	450
#define BUZZ_MAX	800

#define NULL (void *) 0

char saykBuf[LQLEN];

// Base frequency for the buzzer
int buzzer_freq = 1;
int pwm_val = 100;

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

		OSMakeAtomic();
		
			// Write a 1 to digital pin 13
		PORTB |= 0b00100000;
			// base delay
		_delay_ms(delayTime);
			// Write a 0 to digital pin 13
		PORTB &= 0b11011111;
			// base delay to generate the low part of the wave form
			_delay_ms(delayTime);
		
		OSLeaveAtomic();
	}
}


// read adc for led
void task2(void *p)
{
	int val;
	int top;
	
	while(1)
	{
		// Implement Task 2 logic below
		OSMakeAtomic();
		
		// use chanel 1
		ADMUX &= 0b11111000;
		ADMUX |= 1;
		
		// enable ADC
		ADCSRA |= 0b01000000;
		
		// wait for it to finish
		while(ADCSRA & 0x01000000);
		
		// save value
		val = ADCL + 255*ADCH;
		
		// clean ADC
		ADCSRA |= 0b00010000;
		
		// remap
		pwm_val = (val >> 2);
		
		OSLeaveAtomic();
		// Implement Task 2 logic above
		
		// Hand over control to the OS.
		//OSSwapTask();
	}		
}


// read adc for buzzer
void task3(void *p)
{
	int val;
	
	while(1)
	{
		// Implement Task 3 logic below
		OSMakeAtomic();

		// set the channel to be 0
		ADMUX &= 0b11111000;
		
		// enable ADC
		ADCSRA |= 0b01000000;
		
		// wait for it to finish
		while(ADCSRA & 0x01000000);
		
		// save value
		val = ADCL + 255*ADCH;
		
		// clean ADC
		ADCSRA |= 0b00010000;
		
		if(val < 0)	PORTD ^= 0b00100000;
		
		if(val < BUZZ_MIN){
			//PORTD ^= 0b01000000;
			buzzer_freq = 1;
		}else{
			//PORTD ^= 0b10000000;
			buzzer_freq = (int)(((float)500) * (val - BUZZ_MIN) / (BUZZ_MAX-BUZZ_MIN));
		}
		
		OSLeaveAtomic();
		// Implement Task 3 logic above
		
		// Hand over control to the OS.
		// OSSwapTask();
	}
}

void task4(void *ptr)
{
	// initialize the LED
	DDRB |= 0b00001000;
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
	
	while(1)
	{
		// Implement Task 4 logic below
		OCR2A = pwm_val;
		
		// Implement Task 4 logic above
		//OSSwapTask();
	}
}

// Declare all other ISRs, etc below this line.

// I think we're not supposed to use any ISR here?
//  otherwise the OS's swap task got no use

// Declare all other ISRs, etc above this line.

void setup()
{
	// use PORTD for testing
	DDRD |= 0b11110000;
	
	// set up ADC -- commonly used by task 2 and 3
	
	// disable power reduction on the ADC
	PRR &= 0b11111110;
	// prescaler value 64 = 16M/128K; 
	// enable ADC, no interrupt;
	ADCSRA = 0b10000110;
	// set the voltage reference -- Vcc
	ADMUX &= 0b01111111;
	ADMUX |= 0b01000000;
}		



int main()
{
	/*
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
	*/
	
	
	int i;
	char buffer[LQLEN] = "";
	int len = -1;
	
	//DDRD = 0b111111111;
	setupSerial();
	//sei();
	//say("hello!");
	//_delay_ms(1000);
	cli();
	
	// while(len <=0)	hear(buffer, &len);
	// say(buffer);
	
	OSInit();
	
	setup();
	
	// Create the tasks. Task1 is for the buzzer and we pass in the base frequency as an argument.
	
	OSAddTask(task1, 0, (void *) buzzer_freq);	// buzzer tune
	
	OSAddTask(task2, 1, NULL);	// read for LED
	
	OSAddTask(task3, 2, NULL);	// convert for buzzer
	
	// Insert code to create task4 below.
	OSAddTask(task4, 3, NULL);	// blink LED
	
	// And start the OS
	OSRun();
	
	while(1);
}