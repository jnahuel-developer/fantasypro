/*
  Archivo: controlador_ligas.dart
  Descripción:
    Controlador responsable de administrar las Ligas del sistema.
    Aplica validaciones, gestiona creación, actualización y estado de ligas.
  Dependencias:
    - servicio_ligas.dart
    - liga.dart
    - servicio_log.dart
  Archivos que dependen de este:
    - controlador_fechas.dart
    - vistas administrativas que gestionan ligas.
*/

import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/core/app_strings.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorLigas {
  /// Servicio para operaciones de persistencia de ligas.
  final ServicioLigas _servicio = ServicioLigas();

  /// Servicio de registro de eventos y advertencias.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearLiga
    Descripción:
      Crea una liga con nombre, descripción y temporada calculada
      automáticamente. Se validan los nuevos campos introducidos para
      totalFechasTemporada y se inicializa fechasCreadas en cero.
    Entradas:
      - nombre: String — Nombre de la liga.
      - descripcion: String — Descripción opcional.
      - totalFechasTemporada (opcional): int — Cantidad total de fechas (34–50).
    Salidas:
      - Future<Liga> — Liga creada con ID asignado.
  */
  Future<Liga> crearLiga(
    String nombre,
    String descripcion, {
    int totalFechasTemporada = 38,
  }) async {
    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_LIGA_NOMBRE_VACIO);
    }

    // Validación obligatoria del nuevo campo
    if (totalFechasTemporada < 34 || totalFechasTemporada > 50) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorLigasTotalFechasRango),
      );
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final temporadaFormateada = AppStrings.text(
      AppStrings.controladorLigasTemporada,
      args: {
        'anio': '${DateTime.now().year}',
        'anioSiguiente': '${DateTime.now().year + 1}',
      },
    );

    final liga = Liga(
      id: "",
      nombre: nombre.trim(),
      temporada: temporadaFormateada,
      descripcion: descripcion.trim().isEmpty
          ? TextosApp.LIGA_DESCRIPCION_POR_DEFECTO
          : descripcion.trim(),
      fechaCreacion: timestamp,
      activa: true,
      totalFechasTemporada: totalFechasTemporada,
      fechasCreadas: 0, // obligatorio según mod0015
    );

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorLigasLogCreando,
        args: {'nombre': nombre},
      ),
    );

    return await _servicio.crearLiga(liga);
  }

  /*
    Nombre: obtenerActivas
    Descripción:
      Recupera todas las ligas con estado activo.
    Entradas:
      - ninguna
    Salidas:
      - Future<List<Liga>>
  */
  Future<List<Liga>> obtenerActivas() async {
    _log.informacion(
      AppStrings.text(AppStrings.controladorLigasLogObtenerActivas),
    );
    return await _servicio.obtenerLigasActivas();
  }

  /*
    Nombre: obtenerPorId
    Descripción:
      Recupera una liga a partir de su identificador. Devuelve null si
      no existe coincidencia en el repositorio.
    Entradas:
      - idLiga (String): identificador de la liga.
    Salidas:
      - Future<Liga?>
  */
  Future<Liga?> obtenerPorId(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorLigasIdLigaVacio),
      );
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorLigasLogRecuperando,
        args: {'idLiga': idLiga},
      ),
    );
    return await _servicio.obtenerLiga(idLiga);
  }

  /*
    Nombre: buscar
    Descripción:
      Busca ligas cuyo nombre coincida con el texto indicado.
    Entradas:
      - texto: String
    Salidas:
      - Future<List<Liga>>
  */
  Future<List<Liga>> buscar(String texto) async {
    if (texto.trim().isEmpty) {
      _log.advertencia(
        AppStrings.text(AppStrings.controladorLigasLogBusquedaVacia),
      );
      return [];
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorLigasLogBuscar,
        args: {'texto': texto},
      ),
    );
    return await _servicio.buscarLigasPorNombre(texto.trim());
  }

  /*
    Nombre: obtenerTodas
    Descripción:
      Obtiene todas las ligas sin filtrar estado.
    Entradas: ninguna
    Salidas: Future<List<Liga>>
  */
  Future<List<Liga>> obtenerTodas() async {
    return await _servicio.obtenerTodasLasLigas();
  }

  /*
    Nombre: editarLiga
    Descripción:
      Actualiza los datos de una liga, permitiendo modificar campos como
      totalFechasTemporada y fechasCreadas. Usado por otros controladores.
    Entradas:
      - liga: Liga — Instancia modificada.
    Salidas:
      - Future<void>
  */
  Future<void> editarLiga(Liga liga) async {
    // Validación de consistencia con el nuevo modelo
    if (liga.totalFechasTemporada < 34 || liga.totalFechasTemporada > 50) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorLigasTotalFechasRango),
      );
    }

    if (liga.fechasCreadas < 0) {
      throw ArgumentError(
        AppStrings.text(AppStrings.controladorLigasFechasNegativas),
      );
    }

    _log.informacion(
      AppStrings.text(
        AppStrings.controladorLigasLogEditar,
        args: {'idLiga': liga.id},
      ),
    );
    await _servicio.editarLiga(liga);
  }

  /*
    Nombre: archivar
    Descripción:
      Marca una liga como inactiva sin eliminarla.
    Entradas:
      - id: String — Identificador de liga.
    Salidas:
      - Future<void>
  */
  Future<void> archivar(String id) async {
    _log.advertencia(
      AppStrings.text(
        AppStrings.controladorLigasLogArchivar,
        args: {'idLiga': id},
      ),
    );
    await _servicio.archivarLiga(id);
  }

  /*
    Nombre: activar
    Descripción:
      Activa una liga específica.
    Entradas:
      - id: String
    Salidas:
      - Future<void>
  */
  Future<void> activar(String id) async {
    _log.informacion(
      AppStrings.text(
        AppStrings.controladorLigasLogActivar,
        args: {'idLiga': id},
      ),
    );
    await _servicio.activarLiga(id);
  }

  /*
    Nombre: eliminar
    Descripción:
      Elimina una liga del sistema.
    Entradas:
      - id: String
    Salidas:
      - Future<void>
  */
  Future<void> eliminar(String id) async {
    _log.error(
      AppStrings.text(
        AppStrings.controladorLigasLogEliminar,
        args: {'idLiga': id},
      ),
    );
    await _servicio.eliminarLiga(id);
  }
}
