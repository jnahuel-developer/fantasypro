/*
  Archivo: servicio_base_de_datos.dart
  Descripción:
    Servicio genérico para operaciones CRUD básicas sobre las colecciones
    principales del proyecto. Establece un estándar interno para el manejo
    de colecciones y campos en Firestore.

  Dependencias:
    - cloud_firestore
    - servicio_log.dart
    - textos_app.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioBaseDeDatos {
  final FirebaseFirestore _bd = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas: nombres de colecciones y campos
  // ---------------------------------------------------------------------------

  static const String _colUsuarios = "usuarios";
  static const String _colLigas = "ligas";

  static const String _campoCreadoEn = "creadoEn";

  // ---------------------------------------------------------------------------
  // Guardar o actualizar usuario
  // ---------------------------------------------------------------------------
  Future<void> guardarUsuario(String uid, Map<String, dynamic> datos) async {
    try {
      await _bd
          .collection(_colUsuarios)
          .doc(uid)
          .set(datos, SetOptions(merge: true));

      _log.informacion("${TextosApp.LOG_BD_GUARDAR_USUARIO} $uid");
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener documento de usuario
  // ---------------------------------------------------------------------------
  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerUsuario(
    String uid,
  ) async {
    try {
      final doc = await _bd.collection(_colUsuarios).doc(uid).get();

      _log.informacion("${TextosApp.LOG_BD_OBTENER_USUARIO} $uid");
      return doc;
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Crear liga mínima
  // ---------------------------------------------------------------------------
  Future<String> crearLiga(Map<String, dynamic> datos) async {
    try {
      final docRef = await _bd.collection(_colLigas).add({
        ...datos,
        _campoCreadoEn: FieldValue.serverTimestamp(),
      });

      _log.informacion("${TextosApp.LOG_BD_CREAR_LIGA} ${docRef.id}");
      return docRef.id;
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Leer lista de ligas (stream)
  // ---------------------------------------------------------------------------
  Stream<QuerySnapshot<Map<String, dynamic>>> listarLigasStream() {
    try {
      _log.informacion(TextosApp.LOG_BD_LISTAR_LIGAS);

      return _bd
          .collection(_colLigas)
          .orderBy(_campoCreadoEn, descending: true)
          .snapshots();
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }
}
