	/**
 * @file cwtg_sistema.pwn
 * @brief Sistema CW/TG para cualquier gamemode de sa-mp.
 * 
 * @author leo1q (https://github.com/leo1q)
 * @author ne0de (https://github.com/ne0de)
 * 
 * @version 0.1.3
 * @date 2021-09-27
 * 
 * @copyright 2021 by ne0de and leo1q - All rights reserved.
 * @license GNU General Public License v3.0
 */

#include <a_samp>
#include <zcmd>

#tryinclude "modulos/cwtg_configuracion.pwn"
#tryinclude "modulos/cwtg_declaraciones.pwn"
#tryinclude "modulos/cwtg_utilidades.pwn"
#tryinclude "modulos/cwtg_funciones.pwn"
#tryinclude "modulos/cwtg_comandos.pwn"

// Verifica si se incluyen los modulos.
#if !defined CWTG_CONFIG || \
	!defined CWTG_UTILS || \
	!defined CWTG_FUNCS || \
	!defined CWTG_DECL || \
	!defined CWTG_CMDS
	#error Error a cargar uno de los modulos.
#endif

public OnFilterScriptInit()
{
	print("\n> Sistema CW/TG cargado correctamente.\n> Desarrolladores: ne0de y leoq1.");
	return 1;
}

// Callbacks

public OnGameModeInit()
{
	InicializarMundo();
	InicializarEquipos();

	#if RP_ESTADO
		print("> Sistema CW/TG: refresco de posicion para espectadores activado.");
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

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Mundo[EnJuego])
		ActualizarEquipos(playerid, killerid);

	if(Jugador[playerid][Jugando])	
		CallLocalFunction("ActualizarPosicionJugador", "i", playerid);
	
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(Mundo[EnJuego])
		ActualizarDamage(playerid, issuerid, amount);
	return 1;
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case D_MENU_EQUIPOS:
			if(!response)
			    return MostrarMenuEquipos(playerid);
			else{
				switch(listitem){
					case 0: return IntegrarEquipo(playerid, EQUIPO_ALPHA);
					case 1: return IntegrarEquipo(playerid, EQUIPO_BETA);
					case 2: return IntegrarEquipo(playerid, EQUIPO_ESPECTADOR);
				}
			}
		
		case D_MENU_CONFIGURACION:
			if(response)
				switch(listitem)
				{
					case 11: return MostrarConfiguracionEquipo(playerid, EQUIPO_ALPHA); 
					case 12: return MostrarConfiguracionEquipo(playerid, EQUIPO_BETA); 
				}
		
		case D_CONFIGURACION_EQUIPO:
			if(!response)
				return MostrarMenuConfiguracion(playerid);

	}
	return 1;
}
