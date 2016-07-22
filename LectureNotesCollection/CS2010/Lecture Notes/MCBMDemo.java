import java.util.*;

class MCBMDemo {
  private static Vector < Vector < IntegerPair > > AdjList = 
    new Vector < Vector < IntegerPair > >();
  private static Vector < Integer > owner, visited; // global variables

  private static int Aug(int left) {
    if (visited.get(left) == 1) return 0;
    visited.set(left, 1);

    // another way for exploring Adjacency List
    Iterator it = AdjList.get(left).iterator();
    while (it.hasNext()) { // either greedy assignment or recurse
      IntegerPair right = (IntegerPair)it.next();
      if (owner.get(right.first()) == -1 || Aug(owner.get(right.first())) == 1) {
        owner.set(right.first(), left);
        return 1; // we found one matching
      }
    }

    return 0; // no matching
  }

  public static void main(String[] args) {
/*
    // Example 3 Graph
    int V = 6, V_left = 3;
    AdjList.clear();
    for (int i = 0; i < V; i++) {
      Vector<IntegerPair> Neighbor = new Vector<IntegerPair>();
      AdjList.add(Neighbor); // store blank vector first
    }
    AdjList.get(0).add(new IntegerPair(3, 1));
    AdjList.get(0).add(new IntegerPair(4, 1));
    AdjList.get(0).add(new IntegerPair(5, 1));
*/

    // Example 5 Graph
    int V = 4, V_left = 2;
    AdjList.clear();
    for (int i = 0; i < V; i++) {
      Vector<IntegerPair> Neighbor = new Vector<IntegerPair>();
      AdjList.add(Neighbor); // store blank vector first
    }
    AdjList.get(0).add(new IntegerPair(2, 1));
    AdjList.get(0).add(new IntegerPair(3, 1));
    AdjList.get(1).add(new IntegerPair(2, 1));

    // the MCBM routine
    int cardinality = 0;
    owner = new Vector < Integer > ();
    owner.addAll(Collections.nCopies(V, -1));
    for (int left = 0; left < V_left; left++) {
      visited = new Vector < Integer > ();
      visited.addAll(Collections.nCopies(V_left, 0));
      cardinality += Aug(left);
    }

    System.out.printf("Found %d matchings\n", cardinality);
  }
}
