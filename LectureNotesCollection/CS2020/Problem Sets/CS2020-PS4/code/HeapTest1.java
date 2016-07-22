package sg.edu.nus.cs2020.PS4;

public class HeapTest1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int[] array = new int[]{19, 3, 17, 1, 2, 25, 7, 36, 100};
		Heap h = new Heap();
		h.Build_Heap(array);
		h.Heap_UpdateKey(1, 21); // `decrease' max element (at index 1) from 100 to 21
		System.out.println(h.Heap_ExtractMax()); // must be 36, not 100 anymore
		System.out.println(h.Heap_ExtractMax()); // must be 25
		System.out.println(h.Heap_ExtractMax()); // must be 21 (which was originally 100)
		System.out.println(h.Heap_ExtractMax()); // must be 19
		System.out.println("-------------");
		h.Build_Heap(array); // restore the heap with the original content of 'array'
		h.Heap_UpdateKey(6, 77); // `increase' element at index 6 (previously 17) to 77
		System.out.println(h.Heap_ExtractMax()); // must be 100 (unchanged)
		System.out.println(h.Heap_ExtractMax()); // must be 77 (which was originally 17)
		System.out.println(h.Heap_ExtractMax()); // must be 36
		System.out.println(h.Heap_ExtractMax()); // must be 25
		}
}
