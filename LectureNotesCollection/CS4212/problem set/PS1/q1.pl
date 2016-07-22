%  Author: Song Yangyu (A0077863N), Zhong Shiyin (A0082182J)
%
% Assumption: the given program has correct syntax.
:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).


count_assig(P,0):- atomic(P),!.

count_assig(P,N):- !,
	P =.. [Op|Param],
	(   Op = (=) % would add 1 to result if it's a '='
	->  AddV is 1
	;   AddV is 0),
	% Param can be either binary or uniary
	(   Param = [P1,P2]
	->  count_assig(P1,N1),count_assig(P2,N2),
	    N is N1 + N2 + AddV
	;   count_assig(Param,N1),N is N1 + AddV
	).

?- P = (
       a = 240; b = 144; i = 0;
       while( a \= b) do {
           if( b > a )
	       then { b = b - a}
	       else { a = a - b};
	   i = i + 1;
       }),count_assig(P,N),writeln(N).
