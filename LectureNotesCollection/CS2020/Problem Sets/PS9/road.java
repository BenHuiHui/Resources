package sg.edu.nus.cs2020.ps9;

import java.util.*;

public class road {
	public static Vector<Vector<ii>> AdjList = new Vector<Vector<ii>>();
	public static Vector<Integer> T = new Vector<Integer>();

	// **--------------------------------------------------**
	// If you need to write additional functions or global data structure,
	// write them in between these two lines



	// **--------------------------------------------------**

	public static int shortestTime() {
		int V = AdjList.size(), longest = -1;

		// **--------------------------------------------------**
		// Write your code that uses topological sort here



		// **--------------------------------------------------**

		return longest;
	}

	public static void main(String[] args) {
/*
 * // Sample Input/Output
2

3 2
0 1
0 2
10 10 20

4 4
0 1
0 2
1 3
2 3
10 10 20 10
*/

		// DO NOT TOUCH THE MAIN METHOD!
		Scanner sc = new Scanner(System.in);

		int TC = sc.nextInt();
		while (TC-- > 0) {
			int V = sc.nextInt(), E = sc.nextInt();

			AdjList.clear();
			for (int i = 0; i < V; i++) {
				Vector<ii> Neighbor = new Vector<ii>();
				AdjList.add(Neighbor);
			}

			for (int i = 0; i < E; i++) {
				int u = sc.nextInt(), v = sc.nextInt();
				AdjList.get(u).add(new ii(v, 1)); // weight is always 1 in this
													// problem
			}

			T.clear();
			for (int i = 0; i < V; i++)
				T.add(sc.nextInt());

			System.out.printf("%d\n", shortestTime());
		}
	}
}
