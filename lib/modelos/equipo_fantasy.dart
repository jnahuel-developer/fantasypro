/*
  Archivo: equipo_fantasy.dart
  Descripción:
    Modelo que representa un Equipo Fantasy creado por un usuario dentro de una liga.
    Incluye información de presupuesto y el plantel inicial de 15 jugadores reales.
  Responsabilidades:
    - Persistir los datos principales del equipo fantasy.
    - Mantener el presupuesto inicial y restante.
    - Almacenar la lista fija de 15 jugadores del plantel.
    - Permitir serialización, deserialización y copia.
  Dependencias directas:
    - Ninguna.
  Archivos que dependen de este:
    - alineacion.dart
    - participacion_liga.dart
*/

class EquipoFantasy {
  /// Identificador del documento en Firestore.
  final String id;

  /// Identificador del usuario que creó el equipo.
  final String idUsuario;

  /// Identificador de la liga a la que pertenece el equipo fantasy.
  final String idLiga;

  /// Nombre del equipo fantasy.
  final String nombre;

  /// Presupuesto asignado al usuario al crear el equipo.
  final int presupuestoInicial;

  /// Presupuesto restante luego de seleccionar el plantel inicial.
  final int presupuestoRestante;

  /// Lista fija de los 15 jugadores reales seleccionados.
  final List<String> idsJugadoresPlantel;

  /// Timestamp de creación en milisegundos.
  final int fechaCreacion;

  /// Estado del equipo.
  final bool activo;

  /*
    Nombre: Constructor principal de EquipoFantasy
    Descripción:
      Crea una instancia completa del modelo.
    Entradas:
      - Todos los campos obligatorios.
    Salidas:
      - Instancia de EquipoFantasy.
  */
  const EquipoFantasy({
    required this.id,
    required this.idUsuario,
    required this.idLiga,
    required this.nombre,
    required this.presupuestoInicial,
    required this.presupuestoRestante,
    required this.idsJugadoresPlantel,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Construye una instancia desde un Map de Firestore.
    Entradas:
      - id: identificador del documento.
      - datos: mapa con la información del equipo.
    Salidas:
      - Instancia de EquipoFantasy.
  */
  factory EquipoFantasy.desdeMapa(String id, Map<String, dynamic> datos) {
    return EquipoFantasy(
      id: id,
      idUsuario: datos['idUsuario'] ?? '',
      idLiga: datos['idLiga'] ?? '',
      nombre: datos['nombre'] ?? '',
      presupuestoInicial: datos['presupuestoInicial'] ?? 1000,
      presupuestoRestante: datos['presupuestoRestante'] ?? 1000,
      idsJugadoresPlantel: List<String>.from(
        datos['idsJugadoresPlantel'] ?? [],
      ),
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Serializa la instancia actual en un mapa.
    Entradas:
      - Ninguna.
    Salidas:
      - Mapa<String, dynamic> para almacenar en Firestore.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idUsuario': idUsuario,
      'idLiga': idLiga,
      'nombre': nombre,
      'presupuestoInicial': presupuestoInicial,
      'presupuestoRestante': presupuestoRestante,
      'idsJugadoresPlantel': idsJugadoresPlantel,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Genera una copia modificada del objeto.
    Entradas:
      - Campos opcionales para reemplazar.
    Salidas:
      - Nueva instancia de EquipoFantasy.
  */
  EquipoFantasy copiarCon({
    String? id,
    String? idUsuario,
    String? idLiga,
    String? nombre,
    int? presupuestoInicial,
    int? presupuestoRestante,
    List<String>? idsJugadoresPlantel,
    int? fechaCreacion,
    bool? activo,
  }) {
    return EquipoFantasy(
      id: id ?? this.id,
      idUsuario: idUsuario ?? this.idUsuario,
      idLiga: idLiga ?? this.idLiga,
      nombre: nombre ?? this.nombre,
      presupuestoInicial: presupuestoInicial ?? this.presupuestoInicial,
      presupuestoRestante: presupuestoRestante ?? this.presupuestoRestante,
      idsJugadoresPlantel: idsJugadoresPlantel ?? this.idsJugadoresPlantel,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
