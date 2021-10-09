/**
 * @file cwtg_utilidades.pwn
 * @author ne0de (https://github.com/ne0de)
 * @brief Macros para facilitar la legibilidad del código, no modificar.
 * @version 0.1.6
 * @date 2021-10-04
 * 
 * @copyright Copyright (c) 2021 by ne0de.
 * 
 */
#if defined CWTG_UTILS
	#endinput
#endif

#define CWTG_UTILS

// For macreado, sencillo.
#define Iterar(%0,%1) \
	for (new %0; %0 < %1; %0 ++)

// Itera cada jugador conectado.
#define IterarJugadores(%0) 						\
	for (new %0; %0 <= Mundo[CantidadJugadores]; %0 ++) 	\
		if (IsPlayerConnected(%0) && Jugador[%0][Jugando])

// Itera jugadores en partida.
#define IterarJugadoresEnPartida(%0) \
	for (new %0; %0 <= Mundo[CantidadJugadores]; %0 ++) \
		if (IsPlayerConnected(%0) && Jugador[%0][Jugando] && Jugador[%0][EquipoElegido] != EQUIPO_ESPECTADOR)

// Itera cada equipo.
#define IterarEquipos(%0) for (new %0; %0 < MAX_EQUIPOS; %0 ++)


