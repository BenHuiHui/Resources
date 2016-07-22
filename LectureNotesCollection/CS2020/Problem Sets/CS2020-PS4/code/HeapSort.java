package sg.edu.nus.cs2020.PS4;

import java.util.Arrays;
import java.util.PriorityQueue;

public class HeapSort { 
	
	static void Heap_Sort(int[] array){
		if(array==null)return;	// handle when array is null
		PriorityQueue<Integer> heap = new PriorityQueue<Integer>();
		for(int i:array) heap.add(i);
		for(int i=0;i<array.length;i++)	array[i] = heap.poll();
	}
	
	public static void main(String[] args) {
		int[] array = new int[] { 19, 3, 17,1, 1, 2, 25, 7, 36,17, 100 };	// array with repeated elements
		Heap_Sort(array);
		System.out.println(Arrays.toString(array));
		
		array = new int[0];	// case when array is empty
		Heap_Sort(array);
		System.out.println(Arrays.toString(array));
	}
}
