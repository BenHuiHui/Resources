declare
[Lexer]={Module.link ['lexer.ozf']}

%Examples of calling the function lexer from the Lexer module 
{Browse {Lexer.lexer "let x1=y in x1 end"}} % converts to [tkKwLEt tkId([120 49]) tkEq tkId([121]) tkKwIn tkId([120 49]) tkKwEnd tkEOF]
{Browse {Lexer.lexer "lambda x y1 . y1 x end"}} % converts to [tkKwLambda tkId([120]) tkId([121 49]) tkDot tkId([121 49]) tkId([120]) tkKwEnd tkEOF

%Below write your own code
