#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <queue>
#include <set>
#include <stack>
#include <map>
#include <list>
#define ST 1<<15

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;

int mm[ST];
bool vv[ST];
int N,T;
int ct[16];

bool hasM(int s,int i,int j,int k){
    return (s & (1<<i)) || (s & (1<<j)) || (s & (1<<k));
}

int makeNS(int s,int i,int j,int k){
    return (s | (1<<i) | (1<<j) | (1<<k));
}

int getCost(int i,int j,int k){
    return ct[i] + ct[j] + ct[k];
}

void getNs(vi &pp, int s){
    pp.clear();
    for(int i=0;i<N;i++){
        for(int j=i+1;j<N;j++){
            for(int k=j+1;k<N;k++){
                if(hasM(s,i,j,k)) continue;
                if(T > getCost(i,j,k))   continue;
                pp.push_back(makeNS(s,i,j,k));
    //             printf("s = %x, i = %d, j=%d, k=%d, ns = %x\n",s,i,j,k,makeNS(s,i,j,k));
            }
        }
    }
}


int cal(int s){
    if(vv[s]) return mm[s];

    vi pp;
    getNs(pp,s);
//     printf("s = %x\n",s);
    for(int i=0;i<pp.size();i++){
        mm[s] = max(mm[s], cal(pp[i]) + 1);
   //     printf("s = %x, val = %d, ns = %x\n",s,mm[s],pp[i]);
    }
    vv[s] = 1;
    return mm[s];
}

int main(){
    int TC = 1;
    while(cin >> N >> T, N || T){
        memset(mm,0,sizeof(mm));
        memset(vv,0,sizeof(vv));
        for(int i=0;i<N;i++)    cin >> ct[i];
        printf("Case %d: %d\n",TC++,cal(0));
    }

    return 0;
}
