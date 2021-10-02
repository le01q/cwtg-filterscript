
#if defined CWTG_CMDS
	#endinput
#endif

// Definicion principal del archivo.
#define CWTG_CMDS

CMD:equipo(playerid, params[])
{
	if(!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] No estas en el mundo.");
	
	return MostrarMenuEquipos(playerid);
}

CMD:cwtg(playerid, params[6])
{
	if(Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] Ya estas actualmente en el mundo.");
	
	return UnirJugador(playerid);
}

CMD:cwtgsalir(playerid, params[])
{
	if(!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW/TG] No estas en el mundo para salirte.");

	return QuitarJugador(playerid);
}

CMD:configuracion(playerid, params[])
{
	return MostrarMenuConfiguracion(playerid);
}

CMD:jugadores(playerid, params[]){
	new tmp[1000];
	IterarJugadoresEnPartida(i)
	{
		format(tmp, sizeof(tmp), "Jugador:%d, Nombre:%s, Asesinatos:%d, Muertes:%d, Damage:%d", i, ObtenerNombreJugador(i), Jugador[i][Asesinatos], Jugador[i][Muertes], Jugador[i][Damage]);
		SendClientMessageToAll(BLANCO, tmp);
	}
	return 1;
}

CMD:configurar(playerid, params[]){
	if(!IsPlayerAdmin(playerid))
		return EnviarAdvertencia(playerid, "> Solo los admins pueden configurar.");
	return 1;
}

CMD:data(playerid, params[]){
	new tmp[1000];
	format(tmp, sizeof(tmp), "Jugadores%d, En juego:%d, En pausa:%d, Tipopartida:%d, Tipoarma: %d, PuntajeMaximo:%d, RondaMaxima:%d, RondaActual:%d, Numero:%d, Mapa:%d",
	Mundo[CantidadJugadores], Mundo[EnJuego], Mundo[EnPausa], Mundo[TipoPartida], Mundo[TipoArma], Mundo[PuntajeMaximo], Mundo[RondaMaxima], Mundo[RondaActual], Mundo[Numero], Mundo[Mapa]);
	SendClientMessageToAll(BLANCO, tmp);

	IterarEquipos(i){
		format(tmp, sizeof(tmp), "Nombre:%s, Jugadores:%d, Puntaje:%d, Rondas:%d, Puntajetotal:%d",
		Equipo[i][Nombre], Equipo[i][CantidadJugadores], Equipo[i][Puntaje], Equipo[i][Rondas], Equipo[i][PuntajeTotal]);
		SendClientMessageToAll(BLANCO, tmp);
	}
	return 1;
}

CMD:a(playerid, params[]){
	new Float:angulo, tmp[26];
	GetPlayerFacingAngle(playerid, angulo);
	format(tmp, sizeof(tmp), "Angulo: %0.2f", angulo);
	SendClientMessage(playerid, BLANCO, tmp);
	return 1;
}
