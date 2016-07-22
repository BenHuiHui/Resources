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

#define RMostOne(x) (x & -x)

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;
typedef map<int,int>    mii;

vi bit_arr;
vi vstart;
vi vend;
int dfscnt;
vvi dfs_mmp;
vector<bool> dfs_visited;

void init(int size){
    size+=2;
    bit_arr.assign(size,0);
    vstart.assign(size,0); vend.assign(size,0);
    dfscnt = 1;
    dfs_visited.assign(size,0);

    dfs_mmp.clear(); for(int i=1;i<size;i++)    dfs_mmp.push_back(vi());
}

void bit_dfs(int u){
    dfs_visited[u] = 1;
    vstart[u] = dfscnt++;
    for(int i=0;i<dfs_mmp[u].size();i++){
        int v = dfs_mmp[u][i];
        if(dfs_visited[v])  continue;
        bit_dfs(v);
    }
    vend[u] = dfscnt;
}

// add value to idx, therefore update all the sum related to its range
void bit_update(int idx,int val){   
    while(idx < bit_arr.size() ){
        bit_arr[idx] += val;
        idx += RMostOne(idx);
    }
}

int bit_read(int idx){
    int sum = 0;
    while(idx > 0){
        sum += bit_arr[idx];
        idx -= RMostOne(idx);
    }
    return sum;
}

int main(){
    int a = 12;
    int N,Q;

    while(cin >> N >> Q, N || Q){
        init(N);
        int p,s;

        // build the ele array
        for(int i=0;i<N;i++){
            scanf("%d ",&p);
            if(p == -1) s = i;
            else dfs_mmp[p].push_back(i);
        }
        
        bit_dfs(s);

        /* test start/end flag
        for(int i=0;i<N;i++){
            printf(" %d",vend[i]);
        }
        cout << endl;
        */

        char c; int a,w;
        for(int i=0;i<N;i++){
            scanf(" %c%d",&c,&a);
            if(c == 'U'){
                scanf("%d",&w);
                bit_update(vstart[a],w);
                bit_update(vend[a],-w);
            } else if(c == 'Q'){
                cout << bit_read(vstart[a]) << endl;
            } else{
                cout << "ERR, c = " << c << endl;
                while(1);
            }
        }
        cout << endl;
    }

    return 0;
}
