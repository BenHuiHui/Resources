package sg.edu.nus.cs2020.PS4;

public class MedianTester {
	public static void main(String[] args) throws Exception {
		DynamicMedian A = new DynamicMedian();
		//System.out.println("0:	" + A.queryMedianData());
			// when querying an empty  DynamicMedian, throw exception saying: No data Inserted!
		
		A.addData(12);	// add to an empty DynamicMedian
		A.addData(10);
		A.addData(15);
		System.out.println("1:	" + A.queryMedianData());// must print 12
		A.addData(1);
		System.out.println("2:	" + A.queryMedianData());// must print 12,
														// allowing repeated
														// elements
		A.addData(1);
		System.out.println("3:	" + A.queryMedianData());// must print 10
	}
}
