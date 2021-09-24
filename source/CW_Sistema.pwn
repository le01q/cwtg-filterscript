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

	#if RP_ESTADO
		print("> Sistema Clan-War: refresco de posicion activado.");
		SetTimer("RefrescarPosicion", RP_TIEMPO, true);
	#endif

	return 1;
}

#if RP_ESTADO
forward RefrescarPosicion();
public RefrescarPosicion()
{
    IterarJugadores(i) if (Jugador[i][EquipoElegido] == EQUIPO_ESPECTADOR)
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(i, x, y, z);
		if (z < posicionMapa[Mundo[Mapa]][EQUIPO_ALPHA][2] + 5){
            CallLocalFunction("ActualizarPosicionJugador", "i", i);
			EnviarAdvertencia(i, "Si quieres jugar cambiate de equipo.");
		}
	}
}
#endif

forward ActualizarPosicionJugador(playerid);
public ActualizarPosicionJugador(playerid)
{
	new equipo = Jugador[playerid][EquipoElegido];
	new Float:posicionCamara[3], Float:posicion[4];

	// Establece las posiciones para el jugador.
	ObtenerPosicionCamara(equipo, posicionCamara);
	ObtenerPosicionEquipo(equipo, posicion);

	// Establece el skin del equipo (si es que se encuentra activado)
	if(Mundo[SkinObligatorio])
		SetPlayerSkin(playerid, Equipo[equipo][Skin]);
	
	// Establece las armas al jugador dependiendo del tipo establecido
	EstablecerArmasJugador(playerid);
	
	SetPlayerHealth(playerid, 100);
	SetPlayerCameraPos(playerid, posicionCamara[0], posicionCamara[1], posicionCamara[2]);
	SetPlayerPos(playerid, posicion[0], posicion[1], posicion[2]);
	SetPlayerFacingAngle(playerid, posicion[3]);
}

public OnPlayerConnect(playerid)
{
	InicializarJugador(playerid);
	return 1;
}

CMD:a(playerid, params[]){
	new Float:angulo, tmp[26];
	GetPlayerFacingAngle(playerid, angulo);
	format(tmp, sizeof(tmp), "Angulo: %0.2f", angulo);
	SendClientMessage(playerid, BLANCO, string);
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
		CallLocalFunction("ActualizarPosicionJugador", "i", playerid);
	return 1;
}

public OnPlayerDeath(playerid)
{
	if(Jugador[playerid][Jugando])	
		CallLocalFunction("ActualizarPosicionJugador", "i", playerid);
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