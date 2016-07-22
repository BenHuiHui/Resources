% Lecture 3 pre-recording
%
%  Predicates:
%     append/3 append/2
%     length
%     member
%     select
%     reverse
%     univ =..
%     association lists (dictionaries)
%       empty_assoc(NewEmptyAssoc)
%       put_assoc(Key,Assoc,Value,NewAssoc)
%       get_assoc(Key,Assoc,Value)
%       get_assoc(Key,OldAssoc,Oldval,NewAssoc,NewVal)
%       atomic_list_concat/2   atomic_list_concat/3

app([],L,L).
app([H|T],L,[H|R]) :- app(T,L,R).

nr([],[]).
nr([H|T],X) :- nr(T,R), app(R,[H],X).

% program to generate permutations of a list
permute([],[]).
permute([H|T],L) :- permute(T,T1), sel(H,L,T1).

sel(X,[X|T],T).
sel(X,[H|T],[H|L]) :- sel(X,T,L).

% syntax check for expressions with arithmetic operators

sc(N) :- integer(N),!.
sc(E) :- E =.. [Op,E1,E2], member(Op,[+,-,*,/]),!,sc(E1),sc(E2).






