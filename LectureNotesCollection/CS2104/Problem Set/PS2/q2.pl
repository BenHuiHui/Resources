
%find the derivative of Expression E, based on variable Var, and put the
% result into R.

derive(Atom,Var,Res):-atomic(Atom),(Var == Atom -> Res is 1; Res is 0).
derive(L+R,Var,Res):-derive(L,Var,R_left),derive(R,Var,R_right),Res = R_left+R_right.
derive(L-R,Var,Res):-derive(L,Var,R_left),derive(R,Var,R_right),Res = R_left-R_right.
derive(L*R,Var,Res):-derive(L,Var,R_left),derive(R,Var,R_right),Res = R_left*R + R_right*L.
derive(L/R,Var,Res):-derive(L,Var,R_left),derive(R,Var,R_right),Res = (R_left*R + R_right*L)/(R*R).








