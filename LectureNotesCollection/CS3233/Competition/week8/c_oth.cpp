#include <cstdio>
#include <cstring>
#include <iostream>
using namespace std;
#define MOD 1000000007
#define M 55
typedef long long ll;

int np;
int prime[M];
int factor[M][M];

void init() {
	prime[0] = 2;
	prime[1] = 3;
	np = 2;
	for (int i = 4; i < M; i++) {
		bool p = true;
		for (int j = 0; j < np; j++) {
			if (i % prime[j] == 0) {
				p = false;
				break;
			}
		}
		if (p) prime[np++] = i;
	}
	for (int i = 2; i < M; i++) {
		int v = i;
		for (int j = 0; j < np; j++) {
			if (v == 1) break;
			while (v % prime[j] == 0) {
				v /= prime[j];
				factor[i][j]++;
			}
		}
		for (int j = 0; j < np; j++) {
			factor[i][j] += factor[i - 1][j];
		}
	}
}

ll c(ll n, ll k) {
	ll ans = 1;
	int fac[M];
	for (int i = 0; i < np; i++) {
		fac[i] = factor[k][i];
	}
	for (ll i = n; i > n - k; i--) {
		int v = i;
		for (int j = 0; j < np; j++) {
			while (fac[j] && v % prime[j] == 0) {
				v /= prime[j];
				fac[j]--;
			}
		}
		ans = (ans * v) % MOD;
	}
	return ans;
}

//~ ll bf(int n, int k) {
	//~ ll ans = 1;
	//~ for (int i = 2; i <= n; i++) {
		//~ ll val = 1;
		//~ for (int j = 0; j < k; j++) val = (val * i) % MOD;
		//~ ans = (ans + val) % MOD;
	//~ } 
	//~ return ans;
//~ }

int main() {
	init();
	int n, k;
	while (scanf("%d%d", &n, &k) == 2) {
		ll ans = 0;
		for (int i = 1; i <= k; i++) {
			for (int j = 0; j < i; j++) {
				ll val = 1;
				for (int a = 0; a < k; a++) val = (val * (i - j)) % MOD;
				val = (val * c(n + k - i + 1, k + 1)) % MOD;
				val = (val * c(k + 1, j)) % MOD;
				if (j % 2) ans = (ans + MOD - val) % MOD;
				else ans = (ans + val) % MOD;
			}
		}
		printf("%lld\n", ans);
		//printf("%lld\n", bf(n, k));
	}
	return 0;
}
