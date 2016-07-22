import java.io.*;
import java.util.*;

public class GraphDemo2 {
  private Vector < Vector < ii > > AdjList;
  private int V;
  private static Vector < Integer > visited = new Vector < Integer > ();
  private static Vector < Integer > p = new Vector < Integer > ();
  private static Vector < Integer > toposort = new Vector < Integer > ();

  public static void main(String[] args) throws Exception {
    Scanner sc = new Scanner(new File("undirected.txt"));

    int numV = sc.nextInt();
    GraphDemo2 G = new GraphDemo2(numV);
    for (int i = 0; i < numV; i++) {
      int k = sc.nextInt();
      while (k-- > 0) {
        int j = sc.nextInt(), w = sc.nextInt();
        G.AddEdge(i, j, w);
      }
    }
    
    // BFS demo
    System.out.printf("========================\nBFS DEMO\n");
    G.initTraversal();
    int CC = 1; // G.BFS(3) below will count one component reachable from vertex 3
    G.BFS(3); // suppose we want to start BFS from this vertex 3
    G.iterativePath(0); // print BFS path from 3 --> 0
    G.recursivePath(0); // same
    System.out.printf("Vertex %d is reachable from %d: %s\n", 0, 3, visited.get(0) == 1 ? "YES" : "NO");
    System.out.printf("Vertex %d is reachable from %d: %s\n", 5, 3, visited.get(5) == 1 ? "YES" : "NO");
    for (int i = 0; i < numV; i++)
      if (visited.get(i) == 0) {
        G.BFS(i); // do not call G.initTraversal(); again
        CC++;
      }
    System.out.printf("There are %d connected components in this undirected graph\n", CC);
    System.out.printf("========================\n");
    
    // DFS demo
    System.out.printf("========================\nDFS DEMO\n");
    G.initTraversal();
    CC = 1; // G.DFS(3) below will count one component reachable from vertex 3
    G.DFS(3); // suppose we want to start DFS from this vertex 3
    G.iterativePath(0); // print DFS path from 3 --> 0
    G.recursivePath(0); // same
    System.out.printf("Vertex %d is reachable from %d: %s\n", 0, 3, visited.get(0) == 1 ? "YES" : "NO");
    System.out.printf("Vertex %d is reachable from %d: %s\n", 5, 3, visited.get(5) == 1 ? "YES" : "NO");
    for (int i = 0; i < numV; i++)
      if (visited.get(i) == 0) {
        G.DFS(i); // do not call G.initTraversal(); again
        CC++;
      }
    System.out.printf("There are %d connected components in this undirected graph\n", CC);
    System.out.printf("========================\n");
    
    // Verify that the order of sequence in BFS is layer by layer (breadth-first);
    // whereas in DFS, we will visit deepest vertices first (depth-first);
    
    
    
    // Toposort demo
    sc = new Scanner(new File("dag.txt"));

    numV = sc.nextInt();
    G = new GraphDemo2(numV);
    for (int i = 0; i < numV; i++) {
      int k = sc.nextInt();
      while (k-- > 0) {
        int j = sc.nextInt(), w = sc.nextInt();
        G.AddEdge(i, j, w);
      }
    }

    System.out.printf("========================\nTOPOSORT DEMO\n");
    G.initTraversal();
    toposort.clear();
    for (int i = 0; i < numV; i++)
      if (visited.get(i) == 0)
        G.DFSrec(i);
    Collections.reverse(toposort); // a trick to reverse the content of an array
    System.out.println(toposort);
    System.out.printf("========================\n");
  }
  
  public GraphDemo2() { // default constructor
    AdjList = new Vector < Vector < ii > >();
    V = 0;
  }
  
  public GraphDemo2(int _V) {
    AdjList = new Vector < Vector < ii > >();
    V = _V;
    for (int i = 0; i < V; i++)
      AdjList.add(new Vector<ii>());
  }
  
  public void AddEdge(int u, int v, int w) {
    AdjList.get(u).add(new ii(v, w));
  }
  
  public void initTraversal() {
    visited.clear();
    p.clear();

    visited.addAll(Collections.nCopies(V, 0));
    p.addAll(Collections.nCopies(V, -1)); // to store parent information (it is better to set p as a global variable for backtracking purpose)
  }

  public void BFS(int s) {
    Queue < Integer > q = new LinkedList < Integer > ();
    q.offer(s);
    visited.set(s, 1); // set source 's' as visited

    while (!q.isEmpty()) {
      int u = q.poll(); // queue: layer by layer!
      System.out.printf("Vertex %d is reachable\n", u);
      for (int j = 0; j < AdjList.get(u).size(); j++) {
        ii v = AdjList.get(u).get(j);
        if (visited.get(v.first()) == 0) { // if v not visited before
          visited.set(v.first(), 1); // set v as reachable from u
          p.set(v.first(), u); // parent of v is u
          q.offer(v.first()); // enqueue v for next steps
        }
      }
    }
  }
  
  private void DFSrec(int u) {
    visited.set(u, 1); // to avoid cycle
    System.out.printf("Vertex %d is reachable\n", u);
    for (int j = 0; j < AdjList.get(u).size(); j++) {
      ii v = AdjList.get(u).get(j);
      if (visited.get(v.first()) == 0) {
        p.set(v.first(), u); // parent of v is u
        DFSrec(v.first()); // recursive
      }
    }
    toposort.add(u); // add u at the back of Vector < Integer > toposort
  }

  public void DFS(int s) {
    DFSrec(s); // call this private recursive sub-routine
  }
  
  public void iterativePath(int t) {
    System.out.printf("(Reversed) Path:");
    int i = t; // start from the end of path
    while (i != -1) {
      System.out.printf(" %d", i);
      i = p.get(i); // go back to predecessor of i
    }
    System.out.printf("\n");
  }

  private void backtrack(int u) {
    if (u == -1)
      return;
    backtrack(p.get(u));
    System.out.printf(" %d", u);
  }

  public void recursivePath(int t) {
    System.out.printf("(Correct ) Path:");
    backtrack(t);
    System.out.printf("\n");
  }
}
