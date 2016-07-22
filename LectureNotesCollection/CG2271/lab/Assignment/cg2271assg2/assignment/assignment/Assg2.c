/*
 * Assg2.c
 *
 * Created: 20/10/2011 1:30:57 PM
 *  Author: dcstanc
 */ 

#include <avr/io.h>
#include "coord.h"
#include "serial.h"
#include "kernel.h"

// Tasks 1 and 2 will increment a global variable ctr, and every 10 increments task 1 will send the resulting value in ctr to task3 via a queue.
// Task 3 will then send it via serial to the PC. 

// In addition, do something fun and creative with this program, the serial port and the components you have. Describe it in your report. :)
void task1(void *p)
{
	while(1)
	{
		
	}
}

void task2(void *p)
{
	while(1)
	{
		
	}
}

void task3(void *p)
{
	while(1)
	{
		
	}
}

void setup()
{
}

int main(void)
{
}