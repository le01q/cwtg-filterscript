
/**
 * @file cwtg_comandos.pwn
 * @author ne0de (https://github.com/ne0de)
 * @brief Archivo que contiene los comandos del sistema.
 * @version 0.1.5
 * @date 2021-10-04
 * 
 * @copyright Copyright (c) 2021 by ne0de.
 * 
 */

#if defined CWTG_CMDS
	#endinput
#endif

// Definicion principal del archivo.
#define CWTG_CMDS

// Para ir al mundo CW/TG.
CMD:cwtg(playerid, params[6])
{
	if (Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] Ya estas actualmente en el mundo.");

	return UnirJugador(playerid);
}

// Cambiar de equipo, solamente si esta en el mundo.
CMD:cwtgequipo(playerid, params[])
{
	if (!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] No estas en el mundo.");

	return MostrarMenuEquipos(playerid);
}

// Salir del mundo, sencillo.
CMD:cwtgsalir(playerid, params[])
{
	if (!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] No estas en el mundo para salirte.");

	return QuitarJugador(playerid);
}

// Configurar la partida, solo admin.
CMD:cwtgconfig(playerid, params[])
{
	if (!IsPlayerAdmin(playerid))
		return EnviarAdvertencia(playerid, "> Solo los admins pueden configurar.");
	return MostrarMenuConfiguracion(playerid);
}

// Obtener información de un jugador.
CMD:cwtgi(playerid, params[])
{
	new id = isnull(params) ? playerid : strval(params);

	if (!IsPlayerConnected(id))
		return EnviarAdvertencia(playerid, "Ese jugador no esta en el mundo.");

	return MostrarInfoJugador(playerid, id);
}