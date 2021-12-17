"""
    turno = []

    for jugador in jugadores:
        turno.append((jugador, mesa))
"""

"""def elegirCartasMesa(mesa):
    print("Mesa: ", mesa)
    cartas_elegidas = []
    cantidad_cartas_mesa = len(mesa)
    cantidad_cartas_mesa_usar = int(input('Cantidad cartas en mesa a usar: (1-%d): ' % cantidad_cartas_mesa))
    for x in range(cantidad_cartas_mesa_usar):
        carta_elegida = 0
        while carta_elegida < 1 or carta_elegida > cantidad_cartas_mesa:
            carta_elegida = int(
                input('Elija la/s carta/s de la mesa que suma/n 15 con la de su mano: (1-%d): ' % cantidad_cartas_mesa))
        carta_mesa = mesa[carta_elegida - 1]
        cartas_elegidas.append(carta_mesa)
    return cartas_elegidas

def jugar(turno):
    jugador = turno[0]
    mesa = turno[1]

    estadoTurno(jugador, mesa)

    escoba = input('Escoba: (S)i - (N)o: ').upper()
    if escoba == 'S':
        carta_mano_elegida = elegirCartaMano(jugador)
        cartas_mesa_elegidas = elegirCartasMesa(mesa)
        if not verificarEscoba(carta_mano_elegida, cartas_mesa_elegidas):
            print("EL JUGADOR SE HA EQUIVOCADO - Debera descartar una carta")
            descartarCarta(jugador, mesa)
        else:
            actualizarMonton(jugador, mesa, carta_mano_elegida,cartas_mesa_elegidas)
    else:
        print("Debera descartar una carta")
        descartarCarta(jugador, mesa)"""