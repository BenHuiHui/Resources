package sg.edu.nus.cs2020;

public class PSOneQ2a {

	// asymptotic performance: O(n)
	static int f(int n){
		if(n>1)	return n*(n-1) + f(n-1);
		else return n*n;
	}
	
	public static void main(String args[]){
		int testValue = 1;
		int output = 0;
		
		for(int j=0;j<1000;j++)	output = f(testValue);
	}
}
