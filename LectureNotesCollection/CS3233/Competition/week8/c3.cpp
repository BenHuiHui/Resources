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
#include <cmath>
#include <map>
#include <list>
#define CMAX 52
#define VAL 1000000007

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;


double B[CMAX];
double F[CMAX];
double s[CMAX][CMAX];
long long c[CMAX][CMAX];

int main(){
    // first generate a list of stirling numbers
    s[0][0] = 1;
    for(int i=1;i<CMAX;i++){
        s[i][0] = 0;
        for(int j=1;j<=i;j++){
            s[i][j] = (((i > j)?s[i-1][j]:0)*j + s[i-1][j-1]);
        }
    }

    // build the factorial table
    for(int i=0;i<CMAX;i++) F[i] = 1;
    for(int i=1;i<CMAX;i++){
        F[i] *= F[i-1];
        F[i] *= i;
    }

    // build the table of binomial coefficient
    c[0][0] = 1; c[0][1] = c[0][2] = 0;
    for(int i=1;i<CMAX;i++){
        c[i][0] = 1; c[i][1] = i;
        for(int j=1;j<=i;j++){
            c[i][j] = (((i > j)?c[i-1][j]:0) + c[i-1][j-1]);
        }
    }

    // build the table of bernoulli numbers
    for(int i=0;i<CMAX;i++){
        B[i] = 0;
        for(int j=0;j<=i;j++){
            B[i] += ((j & 1)?-1:1)*F[j]/(1+j)*s[i][j];
        }
    }
    
    int n,k;
    while(cin >> n >> k){
        double res = 0;
        for(int i=0;i<k;i++){
            res += ((i&1)?-1:1)*c[k+1][i]*B[i]*pow((double)n,(double)(k+1-i));
        }
        res /= (k+1);
        cout << res << endl;
    }

    return 0;
}
