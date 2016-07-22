% fractal(Equation, Approximation_level, Unit_length)
% E.g. of Equation: g = (g; left(45);g;right(90);g;left(45);g)
%

fractal(VarChar = Expression , Level,Length):-
	writef('%w\n%w\n\n',['from turtle import * ','delay(0)']),
	fractal(Expression,Level,Length,Expression,VarChar),!,
	writef('%w\n',['raw_input("Press Enter to exit. ")']).

% draw the basic one (unit move)
fractal(Str,Level,Length,OverallExpression,VarChar):-!,
	%write(Str),
      (
	(  %write('trying first one'),nl,
	Str = ;(Var,Rest),!, %write('first matched'),nl,% when
%	   writef('op = %w,Var = %w',[Op,Var]),nl,
	   fractal(Var,Level,Length,OverallExpression,VarChar),
           fractal(Rest,Level,Length,OverallExpression,VarChar)
	);
	(Str == VarChar, %write('Second matched'),
	 (
	  (Level == 0,!,
	    %simply write the unit length
	    %write('succeed on VarChar, Level = 0'),nl,
	    IntLength is round(Length),
	    writef('%w%d%w\n',['forward(',IntLength,')'])
	  );
	  ( % the else condition: When Level > 0 -> entering a new level
	    %writef('succeed on VarChar, Level is %d',[Level]),nl,
	    NewLevel is Level - 1, NewLength is Length/2,
	    fractal(OverallExpression,NewLevel,NewLength,OverallExpression,VarChar)
	  )
	 )
	);
	( % The else condition: Str != VarChar: Str is a python statement
	  write(Str),nl
	)
      ).

% handle the expression
%fractal(Expression,Level,Length,OverallExpression,VarChar):-
%	Expression = Var ';' Rest,
%	fractal(Var,Level,Length,OverallExpression),
%	fractal(Rest,Level,Length,OverallExpression).


%is_char(Var):-atom_codes(Var,Str),Str=[_|[]].








