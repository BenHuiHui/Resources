import java.util.*;

// write your matric number here:
// write your name here:
// write list of collaborators here (reading someone's post in IVLE discussion forum and using the idea is counted as collaborating):

class BabyNamesR {
  // if needed, declare a private data structure here that
	BSTofBabyNames T=new BSTofBabyNames();
  // is accessible to all methods in this class

  public BabyNamesR() {
    // Write necessary codes during construction;
    //
    // write your answer here
	


  }

  void AddSuggestion(String babyName) {
    // You have to insert the information (babyName, genderSuitability)
    // into your chosen data structure
    //
    // write your answer here

	T.insert(babyName);
	

  }

  int Query(String subString) {
    int count = 0;

    // You have to answer how many baby names starts
    // with prefix that is inside query interval [START..END)
    //
    // write your answer here
   T.inorder(subString);
   count=T.count;

    return count;
  }
  
  void run() {
    // do not alter this method
    Scanner sc = new Scanner(System.in);
    int N = sc.nextInt();
    while (N-- > 0)
      AddSuggestion(sc.next());

    int Q = sc.nextInt();
    while (Q-- > 0)
      System.out.println(Query(sc.next() ));   // subString 
    
    sc.close();
  }

  public static void main(String[] args) {
    // do not alter this method
    BabyNamesR ps1 = new BabyNamesR();
    ps1.run();
  }
}


class BSTVertexOfBabyNames {

	BSTVertexOfBabyNames(String v) { key=v; parent = left = right = null; height = 0; }
	BSTVertexOfBabyNames parent, left, right;
	String key=new String();
	int height;

}


 class BSTofBabyNames {

	protected BSTVertexOfBabyNames root;
	protected int count=0;
	
	public BSTofBabyNames()	{root=null;}
	
	//we need to keep checking the height-balanced
	protected BSTVertexOfBabyNames insert(BSTVertexOfBabyNames T,String v)
	{
		//for null pointer, the height of T has been pre-allocated as 0;
		
		if(T==null)
			return new BSTVertexOfBabyNames(v);
		else if(stringCompare(v,T.key)==0)//v< T.key
		{
			
			T.left=insert(T.left,v);
			T.left.parent=T;
			
			
			T.height=calHeight(T);
			
			if(Math.abs(balanceFactor(T))>1)  //unbalanced BST
				T=rotation(T);
		}
		else
		{
			T.right=insert(T.right,v);
			T.right.parent=T;
			
			T.height=calHeight(T);
			
			if(Math.abs(balanceFactor(T))>1)  //unbalanced BST
				T=rotation(T);
		}
			
		return T;// return updated BST;
	}
	
	
	public void insert(String v) { root = insert(root, v); }
	
	
	//Compare the stirng
	//eg."ABC"<"ABCD"
	protected int stringCompare(String s1,String s2)
	{
		int shortLength=Math.min(s1.length(), s2.length());
		for(int i=0;i<shortLength;i++)
		{
			if(s1.charAt(i)<s2.charAt(i))
				return 0;
			else if(s1.charAt(i)>s2.charAt(i))
				return 1;	
		}
		//if the first shrotLenghtTH characters of s1 and s2 are same 
		if(s1.length()<=s2.length())   //it's a close situation. 
			return 0;
		else 
			return 1;                
		
	}
	
	protected int balanceFactor(BSTVertexOfBabyNames T)
	{
		if(T.left==null)
			return 0-T.right.height;
		else if(T.right==null)
			return T.left.height;
		else
			return T.left.height-T.right.height;
	}
	
	protected BSTVertexOfBabyNames rotation(BSTVertexOfBabyNames T)
	{
		if(balanceFactor(T)==2&&balanceFactor(T.left)==1)  //it is like "/"  
			T=rightRotate(T);
		
		else if(balanceFactor(T)==2&&balanceFactor(T.left)==-1) //it is like"<"
		{
			T.left=leftRotate(T.left);      //make it like "/"
			T=rightRotate(T);
		}
		
		else if(balanceFactor(T)==-2&&balanceFactor(T.right)==1)
			T=leftRotate(T);
		
		else if(balanceFactor(T)==-2&&balanceFactor(T.right)==1)
		{
			T.right=rightRotate(T.right);
			T=leftRotate(T);
		}
		
		return T;
	}
	
	protected BSTVertexOfBabyNames leftRotate(BSTVertexOfBabyNames T)
	{
		BSTVertexOfBabyNames temp=T.right;
		temp.parent=T.parent;
		T.parent=temp;
		T.right=temp.left;   //very important do remember write this line.
		
		if(temp.left!=null)	
			temp.left.parent=T;
		
		temp.left=T;
		
		temp.height=calHeight(temp);
		T.height=calHeight(T);
		T.parent.height=calHeight(T.parent);
		return temp;
	}
		
	
	protected BSTVertexOfBabyNames rightRotate(BSTVertexOfBabyNames T)
	{
		BSTVertexOfBabyNames temp=T.left;
		temp.parent=T.parent;
		T.parent=temp;
		T.left=temp.right;
		if(temp.right!=null)	temp.right.parent=T;
		
		temp.right=T;
		
		temp.height=calHeight(temp);
		T.height=calHeight(T);
		T.parent.height=calHeight(T.parent);
		return temp;
		
	}
	
	protected int calHeight(BSTVertexOfBabyNames T)
	{
		if (T.left==null&&T.right==null)
			return 0;
		else if(T.left==null)
			return T.right.height+1;
		else if(T.right==null)
			return T.left.height+1;
		else 
			{return Math.max(T.left.height,T.right.height)+1;}
	}
	
	
	protected void inorder(BSTVertexOfBabyNames T,String subString)
	{
		if(T==null)	return ;
		inorder(T.left,subString);
		if(isSubString(T,subString))
			count++;
			
		inorder(T.right,subString);
		
	}
	
	protected void inorder(String subString)
	{
		count=0;
		inorder(root,subString);
	}
	
	//check whether this subString is the subString of T.key
	//equal string is also considered as subString.
	//eg."ABCD" is a subString of "ABCD"
	protected boolean isSubString(BSTVertexOfBabyNames T,String subString)
	{
		String babyName=T.key;
		int stringLength=subString.length();
		boolean identical=false;
		
		for(int i=0;i<babyName.length();i++)
		{
			if(i+stringLength>babyName.length())
				return false;
			for(int start=0;start<stringLength;start++)
			{
				if(babyName.charAt(i+start)==subString.charAt(start))
					identical=true;
				else
				{
					identical=false;
					break;
				}
			}
			if(identical)	return true;		
			
			
		}
		
		return false;
		
	}
	
}
	