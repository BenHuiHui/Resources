package sg.edu.nus.cs2020.PS4;

public class MinHeap extends Heap {
	// potential problem: I don't have any good idea on how to hide the "Heap_ExtractMax()" method -- 
	// this would simply give the wrong result 
	
	/* Method 1: need to vector A, and "heapsize" in its super class to be protected
	 * No need to change the "Build Heap" method
	 */ 
//	void shiftUp(int i) {
//		while (i > 1 && super.A.get(Parent(i)) > super.A.get(i)) {
//			// exchange the value of its (Parent) or (Bigger Child)
//			int temp = super.A.get(i);
//			super.A.set(i, super.A.get(Parent(i)));
//			super.A.set(Parent(i), temp);
//			i = Parent(i);
//		}
//	}
//	
//	 	void shiftDown(int i) {
//		while (i <= super.heapsize) {
//			int maxV = super.A.get(i), max_id = i;
//			if (Left(i) <= super.heapsize && maxV > super.A.get(Left(i))) {
//				maxV = super.A.get(Left(i));
//				max_id = Left(i);
//			}
//			if (Right(i) <= super.heapsize && maxV > super.A.get(Right(i))) {
//				maxV = super.A.get(Right(i));
//				max_id = Right(i);
//			}
//
//			if (max_id != i) {
//				int temp = super.A.get(i);
//				super.A.set(i, super.A.get(max_id));
//				super.A.set(max_id, temp);
//				i = max_id;
//			} else
//				break;
//		}
//	}
//
//	int Heap_ExtractMin() {
//	    return Heap_ExtractMax();
//	}
	

	
	
	/* There's another very good method, offered by Ding Mingzhe */
	@Override void Heap_Insert(int key) {
	    super.Heap_Insert(-key);
	}
	
	@Override void Build_Heap(int[] array) { // v2, array is 0-based
		for(int i=0;i<array.length;i++)	array[i] = -array[i];
		super.Build_Heap(array);
		for(int i=0;i<array.length;i++)	array[i] = -array[i];	// then change the values back
	  }
	
	int Heap_ExtractMin(){
		return  -Heap_ExtractMax();
	}
	
	public static void main(String[] args) {
		MinHeap a = new MinHeap();
		a.Heap_Insert(12);
		a.Heap_Insert(10);
		a.Heap_Insert(5);
		a.Heap_Insert(20);
		System.out.println(a.Heap_ExtractMin());
		System.out.println(a.Heap_ExtractMin());
		System.out.println(a.Heap_ExtractMin());
	}

}
