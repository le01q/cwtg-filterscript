
#if defined CW_COMANDOS
	#endinput
#endif

// Definicion principal del archivo.
#define CW_COMANDOS

CMD:equipo(playerid, params[])
{
	if(!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW] No estas en el mundo.");
	
	return MostrarMenuEquipos(playerid);
}

CMD:cw(playerid, params[])
{
	if(Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW] Ya estas actualmente en el mundo.");
	
	return UnirJugador(playerid);
}

CMD:cwsalir(playerid, params[])
{
	if(!Jugador[playerid][Jugando])
		return EnviarAdvertencia(playerid, "[CW] No estas en el mundo para salirte.");

	return QuitarJugador(playerid);
}

CMD:data(playerid, params[]){
	new tmp[1000];
	format(tmp, sizeof(tmp), "Jugadores%d, En juego:%d, En pausa:%d, Tipopartida:%d, PuntajeMaximo:%d, RondaMaxima:%d, RondaActual:%d, Numero:%d, Mapa:%d",
	Mundo[CantidadJugadores], Mundo[EnJuego], Mundo[EnPausa], Mundo[TipoPartida], Mundo[PuntajeMaximo], Mundo[RondaMaxima], Mundo[RondaActual], Mundo[Numero], Mundo[Mapa]);
	SendClientMessageToAll(BLANCO, tmp);

	IterarEquipos(i){
		format(tmp, sizeof(tmp), "Nombre:%s, Jugadores:%d, Puntaje:%d, Rondas:%d, Puntajet:%d, Rondast:%d",
		Equipo[i][Nombre], Equipo[i][CantidadJugadores], Equipo[i][Puntaje], Equipo[i][Rondas], Equipo[i][PuntajeTotal], Equipo[i][RondasTotal]);
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
