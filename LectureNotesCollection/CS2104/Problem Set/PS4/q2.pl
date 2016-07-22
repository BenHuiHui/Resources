% Changeds Made:
%  see line 39 ~ 59. Added in the handling of "(A,B)=(C,D)" there.

:- op(1099,yf,;).
:- op(960,fx,if).
:- op(959,xfx,then).
:- op(958,xfx,else).
:- op(960,fx,while).
:- op(959,xfx,do).

compileExpr(K,E,E,T,T) :- % integer: push in directly
	integer(K),!,
	write('    esp -= 4 ; *(int*)&M[esp] = '),
	write(K),write(' ; // push '), writeln(K).
compileExpr(V,Ein,Eout,Tin,Tout) :-
	atom(V),!,
	(   member((V->Addr),Ein)
	->  Tout = Tin, Eout = Ein			       % use the current space
	;   Tout is Tin+4, Eout = [(V->Tin)|Ein], Addr = Tin), % assign new space
	write('    ecx = *(int*)&M['),            % load to ecx
	write(Addr),
	% push the loaded element to the top of the stack
	write('] ; esp -= 4 ; *(int*)&M[esp] = ecx ; // push '),
	writeln(V).
compileExpr(Exp,Ein,Eout,Tin,Tout) :-
	Exp =.. [O,A,B], % case of operator
	compileExpr(A,Ein,Eaux,Tin,Taux), % evaluate the LHS
	compileExpr(B,Eaux,Eout,Taux,Tout), % evaluate the RHS
	% pop the last two evaluation
	writeln('    ecx = *(int*)&M[esp] ; esp += 4 ;'),
	writeln('    eax = *(int*)&M[esp] ; esp += 4 ;'),
	% perfrom the operation on the two element
	write('    eax '), write(O), writeln('= ecx ;'),
	% and push the result back to the top of the stack
	write('    esp -= 4 ; *(int*)&M[esp] = eax ; // push result of '),
	writeln(O).


compile(V=E,Ein,Eout,Tin,Tout,L,L) :-
	%handle the case of (x,y) = (Expr1, Expr2)
	( %first case
	V=(A,B),E=(C,D),!,
		(	 member((A->Addr),Ein)
		->	 compileExpr(A,Ein,_,Tin,Tin_1), % store the value of A
		 compile((A=C),Ein,Eaux,Tin_1,Taux,L,L),
		 % store the current value to ecx
		 writef('    %w%d%w',['ecx = *(int*)&M[', Addr, '];']),
		% load the old value to edx
		writeln('edx = *(int*) &M[esp]; esp += 4;'),
		 % restore the old value
		 writef('    %w%d%w',['*(int*)&M[', Addr, '] = edx;']),
		% store teh new value to the stack
		writeln('esp-=4;*(int*)&M[esp] = ecx;'),
		 compile((B=D),Eaux,Eout,Taux,Tout,L,L),
		 write('    ecx = *(int*)&M[esp];esp += 4;'),
		 writef('%w%d%w',['*(int*)&M[',Addr,'] = ecx;'])
		;   compile((A=C),Ein,Eaux,Tin_1,Taux,L,L),
		 compile((B=D),Eaux,Eout,Taux,Tout,L,L)
		)
	);
	( % second case
	compileExpr(E,Ein,Eaux,Tin,Taux),!,
		(   member((V->Addr),Eaux)
		->  Tout = Taux, Eout = Eaux
		;   Tout is Taux+4, Eout = [(V->Taux)|Eaux], Addr = Taux),
		   writeln('    ecx = *(int*)&M[esp] ; esp += 4 ;'),
		write('    *(int*)&M['),write(Addr),write('] = ecx ; // pop '),
		writeln(V)
	).
compile(if B then S1 else S2,Ein,Eout,Tin,Tout,Lin,Lout) :- !,
	B =.. [O,X,Y], La1 is Lin+1,
	(   O == (\=) -> Otrans = '!=' ; Otrans = O ),
	writeln('    // start of if-then-else statement'),
	compileExpr(X,Ein,Ea1,Tin,Ta1),
	compileExpr(Y,Ea1,Ea2,Ta1,Ta2),
	writeln('    ecx = *(int*)&M[esp] ; esp += 4 ;') ,
	writeln('    eax = *(int*)&M[esp] ; esp += 4 ;') ,
	write('    if ( eax '), write(Otrans),
	write(' ecx ) goto Lthen'), write(Lin), writeln('; // if condition'),
	compile(S2,Ea2,Ea3,Ta2,Ta3,La1,La2),
	write('    goto Lendif'),write(Lin),writeln(';'),
	write('Lthen'),write(Lin),writeln(':'),
	compile(S1,Ea3,Eout,Ta3,Tout,La2,Lout),
	write('Lendif'),write(Lin),writeln(':').
compile(if B then S,Ein,Eout,Tin,Tout,Lin,Lout) :- !,
	B =.. [O,X,Y], La1 is Lin+1,
	(   O == (\=) -> Otrans = '!=' ; Otrans = O ),
	writeln('    // start of if-then statement'),
	compileExpr(X,Ein,Ea1,Tin,Ta1),
	compileExpr(Y,Ea1,Ea2,Ta1,Ta2),
	writeln('    ecx = *(int*)&M[esp] ; esp += 4 ;') ,
	writeln('    eax = *(int*)&M[esp] ; esp += 4 ;') ,
	write('    if ( eax '), write(Otrans),
	write(' ecx ) goto Lthen'), write(Lin), writeln('; // if condition'),
	write('    goto Lendif'),write(Lin),writeln(';'),
	write('Lthen'),write(Lin),writeln(':'),
	compile(S,Ea2,Eout,Ta2,Tout,La1,Lout),
	write('Lendif'),write(Lin),writeln(':').
compile(while B do S,Ein,Eout,Tin,Tout,Lin,Lout) :- !,  % 'while'
	B =.. [O,X,Y], La1 is Lin+1,
	(   O == (\=) -> Otrans = '!=' ; Otrans = O ),
	write('Lwhile'),write(Lin),writeln(':'),
	compileExpr(X,Ein,Ea1,Tin,Ta1),
	compileExpr(Y,Ea1,Ea2,Ta1,Ta2),
	writeln('    ecx = *(int*)&M[esp] ; esp += 4 ;') ,
	writeln('    eax = *(int*)&M[esp] ; esp += 4 ;') ,
	write('    if ( eax '), write(Otrans),
	write(' ecx ) goto Lwhilebody'), write(Lin), writeln(';'),
	write('    goto Lendwhile'),write(Lin),writeln(';'),
	write('Lwhilebody'),write(Lin),writeln(':'),
	compile(S,Ea2,Eout,Ta2,Tout,La1,Lout),
	write('    goto Lwhile'),write(Lin),writeln(';'),
	write('Lendwhile'),write(Lin),writeln(':').
compile(S1;S2,Ein,Eout,Tin,Tout,Lin,Lout) :- !, % link two statement separated by ';' together
	compile(S1,Ein,Eaux,Tin,Taux,Lin,Laux),
	compile(S2,Eaux,Eout,Taux,Tout,Laux,Lout).
compile(S;,Ein,Eout,Tin,Tout,Lin,Lout) :- !,    % compile statement S
	compile(S,Ein,Eout,Tin,Tout,Lin,Lout).
compile({S},Ein,Eout,Tin,Tout,Lin,Lout) :- !,	% compile block S
	compile(S,Ein,Eout,Tin,Tout,Lin,Lout).

compileProg(P) :-
	writeln('#include <stdio.h>'),
	writeln('int eax,ebx,ecx,edx,esi,edi,ebp,esp;'),
	writeln('unsigned char M[10000];'),
	writeln('void exec(void) {'),
	compile(P,[],Eout,0,_,0,_),
	writeln('{}}'),nl,
	writeln('int main() {'),
	writeln('    esp = 10000 ;'),
	writeln('    exec();'),
	outputVars(Eout),
	writeln('    return 0;'),
	writeln('}').

outputVars([]).
outputVars([(V->Addr)|T]) :-
	write('    printf("'),write(V),write('=%d\\n",'),
	write('*(int*)&M['),write(Addr),writeln(']);'),
	outputVars(T).

:- P = (
          x = 144 ;
          y = 60 ;
          while ( x \= y ) do {
             if ( x < y ) then {
                y = y - x ;
             } else {
                x = x - y ;
             } ;
          } ;
       ),
	compileProg(P).



