/*
  Archivo: ui__admin__fecha__lista__desktop.dart
  Descripción:
    Lista de fechas asociadas a una liga. Permite crear nuevas fechas,
    visualizar fecha activa, listar fechas cerradas, cerrar fecha activa,
    cargar puntajes reales y — en modo de prueba del MVP — simular la
    carga de puntajes reales automáticamente.

  Dependencias:
    - modelos/fecha_liga.dart
    - modelos/liga.dart
    - controladores/controlador_fechas.dart
    - controladores/controlador_equipos_reales.dart
    - controladores/controlador_jugadores_reales.dart
    - servicios/servicio_puntajes_reales.dart
    - servicios/utilidades/servicio_log.dart
    - dart:math (para generación de puntajes aleatorios)

  Pantallas que navegan hacia esta:
    - ninguna

  Pantallas destino:
    - ui__admin__puntajes_reales__lista__desktop.dart (para carga manual)
*/

import 'dart:math';

import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/modelos/puntaje_jugador_fecha.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_fechas.dart';
import 'package:fantasypro/servicios/firebase/servicio_puntajes_reales.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'ui__admin__puntajes_reales__lista__desktop.dart';

class UiAdminFechaListaDesktop extends StatefulWidget {
  final Liga liga;

  const UiAdminFechaListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminFechaListaDesktop> createState() =>
      _UiAdminFechaListaDesktopEstado();
}

class _UiAdminFechaListaDesktopEstado extends State<UiAdminFechaListaDesktop> {
  final ControladorFechas _controlador = ControladorFechas();

  bool cargando = true;

  FechaLiga? fechaActiva;
  List<FechaLiga> fechasCerradas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Recupera todas las fechas de la liga, separa la fecha activa (si existe)
      y las fechas ya cerradas.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final lista = await _controlador.obtenerPorLiga(widget.liga.id);

    final candidatas = lista.where((f) => f.activa && !f.cerrada).toList();
    fechaActiva = candidatas.isEmpty ? null : candidatas.first;

    fechasCerradas = lista.where((f) => f.cerrada).toList()
      ..sort((a, b) => a.numeroFecha.compareTo(b.numeroFecha));

    setState(() => cargando = false);
  }

  /*
    Nombre: _cerrarFecha
    Descripción:
      Intenta cerrar la fecha activa. Muestra mensajes según resultado.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cerrarFecha() async {
    if (fechaActiva == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_TITULO,
        ),
        content: Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_CONTENIDO
              .replaceFirst("{NUMERO}", fechaActiva!.numeroFecha.toString()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(TextosApp.ADMIN_FECHA_LISTA_DESKTOP_BOTON_CERRAR),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _controlador.cerrarFecha(fechaActiva!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              TextosApp.ADMIN_FECHA_LISTA_DESKTOP_SNACKBAR_FECHA_CERRADA_OK,
            ),
          ),
        );
      }

      _cargar();
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              TextosApp.ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_ERROR_TITULO,
            ),
            content: const Text(
              TextosApp
                  .ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_ERROR_CONTENIDO,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(TextosApp.COMUN_BOTON_ACEPTAR),
              ),
            ],
          ),
        );
      }
    }
  }

  /*
    Nombre: _confirmarCrearFecha
    Descripción:
      Diálogo de confirmación previo a crear una nueva fecha.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _confirmarCrearFecha() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CREAR_TITULO,
        ),
        content: const Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CREAR_CONTENIDO,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(TextosApp.COMUN_BOTON_CREAR),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await _controlador.crearFecha(widget.liga.id);
    _cargar();
  }

  /*
  Nombre: _simularPuntajesReales
  Descripción:
    Función utilizada únicamente para pruebas en el MVP. Simula la carga de
    puntajes reales asignando valores aleatorios entre 1 y 10 a todos los
    jugadores reales activos de la liga en la fecha activa. Durante el proceso,
    se muestra un modal bloqueante de carga y se registran logs informativos.
  Entradas: ninguna
  Salidas: Future<void>
*/
  Future<void> _simularPuntajesReales() async {
    if (fechaActiva == null) return;

    // Loader modal bloqueante
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final log = ServicioLog();
    final idLiga = widget.liga.id;
    final idFecha = fechaActiva!.id;
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    log.informacion(
      "Iniciando simulación de puntajes reales: idLiga=$idLiga idFecha=$idFecha",
    );

    try {
      // 1. Obtener equipos reales
      final ctrlEquipos = ControladorEquiposReales();
      final equipos = await ctrlEquipos.obtenerPorLiga(idLiga);
      log.informacion(
        "Equipos reales obtenidos: ${equipos.map((e) => e.id).toList()}",
      );

      // 2. Acumular puntajes por jugador
      final List<PuntajeJugadorFecha> puntajes = [];
      final ctrlJugadores = ControladorJugadoresReales();
      final random = Random();

      for (final eq in equipos) {
        final jugadores = await ctrlJugadores.obtenerPorEquipoReal(eq.id);
        final activos = jugadores.where((j) => j.activo).toList();

        log.informacion(
          "Jugadores activos del equipo ${eq.id}: ${activos.map((j) => j.id).toList()}",
        );

        for (final j in activos) {
          final puntuacion = random.nextInt(10) + 1;

          log.informacion(
            "Generado puntaje aleatorio para jugadorReal ${j.id}: $puntuacion",
          );

          final puntaje = PuntajeJugadorFecha(
            id: "${idFecha}_${j.id}",
            idFecha: idFecha,
            idLiga: idLiga,
            idEquipoReal: j.idEquipoReal,
            idJugadorReal: j.id,
            puntuacion: puntuacion,
            fechaCreacion: timestamp,
          );

          puntajes.add(puntaje);
        }
      }

      // 3. Guardar todos los puntajes con WriteBatch
      log.informacion(
        "Enviando ${puntajes.length} puntajes al servicio guardarPuntajesDeFecha",
      );

      await ServicioPuntajesReales().guardarPuntajesDeFecha(
        idLiga,
        idFecha,
        puntajes,
      );

      // 4. Éxito → cerrar loader
      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              TextosApp.ADMIN_FECHA_LISTA_DESKTOP_SNACKBAR_SIMULACION_OK,
            ),
          ),
        );
      }
    } catch (e) {
      log.error("Error en la simulación de puntajes reales: $e");

      if (mounted) {
        Navigator.pop(context); // Cierra loader

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              TextosApp
                  .ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_SIMULACION_ERROR_TITULO,
            ),
            content: Text(
              TextosApp
                  .ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_SIMULACION_ERROR_CONTENIDO
                  .replaceFirst("{DETALLE}", "$e"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(TextosApp.COMUN_BOTON_ACEPTAR),
              ),
            ],
          ),
        );
      }
    }
  }

  /*
    Nombre: _itemFechaCerrada
    Descripción:
      Renderiza un ítem de la lista de fechas cerradas.
    Entradas:
      - f (FechaLiga): fecha cerrada
    Salidas:
      - Widget
  */
  Widget _itemFechaCerrada(FechaLiga f) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_ITEM_FECHA_CERRADA_TITULO
              .replaceFirst("{NUMERO}", f.numeroFecha.toString())
              .replaceFirst("{NOMBRE}", f.nombre),
        ),
        subtitle: const Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_ITEM_FECHA_CERRADA_ESTADO,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.liga.totalFechasTemporada;
    final creadas = widget.liga.fechasCreadas;
    final puedeCrear = fechaActiva == null && creadas < total;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.ADMIN_FECHA_LISTA_DESKTOP_TITULO_APPBAR.replaceFirst(
            "{LIGA}",
            widget.liga.nombre,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: puedeCrear
          ? FloatingActionButton(
              onPressed: _confirmarCrearFecha,
              child: const Icon(Icons.add),
            )
          : null,

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),

                // Fecha activa
                if (fechaActiva != null)
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        TextosApp.ADMIN_FECHA_LISTA_DESKTOP_TITULO_FECHA_ACTIVA
                            .replaceFirst("{NOMBRE}", fechaActiva!.nombre),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        TextosApp
                            .ADMIN_FECHA_LISTA_DESKTOP_SUBTITULO_FECHA_ACTIVA
                            .replaceFirst(
                              "{NUMERO}",
                              fechaActiva!.numeroFecha.toString(),
                            ),
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UiAdminPuntajesRealesListaDesktop(
                                        liga: widget.liga,
                                        fecha: fechaActiva!,
                                      ),
                                ),
                              );
                            },
                            child: const Text(
                              TextosApp
                                  .ADMIN_FECHA_LISTA_DESKTOP_BOTON_CARGAR_PUNTAJES,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _cerrarFecha,
                            child: const Text(
                              TextosApp
                                  .ADMIN_FECHA_LISTA_DESKTOP_BOTON_CERRAR_FECHA,
                            ),
                          ),
                          // Botón solo para pruebas (MVP)
                          ElevatedButton(
                            onPressed: _simularPuntajesReales,
                            child: const Text(
                              TextosApp
                                  .ADMIN_FECHA_LISTA_DESKTOP_BOTON_SIMULAR_PUNTAJES,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      TextosApp
                          .ADMIN_FECHA_LISTA_DESKTOP_MENSAJE_SIN_FECHA_ACTIVA,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    TextosApp.ADMIN_FECHA_LISTA_DESKTOP_TITULO_FECHAS_CERRADAS,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),

                Expanded(
                  child: ListView(
                    children: fechasCerradas.map(_itemFechaCerrada).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
