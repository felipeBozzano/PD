from itertools import cycle
import random

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

for x in jugadores:
    print(x)

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
    print("Jugador: ", jugador)
    return jugador

while(len(mazo)):
    for turno in range(3):
        jugadores = map(jugar, jugadores)
            
    for x in range(3):
        jugadores = map(entregarCarta, jugadores)

print("Fin del juego, se sumaran los puntos")