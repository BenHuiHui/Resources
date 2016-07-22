import java.util.*;

public class DijkstraDemo {
  private static final int INF = 1000000000;
  private static Vector< Vector< ii > > AdjList = new Vector< Vector< ii > >();
  private static Vector< Integer > D = new Vector< Integer >();
  private static Vector< Integer > p = new Vector< Integer >();
  private static Vector< Integer > c = new Vector< Integer >(); // optional, for terminating condition
  private static int V, E;
  
  private static void init_SSSP(int s) { // initialization phase
    D.clear();
    D.addAll(Collections.nCopies(V, INF)); // use 1B to represent INF
    p.clear();
    p.addAll(Collections.nCopies(V, -1)); // use -1 to represent NULL
    c.clear();
    c.addAll(Collections.nCopies(V, 0)); // counter, how many times this vertex is in the queue
    D.set(s, 0); // this is what we know so far
    c.set(s, 1);
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
// Small graph without negative weight cycle (slide 21), OK
5 7 2
1 4 6
1 3 3
2 1 2
0 4 1
2 0 6
3 4 5
2 3 7

// Small graph with some negative weight edges; no negative cycle (slide 28), still OK
5 5 0
0 1 1
0 2 10
1 3 2
2 3 -10
3 4 3
 
// Small graph with negative weight cycle (slide 33), irrelevant result, output "negative cycle exists"
5 5 0
0 1 1000
1 2 15
2 1 -42
2 3 10
0 4 -100
*/

    Scanner sc = new Scanner(System.in);
    V = sc.nextInt(); E = sc.nextInt();
    int source = sc.nextInt();

    AdjList.clear();
    for (int i = 0; i < V; i++) {
      Vector< ii > Neighbor = new Vector < ii >();
      AdjList.add(Neighbor); // add neighbor list to Adjacency List
    }

    for (int i = 0; i < E; i++) {
      int u = sc.nextInt(), v = sc.nextInt(), w = sc.nextInt();
      AdjList.get(u).add(new ii(v, w));
    }

    init_SSSP(source);

    // Dijkstra's routine
    PriorityQueue < ii > pq = new PriorityQueue < ii > (); pq.offer(new ii(0, source)); // sort based on increasing distance
    boolean negative_cycle_exist = false;
    
    while (!pq.isEmpty()) { // main loop
      ii top = pq.poll(); // greedy: pick shortest unvisited vertex
      int d = top.first(), u = top.second();
      
      // bonus: negative cycle test
      if (c.get(u) > V - 1) {
        negative_cycle_exist = true;
        break;
      }

      if (d == D.get(u)) { // This check is important! We want to process vertex u only once but we can
        // actually enqueue u several times in priority_queue... Fortunately, other occurrences of u
        // in priority_queue will have greater distances and can be ignored (the overhead is small) :)
        for (int j = 0; j < AdjList.get(u).size(); j++) { // for all outgoing edges of u
          ii n = AdjList.get(u).get(j);
          int v = n.first(), w_u_v = n.second();
          if (D.get(v) > D.get(u) + w_u_v) { // if can relax
            D.set(v, D.get(u) + w_u_v); // relax
            p.set(v, u);
            c.set(v, c.get(v) + 1);
            // note that we do not use "relax" method shown earlier in BellmanFord as we need to add this one line:
            pq.offer(new ii(D.get(v), v)); // enqueue this neighbor regardless whether it is already in pq or not
          }
        }
      }
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
