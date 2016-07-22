#include <iostream>
#include <cstdio>
#include <algorithm>
#include <cstring>
#include <string>
#include <cctype>
#include <stack>
#include <queue>
#include <vector>
#include <map>
#include <sstream>
#include <set>
#include <math.h>
#include <cmath>

using namespace std;

typedef long long ll;
typedef vector<int> vi;
typedef pair<int, int> ii;
typedef vector<ii> vii;

#define LOOP(i, a, b) for (int i = int(a); i < int(b); i++)
#define isOn(S, j) (S & (1 << j))
#define setBit(S, j) (S |= (1 << j))
#define clearBit(S, j) (S &= ~(1 << j))
#define toggleBit(S, j) (S ^= (1 << j))
#define lowBit(S) (S & (-S))
#define setAll(S, n) (S = (1 << n) - 1)

#define modulo(x, N) ((x) & (N - 1))   // returns x % N, where N is a power of 2
#define isPowerOfTwo(x) ((x & (x - 1)) == 0)
#define nearestPowerOfTwo(x) ((int)pow(2.0, (int)((log((double)x) / log(2.0)) + 0.5)))

int main ()
{
	long long p;
	int c;
	int cter = 1;

	scanf("%lld %d", &p, &c);
	while(p!=0 && c!=0)
	{
		map<long long, long long> num_pri;
		map<long long, long long> pri_num;
		long long count_pri = 0;

		printf("Case %d:\n", cter++);
		for(long long i=1; i<=p; i++)
		{
			pri_num[count_pri] = i;
			num_pri[i] = count_pri;
			count_pri++;
		}

		for(int j=0; j<c; j++)
		{
			char temp;
			cin>>temp;
			if(temp == 'N')
			{
				long long tnum, tpr;
				tnum = pri_num.begin()->second;
				pri_num.erase(pri_num.begin());
				pri_num[count_pri] = tnum;
				num_pri[tnum] = count_pri++;
				printf("%lld\n", tnum);
			}
			else
			{
				long long innum;
				cin>>innum;
				long long inpr;
				inpr = num_pri[innum];
				long long firstpri;
				firstpri = pri_num.begin()->first;
				pri_num.erase(pri_num.find(inpr));
				pri_num[firstpri-1] = innum;
				num_pri[innum] = firstpri-1;
			}
		}

		scanf("%lld %d", &p, &c);
	}

}
