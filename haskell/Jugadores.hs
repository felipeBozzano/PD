module Jugadores
(
    Jugador(..),
    crearJugadores,
    crearJugador,
    servirJugadores,
    manosVacias,
    reemplazarJugador,
    calcularPuntajes,
) where

import Mazo
import Data.List (sortOn)
import Data.Ord (comparing)

{- Defininmos un nuevo tipo de datos Jugador al cual le redefinimos el Show-}
data Jugador = Jugador { nombre::String, cartas::[Carta], monton::[Carta]}

instance Show Jugador where
    show (Jugador nombre cartas monton) = nombre ++ " - Cartas:" ++ show cartas ++ " - Monton:" ++ show monton

{- Nos permite crear un Jugador con un nombre, una mano vacia y un monton vacio -}
crearJugador :: IO Jugador
crearJugador = do
    putStr "Por favor, ingrese el nombre del jugador: "
    name <- getLine
    let nombre = name
        jugador = Jugador nombre [] []
    return jugador

{- Nos permite crear n jugadores, se llama recursivamente decrementando el contador
   hasta que este llegue a 0, entonces encierra a los jugadores en una lista y la devuelve -}
crearJugadores :: Int -> IO Jugador -> [IO Jugador]
crearJugadores 0 jugador = []
crearJugadores n jugador = jugador : crearJugadores (n-1) crearJugador

{- Entrega a cada jugador 3 cartas del mazo, estas 3 se corresponden con su posicion
    es decir si es el jugador  1 decibe las  3 primeras cartas, cuadno es el jugador 2
    se dropean las 3 primeras cartas y se entregan las 3 nuevas primeras -}
servirJugador :: [Carta] -> (Jugador,Int) -> Jugador
servirJugador mano (jugador,num)
    | num == 1 = Jugador (nombre jugador) (take 3 mano) (monton jugador)
    | num > 1 = Jugador (nombre jugador) (take 3 $ drop ((num-1)*3) mano) (monton jugador)
    | otherwise = Jugador "Fallo" [] []

{- Currificamos la funcion servirJugador para poder zipearla a lo largo de las tuplas jugador, numero.
   Lo cual tiene como resultado que se le entreguen las 3 cartas que corresponden a cada jugador -}
servirJugadores :: [Jugador] -> [Carta] -> [Jugador]
servirJugadores jugadores mazo = zipWith (curry (servirJugador mazo)) jugadores [1..length jugadores]

{- Nos permite saber si todos los jugadorres se quedaron sin cartas en la mano, devuelve True
   en ese caso, y falso en cualquier otro caso -}
manosVacias :: [Jugador] -> Bool
manosVacias jugadores = map manoVacia jugadores == replicate (length jugadores) False

{- Nos permite saber si un jugador se quedo sin cartas en la mano, cuando no tiene cartas en la mano devuelve False -}
manoVacia :: Jugador -> Bool
manoVacia x
    | null (cartas x) = False
    | otherwise = True

{- Nos permite reemplazar un jugador por uno actualizado, esto lo hace cuando esta posicion 0, en todos
   los otros casos simplemte deja intacto a los jugadores, pero cuando llega a la posicion 0 significa que
   encontro el jugador a cambiar y lo descarta y coloca el nuevo jugador -}
reemplazarJugador :: Jugador -> [Jugador] -> Int -> [Jugador]
reemplazarJugador jugador jugadores posicion
    | null jugadores = []
    | posicion == 0 = jugador : reemplazarJugador jugador (tail jugadores) (posicion-1)
    | otherwise = head jugadores : reemplazarJugador jugador (tail jugadores) (posicion-1)

{- Calculamos los puntajes de todos los jugadores y los ordenamos de menor a mayor -}
calcularPuntajes :: [Jugador] -> [(Int, Jugador)]
calcularPuntajes jugadores = sortOn fst (map calularPuntaje jugadores)

{- Sumamos el valor de todas las cargas de cada monton de jugador -}
calularPuntaje :: Jugador -> (Int, Jugador)
calularPuntaje jugador = (sum (map getValor (monton jugador)), jugador)
