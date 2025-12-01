/*
  Archivo: liga.dart
  Descripción:
    Modelo de datos que representa una Liga dentro del sistema FantasyPro.
    Incluye métodos para serialización/deserialización desde Firestore.

  Dependencias:
    - Ninguna directa.

  Archivos que dependen de este:
    - Servicios y controladores de administración de ligas.
    - Módulos de fechas, equipos y participaciones.
*/

class Liga {
  /// ID del documento en Firestore.
  final String id;

  /// Nombre visible de la liga.
  final String nombre;

  /// Temporada de la liga (ej.: "2024/2025").
  final String temporada;

  /// Texto descriptivo de la liga.
  final String descripcion;

  /// Timestamp de creación.
  final int fechaCreacion;

  /// Estado de la liga (activa o archivada).
  final bool activa;

  /// Cantidad total de fechas de la temporada (34–50).
  final int totalFechasTemporada;

  /// Cantidad de fechas creadas hasta el momento.
  final int fechasCreadas;

  /*
    Nombre: Liga (constructor)
    Responsabilidad:
      Crear instancia completa del modelo Liga.
  */
  const Liga({
    required this.id,
    required this.nombre,
    required this.temporada,
    required this.descripcion,
    required this.fechaCreacion,
    required this.activa,
    required this.totalFechasTemporada,
    required this.fechasCreadas,
  });

  /*
    Nombre: desdeMapa
    Responsabilidad:
      Construir una liga desde Firestore manteniendo compatibilidad con datos anteriores.
    Entradas:
      - id (String)
      - datos (Map<String, dynamic>)
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
      totalFechasTemporada: datos['totalFechasTemporada'] ?? 38,
      fechasCreadas: datos['fechasCreadas'] ?? 0,
    );
  }

  /*
    Nombre: aMapa
    Responsabilidad:
      Serializar la liga para almacenar en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic>
  */
  Map<String, dynamic> aMapa() {
    return {
      'nombre': nombre,
      'temporada': temporada,
      'descripcion': descripcion,
      'fechaCreacion': fechaCreacion,
      'activa': activa,
      'totalFechasTemporada': totalFechasTemporada,
      'fechasCreadas': fechasCreadas,
    };
  }

  /*
    Nombre: copiarCon
    Responsabilidad:
      Crear una copia modificando únicamente los campos deseados.
    Entradas:
      - Campos opcionales.
    Salidas:
      - Nueva instancia de Liga.
  */
  Liga copiarCon({
    String? id,
    String? nombre,
    String? temporada,
    String? descripcion,
    int? fechaCreacion,
    bool? activa,
    int? totalFechasTemporada,
    int? fechasCreadas,
  }) {
    return Liga(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      temporada: temporada ?? this.temporada,
      descripcion: descripcion ?? this.descripcion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activa: activa ?? this.activa,
      totalFechasTemporada: totalFechasTemporada ?? this.totalFechasTemporada,
      fechasCreadas: fechasCreadas ?? this.fechasCreadas,
    );
  }
}
