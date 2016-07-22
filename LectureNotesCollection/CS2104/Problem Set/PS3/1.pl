%assumption: all image are of size 640*640

%beside(IMG_a, IMG_b):- IMG_a would be placed on the left of IMG_b.
% Both img has the same size


%rotate(IMG_a):- rotate 90 degree clockwise


% e.g.: beside(rotate(beside(a,rotate(b))),rotate(beside(rotate(a),b)))

% sample code:
% Prog = beside(rotate(beside(a,rotate(b))),rotate(beside(rotate(a),b))),
% montage(Prog,o).

image(IMG,R) :- atom_concat(IMG,'.jpg',R).
% use these two for the mapping of montage
beside(_,_).
rotate(_).

beside(IMG_A, IMG_B,IMG_R):-
	image(IMG_A,A_name), image(IMG_B,B_name), image(IMG_R,R_name),
	writef('%w %w %w\n',['convert -scale 50%%x100%%',A_name,'tempfile_a.jpg']),
	writef('%w %w %w\n',['convert -scale 50%%x100%%',B_name,'tempfile_b.jpg']),
	writef('%w %w %w %w\n',['convert +append','tempfile_a.jpg','tempfile_b.jpg',R_name]).

rotate(IMG_A, IMG_R):-
	image(IMG_A,A_name), image(IMG_R,R_name),
	writef('%w %w %w\n',['convert -rotate 90',A_name,R_name]).
montage(Exp,O):-(
	(   Exp = beside(ExpA,ExpB),
	    atom_concat(O,'_bA',O_tA),atom_concat(O,'_bB',O_tB),
	    (	compound(ExpA)->montage(ExpA,O_tA);true),
	    (	compound(ExpB)->montage(ExpB,O_tB);true),
	    beside(O_tA,O_tB,O)
	);
	(   Exp = rotate(ExpA),
	    atom_concat(O,'_r',O_r),
	    (	compound(ExpA)->montage(ExpA,O_r);true),
	    rotate(O_r,O)
	)),!.













