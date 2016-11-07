;Brian Bowles, 10/12/15, fractal.lsp.
(module "postscript.lsp") ;Import postscript module for drawing purposes.

(ps:translate 250 250) ;Set beginning point of tip of triangle.
(ps:line-color 0 0 0) ;Set initial color of the line to be drawn.
(ps:line-width 2 2) ;Set the width of the pen.

(define (triangle) 
	(begin
		(ps:goto 0 0)
		(ps:line-color 256 0 256)
		(ps:drawto -50 -100)
		(ps:line-color 256 256 0)
		(ps:drawto 50 -100)
		(ps:line-color 0 256 256)
		(ps:drawto 0 0)
	)
) ;This function draws a triangle in the middle of the page.

(define (upperTriangle)
	(begin
		(ps:line-color 256 0 0)
		(ps:drawto -50 100)
		(ps:line-color 0 256 0)
		(ps:drawto 50 100)
		(ps:line-color 0 0 256)
		(ps:drawto 0 0)
	)
) ;This function draws a triangle, that's rotated 180 degrees, on top of the main triangle.

(define (rightTriangle)
	(begin
		(ps:line-color 256 0 0)
		(ps:drawto 100 50)
		(ps:line-color 0 256 0)
		(ps:drawto 100 -50)
		(ps: line-color 0 0 256)
		(ps:drawto 0 0)
	)
) ;This function draws a triangle, that's rotated 90 degrees, to the right of the main triangle.

(define (leftTriangle)
	(begin
		(ps:line-color 256 0 256)
		(ps:drawto -100 50)
		(ps:line-color 256 256 0)
		(ps:drawto -100 -50)
		(ps:line-color 0 256 256)
		(ps:drawto 0 0)
	)
) ;This function draws a triangle, that's rotated -90 degrees, to the left of the main triangle.

(define (smallerLeftTriangle num)
	(ps:gsave) ;Save original canvas.
	(ps:translate -100 50)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate -45)
	(fractalLeftInner (- num 1)) ;Draw the upper left inner fractal.
	(ps:grestore) ;Restore saved canvas.

	(ps:gsave) ;Save original canvas.
	(ps:translate -100 -50)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate 45)
	(fractalLeftInner (- num 1)) ;Draw the lower left inner fractal.
	(ps:grestore) ;Restore saved canvas.
) ;This function draws the smaller triangles for the left fractal.

(define (smallerRightTriangle numTimes)
	(ps:gsave) ;Save original canvas.
	(ps:translate 100 50)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate 45)
	(fractalRightInner (- numTimes 1)) ;Draw the upper right inner fractal.
	(ps:grestore) ;Restore the saved canvas.

	(ps:gsave) ;Save original canvas.
	(ps:translate 100 -50)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate -45)
	(fractalRightInner (- numTimes 1)) ;Draw the lower right inner triangle.
	(ps:grestore) ;Restore saved canvas.
) ;Draws the smaller triangles for the right fractal.

(define (smallerUpperTriangle number)
	(ps:gsave) ;Save original canvas.
	(ps:translate -50 100)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate 45)
	(fractalUpperInner (- number 1)) ;Draw the upper inner fractals on the left side.
	(ps:grestore) ;Restore saved canvas.

	(ps:gsave) ;Save original canvas.
	(ps:translate 50 100)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate -45)
	(fractalUpperInner (- number 1)) ;Draw the upper inner fractals on the right side.
	(ps:grestore) ;Restore the saved canvas.
) ;This function draws the smaller triangles for the upper fractal.

(define (smallerTriangle file n) 
	(ps:gsave) ;Save original canvas.
	(ps:line-color 0 256 0)
	(ps:translate -50 -100) 
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate -45)
	(fractalInner file (- n 1)) ;Draw the inner fractals on the left side.
	(ps:grestore) ;Restore the saved canvas.

	(ps:gsave) ;Save original canvas.
	(ps:line-color 0 0 256)
	(ps:translate 50 -100)
	(ps:scale 0.5 0.5) ;Scale the triangle by 50%.
	(ps:rotate 45)
	(fractalInner file (- n 1)) ;Draw the inner fractals on the right side.
	(ps:grestore) ;Restore the saved canvas.
) ;This function draws the smaller rotated triangles.

(define (fractal filename times)
	(fractalLeftInner times) ;Draw left fractal.
	(fractalRightInner times) ;Draw right fractal.
	(fractalUpperInner times) ;Draw the upper fractal.
	(fractalInner filename times) ;Draw the main fractal.
	(ps:save filename) ;Save the drawing to a postscript file 
	(exit) ;and exit the program.
) ;This function draws the whole fractal. (Helper function for inner fractal functions).


(define (fractalLeftInner num)
	(if (= num 0)
		(begin
		)
		(begin
			(leftTriangle) ;Draw original left triangle.
			(smallerLeftTriangle num) ;Draw two smaller triangles on the bottom corner.
		)
	)
) ;This function draws the left inner fractal.

(define (fractalRightInner numTimes)
	(if (= numTimes 0)
		(begin
		)
		(begin
			(rightTriangle) ;Draw original right triangle.
			(smallerRightTriangle numTimes) ;Draw two smaller triangles on the bottom corner.
		)
	)
) ;This function draws the right inner fractal.

(define (fractalUpperInner number)
	(if (= number 0)
		(begin
		)
		(begin
			(upperTriangle) ;Draw original upper triangle.
			(smallerUpperTriangle number) ;Draw two smaller triangles on the bottom corner.
		)
	)
) ;This function draws the upper inner fractal.

(define (fractalInner filename times)
	(if (= times 0)
		(begin 
		)
		(begin
			(triangle) ;Draw original triangle.
			(smallerTriangle filename times) ;Draw two smaller triangles on the bottom corner.
		)
	)
) ;This function draws the inner fractal.

(fractal "C:/Users/Shadow/Desktop/fractal.ps" 10)