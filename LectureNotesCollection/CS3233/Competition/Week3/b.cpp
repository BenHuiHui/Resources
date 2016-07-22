#include <iostream>
#include <vector>
#include <cstdio>

using namespace std;

int main(){
//    freopen("b.in","r",stdin);
    int n;

    while(cin >> n){
        //cout << "n = " << n << endl;
        vector<int> v(1<<n);
        vector<int> p(1<<n);
        for(int i=0; i<(1<<n); i++){
            cin >> v[i];
//            cout << v[i] << endl;
        }
  //      while(1);
        // then iterate
        int t;
        for(int i=0;i< (1<<n); i++){
            t = 0;
            for(int j=0;j<n;j++){
                t += v[(i ^ (1<<j)) ];
            }
            p[i] = t;
        }

        int max = 0;
        for(int i=0;i< (1<<n);i++){
            for(int j=0;j<n;j++){
                t = p[(i ^ (1<<j)) ] + p[i];
                if(t > max) max = t;
            }
        }
        cout << max << endl;
    }

    return 0;
}
