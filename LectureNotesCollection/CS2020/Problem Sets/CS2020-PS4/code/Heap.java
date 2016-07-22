package sg.edu.nus.cs2020.PS4;

import java.util.*;

class Main {
  public static void main(String[] args) {
    int[] array = new int[]{19, 3, 17, 1, 2, 25, 7, 36, 100};
    Heap h = new Heap();
    Vector<Integer> sorted = h.Heap_Sort(array); // build heap routine is already inside Heap_Sort
    for (int i = 0; i < sorted.size(); i++) // first item will always be 0
      System.out.println(sorted.get(i));
    
    h.Slow_Build_Heap(array); // rebuild heap again
    System.out.println("-------------");
    System.out.println(h.Heap_ExtractMax()); // must be 100
    System.out.println(h.Heap_ExtractMax()); // must be 36 now
    
    h.Build_Heap(array); // rebuild heap again, using different technique 
    System.out.println("-------------");
    System.out.println(h.Heap_ExtractMax()); // must be 100
    System.out.println(h.Heap_ExtractMax()); // must be 36
    h.Heap_Insert(24);
    System.out.println(h.Heap_ExtractMax()); // must be 25
    System.out.println(h.Heap_ExtractMax()); // must be 24, the one that we inserted recently
  }
}

class Heap {
  protected Vector<Integer> A;
  protected int heapsize;

  Heap() {
    A = new Vector<Integer>();
    A.add(0); // dummy
    heapsize = 0;
  }

  Heap(int[] array) {
    Build_Heap(array);
  }

  int Parent(int i) { return i >> 1; } // shortcut for i / 2, round down
  
  int Left(int i) { return i << 1; } // shortcut for 2 * i
  
  int Right(int i) { return (i << 1) + 1; } // shortcut for 2 * i + 1
  
  // time O(h)
  void shiftUp(int i) {
    while (i > 1 && A.get(Parent(i)) < A.get(i)) {
      // exchange the value of its (Parent) or (Bigger Child)
      int temp = A.get(i);
      A.set(i, A.get(Parent(i)));
      A.set(Parent(i), temp);
      i = Parent(i);
    }
  }
  
  // time O(h)
  void Heap_Insert(int key) {
    heapsize++;
    if (heapsize >= A.size())	// very good operation -- can reuse the alocated space 
      A.add(key);
    else
      A.set(heapsize, key);
    shiftUp(heapsize);
  }
  
  // time O(h)
  void shiftDown(int i) {
    while (i <= heapsize) {
      int maxV = A.get(i), max_id = i;
      if (Left(i) <= heapsize && maxV < A.get(Left(i))) { // compare value of this node with its Left subtree, if possible
        maxV = A.get(Left(i));
        max_id = Left(i);
      }
      if (Right(i) <= heapsize && maxV < A.get(Right(i))) { // now compare with its Right subtree, if possible
        maxV = A.get(Right(i));
        max_id = Right(i);
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
  
  void Heap_UpdateKey(int i, int k){
	A.set(i, k);
	shiftDown(i);
	shiftUp(i);
  }
  
  // time O(h)
  int Heap_ExtractMax() {
    int maxV = A.get(1);
    A.set(1, A.get(heapsize));
    heapsize--; // virtual decrease
    shiftDown(1);	// main factor
    return maxV;
  }
  
  void Slow_Build_Heap(int[] array) { // v1, array is 0-based
    A = new Vector<Integer>();
    A.add(0); // dummy, this heap is 1-based
    for (int i = 1; i <= array.length; i++)
      Heap_Insert(array[i - 1]);
  }
  
  void Build_Heap(int[] array) { // v2, array is 0-based
    heapsize = array.length;
    A = new Vector<Integer>();
    A.add(0); // dummy, this heap is 1-based
    for (int i = 1; i <= heapsize; i++) // copy the content
      A.add(array[i - 1]);
    for (int i = Parent(heapsize); i >= 1; i--)
      shiftDown(i);
  }

  Vector<Integer> Heap_Sort(int[] array) {
    Build_Heap(array);
    for (int i = 1; i <= array.length; i++)
      A.set(array.length - i + 1, Heap_ExtractMax());
    return A; // ignore the first index 0
  }

  int GetSize() { return heapsize; }
  
  boolean IsEmpty() { return heapsize == 0; }
}
