import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class Labor {
  private int V; // number of vertices in the graph (number of junctions in Singapore map)
  private Vector < Vector < IntegerPair > > AdjList; // the weighted graph (the Singapore map), the length of each edge (road) is stored here too, as the weight of edge

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  // --------------------------------------------

  public Labor() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  int Query() {
    int answer = 0;

    // You have to report the shortest path from Steven and Grace's home (vertex 0)
    // to reach their chosen hospital (vertex 1)
    //
    // write your answer here



    //------------------------------------------------------------------------- 

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
          AdjList.get(i).add(new IntegerPair(j, w)); // edge (road) weight (length of road) is stored here
        }
      }

      System.out.println(Query());
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    Labor ps5 = new Labor();
    ps5.run();
  }
}
