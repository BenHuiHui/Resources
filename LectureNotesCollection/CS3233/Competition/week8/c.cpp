/**
 * Song Yangyu, A0077863
 *
 * Method to solve C: there's a formula for calculating the power sum.
 *      apply the formula got form 
 *          http://mathworld.wolfram.com/PowerSum.html
 *  Note that when calculating the combinatorial number, we need to factoize
 *  the denominator, so that when we cumulatively multiply the nominator, we
 *  would consume up the factors of the denominator before we modulo by 100000007
 */
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
#define UP 53
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

vector<bool> sei(UP,0);
vi ft;

int C(int n,int k){
    // first factorize k -- assume k <= 50
    vi factors;
    int ok = k;
    for(int i=1;i<=k;i++){
        int nk = i,pf=0;
        while(nk > 1){
            if(nk % ft[pf] == 0){
                nk /= ft[pf]; factors.push_back(ft[pf]);
            } else{
                pf++;
            }
        }
    }
    // then loop through the n ~ k, divide and sum
    long long res = 1;
    for(int i=0;i<ok;i++){
        res *= (n-i);
        for(int j=0;j<factors.size();j++){
            if(factors[j] != -1 && (res % factors[j] == 0)){
                res /= factors[j];
                factors[j] = -1;
            }
        }
        res %= VAL;
    }
    return res;
}

long long pw(int n,int p){
    long long res=n;
    for(int i=1;i < p;i++){
        res *= n;
        res %= VAL;
    }
    return res;
}

int main(){
    // build a table of prime numbers
    for(int i=2;i<UP;i++){
        if(!sei[i]){
            ft.push_back(i);
            for(int j=2;i*j < UP;j++){
                sei[i*j] = 1;
            }
        }
    }
    sei.clear();

    int n,k;
    while(cin >> n >> k){
        long long sum = 0;
        for(int i=1;i<=k;i++){
            for(int j=0;j<i;j++){
                long long tmp = ((j&1)?-1:1)*pw(i-j,k)*C(n+k-i+1,k+1);
                tmp %= VAL;
                tmp *= C(k+1,j);
                tmp %= VAL;
                sum += tmp;
            }
            if(sum < 0) sum += VAL;
            sum %= VAL;
        }
        cout << (sum + VAL) % VAL << endl;
    }

    return 0;
}
