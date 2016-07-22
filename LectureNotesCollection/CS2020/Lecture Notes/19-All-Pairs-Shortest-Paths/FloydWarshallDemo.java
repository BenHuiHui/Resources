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
// graph shown in lecture, slide 16
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
    int[][] D = new int[V][V];
    //double[][] D = new double[V][V];
    p = new int[V][V];
    
    for (i = 0; i < V; i++) {
      Arrays.fill(D[i], 1000000000); // initialize every cell with huge number, 1B is a good value (to avoid trivial overflow)
      //Arrays.fill(D[i], 0);
      //Arrays.fill(D[i], 0.0);
      D[i][i] = 0;
      //D[i][i] = 1.0;
      for (j = 0; j < V; j++)
        p[i][j] = i;
    }

    for (i = 0; i < E; i++) { // fill in D with the weight of direct edges (or k = -1)
      u = sc.nextInt(); v = sc.nextInt(); w = sc.nextInt();
      D[u][v] = w; // / 10.0; // directed weighted edge      
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
      printMatrix(D);
    }

    //printMatrix(p);
    print_path(1, 4);
    System.out.printf("\n");
  }
}
