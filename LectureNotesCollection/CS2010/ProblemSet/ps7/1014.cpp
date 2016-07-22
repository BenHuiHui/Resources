# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <math.h>
# include <vector>
# include <algorithm>

using namespace std;

typedef pair<double, double> dd;

int n;
vector<dd> v;
double f[1005][1005], d[1005][1005];

double sqr(double x)
{
	return x*x;
}

double dist(dd i, dd j)
{
	return sqrt(sqr(i.first-j.first)+sqr(i.second-j.second));
}

int main()
{
	freopen("a.txt", "r", stdin);

	scanf("%d", &n);

	for (int i=0; i<n; i++)
	{
		double a,b;
		
		scanf("%lf%lf", &a, &b);

		v.push_back(dd(a,b));
	}

	sort(v.begin(), v.end());

	for (int i=0; i<n; i++)
		for (int j=0; j<n; j++)
		{
			if (i!=j) d[i][j]=dist(v[i],v[j]);

			f[i][j]=10e15;
		}

	f[1][0]=d[1][0];

	for (int i=2; i<n; i++)
	{
		for (int j=0; j<i-1; j++) f[i][j]=f[i-1][j]+d[i-1][i];

		for (int j=0; j<i-1; j++) f[i][i-1]=min(f[i][i-1], f[i-1][j]+d[j][i]);
	}

	printf("%.2lf\n", f[n-1][n-2]+d[n-2][n-1]);
}
