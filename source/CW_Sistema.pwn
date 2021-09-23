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

#tryinclude "modulos/CW_Configuracion.pwn"
#tryinclude "modulos/CW_Declaraciones.pwn"
#tryinclude "modulos/CW_Utilidades.pwn"
#tryinclude "modulos/CW_Funciones.pwn"
#tryinclude "modulos/CW_Comandos.pwn"

// Verifica si se incluyen los modulos.
#if !defined CW_CONFIGURACION || !defined CW_UTILIDADES || !defined CW_DECLARACIONES || !defined CW_FUNCIONES || !defined CW_COMANDOS
	#error Error a cargar uno de los modulos.
#endif

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
	if(Jugador[playerid][Jugando])
		QuitarJugador(playerid);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(Jugador[playerid][Jugando])	
		ActualizarPosicionJugador(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case D_MENU_EQUIPOS:
		{
			if(!response){
			    return MostrarMenuEquipos(playerid);
			}else{
				switch(listitem){
					case 0: return IntegrarEquipo(playerid, EQUIPO_ALPHA);
					case 1: return IntegrarEquipo(playerid, EQUIPO_BETA);
					case 2: return IntegrarEquipo(playerid, EQUIPO_ESPECTADOR);
				}
			}
		}
	}
	return 1;
}