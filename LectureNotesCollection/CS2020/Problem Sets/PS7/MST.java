import java.util.*;

public class MST {
  private static Vector < iii > EdgeList;
  private static int N;

  public static void main(String[] args) {
/*
// first test case, output: 6
5 3 4
0 1 0
0 2 0
1 2 0
2 3 5
0 3 7
1 3 10
3 4 1

// second test case, output: -1
5 2 3
0 1 0
0 2 0
1 2 0
2 3 5
0 3 7
1 3 10
*/

    int M, K;
    Scanner sc = new Scanner(System.in);
    N = sc.nextInt(); M = sc.nextInt(); K = sc.nextInt();
    EdgeList = new Vector < iii >();

    for (int i = 0; i < M + K; i++) { // the first M lines are for existing roads, the remaining K lines are for additional roads
      int u = sc.nextInt(), v = sc.nextInt(), w = sc.nextInt();
      EdgeList.add(new iii(w, u, v)); // all edges are inserted sequentially in this format (w, u, v)!
    }

    System.out.printf("%d\n", minCost());
  }

  @SuppressWarnings("unchecked") // for Collections.sort, if you use it
  private static int minCost() {
    int cost = 0;

    // Implement this method
    // Input: none, but this method has access to these global variables N and EdgeList
    //        we will not bother too much that the fact this violates "OOP" style...
    // Output: the minimum cost to make the N villages connected
    //         or -1 if it is not possible to do so.

    // Then answer these questions:
    // 1. What is your strategy to deal with the M existing roads with cost 0?
    //    Remember that these M existing roads form a general graph!
    // 2. How to determine whether it is possible to build a connected MST?
    //    Hint: This part is discussed in DG6.
    // 3. Which algorithm that you use to solve this `modified' MST: Prim's or Kruskal's?
    //    Why do you choose that particular algorithm?
    //--------------------------------------------------------


    // PUT YOUR ANSWER HERE, BETWEEN THE TWO LINES


    //--------------------------------------------------------
    
    return cost;
  }
}
