package sg.edu.nus.cs2020.PS4;


public class HeapTest2 {

	public static void main(String[] args) {
		MinHeap h = new MinHeap();

		// System.out.println(h.Heap_ExtractMin());
			// the case of extracting an
			// empty heap -- throw exception

		// build heap with an array
		h.Heap_Insert(4); // test when heap is empty
		System.out.println(h.Heap_ExtractMin()); // must be 4

		System.out.println("-------------");

		int[] array = new int[] { 19, 3, 17, 1, 2, 25, 7, 36, 100 };
		h.Build_Heap(array); // build with an array

		// test the insert method
		h.Heap_Insert(4);
		h.Heap_Insert(4);	// case for repeated elements
		h.Heap_Insert(50);

		System.out.println(h.Heap_ExtractMin()); // must be 1
		System.out.println(h.Heap_ExtractMin()); // must be 2
		System.out.println(h.Heap_ExtractMin()); // must be 3
		System.out.println(h.Heap_ExtractMin()); // must be 4
		System.out.println(h.Heap_ExtractMin()); // must be 4
		System.out.println(h.Heap_ExtractMin()); // must be 7
		System.out.println("-------------");

		h.Build_Heap(array); // restore the heap with array
		System.out.println(h.Heap_ExtractMin()); // must be 1 again
	}
}
