% syntax analyzer
%
analyze(S,R1,_) :- append(["(",A,")"],S), analyzeA(A,R1,_).
analyzeA(A,R1,_) :- append(["[",A1,"]"],A), analyzeA(A1,R1,_).
analyzeA(A,R1,R2) :- append(["{",A1,"}",S],A), analyzeA(A1,R1,_),analyze(S,R2,_).
analyzeA(A,A,_) :- A=[_|[]], A > "a", A < "z",!.


