#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

#define NUMELTS 16384

int prime(int n){
    int ret=1, i;
    for(i=2;i<=(int) sqrt(n) && ret; i++)   ret = n%i;
    return ret;
}

int main(){
    int data[NUMELTS];

    // TODO: Declare other variable here
    int i;
    int fd[2];  // used for task
    pid_t parent_pid = getpid(), child_pid;
    int count,res;

    pipe(fd);

    // Create the random number list
    // note that the two process are actually creating two set of random numbers;
    // but the two set of numbers are the same because they're using the same seed
    srand(time(NULL));

    for(i=0;i<NUMELTS;i++){
        data[i] = (int) ((double) rand() / (double) RAND_MAX *10000);
    }

    count = 0;
    if(child_pid = fork()){
        for(i=0;i<8192;i++){
            if(prime(i)){
                count++;
            }
        }
        printf("Total # of primes from parent, value:%d\n",count);
        //waitpid(child_pid);
        close(fd[1]);
        read(fd[0],&res,sizeof(res));
        printf("Total # of primes from child, value:%d\n",res);
        count += res;

        printf("Total # of primes in this range:%d\n",count);
    } else{
        // child sub task
        for(i=8192;i<NUMELTS;i++){
            if(prime(i)){
                count++;
            }
        }

        // then write this to parent
        close(fd[0]);
        write(fd[1],&count,sizeof(count));
    }
}
