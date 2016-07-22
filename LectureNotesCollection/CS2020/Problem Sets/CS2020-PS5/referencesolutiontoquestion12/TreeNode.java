/**
 * @author Cliff Koh Zi Han 
 * 
 * Comments: c - java convention: createTree instead of CreateTree?
 *           d - sorted array, int[] array or ArrayList?
 *           all - all in 1 go or part by part?
 *           e - static method?
 */
package sg.edu.nus.cs2020.solutions;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

/**
 * TreeNode - a node of a binary tree. This implementation implements
 * requirements A to E. Note that this class is NOT thread-safe.
 * 
 * @author Cliff Koh Zi Han
 * 
 */
public class TreeNode implements ITreeNode {
	/**
	 * Pointer to the left child of the tree
	 */
	protected ITreeNode leftChild;

	/**
	 * Pointer to the right child of the tree
	 */
	protected ITreeNode rightChild;

	/**
	 * Pointer to parent
	 */
	protected ITreeNode parent;
	
	/**
	 * The total number of keys stored in the subtree, including the key in the
	 * current node.
	 */
	protected int weight;

	/**
	 * The key that the node in the binary tree holds
	 */
	protected int key;

	/**
	 * Creates a new TreeNode object.
	 * 
	 * @param key
	 * @param parent Null if no parent, a reference to the parent node otherwise.
	 */
	public TreeNode(int key, ITreeNode parent) {
		this.key = key;
		this.weight = 1;
		this.parent = parent;
	}

	/**
	 * Part A/B requirement: Add a key rooted at this node. This solution
	 * assumes no duplicate key already exist.
	 * 
	 * @param key
	 */
	public void insert(int key) {
		this.weight += 1;
		if (key < this.key) {
			if (this.leftChild == null) {
				this.leftChild = new TreeNode(key, this);
			} else {
				this.leftChild.insert(key);
			}
		}

		if (key > this.key) {
			if (this.rightChild == null) {
				this.rightChild = new TreeNode(key, this);
			} else {
				this.rightChild.insert(key);
			}
		}
	}

	/**
	 * Part A Requirement: Searches the tree rooted at this node for a key, and
	 * returns true/false depending on whether the key can be found in the tree.
	 * 
	 * @param key
	 * @return true/false depending on whether the key can be found in the tree.
	 */
	public boolean search(int key) {
		if (this.key == key) {
			return true;
		}

		if (this.leftChild != null && this.leftChild.search(key)) {
			return true;
		}

		if (this.rightChild != null && this.rightChild.search(key)) {
			return true;
		}

		return false;
	}


	/**
	 * Part D Requirement: Returns a sorted, increment array containing all the
	 * keys in the tree rooted at that node.
	 * 
	 * @return A sorted, increment array containing all the keys in the tree
	 *         rooted at that node.
	 */
	public List<Integer> getTreeKeys() {
		List<Integer> temp;
		if (this.leftChild != null) {
			temp = this.leftChild.getTreeKeys();
		} else {
			temp = new ArrayList<Integer>();
		}

		temp.add(this.key);
		if (this.rightChild != null) {
			temp.addAll(this.rightChild.getTreeKeys());
		}

		return temp;
	}


	/**
	 * Part E Alternative: Builds a perfectly balanced tree given an array of
	 * sorted integers, using an alternative, constructive approach.
	 * 
	 * @param arrayOfSortedIntegers
	 *            Assumed to be not null.
	 * @return An array of sorted integers.
	 */
	public static TreeNode buildTree(List<Integer> arrayOfSortedIntegers) {
		return buildTree2Helper(arrayOfSortedIntegers, null);
	}
	
	private static TreeNode buildTree2Helper(List<Integer> arrayOfSortedIntegers, ITreeNode head){
		int size = arrayOfSortedIntegers.size();
		if (size == 0) {
			return null;
		}

		// get position of middle element
		int mid = size / 2;

		TreeNode root = new TreeNode(arrayOfSortedIntegers.get(mid), head);
		root.weight = size;
		if (mid != 0) {
			root.leftChild = TreeNode.buildTree2Helper(arrayOfSortedIntegers.subList(
					0, mid), root);
		} else {
			root.leftChild = null;
		}
		
		if(mid != size - 1){
			root.rightChild = TreeNode.buildTree2Helper(arrayOfSortedIntegers.subList(mid+1, size), root);
		}else{
			root.rightChild = null;
		}
		
		return root;		
	}

	/**
	 * @return the leftChild
	 */
	public ITreeNode getLeftChild() {
		return leftChild;
	}

	/**
	 * @return the rightChild
	 */
	public ITreeNode getRightChild() {
		return rightChild;
	}

	/**
	 * @return the weight
	 */
	public int getWeight() {
		return weight;
	}

	/**
	 * @return the key
	 */
	public int getKey() {
		return key;
	}
	
	public ITreeNode getParent(){
		return this.parent;
	}
}
