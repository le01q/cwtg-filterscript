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

// Definición principal.
#define NULO -1
#define MAX_EQUIPOS 3
#define MAX_JUGADORES 6
#define MAX_NOMBRE_EQUIPO 24

#define PUNTAJE_MAXIMO 30
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

// Definición de dialogos
enum 
{
	D_MENU_EQUIPOS,
	D_MODO_INFO,
	D_CONFIGURAR
}

#define D_MENU_EQUIPOS 0
#define D_MODO_INFO 1
#define D_CONFIGURAR 2

//  Definición de macros.
#define IterarJugadores(%0) 						\
	for (new %0; %0 <= jugadoresConectados; %0 ++) 	\
		if (IsPlayerConnected(%0))

#define IterarEquipos(%0) for (new %0; %0 < MAX_EQUIPOS; %0 ++)

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
	CantidadJugadores,
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
	NumeroMundo
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
	InicializarMundo();
	InicializarEquipos();
	return 1;
}

public OnPlayerConnect(playerid)
{
	InicializarJugador(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case D_MENU_EQUIPOS:
		{
			if(!response){
			    return 1;
			}else{

			}
		}
	}
	return 1;
}

InicializarJugador(playerid)
{
	Jugador[playerid][EquipoElegido] = NULO;
	Jugador[playerid][Jugando] = false;
	Jugador[playerid][Promedio] = 0;
	Jugador[playerid][Asesinatos] = 0;
	Jugador[playerid][Muertes] = 0;
}

InicializarEquipos()
{

	IterarEquipos(i){
		Equipo[i][Puntaje] = 0;
		Equipo[i][Rondas] = 0;
		Equipo[i][PuntajeTotal] = 0;
		Equipo[i][RondasTotal] = 0;
		Equipo[i][CantidadJugadores] = 0;
	}

	// Se establece los nombres de cada equipo.
	format(Equipo[EQUIPO_ALPHA][Nombre], MAX_NOMBRE_EQUIPO, "Alpha");
	format(Equipo[EQUIPO_BETA][Nombre], MAX_NOMBRE_EQUIPO, "Beta");
	format(Equipo[EQUIPO_ESPECTADOR][Nombre], MAX_NOMBRE_EQUIPO, "Espectador");
}

InicializarMundo()
{
	Mundo[EnJuego] = false;
	Mundo[EnPausa] = false;
	Mundo[EquiposBloqueados] = false;
	Mundo[TipoPartida] = ENTRENAMIENTO;
	Mundo[PuntajeMaximo] = PUNTAJE_MAXIMO;
	Mundo[RondaMaxima] = RONDA_MAXIMA;
	Mundo[RondaActual] = 0;
	Mundo[Mapa] = AEROPUERTO_LS;
	Mundo[NumeroMundo] = 7284;
}

MostrarMenuEquipos(playerid)
{
	new dialogo[48], tmp[72];

	strcat(dialogo, "Equipo\tJugadores\n");

	IterarEquipos(i){
		format(tmp, sizeof(tmp), "\n%s\t%d", Equipo[i][Nombre], Equipo[i][CantidadJugadores]);
		strcat(dialogo, tmp);
	}

	return ShowPlayerDialog(playerid, D_MENU_EQUIPOS, DIALOG_STYLE_TABLIST_HEADERS, "Seleccion de Equipos", dialogo, ">>", "X");
}

MostrarConfiguracionPartida()
{
	// Proximamente
}

MostrarPartidasRealizadas()
{
	// Por si acaso.
}


// Comandos

CMD:equipo(playerid, params[]){
	return MostrarMenuEquipos(playerid);
}

CMD:cw(playerid, params[])
{
	// Se le asigna que entró a jugar por lo tanto...
	Jugador[playerid][Jugando] = true;
}