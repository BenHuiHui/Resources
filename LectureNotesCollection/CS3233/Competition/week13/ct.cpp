// Song Yangyu, A0077863
// Solution for Problem C of Week 12's contest
// Basic Idea: Binary Search
//  for a set of Rx, Zx (where Rx=hypot(x,y) and Zx = z), if the Height h of the cone is know,
//      then the cone's R can be be calculated.
//  Assume the Volume of cone R*R*h/3*PI has a lowest value in the middle, i.e., as H increases,
//   The Volume would first decrease, and then increase.
//    We can do a binary search on the result.
//
//  Oh.. BTW, I got another idea using convex hall, but somehow cannot get ACed. (and I don't know why)
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
#define MXN 10005
#define EPS 1e-7

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;
typedef vector<vi>     vvi;
typedef vector<vii>    vvii;
typedef map<int,int>    mii;

double rr[MXN],zz[MXN];
int n;

double findR(double h){
    double r = 0;
    for(int i=0;i<n;i++){
        r = max(r,rr[i]/(h - zz[i]) * h);
    }
    return r;
}

int main(){
    while(cin >> n){
        double x,y;
        double mz = 0;
        for(int i=0;i<n;i++){
            cin >> x >> y >> zz[i];
            mz = max(zz[i],mz);
            rr[i] = hypot(x,y);
        }
        
        for(int i=0;i<n;i++){
            printf("%lf, %lf\n",rr[i],zz[i]);
        }
    }

    return 0;
}
