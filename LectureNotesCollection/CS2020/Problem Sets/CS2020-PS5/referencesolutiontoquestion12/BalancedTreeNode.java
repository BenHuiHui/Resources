/**
 * @author Cliff Koh Zi Han 
 */
package sg.edu.nus.cs2020.solutions;

public class BalancedTreeNode extends TreeNode {

	/**
	 * Constructor
	 * 
	 * @param key
	 * @param parent
	 *            assumed to extend TreeNode
	 */
	public BalancedTreeNode(int key, ITreeNode parent) {
		super(key, parent);
		if (parent!= null && !(parent instanceof TreeNode)) {
			System.err
					.println("Parent must be TreeNode or be a derived class of TreeNode! This property has been violated and correct functioning is not assured.");
		}
	}

	/**
	 * Inserts an element into the tree, efficiently re-balancing the tree if it
	 * goes out of balance.
	 * 
	 * @param key
	 */
	@Override
	public void insert(int key) {

		// We take an iterative approach here

		// One of the oddness of this question is that the interface has no
		// setLeft/setRight child.
		// We thus assume that BalancedTreeNode has full knowledge of TreeNode
		// and uses directly the leftChild/rightChild fields.
		TreeNode node = this;

		while (true) {
			node.weight += 1;
			if (key < node.key) {
				if (node.leftChild == null) {
					node.leftChild = new BalancedTreeNode(key, node);
					break;
				} else {
					// One of the limitations given the question setup involves
					// this constant cast. The validity of this cast is ensured
					// since leftChild and rightChild are protected members of
					// TreeNode.
					node = (TreeNode) node.getLeftChild();
				}
			} else if (key > node.key) {
				if (node.rightChild == null) {
					// Likewise down here.
					node.rightChild = new BalancedTreeNode(key, node);
					break;
				} else {
					node = (TreeNode) node.getRightChild();
				}
			} else {
				// repeated key, we do cease and return quietly.
				return;
			}
		}

		// Now we traverse up the tree checking for balance.
		TreeNode highestUnbalancedNode = null;
		do {
			if (!balancePerserverenceCheck(node.getLeftChild(),
					node.getRightChild())) {
				// update the highestUnbalancedNode
				highestUnbalancedNode = node;
			}

			if (node.getParent() != null) {
				node = (TreeNode) node.getParent();
			} else {
				break;
			}
			
		} while (true);

		if (highestUnbalancedNode != null) {
			// this means there was a point in the tree that was unbalanced
			TreeNode newTree = TreeNode.buildTree(highestUnbalancedNode.getTreeKeys());
			
			// check if highestUnbalancedNode is the same node as what the insert method was called on
			if(highestUnbalancedNode == this){
				// we need to replace "this"
				this.key = newTree.key;
				this.leftChild = newTree.leftChild;
				this.rightChild = newTree.rightChild;
				if(this.leftChild!= null){
					((TreeNode)this.leftChild).parent = this;
				}
				if(this.rightChild!= null){
					((TreeNode)this.rightChild).parent = this;
				}
				this.weight = newTree.getWeight();
				newTree = this;
			}
			
			// update parent
			newTree.parent = highestUnbalancedNode.parent;
			
			// replace the position in the tree
			if(highestUnbalancedNode.parent != null){
				TreeNode temp = (TreeNode)highestUnbalancedNode.parent;
				if(temp.leftChild == highestUnbalancedNode){
					temp.leftChild = newTree;
				}else{
					temp.rightChild = newTree;
				}
			}
		}
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
		}//E:\Documents\Documents(From D)\My Dropbox\On Learning\modules\current\CS2020\Assignment\CS2020-PS5

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
