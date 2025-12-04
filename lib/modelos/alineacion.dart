/*
  Archivo: alineacion.dart
  Descripción:
    Modelo que representa una Alineación de un EquipoFantasy.
    Incluye titulares, suplentes y la referencia al equipo fantasy.
  Responsabilidades:
    - Persistir la alineación titular/suplentes.
    - Mantener compatibilidad con jugadoresSeleccionados.
  Dependencias directas:
    - equipo_fantasy.dart
  Archivos que dependen de este:
    - Servicios y controladores de alineaciones.
*/

class Alineacion {
  final String id;
  final String idLiga;
  final String idUsuario;

  /// Identificador del equipo fantasy al que pertenece esta alineación.
  final String idEquipoFantasy;

  /// IDs de los 11 titulares.
  final List<String> idsTitulares;

  /// IDs de los 4 suplentes.
  final List<String> idsSuplentes;

  /// Unión de titulares y suplentes (compatibilidad).
  final List<String> jugadoresSeleccionados;

  final String formacion;
  final int puntosTotales;
  final int fechaCreacion;
  final bool activo;

  const Alineacion({
    required this.id,
    required this.idLiga,
    required this.idUsuario,
    required this.idEquipoFantasy,
    required this.idsTitulares,
    required this.idsSuplentes,
    required this.jugadoresSeleccionados,
    required this.formacion,
    required this.puntosTotales,
    required this.fechaCreacion,
    required this.activo,
  });

  factory Alineacion.desdeMapa(String id, Map<String, dynamic> datos) {
    final titulares = List<String>.from(datos['idsTitulares'] ?? []);
    final suplentes = List<String>.from(datos['idsSuplentes'] ?? []);

    return Alineacion(
      id: id,
      idLiga: datos['idLiga'] ?? '',
      idUsuario: datos['idUsuario'] ?? '',
      idEquipoFantasy: datos['idEquipoFantasy'] ?? '',
      idsTitulares: titulares,
      idsSuplentes: suplentes,
      jugadoresSeleccionados: List<String>.from(
        datos['jugadoresSeleccionados'] ?? titulares + suplentes,
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
      'idEquipoFantasy': idEquipoFantasy,
      'idsTitulares': idsTitulares,
      'idsSuplentes': idsSuplentes,
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
    String? idEquipoFantasy,
    List<String>? idsTitulares,
    List<String>? idsSuplentes,
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
      idEquipoFantasy: idEquipoFantasy ?? this.idEquipoFantasy,
      idsTitulares: idsTitulares ?? this.idsTitulares,
      idsSuplentes: idsSuplentes ?? this.idsSuplentes,
      jugadoresSeleccionados:
          jugadoresSeleccionados ?? this.jugadoresSeleccionados,
      formacion: formacion ?? this.formacion,
      puntosTotales: puntosTotales ?? this.puntosTotales,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      activo: activo ?? this.activo,
    );
  }
}
