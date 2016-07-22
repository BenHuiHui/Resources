declare
proc {App X Y R}
   case X
   of nil then R = Y
   [] H|T then R1 {App T Y R1} in R = H|R1
   end
end

declare
fun {Fact N}
   if N==0 then 1 else N*{Fact N-1} end
end


R Z
%{App [1 2 3] [4 5 6] R}
%{Browse R}

%{Browse {Fact 100}}

declare
T = [4 5 6 7]

declare Pascal AddList ShiftLeft ShiftRight
fun {Pascal N}
   if N==1 then [1]
   else
      {AddList {ShiftLeft {Pascal N-1}}
               {ShiftRight {Pascal N-1}}}
   end
end

fun {ShiftLeft L}
   case L of H|T then
      H|{ShiftLeft T}
   else [0] end
end

fun {ShiftRight L} 0|L end

fun {AddList L1 L2}
   case L1 of H1|T1 then
      case L2 of H2|T2 then
	 H1 + H2|{AddList T1 T2}
      end
   else nil end  % the return value
end

declare Ints
fun {Ints N}
   N|{Ints N+1}
end


%{Browse {Pascal 20}}
%L = {Ints 0}
%{Browse L}