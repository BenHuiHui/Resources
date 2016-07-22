package sg.edu.nus.cs2020.solutions;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import java.util.EnumSet;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

public class BalancedTreeNodeBasicTest {

	private final static EnumSet<TreeVerifierCheck> BalanceCheck = EnumSet.of(TreeVerifierCheck.Balance);
	private final static EnumSet<TreeVerifierCheck> OthersCheck = EnumSet.complementOf(BalanceCheck);
	
	public static BalancedTreeNode ConstructTreeNode(int key){
		return new BalancedTreeNode(key, null);
	}
	
	/**
	 * This class tests a basic balancing
	 */
	@Test public void BasicRebalanceTestingBalance(){
		BalancedTreeNode root = ConstructTreeNode(1);
		int[] arr = {2,3};
		for(int a : arr){
			root.insert(a);
		}
		BalancedTreeNodeTestHelper.verifyTree(root, BalanceCheck);
		assertEquals(2,root.getKey());
	}
	
	/**
	 * Test if other properties are adhered to after basic balance
	 */
	@Test public void BasicRebalanceTestingOthers(){
		BalancedTreeNode root = ConstructTreeNode(1);
		int[] arr = {2,3};
		for(int a : arr){
			root.insert(a);
		}
		BalancedTreeNodeTestHelper.verifyTree(root, OthersCheck);
	}
	
	/**
	 * This tests if the tree continues to balance after an initial balance
	 */
	@Test public void RebalanceAndBalanceAgainTestingBalance(){
		BalancedTreeNode root = ConstructTreeNode(1);
		int[] arr = {2,3,4,5,6};
		for(int a : arr){
			root.insert(a);
		}
		BalancedTreeNodeTestHelper.verifyTree(root, BalanceCheck);
	}
		
	@Test public void RebalanceAndBalanceAgainTestingWeightAndElements(){
		BalancedTreeNode root = ConstructTreeNode(1);
		int[] arr = {2,3,4,5,6};
		for(int a : arr){
			root.insert(a);
		}
		
		assertFalse(root.search(0));
		assertTrue(root.search(1));
		assertTrue(root.search(2));
		assertTrue(root.search(3));
		assertTrue(root.search(4));
		assertTrue(root.search(5));
		assertTrue(root.search(6));
		assertFalse(root.search(7));
		
		BalancedTreeNodeTestHelper.verifyTree(root, OthersCheck);
	}
	
	@Test public void RebalanceAndBalanceAgainTestingGetTreeKeys(){
		BalancedTreeNode root = ConstructTreeNode(-3);
		int[] arr = {-2,-1,1,2,3};
		for(int a : arr){
			root.insert(a);
		}
		
		List<Integer> a = root.getTreeKeys();
		assertEquals(6, a.size());
		assertEquals(-3, (int)a.get(0));
		assertEquals(-2, (int)a.get(1));
		assertEquals(-1, (int)a.get(2));
		assertEquals(1, (int)a.get(3));
		assertEquals(3, (int)a.get(5));
	}
		
	@Test public void SubTreeOnlyRebalancing(){
		BalancedTreeNodeTestHelper root = new BalancedTreeNodeTestHelper(7,null);
		int[] arr = {4,11,2,9,6,13,1,5,8,12,3,15};
		for(int a : arr){
			root.insert(a);
		}
		BalancedTreeNodeTestHelper.verifyTree(root, EnumSet.allOf(TreeVerifierCheck.class));
		assertTrue(root instanceof BalancedTreeNodeTestHelper);
		root.insert(17);
		root.insert(20);
		assertTrue(root instanceof BalancedTreeNodeTestHelper);
	}

}
