:- [library(clpfd)].

:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

/*
ve(X) :-
	term_to_atom(X,XA),
	atomic_list_concat(['in ve:',XA],Writable),
	writeln(Writable),fail.
*/
ve(X) :- integer(X),!.
ve(X) :- atom(X),!.
ve(E) :- E =.. [Op,A,B],
	member(Op,[+,-,*,/,rem,/\,\/,<,>,=<,>=,\=,==]),!,
	ve(A), ve(B).
ve(E) :- E =.. [Op,A],
	member(Op,[+,-,\]),!,ve(A).

vs(X=E) :- !, atom(X), ve(E).
vs(if E then { S1 } else { S2 }) :- !,ve(E), vs(S1), vs(S2).
vs(if E then { S }) :- !,ve(E), vs(S).
vs(while E do { S }) :- !,ve(E), vs(S).
vs(S1;S2) :- !,vs(S1), vs(S2).
vs(S;) :- !,vs(S).

eval(N,_,N) :- integer(N), !.
eval(X,Env,R) :- atom(X),!,get_assoc(X,Env,R).
eval(E,Env,R) :-
	E =.. [Op,A,B],
	member(Op,[+,-,*,/,rem,^]),!,
	eval(A,Env,RA), eval(B,Env,RB),
	Compute =.. [Op,RA,RB],
	R #= Compute.
eval(E,Env,R) :-
	E =.. [Op,A],
	member(Op,[+,-]),!,
	eval(A,Env,RA),
	Compute =.. [Op,RA],
	R #= Compute.
eval(E,Env,R) :-
	E =.. [Op,A,B],
	member(Op,[<,>,=<,>=,\=,==]),!,
	(   Op == (==) -> OpEv = (=) ; OpEv = Op ),
	eval(A,Env,RA), eval(B,Env,RB),
	atomic_concat('#',OpEv,HOp),
	Compute =.. [HOp,RA,RB],
        (   Compute -> R = 1 ; R = 0 ).
eval(E,Env,R) :-
	E =.. [Op,A],
	member(Op,[\]),!,
	eval(A,Env,RA),
	atomic_concat('#',Op,HOp),
	Compute =.. [HOp,RA],
        (   Compute -> R = 1 ; R = 0 ).

interp((X = Expr),Ein,Eout) :-
	atom(X),!,
	eval(Expr,Ein,R),
	put_assoc(X,Ein,R,Eout).

interp((S;),Ein,Eout) :- interp(S,Ein,Eout).

interp((S1;S2),Ein,Eout) :- interp(S1,Ein,Eaux), interp(S2,Eaux,Eout).

interp((if B then { S1 } else { S2 } ),Ein,Eout) :-
	eval(B,Ein,Bval),
	(   Bval #= 1
	->  interp(S1,Ein,Eout)
	;   interp(S2,Ein,Eout) ).

interp((if B then { S1 } ),Ein,Eout) :-
	eval(B,Ein,Bval),
	(   Bval #= 1
	->  interp(S1,Ein,Eout)
	;   Eout = Ein ).

interp((while B do { S }),Ein,Eout) :-
	interp(
	    (if B then {
		      S ;
		      while B do { S }
		  }
	    ),Ein,Eout).

get_var_values([],[],_).
get_var_values([X|XT],[V|VT],Assoc) :-
	get_assoc(X,Assoc,VX),
	term_to_atom((X=VX),V),
	get_var_values(XT,VT,Assoc).


get_var_lst(P,Ein,Eout):-
	P =.. [Op|Param],
	(   Op = (=), Param = [L,R],atom(L)
	% in the case of (=) would check if var
	% is in the env or not.
	% note that '=' is defined as left assoc in Prolog,
	% but it doesn't matter here.
	->  union([L],Ein,Eaux),get_var_lst(R,Eaux,Eout)
	;   Param = []
	->  Ein = Eout
	;   Param = [P1,P2]
	->  get_var_lst(P1,Ein,Ea1),
	    get_var_lst(P2,Ea1,Eout)
	;   get_var_lst(Param,Ein,Eout)
	).

var_list(P,Vars):-get_var_lst(P,[],Vars).

% Reuse Problem 2's Code

convert_toy(Pin,Pout):-
	var_list(Pin,Vars),
	convert_toy(Pin,Pout,Vars,_).

/*
things stay unchange -- 100% not involves in if..then..else, buy may
involves in the change of Environment -- assume all variable would be
properly initiallized, any appeared X constant would come on the LFS.
 */
convert_toy((X=Expr),(X=Expr),Vars,Vars).

convert_toy((S;),(Sc;),VI,VO):-
	convert_toy(S,Sc,VI,VO). % remove ; if have
convert_toy((S1;S2),(S1c;S2c),VI,VO):-
	convert_toy(S1,S1c,VI,Vaux),convert_toy(S2,S2c,Vaux,VO).

% it's perfectly fine if it's if..then
convert_toy((if B then {S1}),(if B then {S1c}),VI,VO):-
	convert_toy(S1,S1c,VI,VO).

% main part of the translation comes here.
convert_toy( (if B then {S1} else{S2}),
		     (Var = B; if Var then {S1c}; if (\Var) then {S2c}),
		      VI,VO):-
	get_never_used_var(VI,1,Va1,Var),% find an appripriate value
	convert_toy(S1,S1c,Va1,Ea2),convert_toy(S2,S2c,Ea2,VO).

convert_toy((while B do {S}),(while B do {Sc}),VI,VO):-
	convert_toy(S,Sc,VI,VO).

get_never_used_var(VI,N,VO,Var):-
	atom_concat(n,N,R),
	(	member(R,VI)
	->	writeln(R),Np is N + 1, get_never_used_var(VI,Np,VO,Var)
	;	VO = [R|VI],Var = R).


?- P =
    ( a = 240 ; b = 144 ; i = 0 ;
      while ( a \= b ) do {
          if ( b > a )
              then { b = b - a }
              else { a = a - b } ;
	  i = i + 1 ;
      } ),convert_toy(P,Pc),
    empty_assoc(Empty),
    interp(Pc,Empty,Out),
    get_var_values([a,b,i],Vals,Out),
    atomic_list_concat(Vals,' ',Writable),
    writeln(Writable).


:- Program =
    ( a = 0 ; b = 0 ; x = 1 ;
      while ( a < 10 ) do {
          a = a + 1 ;
          b = b + a ;
	  x = x * b ;
      } ),convert_toy(Program,Pc),
    empty_assoc(Empty),
    interp(Pc,Empty,Out),
    get_var_values([a,b,x],Vals,Out),
    atomic_list_concat(Vals,' ',Writable),
    writeln(Writable).

:- Program =
    ( a = 0 ; b = 0 ; x = 1 ;
      while ( \(a == 10) ) do {
          a = a + 1 ;
          b = b + a ;
	  x = x * b ;
      } ),convert_toy(Program,Pc),
    empty_assoc(Empty),
    interp(Pc,Empty,Out),
    get_var_values([a,b,x],Vals,Out),
    atomic_list_concat(Vals,' ',Writable),
    writeln(Writable).

