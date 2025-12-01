/*
  Archivo: participacion_liga.dart
  Descripción:
    Modelo de datos que representa la participación de un usuario dentro de una liga.
    Incluye métodos de serialización y deserialización para Firestore.

  Dependencias:
    - Ninguna directa.
  Archivos que dependen de este archivo:
    - Controladores y servicios de participaciones.
*/

class ParticipacionLiga {
  /// Identificador único de la participación en Firestore.
  final String id;

  /// Identificador de la liga asociada.
  final String idLiga;

  /// Identificador del usuario que participa en la liga.
  final String idUsuario;

  /// Nombre del equipo fantasy asignado por el usuario.
  final String nombreEquipoFantasy;

  /// Puntos acumulados por la participación.
  final int puntos;

  /// Fecha de creación como timestamp (milisegundos desde época Unix).
  final int fechaCreacion;

  /// Estado de la participación (true = activa, false = archivada).
  final bool activo;

  /*
    Constructor principal de ParticipacionLiga.
    Entradas:
      - id (String)
      - idLiga (String)
      - idUsuario (String)
      - nombreEquipoFantasy (String)
      - puntos (int)
      - fechaCreacion (int)
      - activo (bool)
    Salida:
      - Instancia de ParticipacionLiga.
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
      Crea una instancia de ParticipacionLiga a partir de datos Firestore.
    Entradas:
      - id (String): id del documento.
      - datos (Map<String, dynamic>): datos deserializados.
    Salidas:
      - Instancia de ParticipacionLiga.
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
      Convierte la instancia en un Map<String, dynamic> para almacenar en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> representando la participación.
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
      Permite crear una copia de ParticipacionLiga modificando campos específicos.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia con los cambios aplicados.
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
