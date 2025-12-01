/*
  Archivo: jugador_real.dart
  Descripción:
    Modelo de datos que representa un Jugador Real dentro del sistema FantasyPro.
    Este modelo describe jugadores de equipos reales y es utilizado por secciones
    administrativas y módulos que consumen datos de fútbol profesional.

  Dependencias:
    - Ninguna directa.

  Archivos que dependen de este:
    - Servicios y controladores que gestionen jugadores reales.
    - Cualquier módulo que liste o consulte información de jugadores reales.
*/

class JugadorReal {
  /// Identificador único del jugador real en Firestore.
  final String id;

  /// Identificador del equipo real al que pertenece el jugador.
  final String idEquipoReal;

  /// Nombre visible del jugador real.
  final String nombre;

  /// Posición del jugador (POR, DEF, MED, DEL).
  final String posicion;

  /// Nacionalidad del jugador.
  final String nacionalidad;

  /// Número de dorsal del jugador (1–99).
  final int dorsal;

  /// Valor de mercado del jugador (1–1000).
  final int valorMercado;

  /// Estado del jugador (true = activo, false = archivado).
  final bool activo;

  /// Timestamp de creación en milisegundos desde época Unix.
  final int fechaCreacion;

  /*
    Nombre: JugadorReal (constructor)
    Descripción:
      Construye un jugador real con todos sus campos obligatorios.
    Entradas:
      - id (String): identificador del jugador.
      - idEquipoReal (String): referencia al equipo real del jugador.
      - nombre (String): nombre del jugador.
      - posicion (String): posición del jugador (POR/DEF/MED/DEL).
      - nacionalidad (String): país de origen.
      - dorsal (int): número de camiseta.
      - valorMercado (int): valor de mercado del jugador.
      - activo (bool): estado actual.
      - fechaCreacion (int): timestamp de creación.
    Salidas:
      - Instancia de JugadorReal.
  */
  const JugadorReal({
    required this.id,
    required this.idEquipoReal,
    required this.nombre,
    required this.posicion,
    required this.nacionalidad,
    required this.dorsal,
    required this.valorMercado,
    required this.activo,
    required this.fechaCreacion,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de JugadorReal desde un Map obtenido de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): mapa con los valores serializados.
    Salidas:
      - Instancia de JugadorReal.
  */
  factory JugadorReal.desdeMapa(String id, Map<String, dynamic> datos) {
    return JugadorReal(
      id: id,
      idEquipoReal: datos['idEquipoReal'] ?? '',
      nombre: datos['nombre'] ?? '',
      posicion: datos['posicion'] ?? '',
      nacionalidad: datos['nacionalidad'] ?? '',
      dorsal: datos['dorsal'] ?? 0,
      valorMercado: datos['valorMercado'] ?? 0,
      activo: datos['activo'] ?? true,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte esta instancia de JugadorReal en un mapa serializable.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos serializados.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idEquipoReal': idEquipoReal,
      'nombre': nombre,
      'posicion': posicion,
      'nacionalidad': nacionalidad,
      'dorsal': dorsal,
      'valorMercado': valorMercado,
      'activo': activo,
      'fechaCreacion': fechaCreacion,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Crea una copia de este jugador real modificando solo los campos deseados.
    Entradas:
      - Campos a reemplazar de manera opcional.
    Salidas:
      - Nueva instancia de JugadorReal con los cambios aplicados.
  */
  JugadorReal copiarCon({
    String? id,
    String? idEquipoReal,
    String? nombre,
    String? posicion,
    String? nacionalidad,
    int? dorsal,
    int? valorMercado,
    bool? activo,
    int? fechaCreacion,
  }) {
    return JugadorReal(
      id: id ?? this.id,
      idEquipoReal: idEquipoReal ?? this.idEquipoReal,
      nombre: nombre ?? this.nombre,
      posicion: posicion ?? this.posicion,
      nacionalidad: nacionalidad ?? this.nacionalidad,
      dorsal: dorsal ?? this.dorsal,
      valorMercado: valorMercado ?? this.valorMercado,
      activo: activo ?? this.activo,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
