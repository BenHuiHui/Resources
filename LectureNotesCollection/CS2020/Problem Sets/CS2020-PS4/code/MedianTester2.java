package sg.edu.nus.cs2020.PS4;

public class MedianTester2 {
	public static void main(String[] args) throws Exception {
		DynamicMedian2 A = new DynamicMedian2();
		// System.out.println(A.queryMaxData());
		// case when A is empty -- throw exception saying "No data inserted"
		
		A.addData(12);
		A.addData(15);
		A.addData(10);
		System.out.println(A.queryMaxData());	// must be 15
		A.addData(21);
		System.out.println(A.queryMaxData());	// must be 21
		A.addData(1);
		System.out.println(A.queryMaxData());	// must be 21

	}
}
