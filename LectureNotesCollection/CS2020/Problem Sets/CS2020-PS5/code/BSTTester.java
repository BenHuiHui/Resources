package sg.edu.nus.cs2020.PS5;

/**
*
* Sample code for testing your Binary Search Tree code.
*
**/

import java.util.ArrayList;
import java.util.List;

public class BSTTester {
	
	static List<String> problems;

	// Verifies a tree rooted at a.
	public static boolean verifyTree(ITreeNode a) {
		try {
			problems = new ArrayList<String>();
			treeVerifier(a);
			if(problems.size() != 0) return false;
		} catch (Exception e) {
			System.out.println(e);
			return false;
		}
		return true;
	}

	// Verifies a tree rooted at a, returning the weight of the tree.
	private static int treeVerifier(ITreeNode a) throws Exception {
		if (a == null)
			return 0;

		int weightLeft = treeVerifier(a.getLeftChild());
		int weightRight = treeVerifier(a.getRightChild());
		if (weightLeft + weightRight +1 != a.getWeight()) {
			problems.add("Tree weight not proper");
		}

		if (!treeStructureVerifier(a)) {
			problems.add("Tree structure not proper");
		}
		
		if(!verifyParentReferences(a)){
			problems.add("Parent references not accurate");
		}

		return a.getWeight();
	}

	// Verifies that parents references are correct at node a's children.	
	private static boolean verifyParentReferences(ITreeNode a){
		return !((a.getLeftChild() != null && a.getLeftChild().getParent() != a) || 
				(a.getRightChild() != null && a.getRightChild().getParent() != a));
	}

	// Verifies that the BST property is satisfied at node a.
	private static boolean treeStructureVerifier(ITreeNode a) {
		if (a.getLeftChild() != null && a.getLeftChild().getKey() > a.getKey()) {
			return false;
		}

		if (a.getRightChild() != null
				&& a.getRightChild().getKey() < a.getKey()) {
			return false;
		}

		return true;
	}
	
	
	public static void main(String[] args) {
					
		// Create a TreeNode and insert every integer from 100 down to 1.
		ITreeNode root = new TreeNode(100, null);
		for (int i = 99; i >= 1; i--) {
			root.insert(i);
		}

		// Test the getTreeKeys routine.
		List<Integer> keys = root.getTreeKeys();
		int counter = 1;
		boolean error = false;
		for (int i : keys) {
			if (i != counter) {
				error = true;
				break;
			}
			counter++;
		}

		if (error) {
			System.out.println("TreeNode test case 1 - FAILED");
			error = false;
		} else {
			System.out.println("TreeNode test case 1 - PASSED");
		}

		// Test the buildTree routine.
		ITreeNode tree1 = TreeNode.buildTree(keys);
		if(verifyTree(tree1)){
			System.out.println("buildTree testing - PASSED");
		}else{
			System.out.println("buildTree testing - FAILED");
			for(String err: problems){
				System.out.println("Problems encountered - " + err);
			}
		}
					
	}

}
