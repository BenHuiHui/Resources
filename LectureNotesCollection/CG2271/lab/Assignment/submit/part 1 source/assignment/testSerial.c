/*
 * testSerial.c

 avrdude -p m328p -b 115200 -c stk500v1 -P\\.\\COM4 -U flash:w:assignment.hex

 *
 * Created: 16/10/2011 7:59:15 PM
 *  Author: dcstanc
 */

#include <string.h>
#include "serial.h"
int main()
{
	char buffer[LQLEN];
	char outbuf[QLEN];
	int len;

	setupSerial();
	say("Hello world!");

	while(1)
	{
		// Echo back whatever we heard
		hear(buffer, &len);

		if(len>0)
		{
			sprintf(outbuf, "%s, Len:%d\r\n", buffer, len);
			say(outbuf);
		}
	}
}
