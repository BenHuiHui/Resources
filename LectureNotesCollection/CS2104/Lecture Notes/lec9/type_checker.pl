/**********************************************************
 *  A typechecker for a simple functional language
 *  (C) cs2104-SoC-NUS, 2011
 **********************************************************/

/* Grammar of the language:
       Expression ::=  Variable
                     | true | false | 0 | 1 | -1 | 2 | -2 | ...
		     | Expression + Expression
		     | Expression - Expression
		     | Expression * Expression
		     | Expression / Expression
		     | Expression /\ Expression
		     | Expression \/ Expression
		     | \+ Expression		      (negation)
		     | Expression < Expression
		     | Expression <= Expression
		     | Expression > Expression
		     | Expression >= Expression
		     | Expression == Expression
		     | Expression \= Expression       (disequality)
		     | if Expression then Expression else Expression
		     | \ Variable -> Expression	      (functional abstraction)
		     | Variable = Expression          (recursive abstraction)
		     | Expression @ Expression        (function application)

Legal expressions:

\x -> x + 1         the function that increments its argument by 1

(\x -> x + 1) @ 3   Should evaluate to 4 (though this program only
                    performs typechecking (we cannot use an invisible
		    operator for function application, as we do in
		    Haskell, the operator has to be explicit, namely the
		    symbol '@')


fact =			       The factorial function can be defined
   (\x) ->		       as a recursive function
      if (x==0)                The scope of fact is restricted to
         then 1		       the function's definition and it's useful
	 else (x*fact@(x-1))   only to allow the self-call.
                               The type of this expression is int->int

( fact =                       The type of this expression is int.
   (\x) ->		       Should evaluate to 120.
      if (x==0)
      then 1
      else (x*fact@(x-1))
  @ 5 )                                                             */

/* Operator declarations (many of the operators are predefined) */
?- op(599,fx,if).
?- op(598,xfx,then).
?- op(597,xfx,else).
?- op(699,yfx,->).
?- op(100,yfx,@).
?- op(50,xfx,::). % to record types in environments

/* Compute the difference of 2 sets represented as lists */

diff([],L,L) :- !.  % remove the first element in the arg1 from arg2, and use the result to produce arg2, until an empty list reached, and arg3 is the return result.
  % it would fail when arg1 contains elments which is not in arg2
diff([H|T],L1,L2) :- select(H,L1,L3),!,diff(T,L3,L2).

/* "it": A predicate to infer the type of an expression.
   1st argument: the expression of interest
   2nd argument: the return argument, unified to the type of the; the
   rule | expression
   3rd argument: the type environment, implemented as a list, which
		 records the types of variables encountered so far.
   4th argument: A list of pre-defined constants
*/

/* Each rule of infer_type corresponds to a line in the grammar */

/* functional abstraction */
it(((\ X) -> Y), (TX->TY),L,P) :- !,
	% get the expression of x, get the type of y, produce the environment L1
	% P is always unchanged; Note: it seems that only function has return val
	it(X,TX,L1,P), it(Y,TY,L2,P),diff(L1,L2,L).
	% the "diff" here is to remove X from the environment
	% implicitly declare that the type of X to be the same as the type of X in  -->
	% besides of removing, it would also try to match the variable of x if it's not decided.
/* recursive abstraction */
it((F = E),T,L,P) :- !,
	it(E,T,L1,P),diff([(F::T)],L1,L).

/* function application */
it((E1 @ E2),T,L,P) :- !,
	it(E1,(T1->T),L1,P), it(E2,T1,L2,P),
	union(L1,L2,L).
/* Constants */
it(X,int,[],_) :- integer(X),!.
/* Predefined Symbol */
%it(X,T,[],P) :- copy_term(P,FreshP), member((X::T),FreshP),!.
it(X,T,[],P) :- member((X::T),P),!.
%TODO: find out the use of copy_term here.
/* variables -- T is a new type variable */
it(X,T,[X::T],_) :- atom(X),!.
/* if statement */
it((if B then X else Y),T,L,P) :- !,it((if)@B@X@Y,T,L,P).
/* Expressions */
it(E,T,L,P) :- E =.. [O,X,Y]
,!, it(O@X@Y,T,L,P).
it(E,T,L,P) :- E =.. [O,X],!, it(O@X,T,L,P).  % change it to the type of function-list expression


infertype(E,T) :-
	Predefined =
	   [ true :: bool,
	     false :: bool,
	     (+) :: ( int -> int -> int ),
	     (-) :: ( int -> int -> int ),
	     * :: ( int -> int -> int ),
	     / :: ( int -> int -> int ),
	     mod :: ( int -> int -> int ),
	     /\ :: ( bool -> bool -> bool ),
	     \/ :: ( bool -> bool -> bool ),
	     <  :: ( int -> int -> bool ),
	     =< :: ( int -> int -> bool ),
	     >  :: ( int -> int -> bool ),
	     >= :: ( int -> int -> bool ),
	     == :: ( X -> X -> bool ), % define these variables to create dummy names
	     \= :: ( Y -> Y -> bool ),
	     (if) :: ( bool -> Z -> Z -> Z ),
	     [] :: [_],
	     (:) :: (X1 -> [X1] -> [X1]),
	     head :: ( [X2] -> X2 ),
	     tail :: ( [X3] -> [X3] ) ],
	it(E,T,_,Predefined).


/*
% Example queries:

% Function composition
:- E = (\f-> \g -> \x->f@(g@x)),
	infertype(E,T),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
% T = ((_G637->_G629)-> (_G628->_G637)->_G628->_G629).

% Composition with identity
:- E = (\f -> \g -> \x->f@(g@x))@(\x->x),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
% T = ((_G685->_G686)->_G685->_G686).

% Composition with identity and doubling
:- E = (\f -> \g -> \x->f@(g@x))@(\x->x)@(\x->2*x),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
% T = (int->int).

% Factorial
:- E = (fact = (\x) -> if (x==0) then 1 else (x*fact@(x-1))),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
% T = int->int


% Map
:- E = (map = (\f) -> (\l) -> if (l == []) then [] else ((f@(head@l)):(map@f@(tail@l)))),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
% T = (_G6280->_G6419)->[_G6280]->[_G6419] .

% Foldl
:- E = (foldl = \f -> \i -> \l -> if (l == []) then i else foldl@f@(f@i@(head@l))@(tail@l)),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.

% Foldr
:- E = (foldr = \f -> \i -> \l -> if (l==[]) then i else f@(head@l)@(foldr@f@i@(tail@l))),
	infertype(E,T),
	term_variables(T,V), append(V,_,[a,b,c,d,e,f,g]),
	write('Expression:'),writeln(E),
	write('Type:'), writeln(T),nl.
*/
















