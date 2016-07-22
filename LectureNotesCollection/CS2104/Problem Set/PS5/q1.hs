insert a pos l = 
    fst ( foldr 
        (\x (b,c) -> ((if c == pos then x:a:b else (if c==(length l) -1 && pos == length l then a:x:b else x:b)),c+1))
       ((drop pos (if (l == []) then [a] else [])),0) l)
