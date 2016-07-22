/* Information: 
 * 	for the test of this class, please refer to the main method at the end of this file.
 *  One can change the number of elements generated when testing
 *  It's sufficient to test the correctness because every method has been used, and every path 
 *  	has been gone through. 
 */

package sg.edu.nus.cs2020.PS5;

import java.util.*;

public class TreeNode implements ITreeNode {
	protected TreeNode leftChild = null;
	protected TreeNode rightChild = null;
	protected TreeNode parent = null;
	protected int weight = 0;
	protected int key;
	protected int count = 0;
	protected Object data;

	public ITreeNode getLeftChild() {
		return leftChild;
	};

	public ITreeNode getRightChild() {
		return rightChild;
	};

	public ITreeNode getParent() {
		return parent;
	};

	// weight = left.weight + right.weight + 1
	public int getWeight() {
		return weight;
	};

	// for test only: to print the weight of each node
	void printWeight() {
		count = 0;
		printWeightRecur(this);
	}

	private void printWeightRecur(TreeNode node) {
		if (node.leftChild != null)
			printWeightRecur(node.leftChild);
		System.out.println("the " + this.count++ + "th element, key: "
				+ node.key + ", weigth= " + node.weight);
		if (node.rightChild != null)
			printWeightRecur(node.rightChild);
	}

	public int getKey() {
		return key;
	};

	// O(n)
	public List<Integer> getTreeKeys() {
		List<Integer> res = new ArrayList<Integer>();
		this.keysTreeWalk(res);
		return res;
	};

	private void keysTreeWalk(List<Integer> res) {
		if (this.leftChild != null)
			this.leftChild.keysTreeWalk(res);
		res.add(this.key);
		if (this.rightChild != null)
			this.rightChild.keysTreeWalk(res);
	}


	/* (non-Javadoc)
	 * While inserting the element, this can also update the weight along the way
	 */
	public void insert(int number) {
		this.weight++; // the weight is going to increase anyway
		if (this.key > number) {
			if (this.leftChild != null) {
				this.leftChild.insert(number);
			} else
				this.leftChild = new TreeNode(this, number, 1);
		} else {
			if (this.rightChild != null) {
				this.rightChild.insert(number);
			} else
				this.rightChild = new TreeNode(this, number, 1);
		}
	};

	public boolean search(int number) {
		if (this.key > number)
			return this.leftChild == null ? false : (this.leftChild
					.search(number));
		else if (this.key < number)
			return this.rightChild == null ? false : (this.rightChild
					.search(number));
		else
			return true; // this is when this.key==number
	};

	/**
	 * Assumption: a is a sorted list, with no duplicate;
	 * Function: this would automatically set the correct tree weight to each node
	 * 
	 * @param a
	 * @return
	 */
	static ITreeNode buildTree(List<Integer> a) {
		return buildNode(0, a.size() - 1, a);
	}

	/**
	 * @param startIndex
	 * @param endIndex
	 * @param a
	 * @return
	 */
	protected static TreeNode buildNode(int startIndex, int endIndex,
			List<Integer> a) {
		if (startIndex > endIndex)
			return null;

		int currentIndex = (startIndex + endIndex) / 2;

		// set the current tree node
		TreeNode node = new TreeNode(null, a.get(currentIndex), endIndex
				- startIndex + 1);
		// if the left/right child is null, then weight doesn't exist
		node.leftChild = buildNode(startIndex, currentIndex - 1, a);
		node.rightChild = buildNode(currentIndex + 1, endIndex, a);

		// the parent of the left/right child, is setted in the current node
		if (node.leftChild != null)
			node.leftChild.parent = node;
		if (node.rightChild != null)
			node.rightChild.parent = node;
		return node;
	}
	

	
	/**
	 * This is the constructor for building a node/leaf
	 * 
	 * @param parent
	 * @param key
	 * @param weight
	 */
	protected TreeNode(TreeNode parent, int key, int weight) {
		this.weight = weight;
		this.key = key;
		this.parent = parent;
	}

	/**
	 * this can build the root of the tree node -- without assigning a parent
	 * 
	 * @param key
	 * @param data
	 */
	public TreeNode(int key, Object data) {
		this.key = key;
		this.data = data;
		this.weight = 1;
	}

	// this main method is used for test
	public static void main(String[] args) {
		Random rand = new Random(47);
		List<Integer> seed = new ArrayList<Integer>();

		// temp var
		int i = 0, t;
		while (i < 10) {
			t = rand.nextInt(98);
			if (!seed.contains(t)) {
				seed.add(t);
				i++;
			}
		}
		Collections.sort(seed);
		System.out.println(seed);

		ITreeNode tree = TreeNode.buildTree(seed);

		// test Search
		System.out.println("search for 12: " + tree.search(12));

		// test inserting elements
		tree.insert(12);
		tree.insert(14);
		System.out.println(tree.getTreeKeys());

		// after insert, test Search
		System.out.println("After inserting 12, search for 12: "
				+ tree.search(12));

		// for using the printWeight method to output the weight, check if it is
		// correct
		TreeNode test = (TreeNode) tree;
		test.printWeight();

	}
}
