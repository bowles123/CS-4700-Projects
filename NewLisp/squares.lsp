;Brian Bowles, 10/11/15, square.lsp.
(module "postscript.lsp") ;Load the canvas module to draw. 

(ps:translate 0 200) ;Set beginning point of the drawing.

(define (drawBlue)
	(ps:fill-color 0 0 51) ;Make fill color blue.
	(ps:rectangle 50 50 true)
	(ps:translate 50 0) ;Move coordinate system.
) ;This function draws a black square.

(define (drawRed)
	(ps:fill-color 204 0 0) ;Make fill color red.
	(ps:rectangle 50 50 true)
	(ps:translate 50 0) ;Move coordinate system.
) ;This function draws a gray square.

(define (squares filename n)
	(if (>= n 1)
		(begin
			(if (= (% n 2) 0)
				(drawRed) ;Draw red square if the number is even.
				(drawBlue) ;Otherwise draw blue square.
			)
			(squares filename (- n 1)) ;Call squares recursively.
		)
		(begin 
			(ps:save filename) ;Save drawings to postscript file
			(exit) ;and exit program.
		)
	)
) ;Function squares draws n number of squares into a specified file.

(squares "C:/Users/Shadow/Desktop/squares.ps" 8) 