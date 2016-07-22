/**
 * Part of the SkipList implementation for Lecture 9 of CS2020.
 * Extends the ListNode.
 * 
 * @author Seth Gilbert
 *
 * @param <TData>
 */
package sg.edu.nus.cs2020;

/**
 * A node in a SkipList is a list node with the addition of up and down pointers.
 * 
 * @author Seth Gilbert
 *
 * @param <TData>
 */
public class SkipListNode<TData> extends ListNode<TData> {

	/**
	 * Class member variables:
	 * A pointer up and down.
	 */
	SkipListNode<TData> m_up;
	SkipListNode<TData> m_down;
	
	/**
	 * Constructor
	 * @param key
	 * @param data
	 */
	SkipListNode(int key, TData data)
	{
		super(key, data);
		m_up = null;
		m_down = null;
	}

	/**
	 * Returns the node above it in the SkipList.
	 * @return up pointer
	 */
	public SkipListNode<TData> getUp()
	{
		return m_up;
	}
	
	/**
	 * Returns the node below it in the SkipList
	 * @return down pointer
	 */
	public SkipListNode<TData> getDown()
	{
		return m_down;
	}
	
	/**
	 * Sets the node above it in the SkipList
	 * @param newUp
	 */
	void setUp(SkipListNode<TData> newUp)
	{
		m_up = newUp;
	}
	
	/**
	 * Sets the node below it in the SkipList.
	 * @param newDown
	 */
	void setDown(SkipListNode<TData> newDown)
	{
		m_down = newDown;
	}
	
	/**
	 * Returns the next node in the list.
	 */
	public SkipListNode<TData> getNext()
	{
		return (SkipListNode<TData>)m_next;
	}
	
	/**
	 * Returns the previous node in the list.
	 */
	public SkipListNode<TData> getPrevious()
	{
		return (SkipListNode<TData>)m_prev;
	}
	
	/**
	 * Inserts a a new key/data pair as a SkipListNode.
	 */
	public void insertAfter(int key, TData data)
	{
		SkipListNode<TData> newNode = new SkipListNode<TData>(key, data);
		insertAfter(newNode);
	}
	
	/**
	 * Searches for the first preceding node in the list which has a
	 * non-null up pointer, and returns that up pointer.
	 * @return The first preceding node at the next level of the SkipList.
	 */
	public SkipListNode<TData> searchUp()
	{
		SkipListNode<TData> upNode = null;
		SkipListNode<TData> iterator = this;
		
		while (upNode == null && iterator != null)
		{
			upNode = iterator.getUp();
			iterator = iterator.getPrevious();
		}
		
		return upNode;
	}
}


