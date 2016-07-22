% call by reference
declare
proc {Sqr_ref A B}
   B = A * A
end

% call by varable
  % problem is, I don't know how to call this function
declare
proc {Sqr_var A}
   A := @A * @A
end


% call by value
proc {Sqr_val A}
   C = {NewCell A}
in
   C := @C + 1
   {Browse @C * @C}
end

L = 12
%proc {Sqr_val 12}

% declare
% local l in
%  {Sqr 25 l}
%  {Browse l}
% end


local X Y Z in 
   f(1:X 2:b) = f(a Y)
   f(Z a) = Z
   {Browse [X Y Z]}
end


declare X Y Z in 
X = f(c a)
Y = f(Z b)
{Browse [X Y]}
%X = Y


% See, lists are just tuples, which are just records
local L1 L2 L3 Head Tail in 
   L1 = Head|Tail
   Head = 1
   Tail = 2|nil
   L2 = [1 2]
   {Browse L1==L2}
   L3 = '|'(1:1 2:'|'(2 nil))
   {Browse L1==L3}
end

declare B
if true then {Browse 1} else {Browse 2} end

declare B = 12
declare X = 12

local Max M N P in 
   proc {Max X Y Z}
      if X >= Y then Z = X else Z = Y end 
   end 
   M = 5
   N = 10
   {Max M N P} {Browse P}
end


local 
   Max = proc {$ X Y Z}
             if X >= Y then Z = X
             else Z = Y end 
         end 
   X = 5
   Y = 10
   Z
in 
   {Max X Y Z} {Browse Z}
end

% note that Y is usable on the RHS without declaring, this is because that it's decalred in the outer level -- if Y not declared, the program would use outer one by default. Note that one cannot replace Y on the RHS to be other letters (like Z)
local 
   Y = 1
in 
   local 
      M = f(M Y)
      [X1 K] = L
      L = [1 2]
   in {Browse [Y L]} end 
end

local 
   Y = 1
in 
   local 
      M = f(M Y)
      [X1 !Y] = L
      L = [1 1]
   in {Browse [M L]}
   end 
end



% Binary Tree
proc {Insert Key Value TreeIn ?TreeOut}
   if TreeIn == nil then TreeOut = tree(Key Value nil nil)
   else  
      local tree(K1 V1 T1 T2) = TreeIn in 
         if Key == K1 then TreeOut = tree(Key Value T1 T2)
         elseif Key < K1 then 
             local T in 
                TreeOut = tree(K1 V1 T T2)
                {Insert Key Value T1 T}
             end 
         else 
             local T in 
                TreeOut = tree(K1 V1 T1 T)
                {Insert Key Value T2 T}
             end  
         end 
      end 
   end 
end