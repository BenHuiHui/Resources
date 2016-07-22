rev(A,B) :- reverse(A,[],B).
reverse([],Reversed,Reversed):- !.
reverse([H|List],Buffer,Reversed):- reverse(List,[H|Buffer],Reversed).

rev2([],[]).
rev2([H|T],L) :- rev2(T,X), append(X,[H],L).

