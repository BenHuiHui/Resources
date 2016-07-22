package sg.edu.nus.cs2020.PS5;

import java.util.Random;

public class BalancedTreeNode_Profiling {
	public static void main(String[] args){
		Random rand = new Random();
		
		BalancedTreeNode tn = new BalancedTreeNode(0, null);
		
		int n=1000;
		
		for(int i=0;i<n;i++){
			tn.insert(rand.nextInt(35000));
			
		}
	}
}
