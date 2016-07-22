declare DConsume DProduce
fun {DConsume ?Xs A B Limit}
   if Limit > 0 then
      local X Xr in
	 Xs = X|Xr {DConsume Xr {Max A X} {Min B X}  Limit-1}
      end
   else [A B] end
end
proc {DProduce N Xs}
   case Xs of X|Xr then % this doesn't bound Xs
      X=N*N
      {DProduce N+1 Xr}
   end
end

Zs
thread {DProduce -10 Zs} end
A = thread {DConsume Zs  -10000000  10000000  1000} end
{Browse A}
   
   /*
local Xs S in
   thread {DProduce 0 Xs} end
   thread S = {DConsume Xs 0 150000} end
   {Browse S}
end

declare Buffer
proc {Buffer N Xs Ys}
   local Startup AskLoop in
   fun {Startup N ?Xs}
      if N==0 then Xs
      else Xr in Xs=_|Xr {Startup N-1 Xr} end
   end
   proc {AskLoop Ys ?Xs ?End}
      case Ys of Y|Yr then Xr End2 in
	 Xs = Y|Xr % get elemnet from buffer
	 End = _|End2 %replenish the buffer
	 {AskLoop Yr Xr End2}
      [] nil then End=nil
      end
      End={Startup N Xs}
   in
      {AskLoop Ys Xs End}
   end
end
*/