:- dynamic parent/2, ancestor/2, del/3, cutting_stack/1, backtracking/0.

parent(jim,harry).
parent(anna,george).
parent(anna,mary).
%parent(john,harry).
%parent(mary,adam).
parent(jim,anna).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z),!, ancestor(Z,Y).

del(X,[X|Y],Y).
del(X,[Y|T],[Y|T1]) :- del(X,T,T1).

cutting_stack([]).

adjust_cut(K) :-
	retract(cutting_stack(L)),
	remove_uptok(K,L,L1),
	assert(cutting_stack(L1)).

remove_uptok(K,[K1|L1],L2) :- K1 > K, !, remove_uptok(K,L1,L2).
remove_uptok(_,L,L).


annotate_cut(N,(!,G),((!^N),G1)) :- !,annotate_cut(N,G,G1).
annotate_cut(N,(!),(!^N)) :- !.
annotate_cut(N,(G1,G2),(G3,G4)) :- !, annotate_cut(N,G1,G3), annotate_cut(N,G2,G4).
annotate_cut(_,G,G).

find_clause(N,H,B,B0) :-
	functor(H,Name,Arg), functor(H1,Name,Arg),
	retract(cutting_stack(S)),
	assert(cutting_stack([N|S])),
	(   clause(H1,B1) ; N1 is N-1, adjust_cut(N1), fail) ,
	(   backtracking, cutting_stack(L)
	->  (   L=[K|_]
	    ->	(	K < N
		->	fail
		;	adjust_cut(N),retract(backtracking) )
	    ;  fail )
	;   true),
	annotate_cut(N,B1,B2),
	printf("%rL:",['   ',N]),writeln(N),
	printf("%rCS:",['   ',N]),
	cutting_stack(L),
	writeln(L),
	printf("%rC:",['   ',N]),
	writeln((H1 :- B2)),
	printf("%rU:",['   ',N]),
	(   B0 = true
	->  (B1=true -> writeln((H1=H)) ; writeln(((H1=H),B2)))
	;   (B1=true -> writeln(((H1=H),B0)) ; writeln(((H1=H),B2,B0)))),
	printf("%r     ",['   ',N]),
	( H=H1 ->
	    B=B2, writeln(' ') ;
	    writeln('failure'), assert(backtracking), fail
	).

meta(N,G) :-
	printf("%r   G:",['   ',N]),
	writeln(G),
	N1 is N+1,
	metah(N1,G).

metah(N,((G1,G2),G3)) :- !, metah(N,(G1,(G2,G3))).

metah(N,(G1,G2)) :- !,
	(   G1=(!^K)
	->  B1=true, K1 is K - 1, adjust_cut(K1),
	    printf("%rL:",['   ',N]),writeln(N),
	    printf("%rCS:",['   ',N]), cutting_stack(L), writeln(L),
	    writeln(' ')
	;   find_clause(N,G1,B1,G2) ),
	( B1 = true ->
	    meta(N,G2) ;
	    meta(N,(B1,G2))
	).
metah(N,(!^K)) :- !,
	K1 is K - 1, adjust_cut(K1), assert(backtracking),
	printf("%rL:",['   ',N]),writeln(N),
	printf("%rCS:",['   ',N]), cutting_stack(L), writeln(L),
	printf("%r ",['   ',N]),
	writeln('success').
metah(N,G) :-
	find_clause(N,G,B,true),
	( B=true ->
	    printf("%r ",['   ',N]),
	    writeln('success'), assert(backtracking) ;
	    meta(N,B)
	).
%metah(N, _G) :-
%	printf("%r",[' ',N]),
%	writeln('failure'),
%	fail.

factorial(0,1) :- !.
factorial(N,R) :- N1 is N-1, factorial(N1,R1), R is N*R1.

app([],S,S).
app([H|T],S,[H|S1]) :- app(T,S,S1).

count_nodes(nil,0).
count_nodes(node(_,L,R),N) :-
	count_nodes(L,NL),count_nodes(R,NR),N is NL+NR+1.

p(X) :- q(X,Y),r(Y).
p(X) :- q(Y,X),r(Y).

q(X,f(X)).
q(X,g(X)):- eq(X,a).

r(f(a)):-!.
r(f(b)).

eq(X,X).

:- retractall(cutting_stack(_)), assert(cutting_stack([])).
:- retractall(backtracking).

















