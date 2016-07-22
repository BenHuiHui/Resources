%implement the quick sort


% some quick exercise... for getting fimilar with prolog's way of
% thinking:
%
% factorial(A,B) A's factorial is B.
factorial(0,1).
factorial(A,B) :- A_1 is (A-1), factorial(A_1,B_2), B is B_2 * A.

%fibonicci(A,B): the A'th fibonicci is B. starting from 0.
%List of fibonicci numbers: 0,1,1,2,3,5,8,13,21,etc
fibonacci(1,0).
fibonacci(2,1).
fibonacci(A,B) :- A_1 is A-1, A_2 is A-2,fibonacci(A_1,B_1), fibonacci(A_2,B_2), B is B_1+B_2.


%use the concept of "accumulator" for storing the intermediate result
find_max_acc([],R,R).
find_max_acc([H|T],Max,R) :- (H>Max-> find_max_acc(T,H,R); find_max_acc(T,Max,R)).
%find_max([H|T],R):-find_max_acc(T,H,R).


find_max([H|[]],H).
find_max([H|T],Max) :-
	(var(Max)->find_max(T,H);
	        (H>Max -> find_max(T,H);
		          find_max(T,Max))
	).
%insertion sort -- incomplete
%insertion_sort([]).

% Stop the exercise, start my main q_sort program

quickSort([],[]):-!.
quickSort([Pivot|Rest],R) :- partition(Rest,[],[],Pivot,R),!.
partition([H|T],A,B,Pivot,R) :-
	(H=<Pivot -> partition(T,[H|A],B,Pivot,R);partition(T,A,[H|B],Pivot,R)),!.
% The merge process
partition([],A,B,Pivot,R) :- quickSort(A,A2),!, quickSort(B,B2),!, append(A2,[Pivot|B2],R).
% Actual partition





























