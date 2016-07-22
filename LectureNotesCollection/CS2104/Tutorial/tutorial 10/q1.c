#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>

#define NO_EXCEPTION 0
#define EXC1 1
#define EXC2 2
#define EXC3 3

#define BUF_SIZE 100

struct Exc{
    int t;
    char msg[BUF_SIZE];
};

struct Exc E = {NO_EXCEPTION,"Nothing"};

struct jmp_list{
    struct jmp_list *next;
    struct jmp_list *prev;
    jmp_buf* value;
} *list_tail;

jmp_buf* push(jmp_buf* node){
    if(list_tail == NULL){
        list_tail = malloc(sizeof(struct jmp_list));
        list_tail->prev = NULL; list_tail->next = NULL;
        list_tail->value = node;
        return node;
    } else{
        struct jmp_list *next = malloc(sizeof(struct jmp_list));
        next->prev = list_tail; next->next = NULL;
        list_tail->next = next;
        list_tail->value = node;
        return node;
    }
}

jmp_buf* pop(){
    if(list_tail == NULL){
        return NULL;
    } else{
        jmp_buf* res = list_tail->value; struct jmp_list* cur_l = list_tail;
        list_tail = list_tail->prev;

        free(cur_l);
        if(list_tail != NULL)   list_tail->next = NULL;

        return res;
    }
}

void second(int b){
    if(b==1){
        E.t = EXC2;
        strcpy(E.msg,"Exception 2 from second");
        longjmp(*pop(),1);
    }

    if(b==2){
        E.t = EXC3;
        strcpy(E.msg,"Exception 3 from second");
        longjmp(*pop(),1);
    }
}

void first(int a, int b){
    if(!setjmp(*push(malloc(sizeof(jmp_buf))))){
        if(a==1){
            E.t = EXC1;
            strcpy(E.msg,"Exception 1 from first");
            longjmp(*pop(),1);
        }
        second(b);
        pop();
    } else{
        switch(E.t){
            case EXC3:printf("%s",E.msg);break;
            default: longjmp(*pop(),1);   // go one level up
        }
    }
}

int main(){
    // for mocking argc and argv
    int argc = 3; char *argv[] = {"lualal","1","2"};

    if(!setjmp(*push(malloc(sizeof(jmp_buf))))){
        int i1,i2;
        sscanf(argv[1],"%d",&i1);sscanf(argv[2],"%d",&i2);
        first(i1,i2);
        printf("This line might not get printed");
        pop();
    } else{
        switch(E.t){
            case EXC1:  printf("%s",E.msg);break;
            case EXC2:  printf("%s",E.msg);break;
            case NO_EXCEPTION: break;   // do nothing on no exception
            default:break;  // TODO: check how to deal with this part
        }
    }
    return 0;
}
