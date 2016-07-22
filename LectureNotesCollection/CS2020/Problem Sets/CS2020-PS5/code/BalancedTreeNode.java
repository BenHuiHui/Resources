package sg.edu.nus.cs2020.PS5;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class BalancedTreeNode extends TreeNode {

	/**
	 * The same as its parent
	 * 
	 * @param key
	 *            - the key for looking up
	 * @param data
	 *            - the data stored, which is an object
	 */
	public BalancedTreeNode(int key, Object data) {
		super(key, data);
	}

	/** The expected Constructor
	 * @param key
	 * @param parent
	 */
	public BalancedTreeNode(int key, ITreeNode parent) {
		super(key, parent);
	}

	@Override
	public void insert(int number) {
		// first we insert this number
		super.insert(number);

		// then we find the first unbalanced weight, for this number
		TreeNode firstUnbalancedNode = findFirstUnbalanced(this, number);

		// then we re-balance the weight; if the first Unbalanced Node is null
		if (firstUnbalancedNode != null)
			rebalanceWeight(firstUnbalancedNode);
	};

	private static TreeNode findFirstUnbalanced(TreeNode node, int number) {
		if (!isBalanced(node))
			return node;
		else {
			if (node.key > number && node.leftChild != null)
				return findFirstUnbalanced(node.leftChild, number);
			else if (node.key <= number && node.rightChild != null)
				return findFirstUnbalanced(node.rightChild, number);
		}
		return null;
	}

	private static void rebalanceWeight(TreeNode node) {
		if (isBalanced(node)) {
			return;
		}
		List<Integer> subnodes = node.getTreeKeys();
		
		int medianIndex = subnodes.size() / 2;
		// when it's unbalanced, it has at least 2 elements, and thus
		// medianIndex is always >1
		node.leftChild = (TreeNode) buildTree(new ArrayList<Integer>(
				subnodes.subList(0, medianIndex)));
		// For the right subtree, there's an edge condition that, when 2
		// elements, the medianIndex is the endIndex
		node.rightChild = (medianIndex > subnodes.size()) ? null
				: (TreeNode) buildTree(new ArrayList<Integer>(subnodes.subList(
						medianIndex + 1, subnodes.size())));
		// then set the median, i.e. "this"
		node.key = subnodes.get(medianIndex);

		// then change all the related information stored in this node:
		updateWeight(node);
		// but "data" is not copied. If we want to copy the "data", then it's
		// the best if we can change the "getTreeKeys" to "getTree", while
		// output order according to the tree keys
	}

	/**
	 * @param node
	 *            -- the node to test
	 * @return -- true if balanced, false if not
	 */
	private static Boolean isBalanced(TreeNode node) {
		int left = (node.leftChild != null) ? node.leftChild.weight : 0;
		int right = (node.rightChild != null) ? node.rightChild.weight : 0;
		if (left * right == 0) {
			if (left + right > 1)
				return false;
		} else if (left > right * 2)
			return false;
		else if (right > left * 2)
			return false;
		return true;
	}

	/**
	 * use the formula: currentNode.weight = leftWeight + rightWeight; a null
	 * node's weight is considered as 0
	 * 
	 * @param node
	 */
	private static void updateWeight(TreeNode node) {
		node.weight = ((node.leftChild != null) ? node.leftChild.weight : 0)
				+ ((node.rightChild != null) ? node.rightChild.weight : 0);
	}

	/**
	 * this is used for test
	 * 
	 * @param node
	 * @return
	 * @throws Exception
	 */
	private static void testTreeBalanced(TreeNode node) throws Exception {
		if (!isBalanced(node))
			throw new Exception("Tree Balance Test Failed...");
		if (node.leftChild != null)
			testTreeBalanced(node.leftChild);
		if (node.rightChild != null)
			testTreeBalanced(node.rightChild);
	}

	private static void testIncreaingList(List<Integer> li) throws Exception {
		for (int i = 0; i < li.size() - 1; i++) {
			if (li.get(i) > li.get(i + 1))
				throw new Exception("The List test faied.");
		}
	}

	public static void main(String[] args) {
		BalancedTreeNode root = new BalancedTreeNode(100, null);
		System.out.println("root key = " + root.getKey() + ", weight = "
				+ root.getWeight());
		root.insert(12);
		root.insert(19);
		System.out.println("root key = " + root.getKey() + ", weight = "
				+ root.getWeight());
		root.insert(15);
		System.out.println("root key = " + root.getKey() + ", weight = "
				+ root.getWeight());
		root.insert(14);
		System.out.println("root key = " + root.getKey() + ", weight = "
				+ root.getWeight());
		root.insert(13);
		System.out.println("root.left key = " + root.getLeftChild().getKey()
				+ ", weight = " + root.getLeftChild().getWeight());

		try {
			// check the increasing order
			root = new BalancedTreeNode(100, null);
			for (int i = 1; i <= 200; i++) {
				root.insert(i);
				testTreeBalanced(root);
				testIncreaingList(root.getTreeKeys());
			}
			System.out.println("Increasing order test passed");

			// check the reverse order
			root = new BalancedTreeNode(100, null);
			for (int i = 200; i > 0; i--) {
				root.insert(i);
				testTreeBalanced(root);
				testIncreaingList(root.getTreeKeys());
			}
			System.out.println("Decreasing order test passed");
			// check random case -- inserting 200 random numbers
			Random rand = new Random();
			root = new BalancedTreeNode(rand.nextInt(), null);
			for (int TC = 0; TC < 200; TC++) {
				for (int i = 0; i < 200; i++) {
					root.insert(rand.nextInt());
				}
				testTreeBalanced(root);
				testIncreaingList(root.getTreeKeys());
			}

			// if no exception thrown, then it has passed all the test cases~
			System.out.println("Ramdom test cases passed");
		} catch (Exception e) {
			System.out.println("Exception: " + e);
		}

	}

}
