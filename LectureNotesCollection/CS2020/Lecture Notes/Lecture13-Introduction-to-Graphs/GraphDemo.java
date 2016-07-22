import java.io.*;
import java.util.*;

public class GraphDemo {
  private Vector < Vector < ii > > AdjList;
  private int V;

  public static void main(String[] args) throws Exception {
    Scanner sc = new Scanner(new File("adjlist.txt"));

    int numV = sc.nextInt();
    GraphDemo G = new GraphDemo(numV);
    for (int i = 0; i < numV; i++) {
      int k = sc.nextInt();
      while (k-- > 0) {
        int j = sc.nextInt(), w = sc.nextInt();
        G.AddEdge(i, j, w);
      }
    }
    
    G.printAdjList();

    System.out.printf("Number of vertices V = %d\n", G.numV());
    System.out.printf("Neighbors of vertex %d are = ", 1); G.enumerateNeighbors(1);
    System.out.printf("Number of edges E = %d\n", G.numE());
    System.out.printf("Edge (%d,%d) exists? %s\n", 0, 1, G.edgeExists(0, 1) ? "Yes" : "No");
    System.out.printf("Edge (%d,%d) exists? %s\n", 0, 2, G.edgeExists(0, 2) ? "Yes" : "No");
  }
  
  public GraphDemo() { // default constructor
    AdjList = new Vector < Vector < ii > >();
    V = 0;
  }
  
  public GraphDemo(int _V) {
    AdjList = new Vector < Vector < ii > >();
    V = _V;
    for (int i = 0; i < V; i++)
      AdjList.add(new Vector<ii>());
  }
  
  public void AddEdge(int u, int v, int w) {
    AdjList.get(u).add(new ii(v, w));
  }
  
  public void printAdjList() {
    System.out.println("V = " + V);
    for (int i = 0; i < V; i++) {
      System.out.print(AdjList.get(i).size());
      for (int j = 0; j < AdjList.get(i).size(); j++) {
        ii v = AdjList.get(i).get(j);
        System.out.print(" (" + v.first() + "," + v.second() + ")");
      }
      System.out.println();
    }
  }
  
  public int numV() {
    return V;
  }

  public void enumerateNeighbors(int u) {
    System.out.print(AdjList.get(u).size());
    for (int j = 0; j < AdjList.get(u).size(); j++) {
      ii v = AdjList.get(u).get(j);
      System.out.print(" (" + v.first() + "," + v.second() + ")");
    }
    System.out.println();
  }

  public int numE() {
    int ans = 0;
    for (int i = 0; i < V; i++)
      ans += AdjList.get(i).size();
    return ans;
  }

  public Boolean edgeExists(int u, int v) {
    for (int j = 0; j < AdjList.get(u).size(); j++) {
      ii vtx = AdjList.get(u).get(j);
      if (vtx.first() == v)
        return true;
    }
    return false;
  }
}
