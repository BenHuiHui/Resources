import java.util.*;

public class PrimDemo {
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

    Scanner sc = new Scanner(System.in);
    int V = sc.nextInt(), E = sc.nextInt();
    Vector < Vector < ii > > AdjList = new Vector < Vector < ii > >();

    for (int i = 0; i < V; i++) {
      Vector < ii > Neighbor = new Vector < ii >(); // create vector of Integer pair 
      AdjList.add(Neighbor); // store blank vector first
    }
    
    for (int i = 0; i < E; i++) { // store graph information in Adjacency List
      // we decrease index by 1 to change input to 0-based indexing
      int u = sc.nextInt() - 1, v = sc.nextInt() - 1, w = sc.nextInt();
      AdjList.get(u).add(new ii(v, w)); // bi-directional
      AdjList.get(v).add(new ii(u, w));
    }

    int mst_cost = 0;
    Vector < Boolean > taken = new Vector < Boolean >();
    PriorityQueue < ii > pq = new PriorityQueue < ii > ();

    // take any vertex of the graph, for simplicity, vertex 0, to be included in the MST
    System.out.println(">> At vertex 0");
    taken.addAll(Collections.nCopies(V, false)); taken.set(0, true);
    for (int j = 0; j < AdjList.get(0).size(); j++) {
      ii v = AdjList.get(0).get(j);
      pq.offer(new ii(v.second(), v.first()));  // we sort by weight then by adjacent vertex
      System.out.println(">> Inserting [" + v.second() + ", " + v.first() + "] to priority queue");
    }
    System.out.println(">> Done with insertion(s), if any");
    
    while (!pq.isEmpty()) { // we will do this until all V vertices are taken (or E = V - 1 edges are taken)
      if (!taken.get(pq.peek().second())) { // we have not connected this vertex yet
        taken.set(pq.peek().second(), true); // we flag this as visited
        mst_cost += pq.peek().first(); // add the weight of this
        System.out.println("Adding   edge: " + pq.peek() + ", MST cost now = " + mst_cost);
        int u = pq.peek().second();
        System.out.println(">> At vertex " + u);
        pq.poll(); // remove this item from priority queue
        for (int j = 0; j < AdjList.get(u).size(); j++) {
          ii v = AdjList.get(u).get(j);
          if (!taken.get(v.first())) {
            pq.offer(new ii(v.second(), v.first()));
            System.out.println(">> Inserting [" + v.second() + ", " + v.first() + "] to priority queue");
          }
        }
        System.out.println(">> Done with insertion(s), if any");
      }
      else { // this vertex has been connected before via some other tree branch
        System.out.println("Ignoring edge: " + pq.peek() + ", MST cost now = " + mst_cost);
        pq.poll(); // simple, ignore this edge
      }
    }
    
    System.out.printf("Final MST cost %d\n", mst_cost);
  }
}
