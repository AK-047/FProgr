module Fcm where

import Data.Matrix as M
import Data.List.Split
import Control.Applicative
import Options
import System.Environment
import System.Exit
import System.IO
import Text.Read
import Data.Maybe
import System.Random
import Data.List as L
import Control.Exception
import System.IO.Error
 
fcm x bM m e d
    | epsilon bM newBM > 0.001 = fcm x newBM m e d
    | otherwise = newBM
    where
        newBM = newBMatrix bM x newC m d
        newC = newCenters bM x m



hammingDistance :: Floating a => [a] -> [a] -> a
hammingDistance a b
    | (length a) == (length b) = sum (map (\ (x, y) -> abs(x - y) ) (zip a b))
    | otherwise                = error "Vectors count should be equals."

euklidDistance :: Floating a  => [a] -> [a] -> a
euklidDistance a b
    | (length a) == (length b) = sqrt $ sum (map (\ (x, y) -> (x - y)**2) (zip a b))
    | otherwise                = error "Vectors count should be equals."



--Reading CSV


ignore list iF iL iH
    | iF = ignore (map tail list) False iL iH
    | iL = ignore (map init list) iF False iH
    | iH = ignore (tail list) iF iL False
    | otherwise = list
--Reading CSV

-- Utilities
readFloat :: [String] -> [Double]
readFloat = map read

normalizeRow :: Floating a => [a] -> [a]
normalizeRow row = map (/(sum row)) row
-- Utilities


-- Calculations
generateMatrix n c g = fromLists $ map normalizeRow $ toLists $ fromList n c $ take (n*c) (randoms g :: [Double])

generateCenters input c g = 
    toLists $ fromList c n $ take (n*c) (randoms g :: [Double])
    where
        n = ncols input
        max = maximum $ toList input
        min = minimum $ toList input

newCenters bM iM m =
    calculate
    where
        colSum = map (foldl (\x y -> x + y**m) 0) ( toLists $ M.transpose bM)  -- SUM (M(il))
        tempSum = map (zipWith (\x y -> map (*y**m) x) (toLists iM)) $ (toLists $ M.transpose bM)
        secondSum = map (map sum) (map (L.transpose) ( tempSum)) -- SUM((M(il)**m)Xi)
        calculate =  zipWith (\x y -> map (/y) x) secondSum colSum

newBMatrix u x v m d =  fromLists $ map reverse $ zipWith (\a b -> zipWith (\ q k -> (foldl (\memo vRow -> memo + (((d b vRow)/(d b k))**(2/(m-1)))) 0 v)**(-1)) a v) (toLists u) (toLists x)

epsilon u1 u2 =  maximum $ map abs $ toList $ elementwise (-) u1 u2
--Calculations