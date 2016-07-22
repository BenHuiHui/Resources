declare
fun {NoAttact X1 Y1 X2 Y2}
   {Abs X1 - X2} \= {Abs Y1 - Y2}
end

fun {Extend X Y L N} % X,Y: coordinates of X,Y
   case L of
      nil then true
   [] H|T then {NoAttact X Y N H} andthen {Extend X Y T N+1}
   end
end

proc {Run R A}
   case R of
      nil then {Browse A}
   [] _|_ then {ForAll R proc{$ Y}
			    thread if {Extend {Length A}+1 Y A 1}
				   then {Run {List.subtract R Y} {Append A [Y]}}
				   end
			    end
			 end
	       }
   end
end

{Run [1 2 3 4 5 6 7 8] nil}