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
      automáticamente.
      Aplica reglas de negocio:
        - Validar nombre no vacío.
        - Exigir totalFechasTemporada entre 34 y 50.
        - Inicializar fechasCreadas en cero para nuevas ligas.
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

    if (totalFechasTemporada < 34 || totalFechasTemporada > 50) {
      throw ArgumentError(TextosApp.ERR_CTRL_TOTAL_FECHAS_RANGO);
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final temporadaFormateada =
        "${TextosApp.LIGA_TEXTO_TEMPORADA} ${DateTime.now().year}/${DateTime.now().year + 1}";

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
      fechasCreadas: 0,
    );

    _log.informacion("${TextosApp.LOG_LIGA_CREANDO} $nombre");

    return await _servicio.crearLiga(liga);
  }

  /*
    Nombre: obtenerActivas
    Descripción:
      Recupera todas las ligas con estado activo.
      Aplica reglas de negocio:
        - Sin reglas adicionales, delega al servicio.
    Entradas:
      - ninguna
    Salidas:
      - Future<List<Liga>>
  */
  Future<List<Liga>> obtenerActivas() async {
    _log.informacion(TextosApp.LOG_LIGA_LISTAR_ACTIVAS);
    return await _servicio.obtenerLigasActivas();
  }

  /*
    Nombre: obtenerPorId
    Descripción:
      Recupera una liga a partir de su identificador. Devuelve null si
      no existe coincidencia en el repositorio.
      Aplica reglas de negocio:
        - Validar el id de liga no vacío.
    Entradas:
      - idLiga (String): identificador de la liga.
    Salidas:
      - Future<Liga?>
  */
  Future<Liga?> obtenerPorId(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    _log.informacion("${TextosApp.LOG_LIGA_OBTENER} $idLiga");
    return await _servicio.obtenerLiga(idLiga);
  }

  /*
    Nombre: buscar
    Descripción:
      Busca ligas cuyo nombre coincida con el texto indicado.
      Aplica reglas de negocio:
        - Retorna lista vacía si el texto está vacío en lugar de consultar.
    Entradas:
      - texto: String
    Salidas:
      - Future<List<Liga>>
  */
  Future<List<Liga>> buscar(String texto) async {
    if (texto.trim().isEmpty) {
      _log.advertencia(TextosApp.ERR_CTRL_BUSQUEDA_TEXTO_VACIO);
      return [];
    }

    _log.informacion("${TextosApp.LOG_LIGA_BUSCAR_NOMBRE} '$texto'");
    return await _servicio.buscarLigasPorNombre(texto.trim());
  }

  /*
    Nombre: obtenerTodas
    Descripción:
      Obtiene todas las ligas sin filtrar estado.
      Aplica reglas de negocio:
        - Sin reglas adicionales, entrega todo el catálogo.
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
      Aplica reglas de negocio:
        - Validar que totalFechasTemporada se mantenga en rango permitido.
        - Verificar que fechasCreadas no sea negativa.
    Entradas:
      - liga: Liga — Instancia modificada.
    Salidas:
      - Future<void>
  */
  Future<void> editarLiga(Liga liga) async {
    if (liga.totalFechasTemporada < 34 || liga.totalFechasTemporada > 50) {
      throw ArgumentError(TextosApp.ERR_CTRL_TOTAL_FECHAS_RANGO);
    }

    if (liga.fechasCreadas < 0) {
      throw ArgumentError(TextosApp.ERR_CTRL_FECHAS_CREADAS_NEGATIVAS);
    }

    _log.informacion("${TextosApp.LOG_LIGA_EDITADA} ${liga.id}");
    await _servicio.editarLiga(liga);
  }

  /*
    Nombre: archivar
    Descripción:
      Marca una liga como inactiva sin eliminarla.
      Aplica reglas de negocio:
        - No aplica reglas adicionales más allá del registro de log.
    Entradas:
      - id: String — Identificador de liga.
    Salidas:
      - Future<void>
  */
  Future<void> archivar(String id) async {
    _log.advertencia("${TextosApp.LOG_LIGA_ARCHIVADA} $id");
    await _servicio.archivarLiga(id);
  }

  /*
    Nombre: activar
    Descripción:
      Activa una liga específica.
      Aplica reglas de negocio:
        - No aplica reglas adicionales más allá del registro de log.
    Entradas:
      - id: String
    Salidas:
      - Future<void>
  */
  Future<void> activar(String id) async {
    _log.informacion("${TextosApp.LOG_LIGA_ACTIVADA} $id");
    await _servicio.activarLiga(id);
  }

  /*
    Nombre: eliminar
    Descripción:
      Elimina una liga del sistema.
      Aplica reglas de negocio:
        - No aplica reglas adicionales más allá de registrar el evento crítico.
    Entradas:
      - id: String
    Salidas:
      - Future<void>
  */
  Future<void> eliminar(String id) async {
    _log.error("${TextosApp.LOG_LIGA_ELIMINADA} $id");
    await _servicio.eliminarLiga(id);
  }
}
