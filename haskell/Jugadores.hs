{-# LANGUAGE FlexibleContexts #-}
module Jugadores
(
    Jugador(..),
    crearJugadores,
    crearJugador,
    servirJugadores,
    cartasJugadores,
    reemplazarJugador
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

servirJugador :: [Carta] -> (Jugador,Int) -> Jugador
servirJugador mano (jugador,num)
    | num == 1 = Jugador (nombre jugador) (take 3 mano) (monton jugador)
    | num > 1 = Jugador (nombre jugador) (take 3 $ drop ((num-1)*3) mano) (monton jugador)
    | otherwise = Jugador "Fallo" [] []

servirJugadores :: [Jugador] -> [Carta] -> [Jugador]
servirJugadores jugadores mazo = zipWith (curry (servirJugador mazo)) jugadores [1..length jugadores]

cartasJugadores :: [Jugador] -> Bool
cartasJugadores jugadores = map cartasJugador jugadores == replicate (length jugadores) False

cartasJugador :: Jugador -> Bool
cartasJugador x
    | null (cartas x) = False
    | otherwise = True

reemplazarJugador :: Jugador -> [Jugador] -> Int -> [Jugador]
reemplazarJugador jugador jugadores posicion
    | null jugadores = []
    | posicion == 0 = jugador : reemplazarJugador jugador (tail jugadores) (posicion-1)
    | otherwise = head jugadores : reemplazarJugador jugador (tail jugadores) (posicion-1)
