import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class PancakeSorting {
  // if needed, declare a private data structure here that
  // is accessible to all methods in this class
  // --------------------------------------------



  // --------------------------------------------

  public PancakeSorting() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  int Sort(int N, int[] pancake) {
    int answer = 0;

    // You have to report the weight of best path from building A to building B
    //
    // write your answer here

    //------------------------------------------------------------------------- 



    //------------------------------------------------------------------------- 

    return answer;
  }

  // You can add extra function if needed
  // --------------------------------------------



  // --------------------------------------------

  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);

    int TC = sc.nextInt(); sc.nextLine(); // there will be several test cases
    while (TC-- > 0) {
      int N = sc.nextInt();
      int[] pancake = new int[N];
      for (int i = 0; i < N; i++)
        pancake[i] = sc.nextInt();
      System.out.println(Sort(N, pancake));
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    PancakeSorting psBonus = new PancakeSorting();
    psBonus.run();
  }
}
