import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class Caesarean {
  private int V; // number of vertices in the graph (steps of a Caesarean section surgery)
  private int E; // number of edges in the graph (dependency information between various steps of a Caesarean section surgery)
  private Vector < IntegerPair > EL; // the unweighted graph, an edge (u, v) in EL implies that step u must be performed before step v
  private Vector < Integer > estT; // the estimated time to complete each step

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  // --------------------------------------------

  public Caesarean() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  int Query() {
    int answer = 0;

    // You have to report the quickest time to complete the whole Caesarean section surgery
    // (from vertex 0 to vertex V-1)
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
      V = sc.nextInt(); E = sc.nextInt(); // read V and then E

      estT = new Vector < Integer > ();
      for (int i = 0; i < V; i++)
        estT.add(sc.nextInt());

      // clear the graph and read in a new graph as an unweighted Edge List (only using IntegerPair, not IntegerTriple)
      EL = new Vector < IntegerPair > ();
      for (int i = 0; i < E; i++)
        EL.add(new IntegerPair(sc.nextInt(), sc.nextInt())); // just directed edge (u -> v)

      System.out.println(Query());
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    Caesarean ps6 = new Caesarean();
    ps6.run();
  }
}
