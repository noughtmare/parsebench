module Main where

import qualified UUParser (parseSite)
import qualified AttoParser (parseSite)
import System.IO
import Criterion.Main
import Control.DeepSeq

readBenchFile :: IO String
readBenchFile = do
  handle <- openFile "bench.html" ReadMode
  hSetEncoding handle latin1
  hGetContents handle

main :: IO ()
main = do
  site <- readBenchFile
  site `deepseq` defaultMain 
    [ bench "UUParser" $ nf UUParser.parseSite site
    , bench "AttoParser" $ nf AttoParser.parseSite site
    ]
