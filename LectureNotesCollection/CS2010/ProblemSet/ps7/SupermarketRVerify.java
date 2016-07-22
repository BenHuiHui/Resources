import java.util.*;

class SupermarketRVerify {
  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    int i, j, N, TC = sc.nextInt();
    int[] X = new int[1010], Y = new int[1010];

    while (TC-- > 0) {
      N = sc.nextInt();

      for (i = 0; i <= N; i++) {
        X[i] = sc.nextInt();
        Y[i] = sc.nextInt();
      }

      for (i = 1; i <= N; i++)
        if (X[i - 1] >= X[i]) {
          System.out.println("ERROR AT " + TC + "-th/nd/st TESTCASE FROM END, X[i-1] MUST BE < X[i]");
          return;
        }

      for (i = 0; i < N; i++)
        for (j = i + 1; j <= N; j++)
          if (X[i] == X[j]) {
            System.out.println("ERROR AT " + TC + "-th/nd/st TESTCASE FROM END, NO TWO ITEMS HAVE THE SAME X VALUE");
            return;
          }
    }

    System.out.println("Test data is valid :)");
  }
}
