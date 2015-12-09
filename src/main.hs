module Main where

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
import Fcm

data MainOptions = MainOptions
    { optInput :: String
    , optDelimiter :: String
    , optIgnoreFirst :: Bool
    , optIgnoreLast :: Bool
    , optIgnoreHeader :: Bool
    , optClusters :: Int
    ,optEps :: Float
    ,optEuklid :: Bool
    ,optCenters :: Bool
    ,optOut :: String
    }

instance Options MainOptions where
    defineOptions = pure MainOptions
        <*> simpleOption "input" "1.txt"
            "CSV-file path."
        <*> simpleOption "delimiter" ","
            "CSV delimeter."
        <*> simpleOption "ignoreFirst" False
            "Whether to ignore first column of CSV"
        <*> simpleOption "ignoreLast" False
            "Whether to ignore last column of CSV"
        <*> simpleOption "ignoreHeader" False
            "Whether to ignore header of CSV"
        <*> simpleOption "clusters" 5
            "Number of clusters"
        <*> simpleOption "e" 0.0001
            "Epsilon"
        <*> simpleOption "euklid" False
            "Euklid distance (Hamming by default)"
        <*> simpleOption "centers" False
            "Start from random centers (Random belonging matrix by default)"
        <*> simpleOption "out" ""
            "Output File"    
-- Command line options

main = runCommand $ \opts args -> do
    --reading args
    let fileName = (optInput opts)
    let delimiter = (optDelimiter opts)
    let ignoreFirst = (optIgnoreFirst opts)
    let ignoreLast = (optIgnoreLast opts)
    let ignoreHeader = (optIgnoreHeader opts)
    let c = (optClusters opts)
    let e = (optEps opts)
    let fromCenters = (optCenters opts)
    let d = if (optEuklid opts) then euklidDistance else hammingDistance
    let out = (optOut opts)
    let m = 2
    --reading args



    content <- catch    (readFile fileName)
                        (\e -> do 
                                    let err = show (e :: IOException)
                                    die "Can't read file"
                                    return "")
    let listString = lines content
    let inputMatrix = parseCSV listString delimiter ignoreFirst ignoreLast ignoreHeader
    let n = nrows inputMatrix

    let atrCount = ncols inputMatrix

    g <- newStdGen
    let initialMatrix = if fromCenters then newBMatrix (zero n c) inputMatrix (generateCenters inputMatrix c g) m d else generateMatrix n c g
    let output = prettyMatrix $ fcm inputMatrix initialMatrix m e d
    if null out then putStrLn output else writeFile out output
    --writeFile "output.txt" output

parseCSV list del iF iL iH = fromLists $ ignore (map readFloat $ map (splitOn del) list) iF iL iH