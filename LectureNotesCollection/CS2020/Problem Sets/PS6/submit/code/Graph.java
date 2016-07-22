package sg.edu.nus.cs2020.PS6;

import java.io.*;
import java.util.*;

public class Graph {
	private Vector<Vector<ii>> AdjList;

	/**
	 * the number of vertexes
	 */
	private int V;

	private static boolean cyclic;

	public static void main(String[] args) throws Exception {
		// to help yourself and your tutor, please do not touch anything in this
		// main method
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
		AdjList = new Vector<Vector<ii>>();
		V = 0;
	}

	public Graph(int _V) {
		AdjList = new Vector<Vector<ii>>();
		V = _V;
		for (int i = 0; i < V; i++)
			AdjList.add(new Vector<ii>());
	}

	/**
	 * @param u
	 *            - the starting vertex index
	 * @param v
	 * @param w
	 */
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

	/**
	 * convert the default adjacency list already implemented in Graph.java as
	 * private Vector < Vector < ii > > AdjList; into an adjacency matrix
	 * 
	 * @return
	 */
	public int[][] convert() {
		int AdjMatrix[][] = new int[V][V];

		// Implement adjacency list to adjacency matrix conversion here
		// the adjacency list is stored in variable AdjList
		// returns a 2-d array of size V * V

		// Then answer these questions:
		// 1. What is the time complexity of your algorithm?
		// 2. Will your conversion algorithm works for each g1.txt, g2.txt, and
		// g3.txt? Why?
		// --------------------------------------------------------
		// PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!
		/*
		 * 1. time complexity: O(V + E), where V is the total number of
		 * vertexes, while E is the total number of edges
		 * 
		 * 2. After testing, it works well for all three of them... Though for
		 * g3, the Array size is extremely large
		 */
		for (int i = 0; i < V; i++) {
			for (int j = 0; j < AdjList.get(i).size(); j++) {
				ii v = AdjList.get(i).get(j);
				AdjMatrix[i][v.first()] = v.second();
			}
		}

		// --------------------------------------------------------

		return AdjMatrix;
	}

	/**
	 * @param AdjMatrix
	 * @return a direct graph all of the edges reversed compared to the
	 *         orientation of the corresponding edges in G.
	 */
	public int[][] transpose(int AdjMatrix[][]) {
		int NewAdjMatrix[][] = new int[V][V];

		// Implement graph transpose here
		// the AdjMatrix after transpose has exactly the same size as the
		// original

		// Then answer these questions:
		// 1. What is the time complexity of your algorithm?
		// 2. Apply your algorithm to g1.txt and then to g2.txt. Is there any
		// phenomenon that you can you see? Elaborate!

		// --------------------------------------------------------
		// PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!
		/*
		 * 1. time complexity: O(V^2) (where V is the total number of vertexes)
		 * 2. the transpose of a matrix is the reflection over the diagonal
		 * which is from the top left corner to the bottom right corner - i.e.,
		 * the in edge becomes the out edge, while the out edge becomes the in
		 * edge
		 */
		for (int i = 0; i < V; i++) {
			for (int j = 0; j < V; j++) {
				NewAdjMatrix[i][j] = AdjMatrix[j][i];
			}
		}

		// --------------------------------------------------------

		return NewAdjMatrix;
	}

	/**
	 * @param mode
	 *            - 0 for computing in-degrees, 1 for computing out-degrees
	 * @param vtx
	 *            - vertex number
	 * @return - the number of in (or out { depending on the mode) degrees of a
	 *         certain vertex; -1 if the mode is wrong
	 */
	public int countDegrees(int mode, int vtx) {
		// Implement count (in/out) degrees here
		// if mode == 0, count in-degrees of vertex 'vtx'
		// if mode == 1, count out-degrees of vertex 'vtx'

		// Then answer these questions:
		// 1. What is the time complexity of your algorithm?
		// 2. Which mode is `computationally harder' to compute? Why?

		// --------------------------------------------------------
		// PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!
		/*
		 * 1. Time Complexity: a) in-mode: O(V + E): it would go through all the
		 * edges and vertexes b) out-mode: O(1): simply the size of the vector
		 * lest corresponding to vtx
		 */

		int count = 0;

		// count the in degree
		if (mode == 0) {
			count = 0;
			for (int i = 0; i < V; i++) {
				for (int j = 0; j < AdjList.get(i).size(); j++) {
					if (AdjList.get(i).get(j).first() == vtx)
						count++;
				}
			}
			return count;
		}

		// count the out degree
		else if (mode == 1) {
			return AdjList.get(vtx).size();
		}

		else
			return -1;

		// --------------------------------------------------------

	}

	/**
	 * @return - true if the AdjList represents an acyclic graph
	 */
	public boolean isAcyclic() {
		// Implement cyclic test here
		// returns true if the AdjList represents an acyclic graph
		// returns false otherwise

		// Then answer these questions:
		// 1. What is the time complexity of your algorithm?
		// 2. Which input file is acyclic? g1.txt or g2.txt?

		cyclic = false;

		// --------------------------------------------------------
		// PUT YOUR ANSWER ONLY BETWEEN THESE TWO LINES!!
		/*
		 * 1. Time Complexity: [O(DFS) + O( V+ E )] * O(V) = O(V^2 + V*E)
		 * 2. g1.txt is acyclic
		 */

		for (int i = 0; i < V; i++) {
			// create a list to note if the vertex is visited or not, and
			// initialize all elements to false
			boolean visited[] = new boolean[V];
			boolean cyclicVertex[] = new boolean[V];
			for (int t = 0; t < V; t++){
				visited[t] = false;
				cyclicVertex[t] = false;
			}
			
			// perform a DFS
			checkCyclic(i,visited,cyclicVertex);
			
			for(int j=0;j<V;j++){
				if(cyclicVertex[j]==true){
					for(int t=0;t<AdjList.get(j).size();t++){
						if(AdjList.get(j).get(t).first() == i)	return !(cyclic = true);						
					}
				}
			}
		}

		// --------------------------------------------------------
		return !cyclic;
	}
	
	/**
	 * @param vertexIndex - the index of the starting vertex
	 * @param visited - the array which marks the visited array; would be modified
	 * @param singlePathVertex - the array noted down which vertex (by index) has been revisited
	 */
	private void checkCyclic(int vertexIndex, boolean visited[], boolean singlePathVertex[]){
		for(int i=0;i<AdjList.get(vertexIndex).size();i++){
			int v = AdjList.get(vertexIndex).get(i).first();
			if(visited[v] == true){
				singlePathVertex[v] = true;
			} else{
				visited[v] = true;
				checkCyclic(v, visited, singlePathVertex);
			}
		}
	}
	
}
