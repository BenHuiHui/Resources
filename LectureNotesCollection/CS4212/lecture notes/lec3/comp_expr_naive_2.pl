/*****************************************************************
    CS4212 -- Compiler Design
    Naive Expression Compiler, v2.
    Handles expressions with integers and the following binary
    operators: +, -, *, /, rem, < ("less then uses 0 and 1 as booleans)
    Generates utterly unoptimized Pentium AL code (hence "naive").

    This is an extension of the Naive Expression Compiler v1 (so it's
    probably best if you understand that one first). In terms of the
    expression language, all we add is the comparison operator '<'.
    However, at the implementation level, this will turn out to
    complicate things quite a bit. In translating comparison,
    we need labels, and while the principle of generating code
    by postorder traversal remains in place, each time we add the
    program fragment corresponding to an instance of '<', we need
    to generate a fresh set of labels for it. Thus, the code fragment
    for '<' becomes a _pattern_, with placeholders for these labels.
    The placeholders are represented by Prolog variables, and we
    take advantage of the _lazy_binding_ programming technique
    to fill the placeholders with fresh atoms representing labels
    every time the comparison code is issued.

   As before, the "workhorse" predicate is 'ce'. It takes in an
   expression, and returns a (Prolog) list of instructions representing
   the generated program. This is the predicate that performs the
   postorder traversal. We encode all instructions and labels as
   single-quote-delimited atoms. However, because labels and
   instructions have different indentations, the pretty-printing
   atom '\n\t\t ' can no longer be inserted in one go, and must
   be part of all those instructions that are indented. As
   before, programs are encoded as Prolog lists of such quoted atoms.
   After the full program has been constructed, the atoms are pasted
   together into a single huge atom that can be printed on the screen,
   and then copied and pasted into an assembly language file.

   The main predicate is 'out'. It takes in an expression, and
   prints its translation on the screen.


*****************************************************************/

:- [library(clpfd)]. % We need arithmetic

% Predicate that fills the placeholders for labels in a program
% fragment. The first argument is the set of placeholders (note
% that we don't need to bring the code pattern as an argument too).
% Each label will have the form 'Ln', where n is a new number (computed
% as the previously used number +1. Of course, we have to keep track
% of this number, and if we had assignment, we could just update
% its value to n+1. However, this is not possible in Prolog, so we
% must use input and output variables to keep track of the value
% that must be used for the next label. The second and third
% argument are such input and output variables.
%
generateLabels([],LabelSuffix,LabelSuffix).
          % If the list of placeholders is empty, the input and output
          % label suffix are the same, since no label is generated
generateLabels([H|T],LabelSuffixIn,LabelSuffixOut) :-
	  % The second argument is the number to be used on the next label
	atomic_list_concat(['L',LabelSuffixIn],H),
	  % Generate the label atom and bind it to H
	LabelSuffixAux #= LabelSuffixIn + 1,
	  % Compute the number for the next label as LabelSuffixIn+1
	generateLabels(T,LabelSuffixAux,LabelSuffixOut).
          % Recursively generate labels for the rest of the placeholders.
          % The output of the recursive call is also the output of the current call.

% cop must now have 3 arguments. The first argument is the same,
% and the third argument is the same as the second arg of cop in
% version 1. The second argument is new, and supposed to reflect
% the list of placeholders for the third argument. If no such
% placeholders are used for a given program fragment, then the
% list should be empty
%
cop(+,[],                      % generated code for + remains the same
    ['\n\t\t popl %ebx',       % thus the second arg is empty
     '\n\t\t popl %eax',       % however, the pretty printing atom '\n\t\t '
     '\n\t\t addl %ebx,%eax',  % has been moved inside each instruction
     '\n\t\t pushl %eax']).
cop(-,[],                      % same for -
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t subl %ebx,%eax',
     '\n\t\t pushl %eax']).
cop(*,[],                      % same for *
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t imull %ebx,%eax',
     '\n\t\t pushl %eax']).
cop(/,[],                      % same for /
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t cdq',
     '\n\t\t idiv %ebx',
     '\n\t\t pushl %eax']).
cop(rem,[],                    % same for rem
    ['\n\t\t popl %ebx',
     '\n\t\t popl %eax',
     '\n\t\t cdq',
     '\n\t\t idiv %ebx',
     '\n\t\t pushl %edx']).
cop(<,[L1,L2],                 % '<' generates a code pattern with two labels
    ['\n\t\t popl %eax',       % the placeholders for these two labels are L1 and L2.
     '\n\t\t popl %ebx',       % Each time this code fragment is retrieved for '<',
     '\n\t\t cmpl %eax,%ebx',  % Prolog makes a fresh copy of L1 and L2
     '\n\t\t jge ', L1,	       % and then, in the 'ce' predicate we call
     '\n\t\t pushl $1',        % generateLabel([L1,L2],...) to bind the fresh copies
     '\n\t\t jmp ', L2,'\n',   % to atoms representing labels.
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).

% Predicate to compile an expression
% Compared to v1, it has two new arguments, because it must generate
% labels. As with generateLabels, there must be an input label number
% and an output label number.
%
ce(C,[Instr],LabelSuffix,LabelSuffix) :- % rule for constant expression
	% no labels will be generated here, so the input and output
	% label numbers are the same
	integer(C),!, % same as before
	atomic_list_concat(['\n\t\t pushl $',C],Instr).
ce(E,Code,LabelSuffixIn,LabelSuffixOut) :-
	E =.. [Op,E1,E2],
	member(Op,[+,-,*,/,rem,<]),!, % same as before, '<' added to the list
	cop(Op,LPlaceholders,Cop), % here we also retrieve the label placeholders
	generateLabels(LPlaceholders,LabelSuffixIn,LabelSuffixAux1),
	   % at this point, the labels have been generated, and Cop is ready to be issued.
	ce(E1,C1,LabelSuffixAux1,LabelSuffixAux2),
	   % connect the output of one to the input of the next.
	ce(E2,C2,LabelSuffixAux2,LabelSuffixOut),
	append([C1,C2,Cop],Code).

% main predicate, slightly changed from v1, by adding the pretty
% printing codes into the instruction atoms.
%
out(E) :-
	ce(E,Code,0,_), % start with label numbers at 0, don't care abt their final value
	Pre = [ '\n\t\t .section .text', % Prelude to the AL function
		'\n\t\t .globl _start',
		'\n_start:',
	        '\n\t\t pushl %ebp',
		'\n\t\t movl %esp,%ebp'],
	Post = ['\n\t\t popl %eax',      % Postlude
		'\n\t\t movl %ebp,%esp',
		'\n\t\t popl %ebp',
		'\n\t\t ret'],
	append([Pre,Code,Post],All), % get all instructions in one list
	atomic_list_concat(All,AllWritable),
				     % obtain giant writable atom
	write(AllWritable).          % and dump it on the screen

/* Example interactions (copy and paste into the Read-Eval-Print window)
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





