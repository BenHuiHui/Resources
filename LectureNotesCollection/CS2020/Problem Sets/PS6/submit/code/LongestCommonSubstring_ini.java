package sg.edu.nus.cs2020.PS6;

import java.util.Scanner;
import java.io.File;
import java.util.HashMap;

public class LongestCommonSubstring_ini {

	// In your submission, do not modify the main routine.
	public static void main(String[] args) {
		String A = readFile("A.txt");
		String B = readFile("B.txt");

		String commonSubstring = LCS(A, B);
		System.out.println(commonSubstring);
	}

	/**
	 * this would find the index in B of the common substring with length L
	 * 
	 * @param A
	 * @param B
	 * @param L
	 * @return - the index of the common substring in B, with length L; -1 if
	 *         there doesn't exist such String
	 */

	public static int existsSubstring(String A, String B, int L) {

		/* This is the old code I've implemented with HashMap */
		HashMap<String, Object> m = new HashMap<String, Object>();
		for (int i = 0; i < A.length() - L + 1; i++) {
			m.put(A.substring(i, i + L), null);
		}
		for (int i = 0; i < B.length() - L + 1; i++) {
			if (m.containsKey(B.substring(i, i + L))) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * @param A
	 * @param B
	 * @return -the longest common substring of the two strings.
	 */
	public static String LCS(String A, String B) {
		int UpperBond = Math.min(A.length(), B.length());
		return LCS_BinarySearch(A, B, 0, UpperBond);

	}

	/**
	 * a private function used to perform a binary search for longest common
	 * substring
	 * 
	 * @param A
	 * @param B
	 * @param start
	 * @param end
	 * @return
	 */
	private static String LCS_BinarySearch(String A, String B, int start,
			int end) {
		int middle = (start + end) / 2;
		int index = existsSubstring(A, B, middle);
		if (middle == start)
			return B.substring(index, index + middle);
		if (index < 0) {
			return LCS_BinarySearch(A, B, start, middle);
		} else {
			return LCS_BinarySearch(A, B, middle, end);
		}
	}

	static String readFile(String fileName) {
		try {
			Scanner sc = new Scanner(new File(fileName));
			return sc.nextLine();
		} catch (Exception e) {
			System.out.println(e);
			return "";
		}
	}

}