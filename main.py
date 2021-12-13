from itertools import cycle
from functools import reduce
import random

"""
BIENVENIDA AL JUEGO Y SETEO DEL NUMERO DE JUGADORES
"""
def bienvenida():
    print("Bienvenido/a a la Escoba del 15")
    cantidad = 0
    while cantidad < 2 or cantidad > 4:
        cantidad = input("Por favor, indique la cantidad de jugadores (2-4): ")
        cantidad = int(cantidad)
    return cantidad

"""
GENERACION DEL MAZO DE CARTAS
"""
def generarMazo():
    numeros = list(range(1,8)) + list(range(10,13))
    espadas = list(zip(numeros, cycle(['Espada'])))
    bastos = list(zip(numeros, cycle(['Basto'])))
    oros = list(zip(numeros, cycle(['Oro'])))
    copas = list(zip(numeros, cycle(['Copa'])))
    return espadas + bastos + oros + copas

"""
CREACION DE JUGADORES
"""
def crearJugadores(cantidad):
    lista_jugadores = list(dict())
    for x in range(cantidad):
        jugador = {'nombre': input("Ingrese el nombre del jugador: "), 'cartas': [], 'monton': []}
        lista_jugadores.append(jugador)
    return lista_jugadores

"""
SE MEZCLA TODO EL MAZO
"""
def mezclarMazo(mazo):
    for i in range(len(mazo)):
        indice_aleatorio = random.randint(0, len(mazo) - 1)
        temporal = mazo[i]
        mazo[i] = mazo[indice_aleatorio]
        mazo[indice_aleatorio] = temporal

"""
REPARTO DE CARTAS A LOS JUGADORES
"""
def servirJugadores(mazo, jugadores, cantidad):
    if len(mazo) < cantidad*3:
        return None

    cartas = mazo[0:cantidad*3]
    quitarCartas(mazo, cartas)

    for x in range(3):
        list(map(lambda c, j: j['cartas'].append(c), cartas, jugadores))
        quitarCartas(cartas, cartas[0:cantidad])

def quitarCartas(mazo, cartas):
    for n in cartas:
        mazo.remove(n)

"""
REPARTO DE CARTAS EN LA MESA
"""
def servirMesa(mazo):
    mesa = mazo[0:4]
    quitarCartas(mazo, mesa)

    return mesa

"""
EMPIEZA EL JUEGO
"""
def comienzaJuego(jugadores, mesa):
    turno = []
    for jugador in jugadores:
        turno.append((jugador, mesa))

    for x in range(3):
        list(map(jugar, turno))

def jugar(turno):
    jugador = turno[0]
    mesa = turno[1]

    estadoTurno(jugador, mesa)

    escoba = input('Escoba: (S)i - (N)o: ').upper()
    if escoba == 'S':
        carta_mano_elegida = elegirCartaMano(jugador)
        cartas_mesa_elegidas = elegirCartasMesa(mesa)
        if not verificarEscoba(carta_mano_elegida, cartas_mesa_elegidas):
            descartarCarta(jugador, mesa)
        else:
            actualizarMonton(jugador, mesa, carta_mano_elegida,cartas_mesa_elegidas)
    else:
        descartarCarta(jugador, mesa)

"""
MUESTRA LA MESA Y LA MANO DEL JUGADOR
"""
def estadoTurno(jugador, mesa):
    print('----------------------------------------------------------------------------------')
    print("Mesa: ", mesa)
    print("Jugador: \n")
    print("\tNombre: ", jugador['nombre'])
    print("\tCartas: ", jugador['cartas'])

"""
ELIGE LA CARTA DE LA MANO PARA HACER ESCOBA
"""
def elegirCartaMano(jugador):
    cantidad_cartas_mano = len(jugador['cartas'])
    carta_elegida = 0
    while carta_elegida < 1 or carta_elegida > cantidad_cartas_mano:
        carta_elegida = int(input('Elija su carta: (1-%d): ' % cantidad_cartas_mano))
    return jugador['cartas'][carta_elegida - 1]

"""
ELIGE LA/S CARTA/S DE LAS MESA PARA HACER ESCOBA
"""
def elegirCartasMesa(mesa):
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

"""
VERIFICAMOS QUE SEA ESCOBA
"""
def verificarEscoba(carta_mano, cartas_mesa):
    suma_mesa = reduce(lambda x, y: (x[0] + y[0], x[1] + y[1]), cartas_mesa)[0]
    return carta_mano[0]+suma_mesa == 15

"""
TIRA UNA CARTA DE LA MANO A LA MESA
"""
def descartarCarta(jugador, mesa):
    carta_a_descartar = elegirCartaMano(jugador)
    mesa.append(carta_a_descartar)
    jugador['cartas'].remove(carta_a_descartar)

"""
ACTUALIZA EL MONTON Y LAS CARTAS DE LA MESA
"""
def actualizarMonton(jugador, mesa, carta_mano, cartas_mesa):
    print('Felicitaciones, hiciste escoba !')
    jugador['monton'].append(carta_mano)
    jugador['cartas'].remove(carta_mano)
    jugador['monton'].extend(cartas_mesa)
    quitarCartas(mesa, cartas_mesa)

def main():
    cantidad_de_jugadores = bienvenida()

    mazo = generarMazo()

    jugadores = crearJugadores(cantidad_de_jugadores)

    mezclarMazo(mazo)

    servirJugadores(mazo, jugadores, cantidad_de_jugadores)

    mesa = servirMesa(mazo)

    comienzaJuego(jugadores, mesa)

if __name__ == "__main__":
    main()