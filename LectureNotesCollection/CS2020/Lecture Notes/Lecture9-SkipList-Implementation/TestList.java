/**
 * Code for testing the Linked List implementation from Lecture 9 of CS2020.
 */
package sg.edu.nus.cs2020;

import java.lang.Integer;

public class TestList {
	
	/**
	 * Test cases when the list is empty.
	 */
	public static void testEmptyList()
	{
		LinkedList<Integer> listA = new LinkedList<Integer>();
		try{						
			if (listA.getSize() == 0){
				System.out.println("Passed: size of empty list.");
			}
			else {
				System.out.println("Failed: size of empty list.");
			}
			
			if (listA.isEmpty()){
				System.out.println("Passed: isEmpty on empty list.");
			}
			else {
				System.out.println("Failed: isEmpty on empty list.");
			}
		}
		catch(LinkedListException e)
		{
			System.out.println("Error---Linked List threw exception:" + e);
		}
		
		try{
			listA.getKey(0);
			System.out.println("Failed: cannot get items from empty list.");
		}
		catch(LinkedListException e)
		{
			System.out.println("Passed: cannot get items from empty list.");
		}
		
		try{
			listA.getData(0);
			System.out.println("Failed: cannot get items from empty list.");
		}
		catch(LinkedListException e)
		{
			System.out.println("Passed: cannot get items from empty list.");
		}
		
	}
	
	/**
	 * Test retrieving data from the list.
	 */
	public static void testGetData()
	{
		LinkedList<Integer> listA = new LinkedList<Integer>();
		try{
			// Test prepend
			listA.prepend(5, 100);					
			if (listA.getData(0) == 100){
				System.out.println("Passed: get first item.");

			}
			else {
				System.out.println("Failed: get first item.");
			}
			
			// Test append
			listA.append(20, 200);
			if (listA.getData(0) == 100){
				System.out.println("Passed: get first item in 2 item list.");

			}
			else {
				System.out.println("Failed: get first item in 2 item list.");
			}			
			if (listA.getData(1) == 200){
				System.out.println("Passed: get second item.");

			}
			else {
				System.out.println("Failed: get second item.");
			}
			
			// Test getSize
			if (listA.getData(listA.getSize()-1) == 200){
				System.out.println("Passed: getSize returns correct size.");

			}
			else {
				System.out.println("Failed: getSize returns correct size.");
			}


		}
		catch(LinkedListException e) { 
			System.out.println("Error---Linked List threw exception:" + e);
		}
	}
	
	/**
	 * Test concatenating two lists.
	 */
	public static void testAppend()
	{
		LinkedList<Integer> listA = new LinkedList<Integer>();
		LinkedList<Integer> listB = new LinkedList<Integer>();
		try{
			// Test prepend
			for (int i=0; i<20; i++)
			{
				listA.append(i, i+100);
				listB.append(20-i, i+1000);
			}
			listA.append(listB);
			
			// Check if the appended list is the right size
			if (listA.getSize() == 40){
				System.out.println("Passed: size of combined list.");
			}
			else {
				System.out.println("Failed: size of combined list.");
			}
			// Check the size of the second list
			if (listA.getSize() == 20){
				System.out.println("Passed: size of second list.");
			}
			else {
				System.out.println("Failed: size of second list.");
			}
			
			// Check if the list has the right elements in the right order
			boolean listACorrect = true;
			for (int i=0; i<20; i++)
			{
				if (listA.getKey(i) != i) {				
					listACorrect = false;
				}
			}
			for (int i=0; i<20; i++)
			{
				if (listA.getKey(i+20) != 20-i) {				
					listACorrect = false;
				}
			}
			if (listACorrect){
				System.out.println("Passed: first combined list.");
			}
			else {
				System.out.println("Failed: first combined list.");
			}
			
			// Check if the second list has the right elements in the right order
			boolean listBCorrect = true;
			for (int i=0; i<20; i++)
			{
				if (listB.getKey(i) != 20-i) {				
					listBCorrect = false;
				}
			}
			if (listBCorrect){
				System.out.println("Passed: second list.");
			}
			else {
				System.out.println("Failed: second list.");
			}						
		}
		catch(LinkedListException e) { 
			System.out.println("Error---Linked List threw exception:" + e);
		}
	}
			

	/**
	 * Main testing routine.
	 * Note: there are many more tests that should be added. 
	 * This is not complete.
	 * @param args
	 */
	public static void main(String[] args)
	{
	
		testEmptyList();
		testGetData();
		testAppend();
	}
	
}
