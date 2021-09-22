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

#define NULO 0			
#define MAX_JUGADORES		6	// Cantidad máxima de jugadores en una partida.

// Definición de equipos.
#define EQUIPO_ROJO 		1	
#define EQUIPO_AZUL			2
#define EQUIPO_ESPECTADOR 	3

// Definición modos de juego.
#define ENTRENAMIENTO	1
#define POR_EQUIPO		2
#define UNOVSUNO		3

// Definición de colores.
#define BLANCO		-1
#define NEUTRO   	0xC0C9C9C9
#define GRIS      	0x80808080
#define AZUL      	0x3624FFFF
#define CYAN	    0x88F7F7FF
#define ROJO      	0xFF5353FF
#define AMARILLO 	0xFFFFBB00

//  Definición de macros.
#define For(%0) for(new %0; %0 <= jugadoresConectados; %0++) if(IsPlayerConnected(%0))

// Variables del jugador.
enum DATOS_JUGADOR
{
	Equipo,
	Asesinatos,
	Muertes,
	Float:Promedio
};
new Jugador[MAX_PLAYERS][DATOS_JUGADOR];

// Posiciones de cada mapa.
new const Float:posicionMapa[7][4][4] =
{
	{ // Aeropuerto LV
		{0.0, 0.0, 0.0},
		{1617.4435, 1629.5537, 11.5618},
		{1497.5476, 1501.1267, 10.3481},
		{1599.2198, 1512.4071, 22.0793}
	},{ // Aeropuerto SF
  		{0.0, 0.0, 0.0},
		{-1313.0103, -55.3676, 13.4844, 180.0000},
		{-1186.4745, -182.016, 14.1484, 90.0000},
		{-1227.1295, -76.7832, 29.0887, 130.0000}
	},{ // Aeropuerto LS
		{0.0, 0.0, 0.0},
		{2071.0554, -2284.8943, 13.5469, 84.4657},
		{1865.7639,-2299.0803, 13.5469, 288.4241},
		{1921.2411, -2209.7275, 29.3730}
	}
};

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n> Sistema Clan-War cargado correctamente.\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{

}

#endif

public OnGameModeInit()
{
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
