import Jugadores
import Mazo

main = do
    putStrLn "Bienvenido/a a la Escoba del 15"
    putStr "Por favor, indique la cantidad de jugadores (2-4): "
    cantidad_de_jugadores <- getLine
    let jugadores = crearJugadores (read cantidad_de_jugadores :: Int) crearJugador

    players <- sequence jugadores

    let mazo = crearMazo

    mazoM <- mezclarCartas [] mazo

    let mesa = take 4 mazoM
        mazoMezclado = drop 4 mazoM
        jugadoresListos = comenzarJuego players mesa mazoMezclado 0

    jugadoresTerminados <- jugadoresListos

    --print jugadoresTerminados

    putStrLn "Se acabo"

comenzarJuego :: [Jugador] -> [Carta] -> [Carta] -> Int -> IO [Jugador]
comenzarJuego jugadores mesa mazo num
    | null mazo && cartasJugadores jugadores = return jugadores
    | cartasJugadores jugadores = do
        print "Hola"
        comenzarJuego (servirJugadores jugadores mazo) 
            mesa (drop (length jugadores * 3) mazo) num
    | otherwise = do
        let turno = (jugadores !! num, mesa)

        print $ "Jugador: " ++ show (fst turno)
        --print $ "Mesa: " ++ show (snd turno)

        let turnoTerminado = (Jugador (show (nombre (fst turno))) [] [], snd turno)
        --turnoTerminado = jugar

        let player = fst turnoTerminado
            tapete = snd turnoTerminado
            jugadoresActualizados = reemplazarJugador player jugadores num
            ronda = (num + 1) `mod` length jugadores

        comenzarJuego jugadoresActualizados tapete mazo ronda


jugar :: (Jugador, [Carta]) -> IO (Jugador, [Carta])
jugar turno = do
    putStrLn "Escoba: (S)i - (N)o: "
    return turno
