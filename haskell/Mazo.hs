module Mazo
(
    Palo(..),
    Carta(..),
    getValor,
    getPalo,
    crearMazo,
    mezclarCartas
) where

import System.Random

-- Definimos el tipo de dato Palo
data Palo = Copa | Espada | Oro | Basto deriving (Show, Enum)

-- Definimos el tipo de dato Carta
data Carta = Carta { valor:: Int, palo:: Palo }

-- Redefinimos el Show para Carta
instance Show Carta where
  show (Carta valor palo) = "(" ++ show valor ++ ", " ++ show palo ++ ")"

getValor :: Carta -> Int
getValor = valor

getPalo :: Carta -> Palo
getPalo = palo

crearMazo :: [Carta]
crearMazo = [Carta v p | p <- [Copa ..], v <- [1..7] ++ [10..12]]

mezclarCartas :: [Carta] -> [Carta] -> IO [Carta]
mezclarCartas mezclado [] = return mezclado
mezclarCartas mezclado sinMezclar = do
  indiceCartaRandom <- randomRIO (0, length sinMezclar - 1)
  let cartaRandom = sinMezclar !! indiceCartaRandom
      sinMezclarAntes = take indiceCartaRandom sinMezclar
      sinMezclarDesppues = drop (indiceCartaRandom + 1) sinMezclar

  mezclarCartas (cartaRandom:mezclado) (sinMezclarAntes ++ sinMezclarDesppues)
