import java.util.*;

public class KruskalDemo {
  @SuppressWarnings("unchecked")
  public static void main(String[] args) {
    /*
    // Sample graph shown in lecture
    5 7
    1 2 4
    1 3 4
    2 3 2
    1 4 6
    3 4 8
    1 5 6
    4 5 9
    */

    // THE FIRST PART, DEMO OF USING EDGE LIST DATA STRUCTURE + SORTING EDGES
    Scanner sc = new Scanner(System.in);
    int V = sc.nextInt(), E = sc.nextInt();

    // another graph data structure: EdgeList
    Vector < iii > EdgeList = new Vector < iii >();
    for (int i = 0; i < E; i++) { // simply populate this EdgeList
      // we decrease index by 1 to change input to 0-based indexing
      int u = sc.nextInt() - 1, v = sc.nextInt() - 1, w = sc.nextInt();
      EdgeList.add(new iii(w, u, v)); // we store this information as (w, u, v)
    }

    System.out.println("BEFORE SORTING");
    for (int i = 0; i < E; i++)
      System.out.println(EdgeList.get(i));
    System.out.println("==============");

    // sort by edge weight O(E log E)
    Collections.sort(EdgeList);

    System.out.println("AFTER  SORTING");
    for (int i = 0; i < E; i++)
      System.out.println(EdgeList.get(i));
    System.out.println("==============");

    

    // THE SECOND PART, THE MAIN LOOP OF KRUSKAL'S ALGORITHM
    UnionFind UF = new UnionFind(V); // all V are disjoint sets at the beginning
    int mst_cost = 0;
    for (int i = 0; i < E; i++) { // process all edges, O(E)
      iii e = EdgeList.get(i);
      int u = e.second(), v = e.third(), w = e.first(); // note that we have re-ordered the integer triple
      if (!UF.isSameSet(u, v)) { // if no cycle
        mst_cost += w; // add weight w of e to MST
        System.out.println("Adding   edge: " + e + ", MST cost now = " + mst_cost);
        UF.unionSet(u, v); // link these two vertices
      }
      else
        System.out.println("Ignoring edge: " + e + ", MST cost now = " + mst_cost);
    }
    
    System.out.printf("Final MST cost %d\n", mst_cost);
  }
}

