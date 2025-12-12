/*
  Archivo: controlador_fechas.dart
  Descripción:
    Controlador responsable de administrar las Fechas de una Liga.
    Aplica validaciones de negocio, controla el flujo de creación y cierre,
    registra eventos mediante logs y delega persistencia al servicio.
  Dependencias:
    - servicio_fechas.dart
    - fecha_liga.dart
    - servicio_ligas.dart
    - controlador_ligas.dart
    - controlador_puntajes_reales.dart
    - servicio_log.dart
  Archivos que dependen de este:
    - Vistas administrativas que gestionan fechas por liga.
*/

import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';

import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';

import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'controlador_ligas.dart';
import 'controlador_puntajes_reales.dart';

class ControladorFechas {
  /// Servicio para persistir fechas de liga.
  final ServicioFechas _servicioFechas = ServicioFechas();

  /// Servicio para obtener y editar ligas.
  final ServicioLigas _servicioLigas = ServicioLigas();

  /// Controlador de ligas para operaciones de estado.
  final ControladorLigas _controladorLigas = ControladorLigas();

  /// Controlador encargado de gestionar puntajes reales.
  final ControladorPuntajesReales _controladorPuntajesReales =
      ControladorPuntajesReales();

  /// Servicio de logs.
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear fecha
  // ---------------------------------------------------------------------------
  /*
    Nombre: crearFecha
    Descripción:
      Crea una nueva fecha para una liga, aplicando validaciones:
      - idLiga no puede estar vacío
      - La liga debe tener totalFechasTemporada definido
      - fechasCreadas < totalFechasTemporada
      - No puede existir una fecha activa en la liga
      - numeroFecha = fechasCreadas + 1
      - nombre = "Fecha $numeroFecha"
      Luego incrementa fechasCreadas en la liga.
    Entradas:
      idLiga (String)
    Salidas:
      Future<FechaLiga>
  */
  Future<FechaLiga> crearFecha(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    _log.informacion("${TextosApp.LOG_CTRL_FECHAS_CREAR} $idLiga");

    final Liga? liga = await _servicioLigas.obtenerLiga(idLiga);
    if (liga == null) {
      throw Exception(TextosApp.ERR_CTRL_LIGA_NO_ENCONTRADA);
    }

    final int total = liga.totalFechasTemporada;
    final int creadas = liga.fechasCreadas;

    if (creadas >= total) {
      throw Exception(
        "${TextosApp.ERR_CTRL_LIGA_SIN_TOTAL_FECHAS} ($total)",
      );
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);

    if (existeActiva) {
      throw Exception(
        TextosApp.ERR_CTRL_LIGA_CON_FECHA_ACTIVA_PARA_CREAR,
      );
    }

    final int numeroFecha = creadas + 1;
    final String nombre =
        TextosApp.LIGA_NOMBRE_FECHA.replaceFirst("{NUMERO}", "$numeroFecha");
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final nuevaFecha = FechaLiga(
      id: "",
      idLiga: idLiga,
      numeroFecha: numeroFecha,
      nombre: nombre,
      activa: false,
      cerrada: false,
      fechaCreacion: timestamp,
    );

    final FechaLiga creadaFecha = await _servicioFechas.crearFecha(nuevaFecha);

    final Liga ligaActualizada = liga.copiarCon(fechasCreadas: creadas + 1);

    _log.informacion(
      "${TextosApp.LOG_CTRL_FECHAS_ACTUALIZAR_CONTADOR} ${creadas + 1}/$total",
    );

    await _servicioLigas.editarLiga(ligaActualizada);

    return creadaFecha;
  }

  // ---------------------------------------------------------------------------
  // Obtener fechas por liga
  // ---------------------------------------------------------------------------
  /*
    Nombre: obtenerPorLiga
    Descripción:
      Retorna todas las fechas correspondientes a una liga.
    Entradas:
      idLiga (String)
    Salidas:
      Future<List<FechaLiga>>
  */
  Future<List<FechaLiga>> obtenerPorLiga(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    _log.informacion("${TextosApp.LOG_CTRL_FECHAS_OBTENER} $idLiga");

    return await _servicioFechas.obtenerPorLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Cerrar fecha
  // ---------------------------------------------------------------------------
  /*
    Nombre: cerrarFecha
    Descripción:
      Permite cerrar una fecha si:
        - Está activa
        - No faltan puntajes (se consulta al ControladorPuntajesReales)
      Luego:
        - ServicioFechas.cerrarFecha()
        - Si es la última fecha de la liga (numeroFecha == totalFechasTemporada)
          entonces se archiva la liga.
    Entradas:
      fecha (FechaLiga)
    Salidas:
      Future<void>
  */
  // ---------------------------------------------------------------------------
  // Cerrar fecha
  // ---------------------------------------------------------------------------
  Future<void> cerrarFecha(FechaLiga fecha) async {
    _log.informacion("${TextosApp.LOG_CTRL_FECHAS_CERRAR} ${fecha.id}");

    if (!fecha.activa) {
      throw Exception(TextosApp.ERR_CTRL_FECHA_NO_ACTIVA);
    }

    final bool faltan = await _controladorPuntajesReales.faltanPuntajes(
      fecha.idLiga,
      fecha.id,
    );

    if (faltan) {
      throw Exception(TextosApp.ERR_CTRL_FALTAN_PUNTAJES);
    }

    // 1) Cerrar fecha en Firestore
    await _servicioFechas.cerrarFecha(fecha.id);

    // 2) Aplicar puntajes fantasy (EL PASO QUE FALTABA)
    _log.informacion(
      "${TextosApp.LOG_CTRL_FECHAS_APLICAR_PUNTAJES} ${fecha.idLiga} "
      "para la fecha ${fecha.id}",
    );

    await ControladorParticipaciones().aplicarPuntajesFantasyAFecha(
      fecha.idLiga,
      fecha.id,
    );

    // 3) Archivar liga si corresponde
    final Liga? liga = await _servicioLigas.obtenerLiga(fecha.idLiga);
    if (liga == null) {
      throw Exception(TextosApp.ERR_CTRL_LIGA_ASOCIADA_NO_ENCONTRADA);
    }

    if (fecha.numeroFecha == liga.totalFechasTemporada) {
      _log.advertencia(
        "${TextosApp.LOG_CTRL_FECHAS_ARCHIVAR_LIGA} ${liga.id}",
      );
      await _controladorLigas.archivar(liga.id);
    }

    _log.informacion("${TextosApp.LOG_CTRL_FECHAS_CERRADA_OK}");
  }
}
