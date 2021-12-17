{-
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

        let test = (Jugador (nombre player) [] (monton player), snd turno)
            test2 = reemplazarJugador (fst test) jugadoresActualizados num
        comenzarJuego test2 tapete mazo ronda

        {- comenzarJuego jugadoresActualizados tapete mazo ronda -}
-}

{-
jugar :: (Jugador, [Carta]) -> IO (Jugador, [Carta])
jugar turno = do
    putStr "Escoba: (S)i - (N)o: "
    respuesta <- getLine
    putStr "Elija una carta de su mano: "
    cartaMano <- getLine
    let cartaManoElegida = (read cartaMano :: Int) - 1
    jugada turno (escoba respuesta) cartaManoElegida
-}

{-
escoba :: String -> Bool
escoba respuesta = respuesta == "S"
-}

{-
jugada :: (Jugador, [Carta]) -> Bool -> Int -> IO (Jugador, [Carta])
jugada (jugador, mesa) escoba posicionCarta
    | not escoba = return (Jugador (nombre jugador) (filter (/= head cartasQuitar) (cartas jugador)) (monton jugador), mesa ++
    [cartas jugador !! posicionCarta])
    | otherwise = do
        putStr "Cantidad cartas en mesa a usar: "
        cantidadCartasMesa <- getLine
        cartasMesaElegidas <- elegirCartasMesa (read cantidadCartasMesa :: Int) mesa []
        let listaCartas = (cartas jugador !! posicionCarta) : cartasMesaElegidas
        return $ actualizarJugada listaCartas (jugador, mesa) (verificarEscoba listaCartas)
-}

{-
actualizarJugada :: [Carta] -> (Jugador, [Carta]) -> Bool -> (Jugador, [Carta])
actualizarJugada cartasQuitar (jugador, mesa) escoba
    | escoba = (Jugador (nombre jugador) (filter (/= head cartasQuitar) (cartas jugador)) (monton jugador ++ cartasQuitar), 
                filter (`notElem`  tail cartasQuitar) mesa)
    | otherwise = (Jugador (nombre jugador) (filter (/= head cartasQuitar) (cartas jugador)) (monton jugador), 
                    mesa ++ [head cartasQuitar])
-}

----------------------------------------------------------------------------------------------------------------

{-
quitarCarta :: [Carta] -> Int -> [Carta]
quitarCarta cartas posicion
  | null cartas = []
  | posicion == 0 = quitarCarta (tail cartas) (posicion-1)
  | otherwise = head cartas : quitarCarta (tail cartas) (posicion-1)
-}