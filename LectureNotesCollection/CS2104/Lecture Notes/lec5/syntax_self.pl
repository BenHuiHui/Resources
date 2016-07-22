expr(X):-
	Xs = X,
	append(X1,X2,Xs),subexpr(X1),term(X2).
subexpr("").
subexpr(X):-
	Xs = X,
	append([X1,X2,X3],Xs),subexpr(X1),term(X2),member(X3,["+","-"]).
term(X):-
	Xs = X,
	append([X1,X2],Xs),subterm(X1),factor(X2).
subterm("").
subterm(X):-
	Xs = X,
	append([X1,X2,X3],Xs),subterm(X1),factor(X2),member(X3,["*","/"]).
factor(X):-
	Xs = X,
	append([X1,X2],Xs),base(X1),restexp(X2).
restexp("").
restexp(X):-
	Xs = X,
	append([X1,X2,X3],Xs),X1="^",base(X2),restexp(X3).
base(X):- member(X,[a,b,c,d]).
base(X):- expr(X).
