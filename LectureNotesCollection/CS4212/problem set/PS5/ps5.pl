/*****************************************************************
* Song Yangyu | A0077863N
* CS4212 PS5
*****************************************************************/

:- [library(clpfd)]. % We need arithmetic
:- [library(lists)]. % We need 'union'

% Operator declarations
:- op(1099,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

% NOTE: EDIT START
:- op(1100, xfy, '||').

random_add_cosw([],[]):- !.
random_add_cosw([H|T],LO):-
    % only add if H is started with a new-line char; 
    % 2 is the frequency set. can be defined as other number also
    (   atom_prefix(H,'\n\t\t'),X is random(2),X is 0
    ->  HO = ['\n\t\t call cosw',H]
    ;   HO = [H]
    ),
    random_add_cosw(T,LOT), append(HO,LOT,LO).
% NOTE: EDIT START


% Predicate to generate new labels when needed
%
generateLabels([],LabelSuffix,LabelSuffix).
generateLabels([H|T],LabelSuffixIn,LabelSuffixOut) :-
	atomic_list_concat(['L',LabelSuffixIn],H),
	LabelSuffixAux #= LabelSuffixIn + 1,
	generateLabels(T,LabelSuffixAux,LabelSuffixOut).

% Database that associates operators with the equivalent Pentium code
% 
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
cop(<,[L1,L2], % second arg lists label placeholders
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jge ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(=<,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jg ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(>,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jle ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(=<,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jl ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(==,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t jne ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(\=,[L1,L2],
    ['\n\t\t popl %eax',
     '\n\t\t popl %ebx',
     '\n\t\t cmpl %eax,%ebx',
     '\n\t\t je ', L1,
     '\n\t\t pushl $1',
     '\n\t\t jmp ', L2,'\n',
L1,':',
     '\n\t\t pushl $0','\n',
L2,':'                  ]).
cop(=,[V],
    ['\n\t\t popl %eax',
     '\n\t\t movl %eax,',V,
     '\n\t\t pushl %eax' ]).

% Predicate to compile an expression, essentially
% the same as comp_expr_naive_4.pro
%
ce(C,[Instr],A,A) :-
	(   integer(C), P = '$' ; atom(C),P='' ),!,
	atomic_list_concat(['\n\t\t pushl ',P,C],Instr).
ce(E,Code,AIn,AOut) :-
	E =.. [Op,E1,E2],
	member(Op,[+,-,*,/,rem,<,=<,>,>=,\=,==,=]),!,
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

% Improved version, capable of adding variable names
% to an array of strings, so that the runtime can
% print the value of all the variables at the end of
% program
% 1st arg: list of variable names collected from program
% 2nd arg: allocation of space for each variable
% 3rd arg: array of strings containing names of variables
% 4th arg: array of pointers to each of the strings
allocvars([],[],[],[]).
allocvars([V|VT],[D|DT],[N|NT],[P|PT]) :-
	atomic_list_concat(['\n',V,':\t\t .long 0'],D),
	atomic_list_concat(['\n',V,'_name:\t .asciz "',V,'"'],N),
	atomic_list_concat(['\n',V,'_ptr:\t .long ',V,'_name'],P),
	allocvars(VT,DT,NT,PT).

% NOTE: EDIT START
cs(({S1} '||' {S2}),Code,Ain,Aout) :-
	get_assoc(labelsuffix,Ain,LabelSuffixIn,A0,LabelSuffixOut),
	generateLabels([LC2,LCend],LabelSuffixIn,LabelSuffixOut),

    cs(S1,CS1,A0,A1),
    cs(S2,CS2,A1,Aout),

    % add in cosw randomly
    random_add_cosw(CS1,CAS1),
    random_add_cosw(CS2,CAS2),

    % merge code
    append(
        [   [   % init
                '\n\t\t call init_threads',
                '\n\t\t movl $',LC2,',%eax',
                '\n\t\t call set_second_thread'
            ],
            CAS1,
            [   % C1 end, join; and C2 start label
                '\n\t\t call single_thread',
                '\n\t\t jmp ',LCend,
                '\n',LC2,':'
            ],
            CAS2,
            [   % C2 end, join; and overall end label
                '\n\t\t call single_thread',
                '\n',LCend,':'
            ]
        ],Code).
% NOTE: EDIT ENDS

% Statement compiler
% Works in a manner similar to the expression compiler
%   -- needs input and output set of attributes
%   -- attributes are the same
% Relies on expression compiler for handling assignments
cs(break, Code,Ain,Aout) :- !,    % added in class, as example of adding
	Code = [ '\n\t\t jmp ',Lbl ], % new attributes
	get_assoc(labelsuffix,Ain,LabelSuffixIn,A,LabelSuffixOut),
	generateLabels([Lbl],LabelSuffixIn,LabelSuffixOut),
	put_assoc(break,A,Lbl,Aout).

cs((X=E),Code,Ain,Aout) :- !, % assignments
	ce((X=E),C,Ain,Aout),
	append([C,['\n\t\t popl %eax']], Code).

cs({S},Code,Ain,Aout) :- !, % blocks, trivially remove braces
	cs(S,Code,Ain,Aout).

cs((S;),Code,Ain,Aout) :- !, % unary semicolon, trivially remove
	cs(S,Code,Ain,Aout).

cs((S1;S2),Code,Ain,Aout) :- !,   % statement sequence
	cs(S1,Code1,Ain,Aaux),    % code is the concatenation of
	cs(S2,Code2,Aaux,Aout),   % recursively obtained codes for
	append(Code1,Code2,Code). % sub-statements

cs((if B then { S1 } else { S2 }),Code,Ain,Aout) :-!, % if-then-else statement
	ce(B,CB,Ain,A1),                    % Compile B recursively
	Cif1 = [ '\n\t\t popl %eax',	    % Code to check if B is false
	         '\n\t\t cmpl $0,%eax',     %   -- if it is, jump to else branch
	         '\n\t\t je ',Else_branch ],
	cs(S1,C1,A1,A2),                    % Compile then branch recursively
	Cif2 = [ '\n\t\t jmp ',End_if,      % Add a jump to skip the else branch
		 '\n',Else_branch,':' ],        % Add label for else branch
	cs(S2,C2,A2,A3),                    % Compile else branch recursively
	Cif3 = [ '\n',End_if,':' ],         % End of 'if' label
	get_assoc(labelsuffix,A3,LabelSuffixIn,Aout,LabelSuffixOut),
	generateLabels([Else_branch,End_if],LabelSuffixIn,LabelSuffixOut),
                                        % The two labels must be generated
                                        % dynamically, and the label
                                        % counter must be updated in the
                                        % attribute dictionary.
	append([CB,Cif1,C1,Cif2,C2,Cif3],Code). % Put all code together

cs((if B then { S }),Code,Ain,Aout) :-!, % if-then statement
	ce(B,CB,Ain,A1),                 % Compile B recursively
	Cif1 = [ '\n\t\t popl %eax',     % Code to check if B is false
	         '\n\t\t cmpl $0,%eax',	 %   -- if it is, skip the 'then' branch
	         '\n\t\t je ',End_if ],
	cs(S,C,A1,A2),                   % Compile then-branch recursively
	Cif2 = [ '\n',End_if,':' ],      % End-of-if label
	get_assoc(labelsuffix,A2,LabelSuffixIn,Aout,LabelSuffixOut),
	generateLabels([End_if],LabelSuffixIn,LabelSuffixOut),
                                     % Generate label dynamically and update
                                     % the label counter
	append([CB,Cif1,C,Cif2],Code).   % Put all the code together

cs((while B do { S }),Code,Ain,Aout) :-!,    % while loops, GCC 4 style
	get_assoc(break,Ain,BreakOrig,A0,none),
        Cwh1 = [ '\n\t\t jmp ',While_cond,   % code to jump to 'while' condition
	         '\n',While_start,':'     ],     % Looping label
	cs(S,C,A0,A1),                           % Compile S recursively
	Cwh2 = [ '\n',While_cond,':' ],          % While condition label
	ce(B,CB,A1,A2),	                         % Compile B recursively
	Cwh3 = [ '\n\t\t popl %eax',             % Code to check if B is true
	         '\n\t\t cmpl $0,%eax',          %  -- if it is, jump to top of loop
	         '\n\t\t jne ',While_start ],
	get_assoc(labelsuffix,A2,LabelSuffixIn,A3,LabelSuffixOut),
	generateLabels([While_cond,While_start],LabelSuffixIn,LabelSuffixOut),
                                             % Generate labels dynamically
                                             % and update the label counter
	get_assoc(break,A3,CurrentBreak,Aout,BreakOrig),
	(   CurrentBreak == none
	 -> CodeBreak = []
	 ;  CodeBreak = ['\n',CurrentBreak,':'] ),
	append([Cwh1,C,Cwh2,CB,Cwh3,CodeBreak],Code).  % Put all the code together

out(P,File) :-
	tell(File),                              % open output file
	empty_assoc(Empty),                      % initialize attribute dict
        put_assoc(break,Empty,none,A0),
	put_assoc(labelsuffix,A0,0,A1),          % add initial label counter
	put_assoc(vars,A1,[],A2),                % add initial list of vars
	cs(P,Code,A2,A3),                        % Compile program P into Code
	                                         %  -- Code is now a list of atoms
                                             %     that must be concatenated to get
                                             %     something printable
	Pre = [ '\n\t\t .text',                  % Sandwich Code between Pre and Post
		'\n\t\t .globl _entry',              %  -- sets up compiled code as
		'\n_entry:',                         %     procedure 'start' that can be
	        '\n\t\t pushl %ebp',             %     called from runtime.c
		'\n\t\t movl %esp,%ebp'],
	Post = ['\n\t\t movl %ebp,%esp',
		'\n\t\t popl %ebp',
		'\n\t\t ret'],
	append([Pre,Code,Post],All),             % The actual sandwiching happens here
	atomic_list_concat(All,AllWritable),     % Now concat and get writable atom
	writeln(AllWritable),                    % Print it into output file
        get_assoc(vars,A3,VarList),          % Create data declarations for all vars
	allocvars(VarList,VarCode,VarNames,VarPtrs),
	atomic_list_concat(VarCode,WritableVars),
                                             % Write declarations to output file
	write('\n\t\t .data\n\t\t .globl __var_area\n__var_area:\n'),
	write(WritableVars),
	                                         % Create array of strings representing
                                             % variable names, so that vars can
                                             % be printed nicely from the runtime
	atomic_list_concat(VarNames,WritableVarList),
	write('\n\n\t\t .globl __var_name_area\n__var_name_area:\n'),
	write(WritableVarList),
	                                         % Create array of pointers to strings
                                             % so that runtime code doesn't need
                                             % to be changed every time we compile
	atomic_list_concat(VarPtrs,WritableVarPtrs),
	write('\n\n\t\t .globl __var_ptr_area\n__var_ptr_area:\n'),
	write(WritableVarPtrs),
	write('\n\n__end_var_ptr_area:\t .long 0\n'),
	told. % close output file

?- Program = (
i = 0 ; j = 0 ; a = 0 ;
{ % thread 0
while i < 10 do {
a = a + 1 ;
i = i + 1 ;
} 
} '||' { % thread 1
while j < 10 do {
a = a - 1 ;
j = j + 1 ;
}
}), out(Program,'test0.s').

