#define F_CPU 16000000

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

unsigned pwm_val = 240;
//unsigned adc_val = 0;
unsigned _chan = 0;
unsigned tuneValue = 0;
unsigned tune_adc_val = 0;


/* start of code from last lab */

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

/* end of code from last lab */


// Q3
void setupPWM(){
	// set initial timer value
	TCNT2 = 0;   
	
	// place TOP timer value to output compare register
	OCR2A = 249;
	
	// Set TCCR2A to set clear mode
	// and choose mode 1 Phase correct PWM
	TCCR2A = 0b10000001;
	// enable compare interrupt
	TIMSK2 |= 0b01;
}


// Q5
void startPWM(){
	// set prescaler of 0b100
	TCCR2B = 0b100;
	
	// set global interrupts
	sei();
}


// Q4
ISR(TIMER2_OVF_vect){
	OCR2A = pwm_val;
}


// Q6.1
// set up ADC using interrupt programming
void setupADC(){
	// disable power reduction on the ADC
	PRR &= 0b11111110;
	// prescaler value 64 = 16M/128K; enable ADC, interrupt; 
	ADCSRA = 0b10001110;
	// set the voltage reference
	ADMUX &= 0b01111111;
	ADMUX |= 0b01000000;
}

// Q6.2
// starts ADC conversion for channel chan
void startADC(int chan){
	
	if(chan == 0){
		ADMUX &= 0b11111000;
	} else{
		ADMUX &= 0b11111001;
		ADMUX |= 1;
	}
	
	_chan = chan;
	
	// then start conversion if it's not set
	ADCSRA |= 0b01000000;
}

// Q6.3
ISR(ADC_vect){
	int adc_val = ADCL + 255*ADCH;
	ADCSRA |= 0b01000000;
	
	pwm_val = adc_val * 255.0 / 1024;
	
	if(_chan == 0){
		tune_adc_val = adc_val;
		startADC(1);
	}else if(_chan == 1){
		pwm_val = adc_val * 255.0 / 1024;
		startADC(0);
	}
	
}


int main(){
	DDRB |= 0b00101000;
	
	setupPWM();
	startPWM();
	setupADC();
	startADC(0);
	
	int min = 620, max = 890;
	
	while(1){
		tone(remap(tune_adc_val, min, max));
	}
}
