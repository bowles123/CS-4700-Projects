; Brian Bowles, 10/06/15. This program sorts the items of a list.

(define (insert x lst_)
	(if (= (length lst_) 0)
		(list x) ;Return list of x if rest of list is empty.
		(if (>= (first lst_) x)
			(cons x lst_) ;Return list with x added to begining if x < first element in list.
			(cons (first lst_) (insert x (rest lst_))) ;Insert value in rest of list otherwise and add first of list to beginning of that last.
		)
	)
) ;This function inserts a value into the correct position of a sorted list.

(define (sortList lst)
	(if (= (length lst) 0)
		'()
		(if (= (length lst) 1)
			lst ;List is already sorted if it has only one element, so return it.
			(insert (first lst) (sortList (rest lst))) ;Insert first element of list into the sorted rest of the list.
		)
	)
) ;This function sorts the items in a given list.

(sortList '(3 6 2 7 2 9 33))