expr(S):- append(S1,S2,S),subexpr(S1),term(S2).
subexpr("").
subexpr(S):- append([S1, S2, O],S), subexpr(S1),term(S2),member(O,["+","-"]).

term(S):- append(S1, S2, S), subterm(S1), factor(S2).
subterm("").
subterm(S):- append([S1,S2,O],S),subterm(S1)
