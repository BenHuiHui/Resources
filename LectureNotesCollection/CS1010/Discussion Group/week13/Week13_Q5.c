// Week13_Q5.c
// cap
// calculate student's CAP based on input
//
// Written by: Lifeng

#include <stdio.h>
#include <string.h>

typedef struct
{
	char module[8];
	char grade[3];
	int mc;
} result_t;

typedef struct
{
	char name[31];
	result_t rt[50];
} student_t;

// function prototypes
student_t read_info(int *);
double compute_cap(student_t, int);
double convert(char *);

int main(void)
{
	student_t stu;
	int num_modules;  // actual number of modules a student take

	stu = read_info(&num_modules);

	printf("CAP = %.2f\n", compute_cap(stu, num_modules) );

	return 0;
}

// read in a student's name, the number of modules he has taken, 
// and for each module, the module code, the grade obtained, 
// and the number of modular credits.
student_t read_info(int *num)
{
	int i;
	student_t stu;

	printf("Enter student's name: ");
	scanf("%[^\n]", stu.name);

	printf("Enter number of modules taken: ");
	scanf("%d", num);

	printf("Enter results of %d modules:\n", *num);
	for (i=0; i<*num; i++)
		scanf("%s %s %d", stu.rt[i].module, stu.rt[i].grade, &stu.rt[i].mc);

	return stu;
}


// compute the student's CAP
double compute_cap(student_t stu, int num)
{
	int i;
	double points, mcs;

	points = mcs = 0;
	for (i=0; i<num; i++)
	{
		points += convert(stu.rt[i].grade) * stu.rt[i].mc;
		mcs += stu.rt[i].mc;
	}

	return points/mcs;
}


// convert from grade to point
double convert(char *grade)
{
	if ( strcmp(grade, "A+") == 0 )
		return 5;
	if ( strcmp(grade, "A") == 0 )
		return 5;
	if ( strcmp(grade, "A-") == 0 )
		return 4.5;
	if ( strcmp(grade, "B+") == 0 )
		return 4;
	if ( strcmp(grade, "B") == 0 )
		return 3.5;
	if ( strcmp(grade, "B-") == 0 )
		return 3;
	if ( strcmp(grade, "C+") == 0 )
		return 2.5;
	if ( strcmp(grade, "C") == 0 )
		return 2;
	if ( strcmp(grade, "D+") == 0 )
		return 1.5;
	if ( strcmp(grade, "D") == 0 )
		return 1.0;
	return 0;  // for "F"
}
