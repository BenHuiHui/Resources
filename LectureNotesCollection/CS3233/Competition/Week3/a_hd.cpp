# include <list>
# include <set>
# include <stdio.h>

using namespace std;

list <int> q;

int p,c,i,n,kase=0;
char x[5];

int min(int a, int b)
{
	return a<b?a:b;
}

int main()
{
//	freopen("a.txt", "r", stdin);

	while (scanf("%d%d", &p, &c)==2 && (p || c))
	{
		printf("Case %d:\n", ++kase);

		q.clear();

		for (i=0; i<min(p,c); i++) q.push_back(i+1);

		for (i=0; i<c; i++)
		{
			scanf("%s", x);
			
			if (x[0]=='N')
			{
				printf("%d\n", q.front());
				q.push_back(q.front());
				q.pop_front();
			} else
			{
				scanf("%d%*c", &n);
				
				q.remove(n);
				q.push_front(n);
			}
		}
	}
}