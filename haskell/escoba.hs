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



    let ganador = calcularGanador jugadoresTerminados

    putStrLn ("Ganador: " ++ show (snd ganador) ++ "\n" ++ "\tPuntaje: " ++ show (fst ganador))

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
        print $ "Mesa: " ++ show (snd turno)

        
        let turnoTerminado = jugar turno
        turnoTerminado1 <- turnoTerminado

        let player = fst turnoTerminado1
            tapete = snd turnoTerminado1
            jugadoresActualizados = reemplazarJugador player jugadores num
            ronda = (num + 1) `mod` length jugadores

        let test = (Jugador (nombre player) [] (monton player), snd turno)
            test2 = reemplazarJugador (fst test) jugadoresActualizados num
        comenzarJuego test2 tapete mazo ronda

        {- comenzarJuego jugadoresActualizados tapete mazo ronda -}


jugar :: (Jugador, [Carta]) -> IO (Jugador, [Carta])
jugar turno = do
    putStr "Escoba: (S)i - (N)o: "
    respuesta <- getLine
    putStr "Elija una carta de su mano: "
    cartaMano <- getLine
    let cartaManoElegida = (read cartaMano :: Int) - 1
    jugada turno (escoba respuesta) cartaManoElegida

escoba :: String -> Bool
escoba respuesta = respuesta == "S"

jugada :: (Jugador, [Carta]) -> Bool -> Int -> IO (Jugador, [Carta])
jugada (jugador, mesa) escoba posicionCarta
    | not escoba = return (Jugador (nombre jugador) (quitarCarta (cartas jugador) posicionCarta) (monton jugador), mesa ++
    [cartas jugador !! posicionCarta])
    | otherwise = do
        putStr "Cantidad cartas en mesa a usar: "
        cantidadCartasMesa <- getLine
        cartasMesaElegidas <- elegirCartasMesa (read cantidadCartasMesa :: Int) mesa []
        let listaCartas = (cartas jugador !! posicionCarta) : cartasMesaElegidas
        return $ actualizarJugada listaCartas (jugador, mesa) (verificarEscoba listaCartas)


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

actualizarJugada :: [Carta] -> (Jugador, [Carta]) -> Bool -> (Jugador, [Carta])
actualizarJugada cartasQuitar (jugador, mesa) escoba
    | escoba = (Jugador (nombre jugador) (filter (/= head cartasQuitar) (cartas jugador)) (monton jugador ++ cartasQuitar), filter (`notElem`  tail cartasQuitar) mesa)
    | otherwise = (Jugador (nombre jugador) (filter (/= head cartasQuitar) (cartas jugador)) (monton jugador), mesa ++ [head cartasQuitar])
    
