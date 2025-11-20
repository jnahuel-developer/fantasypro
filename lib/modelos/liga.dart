/*
  Archivo: liga.dart
  Descripción:
    Modelo de datos que representa una Liga dentro del sistema FantasyPro.
    Incluye métodos para serialización/deserialización desde y hacia Firestore.
  Dependencias:
    - Ninguna directa (solo tipos básicos de Dart).
*/

class Liga {
  /// Identificador único de la liga dentro de Firestore.
  final String id;

  /// Nombre visible de la liga (ej.: "Liga Pro 2024").
  final String nombre;

  /// Temporada asociada (ej.: "2024/2025").
  final String temporada;

  /// Descripción breve de la liga.
  final String descripcion;

  /// Fecha de creación expresada como timestamp (milisegundos desde época Unix).
  final int fechaCreacion;

  /// Estado de la liga (true = activa, false = archivada).
  final bool activa;

  /*
    Constructor principal de la Liga.
    Entradas:
      - id (String): identificador único.
      - nombre (String): nombre visible de la liga.
      - temporada (String): temporada asociada.
      - descripcion (String): texto descriptivo.
      - fechaCreacion (int): timestamp de creación.
      - activa (bool): estado actual de la liga.
    Salida:
      - Instancia de Liga.
  */
  const Liga({
    required this.id,
    required this.nombre,
    required this.temporada,
    required this.descripcion,
    required this.fechaCreacion,
    required this.activa,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de Liga a partir de un Map proveniente de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): datos obtenidos desde Firestore.
    Salidas:
      - Instancia de Liga.
  */
  factory Liga.desdeMapa(String id, Map<String, dynamic> datos) {
    return Liga(
      id: id,
      nombre: datos['nombre'] ?? '',
      temporada: datos['temporada'] ?? '',
      descripcion: datos['descripcion'] ?? '',
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activa: datos['activa'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte la instancia actual en un Map<String, dynamic> para poder
      almacenarla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos serializados.
  */
  Map<String, dynamic> aMapa() {
    return {
      'nombre': nombre,
      'temporada': temporada,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion,
      'activa': activa,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Permite crear una copia de la Liga modificando únicamente los campos
      deseados. Útil para la edición de ligas.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia de Liga con los cambios aplicados.
  */
  Liga copiarCon({
    String? id,
    String? nombre,
    String? temporada,
    String? descripcion,
    int? fechaCreacion,
    bool? activa,
  }) {
    return Liga(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      temporada: temporada ?? this.temporada,
      descripcion: descripcion ?? this.descripcion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activa: activa ?? this.activa,
    );
  }
}
