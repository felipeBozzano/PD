from itertools import cycle
import random
from typing import Dict

"""
BIENVENIDA AL JUEGO Y SETEO DEL NUMERO DE JUGADORES
"""
print("Bienvenido/a a la Escoba del 15")
cantidad_de_jugadores = 0
while cantidad_de_jugadores < 2 or cantidad_de_jugadores > 4:
    cantidad_de_jugadores = input("Por favor, indique la cantidad de jugadores (2-4): ")
    cantidad_de_jugadores = int(cantidad_de_jugadores)

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

mazo = generarMazo()

print("mazo: ", mazo)

"""
CREACION DE JUGADORES
"""
def crearJugadores():
    lista_jugadores = list(dict())
    for x in range(cantidad_de_jugadores):
        jugador = {'nombre':'', 'cartas':[], 'monton':[]}
        jugador['nombre'] = input("Ingrese el nombre del jugador: ")
        lista_jugadores.append(jugador)
    return lista_jugadores

jugadores = crearJugadores()

"""
REPARTO DE CARTAS A LOS JUGADORES
"""
def entregarCarta(jugador):
    if(len(mazo) == 0):
        return jugador
    carta = random.choice(mazo)
    jugador['cartas'].append(carta)
    mazo.remove(carta)
    return jugador

for x in range(3):
    jugadores = map(entregarCarta, jugadores)

"""
REPARTO DE CARTAS EN LA MESA
"""
def servirMesa():
    mesa = []
    for x in range(4):
        carta = random.choice(mazo)
        mesa.append(carta)
        mazo.remove(carta)
    return mesa

mesa = servirMesa()

"""
EMPIEZA EL JUEGO
"""
def jugar(jugador):
    print("Mesa: ", mesa)
    print("Jugador: \n")
    print("\tNombre: ", jugador['nombre'])
    print("\tCartas: ", jugador['cartas'])
    cantidad_cartas_mano = len(jugador['cartas'])
    cantidad_cartas_mesa = len(mesa)
    respuesta = input('Escoba: (S)i - (N)o: ').upper()
    if respuesta == 'S':
        carta_mano = 0
        while carta_mano < 1 or carta_mano > cantidad_cartas_mano:
            carta_mano = int(input('Elija sus cartas: (1-%d): ' %cantidad_cartas_mano))
        carta_mesa = 0
        while carta_mesa < 1 or carta_mesa > cantidad_cartas_mesa:
            carta_mesa = int(input('Elija carta de la mesa que suma 15 con la de su mano: (1-%d): ' %cantidad_cartas_mesa))
        print('Carta de mano de jugador: ', jugador['cartas'][carta_mano-1])
        print('Carta de meza elejida: ', mesa[carta_mesa-1])
        if (jugador['cartas'][carta_mano-1][0] + mesa[carta_mesa-1][0]) == 15:
            jugador['monton'].append(mesa[carta_mesa-1])
            jugador['monton'].append(jugador['cartas'][carta_mano-1])
            mesa.remove(mesa[carta_mesa-1])
            print("nueva mesa: ", mesa)
            print("nuevo monton jugador: ", jugador['monton'])
    else:
        descartar = 0
        while descartar < 1 or descartar > cantidad_cartas_mano:
            descartar = int(input('Elija una carta de su mano para dejar en mesa: (1-%d): ' %cantidad_cartas_mano))
        mesa.append(jugador['cartas'][descartar-1])
        jugador['cartas'].remove(jugador['cartas'][descartar-1])
        print("nueva mesa: ", mesa)
        print("nueva mano jugador: ", jugador['cartas'])
    return jugador


""" cantida_cartas_mazo = len(mazo)
while  cantida_cartas_mazo > 0:
    print(len(mazo))
    for turno in range(3):
        print('Jugadores: ',list(jugadores))
        print('cantidad jugadores: ', len(list(jugadores)))
        jugadores = map(jugar, jugadores)
            
    for x in range(3):
        print("mazo: ", mazo)
        jugadores = map(entregarCarta, jugadores) """

print("Fin del juego, se sumaran los puntos")