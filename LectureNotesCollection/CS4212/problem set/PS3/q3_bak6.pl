/********************************************************************************************
  Song Yangyu (A0077863N)
  Changed based on file 'compiler_scoped_while_lang.pl'
  Place of changes was put within: % NOTE
**********************************************************************************************/

:- [library(clpfd)]. % We need arithmetic
:- [library(lists)]. % We need 'union'

% operator declarations that allow the above program to be read as a Prolog term
:- op(1099,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(1050,fx,global).
:- op(1050,fx,local).
:- op(960,fx,for).
:- op(960,fx,while).
:- op(959,xfx,do).
:- op(960,fx,switch).
:- op(959,xfx,of).
:- op(970,xfx,::).
:- op(960,fx,switch).
:- op(959,xfx,of).
:- op(970,xfx,::).

atomic_list_recur_to_single_list([],[]):-!.
atomic_list_recur_to_single_list(L,R):-!,
    L = [LH|LT], 
    ( is_list(LH) -> atomic_list_recur_to_single_list(LH,RH) ; RH = [LH]), % assume if not list then it's atomic
    atomic_list_recur_to_single_list(LT,RT), append(RH,RT,R).

atom_chars_is_label_tail(LblTail):-
    LblTail = [H|T],
    (   (   T = [],!,H = ':')
    ;   (   atom_to_term(H,Hp,_),integer(Hp),!,atom_chars_is_label_tail(T))
    ).
atom_is_label_pattern(Lbl):-
    atom_chars(Lbl,LblList), LblList = ['\n','L'|LblTail],
    atom_chars_is_label_tail(LblTail).

remove_duplicate_lbl(Lin,Lout):-
    empty_assoc(A),remove_duplicate_lbl(Lin,Lout,A,_).
remove_duplicate_lbl([],[],A,A):-!.
remove_duplicate_lbl(Lin,Lout,Ain,Aout):-!,
    Lin = [HLin | TLin],
    (   atom_is_label_pattern(HLin)
    ->  (   get_assoc(HLin,Ain,_)
        ->  (   Lout = TRes, A0 = Ain)
        ;   (   put_assoc(HLin,Ain,1,A0), Lout = [HLin | TRes] )
        )
    ;   (   Lout = [HLin | TRes],A0 = Ain)
    ),
    remove_duplicate_lbl(TLin,TRes,A0,Aout).


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

% Generate fresh labels for label placeholders
%  1st arg : list of label placeholders to be instantiated
%  2nd arg : integer suffix not yet used for a label before the call
%  3rd arg : integer suffix not yet used for a label after the call
%              -- essentially LabelSuffixOut #= LabelSuffixIn + length(1st_arg)
generateLabels([],LabelSuffix,LabelSuffix).
generateLabels([H|T],LabelSuffixIn,LabelSuffixOut) :-
    atomic_list_concat(['L',LabelSuffixIn],H),
    LabelSuffixAux #= LabelSuffixIn + 1,
    generateLabels(T,LabelSuffixAux,LabelSuffixOut).

% Replace register numbers with register names
%  1st arg : code template (list of atoms) with regs represented
%              as reg32(N) or reg8(N)
%  2nd arg : same code where each reg32(N) or reg8(N) has been replaced
%              with the corresponding register name
replace_regs([],[]).
replace_regs([reg32(N)|T],[A|TR]) :-
    member((N,A),
           [(0,'%eax'),(1,'%edx'),(2,'%ecx'),
            (3,'%ebx'),(4,'%esi'),(5,'%edi')]),!,
    replace_regs(T,TR).
replace_regs([reg8(N)|T],[A|TR]) :-
    member((N,A),
           [(0,'%al'),(1,'%dl'),(2,'%cl'),(3,'%bl')]),!,
    replace_regs(T,TR).
replace_regs([H|T],[H|TR]) :- replace_regs(T,TR).

% combine_expr_code is the main predicate performing register
% allocation for partial results of expressions. It tries to
% minimize register use, and avoid spilling results into memory.
%
% This predicate is called by the 'ce' (compile expression) predicate,
%  after it has generated code for the subexpressions of a binary
%  expression. This predicate generates a code template for the
%  current operator, allocating registers for partial results,
%  yet leaving the registers as underspecified as possible.
%
%  1st & 2nd arg : representation of the result holder for the
%                  left and right subexpressions. May have the
%                  following format:
%                  const(N)    : the result is the constant N
%                  id(X)       : the result is variable X
%                  [R1,R2,...] : the result is in register R1
%                                (which may be an unbound variable)
%                                and the rest of the list contains
%                                the registers that MUST be used
%                                (and therefore will be clobbered)
%                                throughout the evaluation of
%                                the subexpression at hand
% 3rd       arg : The operator for which code is being generated
%                 Can be any of the following:
%                  +,-,*,/\,\/ : any pair of registers can be used as operands
%                  /,rem       : must use %eax,%edx, and another register
%                  <,=<,>,>=,==,\= : may have residual code so as to
%                                    allow compilation as regular arithmetic expr,
%                                    and also efficient code when appears as
%                                    if or while condition
% 4th & 5th arg : Code generated for the left and right subexpressions
%                 (must be consistent with 1st and 2nd arg)
% 6th arg       : Resulting code for the current expression (return value)
% 7th arg       : Residual code, empty for all arithmetic expressions, but
%                 non-empty for boolean expressions. The residual code places
%                 the boolean value in a register. This is not necessary
%                 if a boolean expr say x < y appears as an 'if' or 'while'
%                 condition, but it is necessary if we use it in an
%                 arithmetic expression, in the form (x<y)+1.
%                 Thus, the decision of whether the residual code should be
%                 appended to the currently generated code needs to be made
%                 one level above from the current call.
% 8th arg       : The result holder, with the same syntax as args 1 and 2.
%                 The predicate will decide to either return directly a
%                 constant or variable, if possible (thus not using any
%                 of the registers, and allowing them to be used for other
%                 purposes). Or, it will return a list of registers (encoded
%                 as numbers, with the encoding given by predicate replace_regs).
%                 In that case, the first register in the list holds the
%                 result of the expression, and the rest of the registers
%                 will be used (and therefore, their values will be clobbered)
%                 throughout the evaluation, but once the result has been computed,
%                 will no longer hold any important value, and can be reused
%                 for in evaluations of other subexpressions.
combine_expr_code(const(N),const(M),Op,[],[],[],[],Result) :-
                       % Expressions containing only constants are evaluated
                       % at compile time and do not generate any code
    member(Op,[+,-,*,/\,\/,/]),!,
    ResultExpr =.. [Op,N,M],
    ResultVal #= ResultExpr, % For arithmetic expressions, use #=
    Result = const(ResultVal).

combine_expr_code(const(N),const(M),Op,[],[],[],[],Result) :-
                       % Expressions containing only constants are evaluated
                       % at compile time and do not generate any code
    member((Op,Opc),[(<,#<),(>,#>),(=<,#=<),(>=,#>=),(\=,#\=),(==,#=)]),!,
    ResultExpr =.. [Opc,N,M],
    ResultVal #<==> ResultExpr, % For boolean expressions, use #<==>
    Result = const(ResultVal).

combine_expr_code(L,R,Op,[],[],Code,Residue,Result) :-
                       % Subexpressions that do not need to be held in registers
                       % are expected to have generated empty code
    ( L = const(Tmp), R = id(Y), atomic_concat('$',Tmp,X) ;
      L = id(X), R = const(Tmp), atomic_concat('$',Tmp,Y) ;
      L = id(X), R = id(Y) ),
    member((Op,I),[(<,setl),(=<,setle),(>,setg),(>=,setge),(\=,setne),(==,sete)]),!,
                       % For boolean expressions, a residue may be needed
                       % This is possible only with regs eax,edx,ecx,ebx
                       % The setXX instruction sets an 8-bit reg to 1 or 0
                       %   depending on whether the XX condition is true or false;
                       %   the corresponding 32-bit reg can hold the same result
                       %   if it has been zeroed first.
    Result = [Reg], Reg in 0..3,
                       % This operator must use one register, which we denote
                       % by Reg. This register will not be explicitly specified,
                       % but allocated through constraint programming later,
                       % when the predicate 'label' is called for the entire
                       % code template, corresponding to the entire expression at hand.
                       % Thus, currently, Reg is an unbound variable, constrained
                       % to be between 0 and 3.
                       % The Result list is the list containing this register
    Code = [ '\n\t\t movl ',X,',',reg32(Reg),  % Load one operand into a register
             '\n\t\t cmpl ',Y,',',reg32(Reg) ],%   and compare with the other;
                                               %   result will be stored in condition flags
    Residue = [ '\n\t\t movl $0,',reg32(Reg),  % Zero the register first, and then
                '\n\t\t ',I,' ',reg8(Reg)    ].%   set the lower 8 bits to 0 or 1


combine_expr_code(L,R,Op,[],[],Code,[],Result) :-
                       % Subexpressions that do not need to be held in registers
                       % are expected to have generated empty code
    ( L = const(Tmp), atomic_concat('$',Tmp,X), R = id(Y) ;
      L = id(X), R = const(Tmp), atomic_concat('$',Tmp,Y) ;
      L = id(X), R = id(Y) ),
                       % Handling of arithmetic operators that can be performed
                       % using any registers
    member((Op,I),[(+,addl),(-,subl),(*,imull),(/\,andl),(\/,orl)]),!,
    Result = [Reg], Reg in 0..5,
                       % This operator must use one register, which we denote
                       % by Reg. This register will not be explicitly specified,
                       % but allocated through constraint programming later,
                       % when the predicate 'label' is called for the entire
                       % code template, corresponding to the entire expression at hand.
                       % Thus, currently, Reg is an unbound variable, constrained
                       % to be between 0 and 5.
                       % The Result list is the list containing this register
    Code = [ '\n\t\t movl ',X,',',reg32(Reg),    % Load one operand into a register
             '\n\t\t ',I,' ',Y,',',reg32(Reg) ]. % and perform the operation with the
                                                 % other operand.

combine_expr_code(L,R,Op,[],[],Code,[],Result) :-
                       % Subexpressions that do not need to be held in registers
                       % are expected to have generated empty code
    ( L = const(Tmp), atomic_concat('$',Tmp,X), R = id(Y) ;
      L = id(X), R = const(Tmp), atomic_concat('$',Tmp,Y) ;
      L = id(X), R = id(Y) ),
                       % Handling of division and remainder operators. This is
                       % complicated because one operand, as well as the result
                       % must be in registers %edx:%eax
    member((Op,I),[(/,idivl),(rem,idivl)]),!,
                       % 0 = %eax, 1 = %edx
                       % For division, result will be [%eax,%edx,Reg]
                       % For reminder, result will be [%edx,%eax,Reg]
    (R = const(_)
      -> CodeL = [ '\n\t\t movl ',Y,',',reg32(Reg) ], Reg in 0..5, Z = reg32(Reg),
         (Op == / ->  Result = [0,1,Reg] ; Result = [1,0,Reg])
      ;  CodeL = [], (Op == / ->  Result = [0,1] ; Result = [1,0]), Z = Y ),
                       % In this code template, reg32(0) will be later replaced
                       % with %eax by replace_regs. Similar for reg32(1) --> %edx
    CodeOp = [ '\n\t\t movl ',X,',',reg32(0),
               '\n\t\t movl ',reg32(0),',',reg32(1),
               '\n\t\t shrl $31,',reg32(1), % sign extend %edx
               '\n\t\t ',I,' ',Z ],         % I = idivl
    all_distinct(Result),
    Code = [CodeL,CodeOp].

combine_expr_code(L,R,Op,CL,CR,Code,[],Result) :-
                       % Code generation for the case when one subexpression
                       % is constant or a variable (i.e. doesn't need registers
                       % in its evaluation), and the other subexpression does
                       % need registers. The used registers list remains the same,
                       % as the result register of the subexpression that needs one
                       % can be reused to hold the result of the current expression.
    ( L = [Reg|_], ( R = const(Tmp),atomic_concat('$',Tmp,X) ; R = id(X)) ;
      (L = const(Tmp), atomic_concat('$',Tmp,X) ; L = id(X)), R = [Reg|_] ),
                       % handle operators that can be performed between any registers
    member((Op,I,L),   % moreover, handle only commutative operators
           [(+,addl,_),(-,subl,[_|_]),(*,imull,_),(/\,andl,_),(\/,orl,_)]),!,
    ( L = [_|_] -> Result = L ; Result = R ),
    CodeOp = [ '\n\t\t ',I,' ',X,',',reg32(Reg) ], % code to perform operation between
    (CL = [] -> CS = CR ; CS = CL),                % result reg and const/var operand
    append([CS,CodeOp],Code).                      % order of operands NOT SIGNIFICANT

combine_expr_code(L,R,Op,CL,CR,Code,Residue,Result) :-
                       % One subexpression is const/variable, the other needs
                       % registers. This rule is for boolean operators.
    ( L = [Reg|_], ( R = const(Tmp), atomic_concat('$',Tmp,X) ; R = id(X)) ;
      (L = const(Tmp), atomic_concat('$',Tmp,X) ; L = id(X)), R = [Reg|_] ),
    member((Op,I),
           [(<,setl),(=<,setle),(>,setg),(>=,setge),(==,sete),(\=,setne)]),!,
                       % check if boolean operator, and set instruction for
                       % residual code
    ( L = [_|_] -> Result = L ; Result = R ),
    (   CL = []        % Standard code: compare operands, leave result in flags
    ->  CS = CR, CodeOp = [ '\n\t\t cmpl ',reg32(Reg),',',X ]
    ;   CS = CL, CodeOp = [ '\n\t\t cmpl ',X,',',reg32(Reg) ] ),
    append([CS,CodeOp],Code),
    Reg in 0..3,
    Residue = [ '\n\t\t movl $0,',reg32(Reg), % residual code to use in expressions
                '\n\t\t ',I,' ',reg8(Reg) ].  % of the form 1 + (a<b).

combine_expr_code(L,R,Op,CL,[],Code,[],Result) :-
                       % For division/remainder, left operand MUST use registers,
                       % because of the constraints imposed by the idivl instruction.
                       % This is the case when the right operand is const/variable.
    L = [_|_], ( R = const(Tmp), atomic_concat('$',Tmp,X) ; R = id(X)),
    member((Op,I), [(/,idivl),(rem,idivl)]),!,
                       % Left subexpression may have used 1 or more registers.
    ( L = [0|T], select(1,T,Rest),
                       % If it used multiple registers, we try to make %edx one
                       % of the other used registers, and then reuse the registers
                       % in computing the entire expression (i.e. no new register is
                       % needed)
      (R = const(_)
        -> ( select(Reg,Rest,RRest) ; RRest = Rest),
           (Op == / -> Result = [0,1,Reg|RRest] ; Result = [1,0,Reg|RRest]),
           CodeL = [ '\n\t\t movl ',X,',',reg32(Reg) ], Reg in 0..5, Z = reg32(Reg)
        ;  (Op == / -> Result = L ; Result = [1,0|Rest] ), CodeL = [], Z = X ) )
                       % If Op = /, then result in %eax; if remainder, result in %edx

    ; L = [0],         % If a single register was used, then it must be the case that
                       % this register is %eax, and %edx will be used also (it is
                       % clobbered by idivl, so it must be indicated as 'used').
      (R = const(_)
        -> CodeL = [ '\n\t\t movl ',X,',',reg32(Reg) ], Reg in 0..5, Z = reg32(Reg),
           (Op == / ->  Result = [0,1,Reg] ; Result = [1,0,Reg])
        ;  CodeL = [], (Op == / ->  Result = [0,1] ; Result = [1,0]), Z = X ),
                       % If Op = /, then result in %eax; if remainder, result in %edx
    CodeOp = [ '\n\t\t movl ',reg32(0),',',reg32(1),
               '\n\t\t shrl $31,',reg32(1), % sign extend %eax into %edx
               '\n\t\t ',I,' ',Z ],
    all_distinct(Result),
    append( [CL,CodeL,CodeOp],Code).

combine_expr_code(L,R,Op,[],CR,Code,[],Result) :-
                       % The case when left subexpr is const/variable and
                       % right subexpression requires registers, for non-commutative
                       % operators --> may require an extra register
    (L = const(Tmp),atomic_concat('$',Tmp,X) ; L = id(X)), R = [Reg|_],
    Op = -,!, I = subl,% minus is non-commutative

    ( R = [Reg,Reg1|Rest]         % If a single register is used in computing
      -> Result = [Reg1,Reg|Rest] % subexpression, then an extra register is required
      ;  Result = [Reg1,Reg] ),   % to compute current expression

    CodeOp = [ '\n\t\t movl ',X,',',reg32(Reg1), % order of operands is now SIGNIFICANT
               '\n\t\t ',I,' ',reg32(Reg),',',reg32(Reg1) ],
    Code = [CR,CodeOp].

combine_expr_code(L,R,Op,[],CR,Code,[],Result) :-
                       % Left operand is const/variable, and right operand requires
                       % registers. Operation is division/remainder
                       % May require an extra registers
    (L = const(Tmp),atomic_concat('$',Tmp,X) ; L = id(X)), R = [H|T],
    member(Op,[/,rem]) ,!, I = idivl,

    ( H #\= 0, H #\= 1,  % easy case, right operand does not require %eax or %edx
                         % then, register holding result not clobbered by division/rem
                         % try to force %eax, %edx as used registers, but not holding
                         % result, since they will be used anyway by idivl --> leads
                         % to register use minimization
      (  select(0,T,R1), select(1,R1,Rest)
       ; select(0,T,Rest)
       ; select(1,T,Rest)
       ; Rest = T ),
                         % Result will be in %eax or %edx, depending on Op = / or Op = rem
      (Op == / -> Result = [0,1,H|Rest] ; Result = [1,0,H|Rest]),
                         % %eax and %edx can be used freely, since they do not hold
                         % anything important
      CodeOp = [ '\n\t\t movl ',X,',',reg32(0),
                 '\n\t\t movl ',reg32(0),',',reg32(1),
                 '\n\t\t shrl $31,',reg32(1), % sign extend %eax into %edx
                 '\n\t\t ',I,' ',reg32(H) ]   % I = idivl

    ; (  select(0,T,Rest) % Tough case, result of right operand in either %eax or %edx
       ; select(1,T,Rest) % Try enforcing the use of both regs in code of right operand
       ; Rest = T ),
                          % Check if new register is needed to save the result of
                          % right operand. Reg will either be an existing 'used'
                          % register (but not holding anything important, so that
                          % it can be used to hold a partial result) if possible, or a
                          % completely new, 'unused' register, if a 'used' one
                          % cannot be found.
    ( Rest = [] -> TRest = [] ; Rest = [Reg|TRest] ),
    (Op = / -> Result = [0,1,Reg|TRest] ; Result = [1,0,Reg|TRest]),
                          % The result of right operand will be saved from either
                          % %eax or %edx into Reg. Then, %eax and %edx can be used
                          % in the idivl operation.
      CodeOp = [ '\n\t\t movl ',reg32(H),',',reg32(Reg), % save %eax or %edx
                 '\n\t\t movl ',X,',',reg32(0),          % load %eax with left opd
                 '\n\t\t movl ',reg32(0),',',reg32(1),   % sign extend %eax into %edx
                 '\n\t\t shrl $31,',reg32(1),
                 '\n\t\t ',I,' ',reg32(Reg) ]            % divide by second, saved operand
    ),
    all_distinct(Result), % most registers are still unbound,
                          % make sure they will be distinct when allocated
    Code = [CR,CodeOp].

combine_expr_code(L,R,Op,CL,CR,Code,Residue,Result) :-
                          % Both expressions require registers, and the operator
                          % is boolean. Here we would like to use as many common
                          % registers as possible, so as to minimize register use.
                          % Generating code for the subexpression that requires more
                          % registers first will lead to 1 register holding the
                          % subexpression result, and the remaining registers to
                          % be potentially reused in the code generation of the
                          % other subexpression. If both subexpressions require the
                          % same number of registers, then an extra register will be
                          % required.
                          % This rule is for boolean operators, and is simpler
                          % because the result is stored in the flags (any register
                          % can be used for the residual code).
    L = [HL|TL], R = [HR|TR], L ins 0..5, R ins 0..5, NewReg in 0..5,
    member((Op,I),
           [(<,setl),(=<,setle),(>,setg),(>=,setge),(==,sete),(\=,setne)]),!,
    length(L,LgL), length(R,LgR),

    % first case, when both subexpressions require same no. regs --> extra reg needed
    ( LgL #= LgR
            % happy case, the two result registers are different
      -> (  HL #\= HR,
                          % enforce register reuse by making the right reg list
                          % a subset of the left tail + extra reg (denoted by '_')
            permutation([_|TL],R), Result = [HL,HR|TR],
                          % current operation implemented as comparison, result in flags
            CodeOp = [ '\n\t\t cmpl ',reg32(HR),',',reg32(HL) ],
                          % Generated code made up of the left subexpression code,
                          % followed by right subexpression code, followed by
                          % current operator code.
            append([CL,CR,CodeOp],Code),
            HL in 0..3,
                          % Residue moves flag result into register, so as to allow
                          % compilation of expressions of the form 1+(a<b)
            Residue = [ '\n\t\t movl $0,',reg32(HL),
                        '\n\t\t ',I,' ',reg8(HL) ]
            % less happy case, the two result registers are the same
            % this can only happen if the top-level operators of the left
            % and right subexpressions are both division or both remainder
            % extra register is needed to save right result
          ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
                          % enforce register reuse, as above
            permutation(TL,TR), Result = [NewReg,HL|TL],
                          % Generated code obtained by laying out
                          % the left subexpr code, followed by saving
                          % the result from either %eax or %edx into
                          % a new register, followed by the code for
                          % right subexpr, followed by comparison between
                          % %eax or %edx (depending on whether current Op is / or rem)
                          % and the saved register.
            append( [  CL,
                       [ '\n\t\t movl ',reg32(HL),',',reg32(NewReg) ],
                       CR,
                       [ '\n\t\t cmpl ',reg32(HR),',',reg32(NewReg) ] ],Code) ),
            NewReg in 0..3, % only 4 regs allow setXX instructions
                            % residual code transfers flag result into a register
            Residue = [ '\n\t\t movl $0,',reg32(NewReg),
                        '\n\t\t ',I,' ',reg8(NewReg) ]
      % second case, when right subexpr requires fewer regs than left
      % no new register needed; lay out code for left subexpr first, then for right
      ;  LgR #< LgL
         -> (  HL #\= HR, % happy case, result registers different
                          % permutation constraint ensures register reuse, as above
               permutation(TL,TLP), append(R,_,TLP), Result = L,
               CodeOp = [ '\n\t\t cmpl ',reg32(HR),',',reg32(HL) ],
               append([CL,CR,CodeOp],Code),
               HL in 0..3,
               Residue = [ '\n\t\t movl $0,',reg32(HL),
                           '\n\t\t ',I,' ',reg8(HL) ]
             % less happy case, the two result registers are the same
             % this can only happen if the top-level operators of the left
             % and right subexpressions are both division or both remainder
             % extra register may be needed to save right result, when
             % len(Left) = len(Right)+1
             ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
                          % Enforce register reuse, as above
               permutation(TL,TLP),
               (  append(TR,[NewReg|_],TLP),!,select(NewReg,TL,TLRest)
                ; TR = TLP, TLRest = TL ),
                          % NewReg will be a new, 'unused' register, if
                          % a 'used' one cannot be found.
               Result = [NewReg,HL|TLRest],
                          % NewReg used to save left subexpr result while
                          % the right subexrp is computed. NewReg also holds
                          % final result
               append([  CL,
                          [ '\n\t\t movl ',reg32(HL),',',reg32(NewReg) ],
                          CR,
                          [ '\n\t\t cmpl ',reg32(HR),',',reg32(NewReg) ] ],Code) ),
               NewReg in 0..3,
               Residue = [ '\n\t\t movl $0,',reg32(NewReg), % Residue as usual
                           '\n\t\t ',I,' ',reg8(NewReg) ]
         % third case, when left subexpr requires fewer regs than right
         ;  (  HL #\= HR, % happy case, result registers are different
                          % enforce register reuse
               permutation(TR,TRP), append(L,_,TRP),
               select(HL,R,Rest), Result = [HL|Rest],
               CodeOp = [ '\n\t\t cmpl ',reg32(HR),',',reg32(HL) ],
               % Result of right subexpr will be naturally untouched
               % during the computation of the left subexpr, because
               % of the register reuse constraint
               Code = [CR,CL,CodeOp],
               HL in 0..3,
               Residue = [ '\n\t\t movl $0,',reg32(HL), % residue as usual
                           '\n\t\t ',I,' ',reg8(HL) ]
             % less happy case, the two result registers are the same
             ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
               permutation(TR,TRP),
               (  append(TL,[NewReg|_],TRP),!,select(NewReg,TR,TRRest)
                ; TL = TRP, TRRest = TR ),
                          % NewReg is a new, 'unused' register, only if a 'used'
                          % one cannot be found. NewReg will be used to save
                          % the result of the right subexpr while the left one
                          % is being computed.
               Result = [HR,NewReg|TRRest]),
                          % Generated code obtained by laying out the right
                          % subexpr code, followed by a save of the result
                          % into the new register, followed by the left
                          % subexpr code, followed by the computation of
                          % the current operator --> result left in flags
               append([  CR,
                          [ '\n\t\t movl ',reg32(HR),',',reg32(NewReg) ],
                          CL,
                          [ '\n\t\t cmpl ',reg32(NewReg),',',reg32(HL) ] ],Code) ),
               HL in 0..3,
               Residue = [ '\n\t\t movl $0,',reg32(HL),
                           '\n\t\t ',I,' ',reg8(HL) ] ),
               % enforce that all registers used in computing this expression be
               % distinct when subjected to labeling.
    all_distinct(Result).

combine_expr_code(L,R,Op,CL,CR,Code,[],Result) :-
                          % Both expressions require registers, and the operator
                          % is arithmetic. Here we would like to use as many common
                          % registers as possible, so as to minimize register use.
                          % Generating code for the subexpression that requires more
                          % registers first will lead to 1 register holding the
                          % subexpression result, and the remaining registers to
                          % be potentially reused in the code generation of the
                          % other subexpression. If both subexpressions require the
                          % same number of registers, then an extra register will be
                          % required.
    L = [HL|TL], R = [HR|TR], L ins 0..5, R ins 0..5, NewReg in 0..5,
    member((Op,I),[(+,addl),(-,subl),(*,imull),(/\,andl),(\/,orl)]),!,
    length(L,LgL), length(R,LgR),

    % first case, when both subexpressions require same no.
    % regs --> extra reg needed
    ( LgL #= LgR
            % happy case, the two result registers are different
      -> (  HL #\= HR,
                          % enforce register reuse by making the right reg list
                          % a subset of the left tail + extra reg (denoted by '_')
            permutation([_|TL],R), Result = [HL,HR|TR],
                          % current operation between the two result registers
            CodeOp = [ '\n\t\t ',I,' ',reg32(HR),',',reg32(HL) ],
                          % Generated code made up of the left subexpression code,
                          % followed by right subexpression code, followed by
                          % current operator code.
            Code = [CL,CR,CodeOp]

            % less happy case, the two result registers are the same
            % this can only happen if the top-level operators of the left
            % and right subexpressions are both division or both remainder
            % extra register is needed to save right result
          ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
                          % enforce register reuse, as above
            permutation(TL,TR), Result = [NewReg,HL|TL], NewReg in 0..5,
                          % Generated code obtained by laying out
                          % the left subexpr code, followed by saving
                          % the result from either %eax or %edx into
                          % a new register, followed by the code for
                          % right subexpr, followed by instruction that
                          % performs the current operator between the
                          % result of right subexpr, and the result
                          % of left subexpr saved in NewReg. The overall
                          % result is kept in NewReg.
            append([  CL,
                       [ '\n\t\t movl ',reg32(HL),',',reg32(NewReg) ],
                       CR,
                       [ '\n\t\t ',I,' ',reg32(HR),',',reg32(NewReg) ] ],Code)
                  )
      % second case, when right subexpr requires fewer regs than left
      % no new register needed; lay out code for left subexpr first, then for right
      ;  LgR #< LgL
         -> (  HL #\= HR, % happy case, result registers different
                          % permutation constraint ensures register reuse, as above
               permutation(TL,TLP), append(R,_,TLP), Result = L,
               CodeOp = [ '\n\t\t ',I,' ',reg32(HR),',',reg32(HL) ],
               Code = [CL,CR,CodeOp]

             % less happy case, the two result registers are the same
             % this can only happen if the top-level operators of the left
             % and right subexpressions are both division or both remainder
             % extra register may be needed to save right result, when
             % len(Left) = len(Right)+1
             ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
                          % Enforce register reuse, as above
               permutation(TL,TLP),
               (  append(TR,[NewReg|_],TLP),!,select(NewReg,TL,TLRest)
                ; TR = TLP, TLRest = TL ),
                          % NewReg will be a new, 'unused' register, if
                          % a 'used' one cannot be found.
               Result = [NewReg,HL|TLRest],
                          % NewReg used to save left subexpr result while
                          % the right subexrp is computed. NewReg also holds
                          % final result
               append([  CL,
                          [ '\n\t\t movl ',reg32(HL),',',reg32(NewReg) ],
                          CR,
                          [ '\n\t\t ',I,' ',reg32(HR),',',reg32(NewReg) ] ],Code)
                )
         % third case, when left subexpr requires fewer regs than right
         ;  (  HL #\= HR, % happy case, result registers are different
                          % enforce register reuse
               permutation(TR,TRP), append(L,_,TRP),
               select(HL,R,Rest), Result = [HL|Rest],
               CodeOp = [ '\n\t\t ',I,' ',reg32(HR),',',reg32(HL) ],
               % Result of right subexpr will be naturally untouched
               % during the computation of the left subexpr, because
               % of the register reuse constraint
               Code = [CR,CL,CodeOp]
             % less happy case, the two result registers are the same
             ; (HL #= 0 ; HL #=1), ( HR #= 0 ; HR #= 1 ),
               permutation(TR,TRP),
               (  append(TL,[NewReg|_],TRP),!,select(NewReg,TR,TRRest)
                ; TL = TRP, TRRest = TR ),
                          % NewReg is a new, 'unused' register, only if a 'used'
                          % one cannot be found. NewReg will be used to save
                          % the result of the right subexpr while the left one
                          % is being computed.
               Result = [HR,NewReg|TRRest]),
                          % Generated code obtained by laying out the right
                          % subexpr code, followed by a save of the result
                          % into the new register, followed by the left
                          % subexpr code, followed by the computation of
                          % the current operator
               append([  CR,
                          [ '\n\t\t movl ',reg32(HR),',',reg32(NewReg) ],
                          CL,
                          [ '\n\t\t ',I,' ',reg32(NewReg),',',reg32(HL) ] ],Code)
               ),
    all_distinct(Result).

combine_expr_code(L,R,Op,CL,CR,Code,[],Result) :-
                          % Both expressions require registers, and the operator
                          % is either division or remainder. Code generation is
                          % similar to the rule above, yet slightly
                          % more difficult due to the fact that the result of
                          % the left subexpression must end up in %eax
    L = [HL|TL], R = [HR|TR], L ins 0..5, R ins 0..5, NewReg in 0..5,
    member((Op,I),[(/,idivl),(rem,idivl)]),!,
    length(L,LgL), length(R,LgR),
    % first case, left and right subexpressions require same no of regs
    ( LgL #= LgR
            % Enforce that left subexpr places result in %eax (preferred)
            % or in %edx (cannot be avoided if left top level opr is remainder)
            % happy case is that right subexpr puts result somewhere else
      -> (  ( HL #= 0 ; HL #= 1), HR #\= 0, HR #\= 1,
            Other #= 1 - HL,
            % enforce reuse of registers, and the use of %eax and %edx
            % in the right subexpr
            permutation([_|TR],L),
            (  select(0,R,R1), select(1,R1,R2)
             ; select(0,R,R2)
             ; select(1,R,R2)
             ; R2 = R ),
            (  Op == / ->  Result = [0,1|R2] ; Result = [1,0|R2] ),
            CodeOp = [ '\n\t\t movl ',reg32(HL),',',reg32(Other),
                       '\n\t\t shrl $31,',reg32(1),
                       '\n\t\t ',I,' ',reg32(HR) ],
            % lay out the right subexpr code first (using %eax and %edx for
            % temporary results if possible), and then left subexpr code,
            % and then place the division code
            Code = [CR,CL,CodeOp]
            % Enforce that left subexpr places result in %eax (preferred)
            % or in %edx (cannot be avoided if left top level opr is remainder)
            % less happy case -> right subexpr places result in same register
            % An extra register is needed here to save result of right subexpr
          ; ( HL #= 0 #\/ HL #= 1 ), ( HR #= 0 #\/ HR #= 1 ),
            OtherL #= 1-HL,
            % enforce register reuse, and try reusing %eax and %edx in right subexpr
            permutation(L,R),
            (  select(0,R,R1), select(1,R1,R2)
             ; select(0,R,R2)
             ; select(1,R,R2)
             ; R2 = R ),
            % register order depends on operator
            (    Op == /
             ->  Result = [0,1,NewReg|R2]   % %eax, then %edx
             ;   Result = [1,0,NewReg|R2] ),% %edx, then %eax
            % Lay out resulting code with code for right subexpr first,
            % then save right result into new register, then copy
            % %eax into %edx or viceversa, and then sign extend %edx,
            % and then perform the division/remainder between %eax and
            % new register
            append([  CR,
                       [ '\n\t\t movl ',reg32(HR),',',reg32(NewReg) ],
                       CL,
                       [ '\n\t\t movl ',reg32(HL),',',reg32(OtherL),
                         '\n\t\t shrl $31,',reg32(1),
                         '\n\t\t ',I,' ',reg32(NewReg) ] ],Code) )
            )
      % second case, left subexpr requires more registers than left one
      ;  LgR #< LgL
               % Enforce result of left subexpr be available in either %eax or %edx
         -> (  ( HL #= 0 #\/ HL #= 1 ),
               OtherL #= 1 - HL,
               % Compute Save and Restore codes that may be inserted between
               % codes for left and right subexpressions to preserve partial
               % results
               % enforce register reuse
               permutation(L,LP),
               ( member(HL,R) % if reg of left result used in code of right subexpr
                              % (may be unavoidable due to / or rem)
                 -> (  append(R,[NewReg|_],LP),!,select(NewReg,TL,TLRest)
                              % right registers subset of left registers
                     ; R = LP, TLRest = TL ),
                              % find used or new register to save left result
                    ( select(OtherL,TLRest,TLRest2) ; TLRest2 = TLRest ),
                    ( (Op == /) % NewReg can be used to save result of left opd
                      ->  Result = [0,1,NewReg|TLRest2]
                      ;   Result = [1,0,NewReg|TLRest2] ),
                    % the save code saves partial result into new register
                    Save = [ '\n\t\t movl ',reg32(HL),',',reg32(NewReg) ],
                    ( HR #= 0     % right result in %eax
                      -> Restore = [ '\n\t\t xchg ',reg32(0),',',reg32(NewReg) ]
                      ;  HR #= 1  % right result in %edx
                                  % The corresponding restore code:
                         -> Restore = [ '\n\t\t movl ',reg32(NewReg),',',reg32(0),
                                        '\n\t\t movl ',reg32(1),',',reg32(NewReg) ]
                          ; Restore = [ '\n\t\t movl ',reg32(NewReg),',',reg32(0) ])
                 ;  append(R,_,LP), % reg of left result not used in code of
                                    % right subexpr --> nothing to save/restore
                    (select(OtherL,TL,TL2) ; TL2 = TL ),
                                    % make sure both %eax and %edx reused in
                                    % code of left subexpr
                    ( Op == /
                      ->  Result = [0,1|TL2]
                      ;   Result = [1,0|TL2] ),
                    Save = [], Restore = [] ), % nothing to save/restore
               ( ( HR #= 0 #\/ HR #= 1 )
                                    % repeat the test on where the right
                                    % subexpression result is stored to
                                    % generate the correct code for current operator
                 -> CodeOp = [ '\n\t\t movl ',reg32(0),',',reg32(1),
                               '\n\t\t shrl $31,',reg32(1),
                               '\n\t\t ',I,' ',reg32(NewReg) ]
                 ;  CodeOp = [ '\n\t\t movl ',reg32(0),',',reg32(1),
                               '\n\t\t shrl $31,',reg32(1),
                               '\n\t\t ',I,' ',reg32(HR) ] ),
               Code = [CL,Save,CR,Restore,CodeOp] )
         % Third case, when right subexpr requires more registers than the left one
         % Here we lay out the code for right subexpr first, and we constrain
         % the result of left subexpr to be stored in %eax or %edx
         % We also constrain %eax and %edx to be reused in computation
         % of right subexpr, if possible. We also try to constrain the right
         % result register to not be used in the computation of left subexpr; if
         % that is not possible, then we save right result register into a
         % new register
         ;  (  ( HL #= 0 #\/ HL #= 1 ),
               OtherL #= 1 - HL,
               % Enforce register reuse
               permutation(R,RP),
               append(L,[NewReg|_],RP),select(NewReg,R,RRest),
               (  select(0,RRest,RR1),select(1,RR1,RR2)
                ; select(0,RRest,RR2)
                ; select(1,RRest,RR2)
                ; RR2 = RRest ),
               (  notmember(HR,L), % if true, no need to save right register
                  Save = [],
                  CodeOp = [ '\n\t\t movl ',reg32(HL),',',reg32(OtherL),
                             '\n\t\t shrl $31,',reg32(1),
                             '\n\t\t ',I,' ',reg32(HR) ] ,
                  ( Op == /
                    ->  Result = [0,1|RR2]
                    ;   Result = [1,0|RR2] )
                  % if member(HR,L), then need to find new register, and save
                ; Save = [ '\n\t\t movl ',reg32(HR),',',reg32(NewReg) ],
                  CodeOp = [ '\n\t\t movl ',reg32(HL),',',reg32(OtherL),
                             '\n\t\t shrl $31,',reg32(1),
                             '\n\t\t ',I,' ',reg32(NewReg) ] ),
                  ( Op == /
                    ->  Result = [0,1,NewReg|RR2]
                    ;   Result = [1,0,NewReg|RR2] ) ),
                 % There's no need to restore here, since %eax/%edx store result
               Code = [CR,Save,CL,CodeOp] ),
    all_distinct(Result). % make sure all registers are distinct at labeling time.

% predicate to check for lack of membership
% unlike \+ member(...), it does not fail when
% unbound variables are used
notmember(_,[]).
notmember(X,[Y|T]) :- X \== Y, notmember(X,T).


/************************************************************************
	The compiler for statements and expressions starts here. Treat the
	code above this	line as a black box. You will not be required to
	understand or modify that code.
*************************************************************************/


% Compiler of expressions
%  1st arg : program fragment to be translated
%  2nd arg : generated code for arg 1
%  3rd arg : attributes in
%  4th arg : attributes out
%  Relevant attribute: context -- may have one of the following values:
%     -	expr : causes generation of code as if the current expression
%              is a subexpression of a bigger expression
%			   Eg: current expr is (x+y), and is part of (x+y)/z
%                  The result will be available as 32 bit entity:
%				   reg/mem/con
%	  - stmt : causes generation of code as if the current expression
%	           is the boolean condition in an 'if' or 'while' statement
%	           The final instruction of generated code compares the
%	           result of expression with 0, and flags are set, so that
%	           a jump can be generated for efficient selection of next
%	           instruction
%
% IMPORTANT: The first rule, pertaining to evaluation of variables,
%            might change as we add procedures and nested procedures
%            The rest of the 'ce' rules should not need to change in
%            the future.
ce(X,Code,Ain,Aout) :- % generate code for variable
    atom(X),!,

    % retrieve memory reference for variable X
    get_assoc(local_vars,Ain,Locals),
    get_assoc(global_vars,Ain,Globals),
    (	member((X,Ref),Locals)
     ;	member(X,Globals), Ref = X
     ;	writeln('Encountered undeclared variable'), abort),!,

    put_assoc(expr_result,Ain,id(Ref),Aout),
                       % check context
    get_assoc(context,Ain,Ctx),
    (   Ctx = expr
     -> Code = []      % empty code in expression context
     ;  Code = [ '\n\t\t cmpl ',Ref,',$0' ] ).
                       % comparison code in 'if' or 'while' condition

ce(N,Code,Ain,Aout) :- % generate code for an integer
    integer(N),!,
    get_assoc(context,Ain,Ctx),
    (   Ctx = expr
     -> put_assoc(expr_result,Ain,const(N),Aout),
        Code = [] % nothing to generate in expression context
     ;  put_assoc(expr_result,Ain,[0],Aout),
                  % code for the case where N appears in an 'if' or 'while' cond
        Code = [ '\n\t\t movl $',N,',%eax',
                 '\n\t\t cmpl %eax,$0' ] ).

ce(E,Code,Ain,Aout) :- % generate code for binary operator
    E =.. [Op,EL,ER],!,
    put_assoc(context,Ain,expr,A0), % request expression context
    ce(EL,CodeL,A0,A1),             % recursively compile left subexpr
    ce(ER,CodeR,A1,A2),             % recursively compile right subexpr
    get_assoc(expr_result,A1,ERL),  % combine the codes and registers
    get_assoc(expr_result,A2,ERR),  % getting code C, Residue, and regs in Result
    combine_expr_code(ERL,ERR,Op,CodeL,CodeR,C,Residue,Result),
    get_assoc(context,Ain,Ctx),
    (   Ctx == expr                 % Figure out if residual code needs to be
     -> append([C,Residue],Code)      % appended to currently generated code
     ;  (   notmember(Op,[<,=<,==,\=,>=,>])
         -> ( Result = [Temp|_],R = reg32(Temp) ; Result = id(R) ),
            append(C,['\n\t\t cmpl ',R,',$0'],Code)
         ;  Code = C ) ),
    put_assoc(expr_result,A2,Result,Aout).

ce(E,Code,Ain,Aout) :- % generate code for unary operator
    E =.. [Op,Es],!,   % can be either unary minus, or logical negation
    put_assoc(context,Ain,expr,A0),
    ce(Es,CodeS,A0,A1), % recursively compile argument of unary operator
    get_assoc(expr_result,A1,Regs),
    (   Op = (-)  % unary minus
     -> (   Regs = const(N)
         -> N1 #= (-N), Code = [], RegsOut = const(N1)
         ;  (   Regs = id(X)
             -> RegsOut = [NewReg],
                CodeOp = [ '\n\t\t movl ',X,',',reg32(NewReg),
                           '\n\t\t negl ',reg32(NewReg) ],
                Residue = []
             ;  Regs = [R|_], RegsOut = Regs,
                CodeOp = [ '\n\t\t negl ',reg32(R) ],
                Residue = [] ) )
     ;  (   Op = (\) % logical negation
         -> (   Regs = const(N)
             -> N1 #<==> (N #= 0) , Code = [], RegsOut = const(N1)
             ;  (   Regs = id(X)
                 -> RegsOut = [NewReg], NewReg in 0..3,
                    CodeOp = [ '\n\t\t movl ',X,',',reg32(NewReg),
                               '\n\t\t cmpl ',reg32(NewReg),',$0'],
                    Residue = [ '\n\t\t movl $0,',reg32(NewReg),
                                '\n\t\t sete ',reg8(NewReg)]
                 ;  Regs = [R|_], RegsOut = Regs, R in 0..3,
                    CodeOp =  [ '\n\t\t cmpl ',reg32(R),',$0' ],
                    Residue = [ '\n\t\t movl $0,',reg32(R),
                                '\n\t\t sete ',reg8(R) ] ) )
         ;  RegsOut = Regs, CodeOp = [] ) ),
    get_assoc(context,Ain,Ctx),
    (   Ctx == expr % Figure out if residual code needs to be appended
     -> append([CodeS,CodeOp,Residue],Code)
     ;  (   notmember(Op,[<,=<,==,\=,>=,>])
         -> ( RegsOut = [Temp|_],R = reg32(Temp) ; RegsOut = id(R) ),
            Code = [CodeS,CodeOp,['\n\t\t cmpl ',R,',$0']]
         ;  Code = [CodeS,CodeOp] ) ),
    put_assoc(expr_result,A1,RegsOut,Aout).

/*********************************
	Compile expression wrapper
	-- call this to generate code for an expression
	-- remember to set attribute 'context' first
**********************************/
% -- same arguments as 'ce'
% -- calls label(...) to perform the actual numeric allocation
% -- run 'replace_regs' to replace 'reg32(X)' constructs by the normal
%    register names
% -- result in CER is assembly language code that evaluates expr E
comp_expr(E,CER,Ain,Aout) :-
    ce(E,CE,Ain,Aout),
    get_assoc(expr_result,Aout,Result),
    (  Result = [_|_], Result ins 0..5, label(Result) ; true ),
    replace_regs(CE,CER).

% Process global variable declarations
% Each variable is added to a list stored in the attribute global_vars
% Each reference to an identifier will be checked to have been declared
% in either the global or local variable list.
global_vars((VH,VT),Ain,Aout) :-
	get_assoc(global_vars,Ain,VS,A0,[VH|VS]),
	notmember(VH,VS),!,
	global_vars(VT,A0,Aout).
global_vars(V,Ain,Aout) :-
	V =.. L, L \= [_,_|_],
	get_assoc(global_vars,Ain,VS,Aout,[V|VS]),
	notmember(V,VS),!.

local_vars_helper(V,Ain,Aout) :-
	% allocate space on the stack for a local variable
	% TopIn indexes the most recently allocated variable, so
	% the current variable will be stored at TopIn+4 (downwards from %ebp)
	% Store the maximum amount of space allocated so far in max_local_vars,
	% so as to be able to allocate space conservatively at the start of the program
	get_assoc(top_local_vars,Ain,TopIn,A0,TopOut),
	get_assoc(max_local_vars,A0,MaxIn,A1,MaxOut),
	get_assoc(local_vars,A1,VS,Aout,[(V,Ref)|VS]),
	TopOut #= TopIn + 4, atomic_list_concat([-,TopOut,'(%ebp)'],Ref),
	MaxOut #= max(MaxIn,TopOut).

% Process local variable declarations. Each variable is allocated
% on the stack, and translated into a memory reference of the form
%  -N(%ebp), where N must be a constant. Every reference to an
% identifier will be searched first in the list of local vars, and
% then in the list of global vars. For local vars, the identifier
% will be translated into the corresponding ebp-based memory reference.
local_vars((VH,VT),Ain,Aout) :- !,
	local_vars_helper(VH,Ain,Aaux),
	local_vars(VT,Aaux,Aout).
local_vars(V,Ain,Aout) :- !,
	V =.. L, L \= [_,_|_],
	local_vars_helper(V,Ain,Aout).

% Compile statement -- implements while language

cs((global VL ; S),Code,Ain,Aout) :-!,
	            % Process global variable declarations,
				% then compile S as usual
	global_vars(VL,Ain,A0),
	cs(S,Code,A0,Aout).

cs({local VL ; S},Code,Ain,Aout) :- !,
		    % Preserve the original attribute, and restore at end of block
	get_assoc(local_vars,Ain,OriginalLocalVars),
	get_assoc(top_local_vars,Ain,OriginalTopLocalVars),
		    % Process local variable declarations at top of block
	local_vars(VL,Ain,A0),
	        % compile the rest of the statements
	cs(S,Code,A0,A1),
	        % restore original list of local variables, and allocation space
	put_assoc(local_vars,A1,OriginalLocalVars,A2),
	put_assoc(top_local_vars,A2,OriginalTopLocalVars,Aout).

cs(break, Code,A,A):- !,
	        % Generate a label name, and generate a jump to that label
    get_assoc(loop_end_lbl,A,Loop_end_lbl),
	Code = [ '\n\t\t jmp ',Loop_end_lbl ].

cs(continue, Code,A,A) :- !,
	get_assoc(loop_start_lbl,A,Loop_start_lbl),
	Code = [ '\n\t\t jmp ',Loop_start_lbl ].

cs((X=E),Code,Ain,Aout) :- !, atom(X), % assignment
    put_assoc(context,Ain,expr,A1),    % request expression context
    comp_expr(E,CE,A1,Aout),             % compile right hand side

    % retrieve memory reference for variable X
    get_assoc(local_vars,Ain,Locals),
    get_assoc(global_vars,Ain,Globals),
    (	member((X,Ref),Locals)
     ;	member(X,Globals), Ref = X
     ;	writeln('Encountered undeclared variable'), abort),!,

    % Check where the result of rhs is stored, and transfer it into
    % storage of variable X
    get_assoc(expr_result,Aout,Result),
    (    Result = const(N) % if result is constant, load it into Ref
     ->  Cop = [ '\n\t\t movl $',N,',',Ref ]
     ;   (   Result = id(Y) % if result is a var, transfer value into Ref via %eax
          -> Cop = [ '\n\t\t movl ',Y,',%eax',
                     '\n\t\t movl %eax,',Ref ]
          ;  Result = [Reg|_],      % if result is in Reg, retrieve Reg's name
             member((Reg,RegName),  % and store Reg into Ref
                    [ (0,'%eax'),(1,'%edx'),(2,'%ecx'),
                      (3,'%ebx'),(4,'%esi'),(5,'%edi')]),!,
             Cop = [ '\n\t\t movl ',RegName,',',Ref ] ) ),
    Code = [CE,Cop].

cs((if B then { S1 } else { S2 }), Code,Ain,Aout) :- !,
                            % For if-then-else statement, compile boolean
                            % condition first. Set context to 'stmt', so that
                            % residual code is not used.
    put_assoc(context,Ain,stmt,A1),
    comp_expr(B,CB,A1,A2),
                            % The result is in the flags, and the appropriate
                            % jump instruction must be used to select
    B =.. [Op|_],           % between 'then' and 'else' branches
    (   member((Op,I),[(<,jl),(=<,jle),(==,je),(\=,jne),(>,jg),(>=,jge)])
     -> true
     ;  I = jne ),          % code for 'then' branch appears below code for 'else'
    COpB = [ '\n\t\t ',I,' ',Lthen ],
    cs({S2},C2,A2,A3),      % generate code for 'else', and jump to skip the 'then'
    atomic_list_concat(['\n',Lthen,':'],LblThenStart),
    Cif1 = [ '\n\t\t jmp ',Lifend,LblThenStart ],
                            % label for 'then' branch is 'Lthen:'
    cs({S1},C1,A3,A4),      % generate code for 'then' branch

    atomic_list_concat([ '\n',Lifend,':' ],Cif2),
                            % 'Lifend:' is the label at end of 'if',
                            % target of jump placed after 'else'
    get_assoc(labelsuffix,A4,Kin,Aout,Kout),
    generateLabels([Lthen,Lifend],Kin,Kout),
                            % generate concrete labels for label placeholders
                            % and lay out the code
    Code = [CB,COpB,C2,Cif1,C1,Cif2].

cs((if B then { S }), Code,Ain,Aout) :- !,
                            % Code for 'if-then', similar to the one above.
    put_assoc(context,Ain,stmt,A1),
    comp_expr(B,CB,A1,A2),
    B =.. [Op|_],           % The condition of the jump must now be negated
    (   member((Op,I),[(<,jge),(=<,jg),(==,jne),(\=,je),(>,jle),(>=,jl)])
     -> true
     ;  I = je ),
    COpB = [ '\n\t\t ',I,' ',Lifend ],
    cs({S},C,A2,A3),
    atomic_list_concat([ '\n',Lifend,':' ],Cif),
    get_assoc(labelsuffix,A3,Kin,Aout,Kout),
    generateLabels([Lifend],Kin,Kout),
    Code = [CB,COpB,C,Cif].

cs((while B do { S }), Code,Ain,Aout) :- !,

    get_assoc(unroll_num,Ain,UnrollNum),
    get_assoc(loop_start_lbl,Ain,LoopStart),
    get_assoc(loop_end_lbl,Ain,LoopEnd),

    (   get_assoc(unroll_cnt,Ain,UnrollCnt) -> true ; UnrollCnt = 0), % load unroll count
    put_assoc(unroll_cnt,Ain,NewUnrollCnt,A0),NewUnrollCnt is UnrollCnt + 1,

    (   (   UnrollCnt = 0,!,    % just do initialization
        
            % generate labels for the Start and End of the loop
            get_assoc(labelsuffix,A0,L1In,A1,L1Out),
            generateLabels([NewLoopStart,NewLoopEnd],L1In,L1Out),
            put_assoc(loop_start_lbl,A1,NewLoopStart,A2),
            put_assoc(loop_end_lbl,A2,NewLoopEnd,A3),

            % compile B code, and save it to A
            put_assoc(context,A3,stmt,A4),
                                    % Generate code for boolean condition, in
                                    % 'stmt' context so that residual code is not used.
            comp_expr(B,CB,A4,A5),  % Results will be in the flags
            B =.. [Op|_],           % Appropriate conditional jump must be selected
            (   member((Op,I),[(<,jge),(=<,jg),(==,jne),(\=,je),(>,jle),(>=,jl)])
             -> true
             ;  I = je ),
            COpB = ['\n\t\t ',I,' ',NewLoopEnd],    
            BCode = [CB,COpB],
                                     % compiling S once only ensures that the local variables are generated once only

            put_assoc(unroll_compiled_code,A5,(BCode,SCode),A6), % save the compiled template
            
            (   UnrollNum = 0
            ->  RestCode = [BCode,SCode],
                A7 = A6
            ;   cs((while B do { S }), RestCode,A6,A7)  % after initialization, go to later phase and unroll the code for while loop.
            ),
            atomic_list_concat(['\n',NewLoopStart,':'],StartLabel),
            atomic_list_concat(['\n',NewLoopEnd,':'],EndLabel),
            Code = [ StartLabel,
                     RestCode,
                     ['\n\t\t jmp ',NewLoopStart],
                     EndLabel
                   ]
        );
        (   UnrollCnt < UnrollNum,!,
            get_assoc(unroll_compiled_code,A0,(BCode,SCode)), % get the compiled code, and copy over the unbounded start/end tag variables

            CurrentCode = [BCode,SCode],
            cs((while B do { S }),CodeRest,A0,A1),
            Code = [CurrentCode,CodeRest],
            A7 = A1
        );
        (   UnrollCnt = UnrollNum,!,
            get_assoc(unroll_compiled_code,A0,(BCode,SCode)), % get the compiled code, and copy over the unbounded start/end tag variables

            Code = [BCode,SCode],
            A7 = A0
        )
    ),
    (   UnrollCnt = UnrollNum
    ->  put_assoc(unroll_cnt,A7,0,A8),  % reset the unroll cnt in the end
        get_assoc(unroll_compiled_code,A8,(_,SCode)),   % SCode is still unbounded.
        cs({S},SCode,A8,A9)     % Generate code for body here, so that internal while wouldn't be affected.
    ;   A9 = A7),

    put_assoc(loop_start_lbl,A9,LoopStart,A10),
    put_assoc(loop_end_lbl,A10,LoopEnd,Aout).

cs((for (X1=E1;B;X2=E2) do { S }), Code,Ain,Aout) :- !,
    get_assoc(loop_start_lbl,Ain,OldLoopStart,A0,NewLoopStart),
    get_assoc(loop_end_lbl,A0,OldLoopEnd,A1,NewLoopEnd),
	                                 % Handle 'break' and 'continue' attrs similar to 'while' rule
	cs(X1=E1,CInit,A1,A2),              % compile first assignment
    atomic_list_concat(['\n',NewLoopStart,':'],LblLoopStart),
    CLoopNeck = [ '\n\t\tjmp ',NewLoopMain,LblLoopStart], % Generate 'top-of-loop' label
	cs(X2=E2,CUpdate,A2,A3),              % Compile updating assignment
	put_assoc(context,A3,stmt,A4),   % Compile boolean condition in statement context
    atomic_list_concat(['\n',NewLoopMain,':'],CLblMain),
    comp_expr(B,CB,A4,A5),
    B =.. [Op|_],                    % select the correct jump instruction after boolean condition evaluation
    (   member((Op,I),[(<,jge),(=<,jg),(==,jne),(\=,je),(>,jle),(>=,jl)])
     -> true
     ;  I = je ),                    % generate jump code, to 'out-of-loop' label
    COpB = [ '\n\t\t ',I,' ',NewLoopEnd ],
    cs(S,CS,A5,A6),                  % compile body of for loop
    atomic_list_concat(['\n',NewLoopEnd,':'],LblLoopEnd),
	CLoopFoot = [ '\n\t\t jmp ',NewLoopStart,      % Generate jump to top of loop, to repeat the loop
                  LblLoopEnd],       % Generate 'out-of-loop' label placeholder
    get_assoc(labelsuffix,A6,Kin,A7,Kout),
    generateLabels([NewLoopStart,NewLoopMain,NewLoopEnd],Kin,Kout),
	                                 % Fill placeholders with concrete label names
    put_assoc(loop_start_lbl,A7,OldLoopStart,A8),
    put_assoc(loop_end_lbl,A8,OldLoopEnd,Aout),

    Code = [CInit,CLoopNeck,CUpdate,CLblMain,CB,COpB,CS,CLoopFoot].
                                     % Lay out the code.

cs((N::{S} ; Rest),Code,Ain,Aout) :- !,
	                                 % Compilation of the arms of a 'switch' statement
									 % It compiles the arm N::{S} first, and recursively invokes
									 % the compiler for the remaining arms.
    get_assoc(case_table_labels,Ain,(VL,LL),A1,([N|VL],[L|LL])),
									 % Create a new label placeholder and associate it to case label N
									 % Add the association to the case table labels attribute.
    atomic_list_concat([ '\n',L,':' ],Ccase1),         % Generate code with label placeholder for current arm
    cs({S},CS,A1,A2),				 % Compile statement S
    get_assoc(label_case_end,A2,Lend),
	                                 % Retrieve 'end-of-switch' label
    Ccase2 = [ '\n\t\t jmp ',Lend ], % Generate jump to 'end-of-switch' label so as to implement the
	                                 % invisible break.
    cs(Rest,CodeRest,A2,Aout),		 % Recursively compile the remaining arms
    Code = [Ccase1,CS,Ccase2,CodeRest].
                                     % Lay out the entire code.

cs((default::{S}),Code,Ain,Aout) :- !,
	                                 % Last arm of 'switch' is 'default' arm
    get_assoc(case_table_labels,Ain,(VL,LL),A1,([default|VL],[L|LL])),
	                                 % Create new label placeholder and associate it with 'default' case label
    atomic_list_concat([ '\n',L,':' ],Ccase1),   % Generate code with new label placeholder
    cs({S},CS,A1,Aout),              % Compile body of 'default' arm
    Code = [Ccase1,CS].       % Lay out the entire code.

cs(switch E of { CaseList },Code,Ain,Aout) :-
	                                 % Compilation of 'switch' statements
    get_assoc(label_case_end,Ain,OldCaseLabel,A0,Lcaseend),
									 % Generate new 'out-of-switch-statement' label placeholder
									 % and place it in the attribute set, so it can be accessed
									 % by the cs(N::{S} ; ... ) rule given above
									 % Also, save the original value of this attribute, so it
									 % it can be restored later
    get_assoc(case_table_labels,A0,OldCaseTableLabels,A1,([],[])),
	                                 % Initialize the table of case labels, and store it in the attribute set
									 % Again, save the old value so it can be restored later
    put_assoc(context,A1,expr,A2),
    comp_expr(E,CE,A2,A3),			 % compile E in expr context
    get_assoc(expr_result,A3,RE),    % retrieve the result storage for E
    (    RE = [Reg|_]
     ->  Cop = [],
         member((Reg,X),
                [ (0,'%eax'),(1,'%edx'),(2,'%ecx'),
                  (3,'%ebx'),(4,'%esi'),(5,'%edi')]),!
     ;   (   RE = id(Y) ; RE = const(Y) ),!,
         Cop = [ '\n\t\t movl ',Y,',%eax' ], X = '%eax' ),
									 % Generate code to transfer result of E into %eax
    atomic_list_concat(['\n',Lcasetab,':'],LblLcaseTab),
                            % Generate indirect jump to arm code via the case table
    CJ = [ '\n\t\t jmp * ',Lcasetab,'(,',X,',4)',LblLcaseTab],
		                             % Generate label placeholder destined to hold the base address of
									 % case table
    get_assoc(labelsuffix,A3,Lin,A4,Lout),
    generateLabels([Lcasetab,Lcaseend],Lin,Lout),
	                                 % Generate concrete label names for the two placeholders
    cs(CaseList,CC,A4,A5),           % Recursively compile the case list; build a (list-based)
	                                 %   dictionary of (CaseLabel,AssemblyLabel) pairs
    casetable(CodeCaseTab,A5,A6),    % Build case-table, filled with labels pointing to arms ;
	                                 %   each entry corresponds to either an exisitng case label,
									 %   or to 'default', and the contents of the entry is filled
									 %	 accordingly with the assembly label associated with the
									 %   case label in the dictionary.

    % Generate code for 'out-of-switch-statement' label
    atomic_list_concat([ '\n',Lcaseend,':' ],CodeEnd),
    put_assoc(label_case_end,A6,OldCaseLabel,A7),
    put_assoc(case_table_labels,A7,OldCaseTableLabels,Aout),
	                                 % Restore original case label attribute values. Necessary for correct
									 % handling of nested switch statements.
    Code = [CE,Cop,CJ,CodeCaseTab,CC,CodeEnd].
                                     % Lay out the entire code

cs((S1;S2),Code,Ain,Aout) :- !, % statement sequence
    cs(S1,C1,Ain,Aaux),         % append generated code, thread attributes
    cs(S2,C2,Aaux,Aout),
    Code = [C1,C2].

cs((S;),Code,Ain,Aout) :- !, % statement terminated by semicolon
    cs(S,Code,Ain,Aout).     % compile S without semicolon

cs({S},Code,Ain,Aout) :- !, % statement enclosed in braces
    cs(S,Code,Ain,Aout).    % compile S without braces

% Generate the case table, after having processed all the case arms
% and having obtained the list of associations (CaseLabel,AssemblyLabel)
casetable(Code,Ain,Aout) :-
    get_assoc(case_table_labels,Ain,(CTV,CTL),A1,none),
							% get the association lists, and replace them with 'none' at the same time
    get_assoc(labelsuffix,A1,Lin,Aout,Lout),
    generateLabels(CTL,Lin,Lout),
	                        % The Assembly Labels are actually still unbound, so label names need to
							% be generated
    CTV = [default|CTVT], CTL = [DefaultLabel|CTLT],
	                        % The first label is 'default'. This will be used as a filler for all
							% entries that do not have a corresponding case label, so it's useful
							% to have it as a separate argument fed into the helper predicate.
    reverse(CTVT,VR), reverse(CTLT,LR),
	                        % The association lists have grown in reverse order, so we restore them
							% to the original label, as it appears in the list of case arms
    casetable_helper(VR,LR,CodeL,0,DefaultLabel),
	                        % All the work is done here. 0 is the first table entry to be processed
							% and this argument will increase throughout the recursive calls, to
							% allow iteration through all the table entries
    Code = CodeL.     % Lay out the entire code.

% Generate the case table, line by line. Case labels are restricted
% to values between 0-255, and thus the table will have only
% 256 labels. The first 2 arguments are expecte to have the same length
% Args:
%   1st : list of numeric case labels encountered in the list of
%		  case arms
%	2nd : list of assembly language labels, in the same order, so
%		  that elements of the same rank in the 1st and 2nd arg
%		  are associated with each other
%	3rd : List of assembly language lines (each in a separate list --
%	      so that the final result is a list of lists), each line
%         being a directive to reserve space for 1 table entry
%   4th : current table position, incremented by 1 at each
%         recursive call of the helper.
%	5th : Assembly language label corresponding to 'default'.
%	      Used to fill in location for which a case label was
%	      not provided.
casetable_helper([],[],[],256,_) :- !.
          % If we exhausted all the case labels, and reached the end of the array,
          % generate empty code in 3rd arg

casetable_helper([],[],[C|CT],N,DL) :-
	      % If we exhausted all the case labels, but not reached the end of
	      % the array, fill the current entry with 'default' label
    N < 256, !,
    C = [ '\n\t\t .long ',DL ],
    N1 #= N+1,
		  % move on to next position in the table
    casetable_helper([],[],CT,N1,DL).
          % recursive call to fill remaining positions in the table

casetable_helper([VH|VT],[LH|LT],[CH|CT],N,DL) :-
		  % if VH is the first unprocessed label, and yet the
	      % current table position is smaller than VH, then
		  % fill the current position with 'default' label
    N < VH, !,
    CH = [ '\n\t\t .long ',DL ],
    N1 #= N+1,
	      % move on to next position in the table
    casetable_helper([VH|VT],[LH|LT],CT,N1,DL).
          % recursive call to fill the remaining positions in the table.

casetable_helper([N|VT],[LH|LT],[CH|CT],N,DL) :-
		  % If the first unprocessed label is N, equal to
		  % the current table position, then fill the current entry
	      % with LH, the assembly language label associated to N
    CH = [ '\n\t\t .long ',LH ],
    N1 #= N+1,
	      % move on to next position
    casetable_helper(VT,LT,CT,N1,DL).
          % recursive call to fill the remaining positions in the table.

% Main predicate
%  1st arg : Program to be compiled
%  2nd arg : File for output
% The generated file has to be compiled together with runtime-stmt.c
% to produce a valid executable. Should work on Linux, Mac, and Cygwin.
compile(P,File,UnrollNum) :-
    tell(File),                              % open output file
	empty_assoc(Empty),                      % initialize attribute dict
	AUnrollNumIn = Empty,
    put_assoc(unroll_num,AUnrollNumIn,UnrollNum,AUnrollNumOut),
    AstartIn = AUnrollNumOut,
    put_assoc(loop_start_lbl,AstartIn,none,AstartOut),
	AendIn = AstartOut,                     % initial 'break' label is none
    put_assoc(loop_end_lbl,AendIn,none,AendOut),
    AcaseendIn = AendOut,                   % initial 'continue' label is none
	put_assoc(label_case_end,AcaseendIn,none,AcaseendOut),
    AcasetablelabelsIn = AcaseendOut,		 % initial case-end label is none
	put_assoc(case_table_labels,AcasetablelabelsIn,([],[]),AcasetablelabelsOut),
    AlabelsuffixIn = AcasetablelabelsOut,	 % initial table has no labels (empty lists)
	put_assoc(labelsuffix,AlabelsuffixIn,0,AlabelsuffixOut),
    AlocalvarsIn = AlabelsuffixOut,          % initialize label counter
	put_assoc(local_vars,AlocalvarsIn,[],AlocalvarsOut),
    AglobalvarsIn = AlocalvarsOut,           % initial local vars list is empty
	put_assoc(global_vars,AglobalvarsIn,[],AglobalvarsOut),
    AtoplocalIn = AglobalvarsOut,            % initial global vars list is empty
	put_assoc(top_local_vars,AtoplocalIn,0,AtoplocalOut),
    AmaxlocalIn = AtoplocalOut,              % current allocation size is 0
	put_assoc(max_local_vars,AmaxlocalIn,0,AmaxlocalOut),
											 % max allocation size is 0
    Ainit = AmaxlocalOut,
	cs(P,Code,Ainit,Aresult),!,				 % Compile program P into Code
	                                         %  -- Code is now a list of atoms
                                             %     that must be concatenated to get
                                             %     something printable

	get_assoc(max_local_vars,Aresult,Max),   % Retrieve the size of storage for local vars

	Pre = [ '\n\t\t .text',                  % Sandwich Code between Pre and Post
		'\n\t\t .globl _entry',              %  -- sets up compiled code as
		'\n_entry:',                         %     procedure 'start' that can be
	        '\n\t\t pushl %ebp',             %     called from runtime.c
		'\n\t\t movl %esp,%ebp',
		'\n\t\t subl $',Max,',%esp'],        % Subtract the size of storage from the stack register ;
											 % -- thus the space between %esp and %ebp is safe to use
											 %    even after we add procedure calls to the compiler

    Post = ['\n\t\t movl %ebp,%esp',         % Code to restore the original frame pointer and return
		'\n\t\t popl %ebp',                  % to runtime-stmt.c
		'\n\t\t ret'],

	All = [Pre,Code,Post],             % The actual sandwiching happens here
    atomic_list_recur_to_single_list(All,AllList),
    remove_duplicate_lbl(AllList,NewAllList),
    atomic_list_concat(NewAllList,AllWritable),     % Now concat and get writable atom
	writeln(AllWritable),                    % Print it into output file
	get_assoc(global_vars,Aresult,VarList),  % Create data declarations for all vars
	allocvars(VarList,VarCode,VarNames,VarPtrs),
	                                         % Code to allocate all global variables
	atomic_list_concat(VarCode,WritableVars),
											 % Compound the code into writable atom, for output into file
	write('\n\t\t .data\n\t\t .globl __var_area\n__var_area:\n'),
                                             % Write declarations to output file
	write(WritableVars),
	                                         % Create array of strings representing
                                             % global variable names, so that vars can
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
	                                         % Put null pointer at the end of array of string pointers,
											 % to indicate that the array has ended.
	told. % close output file

%  Various tests, with their assembly output; uncomment one-by-one and
%  compile with C-c C-b, the uncommented test will be automatically run.
%  The output will be placed into the file whose name is given as the
%  second arg of 'compile'.

/*
:- Program = (
         global a ;
		 a = 1 ;
		 { local b,c ;
		   b = a + 1 ;
		   c = a + b ;
		   { local d,e ;
			 d = 2*a + 3 ;
			 e = d - 1 ;
			 b = 2*e
		   } ;
		   { local f,g ;
			 f = b+c ;
			 g = f +1 ;
			 c = 2*g ;
		   } ;
		   a = b + c
		 }
			 ), compile(Program,'test0.s').
*/
/* The C equivalent should yield the same results
   DO NOT UNCOMMENT THIS

int main() {
		 a = 1 ;
		 { int b,c ;
		   b = a + 1 ;
		   c = a + b ;
		   { int d,e ;
			 d = 2*a + 3 ;
			 e = d - 1 ;
			 b = 2*e ;
		   }
		   { int f,g ;
			 f = b+c ;
			 g = f +1 ;
			 c = 2*g ;
		   }
		   a = b + c;
		 }
         printf("a=%d\n",a) ;
    return 0 ;
}

*/

/*
:- Program = (
     global i, gj, gc0, gc1, gc2, gc3 ;
     i = 1 ;
     while i < 100 do {
       local c0, c1, c2, c3 ;
       c0 = 0 ; c1 = 0 ; c2 = 0 ; c3 = 0 ;
       switch i rem 8 of {
         2:: { c1 = c1 + i } ;
         4:: { c2 = c2 + i/2 } ;
         6:: { if c2 \= c1
                 then { c3 = (c3+1)*c3 }
                 else { c3 = (c3-1)*c2 } } ;
         default :: {
	     local j ;
             j = 0 ;
             while j < i do {
               switch j of {
                 0 :: { if c0 >= 0 then { c0 = c0+1 } } ;
                 2 :: { c0 = c0 * c0 } ;
                 default :: { c0 = c0 + 2 ; }
               } ;
               j = j + 1
             } ;
	     gj = j ;
         }
       } ;
       i = i + 1 ;
       gc0 = c0 ; gc1 = c1 ; gc2 = c2 ; gc3 = c3
     }
			 ), compile(Program,'t1.s').
 */

/* The C equivalent should yield the same results
   DO NOT UNCOMMENT THIS

#include <stdio.h>
#include <stdlib.h>

int i, gj, gc0, gc1, gc2, gc3 ; ;

int main() {
     i = 1 ;
     while (i < 100) {
       int c0, c1, c2, c3 ;
       c0 = 0 ; c1 = 0 ; c2 = 0 ; c3 = 0 ;
       switch (i % 8) {
         case 2 : { c1 = c1 + i ; break ; }
         case 4 : { c2 = c2 + i/2 ; break ; }
         case 6 : { if (c2 != c1)
                       { c3 = (c3+1)*c3 ; }
                    else
                       { c3 = (c3-1)*c2 ; }
                   ; break ;
                  }
         default: {
	         int j ;
             j = 0 ;
             while (j < i) {
               switch (j) {
                 case 0 : { if (c0 >= 0) { c0 = c0+1 ; } } ; break ;
                 case 2 : { c0 = c0 * c0 ; }  ; break ;
                 default : { c0 = c0 + 2 ; } ; break ;
               }
               j = j + 1 ;
             }
	         gj = j ;
         }
         break ;
       }
       i = i + 1 ;
       gc0 = c0 ; gc1 = c1 ; gc2 = c2 ; gc3 = c3 ;
     }
     printf("i = %d\n",i);
     printf("gj = %d\n",gj);
     printf("gc0 = %d\n",gc0);
     printf("gc1 = %d\n",gc1);
     printf("gc2 = %d\n",gc2);
     printf("gc3 = %d\n",gc3);
     return 0 ;
}
*/

/*
:- Program = (
    global i,j;
    i = 1; j = 1;
    while ( i < 1000) do{
        local s; s = 1; i = i + 1; j = 0;
        while ( j < 1000) do{
            s = s + 1; j = j + 1;
        }
    }
), compile(Program,'t2.s',3).
*/

/*
:- Program = (
			 global i,s ;
			 s = 0 ;
			 for ( i = 0 ; i < 10 ; i = i + 1 ) do
			     { s = s + i ;
				   if s > 30 then { continue } ;
				   s = s*i ;
				 }
			 ), compile(Program,'test2.s').
*/

/* Equivalent C program
   DO NOT UNCOMMENT

#include <stdio.h>
#include <stdlib.h>

int i, s ;

int main() {
	s = 0 ;
	for ( i = 0 ; i < 10 ; i = i + 1 ) {
		s += i ;
		if ( s > 30 ) continue ;
		s = s*i ;
	}
    printf("i = %d\n",i);
    printf("s = %d\n",s);
}
*/




