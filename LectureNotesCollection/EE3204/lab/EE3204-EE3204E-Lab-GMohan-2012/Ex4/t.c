#include "headsock.h"
#include "time.h"

int main(){
    int i,j;
    struct timeval ts,te;
    gettimeofday(&ts,NULL);
    printf("ack_so size: %d\n",sizeof(struct ack_so));
    for(i=0; i< 10009;i++) for(j=0;j<10000;j++);
    gettimeofday(&te,NULL);
    printf("stime: %ld.%ld, etime: %ld.%ld, diff: %lf\n",ts.tv_sec,ts.tv_usec,te.tv_sec,te.tv_usec,difftime(te,ts));
    return 0;
}
