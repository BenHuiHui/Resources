%count(Expression,Operator,Result):- append([A,[Operator],B],Expression)
%test(E,O,R):-test_help([A,O,B],R)

%count_help([],_,Result,Result).
%count_help(Expression,Operator,Occurence,Result) :-
:-op(1200,xfy,^).
count([],_,0).    % overall terminates when E is empty
count([H|Tail],Op,R):- % when E is a list
	count(H,Op,TempR1),count(Tail,Op,TempR2),
	R is TempR1 + TempR2.
count(E,Op,R):-
	E=.. [CurrentOp|RestE_list],
	(CurrentOp==Op -> TempR_1 is 1; TempR_1 is 0),
	count(RestE_list,Op,TempR_2),
	R is TempR_1 + TempR_2.
%count_h_chain([],_,R,R).  %terminate when E is element with arity 0.
%count_h_chain([H|T],Op,TempR,R):-
%	count_h(H,Op,0,R1),
%	count_h_chain(T,Op,TempR2,R),TempR2 is TempR + R1.






