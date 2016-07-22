#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdio>
#include <queue>

using namespace std;

typedef pair<int,int> ii;
typedef vector<vector<int> > vvi;
typedef vector<vector<ii> > vvii;


int main(){
    int TC;
    int N,E,T,M;
    scanf("%d",&TC);
    int first = true;
    while(TC--){
        scanf("%d%d%d%d",&N,&E,&T,&M);
        vvi mm(N);
        for(int i=0;i<N;i++)    mm[i] = vector<int>(N,-1);
        int a,b,c;
        for(int i=0;i<M;i++){
            scanf("%d%d%d",&a,&b,&c);
            a--;b--;
            if(mm[b][a] != -1 && mm[b][a] < c)  continue;
            mm[b][a] = c;
        }
        
        vvii EdgeList(N);
        for(int i=0;i<N;i++)    for(int j=0;j<N;j++)    if(mm[i][j] != -1)  EdgeList[i].push_back(ii(j,mm[i][j]));
        vector<bool> visited(N,false);
        priority_queue<ii> q;
        q.push(ii(T,E-1));
        int Count = 0;
        while(!q.empty()){
            ii cc = q.top(); q.pop();
            if(visited[cc.second])  continue;
            visited[cc.second] = true;
            if(cc.first >= 0){
                Count++;
            } else break;
            for(int i=0;i<EdgeList[cc.second].size();i++){
                if(!visited[EdgeList[cc.second][i].first]){
                    q.push(ii(cc.first - EdgeList[cc.second][i].second,EdgeList[cc.second][i].first));
                }
            }
        }
        if(first)   first = false;
        else    putchar('\n');
        printf("%d\n",Count);
    }
    return 0;
}

