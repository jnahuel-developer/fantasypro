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
      throw ArgumentError("El idEquipoReal no puede estar vacío.");
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del jugador no puede estar vacío.");
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(posicion.trim())) {
      throw ArgumentError("La posición debe ser POR, DEF, MED o DEL.");
    }

    if (dorsal < 1 || dorsal > 99) {
      throw ArgumentError("El dorsal debe estar entre 1 y 99.");
    }

    if (valorMercado < 1 || valorMercado > 1000) {
      throw ArgumentError("El valor de mercado debe estar entre 1 y 1000.");
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

    _log.informacion("Creando jugador real en equipo $idEquipoReal ($nombre)");

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
      throw ArgumentError("El idEquipoReal no puede estar vacío.");
    }

    _log.informacion("Listando jugadores reales del equipo $idEquipoReal");

    final lista = await _servicio.obtenerPorEquipoReal(idEquipoReal);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      "Jugadores obtenidos: ${lista.length} del equipo $idEquipoReal (ordenados por posición)",
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
      throw ArgumentError("El ID del jugador no puede estar vacío.");
    }

    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del jugador no puede estar vacío.");
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(jugador.posicion.trim())) {
      throw ArgumentError("La posición debe ser POR, DEF, MED o DEL.");
    }

    if (jugador.dorsal < 1 || jugador.dorsal > 99) {
      throw ArgumentError("El dorsal debe estar entre 1 y 99.");
    }

    if (jugador.valorMercado < 1 || jugador.valorMercado > 1000) {
      throw ArgumentError("El valor de mercado debe estar entre 1 y 1000.");
    }

    _log.informacion("Editando jugador real ${jugador.id}");

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
      throw ArgumentError("El ID del jugador no puede estar vacío.");
    }

    _log.advertencia("Archivando jugador real $idJugador");

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
      throw ArgumentError("El ID del jugador no puede estar vacío.");
    }

    _log.informacion("Activando jugador real $idJugador");

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
      throw ArgumentError("El ID del jugador no puede estar vacío.");
    }

    _log.error("Eliminando jugador real $idJugador");

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
      throw ArgumentError("La lista de IDs no puede estar vacía.");
    }

    final idsUnicos = ids.toSet().toList();

    _log.informacion(
      "Obteniendo jugadores reales por IDs (solicitados=${ids.length}, unicos=${idsUnicos.length})",
    );

    final lista = await _servicio.obtenerPorIds(idsUnicos);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      "Jugadores obtenidos por IDs: ${lista.length} (ordenados)",
    );

    return lista;
  }
}
