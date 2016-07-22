// A DFS alg from the book

#include <vector>
#include <map>
#include <queue>

using namespace std;

#define DFS_BLACK   1
#define DFS_WHITE   -1

typedef pair<int,int> ii;
typedef vector<ii> vii;
typedef vector<int> vi;

vi dfs_num;
vector<vii> AdjList;

void dfs(int u){
    dfs_num[u] = DFS_BLACK;
    for( int j = 0; j<(int) AdjList[u].size(); j++){
        ii v = AdjList[u][j];
        if(dfs_num[v.first] == DFS_WHITE)   dfs(v.first);
    }
}


int main(){
    // perform a bfs here
    int s = 0;  // the starting point
    map<int,int> dist; dist[s] = 0;
    queue<int> q; q.push(s);

    while(!q.empty()){
        int u = q.front(); q.pop();
        for(int j = 0;j<(int)AdjList[u].size();j++){
            ii v = AdjList[u][j];
            if(!dist.count(v.first)){
                dist[v.first] = dist[u] + 1;
                q.push(v.first);
            }
        }
    }
}
