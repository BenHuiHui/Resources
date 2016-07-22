import java.util.*;

// change class name to Main to work with UVa online judge
public class UVa10943 { /* How do you add? */
  /*
  // top-down version
  private static int[][] memo = new int[110][110];

  private static int ways(int N, int K) {
    if (K == 1) // only can use 1 number to add up to N
      return 1; // the answer is definitely 1, that number itself
   if (memo[N][K] != -1)
     return memo[N][K];

   // if K > 1, we can choose one number from [0..N] to be one of the number and recursively compute the rest
   int total_ways = 0;
   for (int split = 0; split <= N; split++)
     total_ways = (total_ways + ways(N - split, K - 1)) % 1000000; // we just need the modulo 1M
   return memo[N][K] = total_ways; // memoize them
  }

  public static void main(String[] args) {
    for (int i = 0; i < 110; i++)
      Arrays.fill(memo[i], -1);
    
    Scanner sc = new Scanner(System.in);
    while (true) {
      int N = sc.nextInt(), K = sc.nextInt();
      if (N == 0 && K == 0)
        break;
      System.out.printf("%d\n", ways(N, K));
    }
  }
  */

  // bottom-up version
  public static void main(String[] args) {
    int i, j, split, N, K;
    int[][] dp = new int[110][110];

    for (i = 0; i < 110; i++)
      Arrays.fill(dp[i], 0);

    for (i = 0; i <= 100; i++) // these are the base cases
      dp[i][1] = 1;

    for (j = 1; j < 100; j++) // these three nested loops form the correct topological order
      for (i = 0; i <= 100; i++)
        for (split = 0; split <= 100 - i; split++) {
          dp[i + split][j + 1] += dp[i][j];
          dp[i + split][j + 1] %= 1000000;
        }

    Scanner sc = new Scanner(System.in);
    while (true) {
      N = sc.nextInt(); K = sc.nextInt();
      if (N == 0 && K == 0)
        break;
      System.out.printf("%d\n", dp[N][K]);
    }
  }
}
