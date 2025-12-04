/*
  Archivo: jugador_real.dart
  Descripción:
    Modelo de datos que representa un Jugador Real dentro del sistema FantasyPro.
    Describe futbolistas que pertenecen a equipos reales y es utilizado por
    módulos administrativos, catálogos y lógicas que consumen datos reales.

  Dependencias:
    - Ninguna directa.

  Archivos que dependen de este:
    - Servicios y controladores que gestionan jugadores reales.
    - Módulos que listan o consultan información de jugadores reales.
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

  /// Nacionalidad del jugador real.
  final String nacionalidad;

  /// Número de dorsal del jugador (1–99).
  final int dorsal;

  /// Valor de mercado del jugador (1–1000).
  final int valorMercado;

  /// Estado del jugador (true = activo, false = archivado).
  final bool activo;

  /// Timestamp de creación en milisegundos desde época Unix.
  final int fechaCreacion;

  /// Nombre del equipo real al que pertenece el jugador.
  final String nombreEquipoReal;

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
      - nombreEquipoReal (String): nombre textual del equipo real.
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
    required this.nombreEquipoReal,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de JugadorReal desde un Map obtenido de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): valores serializados.
    Salidas:
      - Instancia de JugadorReal.
    Ejemplo:
      final j = JugadorReal.desdeMapa("J1", snapshot.data());
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
      nombreEquipoReal: datos['nombreEquipoReal'] ?? '',
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte esta instancia de JugadorReal en un mapa serializable para
      persistirla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos del jugador.
    Ejemplo:
      firestore.set({...jugadorReal.aMapa()});
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
      'nombreEquipoReal': nombreEquipoReal,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Crea una copia del jugador real actual modificando únicamente los campos
      que se indiquen como parámetros opcionales.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia de JugadorReal con cambios aplicados.
    Ejemplo:
      final actualizado = jugador.copiarCon(valorMercado: 120);
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
    String? nombreEquipoReal,
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
      nombreEquipoReal: nombreEquipoReal ?? this.nombreEquipoReal,
    );
  }
}
