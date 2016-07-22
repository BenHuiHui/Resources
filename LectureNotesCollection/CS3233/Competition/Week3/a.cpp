#include <iostream>
#include <cstdio>
#include <string>
#include <deque>

using namespace std;

int main(){
    //freopen("a.in","r",stdin);

    int n,m;
    int pos;
    string buf;
    int count = 1;

    bool first = true;

    while(cin >> n >> m, n || m){
        if(first){
            first = false;
        } else{
            putchar('\n');
        }

        cout << "Case " << count++ << ":";

        deque<int> v(n);

        for(int i=0;i<n;i++){
            v[i] = i + 1;
        }

        for(int i=0;i<m;i++){
            cin >> buf;
            if(buf[0] == 'E'){

                cin >> pos;
  //              cout << "pos = " << pos << endl;

                int t = v[pos];
                for(int j = 0;j<pos;j++){
                    v[j+1] = v[j];
                }
                v[0] = t;

          /*      for(int i=0;i<n;i++){
                    cout << v[i] << " ";
                }
                cout << endl;
*/
            } else{ // is 'N'
          //      cout << 'N' << endl;
                printf("\n%d",v[0]);
                v.push_back(v[0]);
                v.pop_front();
            }
        }
        //while(1);
    }

    return 0;
}
