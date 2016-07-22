/**
 * @author Seth Gilbert 
 * 
 * Comments: Part of the SkipList implementation for Lecture 9 of CS2020.
 *           
 */
package sg.edu.nus.cs2020;

/**
 * A node implementation for a linked list.
 * 
 * @author Seth Gilbert
 *
 * @param <TData> 
 */
public class ListNode<TData> {
	
	/**
	 * Class member variables
	 */
	int m_key;
	TData m_data;
	ListNode<TData> m_next;
	ListNode<TData> m_prev;

	/**
	 * Constructor
	 * @param key
	 * @param data
	 */
	ListNode(int key, TData data)
	{
		m_key = key;
		m_data = data;
		m_next = null;
		m_prev = null;
	}
	
	/**
	 * Gets the key for the node.
	 * @return key
	 */
	public int getKey()
	{
		return m_key;
	}
	
	/**
	 * Gets the data associated with the node.
	 * @return data
	 */
	public TData getData()
	{
		return m_data;
	}
	
	/**
	 * Gets the next node in the list.
	 * @return next pointer
	 */
	public ListNode<TData> getNext()
	{
		return m_next;
	}
	
	/**
	 * Gets the previous node in the list.
	 * @return prev pointer
	 */
	public ListNode<TData> getPrevious()
	{
		return m_prev;
	}
	
	/**
	 * Sets the next node in the list.
	 * @param nextNode
	 */
	public void setNext(ListNode<TData> nextNode) 
	{
		m_next = (ListNode<TData>)nextNode;
	}
	
	/**
	 * Sets the previous node in the list.
	 * @param prevNode
	 */
	public void setPrevious(ListNode<TData> prevNode) 
	{
		m_prev = (ListNode<TData>)prevNode;
	}	
	
	/**
	 * Inserts the specified key/data pair after this node.
	 * @param key
	 * @param data
	 */
	public void insertAfter(int key, TData data)
	{
		ListNode<TData> newNode = new ListNode<TData>(key, data);
		insertAfter(newNode);
	}
	
	/**
	 * Inserts the specified newNode after this node.
	 * Note: assumes that newNode is not part of another list.
	 * @param newNode
	 */
	public void insertAfter(ListNode<TData> newNode)
	{		
		if (newNode == null){
			return;
		}
		newNode.setPrevious(this);
		newNode.setNext(m_next);
		if (m_next != null){
			m_next.setPrevious(newNode);
		}		
		setNext(newNode);
	}
	
	/**
	 * Appends the list starting at headNode after this node.
	 * @param headNode
	 */
	public void appendList(ListNode<TData> headNode)
	{
		this.setNext(headNode);
		headNode.setPrevious(this);
	}
	
	/**
	 * Deletes this node.
	 */
	public void delete()
	{
		if (m_prev != null){
			m_prev.setNext(m_next);
		}
		if (m_next != null){
			m_next.setPrevious(m_prev);
		}
		m_next = null;
		m_prev = null;
	}	
}
