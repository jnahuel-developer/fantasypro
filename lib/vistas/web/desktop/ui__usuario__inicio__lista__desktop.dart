/*
  Archivo: ui__usuario__inicio__lista__desktop.dart
  Descripción:
    Pantalla principal del usuario final donde se listan las ligas activas.
    Permite buscar ligas y navegar al detalle para unirse.

  Dependencias:
    - modelos/liga.dart
    - controladores/controlador_ligas.dart

  Pantallas que navegan hacia esta:
    - ui__comun__autenticacion__login__desktop.dart

  Pantallas destino:
    - ui__usuario__liga__detalle__desktop.dart: navegación al seleccionar una liga para unirse.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'widgets/ui__usuario__appbar__desktop.dart';
import 'ui__usuario__liga__detalle__desktop.dart';

class UiUsuarioInicioListaDesktop extends StatefulWidget {
  const UiUsuarioInicioListaDesktop({super.key});

  @override
  State<UiUsuarioInicioListaDesktop> createState() =>
      _UiUsuarioInicioListaDesktopEstado();
}

class _UiUsuarioInicioListaDesktopEstado
    extends State<UiUsuarioInicioListaDesktop> {
  /// Controlador de ligas.
  final ControladorLigas _controladorLigas = ControladorLigas();

  /// Lista actual de ligas mostradas.
  List<Liga> _ligas = [];

  /// Estado de carga de datos.
  bool _cargando = true;

  /// Campo de búsqueda.
  final TextEditingController _ctrlBuscar = TextEditingController();

  /// Mensaje de error en caso de excepción real.
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Carga todas las ligas activas y las ordena por nombre.
      Si ocurre un error real en el controlador, muestra mensaje de error.
      Si la lista está vacía pero sin excepción, no se considera error.

    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final resultado = await _controladorLigas.obtenerActivas();
      _ligas = resultado.toList()
        ..sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );
    } catch (e) {
      _mensajeError = TextosApp.USUARIO_INICIO_DESKTOP_ERROR_CARGA_LIGAS;
    }

    setState(() => _cargando = false);
  }

  /*
    Nombre: _buscar
    Descripción:
      Realiza búsqueda de ligas por nombre ingresado.
      Si el texto está vacío, recarga todas las activas.

    Entradas:
      - texto (String): texto a buscar

    Salidas: Future<void>
  */
  Future<void> _buscar(String texto) async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      if (texto.trim().isEmpty) {
        _ligas = (await _controladorLigas.obtenerActivas()).toList();
      } else {
        _ligas = (await _controladorLigas.buscar(texto.trim())).toList();
      }

      _ligas.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );
    } catch (e) {
      _mensajeError = TextosApp.USUARIO_INICIO_DESKTOP_ERROR_BUSQUEDA;
    }

    setState(() => _cargando = false);
  }

  /*
    Nombre: _itemLiga
    Descripción:
      Construye el widget visual para una liga individual,
      con botón que navega a detalle y recarga al volver.

    Entradas:
      - liga (Liga): liga a renderizar

    Salidas:
      - Widget: tarjeta de la liga
  */
  Widget _itemLiga(Liga liga) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(liga.nombre, style: const TextStyle(fontSize: 18)),
        subtitle: Text(
          TextosApp.USUARIO_INICIO_DESKTOP_SUBTITULO_TEMPORADA
              .replaceFirst("{TEMPORADA}", liga.temporada),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UiUsuarioLigaDetalleDesktop(liga: liga),
              ),
            ).then((_) => _cargar());
          },
          child: const Text(TextosApp.USUARIO_INICIO_DESKTOP_BOTON_UNIRSE),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UiUsuarioAppBarDesktop(
        titulo: TextosApp.USUARIO_INICIO_DESKTOP_TITULO_APPBAR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _ctrlBuscar,
              decoration: InputDecoration(
                labelText: TextosApp.USUARIO_INICIO_DESKTOP_LABEL_BUSCAR,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _buscar(_ctrlBuscar.text),
                ),
              ),
              onSubmitted: _buscar,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : _mensajeError != null
                      ? Center(
                          child: Text(
                            _mensajeError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : _ligas.isEmpty
                          ? const Center(
                              child: Text(
                                TextosApp.USUARIO_INICIO_DESKTOP_SIN_LIGAS,
                              ),
                            )
                          : ListView(
                              children: _ligas.map(_itemLiga).toList(),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
