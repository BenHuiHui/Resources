balanced("","") :-!.
balanced(S,"") :-
	append(["(",S1,")"],S),balanced(S1,_),!.
balanced(S,R) :-
	append([X],S1,S), \+ member([X],["(",")"]),!,
	balanced(S1,R1), append([X],R1,R).
balanced(S,R) :-
%	append(S1,)
