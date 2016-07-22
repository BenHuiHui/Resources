/**
 * Song Yangyu, A0077863
 *
 * Basic Idea (follow YangMansheng's method):
 *  1. I first compute the result by brute force for n = 1 ~ 5 (see the attached e.cpp)
 *  2. then summarize the formula:
 *      a[n+1] = a[n] * (8n + 4),       a[1] = 2
 *  3. Cuz this number increase expontially, and the result only want it % 1000000007; using the relation:
 *      if a = d*q + r, then a % q = r % q, I can mode the result each time in my loop.
 *  4. afterall, print out the result
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

#define CST 1000000007

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;

int main(){
    int n;
    long long sum;
    while(scanf("%d",&n),n){
        sum = 2;
        for(int i=1;i<n;i++){
            sum *= 8*i + 4;
            sum %= CST;
        }
        printf("%lld\n",sum);
    }
    
    return 0;
}
