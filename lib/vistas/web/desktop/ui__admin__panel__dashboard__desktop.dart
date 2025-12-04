/*
  Archivo: ui__admin__panel__dashboard__desktop.dart
  Versión actualizada:
    - Agrega botón “Carga Masiva – España”
    - Muestra loader durante la carga
    - Mantiene navegación existente
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fantasypro/textos/textos_app.dart';
import 'ui__admin__liga__lista__desktop.dart';

class UiAdminPanelDashboardDesktop extends StatelessWidget {
  const UiAdminPanelDashboardDesktop({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // ================================================================
  // MÉTODO GENERAL DE CARGA MASIVA
  // ================================================================
  Future<void> _cargarLigaDesdeJson(
    BuildContext context,
    String rutaJson,
    String nombreLigaVisible,
  ) async {
    // ---------------------------------------------------------
    // Mostrar loader modal
    // ---------------------------------------------------------
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Cargando datos..."),
            ],
          ),
        ),
      ),
    );

    try {
      // Leer JSON
      final jsonStr = await DefaultAssetBundle.of(context).loadString(rutaJson);
      final data = json.decode(jsonStr);

      final FirebaseFirestore db = FirebaseFirestore.instance;

      // ---------------------------------------------------------
      // 1) Cargar la liga
      // ---------------------------------------------------------
      final l = data["liga"];

      final ligaRef = await db.collection("ligas").add({
        "nombre": l["nombre"],
        "temporada": l["temporada"],
        "descripcion": l["descripcion"],
        "fechaCreacion": DateTime.now().millisecondsSinceEpoch,
        "activa": true,
        "totalFechasTemporada": l["totalFechasTemporada"],
        "fechasCreadas": 0,
      });

      final idLiga = ligaRef.id;

      // ---------------------------------------------------------
      // 2) Cargar equipos
      // ---------------------------------------------------------
      for (final equipo in data["equipos"]) {
        final equipoRef = await db.collection("equipos_reales").add({
          "idLiga": idLiga,
          "nombre": equipo["nombre"],
          "descripcion": equipo["descripcion"],
          "escudoUrl": equipo["escudoUrl"],
          "fechaCreacion": DateTime.now().millisecondsSinceEpoch,
          "activo": true,
        });

        final idEquipo = equipoRef.id;

        // ---------------------------------------------------------
        // 3) Cargar jugadores del equipo
        // ---------------------------------------------------------
        for (final j in equipo["jugadores"]) {
          await db.collection("jugadores_reales").add({
            "idEquipoReal": idEquipo,
            "nombre": j["nombre"],
            "posicion": j["posicion"],
            "nacionalidad": j["nacionalidad"],
            "dorsal": j["dorsal"],
            "valorMercado": j["valorMercado"],
            "activo": true,
            "fechaCreacion": DateTime.now().millisecondsSinceEpoch,
          });
        }
      }

      // Cerrar loader
      if (context.mounted) Navigator.pop(context);

      // Mostrar mensaje OK
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Carga completada – $nombreLigaVisible"),
            content: const Text("Los datos fueron cargados correctamente."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context); // cerrar loader

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text("No se pudo completar la carga: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cerrar"),
              ),
            ],
          ),
        );
      }
    }
  }

  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextosApp.ADMIN_PANEL_DESKTOP_TITULO),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //----------------------------------------------
              // ADMINISTRAR LIGAS
              //----------------------------------------------
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UiAdminLigaListaDesktop(),
                    ),
                  );
                },
                child: const Text(TextosApp.ADMIN_PANEL_DESKTOP_BOTON_LIGAS),
              ),

              const SizedBox(height: 30),

              //----------------------------------------------
              // CARGA MASIVA – LIGA ESPAÑA
              //----------------------------------------------
              ElevatedButton(
                onPressed: () {
                  _cargarLigaDesdeJson(
                    context,
                    "assets/data/carga_inicial/carga_espana.json",
                    "Liga Española",
                  );
                },
                child: const Text("Carga Masiva – España"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
