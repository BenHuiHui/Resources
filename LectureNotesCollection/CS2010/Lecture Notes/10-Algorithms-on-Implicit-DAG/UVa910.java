import java.util.*;

public class Main { // default Java class name in UVa online judge
  private static int[] if0 = new int[30], if1 = new int[30];
  private static boolean[] special = new boolean[30];
  private static int[][] memo = new int[30][40]; // max N = 26, max M = 30

  private static int ways(int u, int m_left) {
    if (m_left == 0) // no more move left?
      return special[u] ? 1 : 0; // 1 way if this is special, 0 otherwise
    if (memo[u][m_left] != -1) // has been computed before?
      return memo[u][m_left];
    // two options, take edge 0 or edge 1
    // if0 and if1 is another "graph data structure"
    return memo[u][m_left] = ways(if0[u], m_left - 1) +
                             ways(if1[u], m_left - 1);
  }

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);

/*
5
A B E -
B D C -
C D A x
D D B -
E E E -
5

// the answer is 3, see
// http://uva.onlinejudge.org/external/9/910.html
*/

    while (sc.hasNext()) {
      Arrays.fill(special, false); 
      int N = sc.nextInt();
      for (int i = 0; i < N; i++) {
        char c = sc.next().charAt(0), X = sc.next().charAt(0);
        char Y = sc.next().charAt(0), sp = sc.next().charAt(0);
        if0[c - 'A'] = X - 'A';
        if1[c - 'A'] = Y - 'A';
        special[c - 'A'] = (sp == 'x');
      }
      int m = sc.nextInt();

      for (int i = 0; i < 30; i++) // clear the memo table first
        Arrays.fill(memo[i], -1);
      System.out.printf("%d\n", ways(0, m)); // start from A with m steps left
    }
  }
}
