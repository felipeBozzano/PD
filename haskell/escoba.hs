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

    let puntajes = calcularPuntajes jugadoresTerminados

    putStrLn "--------------------------------------------------------------------"
    putStrLn ""
    putStrLn "Los puntajes son los siguientes"
    print puntajes

    putStrLn ""
    putStrLn "--------------------------------------------------------------------"
    putStrLn ("Ganador: " ++ show (snd (last puntajes)) ++ "\n" ++ "\tPuntaje: " ++ show (fst (last puntajes)))
    putStrLn "--------------------------------------------------------------------"

comenzarJuego :: [Jugador] -> [Carta] -> [Carta] -> Int -> IO [Jugador]
comenzarJuego jugadores mesa mazo num
    | null mazo && manosVacias jugadores = return jugadores
    | manosVacias jugadores = do
        comenzarJuego (servirJugadores jugadores mazo)
            mesa (drop (length jugadores * 3) mazo) num
    | otherwise = do
        let turno = (jugadores !! num, mesa)

        putStrLn ""
        putStrLn "--------------------------------------------------------------------"
        print $ "Jugador: " ++ show (fst turno)
        print $ "Mesa: " ++ show (snd turno)

        
        let turnoTerminado = jugar turno
        turnoTerminado1 <- turnoTerminado

        let player = fst turnoTerminado1
            tapete = snd turnoTerminado1
            jugadoresActualizados = reemplazarJugador player jugadores num
            ronda = (num + 1) `mod` length jugadores

        comenzarJuego jugadoresActualizados tapete mazo ronda

jugar :: (Jugador, [Carta]) -> IO (Jugador, [Carta])
jugar turno = do
    putStr "Escoba: (S)i - (N)o: "
    respuesta <- getLine
    putStr "Elija una carta de su mano: "
    cartaMano <- getLine
    let cartaManoElegida = cartas (fst turno) !! ((read cartaMano :: Int) - 1)
    jugada turno (respuesta == "S") cartaManoElegida

jugada :: (Jugador, [Carta]) -> Bool -> Carta -> IO (Jugador, [Carta])
jugada (jugador, mesa) escoba cartaMano
    | not escoba = return (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador), 
                            mesa ++ [cartaMano])
    | otherwise = do
        putStr "Cantidad cartas en mesa a usar: "
        cantidadCartasMesa <- getLine
        cartasMesaElegidas <- elegirCartasMesa (read cantidadCartasMesa :: Int) mesa []
        return $ actualizarJugada cartaMano cartasMesaElegidas (jugador, mesa) (verificarEscoba $ cartaMano : cartasMesaElegidas)

elegirCartasMesa :: Int -> [Carta] -> [Carta] -> IO [Carta]
elegirCartasMesa cantidadCartas mesa cartas
    | cantidadCartas > 0 = do
        putStr "Elija la carta de la mesa: "
        posicionCartaMesa <- getLine
        let cartasElegidas  = cartas ++ [mesa !! ((read posicionCartaMesa :: Int)-1)]
        elegirCartasMesa (cantidadCartas - 1) mesa cartasElegidas
    | otherwise = return cartas

verificarEscoba :: [Carta] -> Bool
verificarEscoba cartas = sum (map getValor cartas) == 15

actualizarJugada :: Carta -> [Carta] -> (Jugador, [Carta]) -> Bool -> (Jugador, [Carta])
actualizarJugada cartaMano cartasMesa (jugador, mesa) escoba
    | escoba = (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador ++ cartaMano : cartasMesa), 
                filter (`notElem` cartasMesa) mesa)
    | otherwise = (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador), 
                    mesa ++ [cartaMano])
