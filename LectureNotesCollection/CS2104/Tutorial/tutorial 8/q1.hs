-- generate power series
factorial x = foldl (*) 1 [1..x]
--    | x==0 = 1
--    | x>0 = x * (factorial (x-1))

-- evaluate the stream of coefficients
-- seriesa = map(1/) [1..]
coefficients x = x:(zipWith (/) coefficients [1..])

-- series = (map (\x->(1/factorial x)) [0..])
-- seriesx = (map (1/) [1..])
-- series' = 1:(zipWith (*) series' seriesx)
-- ps x = map (\i -> x**i / (factorial (i))) [0,1..]

-- compute until the diff of 2 neighbour ele is less than x
-- approximate (h:t) x
  --   | abs(h- (head t)) > x = h:(approximate t x)
--     | otherwise = [h, head t]

-- compute the sum from the first element until a certain element
-- integral (h:t) = h:(map (h+) (integral t))
-- integral x = map (\i -> x**(i-1)/(factorial i)) [0,1..]

-- appro x = scanl1 (+) (ps x)

-- integrate s = zipWith (/) s [1..]
