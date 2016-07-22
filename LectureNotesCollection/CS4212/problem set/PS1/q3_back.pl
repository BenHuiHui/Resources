% Assumption:
%  1. the given program has correct syntax.

:- op(950,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

convert_toy(Pin,Pout):-
	empty_assoc(X),put_assoc(vars,X,[T],Ein),T = [],
	convert_toy(Pin,Pout,Ein,_).

/*
things stay unchange -- 100% not involves in if..then..else, buy may
involves in the change of Environment -- assume all variable would be
properly initiallized, any appeared X constant would come on the LFS.
 */
convert_toy((X=Expr),(X=Expr),Ein,Eout):-
	(atom(X)
	->	get_assoc(vars,Ein,Vars,Eout,NVars),
		(	member(X,Vars) -> NVars = Vars; NVars=[X|Vars])
	;	true). % otherwise do nothing

convert_toy((S;),(Sc;),Ein,Eout):-
	convert_toy(S,Sc,Ein,Eout). % remove ; if have
convert_toy((S1;S2),(S1c;S2c),Ein,Eout):-
	convert_toy(S1,S1c,Ein,Eaux),convert_toy(S2,S2c,Eaux,Eout).

% it's perfectly fine if it's if..then
convert_toy((if B then {S1}),(if B then {S1c}),Ein,Eout):-
	convert_toy(S1,S1c,Ein,Eout).

% main part of the translation comes here.
convert_toy( (if B then {S1} else{S2}),
		     (Var = B; if Var then {S1c}; if (\Var) then {S2c}),
		      Ein,Eout):-
	Var = aaaaaaaaaaaa, % find an appripriate value
	convert_toy(S1,S1c,Ein,Eaux),convert_toy(S2,S2c,Eaux,Eout).

convert_toy((while B do {S}),(while B do {Sc}),Ein,Eout):-
	convert_toy(S,Sc,Ein,Eout).

/*
	// things cannot match
	P = ((while a\=b)do{ (if b>a)then{b=b-a}else{a=a-b};i=i+1;})

?- P = ( a=240; b = 144;i=0; while (a\=b)do{if (b>a)then{b=b-a}
else{a=a-b}; i=i+1;}),convert_toy(P,Pn),writeln(Pn). => (while a\=b)do{
(if b>a)then{b=b-a}else{a=a-b};i=i+1;} P = ( while ( a \= b) do { if( b
> a )
	       then { b = b - a}
	       else { a = a - b};
	   i = i + 1;
       }),convert_toy(P,Pn),writeln(Pn).


P = (while (a\=b) do{ if (b>a) then{b=b-a}else{a=a-b};i=i+1;})

?- P = (while ( a\=b ) do{ if
(b>a) then{ b=b-a } else{a=a-b};i=i+1;}),convert_toy(P,Pc),writeln(Pc).

?- P = (
		while ( a \= b ) do{
		   if( b>a )
		   then { b = b - a}
		   else { a = a - b} ;i=i+1;}),convert_toy(P,Pc),writeln(Pc).
*/











