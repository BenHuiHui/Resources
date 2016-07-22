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

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vii>     vvii;

int main(){
    int N,E,T,M;
    int TC;
    scanf("%d",&TC);
    bool first = true;

    while(TC--){
        scanf("%d%d%d%d",&N,&E,&T,&M);
        vi dist(N+1,-1);
        vvii EL(N+1);
        int a,b,t;
        for(int i=0;i<M;i++){
            scanf("%d%d%d",&a,&b,&t);
            EL[a].push_back(ii(b,t));
        }

        // traverse
        for(int i=1;i<N;i++){
            priority_queue<ii,vii,greater<ii> > q;
            vi visited(N+1,0);
            q.push(ii(0,i));
            while(!q.empty()){
                ii ele = q.top(); q.pop();
                if(ele.first > T)   continue;
                if(ele.second == E) if(dist[i] == 
            }
        

        if(first) first = false; else putchar('\n');
    }

    return 0;
}
