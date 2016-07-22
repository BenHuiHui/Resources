package sg.edu.nus.CS2020;

public class FriendSet implements ISet{
	private String[] names = new String[101];
	private int size = 0;
	private final int MAXSIZE = 100;
	
	
	/**
	 * Constructor 1: with no parameter
	 */
	FriendSet(){
	}
	
	/**
	 * Constructor 2: create a copy of set a
	 */
	FriendSet(ISet a){
		for(int i=0;i<a.size();i++){
			names = a.enumerateSet();
		}
		this.size = a.size();
	}
	
	
	/* Basic Idea: With the add method, I'm keeping the string sorted, alphically assending order
	 * 
	 */
	@Override
	public boolean add(String name) throws Exception {
		int place;	// the place to add p;
		if(size==MAXSIZE){
			throw new Exception("Maxsize reached!");
		}
		
		for(int i=0;i<size;i++){
			if(names[i].compareTo(name)==0){
				return false;
			}
		}
		
		for(place=0;place<size;place++){
			if(names[place].compareTo(name)>0)	break;
		}
		
		for(int i=size;i>place;i--){
			names[i] = names[i-1];
		}
		
		names[place]=name;
		size++;
		return true;
	}

	@Override
	public String[] enumerateSet() {
		String[] res = new String[101];
		for(int i=0;i<size;i++){
			res[i] = names[i];
		}
		return res;
	}

	
	//TODO:
	@Override
	public ISet intersection(ISet otherSet) {
		int aIndex=0,bIndex=0,resIndex=0;
		String b[] = otherSet.enumerateSet();
		String res[] = new String[101];
		
		while(aIndex<this.size() && bIndex<otherSet.size()){
			if(names[aIndex].compareTo(b[bIndex])>0){
				bIndex++;
			}
			else if(names[aIndex].compareTo(b[bIndex])<0){
				aIndex++;
			} else{
				res[resIndex]=names[aIndex];
				resIndex++;
				aIndex++;bIndex++;
			}
		}
		
		FriendSet out = new FriendSet();
		out.size = resIndex;
		for(int i=0;i<resIndex;i++){
			out.names[i] = res[i];
		}
		return out;
	}

	
	@Override
	public int size() {
		return size;
	}

	
	
	public static void main(String[] args) throws Exception {
		ISet setA = new FriendSet();
		boolean added = false;
		added = setA.add("Joe"); // Returns true
		added = setA.add("Mary"); // Returns true
		System.out.println(added);
		added = setA.add("Sue"); // Returns true
		added = setA.add("Joe"); // Returns false
		System.out.println(added);
		
		int setSize = setA.size(); // Returns 3
		System.out.println(setSize);
		String[] setList = setA.enumerateSet(); // Returns an array containing: [Joe, Mary, Sue]
		System.out.println(setList[2]);
		ISet setB = new FriendSet(setA); // Creates a copy of setA
		added = setB.add("Joe"); // Returns false
		System.out.println(added);
		added = setB.add("Leo"); // Returns true
		System.out.println(added);
		ISet setC = setA.intersection(setB); // Returns setC containing [Joe, Mary, Sue]
		setSize = setC.size(); // returns 3
		ISet setD = new FriendSet();
		String John = "John";
		for (int i=1; i<=100; i++){
		setD.add(John + Integer.toString(i, 10)); // Returns true
		}
		setSize = setD.size(); // returns 100
		System.out.println(setSize);
//		added = setD.add("John101"); // Throws an exception!
	}
}
