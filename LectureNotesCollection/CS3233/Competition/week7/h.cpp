#include <iostream>
#include <sstream>
#include <vector>
#include <stdio.h>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <queue>
#include <set>
#include <stack>
#include <map>
#include <cmath>
#define UP 10000002
#define PWBUP 1000
#define PWPUP 1000

#define VAL  1000000007

using namespace std;

typedef pair<int,int> ii;
typedef vector<int> vi;
typedef vector<ii> vii;

vii fac;
long long sum;
long long N,K;

long long pwt[PWBUP][PWPUP];
long long pw(long long base, long p){
    if(base == 1)   return 1;
    if(p ==0)   return 1;
    if(base < PWBUP && p < PWPUP && pwt[base][p] != -1)  return pwt[base][p];
    long long res = pw(base,p/2);   // already %VAL
    res *= res; res %= VAL;
    if(p&1){ res *= base; res%=VAL;}
    if(base < PWBUP && p < PWPUP) pwt[base][p] = res;
    //printf("base = %lld, p = %ld",base,p);
    // printf(", res = %lld\n",res);
    return res;
}

void cal(long long last,int ci){
    // cout << "last = " << last << ", ci = " << ci << endl;
    if(ci >= fac.size()){
        sum += pw(last,K);
        sum %= VAL;
    } else{
        for(int i=0;i<=fac[ci].second;i++){
            cal(last * pw(fac[ci].first,i),ci+1);
        }
    }
}

vi ft;
vector<bool> sei(UP,0);

int main()
{
    for(int i=0;i<PWBUP; i++)   for(int j=0;j<PWPUP;j++)    pwt[i][j] = -1;
    for(int i=2;i<UP;i++){
        if(!sei[i]){
            ft.push_back(i);
            for(int j=2;i*j < UP;j++){
                sei[i*j] = 1;
            }
        }
    }
    sei.clear();
    int TC;
    cin >> TC;
    while(TC--){
        cin >> N >> K;
        map<int,int> rm;
        fac.clear();
        sum = 0;
        int idx = 0;
        long long hF = sqrt(N) + 4;
        long long oN = N;
        while(idx < ft.size() && ft[idx] < hF && N > 1){
            int m = ft[idx];
            if(N % m == 0){
                N /= m;
                if(rm.count(m)){
                    fac[rm[m]].second = fac[rm[m]].second + 1;
                } else{
                    rm[m] = fac.size();
                    fac.push_back(ii(m,1));
                }
            } else  idx++;
        }

        if(fac.size() == 0) fac.push_back(ii(oN,1));
        cal(1,0);
        cout << sum << endl;
    }
}

