import java.util.*;

// change class name to Main to work with UVa online judge
public class UVa10817 { /* Headmaster's Headache */
  // easier with top-down implementation
  
  private static int S, M, N;
  private static int[] salary = new int[110];
  private static int[][] memo = new int[110][(1 << 16) + 10];
  private static Vector < Vector < Integer > > subject;

  private static int updateMask(int s, int oldmask) {
    int newmask = oldmask;
    if ((newmask & (1 << (2 * (s - 1)))) == 0) // if this course has not been taught by anyone
      newmask |= (1 << (2 * (s - 1)));
    else if ((newmask & (1 << (1 + 2 * (s - 1)))) == 0) // if this course has been taught by someone, but not by two persons
      newmask |= (1 << (1 + 2 * (s - 1)));
    // else
    //   ignore
    return newmask;
  }

  private static int dp(int id, int bitmask) {
    if (bitmask == (1 << (2 * S)) - 1) // all requirement has been met
      return 0; // no need to hire anyone again
    if (id == N) // no more applicant
      return 1000000000; // infeasible
    if (memo[id][bitmask] != -1) // top-down DP
      return memo[id][bitmask];

    // for each applicant, there is only two choices:
    // option 1: take this applicant
    int newmask = bitmask;
    for (int l = 0; l < (int)subject.get(id).size(); l++)
      newmask = updateMask(subject.get(id).get(l), newmask);
    int op1 = salary[id] + dp(id + 1, newmask);

    // option 2: ignore this applicant
    int op2 = dp(id + 1, bitmask);

    return memo[id][bitmask] = Math.min(op1, op2);
  }

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    StringTokenizer st;
    while (true) {
      st = new StringTokenizer(sc.nextLine());
      S = Integer.parseInt(st.nextToken());
      if (S == 0)
        break;
      M = Integer.parseInt(st.nextToken());
      N = Integer.parseInt(st.nextToken());

      int starting_cost = 0, starting_bitmask = 0;
      for (int i = 0; i < M; i++) { // M serving teachers
        st = new StringTokenizer(sc.nextLine());
        starting_cost += Integer.parseInt(st.nextToken()); // must keep employing them, add this cost!
        while (st.hasMoreTokens()) // update the list of courses
          starting_bitmask = updateMask(Integer.parseInt(st.nextToken()), starting_bitmask);
      }

      subject = new Vector < Vector < Integer > > ();
      for (int i = 0; i < N; i++) { // N new applicants
        st = new StringTokenizer(sc.nextLine());
        salary[i] = Integer.parseInt(st.nextToken()); // requested salary of this applicant
        Vector < Integer > list = new Vector < Integer >();
        while (st.hasMoreTokens()) // update the list of courses
          list.add(Integer.parseInt(st.nextToken()));
        subject.add(list);
      }

      for (int i = 0; i < 110; i++)
        Arrays.fill(memo[i], -1);
      System.out.printf("%d\n", starting_cost + dp(0, starting_bitmask));
    }
  }
}
