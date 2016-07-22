/****************************************************************************
 Class: VectorTextFile2
 Purpose: Represents a text file as a vector, i.e., as a sorted array of 
 word/count pairs that appear in the text file.
 
 Constructor: VectorTextFile2(String fileName)
 Behavior: Reads the specified text file and parses it appropriately.
 
 Public Class Methods:
 	int Norm() : Returns the norm of the vector.
 	
 Static Methods:
 	double DotProduct(VectorTextFile2 A, VectorTextFile2 B) : 
 		Returns the dot product of two vectors.
 	double Angle(VectorTextFile2 A, VectorTextFile2 B) : 
 		Returns the angle between two vectors. 
 ***************************************************************************/

// This class is part of the cs2020 package.
package sg.edu.nus.cs2020;

// This class uses the following two packages (associated with reading files):
import java.io.FileInputStream;
import java.io.IOException;

// Class declaration:
public class VectorTextFile2 {

	/*****************************
	 * Class member variables 
	 *****************************/
	
	// Array of words in the file
	String[]  m_WordList;

	// Number of words in the file
	int m_FileWordCount;

	// Array of word/count pairs
	WordCountPair[] m_CountedWords;
	
	// Number of word/count pairs
	int m_WordPairCount;
	
	// Has the word list been sorted?
	boolean m_Sorted;
		
	//-----------------------------------------------------------------------
	// Constructor: Reads and parses the specified file
	//
	// Input: String containing a filename
	// Assumptions: fileName is a text file that exists on disk.
	// Properties: On completion, m_WordList contains a sorted array of all the
	// words in the text file, m_FileWordCount is the number of words in the
	// text file, m_CountedWords contains a sorted array of word/count pairs
	// with one entry for every distinct word in the text file, m_WordPairCount
	// is the number of word/count pairs, and the flag m_Sorted is true.
	// Characters in the file are treated in the following manner:
	// (a) Every letter is made lower-case.
	// (b) All punctuation is removed.
	// (c) Each end-of-line marker ('\n') is replaced with a space.
	// (d) All (other) non-letters and non-spaces are removed.
	//-----------------------------------------------------------------------		
	public VectorTextFile2(String fileName) 
	{	
		// Begin a block of code that handles exceptions (i.e., errors)
		try{
			
			// First, initialize class variables
			m_WordList = null;
			m_CountedWords = null;
			m_FileWordCount = 0;
			m_WordPairCount = 0;
			m_Sorted = false;		
				
			// Next, read in the file and parse it into words.
			ParseFile(fileName);
			
			// Check for errors:
			if ((m_FileWordCount < 1) || (m_WordList == null))
			{
				throw new Exception("Reading the file failed.");
			}
			
			// Next, sort the words.
			InsertionSortWords();
			
			// Check for errors:
			if (m_Sorted == false)
			{
				throw new Exception("Sorting failed.");
			}
			VerifySort();
			
			// Finally, count the number of times each word appears in the file.
			CountWordFrequencies();
			
			// Check for errors:
			if ((m_WordPairCount < 1) || (m_CountedWords == null))
			{
				throw new Exception("Counting the word frequencies failed.");
			}
		}
		// Catch any exceptions (i.e., errors) and report problems.
		catch(Exception e)
		{
			System.out.println("Error creating VectorTextFile.");
		}
	}	
	
	/*****************************
	 * Public Class Methods     *
	 *****************************/
	
	//-----------------------------------------------------------------------
	// Norm: Returns the norm of the vector.
	//			
	// Input: None.
	// Output: The norm of the vector.
	// Assumptions: m_CountedWords contains a sorted list of distinct 
	// word/count pairs, and m_WordPairCount contains the number of word/count 
	// pairs.
	// Methodology: The norm of a vector X is defined to be the square-root of 
	// DotProduct(X,X).
	//-----------------------------------------------------------------------
	public double Norm()
	{
		int dot = VectorTextFile2.DotProduct(this, this);
		return Math.sqrt(dot);
	}
	
	/*****************************
	 * Static Class Methods     *
	 *****************************/
	
	//-----------------------------------------------------------------------
	// DotProduct: Calculates the dot-product of two TextFile vectors.
	//			
	// Input: Two vectors of type VectorTextFile2
	// Output: An integer representing their dot-product
	// Assumptions: For each vector, m_CountedWords contains a sorted list 
	// of distinct word/count pairs, and m_WordPairCount contains the number
	// of word/count pairs.
	// Methodology: The dot-product is calculated by summing the product of 
	// the individual vector components. That is, if D(w,X) is the number of 
	// times word w appears in vector X, then the dot-product of A and B is 
	// defined as: 
	//					Sum_{every w in A and B) [D(w,A)*D(w,B)]
	//-----------------------------------------------------------------------
	static int DotProduct(VectorTextFile2 A, VectorTextFile2 B)
	{
		// Initialize local variables:
		
		// The sum is initially zero
		int sum = 0;
		
		// Alength is the number of word/count pairs in A 
		int Alength = A.m_WordPairCount;
		// We begin with word/count pair zero
		int Aindex = 0;
		
		// Blength is the number of word/count pairs in B
		int Blength = B.m_WordPairCount;
		// We begin with word/count pair zero
		int Bindex = 0;
		
		// We iterate through all the word/count pairs, looking for words that 
		// appear in both A and B.  We continue until we run out of words in 
		// either A or B.
		while ((Aindex < Alength) && (Bindex < Blength))
		{
			// First, get the word associated with Aindex in A
			WordCountPair Awordpair = A.m_CountedWords[Aindex];
			String Aword = Awordpair.getWord();
			
			// Next, get the word associated with Bindex in B
			WordCountPair Bwordpair = B.m_CountedWords[Bindex];
			String Bword = Bwordpair.getWord();
			
			// If Aword==Bword, then we have found a word in both vector A and B
			if (Aword.equals(Bword))
			{
				// Add the product of the counts to the sum.
				sum += (Awordpair.getCount()*Bwordpair.getCount());
				
				// Next, increment both Aindex and Bincex to consider the next
				// word in both vectors.
				Aindex++;
				Bindex++;
			}
			else if (Aword.compareTo(Bword) > 0)
			{
				// Otherwise, if (Aword > Bword) in alphabetic order, we
				// increment Bindex, going to the next WordCountPair in B.
				Bindex++;
			}
			else
			{
				// Otherwise, (Bword > Aword) in alphabetic order.  We
				// increment Aindex, going to the next WordCountPair in A.
				Aindex++;
			}
		}
		
		// Finally, we return the dot-product.
		return sum;
	}
	
	////////////////////////////////////////////////////////////////////////
	// Angle: Calculates the angle between two TextFile vectors.
	//			Input: Two vectors of type VectorTextFile2
	// 			Output: An angle between [0,pi/2]
	//			Methodology: The angle is calculated as per the
	//                       "Cosine Formula" which states that:
	//                        	 Theta(A,B) = arccos((AB)/(|A|*|B|))
	//                       where (AB) is the vector dot product of A and B,
	//						 |A| is the norm of the vector A, and |B| is the
	// 						 norm of vector B.
	/////////////////////////////////////////////////////////////////////////
	static double Angle(VectorTextFile2 A, VectorTextFile2 B)
	{
		// First calculate the dot product of the vectors A and B
		int dot = VectorTextFile2.DotProduct(A, B);
		
		// Second, calculate the norm of the two vectors
		double Anorm = A.Norm();
		double Bnorm = B.Norm();
		
		// Third, calculate (AB)/(|A|*|B|)
		double result = dot/(Anorm*Bnorm);
		
		// Lastly, take the arccos of the result
		double theta = Math.acos(result);
		
		// Return the angle
		return theta;			
	}
	
	
	/*****************************
	 * Private Class Methods     *
	 *****************************/
	
	//-----------------------------------------------------------------------
	// ParseFile: Reads a text file and parses it into a list of words
	//
	// Input: String containing a filename
	// Output: None
	// Properties: On completion, every word in the specified file is included 
	// in the word list m_WordList.  Each word appears the same number of times 
	// in the list as it does in the original file.  All letters in all words 
	// are lower-case, and all punctuation/non-letters are removed.
	//-----------------------------------------------------------------------
	private void ParseFile(String fileName) throws IOException
	{
		// First, read the file into a single long string.
		String strTextFile = ReadFile(fileName);
		
		// Next, divide the string into words.
		SplitString(strTextFile);
	}
	
	//-----------------------------------------------------------------------
	// ReadFile: Takes a file name, and returns the file as a String. 
	//
	// Input: String containing a filename
	// Output: String containing all the text in the file
	// Properties: The string returned contains every character in the 
	// specified file, in the same order, except:
	// (a) Every letter is lower-case
	// (b) All punctuation is removed.
	// (c) Each end-of-line marker ('\n') is replaced with a space.
	// (d) All (other) non-letters and non-spaces are removed.
	// (E) Words are separated by exactly one space.
	//-----------------------------------------------------------------------
	private String ReadFile(String fileName) throws IOException
	{
		// Declare and initialize local variables 
		FileInputStream inputStream = null;		
		int iSize = 0;		
		char[] charBuffer = null;		
		int iCharCount = 0;
								
		// Begin a block of code that handles exceptions
		try{
			// Open the file as a stream
			inputStream = new FileInputStream(fileName);
			
			// Determine the size of the file, in bytes
			iSize = inputStream.available();
			
			// Initialize the char buffer to be arrays of the appropriate size.									
			charBuffer = new char[iSize];			
			
			// Read in the file, one character at a time.
			// For each character, normalize it, removing punctuation and capitalization.
			for (int i=0; i<iSize; i++)
			{
				// Read a character
				char c = (char)inputStream.read();
				
				// Ensure that the character is lower-case
				c = Character.toLowerCase(c);
				
				// Check if the character is a letter, or whitespace, or a new line
				if (Character.isLetter(c))
				{					
					charBuffer[iCharCount] = c;	
					iCharCount++;
				}
				else if ((c == ' ') || (c == '\n'))
				{
					// In this case, we add a space to the string.
					// Note: only add a space if the previous character 
					// is not also a space.  This prevents adding two spaces in a row.
					if ((iCharCount > 0) && (charBuffer[iCharCount-1] != ' '))
					{
						charBuffer[iCharCount] = ' ';	
						iCharCount++;
					}					
				}
				else
				{
					// do nothing
				}
			}														
		}   // end of try block 
		finally // handle any exceptions
		{			
			// If the file is open, then close it.
			if (inputStream != null){								
				inputStream.close();					
			}
		}	
		
		return new String(charBuffer);
	}
		
	//-----------------------------------------------------------------------
	// SplitString: Takes a string representing a file and parses it into 
	// words that are stored in m_WordList. 
	//
	// Input: String containing a filename
	// Output: None
	// Assumptions: The input string is assumed to consist of a set of words 
	// separated by exactly one space.  
	// Properties: On completion, the array m_WordList stores every word in 
	// the initial string, one word per slot in the array. The integer 
	// m_FileWordCount contains the number of words in m_WordList.
	//-----------------------------------------------------------------------
	private void SplitString(String strTextFile)
	{
		// Initialize local variables:
		int iStringSize = strTextFile.length();
		int iWordCount = 0;
		String word = "";
		
		// Initialize class variables:
		// Note: the length of the string is an overestimate of the number of words in the String.
		// As a result, we allocate too much space, wasting memory.
		// It would be better to allocate space more efficiently.
		m_WordList = new String[iStringSize];
		
		// Iterate through the string, examining every character.
		// Accumulate characters in words, detecting word breaks.
		for (int i=0; i<iStringSize; i++)
		{
			// Read a character
			char c = strTextFile.charAt(i);
			
			// Check if the character is part of a word, or a word break.
			if (c != ' ') 
			{
				// Here, the character is part of a word, so add it to the word.
				word += c;
			}
			else
			{
				// Otherwise, the character is not part of a word.
				// If we have found a non-empty word, add it to the list of words.
				if (word != "")
				{
					// Add the word to the list of words
					m_WordList[iWordCount] = word;
				
					// Increment the number of words discovered.
					iWordCount++;

					// Reinitialize the word to the empty string
					word = "";
				}
			}
		}
		
		// Check if there is any leftover word, once the string is complete.
		// If so, add the word to the word list, and increment the word count.
		if (word != "")
		{
			m_WordList[iWordCount] = word;			
			iWordCount++;
		}
		
		// Save the word count.
		m_FileWordCount = iWordCount;
	}				
	
	//-----------------------------------------------------------------------
	// InsertionSortWords: Sorts the words in the array m_WordList. 
	//
	// Input: None
	// Output: None
	// Assumptions: m_WordList holds a non-empty set of words, and
	// m_FileWordCount has a count of the number of words.
	// Properties: On completion, the words in m_WordList are sorted 
	// alphabetically, and the flag m_Sorted is set to true.
	// Methodology: The sorting is accomplished via `insertion sort.'  	
	//-----------------------------------------------------------------------
	private void InsertionSortWords() throws Exception
	{
		// Initialize local variables:
		
		// index stores the slot in the array that we are trying to fill
		int index = 0;
		// strMin stores the word we are currently sorting into place
		String SortString = null;
		// iMax stores the index of the largest sorted word
		int iMaxSorted = 0;
		
		// Check for errors
		if ((m_WordList==null) || (m_FileWordCount==0))
		{
			throw new Exception("Failed in InsertionSortWords: no words to sort.");
		}

		// Iterate through every index in the array.
		// At the beginning of each iteration of the loop, we have sorted
		// the elements in the prefix m_WordList[0..iMaxSorted].
		// The goal of the iteration is to find the proper slot for the string
		// m_WordList[iMaxSorted+1].
		// At the end of each iteration of the loop, we have sorted the 
		// prefix of the array m_WordList[0..iMaxSorted+1].
		for (iMaxSorted = 0; iMaxSorted<m_FileWordCount-1; iMaxSorted++)
		{
			// First, fix the string we are going to sort into place
			SortString = m_WordList[iMaxSorted+1];
			
			// We need to find where SortString fits in the array [1..iMaxSorted+1]
			index = iMaxSorted+1;
			while (index > 0 && SortString.compareTo(m_WordList[index-1]) < 0)
			{
				m_WordList[index] = m_WordList[index-1];
				index--;
			}
			
			// Now that we have found where SortString goes,  
			// move it into place.
			m_WordList[index] = SortString;				
		}
		// Now that we are done sorting, set a flag indicating that the sort is complete.
		m_Sorted = true;
	}
	
	//-----------------------------------------------------------------------
	// CountWordFrequencies: Counts the frequency with which each word 
	// appears in m_WordList, storing the result in m_CountedWords. 
	//
	// Input: None
	// Output: None
	// Assumptions: m_WordList holds a sorted, non-empty set of words, and
	// m_FileWordCount has a count of the number of words.
	// Properties: On completion, m_CountedWords is a sorted array of 
	// word/count pairs containing one entry for every distinct word in
	// m_WordList.  The count associated with each word is the number of
	// times that word appears in m_WordList.  The integer m_WordPairCount
	// contains the number of distinct words in m_WordList, i.e., the number of 
	// entries in m_CountedWords.
	//-----------------------------------------------------------------------
	private void CountWordFrequencies() throws Exception
	{
		// Check for errors:		
		if ((m_WordList==null) || (m_FileWordCount<1) || (m_Sorted == false))
		{
			throw new Exception("Failed in CountWordFrequencies: no words to count.");
		}
		
		// Initialize the m_CountedWords array.
		// We use m_FileWordCount as a safe estimate of the number of distinct 
		// words in m_WordList.  Notice that this is an inefficient use of space,
		// as m_CountedWords will likely be much smaller than m_WordList.
		m_CountedWords = new WordCountPair[m_FileWordCount];
		
		// Initialize the number of count/value pairs to zero.
		int iNumPairs = 0;
		
		// Initialize the first word to be the first word in the word list.		
		String word = m_WordList[0];
		// Initialize the count to be one.
		int count = 1;
		
		// Iterate through every word in m_WordList
		for (int i=1; i<m_FileWordCount; i++)
		{
			// If we find another copy of the word:
			if (m_WordList[i].equals(word))
			{
				// Then increment the count.
				count++;
			}
			else
			{
				// Otherwise, we have found a new word.
				// Store the old word and its count as new WordCountPair.
				m_CountedWords[iNumPairs] = new WordCountPair(word, count);
				// Increment the number of word/count pairs that we have discovered.
				iNumPairs++;
				
				// Re-initialize word with the newly found word.
				word = m_WordList[i];
				// Re-initialize the count to be 1.
				count = 1;
			}
		}
		// Save the number of word/count pairs in m_WordPairCount
		m_WordPairCount = iNumPairs;			
	}
	
	//-----------------------------------------------------------------------
	// VerifySort: Verifies that the word list is sorted. 
	//
	// Input: None
	// Output: None
	// Assumptions: m_WordList holds a sorted, non-empty set of words, and
	// m_FileWordCount has a count of the number of words.
	// Properties: If the m_WordList is properly sorted, then this method
	// has no effect.  If it discovers that the list is not properly sorted,
	// it throws an exception.
	//-----------------------------------------------------------------------
	private void VerifySort() throws Exception
	{
		// First, check if the sort flag is correctly set:
		if (m_Sorted == false)
		{
			throw new Exception("VerifySort fails: list not sorted.");
		}
		// Next, check if there are any words to be sorted:
		if ((m_FileWordCount < 1) || (m_WordList == null))
		{
			throw new Exception("VerifySort fails: list does not contain any words.");
		}
		
		// Finally, iterate through the list of words and make sure that they 
		// are in properly sorted order.
		for (int i=0; i<m_FileWordCount-1; i++)
		{
			if (m_WordList[i].compareTo(m_WordList[i+1]) > 0)
			{
				throw new Exception("VerifySort fails: list badly sorted.");
			}
		}		
	}
}
