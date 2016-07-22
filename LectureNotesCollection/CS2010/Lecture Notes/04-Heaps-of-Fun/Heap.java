import java.util.*;

class Heap {
  private Vector<Integer> A;
  private int heapsize;

  Heap() {
    A = new Vector<Integer>();
    A.add(0); // dummy
    heapsize = 0;
  }

  Heap(int[] array) {
    BuildHeap(array);
  }

  int parent(int i) { return i >> 1; } // shortcut for i / 2, round down
  
  int left(int i) { return i << 1; } // shortcut for 2 * i
  
  int right(int i) { return (i << 1) + 1; } // shortcut for 2 * i + 1
  
  void shiftUp(int i) {
    while (i > 1 && A.get(parent(i)) < A.get(i)) {
      int temp = A.get(i);
      A.set(i, A.get(parent(i)));
      A.set(parent(i), temp);
      i = parent(i);
    }
  }

  void Insert(int key) {
    heapsize++;
    if (heapsize >= A.size())
      A.add(key);
    else
      A.set(heapsize, key);
    shiftUp(heapsize);
  }

  void shiftDown(int i) {
    while (i <= heapsize) {
      int maxV = A.get(i), max_id = i;
      if (left(i) <= heapsize && maxV < A.get(left(i))) { // compare value of this node with its left subtree, if possible
        maxV = A.get(left(i));
        max_id = left(i);
      }
      if (right(i) <= heapsize && maxV < A.get(right(i))) { // now compare with its right subtree, if possible
        maxV = A.get(right(i));
        max_id = right(i);
      }
  
      if (max_id != i) {
        int temp = A.get(i);
        A.set(i, A.get(max_id));
        A.set(max_id, temp);
        i = max_id;
      }
      else
        break;
    }
  }
  
  int ExtractMax() {
    int maxV = A.get(1);
    A.set(1, A.get(heapsize));
    heapsize--; // virtual decrease
    shiftDown(1);
    return maxV;
  }
  
  void BuildHeapSlow(int[] array) { // v1, array is 0-based
    A = new Vector<Integer>();
    A.add(0); // dummy, this heap is 1-based
    for (int i = 1; i <= array.length; i++)
      Insert(array[i - 1]);
  }
  
  void BuildHeap(int[] array) { // v2, array is 0-based
    heapsize = array.length;
    A = new Vector<Integer>();
    A.add(0); // dummy, this heap is 1-based
    for (int i = 1; i <= heapsize; i++) // copy the content
      A.add(array[i - 1]);
    for (int i = parent(heapsize); i >= 1; i--)
      shiftDown(i);
  }

  Vector<Integer> HeapSort(int[] array) {
    BuildHeap(array);
    int N = array.length;
    for (int i = 1; i <= N; i++)
      A.set(N - i + 1, ExtractMax());
    return A; // ignore the first index 0
  }

  int size() { return heapsize; }
  
  boolean isEmpty() { return heapsize == 0; }
}
