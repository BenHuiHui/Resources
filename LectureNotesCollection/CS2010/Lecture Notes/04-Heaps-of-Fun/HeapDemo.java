import java.util.*;

class HeapDemo {
  public static void main(String[] args) {
    int[] array = new int[]{19, 3, 17, 1, 2, 25, 7, 36, 100};
    Heap h = new Heap();
    Vector<Integer> sorted = h.HeapSort(array); // build heap routine is already inside heapSort
    // first item will always be 0 (remember that we ignore index 0 in our heap implementation!)
    for (int i = 0; i < sorted.size(); i++)
      System.out.println(sorted.get(i));
    
    h.BuildHeapSlow(array); // rebuild heap again, we will get the same heap, just slightly slower
    System.out.println("-------------");
    System.out.println(h.ExtractMax()); // must be 100
    System.out.println(h.ExtractMax()); // must be 36 now
    
    h.BuildHeap(array); // rebuild heap again, using different technique (faster)
    System.out.println("-------------");
    System.out.println(h.ExtractMax()); // must be 100
    System.out.println(h.ExtractMax()); // must be 36
    h.Insert(24);
    System.out.println(h.ExtractMax()); // must be 25
    System.out.println(h.ExtractMax()); // must be 24, the one that we inserted recently
  }
}
