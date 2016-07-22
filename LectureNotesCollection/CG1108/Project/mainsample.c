
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

// Finally, define the main function here.
int main()
{
 // put the infinite loop here
 while(1)
 {
 } //endWhile.

}//end Main

