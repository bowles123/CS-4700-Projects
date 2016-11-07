;Brian Bowles, 10/15/15, hypotrochoid.lsp.
(module "postscript.lsp") ;Import the postscript module for drawing.

(ps:translate 200 200) ;Set starting point of drawing.
(ps:line-color 0 0 51)
(ps:line-width 1 1 1)

(define (x a b d t)
	(add (mul (sub a b) (cos t)) (mul (div (cos(mul (sub a b) t)) b) d))
) ;This function returns the value for x based on theta.

(define (y a b d t)
	(add (mul (sub a b) (sin t)) (mul (div (sin (mul (sub a b) t)) b) d))
) ;This function returns the value for y based on theta.

(define (hypotrochoid filename bigR smallR armL numTimes)
	(dotimes (theta (+ (* numTimes 360) 1)) 
		(if (= theta 0) 
			(ps:goto (x bigR smallR armL (mul theta (div 3.14159265359 180))) (y bigR smallR armL (mul theta (div 3.14159265359 180))))
			(ps:drawto (x bigR smallR armL (mul theta (div 3.14159265359 180))) (y bigR smallR armL (mul theta (div 3.14159265359 180))))
		) ;Draw each portion of the hypotrochoid based on the iterations.
	)
	(ps:save filename)
	(exit)
) ;This function draws the hypotrochoid.

(hypotrochoid "C:/Users/Shadow/Desktop/hypotrochoid.ps" 100 20 9 7)	