{- Brian Bowles, 10/29/15, CS 4700 Haskell Assignment -}
module Tree where

{- This is a class to represent a binary search tree. -}
data BinarySearchTree a 
	= Empty
	| Branch (BinarySearchTree a) a (BinarySearchTree a)

{- This function assists the printTree function by creating indentation. -}
print_helper Empty = putStr ""

{- This function prints the values of a given binary search tree. -}
printTree :: Show a => BinarySearchTree a -> IO ()
printTree Empty = putStr "" --Print nothing if tree is empty.
printTree (Branch left val right) = 
	{- Print each portion of the subtree and the proper indentation.-}
	do 
		putStr " "
		printTree left
		putStr " "
		print val
		printTree right

{- This function checks to see if a specific value is in the given
binary search tree. -}
find :: Ord a => a -> BinarySearchTree a -> Bool
find x Empty = False --Value not found if binary search tree is empty.
find x (Branch left val right) =
	{- Determine which subtree to search through until you either find
		it or don't find it. -}
	if val == x
		then True
		else if find x left == True || find x right == True
			then True
		else False

{- This function inserts a value into the given binary search tree. -}
insert :: Ord a => a -> BinarySearchTree a -> BinarySearchTree a
insert x Empty = (Branch Empty x Empty) --Insert value into root if tree is empty.
insert x (Branch left val right) =
	{- Find proper subtree to insert the value. -}	
	if val > x 
		then (Branch (insert x left) val right)
		else (Branch left val (insert x right))
		
{- This function returns the value in the root of the given binary
search tree. Helper function for checkTree. -}
root Empty = 0 --This value doesn't matter.
root (Branch left val right) = val

{- This function checks to make sure the given tree is a binary search tree. -}		
check :: (Num a, Ord a) => BinarySearchTree a -> Bool
check Empty = True --Tree is binary search tree if it's empty.
check (Branch Empty val Empty) = True --Tree is binary search tree if it has one value.
check (Branch Empty val right) =
	{- Tree is binary search tree if root value is less than right value. -}
	if val < root right
		then True
		else False
check (Branch left val Empty) =
	{- Tree is binary search tree if root value is greater than left value. -}
	if val > root left
		then True
		else False
check (Branch left val right) = 
	{- Check the tree for correct properties of binary search tree.
		Return true if it has those properties, false otherwise.-}
	if val <  root right && val > root left
		then  check left && check right
		else False

{- This function applies a specific function to each element of the given
binary search tree. -}
mapTree :: (t -> a) -> BinarySearchTree t -> BinarySearchTree a
mapTree function Empty = Empty --Creates empty binary search tree.
mapTree function (Branch left val right) = 
	{- Applies function to the value and the left and right subtrees
		and creates a new binary search tree with those values. -}
	(Branch (mapTree function left) (function val) (mapTree function right))

{- This function applies a specific function to each element of the given
binary search tree; reducing the values of the nodes as it iterates through. -}
reduceTree :: t -> (t -> t -> t) -> BinarySearchTree t -> t
reduceTree initialVal function Empty = initialVal --Tree becomes reduced simply by returning initial vlaue.
reduceTree initialVal function (Branch Empty val Empty) = function initialVal val --Tree becomes reduces by applying function to root only.
reduceTree initialVal function (Branch left val right) = 
	{- Applies function to each node in the binary search tree combining the nodes into a single value. -}
	function val (function(reduceTree initialVal function left) (reduceTree initialVal function right))

{- This function finds the height of a given binary search tree. -}
height :: (Num a, Ord a) => BinarySearchTree t -> a
height Empty = 0 --Height of binary search tree is zero if it's empty.
height (Branch left val right) = 
	{- Height becomes either the height of the left subtree plus one or the height
		of the left subtree plus one, whichever is greater -}
	if height left > height right
		then height left + 1
		else height right + 1