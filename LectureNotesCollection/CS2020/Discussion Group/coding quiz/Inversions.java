package sg.edu.nus.CS2020;
import java.util.ArrayList;
import java.util.Collection;

public class Inversions {

	static int countInversions(ArrayList<Integer> intArray) {
		int count = 0;
		if (intArray == null || intArray.size() == 1)
			return count;

		for (int i = 0; i < intArray.size(); i++) {
			for (int j = i; j < intArray.size(); j++) {
				if (intArray.get(i) > intArray.get(j))
					count++;
			}
		}

		return count;
	}

	/**
	 * method takes as input a sorted list of integers and an integer
	 * numInversions < n.
	 * 
	 * basic idea: move the last element(largest) back numInversions numbers, and that's the new permutation we want.
	 * 
	 * @param intArray
	 * @param numInversions less than n - 1 
	 * @return a permutation of the original list containing exactly numInversions inversions
	 */
	static ArrayList<Integer> createInversions(ArrayList<Integer> intArray,
			int numInversions) {
		ArrayList<Integer> res = new ArrayList<Integer>();
		int n = intArray.size();
		int copyUpTo = n-1 - numInversions;
		for(int i=0;i<copyUpTo;i++){
			res.add(intArray.get(i));
		}
		res.add(intArray.get(n-1));
		for(int i=copyUpTo;i<n-1;i++){
			res.add(intArray.get(i));
		}
		return res;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ArrayList<Integer> a = new ArrayList<Integer>();
		a.add(1);a.add(2);a.add(3);a.add(4);a.add(5);
		System.out.println(countInversions(a));
		System.out.println(createInversions(a,1));
	}

}
