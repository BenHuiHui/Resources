/**
 * SYY's implementation of the server
 */
#include "stdio.h"
#include "headsock.h"

double timediff(struct timeval *,struct timeval *);
double send_file(FILE *, int, long *);


/**
 * Take 3 args:
 *  - first one is the prog name 
 *  - second one is the host name
 *  - third one is the file name
 */
int main(int argc, char **argv){
  // This is an entry in the host database. It has the following members:
  // - h_name: official name of the host;   - h_aliases: a list of alias for that host
  // - h_addrtype: The address type of the host
  // - h_length: the length, in bytes, for each address
  // - **h_addr_list: the vector of addresses for the host
  // - *h_addr: = h_addr_list[0]: the first host addr
  char *hostaddr;
  if(argc != 2){
    fprintf(stderr,"Sorry incorrect argc number. Exiting.");
    exit(1);
  }
  struct hostent *host_ptr = gethostbyname(argv[1]);
  char **pptr;

  // Parse Host
  if(host_ptr == NULL){
    fprintf(stderr,"Sorry, error when parsing hostname.");
    exit(1);
  } else{
    printf("Host's Canonical Name: %s\n", host_ptr->h_name);
  }

  int alias_cnt = 0;
  for(pptr = host_ptr->h_aliases; *pptr != NULL; pptr++){
    printf("The aliases name is: %s\n",*pptr);
  }
  if(alias_cnt == 0){
    printf("The host don't have any alias.\n");
  }

  // Determine host type (but actually no use)
  printf("Host addrtype: ");
  switch(host_ptr->h_addrtype){
    case AF_INET:
      printf("AF_INET\n"); break;
    default:
      // If not support
      fprintf(stderr,"Unknown addrtype\nProgram will exit.\n");
      exit(1);
      break;
  }

  char filename_base[10] = "myfile", filename_ext[5] = ".txt",filename[20];
  FILE *fdata = fopen("data.txt","w");
  if(!fdata){
    fprintf(stderr, "Error in opening data file, exiting.\n");
    exit(1);
  }
  
  int i,j;
  for(i = 1; i <= 10; i++){
    double trans_time_sum;
    for(j = 0; j < 10; j++){

      sprintf(filename,"%s%d%s",filename_base,i,filename_ext);
      
      FILE *fp;
      if((fp = fopen (filename,"r+t")) == NULL) {
        printf("File doesn't exit\n");
        exit(0);
      }

      // Get the first addr
      struct in_addr *faddr = (struct in_addr *) host_ptr->h_addr;

      // AF_INET family, SOCK_STREAM, and default protocol
      int sockfd = socket(AF_INET, SOCK_STREAM, 0);
      if(sockfd < 0){
        fprintf(stderr,"Error in creating the socket. Exiting");
        exit(1);
      }

      // Refer to: http://www.beej.us/guide/bgnet/output/html/multipage/sockaddr_inman.html for more info
      // on the definition of the structures
      struct sockaddr_in ser_addr;  // structure used with IPv4 address
      /** structure:
       * sin_family: the address family
       * sin_port: the address port
       * sin_addr: the address itself; should ONLY use the s_addr field cuz many sys only implemented that one
       * sin_zero[8]: zero this if you want to || quite umbiguous though..
       */
      ser_addr.sin_family = AF_INET;
      // Converts the unsigned short integer from host byte order to network byte order
      ser_addr.sin_port = htons(MYTCP_PORT);  

      // printf("sin_port = %x\n",ser_addr.sin_port);
      memcpy(&(ser_addr.sin_addr), faddr, sizeof(struct in_addr));
      bzero(ser_addr.sin_zero,8); // NOTE: the original implementation is wrong.
      // connect the socket with the host
      int ret = connect(sockfd,(struct sockaddr *) &ser_addr, sizeof (struct sockaddr));
      if(ret != 0){
        fprintf(stderr,"Connection Failed, exiting.\n");
        close(sockfd);
        exit(1);
      }

      if(j == 0){ // initialize vars
        trans_time_sum = 0;
      }

      long send_size;
      trans_time_sum += send_file(fp,sockfd,&send_size) * 1000;

      if(j == 9){ // save and write
        double trans_time = trans_time_sum / 10;
        double through_put = send_size / trans_time;
        printf("Time(ms) : %.3lf, Data sent(byte): %ld\nData rate: %lf (Kbytes/s)\n", trans_time, send_size, through_put);
        fprintf(fdata,"%ld\t%.3f\t%f\n",send_size,trans_time,through_put);
      }

      close(sockfd);
      fclose(fp);
    }
  }
  
  return 0;
}

/**
 * Send file *fp to the server(sockfd), the length of the file sent would be saved in len
 * @return: the time taken to send this file
 */
double send_file(FILE *fp, int sockfd, long *len){
  long lsize;
  char sends[DATALEN];

  fseek(fp,0,SEEK_END);
  lsize = ftell(fp);  // learn the file size first
  rewind(fp);
  printf("The file length is %ld bytes\n",lsize);
  printf("The packet length is %d bytes\n",DATALEN);

  struct timeval sendt, recvt;
  gettimeofday(&sendt,NULL);

  int ci = 0, resend = 0, slen;
  while(ci <= lsize){

    if(!resend){
      fread(sends,DATALEN,1,fp);

      if( feof(fp) ){  // EOF seen
        slen = lsize - ci;
        sends[slen] = 0;
        slen++;
      }
      else slen = DATALEN;
    } 

    int send_ret = send(sockfd,&sends,slen,0); // If use stop&wait, should not check response here

    struct ack_so ack;
    
    int recv_ret = recv(sockfd,&ack,sizeof(struct ack_so),0);
    if( recv_ret == -1){
      fprintf(stderr,"Didn't got response, timeout. Resending.\n");
      resend = 1; continue;
    } else if(ack.num != 1 || ack.len != 0){
      fprintf(stderr,"Error when receiving ack. Recending\n");
      resend = 1; continue;
    } else{
      ci += slen;
      resend = 0;
    }
  }

  gettimeofday(&recvt,NULL);

  *len = ci;

  return timediff(&recvt,&sendt);
}

double timediff(struct timeval *recvt,struct timeval *sendt){
  return (recvt->tv_sec - sendt->tv_sec) + (recvt->tv_usec - sendt->tv_usec) / 1000000.0;
}

