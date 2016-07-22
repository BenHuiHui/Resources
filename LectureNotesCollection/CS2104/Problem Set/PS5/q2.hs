-- count the occurence of a number in the list l
count x l = foldr (\ele occ -> if ele==x then occ + 1 else occ) 0 l
