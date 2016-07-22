#include <iostream>
#include <utility>
using namespace std;

int main () {
  pair <int,int> one;
  pair <int,int> two;

  one = make_pair (10,20);
  two = make_pair (10.5,'A'); // ok: implicit conversion from pair<double,char>

  cout << "one: " << one.first << ", " << one.second << "\n";
  cout << "two: " << two.first << ", " << two.second << "\n";

  return 0;
}