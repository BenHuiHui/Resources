%simplify the expression based on what's given
% simplify(E,Res) would store the simplified E into Res

simplify(E,Res):-
	E=..[Op,L,R|T], T==[], simplify(L,L_res), simplify(R,R_res),!,
	( % the switch clause
	  (number(L_res),number(R_res),Res is E); % both side are number
	  ( % switch
	    (
	      (Op == + ; Op == -), % condition
	      (
	        (L_res == 0, Res = R_res);
	        (R_res == 0, Res = L_res);
	        op_to_term(Op,L_res,R_res,Res) % default
	      )
	    );
	    (
	      Op == *, % condition
	      (
	        (
		  (L_res == 0; R_res == 0), % inner condition as group
		  Res = 0  % assignment
		);
	        ((L_res == 1, Res = R_res));
	        ((L_res == -1, negative(R_res,Res))); % Res = -R_res));
	        ((R_res == 1, Res = L_res));
	        ((R_res == -1, negative(L_res,Res))); %Res= -L_res));
	        op_to_term(Op,L_res,R_res,Res) % default
	      )
	    );
	    (
	      Op == /,  % condition
	      (
	        (L_res == 0, Res = 0);
	        (R_res == 1, Res = L_res);
                op_to_term(Op,L_res,R_res,Res) % default
	      )
	    )
	  )
	),!.
simplify(Res,Res):-!.

% find the negative of E, store into Res. E can be any constants
negative(E,Res):- % negate an expression
	E =.. [Op,L,R|[]],
	(
	  (Op == +,
	    negative(L,L_res), negative(R,R_res),op_to_term(+,L_res,R_res,Res)
	  );
	  (Op == -,
	    negative(L,L_res),op_to_term(+,L_res,R,Res)
	  );
	  Res = -E
	),!.
negative(E,Res):- number(E), Res is -E,!. %negate a number
negative(E,Res):-  % negate an atom
	E =.. [Op,Var|[]],Op== - -> Res = Var; Res = -E,!.
op_to_term(+,L,R,Res):- (R=..[Op,E|[]],Op == -)-> Res = L - E; Res= L + R,!.
op_to_term(-,L,R,Res):- (R=..[Op,E|[]],Op == -)-> Res = L + E; Res= L - R,!.
op_to_term(*,L,R,Res):- Res= L * R,!.
op_to_term(/,L,R,Res):- Res= L / R,!.






