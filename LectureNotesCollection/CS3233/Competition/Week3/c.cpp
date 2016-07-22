#include <iostream>
#include <vector>
#define VAL 1000006
using namespace std;

typedef struct Node{
    Node *parent;
    int weight;

    Node(Node *_parent){
        parent = _parent;
        weight = 0;
    }
    Node(){
        parent = NULL;
        weight = 0;
    }
} Node;

Node arr[VAL];

int main(){
    int n,q;

    while(cin >> n >> q, n || q){
        for(int i=0;i<n;i++){
            int p;
            cin >> p;
            if(p < 0)   arr[i].parent = NULL;
            else    arr[i].parent = arr + p;
            arr[i].weight = 0;
        }
        char c; int nod,wei;
        for(int i=0;i<q;i++){
            scanf(" %c",&c);
            if(c == 'U'){
                cin >> nod >> wei;
                arr[nod].weight += wei;
            } else if(c == 'Q'){
                cin >> nod;
                Node *cn = arr + nod;
                int wres = 0;
                int cnt = 0;
                while(cn != NULL && cnt++ < VAL){
                    wres += cn->weight;
                    cn = cn->parent;
                }
                cout << wres << endl;
            }
        }
    }
}
