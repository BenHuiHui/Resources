#include <stdio.h>

#define ADC_PRIORITY 250
#define TIMER0_PRIORITY 249
#define TIMER1_PRIORITY 248

#define ADC_INTERRUPT 0
#define TIMER0_INTERRUPT 1
#define TIMER1_INTERRUPT 2

typedef struct pq{
	void (*fp)(void *);
	int priority;
	struct pq *next, *prev;
} TFuncQ;

TFuncQ *root = NULL;

// this function is created for debugging
void printTFuncQ(TFuncQ *n){
	printf("FuncQ pointer addr: %x, priority: %d, next addr: %x, prev addr: %x\n",
		n,n->priority,n->next,n->prev);
}

int count = 0;

/* This can be better done using a heap
 */
void enq(void (*fp)(void *), int priority){
	// otherwise, find a proper place and insert this
	
	printf("function enq executed: %d time(s), priority: %d\n",++count,priority);
	
	TFuncQ *currentNode, *formerNode;
	for 	(currentNode = root, formerNode = NULL;
			(currentNode != NULL) && ((currentNode->priority) >= priority);
			formerNode = currentNode, currentNode = currentNode->next){
	}
	// place found, then insert the new element here
	TFuncQ *newNode = malloc(sizeof(TFuncQ));
	newNode->fp = fp; newNode->priority = priority; 
	newNode->next = currentNode;	// the next element is currentNode
	newNode->prev = formerNode;	// the previous element is the formerNode
	printTFuncQ(newNode);
	
	if(formerNode != NULL){
		formerNode->next = newNode;
	} else{ // when formerNode is NULL, means the root is NULL
		root = newNode;
	}
	if(currentNode != NULL){
		currentNode->prev = newNode;
	}
}

TFuncQ *deq(){
	TFuncQ *res = root;
	if(root != NULL){
		root = root->next;
	}
	return res;
}

/* Implement a priority queue using this structure */

void a(void *p){
	printf("Function a;\n");
}

void b(){
	printf("Function b;\n");
}

void c(){
	printf("Function c, with value cannot pass in;\n");
}

void adc_func(void *ptr)
{ 
  // Handle ADC stuff
}

void timer0_func(void *ptr) 
{ 
  // Handle timer 0 stuff 
} 
void timer1_func(void *ptr) 
{ 
  // Handle timer 1 stuff 
} 

// this would return a pointer to a function
void* ISR(int interruptVector){
	int priority = 0;
	if(interruptVector == ADC_INTERRUPT){
		enq(&adc_func,ADC_PRIORITY);
	} else if(interruptVector == TIMER0_INTERRUPT){
		enq(&timer0_func,TIMER0_PRIORITY);
	} else if(interruptVector == TIMER1_INTERRUPT){
		enq(&timer1_func,TIMER1_PRIORITY);
	}
	return;
}

int main(){
	enq(&a,100);
	enq(&b,50);
	enq(&c,25);
	
	TFuncQ *node;
	
	while((node = deq()),1){
		if(node != NULL){
			(*(node->fp))(NULL);
		}
		
	}
	
	getchar();
	return 0;
}
