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

for jugador in jugadores:
    for x in range(3):
        jugador = entregarCarta(jugador)

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
    print('----------------------------------------------------------------------------------')
    print("Mesa: ", mesa)
    print("Jugador: \n")
    print("\tNombre: ", jugador['nombre'])
    print("\tCartas: ", jugador['cartas'])
    cantidad_cartas_mano = len(jugador['cartas'])
    cantidad_cartas_mesa = len(mesa)
    carta_mano = 0
    cartas_mesa = []
    escoba = input('Escoba: (S)i - (N)o: ').upper()
    if escoba == 'S':
        carta_elegida = 0
        while carta_elegida < 1 or carta_elegida > cantidad_cartas_mano:
            carta_elegida = int(input('Elija su carta: (1-%d): ' %cantidad_cartas_mano))    
        carta_mano = jugador['cartas'][carta_elegida-1]
        jugador['cartas'].remove(carta_mano)
        cantidad_cartas_mano = len(jugador['cartas'])
        print("\tNueva mano de %s: " %jugador['nombre'], jugador['cartas'])
        print("Mesa: ", mesa)
        cantidad_cartas_mesa_usar = int(input('Cantidad cartas en mesa a usar: (1-%d): ' %cantidad_cartas_mesa))
        for x in range(cantidad_cartas_mesa_usar):
            carta_elegida = 0
            while carta_elegida < 1 or carta_elegida > cantidad_cartas_mesa:
                carta_elegida = int(input('Elija la/s carta/s de la mesa que suma/n 15 con la de su mano: (1-%d): ' %cantidad_cartas_mesa))
            carta_mesa = mesa[carta_elegida-1]
            cartas_mesa.append(carta_mesa)
            print("Mesa: ", mesa)
        if verificarEscoba(carta_mano, cartas_mesa):
            print('Felicitaciones, hiciste escoba !')
            jugador['monton'].append(carta_mano)
            for carta in cartas_mesa:
                jugador['monton'].append(carta)
                mesa.remove(carta)
        else:
            print('Escoba incorrecta !')
            descartar = 0
            while descartar < 1 or descartar > cantidad_cartas_mano:
                descartar = int(input('Elija una carta de su mano para dejar en mesa: (1-%d): ' %cantidad_cartas_mano))
            mesa.append(jugador['cartas'][descartar-1])
            jugador['cartas'].remove(jugador['cartas'][descartar-1])
    else:
        descartar = 0
        while descartar < 1 or descartar > cantidad_cartas_mano:
            descartar = int(input('Elija una carta de su mano para dejar en mesa: (1-%d): ' %cantidad_cartas_mano))
        mesa.append(jugador['cartas'][descartar-1])
        jugador['cartas'].remove(jugador['cartas'][descartar-1])
    return jugador

"""
VERIFICAMO QUE SEA ESCOBA
"""
def verificarEscoba(carta_mano, cartas_mesa):
    suma_parcial = carta_mano[0]
    for mesa in cartas_mesa:
        suma_parcial += mesa[0]
    if(suma_parcial == 15):
        return True
    return False

"""
CICLO DE JUEGO
"""
cantida_cartas_mazo = len(mazo)
while  cantida_cartas_mazo > 0:
    for turno in range(3):
        for jugador in jugadores:
            jugador = jugar(jugador)
    for jugador in jugadores:
        for x in range(3):
            jugador = entregarCarta(jugador)

print("Fin del juego, se sumaran los puntos")