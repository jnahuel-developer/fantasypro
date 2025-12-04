/*
  Archivo: participacion_liga.dart
  Descripción:
    Modelo que representa la participación de un usuario dentro de una liga.
    Se amplía para incluir el estado del plantel fantasy.
  Responsabilidades:
    - Persistir asociación usuario–liga.
    - Registrar si el usuario ya completó el armado del plantel fantasy.
  Dependencias directas:
    - Ninguna.
  Archivos que dependen de este:
    - equipo_fantasy.dart
    - alineacion.dart
*/

class ParticipacionLiga {
  final String id;
  final String idLiga;
  final String idUsuario;

  /// Nombre del equipo fantasy del usuario.
  final String nombreEquipoFantasy;

  /// Puntos acumulados.
  final int puntos;

  /// True si terminó de armar su plantel fantasy.
  final bool plantelCompleto;

  final int fechaCreacion;
  final bool activo;

  const ParticipacionLiga({
    required this.id,
    required this.idLiga,
    required this.idUsuario,
    required this.nombreEquipoFantasy,
    required this.puntos,
    required this.plantelCompleto,
    required this.fechaCreacion,
    required this.activo,
  });

  factory ParticipacionLiga.desdeMapa(String id, Map<String, dynamic> datos) {
    return ParticipacionLiga(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      idUsuario: datos['idUsuario'] ?? '',
      nombreEquipoFantasy: datos['nombreEquipoFantasy'] ?? '',
      puntos: datos['puntos'] ?? 0,
      plantelCompleto: datos['plantelCompleto'] ?? false,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  Map<String, dynamic> aMapa() {
    return {
      'idLiga': idLiga,
      'idUsuario': idUsuario,
      'nombreEquipoFantasy': nombreEquipoFantasy,
      'puntos': puntos,
      'plantelCompleto': plantelCompleto,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  ParticipacionLiga copiarCon({
    String? id,
    String? idLiga,
    String? idUsuario,
    String? nombreEquipoFantasy,
    int? puntos,
    bool? plantelCompleto,
    int? fechaCreacion,
    bool? activo,
  }) {
    return ParticipacionLiga(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      idUsuario: idUsuario ?? this.idUsuario,
      nombreEquipoFantasy: nombreEquipoFantasy ?? this.nombreEquipoFantasy,
      puntos: puntos ?? this.puntos,
      plantelCompleto: plantelCompleto ?? this.plantelCompleto,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
