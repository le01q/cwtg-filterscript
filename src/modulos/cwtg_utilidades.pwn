#if defined CWTG_UTILS
	#endinput
#endif

#define CWTG_UTILS

// For macreado
#define Iterar(%0,%1) \
	for (new %0; %0 < %1; %0 ++)

// Itera cada jugador conectado.
#define IterarJugadores(%0) 						\
	for (new %0; %0 <= Mundo[CantidadJugadores]; %0 ++) 	\
		if (IsPlayerConnected(%0) && Jugador[%0][Jugando])

// Itera 
#define IterarJugadoresEnPartida(%0) \
	for (new %0; %0 <= Mundo[CantidadJugadores]; %0 ++) \
		if (IsPlayerConnected(%0) && Jugador[%0][Jugando] && Jugador[%0][EquipoElegido] != EQUIPO_ESPECTADOR)

// Itera cada equipo.
#define IterarEquipos(%0) for (new %0; %0 < MAX_EQUIPOS; %0 ++)


