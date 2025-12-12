/*
  Archivo: controlador_alineaciones.dart
  Descripción:
    Lógica de negocio y validación para gestión de alineaciones.
    Incluye creación, edición y registro de planteles y titulares.
  Dependencias:
    - modelos/alineacion.dart
    - servicios/firebase/servicio_alineaciones.dart
    - servicios/firebase/servicio_participaciones.dart
    - servicios/firebase/servicio_fechas.dart
    - servicios/utilidades/servicio_log.dart
    - textos/textos_app.dart
  Archivos que dependen de este:
    - Flujos web y móviles que gestionan alineaciones de usuario.
*/

import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_alineaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorAlineaciones {
  /// Servicio para persistir y recuperar alineaciones.
  final ServicioAlineaciones _servicio = ServicioAlineaciones();

  /// Servicio para administrar participaciones de usuarios en ligas.
  final ServicioParticipaciones _servicioPart = ServicioParticipaciones();

  /// Servicio para consultar fechas activas y cerradas.
  final ServicioFechas _servicioFechas = ServicioFechas();

  /// Servicio para registrar eventos y errores en bitácora.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearAlineacion
    Descripción:
      Crea una alineación base para un usuario en una liga determinada.
    Aplica reglas de negocio:
      - Valida que los identificadores no estén vacíos.
      - La formación debe ser aceptada por el sistema.
      - Debe existir al menos un jugador seleccionado.
      - Los puntos totales no pueden ser negativos.
    Entradas:
      - idLiga: String → Identificador de la liga.
      - idUsuario: String → Identificador del usuario.
      - idEquipoFantasy: String → Identificador del equipo fantasy.
      - jugadoresSeleccionados: List<String> → IDs de jugadores seleccionados.
      - formacion: String → Distribución táctica inicial.
      - puntosTotales: int → Puntos acumulados iniciales.
      - idsTitulares: List<String> → Identificadores de titulares.
      - idsSuplentes: List<String> → Identificadores de suplentes.
    Salidas:
      - Future<Alineacion> → Alineación creada.
  */
  Future<Alineacion> crearAlineacion(
    String idLiga,
    String idUsuario,
    String idEquipoFantasy,
    List<String> jugadoresSeleccionados, {
    String formacion = "4-4-2",
    int puntosTotales = 0,
    List<String> idsTitulares = const [],
    List<String> idsSuplentes = const [],
  }) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_EQUIPO_FANTASY_VACIO);
    }

    if (jugadoresSeleccionados.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_SELECCION_REQUERIDA);
    }

    if (puntosTotales < 0) {
      throw ArgumentError(TextosApp.ERR_CTRL_PUNTOS_NEGATIVOS);
    }

    if (!_validarFormacion(formacion)) {
      throw ArgumentError("${TextosApp.ERR_CTRL_FORMACION_INVALIDA} $formacion");
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final alineacion = Alineacion(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      idEquipoFantasy: idEquipoFantasy,
      jugadoresSeleccionados: jugadoresSeleccionados,
      formacion: formacion,
      puntosTotales: puntosTotales,
      fechaCreacion: timestamp,
      activo: true,
      idsTitulares: idsTitulares,
      idsSuplentes: idsSuplentes,
    );

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_CREANDO} $idUsuario en liga $idLiga",
    );

    return await _servicio.crearAlineacion(alineacion);
  }

  /*
    Nombre: obtenerPorUsuarioEnLiga
    Descripción:
      Recupera todas las alineaciones registradas por un usuario en una liga.
    Aplica reglas de negocio:
      - Verifica que los identificadores no estén vacíos.
    Entradas:
      - idLiga: String → Identificador de la liga.
      - idUsuario: String → Identificador del usuario.
    Salidas:
      - Future<List<Alineacion>> → Lista de alineaciones del usuario.
  */
  Future<List<Alineacion>> obtenerPorUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_LISTANDO} $idUsuario en liga $idLiga",
    );

    return await _servicio.obtenerPorUsuarioEnLiga(idLiga, idUsuario);
  }

  /*
    Nombre: archivar
    Descripción:
      Marca una alineación como inactiva sin eliminarla.
    Aplica reglas de negocio:
      - Requiere un identificador válido.
    Entradas:
      - idAlineacion: String → Identificador de la alineación.
    Salidas:
      - Future<void>
  */
  Future<void> archivar(String idAlineacion) async {
    _log.advertencia("${TextosApp.LOG_CTRL_ALINEACIONES_ARCHIVANDO} $idAlineacion");
    await _servicio.archivarAlineacion(idAlineacion);
  }

  /*
    Nombre: activar
    Descripción:
      Reactiva una alineación previamente archivada.
    Aplica reglas de negocio:
      - Requiere un identificador válido.
    Entradas:
      - idAlineacion: String → Identificador de la alineación.
    Salidas:
      - Future<void>
  */
  Future<void> activar(String idAlineacion) async {
    _log.informacion("${TextosApp.LOG_CTRL_ALINEACIONES_ACTIVANDO} $idAlineacion");
    await _servicio.activarAlineacion(idAlineacion);
  }

  /*
    Nombre: eliminar
    Descripción:
      Elimina de forma permanente una alineación.
    Aplica reglas de negocio:
      - Requiere un identificador válido.
    Entradas:
      - idAlineacion: String → Identificador de la alineación.
    Salidas:
      - Future<void>
  */
  Future<void> eliminar(String idAlineacion) async {
    _log.error("${TextosApp.LOG_CTRL_ALINEACIONES_ELIMINANDO} $idAlineacion");
    await _servicio.eliminarAlineacion(idAlineacion);
  }

  /*
    Nombre: editar
    Descripción:
      Actualiza los datos de una alineación existente.
    Aplica reglas de negocio:
      - Valida ID, jugadores, puntos y formación antes de editar.
    Entradas:
      - alineacion: Alineacion → Entidad con los cambios solicitados.
    Salidas:
      - Future<void>
  */
  Future<void> editar(Alineacion alineacion) async {
    if (alineacion.id.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_ALINEACION_VACIO);
    }

    if (alineacion.jugadoresSeleccionados.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADOR_SELECCION_REQUERIDA);
    }

    if (alineacion.puntosTotales < 0) {
      throw ArgumentError(TextosApp.ERR_CTRL_PUNTOS_NEGATIVOS);
    }

    if (!_validarFormacion(alineacion.formacion)) {
      throw ArgumentError(
        "${TextosApp.ERR_CTRL_FORMACION_INVALIDA} ${alineacion.formacion}",
      );
    }

    _log.informacion("${TextosApp.LOG_CTRL_ALINEACIONES_EDITANDO} ${alineacion.id}");

    await _servicio.editarAlineacion(alineacion);
  }

  /*
    Nombre: _validarFormacion
    Descripción:
      Verifica que la formación solicitada esté permitida.
    Aplica reglas de negocio:
      - Solo se aceptan formaciones 4-4-2 o 4-3-3.
    Entradas:
      - f: String → Formación táctica a validar.
    Salidas:
      - bool → true si la formación es válida.
  */
  bool _validarFormacion(String f) {
    return f == "4-4-2" || f == "4-3-3";
  }

  /*
    Nombre: guardarPlantelInicial
    Descripción:
      Registra el plantel inicial de 15 jugadores sin distinguir titulares y suplentes.
    Aplica reglas de negocio:
      - Valida identificadores de liga, usuario y equipo fantasy.
      - Confirma que la formación sea válida y que haya exactamente 15 jugadores.
      - Impide registrar plantel si la liga tiene una fecha activa.
    Entradas:
      - idLiga: String → Identificador de la liga.
      - idUsuario: String → Identificador del usuario.
      - idEquipoFantasy: String → Identificador del equipo fantasy.
      - idsJugadoresSeleccionados: List<String> → Plantel inicial completo.
      - formacion: String → Formación táctica.
    Salidas:
      - Future<Alineacion> → Alineación creada.
  */
  Future<Alineacion> guardarPlantelInicial(
    String idLiga,
    String idUsuario,
    String idEquipoFantasy,
    List<String> idsJugadoresSeleccionados,
    String formacion,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }
    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_EQUIPO_FANTASY_VACIO);
    }
    if (!_validarFormacion(formacion)) {
      throw ArgumentError("${TextosApp.ERR_CTRL_FORMACION_INVALIDA} $formacion");
    }
    if (idsJugadoresSeleccionados.length != 15) {
      throw ArgumentError(TextosApp.ERR_CTRL_PLANTEL_TAMANIO);
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);
    if (existeActiva) {
      throw Exception(TextosApp.ERR_CTRL_LIGA_CON_FECHA_ACTIVA);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final alineacion = Alineacion(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      idEquipoFantasy: idEquipoFantasy,
      jugadoresSeleccionados: idsJugadoresSeleccionados,
      formacion: formacion,
      puntosTotales: 0,
      fechaCreacion: timestamp,
      activo: true,
      idsTitulares: const [],
      idsSuplentes: const [],
    );

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_GUARDAR_PLANTEL} $idUsuario en liga $idLiga",
    );

    return await _servicio.crearAlineacion(alineacion);
  }

  /*
    Nombre: guardarAlineacionInicial
    Descripción:
      Define titulares y suplentes de una alineación existente.
    Aplica reglas de negocio:
      - Valida parámetros obligatorios y cantidades de jugadores.
      - Confirma que los jugadores pertenezcan al plantel registrado.
      - Actualiza la participación para marcar plantel completo.
    Entradas:
      - idLiga: String → Identificador de la liga.
      - idUsuario: String → Identificador del usuario.
      - idAlineacion: String → Identificador de la alineación.
      - idsTitulares: List<String> → Jugadores titulares.
      - idsSuplentes: List<String> → Jugadores suplentes.
    Salidas:
      - Future<Alineacion> → Alineación actualizada.
  */
  Future<Alineacion> guardarAlineacionInicial(
    String idLiga,
    String idUsuario,
    String idAlineacion,
    List<String> idsTitulares,
    List<String> idsSuplentes,
  ) async {
    if (idLiga.trim().isEmpty ||
        idUsuario.trim().isEmpty ||
        idAlineacion.trim().isEmpty) {
      throw ArgumentError(
        "${TextosApp.ERR_CTRL_ID_LIGA_VACIO} ${TextosApp.ERR_CTRL_ID_USUARIO_VACIO} ${TextosApp.ERR_CTRL_ID_ALINEACION_VACIO}",
      );
    }
    if (idsTitulares.length != 11) {
      throw ArgumentError(TextosApp.ERR_CTRL_TITULARES_INSUFICIENTES);
    }
    if (idsSuplentes.length != 4) {
      throw ArgumentError(TextosApp.ERR_CTRL_SUPLENTES_INSUFICIENTES);
    }

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    final alineacion = alineaciones.firstWhere(
      (a) => a.id == idAlineacion,
      orElse: () => throw Exception(TextosApp.ERR_CTRL_PARTICIPACION_NO_ENCONTRADA),
    );

    final todos = {...idsTitulares, ...idsSuplentes};
    final setPlantel = alineacion.jugadoresSeleccionados.toSet();
    if (!setPlantel.containsAll(todos)) {
      throw ArgumentError(TextosApp.ERR_CTRL_JUGADORES_NO_COINCIDEN);
    }

    final actualizada = alineacion.copiarCon(
      idsTitulares: idsTitulares,
      idsSuplentes: idsSuplentes,
    );

    await _servicio.editarAlineacion(actualizada);

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_BUSCAR_PARTICIPACION} $idUsuario en liga $idLiga",
    );

    final participacion = await _servicioPart.obtenerParticipacion(
      idUsuario,
      idLiga,
    );

    if (participacion == null) {
      throw Exception(TextosApp.ERR_CTRL_PARTICIPACION_NO_ENCONTRADA);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_PARTICIPACION_ENCONTRADA} ${participacion.id}",
    );

    final actualizadaPart = participacion.copiarCon(plantelCompleto: true);

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_PARTICIPACION_MARCAR} ${participacion.id}",
    );

    await _servicioPart.editarParticipacion(actualizadaPart);

    _log.informacion(TextosApp.LOG_CTRL_ALINEACIONES_PARTICIPACION_ACTUALIZADA);

    return actualizada;
  }

  /*
    Nombre: obtenerAlineacionActivaDeUsuarioEnLiga
    Descripción:
      Recupera la alineación activa de un usuario; si no existe, retorna la más reciente.
    Aplica reglas de negocio:
      - Valida identificadores de liga y usuario.
      - Prioriza alineaciones activas; en ausencia, devuelve la última creada.
    Entradas:
      - idLiga: String → Identificador de la liga.
      - idUsuario: String → Identificador del usuario.
    Salidas:
      - Future<Alineacion?> → Alineación encontrada o null.
  */
  Future<Alineacion?> obtenerAlineacionActivaDeUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_BUSCAR_ACTIVA} $idUsuario en liga $idLiga",
    );

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    if (alineaciones.isEmpty) return null;

    final alineacionesActivas = alineaciones.where((a) => a.activo).toList();
    if (alineacionesActivas.isNotEmpty) {
      final activa = alineacionesActivas.first;
      _log.informacion("${TextosApp.LOG_CTRL_ALINEACIONES_EDITANDO} ${activa.id}");
      return activa;
    }

    alineaciones.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    final reciente = alineaciones.first;
    _log.informacion(
      "${TextosApp.LOG_CTRL_ALINEACIONES_SIN_ACTIVA} ${reciente.id}",
    );
    return reciente;
  }
}
