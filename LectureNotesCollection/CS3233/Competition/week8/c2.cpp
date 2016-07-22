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

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;

#define VAL 1000000007
int pw(int n,int k){
    if(n == 1)  return 1;
    if(k == 0)  return 1;
    if(k == 1)  return n;
    long long res = pw(n,k/2);
    res *= res;
    if(k&1) res *= n;
    res %= VAL;
    return (int)res;
}

int main(){
    int n,k;

    while(cin >> n >> k){
        long long sum = 0;
        for(int i=1;i<=n;i++){
            sum += pw(i,k);
            sum %= VAL;
        }
        cout << sum << endl;
    }
    return 0;
}
