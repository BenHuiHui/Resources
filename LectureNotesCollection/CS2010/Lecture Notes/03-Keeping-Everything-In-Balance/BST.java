// This is just a sample implementation
// There are other ways to implement BST concepts...

class BST {
  protected BSTVertex root;

  protected BSTVertex search(BSTVertex T, int v) {
         if (T == null)  return T;                                  // not found
    else if (T.key == v) return T;                                      // found
    else if (T.key < v)  return search(T.right, v);       // search to the right
    else                 return search(T.left, v);         // search to the left
  }

  protected BSTVertex insert(BSTVertex T, int v) {
    if (T == null) return new BSTVertex(v);          // insertion point is found

    if (T.key < v) {                                      // search to the right
      T.right = insert(T.right, v);
      T.right.parent = T;
    }
    else {                                                 // search to the left
      T.left = insert(T.left, v);
      T.left.parent = T;
    }
    return T;                                          // return the updated BST
  }

  protected void inorder(BSTVertex T) {
    if (T == null) return;
    inorder(T.left);                               // recursively go to the left
    System.out.printf(" %d", T.key);                      // visit this BST node
    inorder(T.right);                             // recursively go to the right
  }

  protected int findMin(BSTVertex T) {
         if (T == null)      return -1;                             // not found
    else if (T.left == null) return T.key;                    // this is the min
    else                     return findMin(T.left);           // go to the left
  }

  protected int findMax(BSTVertex T) {
         if (T == null)       return -1;                            // not found
    else if (T.right == null) return T.key;                   // this is the max
    else                      return findMax(T.right);        // go to the right
  }

  protected int successor(BSTVertex T) {
    if (T.right != null)                       // this subtree has right subtree
      return findMin(T.right);  // the successor is the minimum of right subtree
    else {
      BSTVertex par = T.parent;
      BSTVertex cur = T;
      // if par(ent) is not root and cur(rent) is its right children
      while ((par != null) && (cur == par.right)) {
        cur = par;                                         // continue moving up
        par = cur.parent;
      }
      return par == null ? -1 : par.key;           // this is the successor of T
    }
  }

  protected int predecessor(BSTVertex T) {
    if (T.left != null)                         // this subtree has left subtree
      return findMax(T.left);  // the predecessor is the maximum of left subtree
    else {
      BSTVertex par = T.parent;
      BSTVertex cur = T;
      // if par(ent) is not root and cur(rent) is its left children
      while ((par != null) && (cur == par.left)) { 
        cur = par;                                         // continue moving up
        par = cur.parent;
      }
      return par == null ? -1 : par.key;           // this is the successor of T
    }
  }

  protected BSTVertex delete(BSTVertex T, int v) {
    if (T == null)  return T;              // cannot find the item to be deleted

    if (T.key == v) {                          // this is the node to be deleted
      if (T.left == null && T.right == null)                   // this is a leaf
        T = null;                                      // simply erase this node
      else if (T.left == null && T.right != null) {   // only one child at right
        BSTVertex temp = T;
        T.right.parent = T.parent;
        T = T.right;                                                 // bypass T
        temp = null;
      }
      else if (T.left != null && T.right == null) {    // only one child at left
        BSTVertex temp = T;
        T.left.parent = T.parent;
        T = T.left;                                                  // bypass T
        temp = null;
      }
      else {                                 // has two children, find successor
        int successorV = successor(v);
        T.key = successorV;         // replace this key with the successor's key
        T.right = delete(T.right, successorV);      // delete the old successorV
      }
    }
    else if (T.key < v)                                   // search to the right
      T.right = delete(T.right, v);
    else                                                   // search to the left
      T.left = delete(T.left, v);
    return T;                                          // return the updated BST
  }

  public BST() { root = null; }

  public int search(int v) {
    BSTVertex res = search(root, v);
    return res == null ? -1 : res.key;
  }

  public void insert(int v) { root = insert(root, v); }

  public void inorder() { 
    System.out.print("The BST:");
    inorder(root);
    System.out.println();
  }

  public int findMin() { return findMin(root); }

  public int findMax() { return findMax(root); }

  public int successor(int v) { 
    BSTVertex vPos = search(root, v);
    return vPos == null ? -1 : successor(vPos);
  }

  public int predecessor(int v) { 
    BSTVertex vPos = search(root, v);
    return vPos == null ? -1 : predecessor(vPos);
  }

  public void delete(int v) { root = delete(root, v); }
}
