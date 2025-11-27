/*
  Archivo: participacion_liga.dart
  Descripción:
    Modelo de datos que representa la participación de un usuario dentro de una liga.
    Incluye métodos de serialización/deserialización para Firestore.
  Dependencias:
    - Ninguna directa.
*/

class ParticipacionLiga {
  /// Identificador único de la participación en Firestore.
  final String id;

  /// Identificador de la liga asociada.
  final String idLiga;

  /// Identificador del usuario propietario.
  final String idUsuario;

  /// Nombre del equipo fantasy (opcional).
  final String nombreEquipoFantasy;

  /// Puntos acumulados por la participación (entero).
  final int puntos;

  /// Fecha de creación como timestamp (milisegundos desde epoch).
  final int fechaCreacion;

  /// Estado de la participación (true = activo, false = archivado).
  final bool activo;

  /*
    Constructor principal de ParticipacionLiga.
  */
  const ParticipacionLiga({
    required this.id,
    required this.idLiga,
    required this.idUsuario,
    required this.nombreEquipoFantasy,
    required this.puntos,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia a partir de un Map proveniente de Firestore.
  */
  factory ParticipacionLiga.desdeMapa(String id, Map<String, dynamic> datos) {
    return ParticipacionLiga(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      idUsuario: datos['idUsuario'] ?? '',
      nombreEquipoFantasy: datos['nombreEquipoFantasy'] ?? '',
      puntos: (datos['puntos'] is int)
          ? datos['puntos'] as int
          : (datos['puntos'] == null ? 0 : (datos['puntos'] as num).toInt()),
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte la instancia en un Map para Firestore.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idLiga': idLiga,
      'idUsuario': idUsuario,
      'nombreEquipoFantasy': nombreEquipoFantasy,
      'puntos': puntos,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Crea copia con campos opcionales reemplazados.
  */
  ParticipacionLiga copiarCon({
    String? id,
    String? idLiga,
    String? idUsuario,
    String? nombreEquipoFantasy,
    int? puntos,
    int? fechaCreacion,
    bool? activo,
  }) {
    return ParticipacionLiga(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      idUsuario: idUsuario ?? this.idUsuario,
      nombreEquipoFantasy: nombreEquipoFantasy ?? this.nombreEquipoFantasy,
      puntos: puntos ?? this.puntos,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
