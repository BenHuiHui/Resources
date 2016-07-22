import java.io.*;
import java.util.*;

public class Graph {
  private Vector < Vector < ii > > AdjList;
  private int V;
  private static boolean cyclic;

  public static void main(String[] args) throws Exception {
    // to help yourself and your tutor, please do not touch anything in this main method
    // except to change the file path
    Scanner sc = new Scanner(new File("g1.txt"));

    int numV = sc.nextInt();
    Graph G = new Graph(numV);
    for (int i = 0; i < numV; i++) {
      int k = sc.nextInt();
      while (k-- > 0) {
        int j = sc.nextInt(), w = sc.nextInt();
        G.AddEdge(i, j, w);
      }
    }
    
    G.printAdjList();

    int AM[][] = G.convert();
    for (int i = 0; i < AM.length; i++) {
      System.out.print(AM[i][0]);
      for (int j = 1; j < AM[i].length; j++) {
        System.out.print(" " + AM[i][j]);
      }
      System.out.println();
    }
    
    AM = G.transpose(AM);
    System.out.println("After Transpose:");
    for (int i = 0; i < AM.length; i++) {
      System.out.print(AM[i][0]);
      for (int j = 1; j < AM[i].length; j++) {
        System.out.print(" " + AM[i][j]);
      }
      System.out.println();
    }
    
    System.out.println("In  : " + G.countDegrees(0, 3));
    System.out.println("Out : " + G.countDegrees(1, 3));

    System.out.println("Acylic : " + G.isAcyclic());
  }
  
  public Graph() { // default constructor
    AdjList = new Vector < Vector < ii > >();
    V = 0;
  }
  
  public Graph(int _V) {
    AdjList = new Vector < Vector < ii > >();
    V = _V;
    for (int i = 0; i < V; i++)
      AdjList.add(new Vector<ii>());
  }
  
  public void AddEdge(int u, int v, int w) {
    AdjList.get(u).add(new ii(v, w));
  }
  
  public void printAdjList() {
    System.out.println("V = " + V);
    for (int i = 0; i < V; i++) {
      System.out.print(AdjList.get(i).size());
      for (int j = 0; j < AdjList.get(i).size(); j++) {
        ii v = AdjList.get(i).get(j);
        System.out.print(" (" + v.first() + "," + v.second() + ")");
      }
      System.out.println();
    }
  }

  public int[][] convert() {
    int AdjMatrix[][] = new int[1][1];
    
    // Implement adjacency list to adjacency matrix conversion here
    // the adjacency list is stored in variable AdjList
    // returns a 2-d array of size V * V

    // Then answer these questions:
    // 1. What is the time complexity of your algorithm?
    // 2. Will your conversion algorithm works for each g1.txt, g2.txt, and g3.txt? Why?
    //--------------------------------------------------------
    // PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!



    //--------------------------------------------------------
    
    return AdjMatrix;
  }

  public int[][] transpose(int AdjMatrix[][]) {
    int NewAdjMatrix[][] = new int[1][1];

    // Implement graph transpose here
    // the AdjMatrix after transpose has exactly the same size as the original

    // Then answer these questions:
    // 1. What is the time complexity of your algorithm?
    // 2. Apply your algorithm to g1.txt and then to g2.txt. Is there any phenomenon that you can you see? Elaborate!
        
    //--------------------------------------------------------
    // PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!



    //--------------------------------------------------------
    
    return NewAdjMatrix;
  }
  
  public int countDegrees(int mode, int vtx) {  
    // Implement count (in/out) degrees here
    // if mode == 0, count in-degrees of vertex 'vtx'
    // if mode == 1, count out-degrees of vertex 'vtx'
  
    // Then answer these questions:
    // 1. What is the time complexity of your algorithm?
    // 2. Which mode is `computationally harder' to compute? Why?
        
    //--------------------------------------------------------
    // PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!



    //--------------------------------------------------------

    return 0;
  }
  
  public boolean isAcyclic() {  
    // Implement cyclic test here
    // returns true if the AdjList represents an acylic graph
    // returns false otherwise
  
    // Then answer these questions:
    // 1. What is the time complexity of your algorithm?
    // 2. Which input file is acyclic? g1.txt or g2.txt?
        
    cyclic = false;

    //--------------------------------------------------------
    // PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!



    //--------------------------------------------------------

    return !cyclic;
  }
}
