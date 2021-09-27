#if defined CWTG_DECL
	#endinput
#endif

#define CWTG_DECL

// Variables del jugador.
enum DATOS_JUGADOR {
	bool:Jugando,
	EquipoElegido,
	Asesinatos,
	Muertes,
	Damage
};
new Jugador[MAX_PLAYERS][DATOS_JUGADOR];

// Variables del equipo.
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

// Variables del mundo.
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

new const NombreMapa[][] = {"Aeropuerto LV", "Aeropuerto SF", "Aeropuerto LV"};
new const TipoPartidaNombre[][] = {"Entrenamiento", "Por equipo", "Uno vs Uno"};


new const Armas[3] = {22, 26, 28};
new const NombreArma[][] = {"Armas Rapidas", "Solo recortada"};


// Posiciones de cada mapa.
new const Float:posicionMapa[3][3][4] =
					  {
						  {// Aeropuerto LV
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
						   {1921.2411, -2209.7275, 29.3730}}
						};