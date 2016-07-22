atomic_list_concat_recur([],''):- !.% recursively concat the atomic list into a single item
atomic_list_concat_recur(L,R):- % recursively concat the atomic list into a single item
    L = [LH|LT], 
    ( is_list(LH) -> atomic_list_concat_recur(LH,RH) ; RH = LH), % assume if not list then it's atomic
    atomic_list_concat_recur(LT,RT), atomic_concat(RH,RT,R).
