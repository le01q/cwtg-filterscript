/**
 * @file cwtg_declaraciones.pwn
 * @author ne0de (https://github.com/ne0de)
 * @brief Declaración de las variables que se usan en el sistema, no modificar.
 * @version 0.1.6
 * @date 2021-10-04
 * 
 * @copyright Copyright (c) 2021 by ne0de.
 * 
 */

#if defined CWTG_DECL
	#endinput
#endif

#define CWTG_DECL

// Enumeraciones del jugador.
enum DATOS_JUGADOR {
	bool:Jugando,
	EquipoElegido,
	DActual,
	Asesinatos,
	Muertes,
	Damage,
	Fps,
	DeltaFps,
};
new Jugador[MAX_PLAYERS][DATOS_JUGADOR];

// Enumeraciones del equipo.
enum DATOS_EQUIPO
{
	Nombre[MAX_NOMBRE_EQUIPO],
	CantidadJugadores,
	Puntaje,
	Rondas,
	PuntajeTotal,
	Color,
	Skin,
};
new Equipo[MAX_EQUIPOS][DATOS_EQUIPO];

// Enumeraciones del mundo.
enum DATOS_MUNDO {
	bool:EnJuego,
	bool:EnPausa,
	bool:EquiposBloqueados,
	bool:InicioAutomatico,
	bool:SkinObligatorio,
	CantidadJugadores,
	TipoPartida,
	TipoArma,
	PuntajeMaximo,
	RondaMaxima,
	RondaActual,
	Numero,
	Mapa,
};
new Mundo[DATOS_MUNDO];

new const NombreMapa[MAX_MAPAS + 1][MAX_TITULO] = {"Aeropuerto LV", "Aeropuerto SF", "Aeropuerto LV"};
new const TipoPartidaNombre[3][MAX_TITULO] = {"Entrenamiento", "Por equipo", "Uno vs Uno"};

new const Armas[3] = {22, 26, 28};
new const NombreArma[MAX_ARMAS + 1][MAX_TITULO] = {"Armas Rapidas", "Solo recortada"};

// Título y descripción para la configuración de un parámetro.
new const EncabezadoParametro[12][2][] = {{"Cambiar el mapa actual", "Escribe el numero de mapa"},
										  {"Cambiar el tipo de arma actual", "Escribe el nuevo tipo de arma"},
										  {"Cambiar modo de juego", "Establece el modo de juego"},
										  {"Cambiar ronda maxima", "Escribe la nueva ronda maxima"},
										  {"Cambiar ronda actual", "Escribe la ronda actual"},
										  {"Cambiar puntaje maximo", "Escribe el puntaje maximo"},
										  // booleanos..
										  {"Partida en juego", "Desactivado por defecto"},
										  {"En pausa", "Desactivado por defecto"},
										  {"Inicio automatico", "Desactivado por defecto"},
										  {"Equipos bloqueados", "Desactivado por defecto"},
										  {"Skin obligatorio", "Activado por defecto"},
										  {"Cambiar color equipo", "Escribe el color (hex) para el equipo"}};

// Identificador para máximos de cada parámetro de la partida.
new MaximoParametroPartida[6] = {MAX_MAPAS, MAX_ARMAS, 2, MAX_RONDAS, 0, MAX_PUNTAJE};

// Mensajes de cada parámetro de la partida.
new const MensajeParametroPartida[6][2][100] = {{"No existe ese mapa registrado", "ha cambiado el mapa"},
												{"No existe ese tipo de arma registrado", "ha cambiado el tipo de arma"},
												{"No existe ese modo de juego registrado", "ha cambiado el modo de juego"},
												{"La ronda que escribiste es erronea", "ha cambiado la ronda maxima"},
												{"El ronda que escribiste es erronea", "ha cambiado la ronda actual"},
												{"El puntaje que escribiste es erronea", "ha cambiado el puntaje maximo"}};

// Posiciones de cada mapa.
new const Float:posicionMapa[3][3][4] = {{// Aeropuerto LV
											{1617.4435, 1629.5537, 11.5618},
											{1497.5476, 1501.1267, 10.3481},
											{1599.2198, 1512.4071, 22.0793}},
										   {// Aeropuerto SF
											{-1313.0103, -55.3676, 13.4844, 225.31},
											{-1186.4745, -182.016, 14.1484, 45.45},
											{-1227.1295, -76.7832, 29.0887, 132.27}},
										   {// Aeropuerto LS
											{2071.0554, -2284.8943, 13.5469, 84.4657},
											{1865.7639, -2299.0803, 13.5469, 288.4241},
											{1921.2411, -2209.7275, 29.3730}}};