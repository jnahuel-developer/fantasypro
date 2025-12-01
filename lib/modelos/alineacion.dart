/*
  Archivo: alineacion.dart
  Descripción:
    Modelo de datos que representa una alineación seleccionada por un usuario
    dentro de una liga. Incluye los jugadores seleccionados y la formación táctica.

  Dependencias:
    - Ninguna directa.
  Archivos que dependen de este archivo:
    - Controladores de alineaciones.
*/

class Alineacion {
  /// Identificador único de la alineación en Firestore.
  final String id;

  /// Identificador de la liga donde se aplica la alineación.
  final String idLiga;

  /// Identificador del usuario propietario de la alineación.
  final String idUsuario;

  /// Lista de IDs de jugadores incluidos en esta alineación.
  final List<String> jugadoresSeleccionados;

  /// Formación táctica (ej.: "4-4-2", "4-3-3").
  final String formacion;

  /// Puntos totales obtenidos por la alineación.
  final int puntosTotales;

  /// Fecha de creación en timestamp Unix (milisegundos).
  final int fechaCreacion;

  /// Estado de la alineación (true = activa, false = archivada).
  final bool activo;

  /*
    Constructor principal de Alineacion.
    Entradas:
      - id (String)
      - idLiga (String)
      - idUsuario (String)
      - jugadoresSeleccionados (List<String>)
      - formacion (String)
      - puntosTotales (int)
      - fechaCreacion (int)
      - activo (bool)
    Salida:
      - Instancia de Alineacion.
  */
  const Alineacion({
    required this.id,
    required this.idLiga,
    required this.idUsuario,
    required this.jugadoresSeleccionados,
    required this.formacion,
    required this.puntosTotales,
    required this.fechaCreacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Crea una instancia de Alineacion a partir de datos Firestore.
    Entradas:
      - id (String): identificador del documento.
      - datos (Map<String, dynamic>): datos deserializados.
    Salidas:
      - Instancia de Alineacion.
  */
  factory Alineacion.desdeMapa(String id, Map<String, dynamic> datos) {
    return Alineacion(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      idUsuario: datos['idUsuario'] ?? '',
      jugadoresSeleccionados: List<String>.from(
        datos['jugadoresSeleccionados'] ?? [],
      ),
      formacion: datos['formacion'] ?? '4-4-2',
      puntosTotales: datos['puntosTotales'] ?? 0,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
      activo: datos['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte esta instancia en un mapa para almacenarla en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> representando la alineación.
  */
  Map<String, dynamic> aMapa() {
    return {
      'idLiga': idLiga,
      'idUsuario': idUsuario,
      'jugadoresSeleccionados': jugadoresSeleccionados,
      'formacion': formacion,
      'puntosTotales': puntosTotales,
      'fechaCreacion': fechaCreacion,
      'activo': activo,
    };
  }

  /*
    Nombre: copiarCon
    Descripción:
      Crea una copia de Alineacion modificando únicamente los campos deseados.
    Entradas:
      - Campos opcionales para modificar.
    Salidas:
      - Nueva instancia con los cambios aplicados.
  */
  Alineacion copiarCon({
    String? id,
    String? idLiga,
    String? idUsuario,
    List<String>? jugadoresSeleccionados,
    String? formacion,
    int? puntosTotales,
    int? fechaCreacion,
    bool? activo,
  }) {
    return Alineacion(
      id: id ?? this.id,
      idLiga: idLiga ?? this.idLiga,
      idUsuario: idUsuario ?? this.idUsuario,
      jugadoresSeleccionados:
          jugadoresSeleccionados ?? this.jugadoresSeleccionados,
      formacion: formacion ?? this.formacion,
      puntosTotales: puntosTotales ?? this.puntosTotales,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
