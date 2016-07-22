#include <iostream>
#include <vector>
#include <utility>


using namespace std;


typedef vector<int> vi;
typedef vector<vi> vii;
typedef pair<int,int> pii;
typedef pair<int,pii> pipii;
typedef vector<pii > vpii;
typedef vector<vpii> vvpii;
typedef vector<pipii> vpipii;

void trans_AM_to_AL(const vii adjMat, vvpii adjList){
    adjList.clear();
    for(int i=0;i<adjMat.size();i++){
        adjList.push_back( *(new vpii()) );
        for(int j=0;j<adjMat.size();j++){
            if(i == j)  continue;
            if(adjMat[i][j] > 0){
                adjList[i].push_back(make_pair(j,adjMat[i][j]));
            }
        }
    }
    return;
}

void trans_AL_to_AM(const vvpii adjList, vii adjMat){
    adjMat.clear();

    for(int i=0;i<adjList.size();i++){
        adjMat.push_back(*(new vi(0,adjList.size())));
        adjMat[i][i] = 1;
    }

    for(int i=0;i<adjList.size();i++){
        for(int j=0;j<adjList.size();j++){
            adjMat[i][adjList[i][j].first] = adjList[i][j].second;
        }
    }

    return;
}

void trans_AM_to_EL(const vii adjMat, vpipii edgeList){
    edgeList.clear();

    for(int i=0;i<adjMat.size();i++){
        for(int j=0;j<adjMat.size();j++){
            if(i == j)  continue;
            if(adjMat[i][j] > 0)    edgeList.push_back(make_pair(i,make_pair(j,adjMat[i][j])));
        }
    }
}

int main(){
    vii adjMat;
    vvpii adjList;
    vpipii edgeList;

    make_pair(1,2);

    return 0;
}
