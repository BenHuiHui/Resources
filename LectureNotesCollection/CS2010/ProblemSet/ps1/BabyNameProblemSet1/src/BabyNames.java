import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class BabyNames {
  // if needed, declare a private data structure here that
	BSTofBabyNames T=new BSTofBabyNames();
  // is accessible to all methods in this class

  public BabyNames() {
    // Write necessary codes during construction;
    //
    // write your answer here
	


  }

  void AddSuggestion(String babyName, int genderSuitability) {
    // You have to insert the information (babyName, genderSuitability)
    // into your chosen data structure
    //
    // write your answer here

	T.insert(babyName,genderSuitability);
	

  }

  int Query(String START, String END, int genderPreference) {
    int count = 0;

    // You have to answer how many baby names starts
    // with prefix that is inside query interval [START..END)
    //
    // write your answer here
  // T.inorder(START, END, genderPreference);
    
    T.inorderSolutionFast(START, END, genderPreference);
    count=T.count;

    return count;
  }

  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);
    int N = sc.nextInt();
    while (N-- > 0)
      AddSuggestion(sc.next(), sc.nextInt());

    int Q = sc.nextInt();
    while (Q-- > 0)
      System.out.println(Query(sc.next(),      // START
                               sc.next(),      // END
                               sc.nextInt())); // GENDER
    
    sc.close();
  }

  public static void main(String[] args) {
    // do not alter this method
    BabyNames ps1 = new BabyNames();
    ps1.run();
  }
}
