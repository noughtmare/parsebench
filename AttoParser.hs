{-# LANGUAGE OverloadedStrings #-}
module AttoParser where

import qualified Data.ByteString.Char8 as B
import qualified Data.Attoparsec.ByteString.Char8 as P
import Control.Applicative

parseSite :: String -> [(String,String)]
parseSite = (\(Right a) -> a) . P.parseOnly p . B.pack

p :: P.Parser [(String,String)]
p = P.takeWhile (/= '<') *>
      ([] <$ P.endOfInput
  <|> ("<td class=\"title\">" *> liftA2 (:) match p)
  <|> (P.take 1 *> p))

match :: P.Parser (String,String)
match = P.takeWhile (/= '"')
     *> P.take 1
     *> liftA2 (,)
               (B.unpack <$> P.takeWhile (/= '"'))
               (P.take 2 *> (B.unpack <$> P.takeWhile (/= '<')))
