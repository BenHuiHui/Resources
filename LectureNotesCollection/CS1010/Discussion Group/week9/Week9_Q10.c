// Week10_Hangman_ver2.c
// Author: Janice Lee

#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>
#include <time.h>
#define NUMWORDS 10
#define STRSIZE 15

void play_game(char *[], int);
int has_letter(char, char*);

int main(void) {
	char *dict[NUMWORDS] = {
		"apple", "orange", "banana", "pineapple",
		"starfruit", "strawberry", "mango",
		"kiwifruit", "watermelon", "honeydew"};
	char resp;

	srand(time(NULL));

	do {
		play_game(dict, NUMWORDS);
		printf("Do you want to play another game [y/n]? ");
		scanf(" %c", &resp);
		resp = toupper(resp);
	} while (resp == 'Y');

	return 0;
}

void play_game(char *dict[], int num_words)
{
	int i;
	char input;
	char temp[STRSIZE+1], word[STRSIZE+1];
	int length, count=0;
	int num_lives = 5;

	i = rand() % num_words;	// get a word from list
	strcpy(word, dict[i]);
	length = strlen(word);

	for (i=0; i<length; i++)		
		temp[i] = '_';
	temp[i] = '\0';

	do {
		printf("Number of lives: %d\n", num_lives); 
		printf("Guess a letter in the word ");
		puts(temp);
		scanf(" %c", &input);

		if (has_letter(input, word) == 1) {
			for (i=0; i<length; i++)
				if (input == word[i] && temp[i] == '_') {
					temp[i] = input;
					count++;
				}

		}
		else num_lives = num_lives - 1;

	} while (num_lives != 0 && count != length);

	if (num_lives == 0) {
		printf("Sorry, you're hanged! ");
		printf("The word is %s.\n", word);
	}
	else printf("Congratulations! The word is %s.\n", word);
}

// Check whether word contains ch
int has_letter (char c, char *word)
{
	int j;
	int length = strlen(word);

	for (j=0; j<length; j++) {
		if (c == word[j])
			return 1;
	}

	return 0;   //letter does not occur in word
}

