image(IMG,R) :- atom_concat(IMG,'.jpg',R).

title_helper(-1,_).

% this function depends on title. It cannot be called alone
title_helper(Level,Out_name):-
	(   Level > 0 -> Target_name = 'tempfile_source.jpg'; Target_name = Out_name),
	% get a smaller one
	writef('%w %w %w\n',['convert -scale 50%%x50%%','tempfile_source.jpg','tempfile_source.jpg']),
	% get the left side
	writef('%w %w %w\n',['convert -rotate 90','tempfile_source.jpg','tempfile1.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile1.jpg','tempfile1.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile1.jpg','tempfile1.jpg']),
	writef('%w %w %w %w\n',['convert +append','tempfile1.jpg','tempfile_down.jpg','tempfile1.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile1.jpg','tempfile_double_left.jpg']),
	% combine both
	writef('%w %w %w %w\n',['convert +append','tempfile_double_left.jpg','tempfile_double_right.jpg',Target_name]),
	LowerLevel is Level - 1, title_helper(LowerLevel,Out_name).

title(Level,In,Out):-
	image(In,In_name), image(Out,Out_name),
	(   Level > 0 -> Target_name = 'tempfile_source.jpg'; Target_name = Out_name),
	%create first level temp_generated.jpg
	       % tempfile_source.jpg would be used later in the future.
	writef('%w %w %w\n',['convert -scale 50%%x50%%',In_name,'tempfile_source.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile_source.jpg','tempfile1.jpg']),
	       % tempfile_down.jpg would be used later
	writef('%w %w %w\n',['convert -rotate 90','tempfile1.jpg','tempfile_down.jpg']),
	writef('%w %w %w %w\n',['convert +append','tempfile_source.jpg','tempfile1.jpg','tempfile1.jpg']),
	       % would use the tempfile_double_r.jpg later
	writef('%w %w %w\n',['convert -rotate 90','tempfile1.jpg','tempfile_double_right.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile_double_right.jpg','tempfile_double_left.jpg']),
	writef('%w %w %w\n',['convert -rotate 90','tempfile_double_left.jpg','tempfile_double_left.jpg']),


	writef('%w %w %w %w\n',['convert +append','tempfile_double_left.jpg','tempfile_double_right.jpg',Target_name]),

	% leave the rest of the thing to title_helper()
	Lower_level is (Level-1),title_helper(Lower_level,Out_name).




