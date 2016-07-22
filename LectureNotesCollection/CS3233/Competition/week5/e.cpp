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

const int R = 1000, C = 2;
bool visited[R][C];

int xx[] = {-1,-1,-1,0,0,1,1,1}, yy[] = {-1,0,1,-1,0,1,-1,0,1};

bool neibVisited(int x,int y){
    for(int i=0;i<8;i++){
        int nx = x + xx[i], ny = y + yy[i];
        if(nx < 0 || ny < 0 || nx >= R || ny >= C || !visited[nx][ny]) continue; 
        else return true;
    }
    return false;
}

int visit(int x,int y,int vC){
    if(x < 0 || x >= R || y < 0 || y >= C || visited[x][y])  return 0;
    if(!vC) return 1;
    int sum = 0; visited[x][y] = 1;
    for(int i=0;i<R;i++){
        for(int j=0;j<C;j++){
            if(neibVisited(i,j))    sum += visit(i,j,vC-1);
        }
    }
    visited[x][y] = 0;
    return sum;
}

int main(){
    memset(visited,0,sizeof visited);
    int sum = 0;
    for(int i=0;i<R;i++){
        sum += visit(i,0,R * C -1);
        sum += visit(i,0,R * C -1);
    }
    cout << sum << endl;

    return 0;
}
