import java.io.*;
import java.math.*;


public class BSTofBabyNames {

	protected BSTVertexOfBabyNames root;
	protected int count=0;
	
	public BSTofBabyNames()	{root=null;}
	
	//we need to keep checking the height-balanced
	protected BSTVertexOfBabyNames insert(BSTVertexOfBabyNames T,String v,int gender)
	{
		//for null pointer, the height of T has been pre-allocated as 0;
		
		if(T==null)
			return new BSTVertexOfBabyNames(v,gender);
		else if(stringCompare(v,T.key)==0)//v< T.key
		{
			
			T.left=insert(T.left,v,gender);
			T.left.parent=T;
			
			
			T.height=calHeight(T);
			
			if(Math.abs(balanceFactor(T))>1)  //unbalanced BST
				T=rotation(T);
		}
		else
		{
			T.right=insert(T.right,v,gender);
			T.right.parent=T;
			
			T.height=calHeight(T);
			
			if(Math.abs(balanceFactor(T))>1)  //unbalanced BST
				T=rotation(T);
		}
			
		return T;// return updated BST;
	}
	
	
	public void insert(String v,int gender) { root = insert(root, v,gender); }
	
	
	//Compare the stirng
	//eg."ABC"<"ABCD"
	//return 0 means s1<s2;
	//return 1 means s2>s1;
	//return 2 means s2=s1;
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
		else if(s1.length()==s2.length())
			return 2;				
		else return 1;
		
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
	
	
	
	protected BSTVertexOfBabyNames findSuccessor(BSTVertexOfBabyNames T)
	{
		if(T.right!=null)
			return findMin(T.right);
		else
		{
			BSTVertexOfBabyNames par=T.parent;
			BSTVertexOfBabyNames cur=T;
			while(par!=null&&cur==par.right)
			{
				cur=par;
				par=cur.parent;
			}
			if(par==null)	return null;
			
			else
			{	
				return par;
			}
		}
	}
	
	protected BSTVertexOfBabyNames findMin(BSTVertexOfBabyNames T)
	{
		if(T==null)	 return null;
		else if(T.left==null)	return T;
		else	return findMin(T.left);
	}
	
	protected BSTVertexOfBabyNames findStart(BSTVertexOfBabyNames T,String start)
	{
		while(findSuccessor(T)!=null&&stringCompare(start,T.key)==1)
		{
			T=findSuccessor(T);
		}
		if(T==null)	return null;
		else return T;
	}
	
	protected BSTVertexOfBabyNames findStart(String start)
	{
		return findStart(findMin(root),start);
	}
	
	protected void inorderSolutionFast(String start,String end,int genderPreference)
	{
		count=0;
		BSTVertexOfBabyNames startV=findStart(start);
		inorderSolutionFast(startV,end,genderPreference);
	}
	
	
	protected void inorderSolutionFast(BSTVertexOfBabyNames cur,String end,int genderPreference)
	{
		
		if(cur==null)		return;
		else if(stringCompare(end,cur.key)==0||stringCompare(end,cur.key)==2)	return;
		if(isSuitableName(cur,genderPreference))
				count++;
		inorderSolutionFast(findSuccessor(cur),end,genderPreference);
	}
	
	protected boolean isSuitableName(BSTVertexOfBabyNames T,int genderPreference)
	{
	
		if(genderPreference==0)
				return true;
		else if(genderPreference!=0&&T.gender==genderPreference)
				return true;
		else 
				return false;

	}
	
	protected boolean isSuitableName(BSTVertexOfBabyNames T,String start,String end,int genderPreference)
	{
		int startComparsion=stringCompare(start,T.key);
		if((startComparsion==0||startComparsion==2)&&
				stringCompare(end,T.key)==1)
		{
			if(genderPreference==0)
				return true;
			else if(genderPreference!=0&&T.gender==genderPreference)
				return true;
			else 
				return false;
		}
			
		else 
			return false;
	}
	
	protected void inorder(BSTVertexOfBabyNames T,String start,String end,int genderPreference)
	{
		if(T==null)	return ;
		inorder(T.left,start,end,genderPreference);
		if(isSuitableName(T,start,end,genderPreference))
			count++;
		inorder(T.right,start,end,genderPreference);
		
	}
	
	protected void inorder(String start,String end,int genderPreference)
	{
		count=0;
		inorder(root,start,end,genderPreference);
	}
	
}
	

