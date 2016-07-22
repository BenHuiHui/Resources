%  Author: Song Yangyu (A0077863N), Zhong Shiyin (A0082182J)

% Assumption: the given program has correct syntax.

:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

change_var_name_recur([],[],_V,_N):-!.
change_var_name_recur(ParamO,ParamN,V,N):- % handle a list
	ParamO = [H|T],change_var_name(H,NewH,V,N),change_var_name_recur(T,NewT,V,N),
	ParamN = [NewH|NewT].

change_var_name(OldV,OldV,V,N):- atomic(OldV),OldV \= V,!,
	(	OldV == N
	->	atomic_list_concat(['Variable ',N,' already exists in list'],Output),
		writeln(Output),fail
	;	true).
change_var_name(OldV,NewV,OldV,NewV):-!.
change_var_name(Expr,NewE,V,N):-
	Expr =.. [Op|Param],change_var_name_recur(Param,ParamNew,V,N),
	NewE =.. [Op|ParamNew].


?- P = (
       a = 240; b = 144; i = 0; x = 12;
       while( a \= b) do {
           if( b > a )
	       then { b = b - a}
	       else { a = a - b};
	   i = i + 1;
       }),change_var_name(P,NewP,a,x),writeln(NewP).






