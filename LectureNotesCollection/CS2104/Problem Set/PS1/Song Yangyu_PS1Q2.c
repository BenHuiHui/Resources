#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define NAME_MAX_LENGTH 100
#define LINE_MAX_LENGTH 1000
#define VARIABLE_MAX_NUM 100

/*
Syntax:
	line = [Expression]*
	Expression = statement + ';'
	statement = variable + ['+'|'-'|'*'|'/']'=' + operand
	operand = [variable | [1-9][0-9]* ]
	variable = [A-Z|a-z|'_'][A-Z|a-z|0-9|'_']

// Need: 
	
*/

// Definite Finite Automata to parse each statement; return false on failure and true on success

// struct to store the variables
struct VARIABLE{
	char name[NAME_MAX_LENGTH];
	int value;
};

// global variable stack
struct VARIABLE variables[VARIABLE_MAX_NUM];
int variable_number = 0;

/* For a given variable name, search for the index of this variable; -1 if no match
 */
int variableStoredPosition(char variableName[]){
	int i;
	for(i=0;i<variable_number;i++){
		if(strcmp(variables[i].name,variableName) == 0){
			return i;
		}
	}
	return -1;
}

/* Return the index of this variable being inserted
 */
int insertVariable(char variableName[]){
	if(variable_number >= VARIABLE_MAX_NUM){
		fprintf(stderr,"Maximum number of variables reached, cannot declare new variable \n");
		return -1;
	}
	
	strcpy(variables[variable_number].name,variableName);
	variables[variable_number].value = 0;
	variable_number++;
	return (variable_number -1);
}

int isValidOp(char op){
	switch(op){
		case '+':case '-':case '*':case '/':return 1;
		default: return 0;
	}
}

int isValidVariableName(char *variable_name){
	
	int i;
	char c;
	char errMsg[] = "Invalid variable name: \"%s\"\n";
	
	// check the first letter
	if( !(isalpha(*variable_name) || *variable_name < '_')){
		fprintf(stderr,errMsg,variable_name);
		return 0;
	}
	
	// check hte following letter
	for(i=1,c=*(variable_name + i);i<NAME_MAX_LENGTH && c; i++,c=*(variable_name + i)){
		if( !(isalpha(c) || isdigit(c) || c == '_')){
			fprintf(stderr,errMsg,variable_name);
			return 0;
		}
	}
	
	if(c){
		fprintf(stderr,"variable name \"%s\" is too long. \n",variable_name);
		return 0;
	}
	
	// checked
	return 1;
}

int isValidUnsignedInt(char string[]){
	int i=0;
	for(i=0;i<VARIABLE_MAX_NUM && string[i];i++){
		if(!isdigit(string[i])){
			return 0;
		}
	}
	return 1;
}

void executeStatement(int lhsIndex, int rhsValue, char op){
	switch(op){
		case '+': variables[lhsIndex].value += rhsValue;break;
		case '-': variables[lhsIndex].value -= rhsValue;break;
		case '*': variables[lhsIndex].value *= rhsValue;break;
		case '/': variables[lhsIndex].value /= rhsValue;break;
	}
}

/* Parse a line into statement
 * Return -1 on error
 */
int parseStr(char line[]){
	
	// first parse to statement
	char *statement;
	char *former, *later;
	char op;
	
	int formerIndex, laterIndex;
	int rightHandValue;
	
	statement = strtok(line,";");
	
	int count = 0;
	while(statement!=NULL && (*statement) >20 ){
		// then for each statement, parse the operand
		
		// find the '=' first
		former = strchr(statement,'=');

		if(former == NULL || former == statement){
			fprintf(stderr,"The place of '=' in statement is wrong.\n");
			return -1;
		}
		
		// then the operator
		op = *(former-1);
		*(former-1) = 0;	// make here a termination
		
		if(!isValidOp(op)){
			fprintf(stderr,"Wrong operator given.\n");
			return -1;
		}
		
		later = former+1;	// right after the '='
		former = statement;	// the begining of the statement
		
		if(isValidVariableName(former)){
			formerIndex = variableStoredPosition(former);
			if(formerIndex == -1)	formerIndex	= insertVariable(former);
			
			if(!sscanf(later,"%d",&rightHandValue)){
				if(isValidVariableName(later)){
					laterIndex = variableStoredPosition(later);
					if(laterIndex == -1)	laterIndex	= insertVariable(later);
					rightHandValue = variables[laterIndex].value;
				} else{
					return -1;
				}
			}
			
			executeStatement(formerIndex,rightHandValue,op);
		} else{
			return -1;	// error message already printed.
		}
		
				// testing
//		printf("RES %d: Later: %s, Former: %s",later,former);

		statement = strtok(NULL,";");
	}
	
}


int main(){
	freopen("test.txt","r",stdin);
	int i=0;
	
	char tempStr[LINE_MAX_LENGTH];	// assume no line is longer than 1000 characters
	while(fgets(tempStr,LINE_MAX_LENGTH,stdin)){
		// parse statements one by one
		parseStr(tempStr);
	}
	
	// then output string after calculation
	for(i = 0;i<variable_number;i++){
		printf("%s = %d\n",variables[i].name,variables[i].value);
	}
	
	while(1);
	return 0;
}
