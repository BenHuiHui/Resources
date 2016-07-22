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
#include <cmath>
#define SCC_MAX_ELE_NUM 100000
#define DFS_WHITE   0
#define DFS_GRAY    1
#define DFS_BLACK   2

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;
typedef map<int,int>    mii;

vvi scc_edgeList;
vi scc_current_eles;
int scc_con[SCC_MAX_ELE_NUM],scc_low[SCC_MAX_ELE_NUM],scc_idx[SCC_MAX_ELE_NUM];
int sccidxcnt;
int scc_cnt;

// the array is stored in the edge list
void scc_init(vvi edgeList){
    scc_edgeList = edgeList;
    memset(scc_con,DFS_WHITE,sizeof scc_con);
    sccidxcnt = 0;
    scc_cnt = 0;
    scc_current_eles.clear();
}

// assume the u is within the range
void tarjan_scc(int u){
    if(scc_con[u] == DFS_BLACK)    return;
    scc_idx[u] = scc_low[u] = sccidxcnt++;
    scc_con[u] = DFS_GRAY;
    scc_current_eles.push_back(u);
    for(int i=0;i<scc_edgeList[u].size();i++){
        int v = scc_edgeList[u][i];
        if(scc_con[v] == DFS_GRAY){
            scc_low[u] = scc_low[v] = min(scc_low[u],scc_low[v]);
            continue;
        } else if(scc_con[v] == DFS_WHITE){
            tarjan_scc(v);
            scc_low[u] = min(scc_low[u],scc_low[v]);
        }
    }
    if(scc_low[u] == scc_idx[u]){
        printf("found scc #%d, eles: ",scc_cnt++);

        // here can change to do/while to be more elegant
        while(!scc_current_eles.empty()){
            int ce = scc_current_eles.back();
            scc_con[ce] = DFS_BLACK;
            printf(" %d", ce);
            scc_current_eles.pop_back();
            if(ce == u) break;
        }
        putchar('\n');
    }
}

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
        dfs_num.assign(V,DFS_WHITE); dfs_low.assign(V,0); visited.assign(V,0);
        dfsNumberCounter = numSCC = 0;
        for(int i=0;i<V;i++)   if(dfs_num[i] == DFS_WHITE) tarjanSCC(i);
        for(int i=0;i<V;i++)    printf("%d,%d   ",dfs_num[i],dfs_low[i]);
        cout << endl;
    }
    // read the graph and test
    vvi el;
    int nn;
    cin >> nn;
    for(int i=0;i<nn;i++){
        vi nodes;
        int n,t;
        cin >> n;
        while(n--){
            cin >> t;
            nodes.push_back(t);
        }
        el.push_back(nodes);
    }
    scc_init(el);
    for(int i=0;i<nn;i++){
        tarjan_scc(i);
    }

    return 0;
}
