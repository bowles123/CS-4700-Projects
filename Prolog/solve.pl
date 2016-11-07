% Brian Bowles, 11/18/15, Prolog Assignment

%-----------------------------------------------------------------------
% The try predicate tries to move down, then left
% if down fails, then right if left fails, etc.
% By reordering the rules, the direction of the
% search in the maze can be changed.
%-----------------------------------------------------------------------
% Down
try(Row, Col, ToRow, Col) :- ToRow is Row + 1.
% Left
try(Row, Col, Row, ToCol) :- ToCol is Col + 1.
% Right
try(Row, Col, Row, ToCol) :- ToCol is Col - 1.
% Up
try(Row, Col, ToRow, Col) :- ToRow is Row - 1.

%-----------------------------------------------------------------------
% The memberOf(X, L) predicate suceeds if X is a member of list L.
%-----------------------------------------------------------------------
memberOf(H, [H|_]). 
memberOf(H, [X|T]) :- X \== H, memberOf(H, T).

%-----------------------------------------------------------------------
% The visit(X, L, NL) predicate suceeds if X is not a member of List L,
% and adds X to list L creating list NL.  If X is already in the list L
% it fails.
%-----------------------------------------------------------------------
visit(H, [], [H]). 
visit(X, [H|T], [H|NL]) :- X \== H, visit(X, T, NL).

%-----------------------------------------------------------------------
% The printCell(Maze, List, Row, Col) predicate prints an individual cell 
% in the maze, if Row, Col is a
%   - barrier then print an x
%   - a corner then print a +
%   - a top or bottom boundary then print a -
%   - a side boundary then print a |
%   - in the list of visited celss, then print a *
%   - by default print a blank
%-----------------------------------------------------------------------
% Print a barrier if it is there.
printCell(Maze, _, Row, Col) :- maze(Maze, Row, Col, barrier), write('x').
% Upper left corner
printCell(_, _, 0, 0) :- write('+').
% Upper right corner
printCell(Maze, _, Row, 0) :- mazeSize(Maze, R1, C1),
								Row is R1 + 1,
								write('+').
% Lower left corner
printCell(Maze, _, 0, Col) :- mazeSize(Maze, R1, C1),
								Col is C1 + 1,
								write('+').
% Lower right corner
printCell(Maze, _, Row, Col) :- mazeSize(Maze, R1, C1),
								Row is R1 + 1, 
								Col is C1 + 1,
								write('+').
% Right boundary
printCell(_, _, 0, _) :- write('-').
% Left boundary
printCell(Maze, _, Row, _) :- mazeSize(Maze, R1, C1),
								Row is R1 + 1,
								write('-').
% Top boundary
printCell(_, _, _, 0) :- write('|').
% Bottom boundary
printCell(Maze, _, _, Col) :- mazeSize(Maze, R1, C1),
								Col is C1 + 1,
								write('|').
% Member of the list
printCell(_, L, Row, Col) :- memberOf((Row,Col), L), write('*').
% Default
printCell(_, _, _, _) :- write(' ').

% You write these, add helper predicates as needed...

% This predicate prints out the elements of a given list of moves made.
% Default
printList([]).
% Print head and call printList recursively.
printList([Head | Tail]) :- write('('),
							write(Head),
							write(')'),
							nl,
							printList(Tail).

% This predicate gets a boundary of the maze.
% Bottom-Right Boundary
mazeBoundary(Maze, R, C) :- mazeSize(Maze, R1, C1),
								R is R1 + 1, C is C1 + 1.
% Right Boundary
mazeBoundary(Maze, R, C) :- mazeSize(Maze, R1, C1),
								R is R1 + 1.
% Bottom Boundary
mazeBoundary(Maze, R, C) :- mazeSize(Maze, R1, C1),
							C is C1 + 1.

							
% This predicate finds the next in the maze to go to.
% Default, no more cells in particular your.
nextCell(Maze, R, C, R1, 0) :- mazeSize(Maze, _, C1),
								C is C1 + 1,
								R1 is R + 1,
								nl.
% Move to next cell in the row.
nextCell(Maze, R, C, R, C1) :- C1 is C + 1.
							
% This predicate loops through the maze printing it cell by cell.
% Base case.
printHelper(List, Maze, R, _) :- mazeSize(Maze, R1, _),
							R > R1 + 1.
% Print cell, move to next cell, then call printHelper recursively.
printHelper(List, Maze, R, C) :- printCell(Maze, List, R, C),
							nextCell(Maze, R, C, R1, C1),
							printHelper(List, Maze, R1, C1).
							
% This predicate prints out a given maze.						
printMaze(List, Maze) :- printHelper(List, Maze, 0, 0).                                                                                                                                 cvnnhfd.

% This predicate tries to move in each direction it can until maze is either solve or can't be solved.
% Base case, print maze and list of moves.
solveHelper(List, Maze, R, C) :- mazeSize(Maze, R, C),
								printMaze(List, Maze),
								printList(List).
% Get maze, try moving, visit cell, then call recursively.
solveHelper(List, Maze, R, C) :-
	maze(Maze, R, C, free),
	try(R, C, R1, C1),
	visit((R1, C1), List, NL),
	solveHelper(NL, Maze, R1, C1).

% This predicate solves a given maze.
solve(Maze) :- solveHelper([(1, 1)], Maze, 1, 1).