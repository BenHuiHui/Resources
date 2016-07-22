package sg.edu.nus.cs2020.PS7;

import java.util.*;

public class Maze1 {
  private static char maze[][];
  private static int R, C;
  
  public static void main(String[] args) throws Exception {
    // to help yourself and your tutor's, please do not touch anything in this main method
    Scanner sc = new Scanner(System.in);

/*
Sample input as shown in problem description:

4
5 10
##########
E........#
########.#
#!.......#
##########
5 10
##########
E........#
##########
#!.......#
##########
5 10
##########
E........#
########.#
#!.......E
##########
5 10
##########
E........#
#.######.#
#!.......E
##########
*/
    
    int TC = sc.nextInt();
    while (TC-- > 0) {
      R = sc.nextInt(); C = sc.nextInt();
      maze = new char[R][C + 1];
      sc.nextLine();
      for (int i = 0; i < R; i++)
        maze[i] = sc.nextLine().toCharArray();

      iii ans = nearestExit();
      if (ans.first() != -1)
        System.out.printf("%d %d %d\n", ans.first(), ans.second(), ans.third());
      else
        System.out.printf("-1\n");
    }
  }
  

  private static iii nearestExit() {
    iii ans = new iii(-1, 0, 0);

    // Implement this method
    // Input: none, but this method has access to these global variables R, C, and maze of size R * C
    //        we will not bother too much that the fact this violates "OOP" style...
    // Output: class iii is basically a triple of integers (see iii.java)
    //         if you can reach the nearest exit, then
    //           the first integer will be the minimum number of steps to reach the nearest exit, and the second and third are the coordinate (row, col) of the nearest exit
    //           these coordinates use 0-based indexing
    //         if you cannot reach the nearest exit, then
    //           the first integer must be -1, and the second and third can be any number but will be ignored

    // Then answer these questions:
    // 1. Graph Modeling
    //    a. What are the vertices and the edges of this implicit graph?
    //    b. How many edges and how many vertices are there in an R * C maze?
    //       You do not have to count the precise number! Use big O notation in terms of R and C.
    //    c. What is the graph problem that we are trying to solve here?
    //
    // 2. Graph Algorithm
    // Remember: if we can reach more than one possible exits, we must select the nearer one.
    //    a. Can you use Depth First Search (DFS) to solve this problem? Why?
    //    b. Can you use Breadth First Search (BFS) to solve this problem? Why?
    //    c. Can you use Kruskal's algorithm to solve this problem? Why?
    //    d. Can you use Bellman Ford's or Dijkstra's algorithm to solve this problem? Why?
    //--------------------------------------------------------
    
    /*
     * Answer:
     * 1. 
     *  a) vertices: each path cell; edge: the connected cell (path-path, wall-wall)
     *  b) # of edges: O(R*C) ; # of vertices: O(R*C)
     *  c) graph traversal ()
     * 2.
     *  a) Cannot, cuz DFS would go and find a path first, and then terminate
     *  b) BFS can. (a bit like flood fill) Just to search layer by layer, the first one reached is the nearest one.
     *  	(I've done this problem with BFS)
     *  c) Druskal's also can, but one need to scan through every node to calculate the path
     */
    
    
    // PUT YOUR ANSWER HERE, BETWEEN THE TWO LINES
    
    // initialization
    Queue<iii> toGo = new LinkedList<iii>();	// queue for BFS
    boolean visited[][] = new boolean[R][C];
    for(int i=0;i<R;i++){
    	Arrays.fill(visited[0], false);    	
    }
    
    int i,j = 0;
    
    // first find the starting point
    l:for(i=0;i<R;i++){
    	for(j=0;j<C;j++){
    		if(maze[i][j]=='!') break l;	
    	}
    }
    
    //System.out.println(maze[i][j]);
    // then perform a BFS
    toGo.add(new iii(0,i,j));
    
    while(!toGo.isEmpty()){
    	iii currentNode = toGo.poll();
    	visited[currentNode.second()][currentNode.third()]=true;
    	iii res = goFrom(currentNode, visited, toGo);
    	if(res!=null)	return res;
    }
    
    //--------------------------------------------------------
    
    return ans;
  }
  
  private static iii goFrom(iii currentNode, boolean[][] visited, Queue<iii> toGo){
	  int row = currentNode.second(), col = currentNode.third(), currentCost = currentNode.first();
	  int rows[] = {0,-1,0,1}, cols[] = {-1,0,1,0};
	  for(int i=0;i<4;i++){
		  iii res = goTo(row + rows[i], col + cols[i],visited,toGo,currentCost);
		  if(res!=null)	return res;
	  }
	  return null;
  }
  
  private static iii goTo(int row, int col, boolean[][] visited, Queue<iii> toGo, int currentCost){
	  if(row >=0 && col>=0 && row < R && col < C){
		  if(maze[row][col]=='E')	return new iii(currentCost+1, row, col);
		  if(maze[row][col]=='.' && visited[row][col]==false){
			  toGo.add(new iii(currentCost+1,row,col));
		  }
	  }
	  return null;
  }
}
