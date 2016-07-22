/**
 * Part of the SkipList implementation for Lecture 9 of CS2020.
 */
package sg.edu.nus.cs2020;

/**
 * Interface for a simple search tree.
 * @author Seth Gilbert
 *
 * @param <TKey>
 * @param <TData>
 */
public interface ISearchTree<TKey, TData> {	

	void insert(TKey key, TData data);

	boolean search(TKey key);

	TData getData(TKey key);

	void delete(TKey key);
}


