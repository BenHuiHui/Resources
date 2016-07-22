#define F_CPU 16000000

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int remap(int val, int min_val, int max_val){
	int top = 255;
	if(val > max_val){
		return top;
	} else if(val < min_val){
		return 0;
	} else{
		return (int)top * ((float)(val-min_val))/(max_val - min_val);
	}
}

void tone(int input){
	int i;
	
	// ... Other necessary code
	int freRange = 500 - 100, freMin = 100;
	int frequency = freMin + (int)(((float)input)/255 * freRange);
	int delayUnit = 1000/frequency;
	int delayTime = delayUnit/2;
	
	int remainTimes = 5;
	
	for(i=0; i<remainTimes; i++){
	
		// Write a 1 to digital pin 13
		PORTB |= 0b00100000;
		// base delay
		_delay_ms(delayTime);
	
		//?Write?a?0?to?digital?pin?13?
		PORTB &= 0b11011111;
		// base delay to generate the low part of the wave form
		_delay_ms(delayTime);
	}
}

ISR(ADC_vect){
	int lowal, hival;
	int input,tuneValue;
	int min = 620, max = 890;
	
	lowal = ADCL; hival = ADCH;
	input = lowal + hival * 256;
	
	tuneValue = remap(input, min, max);
	
	tone(tuneValue);
	
	ADCSRA |= 0b01000000;
}


int main(){
	PRR &= 0b11111110;
	ADCSRA = 0b10001111;	// enable ADIE
	ADMUX =  0b01000001;	// use channel 1
	
	sei();
	DDRB |= 0b00100000; // set output
	ADCSRA |= 0b01000000;
	while(1){
	}
}
