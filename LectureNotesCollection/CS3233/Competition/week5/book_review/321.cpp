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
