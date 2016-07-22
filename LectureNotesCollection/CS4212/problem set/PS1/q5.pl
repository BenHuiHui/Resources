% Discussed wiht Zhong Shiyin (A0082182J)
% Assumption:
%  1. the given program has correct syntax.

:- [library(clpfd)].

:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

% E is Expression, R is Result
eval(E,_):- atom(E),!,fail.
eval(N,N):- number(N),!.
eval(E,R):-
  E =.. [Op,A,B],
  member(Op,[+,-,*,/,rem,^]),!,
  eval(A,Ra),eval(B,Rb),
  Compute =.. [Op,Ra,Rb],
  R #= Compute.
eval(E,R):-
  E =.. [Op,A],
  member(Op,[+,-]),!,eval(A,Ra),
  Compute =.. [Op,Ra],
  R #= Compute.
eval(E,R) :-
  E =.. [Op,A,B],
  member(Op,[<,>,=<,>=,\=,==]),!,
  eval(A,RA), eval(B,RB),
  atomic_concat('#',Op,HOp),
  Compute =.. [HOp,RA,RB],
  R #<==> Compute.
eval(E,R) :-
  E =.. [Op,A,B],
  member(Op,[+,-,*,/,rem,^]),!,
  eval(A,RA), eval(B,RB),
  Compute =.. [Op,RA,RB],
  R #= Compute.

eval(E,R) :-
  E =.. [Op,A],
  member(Op,[\]),!,
  eval(A,RA),
  atomic_concat('#',Op,HOp),
  Compute =.. [HOp,RA],
  R #<==> Compute.

% things stay unchange -- 100% not involves in if..then..else
simplify_if((X=Expr),(X=Expr)).

simplify_if((S;),(Sc;)):-simplify_if(S,Sc). % remove ; if have
simplify_if((S1;S2),(S1c;S2c)):- !,
	simplify_if(S1,S1c),simplify_if(S2,S2c).

% it's perfectly fine if it's if..then
simplify_if(if Expr then {S1}, NewP):- !,
  ( eval(Expr,Result)
  ->( member(Result,[1,0])
    ->( Result = 1 -> simplify_if(S1,NewP) ; NewP = '')
    ; writeln('Error: Illegal Expression occured in if condition'),fail
    )
  ;  simplify_if(NewP,NewPPart), NewP = (if Expr then {NewPPart})
  ).

% main part of the translation comes here.
simplify_if(if Expr then {S1} else{S2},NewP):-
  ( eval(Expr,Result)
  ->( member(Result,[1,0])
    ->( Result = 1 -> simplify_if(S1,NewP) ; simplify_if(S2,NewP))
    ; writeln('Error: Illegal Expression occured in if condition'),fail
    )
  ;  NewP = (if Expr then {S1})
  ).

simplify_if((while B do {S}),while B do {Sc}):-
	simplify_if(S,Sc).

?- P = (
  a = 240 ; b = 144 ; i = 0 ;
  while ( a \= b ) do {
    if ( 2+3+(2>1) > 1*1/1 )
    then { b = b - a }
    else { a = a - b } ;
    i=i+1 ;
  } ), simplify_if(P,NewP), writeln(NewP).
