package sg.edu.nus.CS2020;


public class UserDatabase implements IUserDB{
	private String[] users = new String[500];
	private ISet[] friendSet = new FriendSet[500];
	private int[] numFriends = new int[500];	// by default the element's are 0 valued
	private int size = 0;
	
	
	
	/* 
	 * Based on the requirement, this rotine would never return false actually
	 */
	@Override
	public boolean addFriend(String userOne, String userTwo) throws Exception {
		// can use binary search here for better performance
		int userOneIndex,userTwoIndex;
		
		// first we find userOne's index
		for(userOneIndex=0;userOneIndex<size;userOneIndex++){
			if(users[userOneIndex].compareTo(userOne)==0){
				break;
			}
		}
		if(userOneIndex==size){
			throw new Exception(userOne + " unfind");
		}
		
		// find userTwo's index
		for(userTwoIndex=0;userTwoIndex<size;userTwoIndex++){
			if(users[userTwoIndex].compareTo(userTwo)==0){
				break;
			}
		}
		if(userTwoIndex==size){
			throw new Exception(userTwo + " unfind");
		}
		
		// then we add them to each other's friend set
		friendSet[userOneIndex].add(userTwo);
		friendSet[userTwoIndex].add(userOne);
		numFriends[userOneIndex]++;numFriends[userTwoIndex]++;
		
		return true;
	}

	@Override
	public boolean addUser(String name) throws Exception {
		int place;	// the place to add p;
		if(size==500){
			throw new Exception("Maxsize reached!");
		}
		
		// can use binary search here for better performance
		for(int i=0;i<size;i++){
			if(users[i].compareTo(name)==0){
				return false;
			}
		}
		
		for(place=0;place<size;place++){
			if(users[place].compareTo(name)>0)	break;
		}
		
		// copy the rest of the names+friend set to the new place
		for(int i=size;i>place;i--){
			users[i] = users[i-1];
			friendSet[i] = friendSet[i-1];
		}
		
		users[place]=name;
		friendSet[place]= new FriendSet();
		size++;numFriends[place]++;
		return true;
	}

	@Override
	public String[] findFriendsInCommon(String userOne, String userTwo)
			throws Exception {
		
		// firstly we find the corresponding index
		// can use binary search here for better performance
		int userOneIndex,userTwoIndex;
		
		// first we find userOne's index
		for(userOneIndex=0;userOneIndex<size;userOneIndex++){
			if(users[userOneIndex].compareTo(userOne)==0){
				break;
			}
		}
		if(userOneIndex==size){
			throw new Exception(userOne + " unfind");
		}
		
		// find userTwo's index
		for(userTwoIndex=0;userTwoIndex<size;userTwoIndex++){
			if(users[userTwoIndex].compareTo(userTwo)==0){
				break;
			}
		}
		if(userTwoIndex==size){
			throw new Exception(userTwo + " unfind");
		}
		
		// after that, we find the common friend
		ISet resSet = friendSet[userOneIndex].intersection(friendSet[userTwoIndex]);
		return resSet.enumerateSet();
	}

	@Override
	public String findMostPopularUser() throws Exception {
		int max=-1,maxIndex=-1;
		if(size==0){
			throw new Exception("No User here!");
		}
		for(int i=0;i<size;i++){
			if(max>numFriends[i])	maxIndex = i;
		}
		System.out.println(numFriends[1]);
		return users[maxIndex];
	}
	
	
	/** For testing purpose
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		IUserDB userDB = new UserDatabase();
		boolean added = false;
		added = userDB.addUser("Alice"); // Returns true
		System.out.println(added);added=false;
		added = userDB.addUser("Bob"); // Returns true
		added = userDB.addUser("Charlie"); // Returns true
		added = userDB.addUser("Diana"); // Returns true
		added = userDB.addUser("Eli"); // Returns true
		added = userDB.addUser("Joe"); // Returns true
		System.out.println(added);
		userDB.addFriend("Alice", "Bob");
		userDB.addFriend("Bob", "Charlie");
		String[] commonFriends = userDB.findFriendsInCommon("Alice", "Charlie");
		// Returns an array containing [Bob].
		//userDB.addFriend("Alice", "Jim"); // Throws an exception: Jim is not a user!
		userDB.addFriend("Charlie", "Alice");
		userDB.addFriend("Charlie", "Bob"); // Already friends, but that's ok.
		userDB.addFriend("Charlie", "Diana");
		userDB.addFriend("Charlie", "Eli");
		userDB.addFriend("Charlie", "Joe");
		// Charlie's popularity is 5
		String popular = userDB.findMostPopularUser(); // Charlie is the most popular.
		userDB.addUser("Kate");
		userDB.addUser("Larry");
		userDB.addFriend("Bob", "Kate");
		userDB.addFriend("Bob", "Larry");
		userDB.addFriend("Bob", "Eli");
		//Charlie's popularity is still 5
		// Bob's popularity is also 5
		//popular = userDB.findMostPopularUser(); // May return Bob or Charlie.

	}
}
