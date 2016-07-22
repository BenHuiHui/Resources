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

    // PUT YOUR ANSWER HERE, BETWEEN THE TWO LINES

    //--------------------------------------------------------
    
    return ans;
  }
}
