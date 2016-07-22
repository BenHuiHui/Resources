
/*****************************************************************
    CS4212 -- Compiler Design
    Naive Expression Compiler
    Handles expressions with integers and the following binary
    operators: +, -, *, /, rem
    Generates utterly unoptimized Pentium AL code (hence "naive").

    Essentially, performs a postorder traversal of the AST.
      - For each constant, an instruction to push the constant
        on the stack is issued
      - For each operator, the code to be issued is placed is
        defined with the predicate 'cop'
      - After traversal, two code fragments are prepended and
        appended, respectively, to the generated code, to obtain
	a full-fledged assembly language procedure
      - The resulting procedure is called 'start', and must
        be linked in with the C file 'runtime.c'
   The "workhorse" predicate is 'ce'. It takes in an expression,
   and returns a (Prolog) list of instructions representing the
   generated program. This is the predicate that performs the
   postorder traversal. We encode all instructions as
   single-quote-delimited atoms. Programs are encoded as Prolog
   lists of such atoms. After the full program has been constructed,
   the atoms are pasted together into a single huge atom that
   can be printed on the screen, and then copied and pasted
   into an assembly language file.

   The main predicate is 'out'. It takes in an expression, and
   prints its translation on the screen.


*****************************************************************/

% The database of code fragments that must be generated for each
% operator. It seems like there is a lot of repetition, and that
% the code could be further factorized. However, the sequence
% for division is different from the others, because of the way
% the IDIV instruction works. In the future, as we extend the compiler,
% we shall encounter such situations quite often, and this approach
% gives most flexibility.
%
cop(+,['popl %ebx', 'popl %eax', 'addl %ebx,%eax', 'pushl %eax']).
cop(-,['popl %ebx', 'popl %eax', 'subl %ebx,%eax', 'pushl %eax']).
cop(*,['popl %ebx', 'popl %eax', 'imull %ebx,%eax', 'pushl %eax']).
cop(/,['popl %ebx', 'popl %eax', 'cdq', 'idiv %ebx', 'pushl %eax']).
cop(rem,['popl %ebx', 'popl %eax', 'cdq', 'idiv %ebx', 'pushl %edx']).

% The workhorse of the compiler, performs postorder traversal of
% the abstract syntax tree.
%
ce(C,[Instr]) :- % rule for constants
        integer(C), % check that the expression is indeed a constant
        !,          % if yes, no need to try the next rule later
        atomic_list_concat(['pushl $',C],Instr).
                    % Instr will be an instruction that pushes const on stack
ce(E,Code) :- % rule for binary expressions
        E =.. [Op,E1,E2], % decompose the expression into its components
	                  % Op = operator E1 = left operand E2 = right opd
	member(Op,[+,-,*,/,rem]),
	                  % Check that the operator is legal
	!,                % 'member' can only succeed once, no need for further search
	ce(E1,C1),   % Traverse the left operand, C1 = generated AL code
	ce(E2,C2),   % Traverse the right operand, C2 = generated AL code
	cop(Op,Cop), % Retrieve code fragment for the current operator in Cop
	append([C1,C2,Cop],Code).
                     % Code = generated code for expression E

% Main predicate, takes in an expression and prints it on the screen
% (write to file will be implemented in one of the extensions)
%
out(E) :-
	ce(E,Code), % Get the code generated for E as the list Code
	Pre = [ '.section .text', % Preamble of AL file
		'.globl _start',
		'_start:',
	        'pushl %ebp',
		'movl %esp,%ebp'],
	Post = ['popl %eax',      % Postambl of AL file
		'movl %ebp,%esp',
		'popl %ebp',
		'ret'],
	append([Pre,Code,Post],All), % All is the list with all the code
	atomic_list_concat([''|All],'\n\t',AllWritable),
	                             % AllWritable is all code in a single atom
				     % Instructions are separated by '\n\t', so it
				     % is pretty-printed.
	write(AllWritable). % Dump generated code on the screen

/* Example interactions (copy and paste into the Read-Eval-Print window)
   Then, copy the AL part into a separate file, name it, say, test.s,
   and compile with

        gcc -o test runtime.c test.s

   The resulting executable will print the value of the expression.

?- out(1+2).

        .section .text
        .globl _start
        _start:
        pushl %ebp
        movl %esp,%ebp
        pushl $1
        pushl $2
        popl %ebx
        popl %eax
        addl %ebx,%eax
        pushl %eax
        popl %eax
        movl %ebp,%esp
        popl %ebp
        ret
true.

?- out(2*3-4/5+6).

        .section .text
        .globl _start
        _start:
        pushl %ebp
        movl %esp,%ebp
        pushl $2
        pushl $3
        popl %ebx
        popl %eax
        imull %ebx,%eax
        pushl %eax
        pushl $4
        pushl $5
        popl %ebx
        popl %eax
        cdq
        idiv %ebx
        pushl %eax
        popl %ebx
        popl %eax
        subl %ebx,%eax
        pushl %eax
        pushl $6
        popl %ebx
        popl %eax
        addl %ebx,%eax
        pushl %eax
        popl %eax
        movl %ebp,%esp
        popl %ebp
        ret
true.


*/



