/**
 * SkipList implementation for Lecture 9 of CS2020.
 * @author Seth Gilbert
 */
package sg.edu.nus.cs2020;

import java.lang.Integer;
import java.util.Random;

/**
 * SkipList implements the basic search tree interface.
 * @author Seth Gilbert
 *
 * @param <TData>
 */
public class SkipList<TData> implements ISearchTree<Integer, TData>{	

	/**
	 * Final variable used as dummy value for
	 * head nodes in the linked lists.
	 */
	public static final int HEAD_KEY = Integer.MIN_VALUE;	
	
	/**
	 * Class member variables
	 */
	// Head of the top list
	SkipListNode<TData> m_ListHead;
	// Head of the bottom list
	SkipListNode<TData> m_AllKeyLinkedList;
	
	/**
	 * Constructor.
	 * Creates an empty SkipList.
	 */
	SkipList()
	{
		m_ListHead = new SkipListNode<TData>(HEAD_KEY, null);
		m_AllKeyLinkedList = m_ListHead;
	}
	
	/**
	 * Inserts a key/data pair into the SkipList
	 */
	@Override	
	public void insert(Integer key, TData data) {	
		// Check for errors:
		if ((key==null) || (key==HEAD_KEY))
		{
			// Better to throw an exception here?
			return;
		}
		
		// Create the new node to insert.
		SkipListNode<TData> newNode = new SkipListNode<TData>(key, data);
		// Search for the insertion point in the bottom list.
		SkipListNode<TData> insertNode = searchPredecessorNode(key);
		// Initialize the random number generator
		Random generator = new Random();
		
		// During the following loop:
		//    newNode is the node to be inserted.
		//    insertNode is the node to insert newNode after.		
		while (insertNode != null) {	
			// Do the insertion
			insertNode.insertAfter(newNode);
			// Flip a random coin
			boolean goUp = generator.nextBoolean();
			// If we gets heads, we will continue at the next level.
			if (goUp) {
				// Find the new insertNode
				insertNode = newNode.searchUp();
				// If the next level is empty, then create a new list.
				if (insertNode == null) {
					// The new list begins with a new list head.
					insertNode = new SkipListNode<TData>(HEAD_KEY, null);					
					insertNode.setDown(m_ListHead);
					m_ListHead.setUp(insertNode);
					// Set m_ListHead to be the head of the new top list.
					m_ListHead = insertNode;
				}
				// Create the node to be inserted at the next level.
				SkipListNode<TData> nextNewNode = new SkipListNode<TData>(key, data);
				// Initialize the new node.
				nextNewNode.setDown(newNode);
				newNode.setUp(nextNewNode);
				newNode = nextNewNode;
			}
			// Otherwise, if we flip tails, then we are done.
			else {
				insertNode = null;		
			}
		}
	}

	/**
	 * Is there a node with the specified key?
	 */
	@Override
	public boolean search(Integer key) {
		SkipListNode<TData> node = searchPredecessorNode(key);
		return (node.getKey() == key);		
	}

	/**
	 * Get the data from the node with the specified key (if possible).
	 */
	@Override
	public TData getData(Integer key) {
		SkipListNode<TData> node = searchPredecessorNode(key);
		if (node.getKey() == key){
			return node.getData();
		}
		else{
			return null;
		}		
	}	

	/**
	 * Find the largest node with a key that is <= the specified key.
	 * @param key
	 * @return predecessor node
	 */
	public SkipListNode<TData> searchPredecessorNode(Integer key)
	{
		// Start at the beginning of the top list.
		SkipListNode<TData> iterator = m_ListHead;
		
		// Continue until we can't go any further.
		while (iterator != null && (iterator.getKey() <= key)) {
			// Get the next node and the down node.
			SkipListNode<TData> nextNode = iterator.getNext();			
			SkipListNode<TData> downNode = iterator.getDown();
			
			// If we can go left, then go left.
			if ((nextNode != null) && (nextNode.getKey() <= key)){
					iterator = nextNode;
			} // If we can't go left, then go down.
			else if (downNode != null){
				iterator = downNode;				
			} // If we can't go left or down, we must be at the right point of the bottom list.
			else{
				return iterator;
			}
		}
		return null;
	}
	
	/**
	 * Deletes the node with the specified key in the SkipList.
	 */
	@Override	
	public void delete(Integer key) {
		// Find the node to delete.
		SkipListNode<TData> node = searchPredecessorNode(key);
		if (key != node.getKey()){
			return;
		}
		SkipListNode<TData> next = node;
		
		// Iterate up through the lists, deleting the
		// node from all the lists.
		while (node != null){	
			next = node.getUp();
			node.delete();	
			node = next;
		}
	}
}
