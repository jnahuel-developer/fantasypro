// DEPRECATED en mod0013 — reemplazado por EquipoReal y EquipoFantasy

/*
  Archivo: equipo.dart
  Descripción:
    Modelo de datos que representa un Equipo dentro de una Liga en FantasyPro.
    Incluye métodos de serialización y deserialización para Firestore.
    Ajustado para Etapa 1:
      - Se agrega idUsuario (obligatorio)
      - Se preservan todos los campos existentes para compatibilidad futura
*/

class Equipo {
  // ---------------------------------------------------------------------------
  // Campos Firestore (constantes internas para evitar hardcodeo)
  // ---------------------------------------------------------------------------
  static const String campoIdLiga = "idLiga";
  static const String campoIdUsuario = "idUsuario";
  static const String campoNombre = "nombre";
  static const String campoDescripcion = "descripcion";
  static const String campoEscudoUrl = "escudoUrl";
  static const String campoFechaCreacion = "fechaCreacion";
  static const String campoActivo = "activo";

  // ---------------------------------------------------------------------------
  // Atributos del modelo
  // ---------------------------------------------------------------------------
  final String id; // ID del documento en Firestore
  final String idLiga; // Liga a la cual pertenece
  final String idUsuario; // Usuario creador/propietario del equipo (nuevo)
  final String nombre; // Nombre visible
  final String descripcion; // Descripción breve
  final String escudoUrl; // URL del escudo (opcional)
  final int fechaCreacion; // Timestamp en milisegundos
  final bool activo; // true = activo, false = archivado

  // ---------------------------------------------------------------------------
  // Constructor principal
  // ---------------------------------------------------------------------------
  const Equipo({
    required this.id,
    required this.idLiga,
    required this.idUsuario,
    required this.nombre,
    required this.descripcion,
    required this.escudoUrl,
    required this.fechaCreacion,
    required this.activo,
  });

  // ---------------------------------------------------------------------------
  // Deserialización desde Firestore
  // ---------------------------------------------------------------------------
  factory Equipo.desdeMapa(String id, Map<String, dynamic> datos) {
    return Equipo(
      id: id,
      idLiga: datos[campoIdLiga] ?? "",
      idUsuario: datos[campoIdUsuario] ?? "",
      nombre: datos[campoNombre] ?? "",
      descripcion: datos[campoDescripcion] ?? "",
      escudoUrl: datos[campoEscudoUrl] ?? "",
      fechaCreacion: datos[campoFechaCreacion] ?? 0,
      activo: datos[campoActivo] ?? true,
    );
  }

  // ---------------------------------------------------------------------------
  // Serialización a Firestore
  // ---------------------------------------------------------------------------
  Map<String, dynamic> aMapa() {
    return {
      campoIdLiga: idLiga,
      campoIdUsuario: idUsuario,
      campoNombre: nombre,
      campoDescripcion: descripcion,
      campoEscudoUrl: escudoUrl,
      campoFechaCreacion: fechaCreacion,
      campoActivo: activo,
    };
  }

  // ---------------------------------------------------------------------------
  // Copia con campos opcionales
  // ---------------------------------------------------------------------------
  Equipo copiarCon({
    String? id,
    String? idLiga,
    String? idUsuario,
    String? nombre,
    String? descripcion,
    String? escudoUrl,
    int? fechaCreacion,
    bool? activo,
  }) {
    return Equipo(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      escudoUrl: escudoUrl ?? this.escudoUrl,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
