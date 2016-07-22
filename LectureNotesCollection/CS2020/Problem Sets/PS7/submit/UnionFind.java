package sg.edu.nus.cs2020.PS7;

import java.util.Vector;

public class UnionFind { // Union-Find Disjoint Sets Data Structure
  private Vector<Integer> pset;

  public UnionFind() {
    initSet(0);
  }
  
  public UnionFind(int _size) {
    initSet(_size);
  }

  public void initSet(int _size) {
    pset = new Vector<Integer>(_size);
    for (int i = 0; i < _size; i++)
      pset.add(i); 
  }
  
  public int findSet(int i) {
    if (pset.get(i) == i) return i;
    else {
      pset.set(i, findSet(pset.get(i)));
      return pset.get(i);
    }
  }
  
  public void unionSet(int i, int j) {
    pset.set(findSet(i), findSet(j)); 
  }

  public boolean isSameSet(int i, int j) {
    return findSet(i) == findSet(j); 
  }
}
