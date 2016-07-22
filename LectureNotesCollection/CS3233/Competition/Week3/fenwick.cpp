#include <iostream>
#include <vector>
#include <cstdio>

using namespace std;

typedef vector<int> vi;
#define LSOne(S)    (S & -(S))

void ft_create(vi &t, int n){
    t.assign(n+1,0);
}

int ft_rsq(const vi &t, int b){
    int sum = 0;
    for(; b; b -= LSOne(b)) sum += t[b];
    return sum;
}

int ft_rsq(const vi &t, int a, int b){
    return ft_rsq(t,b) - (a == 1 ? 0 : ft_rsq(t, a-1));
}

void ft_adjust(vi &t, int k, int v){
    for(; k <= (int)t.size(); k+= LSOne(k) ) t[k] += v;
}

int main(){


    return 0;
}
