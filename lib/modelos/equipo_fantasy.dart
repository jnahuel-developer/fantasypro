/*
  Archivo: equipo_fantasy.dart
  Descripción:
    Modelo de datos que representa un Equipo FANTASY creado por un usuario
    dentro de una liga en FantasyPro. Este modelo corresponde únicamente al
    equipo fantasy del usuario final y no incluye datos de presupuesto,
    mercado, planteles ni alineaciones en esta etapa.

  Dependencias:
    - Ninguna directa.
  Archivos que dependen de este archivo:
    - Controladores de participación y equipo fantasy.
    - Servicios vinculados al flujo de creación de equipo por parte del usuario.
*/

class EquipoFantasy {
  /// Identificador único del equipo fantasy dentro de Firestore.
  final String id;

  /// Identificador del usuario propietario del equipo fantasy.
  final String idUsuario;

  /// Identificador de la liga en la que participa el equipo fantasy.
  final String idLiga;

  /// Nombre visible del equipo fantasy.
  final String nombre;

  /// Fecha de creación expresada como timestamp (milisegundos desde época Unix).
  final int fechaCreacion;

  /// Estado del equipo fantasy (true = activo, false = archivado).
  final bool activo;

  /*
    Constructor principal de EquipoFantasy.
    Entradas:
      - id (String): identificador único del equipo.
      - idUsuario (String): identificador del usuario creador.
      - idLiga (String): liga donde participa el equipo fantasy.
      - nombre (String): nombre visible del equipo fantasy.
      - fechaCreacion (int): timestamp de creación.
      - activo (bool): indica si el equipo se encuentra activo.
    Salida:
      - Instancia de EquipoFantasy.
  */
  const EquipoFantasy({
    required this.id,
    required this.idUsuario,
    required this.idLiga,
    required this.nombre,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de EquipoFantasy a partir de un Map proveniente de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): datos obtenidos desde Firestore.
    Salidas:
      - Instancia de EquipoFantasy.
  */
  factory EquipoFantasy.desdeMapa(String id, Map<String, dynamic> datos) {
    return EquipoFantasy(
      id: id,
      idUsuario: datos['idUsuario'] ?? '',
      idLiga: datos['idLiga'] ?? '',
      nombre: datos['nombre'] ?? '',
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte la instancia actual en un Map<String, dynamic>
      para almacenar sus datos en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos serializados.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idUsuario': idUsuario,
      'idLiga': idLiga,
      'nombre': nombre,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Permite crear una copia del EquipoFantasy modificando únicamente los campos
      deseados, útil para modificaciones parciales.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia de EquipoFantasy con los cambios aplicados.
  */
  EquipoFantasy copiarCon({
    String? id,
    String? idUsuario,
    String? idLiga,
    String? nombre,
    int? fechaCreacion,
    bool? activo,
  }) {
    return EquipoFantasy(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      idLiga: idLiga ?? this.idLiga,
      nombre: nombre ?? this.nombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
