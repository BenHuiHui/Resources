% Write an Oz function that returns the list of all the prime numbers smaller than its argument.

declare GetPrime TestPrime GetPrimeHelper

fun {TestPrime A T}
   if T < 2 then true
   elseif A mod T == 0 then false
   else {TestPrime A (T-1)}
   end
end

fun {GetPrimeHelper Current Upper}
   if Current > Upper then nil
   elseif {TestPrime Current (Current-1)} then  Current|{GetPrimeHelper (Current+1) Upper}
   else {GetPrimeHelper (Current+1) Upper}
   end
end

fun {GetPrime Upper}
   {GetPrimeHelper 2 Upper}
end


{Browse {GetPrime 20}}