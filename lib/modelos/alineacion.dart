/*
  Archivo: alineacion.dart
  Descripción:
    Modelo de datos que representa una alineación seleccionada por un usuario
    dentro de una liga. Incluye jugadores, puntos y formación táctica.
*/

class Alineacion {
  final String id;
  final String idLiga;
  final String idUsuario;

  /// Lista de IDs de jugadores incluidos en esta alineación.
  final List<String> jugadoresSeleccionados;

  /// Formación táctica (ej.: "4-4-2", "4-3-3").
  final String formacion;

  /// Puntos totales obtenidos por la alineación.
  final int puntosTotales;

  /// Timestamp de creación en milisegundos.
  final int fechaCreacion;

  /// Estado de la alineación.
  final bool activo;

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
