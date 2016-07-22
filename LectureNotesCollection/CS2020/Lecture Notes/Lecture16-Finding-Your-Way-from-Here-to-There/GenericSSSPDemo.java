import java.util.*;

public class GenericSSSPDemo {
  private static final int INF = 1000000000;
  private static Vector< iii > EdgeList = new Vector < iii >(); // demo using EdgeList
  private static Vector< Integer > D = new Vector< Integer >();
  private static Vector< Integer > p = new Vector< Integer >();
  private static int V, E;
  
  private static void init_SSSP(int s) { // initialization phase
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
// Sample graph shown in lecture (slide 12)
5 7 2
1 4 6
1 3 3
2 1 2
0 4 1
2 0 6
3 4 5
2 3 7
    
// Sample graph shown in lecture (slide 13)
5 5 0
0 1 1000
1 2 15
2 1 -42
2 3 10
0 4 -100

// quick challenge 1 shown in lecture (slide 20)
5 6 2
2 1 2
1 3 3
3 4 2
2 0 9
0 4 9
4 0 1

// quick challenge 2 shown in lecture (slide 21)
5 5 2
1 3 3
3 4 2
2 0 9
0 4 9
4 0 1

// with negative weight, but no negative cycle (slide 22)
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

    EdgeList.clear();
    for (int i = 0; i < E; i++) {
      int u = sc.nextInt(), v = sc.nextInt(), w = sc.nextInt();
      EdgeList.add(new iii(u, v, w)); // we can store this information as {u, v, w} or as {w, u, v} as in Kruskal's
    }

    init_SSSP(source);

    // Generic SSSP algorithm
    int counter = 0;
    Random r = new Random();
    while (true) {
      counter++;
      System.out.printf("Iteration %d\n", counter);
      
      // select edge(u, v) in E in arbitrary manner, here: in random style
      iii Edge = EdgeList.get(r.nextInt(E)); // [0 .. E) - note, 0 inclusive, E is exclusive
      relax(Edge.first(), Edge.second(), Edge.third());
      
      // until all edges have D[v] <= D[u] + w(u, v)
      boolean all_edges_done = true;
      for (int i = 0; i < E; i++) {
        Edge = EdgeList.get(i);
        int u = Edge.first(), v = Edge.second(), w = Edge.third();
        if (D.get(v) > D.get(u) + w) {
          all_edges_done = false; // not yet done
          break;
        }
      }
      
      if (all_edges_done)
        break;
    }

    System.out.printf("Algorithm terminates after %d iterations\n", counter);
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
