#if defined CW_FUNCIONES
	#endinput
#endif

// Definicion principal del archivo.
#define CW_FUNCIONES

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

	IterarEquipos(i)
	{
		Equipo[i][Puntaje] = 0;
		Equipo[i][Rondas] = 0;
		Equipo[i][PuntajeTotal] = 0;
		Equipo[i][RondasTotal] = 0;
		Equipo[i][CantidadJugadores] = 0;
	}

	// Se establece los nombres de cada equipo.
	format(Equipo[EQUIPO_ALPHA][Nombre], MAX_NOMBRE_EQUIPO, PD_ALPHA_NOMBRE);
	format(Equipo[EQUIPO_BETA][Nombre], MAX_NOMBRE_EQUIPO, PD_BETA_NOMBRE);
	format(Equipo[EQUIPO_ESPECTADOR][Nombre], MAX_NOMBRE_EQUIPO, PD_ESPECTADOR_NOMBRE);

	// Se establece los colores de cada equipo.
	Equipo[EQUIPO_ALPHA][Color] = PD_ALPHA_COLOR;
	Equipo[EQUIPO_BETA][Color] = PD_BETA_COLOR;
	Equipo[EQUIPO_ESPECTADOR][Color] = PD_ESPECTADOR_COLOR;
}

InicializarMundo()
{
	Mundo[EnJuego] = false;
	Mundo[EnPausa] = false;
	Mundo[EquiposBloqueados] = false;
	Mundo[TipoPartida] = ENTRENAMIENTO;
	Mundo[PuntajeMaximo] = PD_PUNTAJE_MAXIMO;
	Mundo[RondaMaxima] = PD_RONDA_MAXIMA;
	Mundo[RondaActual] = 0;
	Mundo[Mapa] = AEROPUERTO_SF;
	Mundo[Numero] = 7284;
}

ObtenerColorEquipo(numero)
{
	return Equipo[numero][Color] >>> 8;
}

ObtenerColorJugador(playerid)
{
	return GetPlayerColor(playerid) >>> 8;
}

ObtenerNombreJugador(playerid)
{
	new nombre[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nombre, MAX_PLAYER_NAME);
	return nombre;
}

MostrarMenuEquipos(playerid)
{
	new dialogo[MAX_LONGITUD_MENSAJE], tmp[28];

	strcat(dialogo, "Equipo\tJugadores\n");

	IterarEquipos(i)
	{
		format(tmp, sizeof(tmp), "\n{%06x}%s\t%d", ObtenerColorEquipo(i), Equipo[i][Nombre], Equipo[i][CantidadJugadores]);
		strcat(dialogo, tmp);
	}

	return ShowPlayerDialog(playerid, D_MENU_EQUIPOS, DIALOG_STYLE_TABLIST_HEADERS, "Seleccion de Equipos", dialogo, ">>", "X");
}

/*

MostrarConfiguracionPartida()
{
	// Proximamente
}

MostrarPartidasRealizadas()
{
	// Por si acaso.
}¨
*/

EnviarMensajeGlobal(mensaje[])
{
	IterarJugadores(i) if (Jugador[i][Jugando])
		SendClientMessage(i, BLANCO, mensaje);
	return 1;
}

EnviarAdvertencia(playerid, mensaje[])
{
	return SendClientMessage(playerid, AMARILLO, mensaje);
}


ActualizarPosicionJugador(playerid)
{
	new equipo = Jugador[playerid][EquipoElegido];
	SetPlayerPos(playerid, posicionMapa[Mundo[Mapa]][equipo][0], posicionMapa[Mundo[Mapa]][equipo][1], posicionMapa[Mundo[Mapa]][equipo][2]);
}

UnirJugador(playerid)
{
	Jugador[playerid][Jugando] = true;
	SetPlayerVirtualWorld(playerid, Mundo[Numero]);
	Mundo[CantidadJugadores]++;
	new mensaje[MAX_LONGITUD_MENSAJE];
	format(mensaje, sizeof(mensaje), "[CW] El jugador {%06x}%s {FFFFFF}se unió al mundo (%d jugadores)", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid), Mundo[CantidadJugadores]);
	EnviarMensajeGlobal(mensaje);
	return MostrarMenuEquipos(playerid);
}

QuitarJugador(playerid)
{
	new mensaje[MAX_LONGITUD_MENSAJE];
	Mundo[CantidadJugadores]--;
	format(mensaje, sizeof(mensaje), "[CW] El jugador {%06x}%s se salió del mundo (%d jugadores)", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid), Mundo[CantidadJugadores]);
	Jugador[playerid][Jugando] = false;
	AbandonarEquipo(playerid, Jugador[playerid][EquipoElegido]);
	ActualizarPosicionJugador(playerid);
	SetPlayerColor(playerid, BLANCO);
	return EnviarMensajeGlobal(mensaje);
}


IntegrarEquipo(playerid, equipo)
{
	new equipoActual = Jugador[playerid][EquipoElegido];

	if (equipoActual == equipo)
		return MostrarMenuEquipos(playerid);

	if (equipoActual != NULO)
		AbandonarEquipo(playerid, equipoActual);

	new tmp[MAX_LONGITUD_MENSAJE];
	format(tmp, sizeof(tmp), "[CW] %s se integro al equipo %s", ObtenerNombreJugador(playerid), Equipo[equipo][Nombre]);

	Jugador[playerid][EquipoElegido] = equipo;
	Equipo[equipo][CantidadJugadores]++;
	SetPlayerColor(playerid, Equipo[equipo][Color]);

	ActualizarPosicionJugador(playerid);

	return EnviarMensajeGlobal(tmp);
}

AbandonarEquipo(playerid, equipo)
{
	Equipo[equipo][CantidadJugadores]--;
	Jugador[playerid][EquipoElegido] = NULO;
}