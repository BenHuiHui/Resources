import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class OutForAWalk {
  private int V; // number of vertices in the graph (number of rooms in the building)
  private Vector < Vector < IntegerPair > > AdjList; // the weighted graph (the building), effort rating of each corridor is stored here too

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  // --------------------------------------------

  public OutForAWalk() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  void PreProcess() {
    // write your answer here
    // you can leave this method blank if you do not need it


  }

  int Query(int source, int destination) {
    int answer = 0;

    // You have to report the weight of a corridor (an edge)
    // which has the highest effort rating in the easiest path from source to destination for Grace
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

      // clear the graph and read in a new graph as Adjacency List
      AdjList = new Vector < Vector < IntegerPair > >();
      for (int i = 0; i < V; i++) {
        AdjList.add(new Vector<IntegerPair>());

        int k = sc.nextInt();
        while (k-- > 0) {
          int j = sc.nextInt(), w = sc.nextInt();
          AdjList.get(i).add(new IntegerPair(j, w)); // edge (corridor) weight (effort rating) is stored here
        }
      }

      PreProcess(); // you may want to use this function or leave it empty if you do not need it

      int Q = sc.nextInt();
      while (Q-- > 0)
        System.out.println(Query(sc.nextInt(), sc.nextInt()));
      System.out.println(); // separate the answer between two different graphs
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    OutForAWalk ps4 = new OutForAWalk();
    ps4.run();
  }
}
