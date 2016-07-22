import java.util.*;

public class FloydWarshallDemo {
  private static int[][] p;

  private static void printMatrix(int[][] m) { // double[][] m) {
    for (int i = 0; i < m.length; i++) {
      for (int j = 0; j < m[i].length; j++)
        System.out.printf("%d ", m[i][j]);
        //System.out.printf("%.4f ", m[i][j]);
      System.out.printf("\n");
    }
    System.out.printf("\n");
  }

  private static void print_path(int i, int j) {
    if (i != j)
      print_path(i, p[i][j]);
    System.out.printf("%d ", j);
  }
  
  public static void main(String[] args) {
/*
// graph shown in lecture, slide 17-23
5 9
0 1 2
0 2 1
0 4 3
1 3 4
2 1 1
2 4 1
3 0 1
3 2 3
3 4 5
*/
    Scanner sc = new Scanner(System.in);
    int i, j, k, u, v, w, V = sc.nextInt(), E = sc.nextInt();


/*
    // the "memory unfriendly" version, O(V^3) space complexity
    int[][][] D3 = new int[V+1][V][V]; // 3D matrix
    for (k = 0; k <= V; k++) // initialization phase
      for (i = 0; i < V; i++) {
        Arrays.fill(D3[k][i], 1000000000); // cannot use nCopies
        D3[k][i][i] = 0;
      }

    for (i = 0; i < E; i++) { // direct edges
      u = sc.nextInt(); v = sc.nextInt(); w = sc.nextInt();
      D3[0][u][v] = w; // directed weighted edge
    }

    printMatrix(D3[0]);
    // main loop, O(V^3)
    for (k = 0; k < V; k++) { // be careful, put k first
      for (i = 0; i < V; i++) // before i
        for (j = 0; j < V; j++) // and then j
          D3[k+1][i][j] = Math.min(D3[k][i][j],
                                   D3[k][i][k] + D3[k][k][j]);
      printMatrix(D3[k+1]);
    }
*/


    // the "memory friendly" version, O(V^2) space complexity, dropping dimension 'k'
    int[][] D = new int[V][V];
    //double[][] D = new double[V][V];
    //p = new int[V][V];
    
    for (i = 0; i < V; i++) {
      Arrays.fill(D[i], 1000000000); // initialize every cell with huge number, 1B is a good value (to avoid trivial overflow)
      //Arrays.fill(D[i], 0);
      //Arrays.fill(D[i], 0.0);
      D[i][i] = 0;
      //D[i][i] = 1.0;
      //for (j = 0; j < V; j++)
      //  p[i][j] = i;
    }

    for (i = 0; i < E; i++) { // fill in D with the weight of direct edges (or k = -1)
      u = sc.nextInt(); v = sc.nextInt(); w = sc.nextInt();
      D[u][v] = w; // directed weighted edge      
    }
    
    printMatrix(D);
    for (k = 0; k < V; k++) {
      //printMatrix(D);
      for (i = 0; i < V; i++)
        for (j = 0; j < V; j++)
          /*if (D[i][k] * D[k][j] > D[i][j]) {
            D[i][j] = D[i][k] * D[k][j];
            p[i][j] = p[k][j];
          }*/
          /*if (Math.max(D[i][k], D[k][j]) < D[i][j]) {
            D[i][j] = Math.max(D[i][k], D[k][j]);
            p[i][j] = p[k][j];
          }*/
          //D[i][j] = D[i][j] | (D[i][k] & D[k][j]);
          /*if (D[i][k] + D[k][j] < D[i][j]) {
            D[i][j] = D[i][k] + D[k][j];
            p[i][j] = p[k][j];
          }*/
          D[i][j] = Math.min(D[i][j], D[i][k] + D[k][j]);
      //printMatrix(D);
    }

    printMatrix(D);
    System.out.printf("\n");
  }
}
