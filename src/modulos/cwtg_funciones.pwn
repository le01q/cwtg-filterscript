#if defined CWTG_FUNCS
	#endinput
#endif

#define CWTG_FUNCS

InicializarJugador(playerid)
{
	Jugador[playerid][EquipoElegido] = NULO;
	Jugador[playerid][Jugando] = false;
	Jugador[playerid][DialogoActual] = -1;
	ResetearJugador(playerid);
}

InicializarEquipos()
{
	// Resetea los valores de cada equipo.
	ResetearEquipos();

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
	Mundo[InicioAutomatico] = false;
	Mundo[TipoPartida] = ENTRENAMIENTO;
	Mundo[TipoArma] = PD_TIPO_ARMA;
	Mundo[PuntajeMaximo] = PD_PUNTAJE_MAXIMO;
	Mundo[RondaMaxima] = PD_RONDA_MAXIMA;
	Mundo[RondaActual] = 0;
	Mundo[SkinObligatorio] = PD_SKIN_OBLIGATORIO;
	Mundo[Mapa] = AEROPUERTO_SF;
	Mundo[Numero] = PD_NUMERO_MUNDO;
}

EsUnNumero(const texto[])
{
	for (new i = 0, j = strlen(texto); i < j; i++)
		if (texto[i] > '9' || texto[i] < '0')
			return 0;
	return 1;
}

ObtenerColorEquipo(numero)
{
	return (Equipo[numero][Color] >>> 8) & 0xFFFFFF;
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

ObtenerUnicoJugador(equipo)
{
	IterarJugadores(id) if (Jugador[id][EquipoElegido] == equipo) return id;
	return 0;
}

ObtenerEquipoContrario(equipo)
{
	return equipo == EQUIPO_ALPHA ? EQUIPO_BETA : EQUIPO_ALPHA;
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
	if (Mundo[CantidadJugadores] < 0)
		Mundo[CantidadJugadores] = 0;
	format(mensaje, sizeof(mensaje), "[CW] El jugador {%06x}%s {FFFFFF}se salió del mundo (%d jugadores)", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid), Mundo[CantidadJugadores]);
	Jugador[playerid][Jugando] = false;
	AbandonarEquipo(playerid, Jugador[playerid][EquipoElegido]);
	CallLocalFunction("ActualizarPosicionJugador", "i", playerid);
	SetPlayerColor(playerid, BLANCO);
	return EnviarMensajeGlobal(mensaje);
}

ObtenerParametro(numero)
{
	switch (numero)
	{
	case 0:
		return Mundo[Mapa];
	case 1:
		return Mundo[TipoArma];
	case 2:
		return Mundo[TipoPartida];
	case 3:
		return Mundo[RondaMaxima];
	case 4:
		return Mundo[RondaActual];
	case 5:
		return Mundo[PuntajeMaximo];
	}
	return 0;
}

CambiarParametro(playerid, numeroParametro, nuevoValor)
{
	//NombreMapa[Mundo[Mapa]], NombreArma[Mundo[TipoArma]], TipoPartidaNombre[Mundo[TipoPartida]]
	new tmp[MAX_LONGITUD_MENSAJE];

	if (ObtenerParametro(numeroParametro) == nuevoValor)
		return EnviarAdvertencia(playerid, "> No pongas el mismo valor.");

	format(tmp, sizeof(tmp), "{%06x}%s{FFFFFF} ", ObtenerColorJugador(playerid), ObtenerNombreJugador(playerid));
	strcat(tmp, MensajeParametroPartida[numeroParametro][1]);

	switch (numeroParametro)
	{
	case 0:
	{
		Mundo[Mapa] = nuevoValor;
		ReiniciarPosicionJugadores(false);
	}
	case 1:
		Mundo[TipoArma] = nuevoValor;
	case 2:
		Mundo[TipoPartida] = nuevoValor;
	case 3:
		Mundo[RondaMaxima] = nuevoValor;
	case 4:
		Mundo[RondaActual] = nuevoValor;
	case 5:
		Mundo[PuntajeMaximo] = nuevoValor;
	}

	return EnviarMensajeGlobal(tmp);
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

ConvertirATexto(valor)
{
	new tmp[16];
	if (valor)
		format(tmp, sizeof(tmp), "{%06x}Si", VERDE >>> 8 & 0xFFFFFF);
	else
		format(tmp, sizeof(tmp), "{%06x}No", ROJO >>> 8 & 0xFFFFFF);
	return tmp;
}

MostrarMenuConfiguracion(playerid)
{
	new Dialogo[1200], tmp[MAX_LONGITUD_MENSAJE];
	strcat(Dialogo, "Parametro\tSeleccion\n");
	format(tmp, sizeof(tmp), "\nMapa\t%s\nArma actual\t%s\nPartida actual\t%s", NombreMapa[Mundo[Mapa]], NombreArma[Mundo[TipoArma]], TipoPartidaNombre[Mundo[TipoPartida]]);
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nRonda maxima\t%d\nRonda actual\t%d\nPuntaje maximo\t%d", Mundo[RondaMaxima], Mundo[RondaActual], Mundo[PuntajeMaximo]);
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nModificar equipo {%06x}%s{FFFFFF}", ObtenerColorEquipo(EQUIPO_ALPHA), Equipo[EQUIPO_ALPHA][Nombre]);
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nModificar equipo {%06x}%s", ObtenerColorEquipo(EQUIPO_BETA), Equipo[EQUIPO_BETA][Nombre]);
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nEn juego\t%s\nEn pausa\t%s\nInicio automatico\t%s", ConvertirATexto(Mundo[EnJuego]), ConvertirATexto(Mundo[EnPausa]), ConvertirATexto(Mundo[InicioAutomatico]));
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nEquipos bloqueados\t%s\nSkin obligatorio\t%s", ConvertirATexto(Mundo[EquiposBloqueados]), ConvertirATexto(Mundo[SkinObligatorio]));
	strcat(Dialogo, tmp);
	return ShowPlayerDialog(playerid, D_MENU_CONFIGURACION, DIALOG_STYLE_TABLIST_HEADERS, "Configuracion", Dialogo, ">>", "X");
}

MostrarConfiguracionEquipo(playerid, equipo)
{
	new Dialogo[1000], tmp[MAX_LONGITUD_MENSAJE], Titulo[MAX_NOMBRE_EQUIPO + 8];
	format(Titulo, sizeof(Titulo), "{%06x}%s", ObtenerColorEquipo(equipo), Equipo[equipo][Nombre]);
	strcat(Dialogo, "Parametro\tSeleccion\n");
	format(tmp, sizeof(tmp), "\nNombre\t%s\nSkin\t%d\nColor\t{%06x}", Equipo[equipo][Nombre], Equipo[equipo][Skin], ObtenerColorEquipo(equipo));
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nPuntaje\t%d\nPuntaje total\t%d\nRondas\t%d", Equipo[equipo][Puntaje], Equipo[equipo][PuntajeTotal], Equipo[equipo][Rondas]);
	strcat(Dialogo, tmp);
	format(tmp, sizeof(tmp), "\nUnir jugador\nQuitar jugador");
	strcat(Dialogo, tmp);
	return ShowPlayerDialog(playerid, D_CONFIGURACION_EQUIPO, DIALOG_STYLE_TABLIST_HEADERS, Titulo, Dialogo, ">>", "Volver");
}

//Funcion dentro del menu de configuracion de equipos.

MostrarConfiguracionParametro(playerid, titulo[], descripcion[], dialogoid)
{
	return ShowPlayerDialog(playerid, dialogoid, DIALOG_STYLE_INPUT, titulo, descripcion, "Cambiar", "Volver");
}

// Parametros booleanos

CambiarPartidaEnPausa(playerid)
{
	Mundo[EnPausa] = Mundo[EnPausa] ? false : true;
	return MostrarMenuConfiguracion(playerid);
}

CambiarEnPartida(playerid)
{
	Mundo[EnJuego] = Mundo[EnJuego] ? false : true;
	return MostrarMenuConfiguracion(playerid);
}

CambiarInicioAutomatico(playerid)
{
	Mundo[InicioAutomatico] = Mundo[InicioAutomatico] ? false : true;
	return MostrarMenuConfiguracion(playerid);
}

CambiarEquiposBloqueados(playerid)
{
	Mundo[EquiposBloqueados] = Mundo[EquiposBloqueados] ? false : true;
	return MostrarMenuConfiguracion(playerid);
}

CambiarSkinObligatorio(playerid)
{
	Mundo[SkinObligatorio] =  Mundo[SkinObligatorio] ? false : true;
	return MostrarMenuConfiguracion(playerid);
}

/*

Funciones que serviran mas adelante.

ObtenerTipoPartida()
{
	new a = Equipo[EQUIPO_ALPHA][CantidadJugadores], 
		b = Equipo[EQUIPO_BETA][CantidadJugadores],
		Tipo = ENTRENAMIENTO;
	
	if(a == 1 && b == a)
		Tipo = UNO_VS_UNO;

	if((a > 1 && b > 1 ) && a == b)
		Tipo = EN_EQUIPO;

	return Tipo;
}

IniciarPartida()
{
	new Tipo = ObtenerTipoPartida(), tmp[MAX_LONGITUD_MENSAJE],
		Alpha[MAX_NOMBRE_EQUIPO], Beta[MAX_NOMBRE_EQUIPO];

	if(Tipo == ENTRENAMIENTO)
		return 1;
	
	if(Tipo == UNO_VS_UNO)
	{
		format(Alpha, sizeof(Alpha), "%s", ObtenerNombreJugador(ObtenerUnicoJugador(EQUIPO_ALPHA)));
		format(Beta, sizeof(Beta), "%s", ObtenerNombreJugador(ObtenerUnicoJugador(EQUIPO_BETA)));
	}

	if(Tipo == EN_EQUIPO)
	{
		format(Alpha, sizeof(Alpha), "%s", Equipo[EQUIPO_ALPHA][Nombre]);
		format(Beta, sizeof(Beta), "%s", Equipo[EQUIPO_BETA][Nombre]);
	}

	format(tmp, sizeof(tmp), "[CW/TG] La partida %s vs %s ha comenzado.", Alpha, Beta);
	EnviarMensajeGlobal(tmp);

	format(tmp, sizeof(tmp), "[CW/TG] Se juega a %d rondas con %d puntaje maximo.", Mundo[RondaMaxima], Mundo[PuntajeMaximo]);
	EnviarMensajeGlobal(tmp);

	ResetearEquipos();
	IterarJugadoresEnPartida(id)
		ResetearJugador(id);

	return 1;
}

CancelarPartida()
{
	ResetearEquipos();
	IterarJugadoresEnPartida(id)
		ResetearJugador(id);
	EnviarMensajeGlobal("[CW/TG] Se ha cencelado la partida.");
}
*/

AbandonarEquipo(playerid, equipo)
{
	Equipo[equipo][CantidadJugadores]--;
	Jugador[playerid][EquipoElegido] = NULO;
}

ReiniciarPosicionJugadores(enPartida)
{
	IterarJugadores(id) if (enPartida ? Jugador[id][EquipoElegido] != EQUIPO_ESPECTADOR : true)
		CallLocalFunction("ActualizarPosicionJugador", "i", id);
}

EstablecerArmasJugador(playerid)
{
	ResetPlayerWeapons(playerid);
	if (Mundo[TipoArma] == ARMAS_RAPIDAS && Jugador[playerid][EquipoElegido] != EQUIPO_ESPECTADOR)
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
	if (equipo == EQUIPO_ESPECTADOR)
		Iterar(i, 3)
			array[i] = (posicionMapa[Mundo[Mapa]][EQUIPO_ALPHA][i] + posicionMapa[Mundo[Mapa]][EQUIPO_BETA][i]) / 2;
	else
		Iterar(i, 3)
			array[i] = equipo == EQUIPO_ALPHA ? posicionMapa[Mundo[Mapa]][EQUIPO_BETA][i] : posicionMapa[Mundo[Mapa]][EQUIPO_ALPHA][i];
}

ActualizarEquipos(playerid, killerid)
{
	new EquipoAsesino = Jugador[killerid][EquipoElegido], EquipoVictima = Jugador[playerid][EquipoElegido];

	if (EquipoAsesino == EquipoVictima)
	{
		SumarPuntaje(ObtenerEquipoContrario(EquipoAsesino));
		Jugador[playerid][Muertes]++;
	}
	else
	{
		SumarPuntaje(EquipoAsesino);
		Jugador[playerid][Muertes]++;
		Jugador[killerid][Asesinatos]++;
	}

	return 1;
}

ReiniciarPuntajeEquipos()
{
	IterarEquipos(i)
		Equipo[i][Puntaje] = 0;
}

ResetearEquipos()
{
	IterarEquipos(i)
	{
		Equipo[i][Puntaje] = 0;
		Equipo[i][Rondas] = 0;
		Equipo[i][PuntajeTotal] = 0;
	}
}

ResetearJugador(id)
{
	Jugador[id][Damage] = 0;
	Jugador[id][Muertes] = 0;
	Jugador[id][Asesinatos] = 0;
}

SumarPuntaje(numeroEquipo)
{
	Equipo[numeroEquipo][Puntaje]++;
	Equipo[numeroEquipo][PuntajeTotal]++;
	if (Equipo[numeroEquipo][Puntaje] == Mundo[PuntajeMaximo])
		SumarRonda(numeroEquipo);
}

SumarRonda(numeroEquipo)
{
	Mundo[RondaActual]++;
	Equipo[numeroEquipo][Rondas]++;
	ReiniciarPuntajeEquipos();
	return Equipo[numeroEquipo][Rondas] == Mundo[RondaMaxima] ? AnunciarGanador(numeroEquipo, "partida") : AnunciarGanador(numeroEquipo, "ronda");
}

AnunciarMejorJugador(equipo)
{
	// Obtiene el damage del primer jugador.
	new MejorJugador = ObtenerUnicoJugador(equipo);
	new tmp = Jugador[MejorJugador][Damage];

	IterarJugadoresEnPartida(id) if (Jugador[id][EquipoElegido] == equipo) if (Jugador[id][Damage] > tmp)
	{
		// Establece el nuevo mejor jugador.
		tmp = Jugador[id][Damage];
		MejorJugador = id;
	}

	new mensaje[MAX_LONGITUD_MENSAJE];
	format(mensaje, sizeof(mensaje), "[CW] El mejor jugador ha sido {%06x}%s con %d dmg.", ObtenerColorJugador(MejorJugador), ObtenerNombreJugador(MejorJugador), tmp);
	EnviarMensajeGlobal(mensaje);
}

AnunciarDamageJugadores(ganador, perdedor)
{
	new mensaje[MAX_LONGITUD_MENSAJE];
	format(mensaje, sizeof(mensaje), "[1vs1] {%06x}%s {FFFFFF}hizo %d dmg mientras que {%06x}%s {FFFFFF}hizo %d {FFFFFF}dmg.", ObtenerColorJugador(ganador), ObtenerNombreJugador(ganador), Jugador[ganador][Damage], ObtenerColorJugador(perdedor), ObtenerNombreJugador(perdedor), Jugador[perdedor][Damage]);
	EnviarMensajeGlobal(mensaje);
}
AnunciarGanador(equipoGanador, epigrafe[])
{
	new tmp[MAX_LONGITUD_MENSAJE], modo[8], nombreGanador[MAX_NOMBRE_EQUIPO], nombrePerdedor[MAX_NOMBRE_EQUIPO], ganador, perdedor;

	// Se establecen las variables para el ganador y perdedor dependiendo del modo de juego.
	if (Mundo[TipoPartida] == POR_EQUIPO)
	{
		ganador = equipoGanador;
		perdedor = ObtenerEquipoContrario(equipoGanador);
		strcat(nombreGanador, Equipo[ganador][Nombre]);
		strcat(nombrePerdedor, Equipo[perdedor][Nombre]);
		strcat(modo, "CW");
		AnunciarMejorJugador(equipoGanador);
	}
	else
	{
		ganador = ObtenerUnicoJugador(equipoGanador);
		perdedor = ObtenerUnicoJugador(ObtenerEquipoContrario(equipoGanador));
		strcat(nombreGanador, ObtenerNombreJugador(ganador));
		strcat(nombrePerdedor, ObtenerNombreJugador(perdedor));
		strcat(modo, "1vs1");
		AnunciarDamageJugadores(ganador, perdedor);
	}

	if (Equipo[equipoGanador][Rondas] == Mundo[RondaMaxima])
	{
		ResetearEquipos();
		IterarJugadoresEnPartida(id)
			ResetearJugador(id);
	}

	format(tmp, sizeof(tmp), "[%s] {%06x}%s {FFFFFF}ha ganado la %s contra {%06x}%s", modo, ObtenerColorEquipo(equipoGanador), nombreGanador, epigrafe, ObtenerColorEquipo(ObtenerEquipoContrario(equipoGanador)), nombrePerdedor);
	EnviarMensajeGlobal(tmp);
	ReiniciarPosicionJugadores(true);
	return 1;
}

ActualizarDamage(victima, culpable, Float:cantidad)
{
	new EquipoVictima = Jugador[victima][EquipoElegido], EquipoCulpable = Jugador[culpable][EquipoElegido];

	// Si alguno es del equipo espectador, no se tendrá en cuenta.
	if (EquipoVictima == EQUIPO_ESPECTADOR || EquipoCulpable == EQUIPO_ESPECTADOR)
		return 1;

	// Si son equipos iguales se le restará al culpable.
	if (EquipoVictima == EquipoCulpable)
	{
		Jugador[culpable][Damage] -= floatround(cantidad, floatround_ceil);
		EnviarAdvertencia(culpable, "> Has disparado a un compañero.");
	}
	else
		Jugador[culpable][Damage] += floatround(cantidad, floatround_ceil);

	return 1;
}