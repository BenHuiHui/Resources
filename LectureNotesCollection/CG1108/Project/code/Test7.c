
//Include required header files here.
#include "io16f877a.h" //the hardware register definition file.


//Now we declare all the functions used in this program, 
//Put the body of all these functions here, before main().

//This function is called to cause a delay of count Us.
void DelayUs(int count)
{
 int i;
 int j;
 for(i=0;i<count;i++)
 {
  for(j=0;j<5;j++);
  //This for loop has 5 NOPs & wastes 1 uS for our PIC clock frequency of 20MHz. 
 }
}


// This function is to initialise all Input-Output ports used in the program.
void initialize_IO_ports(void)
{
 //set the digital IO ports as per requirement.
 TRISB = 0xFF ; //portB as input.
 
 TRISD = 0x00 ; //portD as output. 
 //clear the output ports at the beginning.
 PORTC = 0x00 ; //clear portC.
 PORTD = 0x00 ; //clear portD.
}

// This is to initialise the Analog to Digital Converter.
void initialize_ADC(void)
{
 TRISA = 0xFF ; //portA as input as we need the analog channel.
 //Configure portA as analog, VDD & VSS as VREFs; 
 ADCON1 = 0x02 ; // ADC result to be left-justified.

/************************************************************
Set AD conversion clock(TAD)to 32 times main clock freq as it should be 
at least 1.6 uS. System clock period for 20MHz crystal is 0.2uS.
************************************************************/
 ADCS1 = 1 ;
 ADCS0 = 0 ;
 //turn ON the ADC.
 ADON = 1 ;
}


//This function takes analog input from channel_number & returns the value.
int read_ADC(int channel_number)
{
 int value;  
 //set RA0/AN0 as ADC analog input channel.
 switch( channel_number)
 {
  case 0:
	CHS2=0;
	CHS1=0;
	CHS0=0;
	break;
  case 1:
	CHS2=0;
	CHS1=0;
	CHS0=1;
	break;
  case 2:
	CHS2=0;
	CHS1=1;
	CHS0=0;
	break;
  case 3:
	CHS2=0;
	CHS1=1;
	CHS0=1;
	break;
  default:
	CHS2=0;
	CHS1=0;
	CHS0=0;
 }//end switch case.
 /*************************************************************
 Delay for the acquisition time which is time for the sample/hold 
 capacitor to reach the steady-state value of input voltage. 
 Refer to the datasheet for the minimum acquisition time.
 **************************************************************/
 DelayUs(100);
 // Start AD conversion.
 GO=1;
 //Then, wait for conversion to finish.
 while(GO) {};
 //Finally, read the values in the A/D result register pair.
 //value=(ADRESH<<8)+ADRESL;
 
 //keep the high byte only for simplicity
 value=ADRESH;
 
 //wait for at least 2TAD. 
 DelayUs(4);
 return(value);
}

char base = 0xff;
char turnBase = 0x80;


// This function is to initialise the CCP1 module to Pulse Width Modulation mode.
void PWM1_init(void)
{
 PR2=0xFF;              //set PWM period; PWM period = [(PR2) + 1] • 4 • TOSC • (TMR2 prescale value)
 CCPR1L=0x00;           //set the PWM dutycyle to 0
 CCP1CON=0x00;
 TRISC&=0xFB;           //Make the CCP1 pin an output 
 T2CON=0x07;		//Post-scale at 1:1 and Prescale at 16s
}

// This function is to initialise the CCP2 module to Pulse Width Modulation mode.
void PWM2_init(void)
{
 PR2=0xFF;              //set PWM period; PWM period = [(PR2) + 1] • 4 • TOSC • (TMR2 prescale value)
 CCPR2L=0x00;           //set the PWM dutycyle to 0
 CCP2CON=0x00;
 TRISC&=0xFD;           //Make the CCP2 pin an output 
 T2CON=0x07;		//Post-scale at 1:1 and Prescale at 16s
}


// This function changes the duty cycle of Pulse Width Modulation module 1.
void PWM1_ChangeDutyCycle(char ccpr1l, char ccp1con)
{
 //Eg. if setting the PWM dutycyle to 50% : ccpr1l=0x7F, ccp1con=0x3F 
 CCPR1L=ccpr1l;            
 CCP1CON=ccp1con;
}

// This function changes the duty cycle of Pulse Width Modulation module 2.
void PWM2_ChangeDutyCycle(char ccpr2l, char ccp2con)
{
 //Eg. if setting the PWM dutycyle to 50% : ccpr2l=0x7F, ccp2con=0x3F 
 CCPR2L=ccpr2l;            
 CCP2CON=ccp2con;
}

void set_Left_Stop(){
  PWM1_ChangeDutyCycle(0,0x0F);
  RD0 = 0;
}
void set_Left_Forward(char phase){
  PWM1_ChangeDutyCycle(phase,0x0F);
  RD0 = 0;
}

void set_Left_Back(char phase){
  PWM1_ChangeDutyCycle(~phase,0x0F);
  RD0 = 1;
}


void set_Right_Stop(){
  PWM2_ChangeDutyCycle(0,0x0F);
  RD1 = 0;
}
void set_Right_Forward(char phase){
  PWM2_ChangeDutyCycle(phase,0x0F);
  RD1 = 0;
}

void set_Right_Back(char phase){
  PWM2_ChangeDutyCycle(~phase,0x0F);
  RD1 = 1;
}

void makeTurn(int direction){
  if(direction==1){ // turn left
    set_Left_Stop();
    set_Right_Forward(base);
  } else if(direction == 2){ // turn right
    set_Left_Forward(base);
    set_Right_Stop();
  } else{
    set_Left_Forward(base);
    set_Right_Forward(base);
  }
}



// Finally, define the main function here.
int main()
{

int counter = 0;
int delay = 20000;
int flag = 0;
//int forwardCounter = 0;
//int direction = 0;

// initialization of the peripherals
initialize_IO_ports();
PWM1_init();
PWM2_init();


while(1)
{
	// *** GA DEMO ***
	// Port D is output, Port B is input
	base = 0xFF;
	turnBase = 0x10;
	
	
	// beep function
	if(flag && counter++ == delay){
	  counter = 0;
	  RD3 = 0;
	  flag = 0;
	}
	
	// the combination of RB1,2,3 can set the PWM ranging from 8/16 to 16/16,
	// increasing by 1
	if(RB1){
	  base-=0x50;
	}
	if(RB2){
	  turnBase -= 0x20;
	}
	
	
//	if(counter == delay)
	
	// RB7: Left, RB6: Middle, RB5: Right
	// 	in the following codes, 0 means black
	if(!RB7 && !RB6 && !RB5){		// 000 (impossible case)          -- all stop case
	  set_Left_Forward(turnBase);
	  set_Right_Forward(turnBase);
//	  forwardCounter = 0;
	} else if(!RB7 && !RB6 && RB5){	// 001 (left encounter black, turn left)
	  set_Left_Stop();
	  set_Right_Forward(turnBase-0x10);
//	  forwardCounter = 0;
	  //direction = 1;
	} else if(RB7 && !RB6 && !RB5){	// 100 (right encounter black, turn right)
	  set_Left_Forward(turnBase-0x10);
	  set_Right_Stop();
//	  direction = 2;
//	  forwardCounter = 0;
	} else if(RB7 && !RB6 && RB5){	// 101 (ideal case, forward)
	  set_Left_Forward(base);
	  set_Right_Forward(base);
	} else if(!RB7 && RB6 && !RB5){	// 010 (unexpected case, stop)    -- all stop case
	  set_Left_Stop();
	  set_Right_Stop();
	} else if(RB7 && RB6 && RB5){	// 111 (totally out, go back)        -- go back case
	  //set_Left_Stop();
	  //set_Right_Stop();
	 // if(forwardCounter++ == 10){
//	  makeTurn(direction);
//	  forwardCounter = 0;
	  set_Left_Back(base);
          set_Right_Back(base);
	  /*} else{
            set_Left_Back(base);
	    set_Right_Back(base);
	  }*/
	  RD3 = 1;
	  flag = 0;
	} else if(!RB7 && RB6 && RB5){	// 011 (big turn to left)
	  set_Left_Back(base);
	  set_Right_Forward(base);
//	  forwardCounter = 0;
	} else{				// 110 (big turn to right)
	  set_Left_Forward(base);
	  set_Right_Back(base);
//	  forwardCounter = 0;
	}
}
}
