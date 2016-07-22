// Song Yangyu -- A0077863 -- Solution for Problem C of Week 11 Competition
// Basic Idea
// 1. Note that the RA is the rank of the suffix array
// 2. To solve the problem of repeated string, build another array to store the repeation info
//  -- it's the number of repeated chars of string i-1 and string i
// 3. Then one can get the number of valid prefix a certain suffix string has. It's  valid_ele_num[i] = n - SA[i] - REP[i]
// 4. Then we can calculate string of the give rank. A for loop can do the job.
//      The end of string is just the position in the string: SA[idx] to (n-q), where q is the result for (rank - sum(valid_ele_num[i])) 
//          just turns non-positive.

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

#define MAX_N 100010

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;
typedef map<int,int>    mii;

char T[MAX_N];  // input str, up to 100K char
int n;          // length of input str
int RA[MAX_N], tempRA[MAX_N];   // rank arr
int SA[MAX_N], tempSA[MAX_N];   // Suffix Arr
int c[MAX_N];   // for radix sort

void countingSort(int k){
    int i,sum,maxi = max(300,n);
    memset(c,0,sizeof c);
    for(i = 0;i<n;i++)  c[i + k < n ? RA[i+k] : 0]++;
    for(i = sum = 0;i<maxi;i++){
        int t = c[i]; c[i] = sum; sum += t;
    }
    for(i = 0; i<n;i++) tempSA[c[SA[i] + k < n ? RA[SA[i] + k] : 0]++]= SA[i];
    for(i=0; i<n;i++)   SA[i] = tempSA[i];
}

void constructSA(){
    int i,k,r;
    for(i = 0;i<n;i++) RA[i] = T[i];  // initial ranking
    for(i = 0;i<n;i++) SA[i] = i;   // initial sa: 0,1,..,n-1
    for(k = 1;k<n;k<<=1){
        countingSort(k); countingSort(0);
        tempRA[SA[0]] = r = 0;
        for(i = 1;i<n;i++) tempRA[SA[i]] = (RA[SA[i]] == RA[SA[i-1]] && RA[SA[i]+k] == RA[SA[i-1]+k])? r : ++r;
        for(i = 0;i<n;i++) RA[i] = tempRA[i];
    }
}

int main(){
    fgets(T,MAX_N,stdin);
    n = (int) strlen(T);
    T[n-1] = 0; n--;

    constructSA();
    RA[0] = 0;
    for(int i=1;i<n;i++){
        int cc = 0;
        while(T[SA[i-1]+cc] == T[SA[i]+cc]) cc++;
        RA[i] = cc;
    }
    
    for(int i=0;i<n;i++){
        RA[i] = n - RA[i] - SA[i];
    }
    int tc;

    cin >> tc;
    while(tc--){
        int q;
        cin >> q;
        int idx;
        for(idx=0;q -= RA[idx] , q > 0; idx++);
        char c = T[n + q]; T[n+q] = 0;
        printf("%s\n",T+SA[idx]);
        T[n+q] = c;
    }
    return 0;
}
