package sg.edu.nus.cs2020.PS6;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.ListIterator;

public class RollingHash {
	LinkedList<String> table[];

	int inputSize;
	int tableSize;
	int tableSizeInBit;

	// set the load factor to be 0.75
	double loadFactor = 0.75;

	public RollingHash() {
		tableSizeInBit = 20;
		tableSize = 1048576; // 2^20, set it to be a power of 2

		// initially it's all set to null
		table = new LinkedList[tableSize];
	}

	/**
	 * this would calculate the reminder of a divided by b;
	 * 
	 * @param a
	 *            the integer
	 * @param b
	 *            the divider, greater than 0
	 * @return - positive integer
	 */
	private static int mod(int a, int b) {
		if (a >= 0)
			return a % b;
		else {
			return b + a % b;
		}
	}

	/**
	 * add the substring with L of string A into the hash table, with the
	 * rolling hash hash function used: sum up each char of the String, where
	 * a,g,c,t represents 0,1,2,3
	 * 
	 * @param A
	 *            - the original string
	 * @param L
	 *            - the length of the substring
	 */
	public void rollingAddSubStrings(String A, int L) {
		String base = A.substring(0, L);
		int t;
		int hash;
		int slasher; // used to delete the former char if necessary

		// compute the hash of Base:
		hash = hash(base);
		hash = mod(hash, tableSize);

		add(base, hash);
		// System.out.println(hash); // for debugging purpose

		// then compute the rest, and add them into the hash table
		slasher = (0x1) << (L * 2);
		for (int i = 1; i < A.length() - L + 1; i++) {
			base = A.substring(i, i + L);

			hash <<= 2;
			if (L * 2 < tableSizeInBit) {
				hash -= decodeChar(A.charAt(i - 1)) * slasher;
			}
			hash += decodeChar(base.charAt(L - 1)); // and add in the last char
													// in the subString
			hash = mod(hash, tableSize);
//			System.out.println(hash);
//			System.out.println(hash(base));
			add(base, hash);
		}
	}

	/**
	 * @param B
	 *            - the whole string used to check the subStrings
	 * @param L
	 *            - the length of the subString
	 * @return -index of the subString, -1 if subString not exist
	 * 
	 */
	public int rollingCheckSubStrings(String B, int L) {
		String base = B.substring(0,L);
		int hash;
		int slasher; // used to delete the former char if necessary

		// compute the hash of Base:
		hash = hash(base);
		hash = mod(hash, tableSize);

		if(contains(base,hash))	return 0;
		// System.out.println(hash); // for debugging purpose

		// then compute the rest, and add them into the hash table
		slasher = (0x1) << (L * 2);
		for (int i = 1; i < B.length() - L + 1; i++) {
			base = B.substring(i, i + L);

			hash <<= 2;
			if (L * 2 < tableSizeInBit) {
				hash -= decodeChar(B.charAt(i - 1)) * slasher;
			}
			hash += decodeChar(base.charAt(L - 1)); // and add in the last char
													// in the subString
			hash = mod(hash, tableSize);
			if(contains(base,hash))	return i;
		}
		return -1;
	}
	
	private boolean contains(String base, int hash){
		LinkedList li  = table[hash];
		if(li==null)	return false;
		ListIterator<String> it = table[hash].listIterator();
		while (it.hasNext()) {
			String t = it.next();
			if ((t.compareTo(base)) == 0)
				return true;
		}
		return false;
	}
	
	private boolean add(String adder, int hash) {
		if (table[hash] == null) {
			table[hash] = new LinkedList<String>();
			table[hash].add(adder);
			return true;
		}

		ListIterator<String> it = table[hash].listIterator();
		while (it.hasNext()) {
			String t = it.next();
			if ((t.compareTo(adder)) == 0)
				return false;
		}
		table[hash].add(adder);
		return true;
	}

	public int hash(String key) {
		int hash = 0;
		for (int i = 0; i < key.length(); i++) {
			hash <<= 2;
			hash += decodeChar(key.charAt(i));
		}
		hash = mod(hash, tableSize);
		return hash;
	}

	/*
	 * Assumption: there're only a,g,c,t or their upper cases
	 */
	private static int decodeChar(char c) {
		c = Character.toLowerCase(c);
		switch (c) {
		case 'a':
			return 0;
		case 'g':
			return 1;
		case 'c':
			return 2;
		case 't':
			return 3;
		default:
			return 0;
		}
	}

	public static void main(String[] args) {
		RollingHash r = new RollingHash();
		String A = "agctgcta";
		String B = "actgctag";
		r.rollingAddSubStrings(A, 4);
		System.out.println(r.rollingCheckSubStrings(B, 4));
	}

}
