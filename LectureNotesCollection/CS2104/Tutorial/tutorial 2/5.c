// to translate: /(a|bc)(d?|e)*/ to a C program

#define N 5 // fill in a value here 
#define M 128 // fill in a value here 
#define Final 2 // fill in a value here 
int t[N][M] = 
{
	{	// state 0: match all the characters before
		-1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,2,1,0,	// a->Final, b->1
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0
	},
	{	// state 1: b, match the following c
		-1,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,2,	// c->Final
		0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0, 0,0,0,0,0,
		0,0,0,0,0, 0,0
	},
	{	// state 2: final state, after one successful match
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final, Final,Final,Final,Final,Final,
		Final,Final,Final,Final,Final, Final,Final
	},
	// no need to test for (d?|e)* part, because by default it can be empty.
} ; 
 
int accept (char *s) {
  int state = 0 ;
  while ( *s != '\0') {
    state = t[state][*s];
    s ++ ;
    if (state == -1 ) return 0 ; // reject 
  } 
  if ( state == Final ) return 1 ; // accept 
  return 0 ; // reject 
}

int main(){
	char test[] = "soagyy";
	
	printf("%d",accept(test));
	
	getchar();
	return 0;
}
