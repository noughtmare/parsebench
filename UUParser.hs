{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module UUParser where

import Text.ParserCombinators.UU
import Control.Arrow
import Data.Foldable
import Data.List
import Data.Void
-- import qualified Data.ByteString as B

newtype State = State { unState :: String }
type Parser = P State

instance StoresErrors State Void where
  getErrors s = ([],s)

instance Eof State where
  eof = unState >>> null
  deleteAtEnd = unState >>> \case
    "" -> Nothing
    _:rest -> Just (5,State rest)

parseSite :: String -> [(String,String)]
parseSite = parse (p <* pEnd) . State

pTakeWhile :: (Char -> Bool) -> Parser String
pTakeWhile predicate = pSymExt splitState Zero Nothing
  where
    splitState k (State s)
      = let (a,b) = span predicate s
        in if null a
           then k "" (State s)
           else Step (length a) (k a (State b))

pTake :: Int -> Parser String
pTake n = pSymExt splitState (fst (until (snd >>> (== 0)) (Succ *** pred) (Zero,n))) Nothing
  where
    splitState k (State s)
      = let (a,b) = splitAt n s
        in if length a >= n
           then Step n (uncurry k (second State (splitAt n s)))
           else Fail [] []

pString :: String -> Parser String
pString str = pSymExt splitState (foldr (const Succ) Zero str) Nothing
  where
    splitState k (State s)
      = let (a,b) = splitAt n s
            n = length str
        in if str == a
           then Step n (k str (State b))
           else Fail [] []

pEof :: Parser ()
pEof = pSymExt splitState Zero Nothing
  where
   splitState k (State "") = k () (State "")
   splitState _ _ = Fail [] []

p :: Parser [(String,String)]
p = pTakeWhile (/= '<') *> 
       ([] <$ pEof
  <<|> (pString "<td class=\"title\">" *> liftA2 (:) match p)
  <<|> (pTake 1 *> p))

match :: Parser (String,String)
match = pTakeWhile (/= '"')
     *> pTake 1
     *> liftA2 (,) 
               (pTakeWhile (/= '"'))
               (pTake 2 *> pTakeWhile (/= '<'))
