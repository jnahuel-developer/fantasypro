/*
  Archivo: fecha_liga.dart
  Descripción:
    Modelo de datos que representa una Fecha dentro de una Liga. Cada fecha
    corresponde a una jornada numerada y permite conocer su estado (activa,
    cerrada) y su fecha de creación.

  Dependencias:
    - Ninguna directa.

  Archivos que dependen de este:
    - Servicios y controladores encargados de generar, listar y cerrar fechas.
    - Interfaces administrativas que consultan y gestionan fechas de liga.
*/

class FechaLiga {
  /// Identificador único del documento en Firestore.
  final String id;

  /// Identificador de la liga a la cual pertenece esta fecha.
  final String idLiga;

  /// Número de la fecha dentro de la liga (1, 2, 3, ...).
  final int numeroFecha;

  /// Nombre visible de la fecha (ej.: "Fecha 1").
  final String nombre;

  /// Indica si esta fecha es la fecha activa de la liga.
  final bool activa;

  /// Indica si esta fecha ya fue cerrada.
  final bool cerrada;

  /// Timestamp de creación en milisegundos.
  final int fechaCreacion;

  /*
    Nombre: FechaLiga (constructor)
    Responsabilidad:
      Crear una instancia completa y consistente del modelo FechaLiga.
    Entradas:
      - id (String)
      - idLiga (String)
      - numeroFecha (int)
      - nombre (String)
      - activa (bool)
      - cerrada (bool)
      - fechaCreacion (int)
    Salidas:
      - Instancia de FechaLiga.
  */
  const FechaLiga({
    required this.id,
    required this.idLiga,
    required this.numeroFecha,
    required this.nombre,
    required this.activa,
    required this.cerrada,
    required this.fechaCreacion,
  });

  /*
    Nombre: desdeMapa
    Responsabilidad:
      Deserializar datos provenientes de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): datos almacenados.
    Salidas:
      - Instancia de FechaLiga.
    Ejemplo de uso:
      final fecha = FechaLiga.desdeMapa("F1", datosFirestore);
  */
  factory FechaLiga.desdeMapa(String id, Map<String, dynamic> datos) {
    return FechaLiga(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      numeroFecha: datos['numeroFecha'] ?? 0,
      nombre: datos['nombre'] ?? '',
      activa: datos['activa'] ?? false,
      cerrada: datos['cerrada'] ?? false,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
    );
  }

  /*
    Nombre: aMapa
    Responsabilidad:
      Serializar la instancia para guardarla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic>
    Ejemplo de uso:
      firestore.set(fecha.id, fecha.aMapa());
  */
  Map<String, dynamic> aMapa() {
    return {
      'idLiga': idLiga,
      'numeroFecha': numeroFecha,
      'nombre': nombre,
      'activa': activa,
      'cerrada': cerrada,
      'fechaCreacion': fechaCreacion,
    };
  }

  /*
    Nombre: copiarCon
    Responsabilidad:
      Crear una nueva instancia modificando únicamente los campos deseados.
    Entradas:
      - Campos opcionales: id, idLiga, numeroFecha, nombre, activa, cerrada, fechaCreacion.
    Salidas:
      - Nueva instancia de FechaLiga.
    Ejemplo de uso:
      final cerrada = fecha.copiarCon(cerrada: true);
  */
  FechaLiga copiarCon({
    String? id,
    String? idLiga,
    int? numeroFecha,
    String? nombre,
    bool? activa,
    bool? cerrada,
    int? fechaCreacion,
  }) {
    return FechaLiga(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      numeroFecha: numeroFecha ?? this.numeroFecha,
      nombre: nombre ?? this.nombre,
      activa: activa ?? this.activa,
      cerrada: cerrada ?? this.cerrada,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
