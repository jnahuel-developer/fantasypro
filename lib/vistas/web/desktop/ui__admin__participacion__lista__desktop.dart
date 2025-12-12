/*
  Archivo: ui__admin__participacion__lista__desktop.dart
  Descripción:
    Administración de participaciones de usuarios dentro de una liga específica.
    Permite visualizar participaciones activas y archivadas, crear nuevas con ID
    de usuario y nombre de equipo fantasy, editar datos, activar/archivar y
    eliminar. Permite además navegar a la gestión de alineaciones del usuario.

  Dependencias:
    - modelos/liga.dart: identifica la liga a la que pertenecen las participaciones
    - modelos/participacion_liga.dart: representa cada participación mostrada
    - controladores/controlador_participaciones.dart: operaciones CRUD para
      participaciones
    - ui__admin__participacion__editar__desktop.dart: edición de una participación
    - ui__admin__alineacion__lista__desktop.dart: gestión de alineaciones del
      usuario en la liga

  Pantallas destino:
    - ui__admin__participacion__editar__desktop.dart: se abre al presionar el
      botón "Editar" en una participación, permitiendo modificar el registro
    - ui__admin__alineacion__lista__desktop.dart: se abre desde el ícono de balón
      para administrar las alineaciones del usuario en la liga actual
*/

import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:flutter/material.dart';

import 'ui__admin__participacion__editar__desktop.dart';
import 'ui__admin__alineacion__lista__desktop.dart';

class UiAdminParticipacionListaDesktop extends StatefulWidget {
  /// Liga a la que pertenecen las participaciones mostradas.
  final Liga liga;

  const UiAdminParticipacionListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminParticipacionListaDesktop> createState() =>
      _UiAdminParticipacionListaDesktopEstado();
}

class _UiAdminParticipacionListaDesktopEstado
    extends State<UiAdminParticipacionListaDesktop> {
  /// Controlador de participaciones para operaciones de CRUD.
  final ControladorParticipaciones _controlador = ControladorParticipaciones();

  /// Indica si los datos están cargando.
  bool cargando = true;

  /// Participaciones activas.
  List<ParticipacionLiga> activos = [];

  /// Participaciones archivadas.
  List<ParticipacionLiga> archivados = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  /*
    Nombre: cargar
    Descripción:
      Recupera las participaciones asociadas a la liga y las separa en listas
      activas y archivadas ordenadas por nombre.
    Entradas: ninguna
    Salidas:
      - Future<void>: sin valor devuelto
  */
  Future<void> cargar() async {
    setState(() => cargando = true);

    final todos = await _controlador.obtenerPorLiga(widget.liga.id);

    activos = todos.where((p) => p.activo).toList()
      ..sort(
        (a, b) => a.nombreEquipoFantasy.toLowerCase().compareTo(
          b.nombreEquipoFantasy.toLowerCase(),
        ),
      );

    archivados = todos.where((p) => !p.activo).toList()
      ..sort(
        (a, b) => a.nombreEquipoFantasy.toLowerCase().compareTo(
          b.nombreEquipoFantasy.toLowerCase(),
        ),
      );

    setState(() => cargando = false);
  }

  /*
    Nombre: crearParticipacion
    Descripción:
      Crea manualmente una nueva participación solicitando ID de usuario y
      nombre del equipo fantasy. Utiliza el controlador para persistencia.
    Entradas: ninguna
    Salidas:
      - Future<void>: sin valor devuelto
  */
  Future<void> crearParticipacion() async {
    final ctrlIdUsuario = TextEditingController();
    final ctrlNombreEquipo = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_DIALOGO_CREAR_TITULO
                .replaceFirst("{LIGA}", widget.liga.nombre),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlIdUsuario,
                decoration: const InputDecoration(
                  labelText: TextosApp
                      .ADMIN_PARTICIPACION_LISTA_DESKTOP_LABEL_ID_USUARIO,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ctrlNombreEquipo,
                decoration: const InputDecoration(
                  labelText: TextosApp
                      .ADMIN_PARTICIPACION_LISTA_DESKTOP_LABEL_NOMBRE_EQUIPO_FANTASY,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text(TextosApp.COMUN_BOTON_CREAR),
              onPressed: () async {
                final idUsuario = ctrlIdUsuario.text.trim();
                final nombre = ctrlNombreEquipo.text.trim();

                if (idUsuario.isEmpty || nombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        TextosApp
                            .ADMIN_PARTICIPACION_LISTA_DESKTOP_ERROR_CAMPOS_OBLIGATORIOS,
                      ),
                    ),
                  );
                  return;
                }

                final participacion = ParticipacionLiga(
                  id: "",
                  idLiga: widget.liga.id,
                  idUsuario: idUsuario,
                  nombreEquipoFantasy: nombre,
                  puntos: 0,
                  plantelCompleto: false,
                  fechaCreacion: DateTime.now().millisecondsSinceEpoch,
                  activo: true,
                );

                await _controlador.editar(participacion);

                if (!mounted) return;
                Navigator.pop(context);
                cargar();
              },
            ),
          ],
        );
      },
    );
  }

  /*
    Nombre: confirmar
    Descripción:
      Muestra un diálogo de confirmación para operaciones de riesgo como
      eliminar o archivar participaciones.
    Entradas:
      - mensaje (String): texto a mostrar en el diálogo
    Salidas:
      - Future<bool>: true si el usuario confirma, false si cancela
  */
  Future<bool> confirmar(String mensaje) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TextosApp.COMUN_TITULO_CONFIRMACION),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text(TextosApp.COMUN_BOTON_ACEPTAR),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    return r ?? false;
  }

  /*
    Nombre: itemParticipacion
    Descripción:
      Construye la tarjeta visual de cada participación, mostrando nombre del
      equipo, ID de usuario y acciones disponibles.
    Entradas:
      - p (ParticipacionLiga): participación a mostrar
    Salidas:
      - Widget: tarjeta renderizada
  */
  Widget itemParticipacion(ParticipacionLiga p) {
    final inicial = p.nombreEquipoFantasy.isNotEmpty
        ? p.nombreEquipoFantasy[0].toUpperCase()
        : "?";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(inicial)),
        title: Text(
          p.nombreEquipoFantasy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_SUBTITULO_USUARIO
              .replaceFirst("{ID_USUARIO}", p.idUsuario),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Alineaciones
            IconButton(
              icon: const Icon(Icons.sports_soccer),
              tooltip: TextosApp
                  .ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_GESTION_ALINEACIONES,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminAlineacionListaDesktop(
                      idLiga: widget.liga.id,
                      idUsuario: p.idUsuario,
                    ),
                  ),
                ).then((_) => cargar());
              },
            ),

            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip:
                  TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_EDITAR,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UiAdminParticipacionEditarDesktop(participacion: p),
                  ),
                );
                if (result == true) cargar();
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(p.activo ? Icons.archive : Icons.unarchive),
              tooltip: p.activo
                  ? TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ARCHIVAR
                  : TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ACTIVAR,
              onPressed: () async {
                final ok = await confirmar(
                  p.activo
                      ? TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ARCHIVAR
                      : TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ACTIVAR,
                );
                if (!ok) return;

                if (p.activo) {
                  await _controlador.archivar(p.id);
                } else {
                  await _controlador.activar(p.id);
                }

                cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip:
                  TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ELIMINAR,
              onPressed: () async {
                final ok = await confirmar(
                  TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ELIMINAR,
                );
                if (!ok) return;

                await _controlador.eliminar(p.id);
                cargar();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_APPBAR
              .replaceFirst("{LIGA}", widget.liga.nombre),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_VOLVER,
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TEXTO_GESTION,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearParticipacion,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Activos
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_ACTIVOS
                            .replaceFirst(
                          "{CANT}",
                          activos.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activos.map(itemParticipacion).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Archivados
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_ARCHIVADOS
                            .replaceFirst(
                          "{CANT}",
                          archivados.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivados.map(itemParticipacion).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
