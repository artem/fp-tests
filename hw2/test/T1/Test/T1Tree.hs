module Test.T1Tree where
import HW2.T1 (Tree (Leaf, Branch), mapTree)
import Test.Hspec
import Test.Tasty
import Test.Tasty.Hspec
import Data.Foldable

instance Eq a => Eq (Tree a) where
    (==) (Branch al av ar) (Branch bl bv br) = al == bl && av == bv && ar == br
    (==) Leaf Leaf = True
    (==) _ _ = False


tInsert :: Ord a => a -> Tree a -> Tree a
tInsert a Leaf = Branch Leaf a Leaf
tInsert a tree@(Branch l v r)
  | a < v = Branch (tInsert a l) v Leaf
  | a > v = Branch l v (tInsert a r)
  | otherwise = tree


--Creates right "bamboo"
tInsertSec :: Ord a => a -> Tree a -> Tree a
tInsertSec a Leaf = Branch Leaf a Leaf
tInsertSec a (Branch l v r) = tInsertSec a r

tFromList :: Ord a => [a] -> Tree a
tFromList = tFromListIns tInsert


tFromListIns :: Ord a => (a -> Tree a -> Tree a) -> [a] -> Tree a
tFromListIns ins = foldr' ins Leaf

hspecTree :: IO TestTree
hspecTree = testSpec "Tree tests:" $ do
    describe "Tree tests:" $ do
        it "Tree test1" $ mapTree (+ 1) (tFromList [1, 2, 3]) `shouldBe` tFromList [2, 3, 4]
        it "Tree test2" $ mapTree (+ 1) (tFromListIns tInsertSec [1, 2, 3]) `shouldBe` tFromListIns tInsertSec [2, 3, 4]
        it "Tree(f . g) test" $ (mapTree (+ 1) . mapTree (* 10)) (tFromList [1, 2, 3]) `shouldBe` tFromList [11, 21, 31]