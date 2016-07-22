package sg.edu.nus.CS2020;
import java.util.Scanner;
import java.io.File;
import java.util.HashMap;

public class LongestCommonSubstring {

	// In your submission, do not modify the main routine.
	public static void main(String[] args){
		String A = readFile("A.txt");
		String B = readFile("B.txt");
		
		String commonSubstring = LCS(A,B);
		System.out.println(commonSubstring);
	}
	
	// The following function should return the longest common
	// substring of the two input strings A and B.
	//
	// If there is no common substring, it should return an 
	// empty string.
	public static String LCS(String A, String B){
		// Implement your solution here.
		
		
		return new String("");
	}

	// The following function should return an index as follows:
	// If the input strings A and B have a common substring of length
	// L, then it should return the index in string B of that substring.
	// Otherwise, if input strings A and B do not have a common substring
	// of length L, then it should return -1.
	public static int existsSubstring(String A, String B, int L){
		// Implement your solution here.
		
		return -1;
	}
	
	static String readFile(String fileName){
		try{
			Scanner sc = new Scanner(new File(fileName));
			return sc.nextLine();
		}
		catch(Exception e)
		{
			System.out.println(e);
			return "";
		}
	}

}
