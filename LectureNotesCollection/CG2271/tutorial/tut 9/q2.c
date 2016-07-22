#include <semaphore.h>

// initialize semaphore
sem_t sema;


/* Handle for trigger group of events */
AMXID amxidTrigger;
/* Constants for use in the group */
#define TRIGGER_MASK
0x0001
#define TRIGGER_SET
0x0001
#define TRIGGER_RESET
0x0000
void main(void)
{
    sem_init(&sema,1,0);
    // ......
    /* Create an event group with the trigger and keyboard events set */
    //  tagged wit "EVTR", event initialized to 0 (reset)
 //   ajevcre(&amxidTrigger, 0, "EVTR");
    // ......
}
void interruptvTriggerISR(void)
{
    /* User pulled trigger. Set the event */
    sem_post(*sema);
}
void vScanTask(void)
{
    ......
    while(1)
    {
        /* Wait for user to pull trigger */
        sem_wait(*sema);
        /* Reset the trigger event */
        // ajevsig(amxidTrigger, TRIGGER_MASK, TRIGGER_RESET);
        // no need to reset when semaphore is used
        !! turn on hardware scanner
    } /* while */
}

