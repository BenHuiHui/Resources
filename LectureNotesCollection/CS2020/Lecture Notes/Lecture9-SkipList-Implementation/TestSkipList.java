/**
 * Code for testing the SkipList implementation from Lecture 9 of CS2020.
 */
package sg.edu.nus.cs2020;

public class TestSkipList {
		
	/**
	 * Test the empty SkipList
	 */
	public static void testEmptyList()
	{
		SkipList<Integer> listA = new SkipList<Integer>();
		try{						
			boolean fCorrect = true;		
			for (int i=0; i<100; i++){
				if (listA.search(i) == true)
				{
					fCorrect = false;
				}
				if (listA.getData(i) != null)
				{
					fCorrect = false;
				}
			}
			if (fCorrect){
				System.out.println("Passed: empty list.");
			}
			else {
				System.out.println("Failed: empty list.");
			}
		}
		catch(Exception e){
			System.out.println("Error---SkipList threw exception:" + e);
		}
	}
	
	/**
	 * Test inserting and searching in the SkipList
	 */
	public static void testInsertAndSearch()
	{
		// Test with repeated values
		SkipList<Integer> listA = new SkipList<Integer>();
		try{
			for (int i=0; i<10; i++){
				for (int j=10; j>0; j--) {
					listA.insert(i*j, 10*i);
				}
			}			
			boolean fCorrect = true;
			for (int j=10; j>0; j--)
			{
				for (int i=0; i<10; i++){
					fCorrect &= listA.search(i*j);
				}
			}
			
			if (fCorrect){
				System.out.println("Passed: insert and search (not unique).");
			}
			else {
				System.out.println("Failed: insert and search (not unique).");
			}
		}
		catch(Exception e){
			System.out.println("Error---SkipList threw exception:" + e);
		}
		
		// Test with unique values
		SkipList<Integer> listB = new SkipList<Integer>();		
		try{
			for (int i=1; i<20; i++){				
					listB.insert(i*i, 10*i);				
			}			
			boolean fCorrect = true;
			for (int i=1; i<10; i++){
				fCorrect &= listB.search(i*i);
				fCorrect &= ((listB.getData(i*i) != null) && (listB.getData(i*i) == 10*i));
			}			
			
			if (fCorrect){
				System.out.println("Passed: insert and search (unique).");
			}
			else {
				System.out.println("Failed: insert and search (unique).");
			}
		}
		catch(Exception e){
			//System.out.println("Error---SkipList threw exception:" + e);
		}		

	}
	
	/**
	 * Test deleting from the SkipList.
	 */
	public static void testDelete(){
		SkipList<Integer> listA = new SkipList<Integer>();
		for (int i=0; i<100; i++){
			listA.insert(i, i);
		}
		
		boolean fSuccess = true;
		for (int i=3; i<100; i+=3)
		{
			listA.delete(100-i);
			if (listA.search(100-i)){
				fSuccess = false;
				System.out.println("Failed: delete test.");
			}
		}
		if (fSuccess){
			System.out.println("Success: delete test.");
		} 
		fSuccess = true;
		for (int i=1; i<100; i++){
			if (i%3 != 0){
				if (!listA.search(100-i)){
					fSuccess = false;
					System.out.println("Failed: delete test 2.");
				}
			}
		}
		if (fSuccess){
			System.out.println("Success: delete test 2.");
		} 
	}
	
	/**
	 * Main test routine to test SkipList.
	 * Missing tests: checking the balance in the SkipList
	 *                testing the number of steps needed for insertions/deletion
	 *                testing the number of levels
	 *                ensuring that a key in list j is also in list j-1 (for j>0)
	 *                testing that all keys are in list 0
	 *                large scale testing
	 * @param args
	 */
	public static void main(String[] args)
	{			
		testEmptyList();
		testInsertAndSearch();
		testDelete();
	}
}
