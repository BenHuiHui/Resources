#include <semaphore.h>
#ifndef PCOMM
#define PCOMM

typedef struct t
{
	int head, tail;
	int size;
	int count;
	int *q;
    sem_t sema_full;    // wait on full push
    sem_t sema_empty;   // wait on empty pop
} pq_t;

pq_t *pq_create(int);
void pq_put(pq_t *, int);
int pq_get(pq_t *);
void pq_destroy(pq_t *);
#endif
