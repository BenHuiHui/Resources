parent(john,george).
parent(john,mary).
parent(george,adam).
parent(george,beth).
parent(adam,james).

ancestor(X,Y) :- parent(X,Y).
ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).
