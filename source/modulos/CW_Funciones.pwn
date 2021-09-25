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

	// Se establece los skins para cada equipo.
	Equipo[EQUIPO_ALPHA][Skin] = PD_ALPHA_SKIN;
	Equipo[EQUIPO_BETA][Skin] = PD_BETA_SKIN;
	Equipo[EQUIPO_ESPECTADOR][Skin] = PD_ESPECTADOR_SKIN;

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
	Mundo[TipoArma] = PD_TIPO_ARMA;
	Mundo[PuntajeMaximo] = PD_PUNTAJE_MAXIMO;
	Mundo[RondaMaxima] = PD_RONDA_MAXIMA;
	Mundo[RondaActual] = 0;
	Mundo[SkinObligatorio] = PD_SKIN_OBLIGATORIO;
	Mundo[Mapa] = AEROPUERTO_SF;
	Mundo[Numero] = PD_NUMERO_MUNDO;
}

ObtenerColorEquipo(numero)
{
	return (Equipo[numero][Color] >>> 8 ) & 0xFFFFFF;
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
	IterarJugadores(i)
		SendClientMessage(i, BLANCO, mensaje);
	return 1;
}

EnviarAdvertencia(playerid, mensaje[])
{
	return SendClientMessage(playerid, AMARILLO, mensaje);
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
	format(mensaje, sizeof(mensaje), "[CW] El jugador {%06x}%s {FFFFFF}se salió del mundo (%d jugadores)", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid), Mundo[CantidadJugadores]);
	Jugador[playerid][Jugando] = false;
	AbandonarEquipo(playerid, Jugador[playerid][EquipoElegido]);
	CallLocalFunction("ActualizarPosicionJugador", "i", playerid);
	SetPlayerColor(playerid, BLANCO);
	return EnviarMensajeGlobal(mensaje);
}

ObtenerUnicoJugador(equipo)
{
	IterarJugadores(id)
	{
		if (Jugador[id][EquipoElegido] == equipo)
			return id;
	}
	
}

IntegrarEquipo(playerid, equipo)
{
	new equipoActual = Jugador[playerid][EquipoElegido];

	if (equipoActual == equipo)
		return 1;

	if (equipoActual != NULO)
		AbandonarEquipo(playerid, equipoActual);

	new tmp[MAX_LONGITUD_MENSAJE];
	format(tmp, sizeof(tmp), "[CW] {%06x}%s {FFFFFF}se integro al equipo {%06x}%s", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid), ObtenerColorEquipo(equipo), Equipo[equipo][Nombre]);

	Jugador[playerid][EquipoElegido] = equipo;
	Equipo[equipo][CantidadJugadores]++;
	SetPlayerColor(playerid, Equipo[equipo][Color]);

	CallLocalFunction("ActualizarPosicionJugador", "i", playerid);

	return EnviarMensajeGlobal(tmp);
}

AbandonarEquipo(playerid, equipo)
{
	Equipo[equipo][CantidadJugadores]--;
	Jugador[playerid][EquipoElegido] = NULO;
}

EstablecerArmasJugador(playerid)
{
	ResetPlayerWeapons(playerid);
	if(Mundo[TipoArma] == ARMAS_RAPIDAS && Jugador[playerid][EquipoElegido] != EQUIPO_ESPECTADOR)
		Iterar(i, 3)
			GivePlayerWeapon(playerid, Armas[i], 9999);
}

ObtenerPosicionEquipo(equipo, Float:array[])
{
	Iterar(i, 4)
		array[i] = posicionMapa[Mundo[Mapa]][equipo][i];
}

ObtenerPosicionCamara(equipo, Float:array[])
{
	if(equipo == EQUIPO_ESPECTADOR)
		Iterar(i, 3)
			array[i] = (posicionMapa[Mundo[Mapa]][EQUIPO_ALPHA][i] + posicionMapa[Mundo[Mapa]][EQUIPO_BETA][i]) / 2;
	else
		Iterar(i, 3)
			array[i] = equipo == EQUIPO_ALPHA ? posicionMapa[Mundo[Mapa]][EQUIPO_BETA][i] : posicionMapa[Mundo[Mapa]][EQUIPO_ALPHA][i];
}

ObtenerEquipoContrario(equipo)
{
	return equipo == EQUIPO_ALPHA ? EQUIPO_BETA : EQUIPO_ALPHA;
}

VerificarTeamKill(playerid, killerid)
{
	if (Mundo[EnJuego] == true)

		new EquipoAsesino = Jugador[killerid][EquipoElegido];
		new EquipoVictima = Jugador[playerid][EquipoElegido];

		EquipoAsesino == EquipoVictima ? SumarPuntaje(ObtenerEquipoContrario(EquipoAsesino)) : SumarPuntaje(EquipoAsesino);
}

SumarPuntaje(numEquipo)
{
	Equipo[numEquipo][Puntaje]++;
	Equipo[numEquipo][PuntajeTotal]++;
	
	if (Equipo[numEquipo][Puntaje] == Mundo[PuntajeMaximo])
	{
		SumarRondas();
	}
}

SumarRondas(numEquipo)
{
	//...
}

VerificarGanadorPartida()
{
	new 
		EquipoGana,
		EquipoPierde;

	if (Equipo[EQUIPO_ALPHA][Rondas] > Equipo[EQUIPO_BETA][Rondas])
	{
		EquipoGana = EQUIPO_ALPHA;
		EquipoPierde = EQUIPO_BETA;
	}
	else
	{
		EquipoGana = EQUIPO_BETA;
		EquipoPierde = EQUIPO_ALPHA;
	}

	if (Mundo[TipoPartida] == POR_EQUIPO) // Si la partida es CW
	{
		new msj[350];
		format(msj, sizeof(msj), "{FFFFFF}[CW] El equipo {%06x}%s {FFFFFF}ha ganado la partida contra {%06x}%s", ObtenerColorEquipo(EquipoGana), Equipo[EquipoGana][Nombre], ObtenerColorEquipo(EquipoPierde), Equipo[EquipoPierde][Nombre]);
		EnviarMensajeGlobal(msj);

	} else if (Mundo[TipoPartida] == UNOVSUNO) { // Si la partida es 1vs1
		new
			JugadorGanador, JugadorPerdedor;

		if (EquipoGana == EQUIPO_ALPHA)
		{
			JugadorGanador = ObtenerUnicoJugador(EQUIPO_ALPHA);
			JugadorPerdedor = ObtenerUnicoJugador(EQUIPO_BETA);
		} else {
			JugadorGanador = ObtenerUnicoJugador(EQUIPO_BETA);
			JugadorPerdedor = ObtenerUnicoJugador(EQUIPO_ALPHA);
		}

		new msj1v1[350];
		format(msj, sizeof(msj), "{FFFFFF}[CW] {%06x}%s ha ganado el enfrentamiento a %{%06}%s", ObtenerColorJugador(JugadorGanador), Jugador[JugadorGanador][Nombre], ObtenerColorJugador(JugadorPerdedor), Jugador[JugadorGanador][Nombre]);
		EnviarMensajeGlobal(msj1v1);
}