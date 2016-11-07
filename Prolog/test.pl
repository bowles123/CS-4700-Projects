% Load the maze.pl file
?- consult(maze).
% Load the solve.pl file
%?- consult(solve).
?- consult(solve).

% Should print a '+'
?- printCell(small, [], 0, 0), nl.

% Should print the small maze
?- printMaze([], small).

% Solve the small maze
?- solve(small).
