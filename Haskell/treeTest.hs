import Tree

{- NOTE THESE TESTS ARE NOT EXHAUSTIVE -}
{-**************************************************************
   Some example good trees for testing 
****************************************************************-}
emptyTree = Empty
tree1 = Branch Empty 5 Empty
tree2 = Branch (Branch Empty 3 Empty) 4 (Branch Empty 5 Empty)
tree3 = Branch (Branch Empty 2 (Branch Empty 3 Empty)) 4 (Branch Empty 7 (Branch Empty 9 Empty))
tree4 = Branch 
           (Branch  
             (Branch
               (Branch
                 (Branch
                   (Branch
                     (Branch
                       (Branch Empty 1 Empty)
                       2 Empty)
                     3 Empty)
                   4 Empty)
                 5 Empty)
               6 Empty)
             7 Empty)
           8 Empty
badTree1 = Branch (Branch Empty 3 Empty) 2 (Branch Empty 1 Empty)
badTree2 = Branch (Branch Empty 1 Empty) 2 (Branch Empty 3 (Branch Empty 3 Empty))

{-***************************************************************
   Some example bad trees for testing 
****************************************************************-}
badtree1 = (Branch (Branch Empty 2 Empty) 8 (Branch Empty 1 Empty))
badtree2 = (Branch (Branch Empty 9 Empty) 2 (Branch Empty 8 Empty))

{- testIt takes as input a String and a test, prints the String and
   evaluates the test.
-}
testIt :: (Show t) => (String, t) -> IO ()
testIt (s,f) = do 
  putStr "\n" 
  putStr s
  putStr "\n"
  print (f)

{- main executes a sequence of tests. Each test is an ordered pair
   of (String, t), where t is the test. Add tests as you like or
   remove tests if you like.
-}
main = do 
  {- Tests of printTree -}
  putStr "printTree tree1\n"
  printTree tree1
  putStr "printTree tree2\n"
  printTree tree2
  putStr "printTree tree3\n"
  printTree tree3
  putStr "printTree tree4\n"
  printTree tree4

  {- Tests of find and check -}
  mapM testIt [
    ("find 4 tree1", 
      find 4 tree1
    ),
    ("find 4 tree2", 
      find 4 tree2
    ),
    ("find 4 tree3",
      find 4 tree3
    ),
    ("check tree3",
      check tree3
    ),
    ("check badtree1",
      check badtree1
    )
    ]

  {- Tests of height -}
  mapM testIt [
    ("height tree4",
      height tree4
    ),
    ("height tree3",
      height tree3
    ),
    ("height tree1",
      height tree1
    )
    ]

  {- Tests of reduceTree -}
  mapM testIt [
    ("reduceTree 0 (+) tree1",
      reduceTree 0 (+) tree1
    ),
    ("reduceTree 1 (*) tree3",
      reduceTree 1 (*) tree3
    ),
    ("reduceTree 0 (+) tree4",
      reduceTree 0 (+) tree4
    )
    ]

  {- Tests of mapTree -}
  putStr "mapTree (\\x -> x * x) (insert 1 tree1)\n"
  printTree (mapTree (\x -> x * x) (insert 1 tree1))
  putStr "mapTree (\\x -> x * x) (insert 1 tree3)\n"
  printTree (mapTree (\x -> x * x) (insert 1 tree3))

  {- Tests of insert -}
  putStr "printTree (insert 1 tree1)\n"
  printTree (insert 1 tree1)
  putStr "printTree (insert 2 (insert 1 tree1))\n"
  printTree (insert 2 (insert 1 tree1))
  putStr "printTree (insert 8 (insert 2 (insert 1 tree1)))\n"
  printTree (insert 8 (insert 2 (insert 1 tree1)))