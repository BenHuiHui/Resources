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

#define DFS_WHITE   -1
#define DFS_BLACK   1
#define DFS_GRAY    2

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>      vvi;
typedef vector<vii>     vvii;

int V;
int dfsNumberCounter=1;
vector<int> dfs_num, dfs_low,S,visited;
vi scc_belong;
vvi scc_group;

vvii AdjList;

void tarjanSCC(int u){
    dfs_low[u] = dfs_num[u] = dfsNumberCounter++;
    S.push_back(u);
    visited[u] = 1;
    for(int j = 0; j < (int) AdjList[u].size(); j++){
        ii v = AdjList[u][j];
        if(dfs_num[v.first] == DFS_WHITE)   tarjanSCC(v.first);
        if(visited[v.first])    dfs_low[u] = min(dfs_low[u],dfs_low[v.first]);
    }
    if(dfs_low[u] == dfs_num[u]){
        vi scc_gp;
        while(1){
            int v = S.back(); S.pop_back(); visited[v] = 0;
            scc_gp.push_back(v);
            scc_belong[v] = scc_group.size();
            if( u == v) break;
        }
        scc_group.push_back(scc_gp);
    }
}

int M;

int main(){
    int TC,a,b,c;
    cin >> TC;
    while(TC--){
        cin >> V >> M;
        AdjList = vvii(V);
        for(int i=0;i<M;i++){
            cin >> a >> b >> c;
            a--;b--;
            AdjList[a].push_back(ii(b,c));
        }
        scc_belong.assign(V,0);
        dfs_num.assign(V,DFS_WHITE); dfs_low.assign(V,0); visited.assign(V,0);
        dfsNumberCounter = 0;
        scc_group.clear();
        for(int i=0;i<V;i++)   if(dfs_num[i] == DFS_WHITE) tarjanSCC(i);
        
        priority_queue<pair<int,ii> > ql;
        for(int i=0;i<AdjList.size();i++){
            for(int j=0;j<AdjList[i].size();j++){
                int v = AdjList[i][j].first;
                if(scc_belong[i] == scc_belong[v])  continue;
                ql.push(pair<int,ii>(AdjList[i][j].second,ii(i,v)));
            }
        }
        int scc_num = scc_group.size();
        int costSum = 0;
        while(!ql.empty() && scc_num > 1){
            int c = ql.top().first; ii ll = ql.top().second;
            int u = ll.first,v = ll.second; ql.pop();
            int ub = scc_belong[u], vb = scc_belong[v];
            if(ub == vb)   continue;
            costSum += c;
            // by default use ub here
            for(int i=0;i<scc_group[vb].size();i++){
                scc_belong[scc_group[vb][i]] = ub;
            }
            scc_num--;
        }
        if(scc_num > 1){
            printf("-1\n");
        } else{
            printf("%d\n",costSum);
        }
    }

    return 0;
}
