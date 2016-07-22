import java.util.*;

public class Main { // default Java class name in UVa online judge
  private static int INF = Integer.MAX_VALUE;
  private static int C;
  private static int[][] profit = new int[110][110];
  private static boolean[] canEnd = new boolean[110];
  private static int[][] memo = new int[110][1100];

  private static int get_profit(int u, int t_left) {
    if (t_left == 0) // last inter-city travel?
      return canEnd[u] ? 0 : -INF;
    if (memo[u][t_left] != -1) // computed before?
      return memo[u][t_left];

    memo[u][t_left] = -INF;
    for (int v = 1; v <= C; v++)
      memo[u][t_left] = Math.max(memo[u][t_left],
         profit[u][v] + get_profit(v, t_left - 1));
    return memo[u][t_left];
  }

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);

/*
3 1 2 2
0 3 5
5 0 1
9 2 0
2 3

0 0 0 0

// the answer is 7, see
// http://uva.onlinejudge.org/external/107/10702.html
*/

    while (true) {
      C = sc.nextInt(); int S = sc.nextInt(), E = sc.nextInt(), T = sc.nextInt();
      if (C == 0 && S == 0 && E == 0 && T == 0)
        break;
    
      for (int i = 1; i <= C; i++) // read the C * C profit table
        for (int j = 1; j <= C; j++)
          profit[i][j] = sc.nextInt();

      Arrays.fill(canEnd, false); // read the list of cities the tour can end
      for (int i = 0; i < E; i++)
        canEnd[sc.nextInt()] = true;

      for (int i = 0; i < 110; i++)
        Arrays.fill(memo[i], -1);
      System.out.printf("%d\n", get_profit(S, T)); // DP
    }
  }
}
