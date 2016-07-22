import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class Supermarket {
  private int N; // number of items in the supermarket. V = N+1 
  private int K; // the number of items that Steven has to buy
  private int[] shoppingList; // indices of items that Steven has to buy
  private int[][] T; // the complete weighted graph that measures the direct walking time to go from one point to another point in seconds

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  public Supermarket() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  int Query() {
    int answer = 0;

    // You have to report the quickest shopping time that is measured
    // since Steven enters the supermarket (vertex 0),
    // completes the task of buying K items in that supermarket as ordered by Grace,
    // then, reaches the cashier of the supermarket (back to vertex 0).
    //
    // write your answer here



    return answer;
  }

  // You can add extra function if needed
  // --------------------------------------------



  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);

    int TC = sc.nextInt(); // there will be several test cases
    while (TC-- > 0) {
      // read the information of the complete graph with N+1 vertices
      N = sc.nextInt(); K = sc.nextInt(); // K is the number of items to be bought

      shoppingList = new int[K];
      for (int i = 0; i < K; i++)
        shoppingList[i] = sc.nextInt();

      T = new int[N+1][N+1];
      for (int i = 0; i <= N; i++)
        for (int j = 0; j <= N; j++)
          T[i][j] = sc.nextInt();

      System.out.println(Query());
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    Supermarket ps7 = new Supermarket();
    ps7.run();
  }
}
