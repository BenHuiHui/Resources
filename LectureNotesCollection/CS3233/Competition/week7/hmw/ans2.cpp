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

#define VAL 100000007
#define CMAX 10001

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;

int c[CMAX][CMAX];
int b[CMAX];

int main(){
    
    // first build the table of binomial coefficient
    c[0][0] = 1; c[0][1] = c[0][2] = 0;
    for(int i=1;i<CMAX;i++){
        c[i][0] = 1; c[i][1] = i;
        for(int j=1;j<=i;j++){
            c[i][j] = (((i > j)?c[i-1][j]:0) + c[i-1][j-1]) % VAL;
        }
    }
    
    // then build the table of bell number
    memset(b,0,sizeof b);
    b[0] = 1;
    for(int i=1;i<CMAX;i++){
        for(int j=0;j<i;j++){
            b[i] += (((long long)c[i-1][j]) * b[j] % VAL);  // convert to long long to avoid overflow
            b[i] %= VAL;
        }
    }

    int TC,t;
    cin >> TC;
    while(TC--){
        cin >> t;
        cout << b[t] << endl;
    }
    
    return 0;
}
