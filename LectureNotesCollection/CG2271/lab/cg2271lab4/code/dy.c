/*
 * lab4par21.c
 *
 * Created: 9/30/2011 1:35:54 PM
 *  Author: DY
 */ 

#define F_CPU 16000000
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>


int adc_val, pwm_val, _chan,  count;

int remap(int val, int min_val, int max_val)
{
	int output;
	if (val<min_val) return 0;
	if (val>max_val) return 255;
	output=(val-min_val)*255.0/(max_val-min_val);
	return output;
}

void tone(int input)
{
int i;
float freq=200+(float)input/255*300;

for(i=0; i<freq; i++)
{
// Write a 1 to digital pin 13
PORTB |= 0b00100000;
_delay_ms(500.0f/freq);
// Write a 0 to digital pin 13
PORTB &= 0b11011111;
_delay_ms(500.0f/freq);
}
}

void setupADC() 
{ 	PRR &= 0b11111110; 
	ADCSRA=0b10001110; 
} 

 void startADC (int chan)
  { 
   if(chan==0) 	
     ADMUX=0b01000000; 	
  else 	ADMUX=0b01000001;  
  	ADCSRA |=0b01000000;
	sei();   
  	  
}

ISR (ADC_vect) { 
		unsigned loval,hival; 	
		loval=ADCL; 	
		hival=ADCH; 	
		adc_val=hival*256+loval; 
		if (_chan==0)
		{
			int freq=remap(adc_val, 620, 890);
			tone(freq);
			_chan=1;
		}
	    else
		{
			pwm_val=remap(adc_val,100,900);
		    _chan=0;
		}		  
	}
 


void setupPWM()
{
	// Set initial timer value
    TCNT2=0;
	OCR2A=250;
    TCCR2A=0b10000001;
    // Enable compare interrupt
    TIMSK2 |= 0b01;
}




void startPWM()
{
	// Set prescaler of 0b100, or 256.
    TCCR2B=0b00000100;
	
   // Set global interrupts
    sei();
}

ISR(TIMER2_OVF_vect)
{
	OCR2A=pwm_val;
};


void setupTimer0()
{
	TCNT0=0;
	OCR0A=249;
	TCCR0A=0b01000010;
	TIMSK0|=0b10;
}




void startTimer0()
{
	TCCR0B=0b00000011;
	sei();
}


ISR (TIMER0_COMPA_vect)
{	
    count++;
	if((count%10) == 0)
		startADC(_chan);

}

void main()
{
	_chan=1;
	count=0;
	DDRB|=0b00101000;
	setupADC();
	setupTimer0();
	setupPWM();
	startPWM();
	startTimer0();
	startADC(_chan);
	while(1)
    {		
		
		//TODO:: Please write your application code 
    }
}
