package sg.edu.nus.cs2020.PS4;

import java.util.Comparator;
import java.util.PriorityQueue;

public class DynamicMedian {

	private Comparator<Integer> rev_cmp = new Comparator<Integer>() {
		@Override
		public int compare(Integer a, Integer b) {
			return b.compareTo(a);
		}
	};

	private PriorityQueue<Integer> A = new PriorityQueue<Integer>(1, rev_cmp); // Max
																				// Heap
	private PriorityQueue<Integer> B = new PriorityQueue<Integer>(); // Min Heap

	public void addData(int d) {

		if (B.peek() == null) {
			B.offer(d);
			return;
		}
		if (A.peek() == null) {
			A.offer(d);
			return;
		}

		int pre = A.peek(), pos = B.peek();
		int nA = A.size(), nB = B.size();

		if (d < pre) {
			A.offer(d);
			if (nA == nB)
				B.offer(A.poll());
		} else if (d >= pos) {
			B.offer(d);
			if (nA == nB - 1)
				A.offer(B.poll());
		} else {
			if (nA == nB)
				B.offer(d);
			else
				A.offer(d);
		}
	}

	public int queryMedianData() throws Exception {
		Integer res = B.peek();
		if(res==null)	throw(new Exception("No data Inserted!"));
		return res;
	}

}
