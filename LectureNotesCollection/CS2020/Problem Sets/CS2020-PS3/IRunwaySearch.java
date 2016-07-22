package sg.edu.nus.cs2020.ps3;

/**
 * Interface for a search tree
 */
public interface IRunwaySearch<typeA, typeB> {
	public void insert(typeA key, typeB data);
	public boolean search(typeA key);
	public typeB dataSearch(typeA key);
	public typeB dataSuccessor(typeA key);
	public typeB dataPredecessor(typeA key);
	public void delete(typeA key);
}
