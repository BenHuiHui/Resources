package sg.edu.nus.cs2020.PS8;

import java.util.*;

public class Maze2 {
  private static char maze[][];
  private static int R, C;
  
  public static void main(String[] args) throws Exception {
    // to help yourself and your tutor's, please do not touch anything in this main method
    Scanner sc = new Scanner(System.in);

/*
Sample input as shown in problem description:

5
5 10
##########
E11111111#
########1#
#!1111111#
##########
5 9
####E####
#2221333#
#2#####3#
#222!333#
#########
5 9
####E####
#2221333#
#2#####3#
#222!333E
#########
5 9
####E####
#1111999#
#1#####9#
#111!999E
#########
3 9
#########
#!#11111E
#########
*/

    int TC = sc.nextInt();
    while (TC-- > 0) {
      R = sc.nextInt(); C = sc.nextInt();
      maze = new char[R][C + 1];
      sc.nextLine();
      for (int i = 0; i < R; i++)
        maze[i] = sc.nextLine().toCharArray();

      iii ans = minCostExit();
      if (ans.first() != -1)
        System.out.printf("%d %d %d\n", ans.first(), ans.second(), ans.third());
      else
        System.out.printf("-1\n");
    }
  }
  
  private static iii minCostExit() {
    iii ans = new iii(-1, 0, 0);

    // Implement this method
    // Input: none, but this method has access to these global variables R, C, and maze of size R * C
    //        we will not bother too much that the fact this violates "OOP" style...
    // Output: class iii is basically a triple of integers (see iii.java)
    //         if you can reach the mincost exit, then
    //           the first integer will be the minimum number of steps to reach the mincost exit, and the second and third are the coordinate (row, col) of the mincost exit
    //           these coordinates use 0-based indexing
    //         if you cannot reach the mincost exit, then
    //           the first integer must be -1, and the second and third can be any number but will be ignored

    // Then answer these questions:
    // 1. Graph Modeling
    //    a. What are the vertices and the edges of this implicit graph?
    //    b. How are you going to represent the 'weight'? Is it on the vertex or is it on the edges?
    //    c. How many edges and how many vertices are there in an R * C maze?
    //       You do not have to count the precise number! Use big O notation in terms of R and C.
    //    d. What is the graph problem that we are trying to solve here?
    //
    // 2. Graph Algorithm
    // Remember: if we can reach more than one possible exits, we must select the nearer one.
    //    a. Can you use Depth First Search (DFS) to solve this problem? Why?
    //    b. Can you use Breadth First Search (BFS) to solve this problem? Why?
    //    c. Can you use Kruskal's algorithm to solve this problem? Why?
    //    d. Can you use Bellman Ford's algorithm to solve this problem? Why?
    //    e. Can you use Dijkstra's algorithm to solve this problem? Why?
    //--------------------------------------------------------
    
    // PUT YOUR ANSWER HERE, BETWEEN THE TWO LINES
    /*
     * 1. a) vertexes: each cell; edge: one cell to another;
     *    b) weight: the cost of each cell. It's on the edge
     *    c) Vertexes: O(R*C);	edge: O(4RC)
     *    d) Single Source Shortest Path
     *    
     * 2. a) DFS can: simply by going through all the possible roads; but it would 
     * 			use lots of storage and time
     *    b) BFS can: due to the same reason as DFS, would not use BFS also; in addition, since
     *    		the graph is weighted, cannot use the that BFS for unweighed graph.  
     *    c) Kruskal's cannot, cuz it's not about finding MST, it's about SSSP
     *    d) Bellman FOrd's can, but it's slow.
     *    e) Dijkstra's can do, in O( (V + E) * log(V)) time; but need to store the exit
     */
    PriorityQueue<iii> queue = new PriorityQueue<iii>();
    PriorityQueue<iii> ansQueue = new PriorityQueue<iii>();
    iii temp;
    
    // first find the starting point
    int a=0,b = 0;
    l:for(a=0;a<R;a++){
    	for(b=0;b<C;b++){
    		if(maze[a][b]=='!') break l;	
    	}
    }
    
    // then perform a Dijkstral's from the starting point
    	// initialize cost array D; set -1 as unvisited
    int[][] D = new int[R][C];
    for(int i=0;i<R;i++)    Arrays.fill(D[i],-1);
    
    D[a][b] = 0; 
    addSurroundingCell(a,b,D,queue,ansQueue);
    
    while(!queue.isEmpty()){
    	iii node = queue.poll();
    	addSurroundingCell(node.second(), node.third(), D, queue,ansQueue);
    }
    
    //--------------------------------------------------------
    if(ansQueue.isEmpty())return ans;
    else return ansQueue.poll();
  }
  
  private static void addSurroundingCell(int a,int b, int[][] D, PriorityQueue<iii> queue, PriorityQueue<iii> ansQueue){
	  int row[] = {0,-1,0,1}, col[] = {-1,0,1,0};
	  for(int i=0;i<4;i++){
		  int a0 =a+row[i], b0 = b+col[i];
		  if(maze[a0][b0]=='E'){	// first check if this is the ending
			  if(D[a0][b0]<0){
				  D[a0][b0]=D[a][b]+1;
				  ansQueue.offer(new iii(D[a0][b0],a0,b0));
			  }
		  } 
		  
		  if(Character.isDigit(maze[a0][b0])){
			  int cost = (int)(maze[a0][b0]-'0');
			  if(D[a0][b0]<0){
				  D[a0][b0] = D[a][b] + cost;
				  queue.offer(new iii(cost ,a0,b0));
			  } else if(D[a0][b0] > D[a][b] + cost){
				  D[a0][b0] = D[a][b] + cost;
			  }
		  }
	  }
  }
}
