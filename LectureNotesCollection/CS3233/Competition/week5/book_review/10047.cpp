./._321.cpp                                                                                         000755  000765  000024  00000000312 11716336567 014025  0                                                                                                    ustar 00songyangyu                      staff                           000000  000000                                                                                                                                                                             Mac OS X            	   2   �      �                                      ATTR       �   �   .                  �   .  com.dropbox.attributes   x��V*�/άP�R�VJ�HM.-IL�IsSK�%�@[[���Z @                                                                                                                                                                                                                                                                                                                      321.cpp                                                                                             000755  000765  000024  00000010400 11716336567 013452  0                                                                                                    ustar 00songyangyu                      staff                           000000  000000                                                                                                                                                                         #include <iostream>
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

#define M_SIZE  20000
#define MAX     2000000000
#define MIN     -2000000000

using namespace std;

typedef pair<int,int>   ii;

ii st[M_SIZE];  // cost, previous state
bool door[12][12];
bool swi[12][12];

int moveToRoom(int state,int roomNum){
    state &= 0xfff0;
    state += roomNum;
    return state;
}

int toggleLight(int state,int lightNum){    // light num is at least 1, and ignore the first 4 bits
    int bit = 1<<(lightNum + 3);
    state ^= bit;
    return state;
}

int getLightNum(int pureState){
    pureState >>= 4;
    int count = 0;
    while(pureState){
        count++;
        pureState >>= 1;
    }
    return count;
}

bool lightIsOn(int state,int num){
    int bit = 1<<(num + 3);
    return (state&bit) > 0;
}

struct qCell{
    int cost,state,count;
    qCell(int cc,int ss,int co){
        cost = cc; state = ss; count = co;
    }
    const bool operator<(const qCell& b) const{
        if(cost != b.cost) return cost > b.cost;
        return count < b.count;
    }
};

int main(){
    int r,d,s;
    int a,b;
    int count = 1;
    int cc = 0;

    while(scanf("%d%d%d",&r,&d,&s), r || d || s){
        memset(door,0,sizeof(door));memset(swi,0,sizeof(swi));
        for(int i =0;i<M_SIZE; i++){ st[i].first = MAX; st[i].second = -1;}

        for(int i=0;i<d;i++){
            scanf("%d%d",&a,&b);
            if(a == b)  continue;
            door[a][b] = 1;
            door[b][a] = 1;
        }

        for(int i=0;i<s;i++){
            scanf("%d%d",&a,&b);
            if(a == b)  continue;
            swi[a][b] = 1;
        }

        priority_queue<qCell> q;
        int initialState = 0;
        initialState = moveToRoom(initialState,1);
        initialState = toggleLight(initialState,1);
        q.push(qCell(0,initialState,cc++));
        st[initialState].first = 0;
        int finalState = moveToRoom(0,r);
        finalState = toggleLight(finalState,r);

        while(!q.empty()){
            qCell e = q.top(); q.pop();
            if(e.state == finalState){break;}
            if(e.cost > st[e.state].first)   continue;   // checked before
            int roomNum = e.state & 0xf;

            for(int i=1;i<=r;i++){
                int state = toggleLight(e.state,i);
                // toggle lights
                if(swi[roomNum][i] && st[state].first > e.cost){
                    st[state].first = e.cost + 1;
                    st[state].second = e.state;
                    q.push(qCell(e.cost + 1, state,cc++));
                }
                state = moveToRoom(e.state,i);
                // enter room
                if(door[roomNum][i] && lightIsOn(state,i) && st[state].first > e.cost){
                    st[state].first = e.cost + 1;
                    st[state].second = e.state;
                    q.push(qCell(e.cost + 1, state,cc++));
                }
            }
        }

        // output
        printf("Villa #%d\n",count++);
        if(st[finalState].first < MAX){
            printf("The problem can be solved in %d steps:\n",st[finalState].first);
            // trace back for the procedure
            stack<int> tr;
            int state = finalState;
            tr.push(-1);

            while(state != initialState){
                tr.push(state); state = st[state].second;
            }
            
            int pState = initialState;
            int nState = tr.top();  tr.pop();
            while(nState > 0){
                if((pState & 0xf) ^ (nState & 0xf)){    // when room got no difference
                    printf("- Move to room %d.\n",nState & 0xf);
                } else{
                    if(pState > nState){    // light turned off
                        printf("- Switch off light in room %d.\n",getLightNum(pState - nState));
                    } else{ // light turned on
                        printf("- Switch on light in room %d.\n",getLightNum(nState - pState));
                    }
                }
                pState = nState; nState = tr.top();
                tr.pop();
            }
        } else{
            printf("The problem cannot be solved.\n");
        }
        putchar('\n');
    }

    return 0;
}
                                                                                                                                                                                                                                                                ch4.txt                                                                                             000644  000765  000024  00000003055 11716617106 013654  0                                                                                                    ustar 00songyangyu                      staff                           000000  000000                                                                                                                                                                         Review Questions:
4.2.2.1: see the attached AC code for 10047 and 321
4.2.2.2: cuz if the graph is stored as Adj Matrix, for a given node,the program would have to iterate through all possible pair to see whether it's connected or not.
4.2.3.1: 
    Union find: using a variable to keep the # of disjoint sets; each time when two disjoint set is linked together, decrease this number by 1
    BFS: in the original algorithm, replace the dfs with bfs. done.
4.2.5.1:
    The push_back(u) is done after the dfs2(i). Therefore, all the son of that node would be visited first, and then push_back(u) got executed.
4.2.5.2:
    Note that no need to use a queue/topological sort, just each time check if there's vertex with 0 incoming degree, output it, mark it as visited, and decrease it's son's incoming degreee by 1.
4.2.6.2:
    it's true. split the graph by 2 parts, in each parts no ele has connection with another. Then one can see that by forming a cycle there must be 2n elements. Therefore it has no odd cycle


To Be Improved:
1. Page 72, in DFS alg: didn't define the DFS_BLACK, AdjList
2. Page 72, in BackTracking alg: 5th line, need to mark visit before calling 
    backtracking, and mark unvisit afterwards
3. Page 81, the TarjanSCC's algorithm: need to give further explaination on the meaning of visited[] array, and the meaning of stack S. (I refered to Wikipedia and finally understood the algorithm...). My Understanding: the visited[] array are the elements belongs to one connected component, and it's used for a quick lookup; the stack S stores the SCC elements
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   dfs_bfs.cpp                                                                                         000644  000765  000024  00000001570 11715374176 014555  0                                                                                                    ustar 00songyangyu                      staff                           000000  000000                                                                                                                                                                         // A DFS alg from the book

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
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        