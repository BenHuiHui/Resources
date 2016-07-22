import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class SupermarketR {
  private int N; // number of items in the supermarket. V = N+1 
  // the number of items that Steven has to buy K is always N in this problem
  private int[] X, Y; // the coordinates of N+1 items

  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  public SupermarketR() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  double Query() {
    double answer = 0.0;

    // You have to visit (and bought) all items, i.e. K = N.
    // You have to start from the leftmost item 0, go strictly left to right to the rightmost item N,
    // and then go strictly right to left back to item 0 to conclude your supermarket tour.
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
      N = sc.nextInt(); // K = N

      X = new int[N+1];
      Y = new int[N+1];
      for (int i = 0; i <= N; i++) { // do not forget to include vertex/item 0
        X[i] = sc.nextInt();
        Y[i] = sc.nextInt();
      }

      System.out.printf("%.2f\n", Query()); // minor precision error will be ignored
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    SupermarketR ps7 = new SupermarketR();
    ps7.run();
  }
}
