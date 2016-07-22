// Song Yangyu, A0077863N
// Problem C, Week 9

/**
 * General Idea:    -- min-cut problem
 * Notice that we'll only need to select an edge from u to v, when we need to 
 *  select all the edges from u to v, and its cost is minimum.
 * Therefore, we can use the edge's cost as the capacity, and keep a separate
 * table of the number of edges from u to v
 *
 * Then we run the max-flow on this graph.
 *
 * the max-flow would be able to separate the graph into several dis-connected
 *  (in terms of forward edge) parts.
 * Then between these separated parts, count the number of edges that has turned
 * 0. Then output this number
 */

#include <iostream>
#include <vector>
#include <algorithm>
#include <vector>
#include <string>
#include <cstring>
#include <queue>
#include <set>
#include <stack>
#include <map>
#include <list>
#define MAX_V 305
#define INF 0x7fffffff

using namespace std;

typedef pair<int,int>    ii;
typedef vector<int>      vi;
typedef vector<vi>      vii;
typedef vector<vii>    vvii;

int res[MAX_V][MAX_V],mf,f,s,t,ccc;
int edgeNum[MAX_V][MAX_V];

vi p;

void augment(int v,int minEdge){
    if(v == s){
        f = minEdge; return;
    } else if(p[v] != -1){
        augment(p[v],min(minEdge,res[p[v]][v]));
        res[p[v]][v] -= f; res[v][p[v]] += f;
    }
}

int M,N;

int main(){
    int TC;
    cin >> TC;
    while(TC--){
        cin >> N >> M;
        memset(res,0,sizeof res);
        memset(edgeNum,0,sizeof edgeNum);

        int a,b,c;
        for(int i=0;i<M;i++){
            cin >> a >> b >> c;
            res[a][b] += c;
            edgeNum[a][b]++;
        }
        s = 1; t = N;
        
        mf = 0;
        while(1){
            f = 0;
            
            // run BFS
            vi dist(MAX_V,INF); dist[s] = 0; queue<int> q; q.push(s);
            p.assign(MAX_V,-1);
            while(!q.empty()){
                int u = q.front(); q.pop();
                if(u == t) break;
                for(int v=0; v < MAX_V; v++){
                    if(res[u][v] > 0 && dist[v] == INF){
                        dist[v] = dist[u] + 1;
                        q.push(v);
                        p[v] = u;
                    }
                }
            }
            augment(t,INF);
            mf += f;
            if(f == 0)  break;
        }
        
        // then try finding out the spliting edge
        int superNodeIdx = 1;
        int ss[MAX_V];
        memset(ss,0,sizeof ss);
        queue<int> sq;
        bool goon = true;

        vector<int> st(N+1,0);
        st[1] = 1;
        while(goon){

            for(int i=1;i<=N;i++){
                if(st[i] == 1){
                    sq.push(i);
                    break;
                }
            }
            while(!sq.empty()){
                int u = sq.front(); sq.pop();
                st[u] = 2;
                ss[u] = superNodeIdx;
                if(u == t){
                    goon = false;
                }
                for(int i=1;i<=N;i++){
                    if(ss[i])   continue;
                    if(edgeNum[u][i])   st[i] = 1;
                    if(!res[u][i])  continue;
                    sq.push(i);
                    ss[i] = superNodeIdx;
                }
            }
            superNodeIdx++;
        }

        // see the final state
        /*
        cout << " N = " << N << endl;
        for(int i=1;i<=N;i++){
            cout << i << ": ";
            for(int j=1;j<=N;j++){
                cout << res[i][j] << " ";
            }
            cout << endl;
        }

        for(int i=1;i<=N;i++)   cout << ss[i] << " ";
        cout << endl;
        */

        // then for each part, add up the spliting edge

        // Complexity: O(N^2)
        int rr = 0;
        for(int i=1;i<=N;i++){
            for(int j=1;j<=N;j++){
                if(res[i][j] == 0 && ss[i] != ss[j]){
                    rr += edgeNum[i][j];
                }
            }
        }
        cout << rr << endl;
    }
    return 0;
}
