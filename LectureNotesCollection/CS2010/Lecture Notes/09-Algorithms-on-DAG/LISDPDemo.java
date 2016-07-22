import java.util.*;

public class LISDPDemo {
  private static Vector < Integer > A = new Vector < Integer > ();
  private static Vector < Integer > memo = new Vector < Integer > ();
  private static int N;

  private static int LIS(int i) {
    if (i == N - 1) return 1;
    // if (memo.get(i) != -1) return memo.get(i); // uncomment this line to get major speed-up :) 

    int ans = 1; // at least A[i] itself
    for (int j = i + 1; j < N; j++)
      if (A.get(i) < A.get(j)) // if can be extended
        ans = Math.max(ans, LIS(j) + 1);
    memo.set(i, ans);
    return ans;
  }

  public static void main(String[] args) {
/*
// LIS (using pure DP technique), slide 41-44
8
-7 10 9 2 3 8 8 1
30
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
61
1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
*/
     Scanner sc = new Scanner(System.in);
     
     N = sc.nextInt();
     A.clear(); A.addAll(Collections.nCopies(N, 0));
     for (int i = 0; i < N; i++)
       A.set(i, sc.nextInt());
     
     memo.clear(); memo.addAll(Collections.nCopies(N, -1)); // to say 'not filled yet'
     System.out.printf("LIS = %d\n", LIS(0));
  }
}
