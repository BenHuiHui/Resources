functor
export
   lexer:Lexer
define
   fun {Lexer Xs}
      case Xs of
	 nil then [tkEOF]
      [] X|Xr andthen X==61 then tkEq|{Lexer Xr}
      [] X|Xr andthen X==40 then tkLBk|{Lexer Xr}
      [] X|Xr andthen X==41 then tkRBk|{Lexer Xr}
      [] X|Xr andthen X==46 then tkDot|{Lexer Xr}
      [] X|Y|Z|V|W|Y|Xr andthen X==108 andthen Y==97 andthen Z==109 andthen V==98 andthen W==100 andthen Y==97 then tkKwLambda|{Lexer Xr}
      [] X|Y|Z|Xr andthen X==108 andthen Y==101 andthen Z==116 then tkKwLet|{Lexer Xr}
      [] X|Y|Xr andthen X==105 andthen Y==110 then tkKwIn|{Lexer Xr}
      [] X|Y|Z|Xr andthen X==101 andthen Y==110 andthen Z==100 then tkKwEnd|{Lexer Xr}
      [] X|Xr andthen {Char.isSpace X} then {Lexer Xr}
      [] X|Xr then
	 if {Char.isLower X} orelse {Char.isUpper X} then 	 
	    Rest#Id={GetId Xs nil} in
	    tkId(Id)|{Lexer Rest}
	 else 'error: unrecognized token '#X %[tkError]
	 end
      end
   end

   fun {GetId Xs Acc}
      case Xs of
	 nil then Xs#Acc
      [] X|Xr then
	 if {Char.isLower X} orelse {Char.isUpper X} orelse {Char.isDigit X} then
	    {GetId Xr {Append Acc [X]}}
	 else Xs#Acc
	 end
      [] _ then Xs#Acc %should not happen: input is a list
      end
   end
end