package sg.edu.nus.cs2020.ps3;

import java.util.List;

/**
 * Interface for a tree node class
 */
public interface ITreeNode {
	public ITreeNode getLeftChild();
	public ITreeNode getRightChild();
	public ITreeNode getParent();
	public int getWeight();
	public int getKey();
	public List<Integer> getTreeKeys();
	public void insert(int number);
	public boolean search(int number);
}
