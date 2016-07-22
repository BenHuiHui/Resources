// pig_latin.c
//
// This program converts a sentence into Pig Latin.
//
// Written by: Lifeng

#include <stdio.h>
#include <string.h>

#define MAX_LEN 300 // assume max sentence is 300 letters
#define VOWEL "aoeiu"

/* function prototype */
void next_word(char [], char []); // fetch the next word

int main(void)
{
	int len;
	char sentence[MAX_LEN] = {0},
		 word[MAX_LEN] = {0};     // a word in sentence

	fgets(sentence, 100, stdin);
	len = strlen(sentence);
	if (sentence[len-1] == '\n' )
		sentence[len-1] = '\0';

	printf("Converted: ");
	next_word(sentence, word);
	while (word[0]) // not an empty string
	{
		if (strchr(VOWEL, word[0]) != NULL) // start with vowel
		{
			printf("%s%s", word, "way");
		}
		else // start with a consonant
		{
			printf("%s%c%s", word+1, word[0], "ay");
		}

		next_word(sentence, word);
		if (word[0]) // still have next word
			printf(" "); // print blank to separate next word
	}
	printf("\n"); // the end of sentence

	return 0;
}

// fetch the next word from sentence
void next_word(char sentence[], char word[])
{
	char *ptr = strchr(sentence, ' ');

	if (ptr != NULL)
	{   
		*ptr = '\0';
		strcpy(word, sentence);  // fetch word
		strcpy(sentence, ptr+1);  // update sentence
	}   
	else
	{   
		strcpy(word, sentence);  // fetch word
		sentence[0] = '\0';      // end of sentence, will stop
	} 
}

