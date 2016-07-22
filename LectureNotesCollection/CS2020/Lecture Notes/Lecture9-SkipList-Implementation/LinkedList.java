/**
 * Linked List implementation for Lecture 9 of CS2020.
 * 
 * @author Seth Gilbert
 *
 * @param <TData>
 */
package sg.edu.nus.cs2020;

public class LinkedList<TData> implements IList<TData> {
	
	/**
	 * Final variables used as dummy values for the head
	 * and tail nodes of the linked list.
	 */
	public static final int HEAD_KEY = Integer.MIN_VALUE;
	public static final int TAIL_KEY = Integer.MAX_VALUE;
	
		
	/**
	 * Class variables for the head and tail of the list, and 
	 * the size of the list.
	 */
	private ListNode<TData> m_head = null;
	private ListNode<TData> m_tail = null;
	private int m_size = 0;
	
	/**
	 * Constructor for the linked list.
	 */
	LinkedList()
	{
		m_head = new ListNode<TData>(HEAD_KEY, null);
		m_tail = new ListNode<TData>(TAIL_KEY, null);
		m_head.insertAfter(m_tail);
		m_size = 0;
	}
	
	/**
	 * Returns the key at the specified index.
	 * Note that the index is 0-based.
	 */
	@Override
	public int getKey(int index) throws LinkedListException {
		if (index >= m_size) {
			throw new LinkedListException();
		}
		
		ListNode<TData> iterator = m_head.getNext();
		for (int i=0; i<index; i++)
		{
			iterator = iterator.getNext();
		}
		return iterator.getKey();
	}

	/**
	 * Returns the data for the specified index.
	 * Note that the index is 0-based.
	 */
	@Override
	public TData getData(int index) throws LinkedListException {
		if (index >= m_size) {
			throw new LinkedListException();
		}
		
		ListNode<TData> iterator = m_head.getNext();
		for (int i=0; i<index; i++)
		{
			iterator = iterator.getNext();
		}
		return iterator.getData();
	}
	
	/**
	 * Inserts a new key/data pair at the beginning of the list.
	 */
	@Override
	public void prepend(int key, TData data) throws LinkedListException {
		m_head.insertAfter(key,data);	
		m_size++;
	}

	/**
	 * Adds a new key/data pair at the end of the list.
	 */
	@Override
	public void append(int key, TData data) throws LinkedListException{
		m_tail.getPrevious().insertAfter(key, data);
		m_size++;		
	}

	/**
	 * Appends the new list to the end of the current list. 
	 * Note that the new list must be a LinkedList.
	 */
	@Override
	public void append(IList<TData> newList) throws LinkedListException{
		// Check whether the list is a LinkedList.
		// If not, throw an exception.
		if (!(newList instanceof LinkedList)){
			throw new LinkedListException();
		}
				
		ListNode<TData> lastNode = m_tail.getPrevious();
		ListNode<TData> firstNewNode = 
				((LinkedList<TData>)newList).m_head.getNext();
		lastNode.appendList(firstNewNode);
		m_tail = ((LinkedList<TData>)newList).m_tail;		
		m_size += ((LinkedList<TData>)newList).m_size;
	}

	/**
	 * Returns whether the list is empty.
	 */
	@Override
	public boolean isEmpty() throws LinkedListException{
		return (m_size == 0);
	}

	/**
	 * Returns the size of the list.
	 */
	@Override
	public int getSize() throws LinkedListException { 
		return m_size;
	}
}
