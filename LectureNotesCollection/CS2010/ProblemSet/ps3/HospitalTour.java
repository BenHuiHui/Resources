import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class HospitalTour {
  private int V; // number of vertices in the graph (number of rooms in the hospital)
  private int[][] AdjMatrix; // the graph (the hospital)
  private Vector < Integer > RatingScore; // the weight of each vertex (rating score of each room)

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class

  public HospitalTour() {
    // Write necessary codes during construction
    //
    // write your answer here



  }

  int Query() {
    int answer = 0;

    // You have to report the rating score of the important room (vertex)
    // with the lowest rating score in this hospital
    //
    // or report -1 if that hospital has no important room
    //
    // write your answer here



    return answer;
  }

  // You can add extra function if needed
  // --------------------------------------------



  // --------------------------------------------

  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);

    int TC = sc.nextInt(); // there will be several test cases
    while (TC-- > 0) {
      V = sc.nextInt();

      // read rating scores, A (index 0), B (index 1), C (index 2), ..., until the V-th index
      RatingScore = new Vector < Integer > ();
      for (int i = 0; i < V; i++)
        RatingScore.add(sc.nextInt());

      // clear the graph and read in a new graph as Adjacency Matrix
      AdjMatrix = new int[V][V];
      for (int i = 0; i < V; i++) {
        int k = sc.nextInt();
        while (k-- > 0) {
          int j = sc.nextInt();
          AdjMatrix[i][j] = 1; // edge weight is always 1 (the weight is on vertices now)
        }
      }

      System.out.println(Query());
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    HospitalTour ps3 = new HospitalTour();
    ps3.run();
  }
}
