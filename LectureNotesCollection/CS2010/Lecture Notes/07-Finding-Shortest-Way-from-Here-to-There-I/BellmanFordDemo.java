import java.util.*;

public class BellmanFordDemo {
  private static final int INF = 1000000000;
  private static Vector< Vector< IntegerPair > > AdjList = new Vector< Vector< IntegerPair > >();
  private static Vector< Integer > D = new Vector< Integer >();
  private static Vector< Integer > p = new Vector< Integer >();
  private static int V, E;

  private static void initSSSP(int s) { // initialization phase
    D.clear();
    D.addAll(Collections.nCopies(V, INF)); // use 1B to represent INF
    p.clear();
    p.addAll(Collections.nCopies(V, -1)); // use -1 to represent NULL
    D.set(s, 0); // this is what we know so far
  }

  private static void relax(int u, int v, int w_u_v) {
    if (D.get(v) > D.get(u) + w_u_v) { // if SP can be shortened
      D.set(v, D.get(u) + w_u_v); // relax this edge
      p.set(v, u); // remember/update the predecessor
    }
  }

  private static void backtrack(int s, int u) {
    if (u == -1 || u == s) {
      System.out.printf("%d", u);
      return;
    }
    backtrack(s, p.get(u));
    System.out.printf(" %d", u);
  }

  public static void main(String[] args) {
/*
// Sample graph shown in lecture (slide 43)
5 7 2
1 4 6
1 3 3
2 1 2
0 4 1
2 0 6
3 4 5
2 3 7
    
// Sample graph shown in lecture (slide 44)
5 5 0
0 1 1000
1 2 15
2 1 -42
2 3 10
0 4 -100

// quick challenge 1 shown in lecture (slide 51)
5 6 2
2 1 2
1 3 3
3 4 2
2 0 9
0 4 9
4 0 1

// quick challenge 2 shown in lecture (slide 52)
5 5 2
1 3 3
3 4 2
2 0 9
0 4 9
4 0 1

// quick challenge 3 shown in lecture (slide 53), with negative weight, but no negative cycle
5 5 2
1 3 -3
3 4 -2
2 0 9
0 4 -8
4 0 8
*/

    Scanner sc = new Scanner(System.in);
    V = sc.nextInt(); E = sc.nextInt();
    int source = sc.nextInt();

    AdjList.clear();
    for (int i = 0; i < V; i++) {
      Vector< IntegerPair > Neighbor =  new Vector < IntegerPair >();
      AdjList.add(Neighbor); // add neighbor list to Adjacency List
    }

    for (int i = 0; i < E; i++) {
      int u = sc.nextInt(), v = sc.nextInt(), w = sc.nextInt();
      AdjList.get(u).add(new IntegerPair(v, w));
    }
    
    initSSSP(source);

    // Bellman Ford's routine, implemented using AdjList (note that you can choose to use EdgeList -- similar performance)
    for (int i = 0; i < V - 1; i++) // relax all E edges V-1 times, O(V)
      for (int u = 0; u < V; u++) // these two loops = O(E)
        for (int j = 0; j < AdjList.get(u).size(); j++) {
          IntegerPair v = AdjList.get(u).get(j);
          relax(u, v.first(), v.second());
        }

    // bonus: negative cycle test
    boolean negative_cycle_exist = false;
    for (int u = 0; u < V; u++) // one more pass to check
      for (int j = 0; j < AdjList.get(u).size(); j++) {
        IntegerPair v = AdjList.get(u).get(j); // try relaxing this edge one more time
        if (D.get(v.first()) > D.get(u) + v.second())
          negative_cycle_exist = true; // if this is true, then negative cycle exists!
      }

    System.out.printf("Negative Cycle Exist? %s\n", negative_cycle_exist ? "Yes" : "No");
    if (!negative_cycle_exist) {
      for (int i = 0; i < V; i++) {
        System.out.printf("SSSP(%d, %d) = %d\n", source, i, D.get(i));
        if (D.get(i) != INF) {
          System.out.printf("Path: ");
          backtrack(source, i);
          System.out.printf("\n");
        }
        System.out.printf("\n");
      }
    }
  }
}
