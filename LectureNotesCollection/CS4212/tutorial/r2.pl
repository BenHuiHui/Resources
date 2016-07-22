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
:- [library(lists)].

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
cop(=,[V],
    ['\n\t\t popl %eax',
     '\n\t\t movl %eax,',V,
     '\n\t\t pushl %eax' ]).

% Predicate to compile an expression
% Compared to v2, the last two arguments have been changed
% into dictionaries. The labelsuffix value becomes
% one of the values in the dictionary
%
ce(C,[Instr],A,A) :-
	(   integer(C), P = '$' ; atom(C),P='' ),!,
	atomic_list_concat(['\n\t\t pushl ',P,C],Instr).
ce(E,Code,AIn,AOut) :-
	E =.. [Op,E1,E2],
	member(Op,[+,-,*,/,rem,<,=]),!,
	cop(Op,LPlaceholders,Cop),
	(   Op = (=)
	->  atom(E1),
	    get_assoc(vars,AIn,OldVars,Aaux,NewVars),
	    union(OldVars,[E1],NewVars),
	    ce(E2,C2,Aaux,AOut),
	    LPlaceholders = [E1],
	    append([C2,Cop],Code)
	;   get_assoc(labelsuffix,AIn,LabelSuffixIn,Aaux1,LabelSuffixAux1),
	    generateLabels(LPlaceholders,LabelSuffixIn,LabelSuffixAux1),
	    ce(E1,C1,Aaux1,Aaux2),
	    ce(E2,C2,Aaux2,AOut),
	    append([C1,C2,Cop],Code) ).
ce((S1;S2),Code,Ain,Aout) :-
	ce(S1,C1,Ain,Aaux),
	ce(S2,C2,Aaux,Aout),
	append([C1,['\n\t\t popl %eax'],C2], Code).

allocvars([],[]).
allocvars([V|VT],[D|DT]) :-
	atomic_list_concat(['\n\t\t .comm ',V,',4,4'],D),
	allocvars(VT,DT).

out(E,File) :- % initialize the dictionary before passing it to 'ce'
	tell(File),
	empty_assoc(Empty),
	put_assoc(labelsuffix,Empty,0,A1),
	put_assoc(vars,A1,[],A2),
	ce(E,Code,A2,A3),
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
	writeln(AllWritable),
        get_assoc(vars,A3,VarList),
	allocvars(VarList,VarCode),
	atomic_list_concat(VarCode,WritableVars),
	write(WritableVars),
	told.

/* Example interactions

?- out(x=1;y=4/2+(0<1);x+2*y,'test0.s').
true.

Contents of test0.s:


		 .section .text
		 .globl _start
_start:
		 pushl %ebp
		 movl %esp,%ebp
		 pushl $1
		 popl %eax
		 movl %eax,x
		 pushl %eax
		 popl %eax
		 pushl $4
		 pushl $2
		 popl %ebx
		 popl %eax
		 cdq
		 idiv %ebx
		 pushl %eax
		 pushl $0
		 pushl $1
		 popl %eax
		 popl %ebx
		 cmpl %eax,%ebx
		 jge L0
		 pushl $1
		 jmp L1
L0:
		 pushl $0
L1:
		 popl %ebx
		 popl %eax
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 movl %eax,y
		 pushl %eax
		 popl %eax
		 pushl x
		 pushl $2
		 pushl y
		 popl %ebx
		 popl %eax
		 imull %ebx,%eax
		 pushl %eax
		 popl %ebx
		 popl %eax
		 addl %ebx,%eax
		 pushl %eax
		 popl %eax
		 movl %ebp,%esp
		 popl %ebp
		 ret

		 .comm x,4,4
		 .comm y,4,4

*/







