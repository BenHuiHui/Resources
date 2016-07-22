/* Information: 
 * 	for the test of this class, please refer to the main method at the end of this file.
 *  One can change the number of elements generated when testing
 *  It's sufficient to test the correctness because every method has been used, and every path 
 *  	has been gone through. 
 */

package sg.edu.nus.cs2020.ps3;

import java.util.*;

public class TreeNode implements ITreeNode {
	private TreeNode leftChild = null;
	private TreeNode rightChild = null;
	private TreeNode parent = null;
	private int weight = 0;
	private int key;
	private int count = 0;
	
	public ITreeNode getLeftChild() {
		return leftChild;
	};

	public ITreeNode getRightChild() {
		return rightChild;
	};

	public ITreeNode getParent() {
		return parent;
	};
	
//	weight = left.weight + right.weight + 1 
	public int getWeight() {
		return weight;
	};
	
	
	// for test only: to print the weight of each node
	void printWeight(){
		count=0;
		printWeightRecur(this);
	}
	
	private void printWeightRecur(TreeNode node){
		if(node.leftChild!=null)printWeightRecur(node.leftChild);
		System.out.println("the " +  this.count++ + "th element, key: " + node.key + 
				", weigth= " + node.weight);
		if(node.rightChild!=null)printWeightRecur(node.rightChild);
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
	
	private void keysTreeWalk(List<Integer> res){
		if(this.leftChild!=null)	this.leftChild.keysTreeWalk(res);
		res.add(this.key);
		if(this.rightChild!=null)	this.rightChild.keysTreeWalk(res);
	}
	
	// assumption: this number does't duplicate with any number in the tree
	// 	if duplicates, then right child can be equal to its parent 
	public void insert(int number) {
		this.weight++;	// the weight is going to increase anyway
		if(this.key>number){
			if(this.leftChild!=null){
				this.leftChild.insert(number);
			}
			else this.leftChild = new TreeNode(this,number,1);
		}
		else{
			if(this.rightChild!=null){
				this.rightChild.insert(number);
			}
			else this.rightChild = new TreeNode(this,number,1);
		}
	};
	
	public boolean search(int number){
		if(this.key>number)
			return this.leftChild==null ? false:(this.leftChild.search(number));
		else if(this.key<number)
			return this.rightChild==null ? false:(this.rightChild.search(number));
		else return true;	// this is when this.key==number
	};
	
	// Assumption: a is a sorted list, with no duplicate
	static ITreeNode buildTree(List<Integer> a){		
		return buildNode(0,a.size()-1,a);
	}
	
	private static TreeNode buildNode(int startIndex, int endIndex, List<Integer> a){
		if(startIndex>endIndex)return null;
		
		int currentIndex = (startIndex + endIndex)/2;
		
		// set the current tree node
		TreeNode node = new TreeNode(null,a.get(currentIndex),endIndex-startIndex+1);
			// if the left/right child is null, then weight doesn't exist
		node.leftChild = buildNode(startIndex,currentIndex-1,a);
		node.rightChild = buildNode(currentIndex+1,endIndex,a);
		
		// the parent of the left/right child, is setted in the current node
		if(node.leftChild!=null)node.leftChild.parent = node;
		if(node.rightChild!=null)node.rightChild.parent = node;
		return node;
	}
	
	private TreeNode(TreeNode parent, int key, int weight){
		this.weight = weight;
		this.key = key;
		this.parent = parent;
	}
	
	
	// this main method is used for test
	public static void main(String[] args) {
		Random rand = new Random(47);
		List<Integer> seed = new ArrayList<Integer>();
		
		// temp var
		int i=0,t;
		while(i<10){
			t=rand.nextInt(98);
			if(!seed.contains(t)){
				seed.add(t);i++;
			}
		}
		Collections.sort(seed);
		System.out.println(seed);
		
		ITreeNode tree = TreeNode.buildTree(seed);
		
		// test Search
		System.out.println("search for 12: " + tree.search(12));
		
		// test inserting elements
		tree.insert(12);tree.insert(14);
		System.out.println(tree.getTreeKeys());
		
		// after insert, test Search
		System.out.println("After inserting 12, search for 12: " + tree.search(12));
		
		// for using the printWeight method to output the weight, check if it is correct 
		TreeNode test = (TreeNode)tree;
		test.printWeight();
		
	}
}
