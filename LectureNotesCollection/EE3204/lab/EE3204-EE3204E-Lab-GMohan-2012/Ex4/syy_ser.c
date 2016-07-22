/**
 * SYY's implementation of the server
 */
#include "stdio.h"
#include "headsock.h"

#define BACKLOG 10

void receive_and_response(int);

int main(){

  // AF_INET family, SOCK_STREAM, and default protocol
  int sockfd = socket(AF_INET, SOCK_STREAM, 0);
  if(sockfd < 0){
    fprintf(stderr,"Error in creating the socket. Exiting");
    exit(1);
  }
  
  struct sockaddr_in my_addr, their_addr;
  my_addr.sin_family = AF_INET;
  my_addr.sin_port = htons(MYTCP_PORT);
  my_addr.sin_addr.s_addr = htonl(INADDR_ANY);  // address to accept any incoming msg
  bzero(my_addr.sin_zero,8);

  // use "bind" to allocate a local socket number; use it instead of listen here cuz we want to 
  // specifically listen to "my_addr" here (which is any address).
  // TODO: check if 'listen' can work here or not
  int ret = bind(sockfd,(struct sockaddr *) &my_addr, sizeof(struct sockaddr));

  if(ret < 0){
    fprintf(stderr,"Error in binding, exiting.\n");
    exit(1);
  }
  
  // TODO: thinking if I delete the above can also work -- actually cannot
  ret = listen(sockfd, BACKLOG);

  if(ret < 0){
    fprintf(stderr,"Error in listening, exiting.\n");
    exit(1);
  }

  int pid;
  while(1){
    printf("Waiting for data\n");
    int sin_size = sizeof(struct sockaddr_in);
    int con_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);

    if(con_fd < 0){
      fprintf(stderr,"Error in accepting, exiting.\n");
      exit(1);
    }
    
    if((pid = fork()) == 0){
      close(sockfd);
      // receive packet and response
      receive_and_response(con_fd);
      close(con_fd);
      exit(0);// finish job already
    } else{
      printf("in Child, pid = %d\n",pid);
      close(con_fd);
    }
  }
  
  printf("pid = %d returning\n",pid);

  close(sockfd);
}




void receive_and_response(int sockfd){

  char recvs[DATALEN_MAX];
  struct ack_so ack;

  printf("receiving data.\n");

  int end = 0; long total_size = 0;

  FILE *fp;
  if((fp = fopen("myTCPPreceive.txt","wt")) == NULL){
    fprintf(stderr,"Error in creating file, exiting\n");
    exit(1);
  }

  while(!end){
    int receive_size;

    if(( receive_size = recv(sockfd, recvs, DATALEN_MAX, 0)) == -1){
      fprintf(stderr,"Error when receiving.\n");
      exit(1);
    }

    // send ack after receiving
    ack.num = 1;
    ack.len = 0;
    if( (send(sockfd, &ack, sizeof(struct ack_so), 0)) == -1){
      fprintf(stderr,"Error in sending ACK. Ignoring.\n");
    } 

    if(recvs[receive_size-1] == 0){
      end = 1;
      receive_size--; // ignore the terminating byte
    }

    fwrite(recvs,1,receive_size,fp);  // Write it to the file directly

    // send repsonse each time after got the response
    total_size += receive_size;
  }

  fclose(fp);
  printf("A file has been successfully received.\nThe total data received is %d bytes\n",(int) total_size);
}
