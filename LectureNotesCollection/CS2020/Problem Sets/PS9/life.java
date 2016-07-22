package sg.edu.nus.cs2020.ps9;

import java.util.Collections;
import java.util.Scanner;
import java.util.Vector;

public class life {

	public static Vector<Vector<Integer>> AdjList = new Vector<Vector<Integer>>();

	// **--------------------------------------------------**
	// If you need to write additional functions or global data structure,
	// write them in between these two lines



	// **--------------------------------------------------**

	public static int numWays(int i) {
		int V = AdjList.size(), ans = 0;

		// **--------------------------------------------------**
		// Write your Dynamic Programming (DP) code here



		// **--------------------------------------------------**

		return ans;
	}

	public static void init(int V) {
		// **--------------------------------------------------**
		// If you need to initialize something before calling numWays(0)
		// write them in between these two lines



		// **--------------------------------------------------**
	}

	public static void main(String[] args) {
/*
 * // Sample Input/Output
2

7
3 1 2 5
3 2 3 4
2 3 4
1 6
1 5
1 6
		 */

		// DO NOT TOUCH THE MAIN METHOD!
		Scanner sc = new Scanner(System.in);
		int TC = sc.nextInt();

		while (TC-- > 0) {
			int V = sc.nextInt();

			AdjList.clear();
			for (int i = 0; i < V; i++) {
				Vector<Integer> Neighbor = new Vector<Integer>();
				int k = sc.nextInt();
				for (int j = 0; j < k; j++)
					Neighbor.add(sc.nextInt());
				AdjList.add(Neighbor);
			}

			init(V);

			System.out.printf("%d\n", numWays(0));
		}
	}
}
