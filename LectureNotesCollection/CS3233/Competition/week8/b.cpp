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
#define MM 105

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;

int N;
int mm[MM][MM];

int cc[MM];
int ss[MM];

int cal(int id, int n){
    if(n >= MM) n = MM - 2;
    if(id == N) return 0;
    if(mm[id][n] != -1)   return mm[id][n];
    mm[id][n] = cal(id+1,n + ss[id]) + cc[id];
    if(n > 0)   mm[id][n] = min(mm[id][n],cal(id+1,n-1+ss[id]) + cc[id]/2);
    return mm[id][n];
}

int main(){
    while( cin >> N, N){
        for(int i=0;i<MM;i++)   for(int j=0;j<MM;j++)   mm[i][j] = -1;
        for(int i=0;i<N;i++){
            cin >> cc[i] >> ss[i];
        }

        cout << cal(0,0) << endl;
    }
    return 0;
}
