{-# LANGUAGE FlexibleContexts #-}
module Jugadores
(
    Jugador(..),
    crearJugadores,
    crearJugador
) where

import Mazo

data Jugador = Jugador { nombre::String, cartas::[Carta], monton::[Carta]}

instance Show Jugador where
    show (Jugador nombre cartas monton) = nombre ++ " - Cartas:" ++ show cartas ++ " - Monton:" ++ show monton

crearJugadores :: Int -> IO Jugador -> [IO Jugador]
crearJugadores 0 jugador = []
crearJugadores n jugador = jugador : crearJugadores (n-1) crearJugador

crearJugador :: IO Jugador
crearJugador = do
    putStr "Por favor, ingrese el nombre del jugador: "
    name <- getLine
    let nombre = name
        jugador = Jugador nombre [] []
    return jugador

{-
mostrarJugadores :: Show a1 => [IO a1] -> IO (Maybe a2)
mostrarJugadores [] =
    return Nothing
mostrarJugadores x = do
    jugador <- head x
    let string = show jugador
    putStrLn string
    mostrarJugadores $ tail x

crearJugadores :: Int -> [Jugador] -> IO[Jugador]
crearJugadores 0 jugadores =
    return jugadores
crearJugadores n jugadores = do
    putStr "Por favor, ingrese el nombre del jugador: "
    name <- getLine
    let nombre = name
        jugador = Jugador nombre [] []
        jugadores = jugadores ++ [jugador]
    crearJugadores (n-1) jugadores
-}