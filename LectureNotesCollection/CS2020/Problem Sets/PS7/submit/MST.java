package sg.edu.nus.cs2020.PS7;

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
5 3 3
0 1 0
0 2 0
1 2 0
2 3 5
0 3 7
1 3 10
*/

    int M, K;
    Scanner sc = new Scanner(System.in);
    // N villages, M roads already, K roads to choose   
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
    
    /* Answer:
     * 1. I'll make use of the "union find", which would put each part of the connected into one union
     * 2. If after going through all the edges, the graph is still not connected, then it's # of edges would be less than (# of nodes -1)
	 * 		another way (faster): check if the num of edges is n-1.
     * 3. Kruskal's. Because I think it's easier to implement : ) 
     */
    
    // PUT YOUR ANSWER HERE, BETWEEN THE TWO LINES
    
    // Sort the Edge list
    Collections.sort(EdgeList);
    
    // perform a Kruskal's:
    int numOfEdges = 0;	// counter
    UnionFind sets = new UnionFind(N);
    for(int i=0;i<N;i++){
    	iii currentEdge = EdgeList.get(i);
    	if(!sets.isSameSet(currentEdge.second(), currentEdge.third())){
    		sets.unionSet(currentEdge._second,currentEdge._third);
        	cost += currentEdge._first;
        	numOfEdges++;
    	}
    }
    
    // determine whether the graph is connected
    if(numOfEdges<N-1)	return -1;

    //--------------------------------------------------------
    
    return cost;
  }
}
