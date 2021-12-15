

module Mazo
(
    Mazo(..),
    mezclarCartas
) where

import System.Random

data Palo = Copa | Espada | Oro | Basto deriving Show

data Carta = Carta { valor:: Int, palo:: Palo }
instance Show Carta where
  show (Carta valor palo) = "(" ++ show valor ++ ", " ++ show palo ++ ")"

newtype Mazo = Mazo { cartas :: [Carta] }
instance Show Mazo where
  show (Mazo m) = show m

mezclarCartas :: [Carta] -> [Carta] -> IO [Carta]
mezclarCartas mezclado [] = return mezclado
mezclarCartas mezclado sinMezclar = do
  indiceCartaRandom <- randomRIO (0, length sinMezclar - 1)
  let cartaRandom = sinMezclar !! indiceCartaRandom
      sinMezclarAntes = take indiceCartaRandom sinMezclar
      sinMezclarDesppues = drop (indiceCartaRandom + 1) sinMezclar

  mezclarCartas (cartaRandom:mezclado) (sinMezclarAntes ++ sinMezclarDesppues)

