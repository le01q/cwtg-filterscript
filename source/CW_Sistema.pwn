/**
 * @file CW_Sistema.pwn
 * @brief Sistema Clan-War para servidores Freeroam.
 * 
 * @author leo1q (https://github.com/leo1q)
 * @author ne0de (https://github.com/ne0de)
 * 
 * @version 0.1
 * @date 2021-09-21
 * 
 * @copyright Copyright (c) 2021 by ne0de and leo1q - All rights reserved.
 * 
 */

#include <a_samp>
#include <zcmd>

#define NULO -1
#define MAX_EQUIPOS 3
#define MAX_JUGADORES 6
#define MAX_NOMBRE_EQUIPO 24

#define PUNTAJE_MAXIMO 15
#define RONDA_MAXIMA 3

// Definición de mapas.
#define AEROPUERTO_LV 0
#define AEROPUERTO_SF 1
#define AEROPUERTO_LS 2

// Definición de equipos.
#define EQUIPO_ALPHA 0
#define EQUIPO_BETA 1
#define EQUIPO_ESPECTADOR 2

// Definición modos de juego.
#define ENTRENAMIENTO 0
#define POR_EQUIPO 1
#define UNOVSUNO 2

// Definición de colores.
#define BLANCO -1
#define NEUTRO 0xC0C9C9C9
#define GRIS 0x80808080
#define AZUL 0x3624FFFF
#define CYAN 0x88F7F7FF
#define ROJO 0xFF5353FF
#define AMARILLO 0xFFFFBB00

//  Definición de macros.
#define For(% 0)                                      \
	for (new % 0; % 0 <= jugadoresConectados; % 0 ++) \
		if (IsPlayerConnected(% 0))

// Variables del jugador.
enum DATOS_JUGADOR {
	bool:Jugando,
	EquipoElegido,
	Asesinatos,
	Muertes,
	Float:Promedio
};
new Jugador[MAX_PLAYERS][DATOS_JUGADOR];

// Variables del equipo.
enum DATOS_EQUIPO
{
	Nombre[MAX_NOMBRE_EQUIPO],
	CantidadJugadores[MAX_JUGADORES],
	Puntaje,
	Rondas,
	PuntajeTotal,
	RondasTotal,
};
new Equipo[MAX_EQUIPOS][DATOS_EQUIPO];

// Variables del mundo.
enum DATOS_MUNDO {
	bool:EnJuego,
	bool:EnPausa,
	bool:EquiposBloqueados,
	TipoPartida,
	PuntajeMaximo,
	RondaMaxima,
	RondaActual,
	Mapa,
};
new Mundo[DATOS_MUNDO];

/* Posiciones de cada mapa.
new const Float:posicionMapa[7][4][4] =
					  {
						  {// Aeropuerto LV
						   {0.0, 0.0, 0.0},
						   {1617.4435, 1629.5537, 11.5618},
						   {1497.5476, 1501.1267, 10.3481},
						   {1599.2198, 1512.4071, 22.0793}},
						  {// Aeropuerto SF
						   {0.0, 0.0, 0.0},
						   {-1313.0103, -55.3676, 13.4844, 180.0000},
						   {-1186.4745, -182.016, 14.1484, 90.0000},
						   {-1227.1295, -76.7832, 29.0887, 130.0000}},
						  {// Aeropuerto LS
						   {0.0, 0.0, 0.0},
						   {2071.0554, -2284.8943, 13.5469, 84.4657},
						   {1865.7639, -2299.0803, 13.5469, 288.4241},
						   {1921.2411, -2209.7275, 29.3730}}};
*/

public OnFilterScriptInit()
{
	print("\n> Sistema Clan-War cargado correctamente.\n");
	return 1;
}

// Callbacks

public OnGameModeInit()
{
	inicializarMundo();
	inicializarEquipos();
	return 1;
}

public OnPlayerConnect(playerid)
{
	inicializarJugador(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

inicializarJugador(playerid)
{
	Jugador[playerid][EquipoElegido] = NULO;
	Jugador[playerid][Jugando] = false;
	Jugador[playerid][Promedio] = 0;
	Jugador[playerid][Asesinatos] = 0;
	Jugador[playerid][Muertes] = 0;
}

inicializarEquipos()
{

	for (new i = 0; i < MAX_EQUIPOS; i++)
	{
		Equipo[i][CantidadJugadores] = 0;
		Equipo[i][Puntaje] = 0;
		Equipo[i][Rondas] = 0;
		Equipo[i][PuntajeTotal] = 0;
		Equipo[i][RondasTotal] = 0;
	}

	// Se establece los nombres de cada equipo.
	format(Equipo[EQUIPO_ALPHA][Nombre], MAX_NOMBRE_EQUIPO, "Alpha");
	format(Equipo[EQUIPO_BETA][Nombre], MAX_NOMBRE_EQUIPO, "Beta");
	format(Equipo[EQUIPO_ESPECTADOR][Nombre], MAX_NOMBRE_EQUIPO, "Espectador");
}

inicializarMundo()
{
	Mundo[EnJuego] = false;
	Mundo[EnPausa] = false;
	Mundo[EquiposBloqueados] = false;
	Mundo[TipoPartida] = ENTRENAMIENTO;
	Mundo[PuntajeMaximo] = PUNTAJE_MAXIMO;
	Mundo[RondaMaxima] = RONDA_MAXIMA;
	Mundo[RondaActual] = 0;
	Mundo[Mapa] = AEROPUERTO_LS;
}