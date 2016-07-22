/*****************************************************************
    CS4212 -- Compiler Design
    Naive Expression Compiler, v3.
    Handles expressions with integers and the following binary
    operators: +, -, *, /, rem, < ("less then uses 0 and 1 as booleans)
    Generates utterly unoptimized Pentium AL code (hence "naive").

    In this version, we make a small but important change. Instead of
    having the label suffix placed directly as an argument to 'ce',
    we prefer to have a set of _attributes_ as arguments. The set of
    attributes is a dictionary with (key,value) pairs, and the first
    key that we place there is the labelsuffix that we used to have as
    an argument. Of course, there is a set of input attributes and a set
    of output attributes. Every time we need the value of an attribute,
    we retrieve it from the dictionary. Every time we need to change the
    value of an attribute, we produce a new dictionary with an updated
    value. The new dictionary can serve as output of the predicate, or
    input to the next recursive call.

    The important advantage of this approach is that the number of
    arguments to the ce predicate remains constant. As we extend the
    compiler further, we will need to add new rules and new attributes.
    If the attributes were passed on directly as arguments to the
    predicate, the number of predicates would increase (actually by a
    lot, as we shall see later). And since all arguments must appear in
    all the heads and all the recursive calls of all the rules of a
    predicate definition, each addition or change of an attribute would
    incur a large number of changes at the level of the source file.
    This would be a software engineering nightmare.
*****************************************************************/

:- [library(clpfd)]. % We need arithmetic

% Same as v2.
%
generateLabels([],LabelSuffix,LabelSuffix).
generateLabels([H|T],LabelSuffixIn,LabelSuffixOut) :-
	atomic_list_concat(['L',LabelSuffixIn],H),
	LabelSuffixAux #= LabelSuffixIn + 1,
	generateLabels(T,LabelSuffixAux,LabelSuffixOut).

cop(+,[],
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t addl %ebx,%eax',
     '\n\t\t pushl %eax']).
cop(-,[],
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t subl %ebx,%eax',
     '\n\t\t pushl %eax']).
cop(*,[],
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t imull %ebx,%eax',
     '\n\t\t pushl %eax']).
cop(/,[],
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t cdq',
     '\n\t\t idiv %ebx',
     '\n\t\t pushl %eax']).
cop(rem,[],
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t cdq',
     '\n\t\t idiv %ebx',
     '\n\t\t pushl %edx']).
cop(<,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jge ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).

% Predicate to compile an expression
% Compared to v2, the last two arguments have been changed
% into dictionaries. The labelsuffix value becomes
% one of the values in the dictionary
%
ce(C,[Instr],A,A) :-
	integer(C),!,
	atomic_list_concat(['\n\t\t pushl $',C],Instr).
ce(E,Code,AIn,AOut) :-
	E =.. [Op,E1,E2],
	member(Op,[+,-,*,/,rem,<]),!,
	cop(Op,LPlaceholders,Cop),
	get_assoc(labelsuffix,AIn,LabelSuffixIn,Aaux1,LabelSuffixAux1),
	generateLabels(LPlaceholders,LabelSuffixIn,LabelSuffixAux1),
	ce(E1,C1,Aaux1,Aaux2),
	ce(E2,C2,Aaux2,AOut),
	append([C1,C2,Cop],Code).

out(E) :- % initialize the dictionary before passing it to 'ce'
	empty_assoc(Empty),
	put_assoc(labelsuffix,Empty,0,A),
	ce(E,Code,A,_),
	Pre = [ '\n\t\t .section .text',
		'\n\t\t .globl _start',
		'\n_start:',
	        '\n\t\t pushl %ebp',
		'\n\t\t movl %esp,%ebp'],
	Post = ['\n\t\t popl %eax',
		'\n\t\t movl %ebp,%esp',
		'\n\t\t popl %ebp',
		'\n\t\t ret'],
	append([Pre,Code,Post],All),
	atomic_list_concat(All,AllWritable),
	write(AllWritable).

/* Example interactions (same as v2 -- copy and paste into
			 the Read-Eval-Print window)
   Then, copy the AL part into a separate file, name it, say, test.s,
   and compile with

        gcc -o test runtime.c test.s

   The resulting executable will print the value of the expression.

?- out(1<2).

                 .section .text
                 .globl _start
_start:
                 pushl %ebp
                 movl %esp,%ebp
                 pushl $1
                 pushl $2
                 popl %eax
                 popl %ebx
                 cmpl %eax,%ebx
                 jge L0
                 pushl $1
                 jmp L1
L0:
                 pushl $0
L1:
                 popl %eax
                 movl %ebp,%esp
                 popl %ebp
                 ret
true.

?- out((1<2)*((3<4)+2*4/5)).

                 .section .text
                 .globl _start
_start:
                 pushl %ebp
                 movl %esp,%ebp
                 pushl $1
                 pushl $2
                 popl %eax
                 popl %ebx
                 cmpl %eax,%ebx
                 jge L0
                 pushl $1
                 jmp L1
L0:
                 pushl $0
L1:
                 pushl $3
                 pushl $4
                 popl %eax
                 popl %ebx
                 cmpl %eax,%ebx
                 jge L2
                 pushl $1
                 jmp L3
L2:
                 pushl $0
L3:
                 pushl $2
                 pushl $4
                 popl %ebx
                 popl %eax
                 imull %ebx,%eax
                 pushl %eax
                 pushl $5
                 popl %ebx
                 popl %eax
                 cdq
                 idiv %ebx
                 pushl %eax
                 popl %ebx
                 popl %eax
                 addl %ebx,%eax
                 pushl %eax
                 popl %ebx
                 popl %eax
                 imull %ebx,%eax
                 pushl %eax
                 popl %eax
                 movl %ebp,%esp
                 popl %ebp
                 ret
true.


*/

