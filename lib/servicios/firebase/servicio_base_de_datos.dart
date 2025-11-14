/*
  Archivo: servicio_base_de_datos.dart
  Descripción:
    Operaciones básicas de lectura/escritura en Firestore para las colecciones básicas.
  Dependencias:
    - cloud_firestore
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class ServicioBaseDeDatos {
  final FirebaseFirestore _bd = FirebaseFirestore.instance;

  // Guardar o actualizar usuario (documento)
  Future<void> guardarUsuario(String uid, Map<String, dynamic> datos) {
    return _bd
        .collection('usuarios')
        .doc(uid)
        .set(datos, SetOptions(merge: true));
  }

  // Obtener documento de usuario
  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerUsuario(String uid) {
    return _bd.collection('usuarios').doc(uid).get();
  }

  // Crear liga mínima
  Future<String> crearLiga(Map<String, dynamic> datos) async {
    final docRef = await _bd.collection('ligas').add({
      ...datos,
      'creadoEn': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Leer lista de ligas (snapshots)
  Stream<QuerySnapshot<Map<String, dynamic>>> listarLigasStream() {
    return _bd
        .collection('ligas')
        .orderBy('creadoEn', descending: true)
        .snapshots();
  }
}
