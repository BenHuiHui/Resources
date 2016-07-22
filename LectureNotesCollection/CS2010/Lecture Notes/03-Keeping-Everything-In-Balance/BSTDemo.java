import java.util.*;

// run this demo via:
// javac BSTDemo.java
// java BSTDemo < BSTInput.txt

class BSTDemo {
  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    BST T = new BST();                                           // an empty BST
    int n = sc.nextInt(), key;
    while (n-- > 0) {
      key = sc.nextInt();
      T.insert(key);
    }

    System.out.println(T.search(71));                               // found, 71
    System.out.println(T.search(7));                                 // found, 7
    System.out.println(T.search(22));                           // not found, -1

    T.inorder();                          // The BST: 4, 5, 6, 7, 15, 23, 50, 71

    System.out.println(T.findMin());                                        // 4
    System.out.println(T.findMax());                                       // 71

    System.out.println(T.successor(23));                                   // 50
    System.out.println(T.successor(7));                                    // 15
    System.out.println(T.successor(71));                                   // -1
    System.out.println(T.predecessor(23));                                 // 15
    System.out.println(T.predecessor(7));                                   // 6
    System.out.println(T.predecessor(71));                                 // 50

    System.out.println("---");
    n = sc.nextInt();
    while (n-- > 0) {
      key = sc.nextInt();
      T.delete(key);
    }

    T.inorder();
  }
}
