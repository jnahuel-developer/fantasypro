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
import 'package:fantasypro/core/app_strings.dart';

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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdEquipoVacio),
      );
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesNombreVacio),
      );
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(posicion.trim())) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesPosicionInvalida),
      );
    }

    if (dorsal < 1 || dorsal > 99) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesDorsalRango),
      );
    }

    if (valorMercado < 1 || valorMercado > 1000) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesValorRango),
      );
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
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogCrear,
        args: {'idEquipoReal': idEquipoReal, 'nombre': nombre},
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdEquipoVacio),
      );
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogListar,
        args: {'idEquipoReal': idEquipoReal},
      ),
    );

    final lista = await _servicio.obtenerPorEquipoReal(idEquipoReal);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogOrdenados,
        args: {
          'total': '${lista.length}',
          'idEquipoReal': idEquipoReal,
        },
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdJugadorVacio),
      );
    }

    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesNombreVacio),
      );
    }

    const posicionesValidas = {"POR", "DEF", "MED", "DEL"};
    if (!posicionesValidas.contains(jugador.posicion.trim())) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesPosicionInvalida),
      );
    }

    if (jugador.dorsal < 1 || jugador.dorsal > 99) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesDorsalRango),
      );
    }

    if (jugador.valorMercado < 1 || jugador.valorMercado > 1000) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesValorRango),
      );
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogEditar,
        args: {'idJugador': jugador.id},
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdJugadorVacio),
      );
    }

    _log.advertencia(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogArchivar,
        args: {'idJugador': idJugador},
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdJugadorVacio),
      );
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogActivar,
        args: {'idJugador': idJugador},
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdJugadorVacio),
      );
    }

    _log.error(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogEliminar,
        args: {'idJugador': idJugador},
      ),
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
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorJugadoresRealesIdsVacios),
      );
    }

    final idsUnicos = ids.toSet().toList();

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogObtenerIds,
        args: {
          'solicitados': '${ids.length}',
          'unicos': '${idsUnicos.length}',
        },
      ),
    );

    final lista = await _servicio.obtenerPorIds(idsUnicos);

    final orden = {"POR": 0, "DEF": 1, "MED": 2, "DEL": 3};
    lista.sort((a, b) => orden[a.posicion]!.compareTo(orden[b.posicion]!));

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorJugadoresRealesLogIdsOrdenados,
        args: {'total': '${lista.length}'},
      ),
    );

    return lista;
  }
}
