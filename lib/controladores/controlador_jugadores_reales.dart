/*
  Archivo: controlador_jugadores_reales.dart
  Descripción: Controlador encargado de gestionar jugadores reales asociados a equipos reales.
  Dependencias:
    - servicio_jugadores_reales.dart
    - jugador_real.dart
    - servicio_log.dart
  Archivos que dependen de este:
    - Vistas administrativas que gestionan jugadores reales.
*/

import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/servicios/firebase/servicio_jugadores_reales.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorJugadoresReales {
  /// Servicio para operaciones de jugadores reales.
  final ServicioJugadoresReales _servicio = ServicioJugadoresReales();

  /// Servicio para registrar logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearJugadorReal
    Descripción: Crea un jugador real verificando valores válidos de nombre, posición, dorsal y valor de mercado.
    Entradas:
      - idEquipoReal: String → ID del equipo real al que pertenece el jugador
      - nombre: String → Nombre del jugador
      - posicion: String → Debe ser uno de {POR, DEF, MED, DEL}
      - nacionalidad: String → Nacionalidad del jugador
      - dorsal: int → Debe estar entre 1 y 99
      - valorMercado: int → Valor entre 1 y 1000
    Salidas: Future<JugadorReal>
  */
  Future<JugadorReal> crearJugadorReal(
    String idEquipoReal,
    String nombre,
    String posicion, {
    String nacionalidad = "",
    int dorsal = 1,
    int valorMercado = 1,
  }) async {
    if (idEquipoReal.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_EQUIPO_REAL_VACIO);
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_NOMBRE_VACIO);
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(posicion.trim())) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_POSICION);
    }

    if (dorsal < 1 || dorsal > 99) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_DORSAL);
    }

    if (valorMercado < 1 || valorMercado > 1000) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_VALOR_MERCADO);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final jugador = JugadorReal(
      id: "",
      idEquipoReal: idEquipoReal.trim(),
      nombre: nombre.trim(),
      posicion: posicion.trim(),
      nacionalidad: nacionalidad.trim(),
      dorsal: dorsal,
      valorMercado: valorMercado,
      activo: true,
      fechaCreacion: timestamp,
      nombreEquipoReal: "",
    );

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_CREAR
          .replaceAll('{EQUIPO}', idEquipoReal)
          .replaceAll('{NOMBRE}', nombre),
    );

    return await _servicio.crearJugadorReal(jugador);
  }

  /*
    Nombre: obtenerPorEquipoReal
    Descripción: Lista todos los jugadores reales pertenecientes a un equipo real.
    Entradas:
      - idEquipoReal: String → ID del equipo real
    Salidas: Future<List<JugadorReal>>
  */
  Future<List<JugadorReal>> obtenerPorEquipoReal(String idEquipoReal) async {
    if (idEquipoReal.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_EQUIPO_REAL_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_LISTAR
          .replaceAll('{EQUIPO}', idEquipoReal),
    );

    final lista = await _servicio.obtenerPorEquipoReal(idEquipoReal);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_LISTAR_RESUMEN
          .replaceAll('{CANTIDAD}', lista.length.toString())
          .replaceAll('{EQUIPO}', idEquipoReal),
    );

    return lista;
  }

  /*
    Nombre: editar
    Descripción: Edita los datos de un jugador real existente.
    Entradas:
      - jugador: JugadorReal → Datos completos del jugador a editar
    Salidas: Future<void>
  */
  Future<void> editar(JugadorReal jugador) async {
    if (jugador.id.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_JUGADOR_VACIO);
    }

    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_NOMBRE_VACIO);
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(jugador.posicion.trim())) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_POSICION);
    }

    if (jugador.dorsal < 1 || jugador.dorsal > 99) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_DORSAL);
    }

    if (jugador.valorMercado < 1 || jugador.valorMercado > 1000) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_VALOR_MERCADO);
    }

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_EDITAR
          .replaceAll('{JUGADOR}', jugador.id),
    );

    await _servicio.editarJugadorReal(jugador);
  }

  /*
    Nombre: archivar
    Descripción: Archiva un jugador real, marcándolo como inactivo.
    Entradas:
      - idJugador: String → ID del jugador real
    Salidas: Future<void>
  */
  Future<void> archivar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_JUGADOR_VACIO);
    }

    _log.advertencia(
      TextosApp.CTRL_JUGADORES_REALES_LOG_ARCHIVAR
          .replaceAll('{JUGADOR}', idJugador),
    );

    await _servicio.archivarJugadorReal(idJugador);
  }

  /*
    Nombre: activar
    Descripción: Activa un jugador real previamente archivado.
    Entradas:
      - idJugador: String → ID del jugador real
    Salidas: Future<void>
  */
  Future<void> activar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_JUGADOR_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_ACTIVAR
          .replaceAll('{JUGADOR}', idJugador),
    );

    await _servicio.activarJugadorReal(idJugador);
  }

  /*
    Nombre: eliminar
    Descripción: Elimina un jugador real en forma definitiva.
    Entradas:
      - idJugador: String → ID del jugador real
    Salidas: Future<void>
  */
  Future<void> eliminar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_JUGADOR_VACIO);
    }

    _log.error(
      TextosApp.CTRL_JUGADORES_REALES_LOG_ELIMINAR
          .replaceAll('{JUGADOR}', idJugador),
    );

    await _servicio.eliminarJugadorReal(idJugador);
  }

  /*
    Nombre: obtenerPorIds
    Descripción:
      Recupera jugadores reales activos según una lista de IDs provista. 
      La lista es validada, se eliminan duplicados y luego se consulta
      el servicio correspondiente. El resultado está ordenado por posición.
    Entradas:
      - ids: List<String> → Lista de IDs de jugadores reales
    Salidas: Future<List<JugadorReal>>
  */
  Future<List<JugadorReal>> obtenerPorIds(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_JUGADORES_REALES_ERROR_IDS_VACIOS);
    }

    final idsUnicos = ids.toSet().toList();

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_OBTENER_IDS
          .replaceAll('{SOLICITADOS}', ids.length.toString())
          .replaceAll('{UNICOS}', idsUnicos.length.toString()),
    );

    final lista = await _servicio.obtenerPorIds(idsUnicos);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      TextosApp.CTRL_JUGADORES_REALES_LOG_OBTENIDOS
          .replaceAll('{CANTIDAD}', lista.length.toString()),
    );

    return lista;
  }
}
