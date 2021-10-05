/**
 * @file cwtg_configuracion.pwn
 * @author ne0de (https://github.com/ne0de)
 * @brief Archivo que contiene la configuración del sistema, es modificable a tu gusto.
 * @version 0.1.5
 * @date 2021-10-04
 * 
 * @copyright Copyright (c) 2021 by ne0de.
 * 
 */

#if defined CWTG_CONFIG
	#endinput
#endif

#define CWTG_CONFIG

/**
 * PD = Por Defecto
 * Puedes modificar cada definición a tu gusto.
 */
#define PD_MAPA AEROPUERTO_LV
#define PD_TIPO_ARMA ARMAS_RAPIDAS
#define PD_NUMERO_MUNDO 7284
#define PD_PUNTAJE_MAXIMO 3
#define PD_RONDA_MAXIMA 2

#define PD_ALPHA_NOMBRE "Alpha"
#define PD_BETA_NOMBRE "Beta"
#define PD_ESPECTADOR_NOMBRE "Espectador"

#define PD_SKIN_OBLIGATORIO true
#define PD_ALPHA_SKIN 237
#define PD_BETA_SKIN 130
#define PD_ESPECTADOR_SKIN 10 

#define PD_ALPHA_COLOR ROJO
#define PD_BETA_COLOR AZUL
#define PD_ESPECTADOR_COLOR CYAN

// Refrescar FPS de jugadores.
#define RF_ESTADO true

// Refrescar posición (RP) para espectadores.
#define RP_ESTADO true
#define RP_TIEMPO 2000	// medida en milisegundos.

/**
 * A partir de aquí ten cuidado con los valores que cambies.
 */
#define NULO -1
#define MAX_EQUIPOS 3
#define MAX_JUGADORES 6
#define MAX_NOMBRE_EQUIPO 24
#define MAX_LONGITUD_MENSAJE 128
#define MAX_TITULO 32
#define MAX_RONDAS 6
#define MAX_PUNTAJE 200

// Definición de mapas.
#define MAX_MAPAS 2
#define AEROPUERTO_LV 0
#define AEROPUERTO_SF 1
#define AEROPUERTO_LS 2

// Definición de armas.
#define MAX_ARMAS 1
#define ARMAS_RAPIDAS 0
#define SOLO_RECORTADA 1

// Definición de equipos.
#define EQUIPO_ALPHA 0
#define EQUIPO_BETA 1
#define EQUIPO_ESPECTADOR 2

// Definición modos de juego.
#define ENTRENAMIENTO 0
#define POR_EQUIPO 1
#define UNOVSUNO 2

#define GANADOR 0
#define PERDEDOR 0

// Definición de colores.
#define BLANCO -1
#define NEUTRO 0xC0C9C9C9
#define GRIS 0x80808080
#define AZUL 0x3624FFFF
#define CYAN 0x88F7F7FF
#define ROJO 0xFF5353FF
#define VERDE 0x007C0EFF
#define AMARILLO 0xFFFFBB00

// Definición de dialogos
#define D_MENU_EQUIPOS 6456
#define D_MENU_CONFIGURACION 6457
#define D_CONFIGURACION_EQUIPO 6458
#define D_CONFIGURACION_PARAMETRO 6459

// Definición dialogos de parametros
#define D_MAPA 7000
#define D_ARMA 7001
#define D_PARTIDA 7002
#define D_RONDA_MAXIMA 7003
#define D_RONDA_ACTUAL 7004
#define D_PUNTAJE_MAXIMO 7005

#define D_INFO_JUGADOR 8000