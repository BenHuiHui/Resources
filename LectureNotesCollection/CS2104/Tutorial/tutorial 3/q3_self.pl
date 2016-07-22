
:- op(1000,fx,push).
% inst(Command, FromStack, ResultStack)
inst(push E,S,[E|S]).
inst(add,[A,B|S],[R|S]):- R is (A+B).
inst(sub,[A,B|S],[R|S]):- R is (A-B).
inst(mul,[A,B|S],[R|S]):- R is (A*B).
inst(div,[A,B|S],[R|S]):- R is (A/B).

exec(P,R):- exec(P,[],[R]).
exec(S1;S2,I,O) :- inst(S1,I,AUX), exec(S2,AUX,O).  %group inst seperated by ";".
exec(S,I,O):- inst(S,I,O). %single instruction
