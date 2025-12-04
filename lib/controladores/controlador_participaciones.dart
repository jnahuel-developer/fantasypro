/*
  Archivo: controlador_participaciones.dart
  Descripción:
    Lógica de negocio y validación para la gestión de participaciones
    de usuarios en una liga.
    Se mantiene el método crearParticipacionSiNoExiste que asegura unicidad usuario–liga.
    Se conserva registrarParticipacionUsuario como wrapper/wrapper extendido
    para dicho método, adaptado a la corrección del flujo mod0017+mod0018:
    al registrar participación, también crea automáticamente el equipo fantasy asociado.
*/

import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorParticipaciones {
  final ServicioParticipaciones _servicio = ServicioParticipaciones();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear participación (Etapa 1)
  // ---------------------------------------------------------------------------
  Future<ParticipacionLiga> crearParticipacionSiNoExiste(
    String idLiga,
    String idUsuario,
    String nombreEquipoFantasy,
  ) async {
    if (idLiga.isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (nombreEquipoFantasy.isEmpty) {
      throw ArgumentError("El nombre del equipo fantasy no puede estar vacío.");
    }

    _log.informacion(
      "Verificando si usuario $idUsuario ya participa en liga $idLiga",
    );

    final bool yaParticipa = await _servicio.usuarioYaParticipa(
      idUsuario,
      idLiga,
    );

    if (yaParticipa) {
      _log.advertencia("El usuario ya participa en la liga");
      throw Exception("El usuario ya participa en esta liga.");
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final participacion = ParticipacionLiga(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      nombreEquipoFantasy: nombreEquipoFantasy,
      puntos: 0,
      plantelCompleto: false,
      fechaCreacion: timestamp,
      activo: true,
    );

    _log.informacion("Creando participación (Etapa 1)");

    return await _servicio.crearParticipacion(participacion);
  }

  // ---------------------------------------------------------------------------
  // registrarParticipacionUsuario — alias / wrapper corregido
  // ---------------------------------------------------------------------------
  /*
    Nombre: registrarParticipacionUsuario
    Descripción:
      Wrapper de crearParticipacionSiNoExiste. Además de crear la participación,
      crea automáticamente el equipo fantasy correspondiente para que la UI
      pueda encontrarlo inmediatamente.
  */
  Future<ParticipacionLiga> registrarParticipacionUsuario(
    String idLiga,
    String idUsuario,
    String nombreEquipoFantasy,
  ) async {
    final participacion = await crearParticipacionSiNoExiste(
      idLiga,
      idUsuario,
      nombreEquipoFantasy,
    );

    _log.informacion(
      "Creando equipo fantasy automáticamente tras registrar participación: usuario=$idUsuario, liga=$idLiga, nombreEquipo=$nombreEquipoFantasy",
    );

    // Crear equipo fantasy asociado — uso directo del servicio, sin intermediarios
    await ServicioEquiposFantasy().crearEquipoFantasy(
      idUsuario,
      idLiga,
      nombreEquipoFantasy,
    );

    return participacion;
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por liga
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    if (idLiga.isEmpty) {
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }

    _log.informacion("Listando participaciones de liga $idLiga");

    return await _servicio.obtenerPorLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por usuario
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    if (idUsuario.isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    _log.informacion("Listando participaciones del usuario $idUsuario");

    return await _servicio.obtenerPorUsuario(idUsuario);
  }

  // ---------------------------------------------------------------------------
  // Archivar participación
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idParticipacion) async {
    _log.advertencia("Archivando participación $idParticipacion");
    await _servicio.archivarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Activar participación
  // ---------------------------------------------------------------------------
  Future<void> activar(String idParticipacion) async {
    _log.informacion("Activando participación $idParticipacion");
    await _servicio.activarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar participación
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idParticipacion) async {
    _log.error("Eliminando participación $idParticipacion");
    await _servicio.eliminarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Editar participación
  // ---------------------------------------------------------------------------
  Future<void> editar(ParticipacionLiga participacion) async {
    if (participacion.id.isEmpty) {
      throw ArgumentError("El ID de la participación no puede estar vacío.");
    }
    if (participacion.puntos < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    _log.informacion("Editando participación ${participacion.id}");

    await _servicio.editarParticipacion(participacion);
  }
}
