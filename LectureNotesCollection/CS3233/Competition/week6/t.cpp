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

using namespace std;

typedef pair<int,int>   ii;
typedef vector<int>     vi;
typedef vector<ii>      vii;

class MyString{
    char *_chars;
    int _size;
public:
    MyString& operator=(char *c);
};

MyString& MyString::operator=(char *c){
    MyString ss;
    ss._chars = c;
    *this = ss;
    return *this;
}

int main(){
    char *p = "lualaa";
    MyString s2 = p;
    cout << "nani?" << endl;
    return 0;

    return 0;
}
