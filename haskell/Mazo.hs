module Mazo
(
    Palo(..),
    Carta(..),
    getValor,
    getPalo,
    crearMazo,
    mezclarCartas,
    --quitarCarta,
) where

import System.Random

-- Definimos el tipo de dato Palo
data Palo = Copa | Espada | Oro | Basto deriving (Show, Enum, Eq)

-- Definimos el tipo de dato Carta
data Carta = Carta { valor:: Int, palo:: Palo } deriving Eq

-- Redefinimos el Show para Carta
instance Show Carta where
  show (Carta valor palo) = "(" ++ show valor ++ ", " ++ show palo ++ ")"

getValor :: Carta -> Int
getValor carta 
  | valor carta == 12 = 10
  | valor carta == 11 = 9
  | valor carta == 10 = 8
  | otherwise  = valor carta

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
