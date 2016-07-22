%  Author: Song Yangyu (A0077863N), Zhong Shiyin (A0082182J)

% Assumption:
%  1. the given program has correct syntax.
%  2. where there's a new variable added into the list,
%     there must be an assignment.
:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

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
things stay unchange -- 100% not involves in if..then..else
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
	get_never_used_var(VI,1,Va1,Var),% find an appripriate variable name which is never used.
	convert_toy(S1,S1c,Va1,Ea2),convert_toy(S2,S2c,Ea2,VO).

convert_toy((while B do {S}),(while B do {Sc}),VI,VO):-
	convert_toy(S,Sc,VI,VO).


get_never_used_var(VI,N,VO,Var):-
	atom_concat(n,N,R),
	(	member(R,VI)
	->	writeln(R),Np is N + 1, get_never_used_var(VI,Np,VO,Var)
	;	VO = [R|VI],Var = R).


?- P = (
       a = 240; b = 144; i = 0;
       while ( a \= b) do {
           if ( b > a )
	       then { b = b - a}
	       else { a = a - b};
	   i = i + 1;
       }),convert_toy(P,Vars),writeln(Vars).










