:- [library(clpfd)].

:- op(1099,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

eval(N,_,_,N) :- integer(N), !.
eval(a,A,_,A).
eval(b,_,B,B).
eval((E1-E2),A,B,Result) :- eval(E1,A,B,R1), eval(E2,A,B,R2), Result #= R1-R2.
eval((E1\=E2),A,B,1) :- eval(E1,A,B,R1), eval(E2,A,B,R2), R1 #\= R2,!.
eval((_\=_),_,_,0).
eval((E1<E2),A,B,1) :- eval(E1,A,B,R1), eval(E2,A,B,R2), R1 #< R2, !.
eval((_<_),_,_,0).

interp((a = Expr),Ain,B,Aout,B) :- eval(Expr,Ain,B,Aout).
interp((b = Expr),A,Bin,A,Bout) :- eval(Expr,A,Bin,Bout).
interp((if B then { S1 } else { S2 } ),Ain,Bin,Aout,Bout) :-
	eval(B,Ain,Bin,Bval),
	(   Bval #= 1
	->  interp(S1,Ain,Bin,Aout,Bout)
	;   interp(S2,Ain,Bin,Aout,Bout) ).

interp((while B do { S }),Ain,Bin,Aout,Bout) :-
	interp(
	    (if B then {
		      S ;
		      while B do { S }
		  } else { a = a }
	    ),Ain,Bin,Aout,Bout).

interp((S1;S2),Ain,Bin,Aout,Bout) :-
	interp(S1,Ain,Bin,Aaux,Baux),
	interp(S2,Aaux,Baux,Aout,Bout).

:- Program =
    ( a = 240 ; b = 144 ;
      while ( a \= b ) do {
          if ( a < b )
              then { b = b - a }
              else { a = a - b }
      } ),
    interp(Program,0,0,A,B),
    writeln(a = A), writeln(b = B).

:- Program =
    ( a = 0 ; b = 0 ;
      while ( a \= 10 ) do {
          a = a - -1 ;
          b = b - (0 - a)
      } ),
    interp(Program,0,0,A,B),
    writeln(a = A), writeln(b = B).









