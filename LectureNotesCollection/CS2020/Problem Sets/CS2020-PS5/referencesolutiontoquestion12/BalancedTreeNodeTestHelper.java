package sg.edu.nus.cs2020.solutions;

import static org.junit.Assert.assertTrue;

import java.util.EnumSet;

/**
 * This class exists to facilitate testing
 */
public class BalancedTreeNodeTestHelper extends BalancedTreeNode {

	public BalancedTreeNodeTestHelper(int key, ITreeNode parent) {
		super(key, parent);
	}


	/**
	 * Performs checks on a BalancedTreeNode based on checks input.
	 * 
	 * @param a
	 * @param checks
	 */
	public static void verifyTree(ITreeNode a, EnumSet<TreeVerifierCheck> checks) {
		treeVerifier(a, checks);

		return;
	}

	private static int treeVerifier(ITreeNode a,
			EnumSet<TreeVerifierCheck> checks) {
		if (a == null)
			return 0;

		int weightLeft = treeVerifier(a.getLeftChild(), checks);
		int weightRight = treeVerifier(a.getRightChild(), checks);

		if (checks.contains(TreeVerifierCheck.Weight)) {
			assertTrue("Tree weight not proper",
					weightLeft + weightRight + 1 == a.getWeight());
		}

		if (checks.contains(TreeVerifierCheck.Structure)) {
			assertTrue("Tree structure not proper", treeStructureVerifier(a));
		}

		if (checks.contains(TreeVerifierCheck.Balance)) {
			assertTrue(
					"Tree not balanced",
					balancePerserverenceCheck(a.getLeftChild(),
							a.getRightChild()));
		}

		if (checks.contains(TreeVerifierCheck.Parent)) {
			assertTrue("Parent references not accurate!",
					verifyParentReferences(a));
		}

		return a.getWeight();
	}

	private static boolean verifyParentReferences(ITreeNode a) {
		return !((a.getLeftChild() != null && a.getLeftChild().getParent() != a) || (a
				.getRightChild() != null && a.getRightChild().getParent() != a));
	}

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

	private static boolean balancePerserverenceCheck(ITreeNode affectedChild,
			ITreeNode otherChild) {
		// If either subtrees are empty and the other has weight of more than 2
		if (otherChild == null && affectedChild != null
				&& affectedChild.getWeight() >= 2) {
			return false;
		}

		if (affectedChild == null && otherChild != null
				&& otherChild.getWeight() >= 2) {
			return false;
		}

		// Factor of 2 difference check
		if (affectedChild != null
				&& otherChild != null
				&& (affectedChild.getWeight() > 2 * otherChild.getWeight() || affectedChild
						.getWeight() * 2 < otherChild.getWeight())) {
			return false;
		}

		return true;
	}

}
