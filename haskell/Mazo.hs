module Mazo
(
    Palo(..),
    Carta(..),
    getValor,
    getPalo,
    crearCartas,
    crearMazoPalo,
    convertirCartas,
    crearMazo
) where

import System.Random

-- Definimos el tipo de dato Palo
data Palo = Copa | Espada | Oro | Basto deriving Show

-- Definimos el tipo de dato Carta
data Carta = Carta { valor:: Int, palo:: Palo }

-- Redefinimos el Show para Carta
instance Show Carta where
  show (Carta valor palo) = "(" ++ show valor ++ ", " ++ show palo ++ ")"

getValor :: Carta -> Int
getValor = valor

getPalo :: Carta -> Palo
getPalo = palo

crearCartas :: Palo -> [(Int, Palo)]
crearCartas x = zip ([1..7] ++ [10..12]) (replicate 10 x)

crearMazoPalo :: [(Int, Palo)]
crearMazoPalo = crearCartas Espada ++ crearCartas Basto ++ crearCartas Copa ++ crearCartas Oro

convertirCartas :: [(Int, Palo)] -> [Carta]
convertirCartas = map (uncurry Carta)

crearMazo :: [Carta]
crearMazo = convertirCartas crearMazoPalo

--newtype Mazo = Mazo { cartas :: [Carta] }
{-
instance Show Mazo where
  show (Mazo m) = show m
-}

{-
shuffle :: [a] -> IO [a]
shuffle [] = return []
shuffle xs = do randomPosition <- getStdRandom (randomR (0, length xs - 1))
                let (left, a:right) = splitAt randomPosition xs
                fmap (a:) (shuffle (left ++ right))
-}

{-
numerosAleatorios :: IO[Int]
numerosAleatorios = shuffle ([1 .. 7] ++ [10 .. 12])
-}


mezclarCartas :: [Carta] -> [Carta] -> IO [Carta]
mezclarCartas mezclado [] = return mezclado
mezclarCartas mezclado sinMezclar = do
  indiceCartaRandom <- randomRIO (0, length sinMezclar - 1)
  let cartaRandom = sinMezclar !! indiceCartaRandom
      sinMezclarAntes = take indiceCartaRandom sinMezclar
      sinMezclarDesppues = drop (indiceCartaRandom + 1) sinMezclar

  mezclarCartas (cartaRandom:mezclado) (sinMezclarAntes ++ sinMezclarDesppues)
