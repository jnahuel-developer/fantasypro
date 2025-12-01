/*
  Archivo: jugador.dart
  Descripción:
    Modelo de datos que representa un Jugador dentro de un Equipo en FantasyPro.
    Incluye métodos de serialización y deserialización para Firestore.
  Dependencias:
    - Ninguna directa.
*/

class Jugador {
  /// Identificador único del jugador dentro de Firestore.
  final String id;

  /// Identificador del equipo al que pertenece el jugador.
  final String idEquipo;

  /// Nombre visible del jugador.
  final String nombre;

  /// Posición del jugador dentro del campo.
  final String posicion;

  /// Nacionalidad del jugador.
  final String nacionalidad;

  /// Número de dorsal del jugador.
  final int dorsal;

  /// Fecha de creación expresada como timestamp (milisegundos desde época Unix).
  final int fechaCreacion;

  /// Estado del jugador (true = activo, false = archivado).
  final bool activo;

  /*
    Constructor principal del Jugador.
    Entradas:
      - id (String): identificador único.
      - idEquipo (String): referencia al equipo propietario.
      - nombre (String): nombre del jugador.
      - posicion (String): posición dentro del campo.
      - nacionalidad (String): país de origen.
      - dorsal (int): número de camiseta.
      - fechaCreacion (int): timestamp de creación.
      - activo (bool): estado actual del jugador.
    Salida:
      - Instancia de Jugador.
  */
  const Jugador({
    required this.id,
    required this.idEquipo,
    required this.nombre,
    required this.posicion,
    required this.nacionalidad,
    required this.dorsal,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de Jugador a partir de un Map proveniente de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): datos obtenidos desde Firestore.
    Salidas:
      - Instancia de Jugador.
  */
  factory Jugador.desdeMapa(String id, Map<String, dynamic> datos) {
    return Jugador(
      id: id,
      idEquipo: datos['idEquipo'] ?? '',
      nombre: datos['nombre'] ?? '',
      posicion: datos['posicion'] ?? '',
      nacionalidad: datos['nacionalidad'] ?? '',
      dorsal: datos['dorsal'] ?? 0,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte la instancia actual en un Map<String, dynamic>
      para poder almacenarla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos serializados.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idEquipo': idEquipo,
      'nombre': nombre,
      'posicion': posicion,
      'nacionalidad': nacionalidad,
      'dorsal': dorsal,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Permite crear una copia del Jugador modificando únicamente los campos 
      deseados. Útil para procesos de edición o actualización parcial.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia de Jugador con los cambios aplicados.
  */
  Jugador copiarCon({
    String? id,
    String? idEquipo,
    String? nombre,
    String? posicion,
    String? nacionalidad,
    int? dorsal,
    int? fechaCreacion,
    bool? activo,
  }) {
    return Jugador(
      id: id ?? this.id,
      idEquipo: idEquipo ?? this.idEquipo,
      nombre: nombre ?? this.nombre,
      posicion: posicion ?? this.posicion,
      nacionalidad: nacionalidad ?? this.nacionalidad,
      dorsal: dorsal ?? this.dorsal,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
