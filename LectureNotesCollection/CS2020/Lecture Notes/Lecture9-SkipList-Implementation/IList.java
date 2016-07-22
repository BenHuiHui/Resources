/**
 * @author Seth Gilbert
 * 
 * List Interface for Lecture 9 of CS2020.
 */
package sg.edu.nus.cs2020;

/**
 * Interface for a list that stores key/data pairs.
 * The keys for this list are always ints, while the data is of type TData.
 * @param <TData> data type.
 */
public interface IList<TData> {
	public int getKey(int index) throws LinkedListException;
	public TData getData(int index) throws LinkedListException;

	public void prepend(int key, TData data) throws LinkedListException;
	public void append(int key, TData data) throws LinkedListException;
	public void append(IList<TData> list) throws LinkedListException;
	
	public boolean isEmpty() throws LinkedListException;
	public int getSize() throws LinkedListException;
}
