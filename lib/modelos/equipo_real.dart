/*
  Archivo: equipo_real.dart
  Descripción:
    Modelo de datos que representa un Equipo REAL administrado desde el panel
    de administración de FantasyPro. Este modelo corresponde a los equipos
    reales utilizados como base de referencia para planteles, alineaciones
    y jugadores reales en etapas futuras.

  Dependencias:
    - Ninguna directa.
  Archivos que dependen de este archivo:
    - Servicios y controladores de administración.
*/

class EquipoReal {
  /// Identificador único del equipo dentro de Firestore.
  final String id;

  /// Identificador de la liga real a la que pertenece el equipo.
  final String idLiga;

  /// Nombre visible del equipo real.
  final String nombre;

  /// Descripción breve del equipo real.
  final String descripcion;

  /// URL opcional del escudo del equipo real.
  final String escudoUrl;

  /// Fecha de creación expresada como timestamp (milisegundos desde época Unix).
  final int fechaCreacion;

  /// Estado del equipo (true = activo, false = archivado).
  final bool activo;

  /*
    Constructor principal de EquipoReal.
    Entradas:
      - id (String): identificador único.
      - idLiga (String): liga a la que pertenece el equipo real.
      - nombre (String): nombre visible del equipo.
      - descripcion (String): descripción corta.
      - escudoUrl (String): URL del escudo.
      - fechaCreacion (int): timestamp de creación.
      - activo (bool): indica si el equipo sigue activo.
    Salida:
      - Instancia de EquipoReal.
  */
  const EquipoReal({
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
      Crea una instancia de EquipoReal a partir de un Map proveniente de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): mapa de datos desde Firestore.
    Salidas:
      - Instancia de EquipoReal.
  */
  factory EquipoReal.desdeMapa(String id, Map<String, dynamic> datos) {
    return EquipoReal(
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
      Convierte esta instancia en un Map<String, dynamic> para almacenarla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos serializados.
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
      Crea una copia del EquipoReal con los campos opcionales modificados.
    Entradas:
      - Campos a reemplazar de manera opcional.
    Salidas:
      - Nueva instancia de EquipoReal con los cambios aplicados.
  */
  EquipoReal copiarCon({
    String? id,
    String? idLiga,
    String? nombre,
    String? descripcion,
    String? escudoUrl,
    int? fechaCreacion,
    bool? activo,
  }) {
    return EquipoReal(
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
