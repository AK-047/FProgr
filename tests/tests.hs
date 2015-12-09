module Main where

import Test.HUnit
import Fcm
import Data.Matrix

test1 = TestCase (assertEqual "Euklid distance 1" 5 (euklidDistance [3, 4] [0, 0]))
test2 = TestCase (assertEqual "Euklid distance  2" 0 (euklidDistance [3, 4] [3, 4]))
test3 = TestCase (assertEqual "Hamming distance 1" 10 (hammingDistance [6, 6] [1, 1]))
test4 = TestCase (assertEqual "Hamming distance 2" 0 (hammingDistance [1, 1] [1, 1]))
test5 = TestCase (assertEqual "Epsilon test 1" 0 (epsilon (fromLists [[1, 2, 3],[1, 2, 3]]) (fromLists [[1, 2, 3],[1, 2, 3]])))
test6 = TestCase (assertEqual "Epsilon test 2" 5 (epsilon (fromLists [[1, 2, 3],[1, 2, 3]]) (fromLists [[2, 3, 4],[5, 6, 8]])))
test7 = TestCase (assertEqual "Normalization test" [0.1, 0.3, 0.6] (normalizeRow [1.0, 3.0, 6.0]))
tests = TestList [test1, test2, test3, test4, test5, test6, test7]

main = runTestTT tests