es(S):- append(["(",A,"|",B,")"],S),ea(A),eb(B),!.

ea(""):- !.
ea(A):- append(B,"a",A),eb(B),!.
eb(""):- !.
eb(B):- append(A,"b",B),ea(A),!.
