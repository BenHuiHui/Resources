class BSTVertex {
  BSTVertex(int v) { key = v; parent = left = right = null; height = 0; }
  BSTVertex parent, left, right;
  int key, height;
};
