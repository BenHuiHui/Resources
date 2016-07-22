atom_chars_is_label_tail(LblTail):-
    LblTail = [H|T],
    (   (   T = [],!,H = ':')
    ;   (   atom_to_term(H,Hp,_),integer(Hp),!,atom_chars_is_label_tail(T))
    ).
atom_is_label_pattern(Lbl):-
    atom_chars(Lbl,LblList), LblList = ['\n','L'|LblTail],
    atom_chars_is_label_tail(LblTail).

remove_duplicate_lbl([],[],A,A):-!.
remove_duplicate_lbl(Lin,Lout,Ain,Aout):-!,
    Lin = [HLin | TLin],
    (   atom_is_label_pattern(HLin)
    ->  (   get_assoc(HLin,Ain,_)
        ->  (   Lout = TRes, A0 = Ain)
        ;   (   put_assoc(HLin,Ain,1,A0), Lout = [HLin | TRes] )
        )
    ;   (   Lout = [HLin | TRes],A0 = Ain)
    ),
    remove_duplicate_lbl(TLin,TRes,A0,Aout).

atomic_list_recur_to_single_list([],[]):-!.
atomic_list_recur_to_single_list(L,R):-!,
    L = [LH|LT], 
    ( is_list(LH) -> atomic_list_recur_to_single_list(LH,RH) ; RH = [LH]), % assume if not list then it's atomic
    atomic_list_recur_to_single_list(LT,RT), append(RH,RT,R).

% ?- atomic_list_recur_to_single_list([ [a,b,c,d],[a,c,[a,c],adb,[a,cd,[adc,sd],a]],a],R).
