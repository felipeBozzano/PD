import Jugadores
import Mazo

{- Funcion principal donde llamamos al resto de funciones -}
main = do
    {- Bienvenida al juego y solicitud de cantidad de jugadores -}
    putStrLn "Bienvenido/a a la Escoba del 15"
    putStr "Por favor, indique la cantidad de jugadores (2-4): "
    cantidad_de_jugadores <- getLine
    {- Creamos x cantidad de jugadores -}
    let jugadores = crearJugadores (read cantidad_de_jugadores :: Int) crearJugador

    {- Convertimos esos [IO Jugador] -> [Jugador] -}
    players <- sequence jugadores

    {- Creamos el mazo de cartas con listas por compresion -}
    let mazo = crearMazo

    {- Mezclamos el mazo y lo vemos a convertir en un [Carta], ya que mezclar cartas devuelve un IO [Carta] -}
    mazoM <- mezclarCartas [] mazo

    {- Servimos la meza, las quitamos del mazoMezclado y comenzamos el juego, 
       el cual termina cuando todos los jugadores se queden sin cartas en la mano
       y no queden cartas en el mazo -}
    let mesa = take 4 mazoM
        mazoMezclado = drop 4 mazoM
        jugadoresListos = comenzarJuego players mesa mazoMezclado 0

    jugadoresTerminados <- jugadoresListos

    {- Calculamos los puntajes, los mostramos y avisamos quien es el ganador -}
    let puntajes = calcularPuntajes jugadoresTerminados

    putStrLn "--------------------------------------------------------------------"
    putStrLn ""
    putStrLn "Los puntajes son los siguientes"
    print puntajes

    putStrLn ""
    putStrLn "--------------------------------------------------------------------"
    putStrLn ("Ganador: " ++ show (snd (last puntajes)) ++ "\n" ++ "\tPuntaje: " ++ show (fst (last puntajes)))
    putStrLn "--------------------------------------------------------------------"

{- Funcion que nos permite generar el ciclo de juego, la cual itera mientras haya cartas en el mazo, y reparte
   cartas a todos los jugadores solo cuando estos se queden sin cartas en su mano -}
comenzarJuego :: [Jugador] -> [Carta] -> [Carta] -> Int -> IO [Jugador]
comenzarJuego jugadores mesa mazo num
    | null mazo && manosVacias jugadores = return jugadores -- Termina el juego
    | manosVacias jugadores = do -- Repartimos cartas cuando los jugadores se queden sin cartas en sus manos
        comenzarJuego (servirJugadores jugadores mazo)
            mesa (drop (length jugadores * 3) mazo) num
    | otherwise = do
        let turno = (jugadores !! num, mesa) -- Un turno es un jugador y la mesa

        {- Mostramos informacion del turno -}    
        putStrLn ""
        putStrLn ("Cartas restantes mazo : " ++ show (length mazo))
        putStrLn "--------------------------------------------------------------------"
        print $ "Jugador: " ++ show (fst turno)
        print $ "Mesa: " ++ show (snd turno)

        {- Se realiza la jugada del turno y se devuelve el mismo actualizado -}
        let jugadaIO = jugar turno
        jugada <- jugadaIO

        {- Con la jugada, actualizamos los datos de ese jugador y calculamos cual es la siguiente ronda (siguiente jugador)-}
        let player = fst jugada
            tapete = snd jugada
            jugadoresActualizados = reemplazarJugador player jugadores num -- Actualizamos el jugador que acaba de jugar
            ronda = (num + 1) `mod` length jugadores -- Proximo jugador

        comenzarJuego jugadoresActualizados tapete mazo ronda -- Llamada recursiva con datos del juego actualizados y nuevo turno

{- Nos permite dar al jugador la flexibilidad de elegir si hacer escoba o no, en ambos casos solicitamos que elija una carta
   de su mano, ya que haga o no escoba debera descartar una carta. En caso positivo realizamos una jugada en la cual se pediran
   que elija cartas de la mesa con las cuales piensa que suma 15 con su carta de la mano elegida -}
jugar :: (Jugador, [Carta]) -> IO (Jugador, [Carta])
jugar turno = do
    putStr "Escoba: (S)i - (N)o: "
    respuesta <- getLine
    putStr "Elija una carta de su mano: "
    cartaMano <- getLine
    let cartaManoElegida = cartas (fst turno) !! ((read cartaMano :: Int) - 1) -- Carta elegida
    jugada turno (respuesta == "S") cartaManoElegida -- Realiza su jugada

{- Cuando no eligio escoba, simplemente descartamos esa carta de su mano, y actuzalizamos la mesa. Pero cuando eligio escoba
   le solicitamos que elija las cartas de la mesa con las cuales quiere jugar y solo actualizamos el monton cuando verificamos 
   que la escoba sea correcta -}
jugada :: (Jugador, [Carta]) -> Bool -> Carta -> IO (Jugador, [Carta])
jugada (jugador, mesa) escoba cartaMano
    {- No pudo hacer escoba, entonces solo descartamos una carta y actualizamos la mesa -}
    | not escoba = return (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador), 
                            mesa ++ [cartaMano])
    | otherwise = do
        putStr "Cantidad cartas en mesa a usar: "
        cantidadCartasMesa <- getLine
        {- Si 'puede' hacer escoba, entonces solicitamos elija las cartas de la mesa -}
        cartasMesaElegidas <- elegirCartasMesa (read cantidadCartasMesa :: Int) mesa []
        {- Verificamos que esa escoba sea correcta, y solo en caso positivo actualizamos el monton, sino simplemente
           descartamos de su mano la carta elegida preivamente -}
        return $ actualizarJugada cartaMano cartasMesaElegidas (jugador, mesa) (verificarEscoba $ cartaMano : cartasMesaElegidas)

{- Nos permite devolver una IO lista de cartas que selecciono el jugador de la mesa -}
elegirCartasMesa :: Int -> [Carta] -> [Carta] -> IO [Carta]
elegirCartasMesa cantidadCartas mesa cartas
    | cantidadCartas > 0 = do
        putStr "Elija la carta de la mesa: "
        posicionCartaMesa <- getLine
        let cartasElegidas  = cartas ++ [mesa !! ((read posicionCartaMesa :: Int)-1)]
        elegirCartasMesa (cantidadCartas - 1) mesa cartasElegidas
    | otherwise = return cartas

{- Devuelve True solo cuando la carta de su mano mas las de la mesa elegidas suman 15 (es Escoba) -}
verificarEscoba :: [Carta] -> Bool
verificarEscoba cartas = sum (map getValor cartas) == 15

{- En caso de que fuera escoba actualizamos la mano del jugador, su monton (agregando la carta de su mano y las de la mesa
   con las cuales hizo escoba) y actualizamos la mesa. En caso de que no hizo escoba simplemente descartamos de su mano la
   carta elegida y la dejamos en la mesa, dejando su monton intacto -}
actualizarJugada :: Carta -> [Carta] -> (Jugador, [Carta]) -> Bool -> (Jugador, [Carta])
actualizarJugada cartaMano cartasMesa (jugador, mesa) escoba
    | escoba = (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador ++ cartaMano : cartasMesa), 
                filter (`notElem` cartasMesa) mesa)
    | otherwise = (Jugador (nombre jugador) (filter (/= cartaMano) (cartas jugador)) (monton jugador), 
                    mesa ++ [cartaMano])
