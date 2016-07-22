import java.util.*;

class LaborVerify {
  private static Vector < Vector < IntegerPair > > AdjList;
  private static Vector < Integer > visited;

  private static void DFSrec(int u) {
    visited.set(u, 1);
    for (int j = 0; j < AdjList.get(u).size(); j++) {
      IntegerPair v = AdjList.get(u).get(j);
      if (visited.get(v.first()) == 0)
        DFSrec(v.first());
    }
  }

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    int i, j, k, w, TC = sc.nextInt();
    long V, E; // the values of V * E can be quite big for Subtask4

    while (TC-- > 0) {
      V = sc.nextLong();
      AdjList = new Vector < Vector < IntegerPair > > ();
      for (E = i = 0; i < V; i++) {
        AdjList.add(new Vector<IntegerPair>());
        k = sc.nextInt();
        E += k;

        while (k-- > 0) {
          j = sc.nextInt(); w = sc.nextInt();
          if (w < 0) {
            System.out.println("ERROR AT " + TC + "-th/nd/st TESTCASE FROM END, EDGE WEIGHT MUST BE NON-NEGATIVE");
            return;
          }
          AdjList.get(i).add(new IntegerPair(j, w)); // edge (road) weight (length of road) is stored here
        }
      }

      if (1 <= V * E && V * E <= 1000000)
        System.out.println("V = " + V + " and E = " + E + ", valid for Subtask 3 as V * E = " + (V * E) + " <= 1000000");
      else
        System.out.println("V = " + V + " and E = " + E + ", NOT valid for Subtask 3 as V * E = " + (V * E) + " > 1000000");

      if (1 <= V + E && V + E <= 250000)
        System.out.println("V = " + V + " and E = " + E + ", valid for Subtask 4 as V + E = " + (V + E) + " <= 250000");
      else
        System.out.println("V = " + V + " and E = " + E + ", NOT valid for Subtask 4 as V + E = " + (V + E) + " > 250000");

      // Check if there is at least one path from vertex 0 to 1
      visited = new Vector < Integer > ();
      visited.addAll(Collections.nCopies((int)V, 0));
      DFSrec(0);
      if (visited.get(1) == 0) {
        System.out.println("ERROR AT " + TC + "-th/nd/st TESTCASE FROM END, THERE MUST BE AT LEAST ONE PATH FROM VERTEX 0->1");
        return;
      }
    }

    System.out.println("Test data is valid :)");
  }
}
