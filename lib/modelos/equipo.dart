/*
  Archivo: equipo.dart
  Descripción:
    Modelo de datos que representa un Equipo dentro de una Liga en FantasyPro.
    Incluye métodos de serialización y deserialización para Firestore.
  Dependencias:
    - Ninguna directa (solo tipos básicos de Dart).
*/

class Equipo {
  /// Identificador único del equipo en Firestore.
  final String id;

  /// Identificador de la liga a la que pertenece el equipo.
  final String idLiga;

  /// Nombre visible del equipo.
  final String nombre;

  /// Descripción breve del equipo.
  final String descripcion;

  /// URL del escudo del equipo (opcional).
  final String escudoUrl;

  /// Fecha de creación como timestamp en milisegundos.
  final int fechaCreacion;

  /// Estado del equipo (true = activo).
  final bool activo;

  /*
    Constructor principal del Equipo.
    Entradas:
      - id (String)
      - idLiga (String)
      - nombre (String)
      - descripcion (String)
      - escudoUrl (String)
      - fechaCreacion (int)
      - activo (bool)
  */
  const Equipo({
    required this.id,
    required this.idLiga,
    required this.nombre,
    required this.descripcion,
    required this.escudoUrl,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de Equipo desde un Map recuperado de Firestore.
  */
  factory Equipo.desdeMapa(String id, Map<String, dynamic> datos) {
    return Equipo(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      nombre: datos['nombre'] ?? '',
      descripcion: datos['descripcion'] ?? '',
      escudoUrl: datos['escudoUrl'] ?? '',
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte la instancia actual en un Map<String, dynamic> para Firestore.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idLiga': idLiga,
      'nombre': nombre,
      'descripcion': descripcion,
      'escudoUrl': escudoUrl,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Genera una nueva instancia copiando la actual pero con cambios opcionales.
  */
  Equipo copiarCon({
    String? id,
    String? idLiga,
    String? nombre,
    String? descripcion,
    String? escudoUrl,
    int? fechaCreacion,
    bool? activo,
  }) {
    return Equipo(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      escudoUrl: escudoUrl ?? this.escudoUrl,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
