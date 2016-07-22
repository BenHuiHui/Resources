/****************************************************************************
 Class: WordCountPair
 Purpose: Contains a pair consisting of a word and a count.
 
 Constructor: WordCountPair(String word, int count)
 Behavior: Sets the word/count pair to the specified word and count.
 
 Public Class Methods:
 	int getWord() : Returns the word.
 	int getCount() : Returns the count. 	 
 ***************************************************************************/

// This class is part of the cs2020 package.
package sg.edu.nus.cs2020;

// Class declaration:
public class WordCountPair
{
	/*****************************
	 * Class member variables 
	 *****************************/
	String word;
	int count;
		
	//-----------------------------------------------------------------------
	// Constructor: Sets the word and the count.
	//
	// Input: String word and integer count.			
	//-----------------------------------------------------------------------
	WordCountPair(String s, int c)
	{
		word = s;
		count = c;
	}
	
	//-----------------------------------------------------------------------
	// getWord: Returns the word.
	//
	// Input: None.
	// Output: The word stored in the word/count pair.
	//-----------------------------------------------------------------------
	String getWord()
	{
		return word;
	}
	
	//-----------------------------------------------------------------------
	// getCount: Returns the count.
	//
	// Input: None.
	// Output: The count stored in the word/count pair.
	//-----------------------------------------------------------------------
	int getCount()
	{
		return count;
	}
}
