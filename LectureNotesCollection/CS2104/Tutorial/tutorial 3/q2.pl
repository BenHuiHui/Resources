%part(X,[H|T],[H1|T1],[H2|T2]).
part(_X,[],[],[]):-!.
part(X,[H|T],HI,LO):- H<X,LO=[H|TL],part(X,T,HI,TL).
part(X,[H|T],HI,LO):- H>=X,HI=[H|TH],part(X,T,TH,LO).
qs([],[]).
qs([H|T],L):- part(H,T,HI,LO),qs(HI,SH),qs(LO,SL),append(SL,[H|SH],L).
