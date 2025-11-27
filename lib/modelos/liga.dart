/*
  Archivo: liga.dart
  Descripción:
    Modelo de datos que representa una Liga dentro del sistema FantasyPro.
    Incluye métodos para serialización/deserialización desde Firestore.
*/

class Liga {
  // ---------------------------------------------------------------------------
  // Campos Firestore (centralizados)
  // ---------------------------------------------------------------------------
  static const String campoNombre = "nombre";
  static const String campoTemporada = "temporada";
  static const String campoDescripcion = "descripcion";
  static const String campoFechaCreacion = "fechaCreacion";
  static const String campoActiva = "activa";

  // ---------------------------------------------------------------------------
  // Atributos del modelo
  // ---------------------------------------------------------------------------
  final String id; // ID del documento en Firestore
  final String nombre; // Nombre visible de la liga
  final String temporada; // Temporada ej: "2024/2025"
  final String descripcion; // Texto descriptivo
  final int fechaCreacion; // Timestamp (milisegundos)
  final bool activa; // true = activa, false = archivada

  // ---------------------------------------------------------------------------
  // Constructor principal
  // ---------------------------------------------------------------------------
  const Liga({
    required this.id,
    required this.nombre,
    required this.temporada,
    required this.descripcion,
    required this.fechaCreacion,
    required this.activa,
  });

  // ---------------------------------------------------------------------------
  // Deserialización desde Firestore
  // ---------------------------------------------------------------------------
  factory Liga.desdeMapa(String id, Map<String, dynamic> datos) {
    return Liga(
      id: id,
      nombre: datos[campoNombre] ?? "",
      temporada: datos[campoTemporada] ?? "",
      descripcion: datos[campoDescripcion] ?? "",
      fechaCreacion: datos[campoFechaCreacion] ?? 0,
      activa: datos[campoActiva] ?? true,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialización hacia Firestore
  // ---------------------------------------------------------------------------
  Map<String, dynamic> aMapa() {
    return {
      campoNombre: nombre,
      campoTemporada: temporada,
      campoDescripcion: descripcion,
      campoFechaCreacion: fechaCreacion,
      campoActiva: activa,
    };
  }

  // ---------------------------------------------------------------------------
  // Copia modificada
  // ---------------------------------------------------------------------------
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
