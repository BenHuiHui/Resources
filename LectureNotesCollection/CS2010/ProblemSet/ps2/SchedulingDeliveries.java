import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class SchedulingDeliveries {
  // if needed, declare a private data structure here that
  // is accessible to all methods in this class

  public SchedulingDeliveries() {
    // Write necessary codes during construction;
    //
    // write your answer here



  }

  void ArriveAtHospital(String womanName, int dilation) {
    // You have to insert the information (womanName, dilation)
    // into your chosen data structure
    //
    // write your answer here



  }

  void UpdateDilation(String womanName, int increaseDilation) {
    // You have to update the dilation of womanName to
    // dilation += increaseDilation
    // and modify your chosen data structure (if needed)
    //
    // write your answer here



  }

  void GiveBirth(String womanName) {
    // This womanName gives birth 'instantly'
    // remove her from your chosen data structure
    //
    // write your answer here



  }

  String Query() {
    String answer = "The delivery suite is empty";

    // You have to report the name of the woman that the doctor
    // has to give the most attention to. If there is no more woman to
    // be taken care of, return a String "The delivery suite is empty"
    //
    // write your answer here



    return answer;
  }

  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);
    int N = sc.nextInt();
    while (N-- > 0) {
      int cmd = sc.nextInt();
      switch (cmd) {
        case 0: ArriveAtHospital(sc.next(), sc.nextInt()); break;
        case 1: UpdateDilation(sc.next(), sc.nextInt()); break;
        case 2: GiveBirth(sc.next()); break;
        case 3: System.out.println(Query()); break;
      }
    }
  }

  public static void main(String[] args) {
    // do not alter this method
    SchedulingDeliveries ps2 = new SchedulingDeliveries();
    ps2.run();
  }
}
