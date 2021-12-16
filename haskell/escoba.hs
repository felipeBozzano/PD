import Jugadores

main = do
    putStrLn "Bienvenido/a a la Escoba del 15"
    putStr "Por favor, indique la cantidad de jugadores (2-4): "
    cantidad_de_jugadores <- getLine
    let jugadores = crearJugadores (read cantidad_de_jugadores :: Int) crearJugador

    player <- sequence jugadores

    print player

    putStrLn "Se acabo"
