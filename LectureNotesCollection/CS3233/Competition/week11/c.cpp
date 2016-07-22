/* Song Yangyu, A0077863
 * Code for Problem C of Week 10
 *   Basic Idea: notice that if a, b have same residue divided by q, then q divides (a-b).
 *   So for a number: AnAn-1...A1, we can calculate the residue of Ak...A1 divided by q.
 *
 *   Define Bk = Ak..A1, then: Ca,b = (Ba - B(b-1))/10^(b-1) can be divided by q, if and only if Ba and B(b-1) are congruent.
 *   We can therefore using this theory to calculate the table of F.
 *   
 *   Also notice the special case when Q is 2, or 5. We need to treated it specially cuz when doing the calculation above, we
 *   are assuming that q doesn't divides 10. Therefore, we need to deal with 2 and 5 specially.
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
#include <map>
#include <list>
#include <cmath>
#define NMAX 100005
#define VAL 1000000009

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;
typedef map<int,int>    mii;

int N,S,W,Q;
int a[NMAX];
int rem[NMAX];
int CC[NMAX];
long long F[NMAX];

void init(){
    int g = S;
    for(int i=0; i<N; i++) {
        a[i] = (g/7) % 10;
        if( g%2 == 0 ) { g = (g/2); }
        else { g = (g/2) ^ W; }
    }
}

int main(){
    int TT = 1;
    while(scanf("%d%d%d%d",&N,&S,&W,&Q), N || S || W || Q){
        init();

        if(Q == 2 || Q == 5){
            // table of non-0 elements
            memset(CC,0,sizeof CC);
            CC[0] = a[0] != 0;
            for(int i=1;i<N;i++){
                CC[i] = CC[i-1] + (a[i] != 0);
            }
            // table of F
            F[0] = ((a[0] != 0) && (a[0] % Q == 0));
            for(int i=1;i<N;i++){
                F[i] = F[i-1] + ((a[i] % Q == 0) ? CC[i] : 0);
            }
        } else{
            int base = 1;

            // table of congruent
            rem[N] = 0;
            for(int i=N-1;i>=0;i--){
                base %= Q;
                rem[i] = (base * a[i]) % Q;
                base *= 10;
            }
            
            // Table of Cumulative Congruent.
            CC[N] = 0;
            for(int i=N-1;i>=0;i--){
                CC[i] = (CC[i+1] + rem[i]) % Q;
            }

            // table of F
            mii mp;
            F[0] = ( (a[0] != 0) && (a[0] % Q == 0));
            if(a[0] != 0) mp[CC[0]]++;

            for(int i=1;i<N;i++){
                if(a[i] != 0) mp[CC[i]]++;
                F[i] = F[i-1] + mp[CC[i+1]];
            }
        }
        // Multi the table of F and get the result
        int fidx= N-1;
        long long res = 1;
        while(F[fidx] > 0 && fidx >= 0){
            res *= F[fidx];
            fidx--;
            res %= VAL;
        }
        if(fidx == N-1) res = 0;
        cout << res << endl;
    }
    return 0;
}
