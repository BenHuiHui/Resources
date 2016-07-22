package sg.edu.nus.cs2020.ps9;

import java.util.*;

public class smallworld {
	public static int[][] AdjMatrix;

	public static int diameter() {
		int V = AdjMatrix.length, answer = 0;

		// **--------------------------------------------------**
		// Write your code that does not use any form of queue here
                // Moreover, your solution must run in O(V^3) even for a complete (dense) graph.



		// **--------------------------------------------------**

		return answer;
	}

	public static void main(String[] args) {
/*
 * // sample input
2

5
1 1 0 0 0
1 1 1 1 0
0 1 1 0 1
0 1 0 1 1
0 0 1 1 1

9
1 1 0 0 0 0 0 0 1
1 1 1 1 0 0 0 0 0
0 1 1 0 1 0 0 0 0
0 1 0 1 1 0 0 0 0
0 0 1 1 1 1 0 0 0
0 0 0 0 1 1 1 0 0
0 0 0 0 0 1 1 1 0
0 0 0 0 0 0 1 1 1
1 0 0 0 0 0 0 1 1
*/

		// DO NOT TOUCH THE MAIN METHOD!
		Scanner sc = new Scanner(System.in);
		int TC = sc.nextInt();

		while (TC-- > 0) {
			int V = sc.nextInt();

			AdjMatrix = new int[V][V];
			for (int i = 0; i < V; i++)
				for (int j = 0; j < V; j++)
					AdjMatrix[i][j] = sc.nextInt();

			System.out.printf("%d\n", diameter());
		}
	}
}
