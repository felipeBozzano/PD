{-# LANGUAGE FlexibleContexts #-}
module Jugadores
(
    Jugador(..),
    crearJugadores,
    mostrarJugadores
) where

import Mazo

data Jugador = Jugador { nombre::String, cartas::[Carta], monton::[Carta]}

instance Show Jugador where
    show (Jugador nombre cartas monton) = nombre ++ " - Cartas:" ++ show cartas ++ " - Monton:" ++ show monton

crearJugadores :: Int -> [Jugador] -> IO [Jugador]
crearJugadores 0 jugadores = return jugadores
crearJugadores n jugadores = do
    putStr "Por favor, ingrese el nombre del jugador: "
    name <- getLine
    print name
    let nombre = name
        jugador = [Jugador nombre [] []]
        jugadores = jugadores ++ jugador
    print jugador
    {- print jugadores -}
    crearJugadores (n-1) jugadores

mostrarJugadores :: [Jugador] -> [Char]
mostrarJugadores [] = ""
mostrarJugadores (x:xs) = show x ++ mostrarJugadores xs
