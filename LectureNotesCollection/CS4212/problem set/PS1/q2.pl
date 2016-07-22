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



?- P = (
       a = 240; b = 144; i = 0;
       while( a \= b) do {
           if( b > a )
	       then { b = b - a}
	       else { a = a - b};
	   i = i + 1;
       }),var_list(P,Vars),writeln(Vars).











