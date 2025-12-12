/*
  Archivo: controlador_jugadores_reales.dart
  Descripción:
    Controlador encargado de gestionar jugadores reales asociados a equipos reales.
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
    Descripción:
      Crea un jugador real validando integridad de datos requeridos.
      Aplica reglas de negocio:
        - Validar idEquipoReal, nombre y posición no vacíos.
        - Asegurar que la posición pertenezca al conjunto {POR, DEF, MED, DEL}.
        - Verificar rangos permitidos para dorsal (1–99) y valorMercado (1–1000).
    Entradas:
      - idEquipoReal: String → ID del equipo real al que pertenece el jugador.
      - nombre: String → Nombre del jugador.
      - posicion: String → Posición del jugador (POR, DEF, MED, DEL).
      - nacionalidad: String → Nacionalidad del jugador (opcional).
      - dorsal: int → Número de camiseta entre 1 y 99.
      - valorMercado: int → Valor entre 1 y 1000.
    Salidas:
      - Future<JugadorReal>: Jugador creado con ID asignado.
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
      throw ArgumentError(TextosApp.ERR_CTRL_ID_EQUIPO_VACIO);
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_NOMBRE_VACIO);
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(posicion.trim())) {
      throw ArgumentError(TextosApp.ERR_CTRL_POSICION_JUGADOR_REAL);
    }

    if (dorsal < 1 || dorsal > 99) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_REAL_DORSAL_RANGO);
    }

    if (valorMercado < 1 || valorMercado > 1000) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_REAL_VALOR_RANGO);
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
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_CREAR} $idEquipoReal ($nombre)",
    );

    return await _servicio.crearJugadorReal(jugador);
  }

  /*
    Nombre: obtenerPorEquipoReal
    Descripción:
      Lista todos los jugadores reales pertenecientes a un equipo real.
      Aplica reglas de negocio:
        - Validar idEquipoReal no vacío.
        - Ordenar jugadores por posición para entrega consistente.
    Entradas:
      - idEquipoReal: String → ID del equipo real.
    Salidas:
      - Future<List<JugadorReal>>: Jugadores activos del equipo ordenados por posición.
  */
  Future<List<JugadorReal>> obtenerPorEquipoReal(String idEquipoReal) async {
    if (idEquipoReal.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_EQUIPO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_LISTAR} $idEquipoReal",
    );

    final lista = await _servicio.obtenerPorEquipoReal(idEquipoReal);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_LISTA_ORDENADA}: "
      "${lista.length} del equipo $idEquipoReal",
    );

    return lista;
  }

  /*
    Nombre: editar
    Descripción:
      Edita los datos de un jugador real existente aplicando validaciones
      consistentes con la creación.
      Aplica reglas de negocio:
        - Mantener validación de posición permitida.
        - Rechazar dorsales y valores de mercado fuera de rango.
    Entradas:
      - jugador: JugadorReal → Datos completos del jugador a editar.
    Salidas:
      - Future<void>: Completa al persistir la actualización.
  */
  Future<void> editar(JugadorReal jugador) async {
    if (jugador.id.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_JUGADOR_VACIO);
    }

    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_NOMBRE_VACIO);
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(jugador.posicion.trim())) {
      throw ArgumentError(TextosApp.ERR_CTRL_POSICION_JUGADOR_REAL);
    }

    if (jugador.dorsal < 1 || jugador.dorsal > 99) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_REAL_DORSAL_RANGO);
    }

    if (jugador.valorMercado < 1 || jugador.valorMercado > 1000) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_REAL_VALOR_RANGO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_EDITAR} ${jugador.id}",
    );

    await _servicio.editarJugadorReal(jugador);
  }

  /*
    Nombre: archivar
    Descripción:
      Archiva un jugador real marcándolo como inactivo para excluirlo de
      futuras alineaciones.
      Aplica reglas de negocio:
        - Requiere idJugador no vacío antes de proceder.
    Entradas:
      - idJugador: String → ID del jugador real.
    Salidas:
      - Future<void>: Completa al marcar el jugador como inactivo.
  */
  Future<void> archivar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_JUGADOR_VACIO);
    }

    _log.advertencia(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_ARCHIVAR} $idJugador",
    );

    await _servicio.archivarJugadorReal(idJugador);
  }

  /*
    Nombre: activar
    Descripción:
      Activa un jugador real previamente archivado.
      Aplica reglas de negocio:
        - Requiere un identificador válido del jugador.
    Entradas:
      - idJugador: String → ID del jugador real.
    Salidas:
      - Future<void>: Completa al reactivar el jugador.
  */
  Future<void> activar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_JUGADOR_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_ACTIVAR} $idJugador",
    );

    await _servicio.activarJugadorReal(idJugador);
  }

  /*
    Nombre: eliminar
    Descripción:
      Elimina un jugador real en forma definitiva.
      Aplica reglas de negocio:
        - Exige idJugador no vacío.
    Entradas:
      - idJugador: String → ID del jugador real.
    Salidas:
      - Future<void>: Completa al remover el registro.
  */
  Future<void> eliminar(String idJugador) async {
    if (idJugador.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_JUGADOR_VACIO);
    }

    _log.error("${TextosApp.LOG_CTRL_JUGADORES_REALES_ELIMINAR} $idJugador");

    await _servicio.eliminarJugadorReal(idJugador);
  }

  /*
    Nombre: obtenerPorIds
    Descripción:
      Recupera jugadores reales activos según una lista de IDs provista.
      La lista es validada, se eliminan duplicados y luego se consulta
      el servicio correspondiente. El resultado está ordenado por posición.
      Aplica reglas de negocio:
        - Exigir lista no vacía y sin duplicados antes de consultar.
        - Ordenar la salida por posición para consistencia.
    Entradas:
      - ids: List<String> → Lista de IDs de jugadores reales.
    Salidas:
      - Future<List<JugadorReal>>: Jugadores encontrados y ordenados.
  */
  Future<List<JugadorReal>> obtenerPorIds(List<String> ids) async {
    if (ids.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_LISTA_IDS_VACIA);
    }

    final idsUnicos = ids.toSet().toList();

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_OBTENER_IDS} "
      "(solicitados=${ids.length}, unicos=${idsUnicos.length})",
    );

    final lista = await _servicio.obtenerPorIds(idsUnicos);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      "${TextosApp.LOG_CTRL_JUGADORES_REALES_OBTENIDOS_IDS}: ${lista.length} "
      "(ordenados)",
    );

    return lista;
  }
}
