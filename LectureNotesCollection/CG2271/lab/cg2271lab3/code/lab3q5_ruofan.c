#define F_CPU 16000000

#include <avr/io.h>
#include <util/delay.h>


int remap(int val, int min_val,int max_val){
	float tempVal=(val-min_val)/(max_val-min_val)*255;
	if(tempVal>255)
		tempVal=255;
	else if(tempVal<0)
		tempVal=0;
	
	return (int)tempVal;
}

void tone(int input)
{
	int i;
	float delay;
	
	delay=500/((float)input*400/255+100);
	//Other necessary code?
	for(i=0; i<100; i++)
	{
		// Write a 1 to digital pin 13
		PORTB|=0b00100000;
		_delay_ms((int)(delay));
		// Write a 0 to digital pin 13
		PORTB&=0B11011111;
		_delay_ms((int)(delay));
	}
}

void main(){
	int min=620;
	int max=890;
	int adcvalue, loval, hival;
	int input;
	
	DDRB|=0b00100000;
	
	PRR&=0b11111110;
	ADCSRA=0b10000111;
	ADMUX=0b01000001;
	
	
	while(1){
		ADCSRA |= 0b01000000;
		while(ADCSRA&0b10000000);
		
		ADCSRA |=0b00010000;
		loval=ADCL;
		hival=ADCH;
		adcvalue = hival*256+loval;
		
		input=remap(adcvalue,min,max);
		tone(input);
	
	}	
}

