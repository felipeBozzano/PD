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

-- Obtenemos el valor de la carta parseado
getValor :: Carta -> Int
getValor carta 
  | valor carta == 12 = 10
  | valor carta == 11 = 9
  | valor carta == 10 = 8
  | otherwise  = valor carta

-- Obtenemos el palo de la carta
getPalo :: Carta -> Palo
getPalo = palo

-- Creamos un mazo con listas por comprension
crearMazo :: [Carta]
crearMazo = [Carta v p | p <- [Copa ..], v <- [1..7] ++ [10..12]]

{- Mezclamos las cartas: recibimos una lista vacia donde
 iremos agregando las cartas que quitamos de forma aleatoria del mazo sin mezclar,
 esto lo hacemos hasta que en el mazo sin mezclar no queden mas cartas -}
mezclarCartas :: [Carta] -> [Carta] -> IO [Carta]
mezclarCartas mezclado [] = return mezclado
mezclarCartas mezclado sinMezclar = do
  indiceCartaRandom <- randomRIO (0, length sinMezclar - 1)
  let cartaRandom = sinMezclar !! indiceCartaRandom
      sinMezclarAntes = take indiceCartaRandom sinMezclar
      sinMezclarDesppues = drop (indiceCartaRandom + 1) sinMezclar

  mezclarCartas (cartaRandom:mezclado) (sinMezclarAntes ++ sinMezclarDesppues)
