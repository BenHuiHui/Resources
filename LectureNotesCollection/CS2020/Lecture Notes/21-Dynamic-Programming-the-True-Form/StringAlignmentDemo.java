import java.util.*;

public class StringAlignmentDemo {
  private static int delta(char a, char b) {
    return a == b ? 2 : -1; // 2 for match, -1 for mismatch, insert, or delete
  }

  public static void main(String[] args) {
    String S = "ACAATCC"; // "STEVEN"
    int n = S.length();
    String T = "AGCATGC"; // "SEVEN"
    int m = T.length();
    
    int i, j;
    // enlarge this array to process strings with more than 100 chars
    int[][] V = new int[100][100];
    for (i = 0; i < 100; i++)
      Arrays.fill(V[i], 0);

    V[0][0] = 0;
    for (j = 1; j <= m; j++) // insert space(s) j times
      V[0][j] = V[0][j - 1] + delta(' ', T.charAt(j - 1)); // FYI, index start from 0 in Java string
    for (i = 1; i <= n; i++) // delete i times
      V[i][0] = V[i - 1][0] + delta(S.charAt(i - 1), ' ');

    System.out.printf("After Initialization\n");
    for (i = 0; i <= n; i++) {
      for (j = 0; j <= m; j++)
        System.out.printf("%2d ", V[i][j]);
      System.out.printf("\n");
    }
    
    for (i = 1; i <= n; i++) {
      for (j = 1; j <= m; j++)
        V[i][j] = Math.max(V[i - 1][j - 1] + delta(S.charAt(i - 1), T.charAt(j - 1)), // match or mismatch
                    Math.max(V[i - 1][j] + delta(S.charAt(i - 1), ' '), // delete
                             V[i][j - 1] + delta(' ', T.charAt(j - 1)))); // insert
    }
    
    System.out.printf("Bottom-Up DP, Topological Order: row-by-row, left-to-right\n");
    for (i = 0; i <= n; i++) {
      for (j = 0; j <= m; j++)
        System.out.printf("%2d ", V[i][j]);
      System.out.printf("\n");
    }
    
    System.out.printf("Global alignment score = %d\n", V[n][m]);
  }
}
