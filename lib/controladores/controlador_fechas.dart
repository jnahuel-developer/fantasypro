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
    - servicio_log.dart
  Archivos que dependen de este:
    - Vistas administrativas que gestionan fechas por liga.
*/

import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';

import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';

import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

import 'controlador_ligas.dart';

class ControladorFechas {
  /// Servicio para persistir fechas de liga.
  final ServicioFechas _servicioFechas = ServicioFechas();

  /// Servicio para obtener y editar ligas.
  final ServicioLigas _servicioLigas = ServicioLigas();

  /// Controlador de ligas para operaciones de estado.
  final ControladorLigas _controladorLigas = ControladorLigas();

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
      throw ArgumentError("El idLiga no puede estar vacío.");
    }

    _log.informacion("Creando nueva fecha para liga $idLiga");

    // Obtener la liga para conocer contadores
    final Liga? liga = await _servicioLigas.obtenerLiga(idLiga);
    if (liga == null) {
      throw Exception("No se encontró la liga solicitada.");
    }

    final int total = liga.totalFechasTemporada;
    final int creadas = liga.fechasCreadas;

    if (creadas >= total) {
      throw Exception(
        "La liga ya alcanzó el número máximo de fechas ($total).",
      );
    }

    // Verificar que no exista una fecha activa
    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);

    if (existeActiva) {
      throw Exception(
        "No se puede crear una nueva fecha mientras exista otra activa.",
      );
    }

    // Generación automática
    final int numeroFecha = creadas + 1;
    final String nombre = "Fecha $numeroFecha";
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

    // Persistir fecha
    final FechaLiga creadaFecha = await _servicioFechas.crearFecha(nuevaFecha);

    // Actualizar liga.fechasCreadas
    final Liga ligaActualizada = liga.copiarCon(fechasCreadas: creadas + 1);

    _log.informacion(
      "Actualizando contador de fechas de la liga: ${creadas + 1}/$total",
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
      throw ArgumentError("El idLiga no puede estar vacío.");
    }

    _log.informacion("Obteniendo fechas de liga $idLiga");

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
        - No faltan puntajes (stub siempre false)
      Luego:
        - ServicioFechas.cerrarFecha()
        - Si es la última fecha de la liga (numeroFecha == totalFechasTemporada)
          entonces se archiva la liga.
    Entradas:
      fecha (FechaLiga)
    Salidas:
      Future<void>
  */
  Future<void> cerrarFecha(FechaLiga fecha) async {
    _log.informacion("Intentando cerrar fecha ${fecha.id}");

    if (!fecha.activa) {
      throw Exception("Solo se pueden cerrar fechas activas.");
    }

    if (_faltanPuntajes(fecha.id)) {
      throw Exception("No se puede cerrar la fecha: faltan puntajes.");
    }

    await _servicioFechas.cerrarFecha(fecha.id);

    // Obtener liga para validar si es la última fecha
    final Liga? liga = await _servicioLigas.obtenerLiga(fecha.idLiga);
    if (liga == null) {
      throw Exception("No se encontró la liga asociada a la fecha.");
    }

    if (fecha.numeroFecha == liga.totalFechasTemporada) {
      _log.advertencia(
        "La última fecha fue cerrada; archivando liga ${liga.id}",
      );
      await _controladorLigas.archivar(liga.id);
    }
  }

  // ---------------------------------------------------------------------------
  // Stub: puntajes futuros
  // ---------------------------------------------------------------------------
  /*
    Nombre: _faltanPuntajes
    Descripción:
      Determina si faltan puntajes para cerrar la fecha.
      En esta versión siempre retorna false.
    Entradas:
      idFecha (String)
    Salidas:
      bool
  */
  bool _faltanPuntajes(String idFecha) {
    return false;
  }
}
