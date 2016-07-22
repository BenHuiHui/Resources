#include <iostream>
#include <sstream>
#include <vector>
#include <stdio.h>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <queue>
#include <set>
#include <stack>
#include <map>
#include <cmath>
#define UP 1000005
#define PWBUP 1000
#define PWPUP 1000

#define VAL 1000000007

using namespace std;

long long pwt[PWBUP][PWPUP];
long long pw(long long base, long p){
    if(base == 1)   return 1;
    if(p ==0)   return 1;
    if(base < PWPUP && p < PWPUP && pwt[base][p] != -1)  return pwt[base][p];
    long long res = pw(base,p/2); res*=res;res%=VAL;
    if(p&1) res *= base; res %= VAL;
    if(base < PWPUP && p < PWPUP) pwt[base][p] = res;
    printf("base = %lld, p = %ld",base,p);
    printf(", res = %ld\n",res);
    return res;
}
int main(){
    for(int i=0;i<PWPUP; i++)   for(int j=0;j<PWBUP;j++)    pwt[i][j] = -1;
    cout << pw(100000000,50) << endl;
    return 0;
}
