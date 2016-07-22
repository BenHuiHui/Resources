// lab7a.c Introduction for fork and wait
#include <stdio.h>
#include <unistd.h>

#define PARENT_DELAY    0
#define CHILD_DELAY    0

int main(){
    pid_t pid;
    int i,j,k,status;

    k = 15;
    printf("Current Process's PID = %d, parrent process's pid = %d\n",getpid(), getppid());
    if(pid = fork()){
        printf("Process ID of child: %d\n",pid);

        for(i = 0;i<10;i++){
            printf("Parent: i=%d, k=%d\n",i,k);
            k++;
            // delay
            sleep(PARENT_DELAY);
        }
        waitpid(pid,0,0);
    } else{
        for(i=10;i<50;i++){
            printf("Child: i=%d, k=%d\n",i,k);
            sleep(CHILD_DELAY);
        }
    }
    return 0;
}


