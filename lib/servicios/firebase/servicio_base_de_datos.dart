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

  Archivos que dependen de este archivo:
    - Controladores relacionados al registro de usuario
    - Flujos de creación de ligas
    - Funcionalidades comunes de acceso a Firestore
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ColFirebase {
  static const usuarios = "usuarios";
  static const ligas = "ligas";
  static const equiposReales = "equipos_reales";
  static const jugadoresReales = "jugadores_reales";
  static const fechasLiga = "fechas_liga";
  static const puntajesReales = "puntajes_reales";
  static const equiposFantasy = "equipos_fantasy";
  static const participaciones = "participaciones_liga";
  static const puntajesFantasy = "puntajes_fantasy";
  static const alineaciones = "alineaciones";
}

class CamposFirebase {
  static const uid = "uid";
  static const nombre = "nombre";
  static const email = "email";
  static const rol = "rol";
  static const creado = "creado";
  static const idLiga = "idLiga";
  static const idUsuario = "idUsuario";
  static const idFecha = "idFecha";
  static const idJugadorReal = "idJugadorReal";
  static const idEquipoReal = "idEquipoReal";
  static const id = "id";
  static const nombreBusqueda = "nombreBusqueda";
  static const activa = "activa";
  static const activo = "activo";
  static const puntos = "puntos";
  static const plantelCompleto = "plantelCompleto";
  static const nombreEquipoFantasy = "nombreEquipoFantasy";
  static const idsTitulares = "idsTitulares";
  static const idsSuplentes = "idsSuplentes";
  static const jugadoresSeleccionados = "jugadoresSeleccionados";
  static const formacion = "formacion";
  static const timestampAplicacion = "timestampAplicacion";
  static const idsJugadoresPlantel = "idsJugadoresPlantel";
  static const presupuestoRestante = "presupuestoRestante";
  static const cerrada = "cerrada";
  static const fechaCreacion = "fechaCreacion";
  static const puntuacion = "puntuacion";
}

class ServicioBaseDeDatos {
  /// Instancia de Firestore utilizada para acceder a la base de datos.
  final FirebaseFirestore _bd = FirebaseFirestore.instance;

  /// Servicio de logs para registrar eventos del sistema.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: guardarUsuario
    Descripción:
      Guarda o actualiza la información de un usuario en la colección "usuarios".
      Si el documento ya existe, fusiona los datos nuevos con los existentes.
    Entradas:
      - uid (String): identificador único del usuario.
      - datos (Map<String, dynamic>): datos a guardar o actualizar.
    Salidas:
      - Future<void>
  */
  Future<void> guardarUsuario(String uid, Map<String, dynamic> datos) async {
    try {
      await _bd
          .collection(ColFirebase.usuarios)
          .doc(uid)
          .set(datos, SetOptions(merge: true));

      _log.informacion("${TextosApp.LOG_BD_GUARDAR_USUARIO} $uid");
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerUsuario
    Descripción:
      Recupera el documento de un usuario específico desde Firestore.
    Entradas:
      - uid (String): identificador del usuario.
    Salidas:
      - Future<DocumentSnapshot<Map<String, dynamic>>>: snapshot del documento.
  */
  Future<DocumentSnapshot<Map<String, dynamic>>> obtenerUsuario(
    String uid,
  ) async {
    try {
      final doc = await _bd.collection(ColFirebase.usuarios).doc(uid).get();

      _log.informacion("${TextosApp.LOG_BD_OBTENER_USUARIO} $uid");
      return doc;
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: crearLiga
    Descripción:
      Crea una nueva liga con los datos mínimos requeridos, incluyendo la fecha
      de creación generada automáticamente desde el servidor.
    Entradas:
      - datos (Map<String, dynamic>): información básica de la liga.
    Salidas:
      - Future<String>: ID asignado a la liga creada.
  */
  Future<String> crearLiga(Map<String, dynamic> datos) async {
    try {
      final docRef = await _bd.collection(ColFirebase.ligas).add({
        ...datos,
        CamposFirebase.creado: FieldValue.serverTimestamp(),
      });

      _log.informacion("${TextosApp.LOG_BD_CREAR_LIGA} ${docRef.id}");
      return docRef.id;
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: listarLigasStream
    Descripción:
      Devuelve un stream en tiempo real de las ligas existentes, ordenadas por
      fecha de creación descendente.
    Entradas:
      - Ninguna.
    Salidas:
      - Stream<QuerySnapshot<Map<String, dynamic>>>: flujo de resultados.
  */
  Stream<QuerySnapshot<Map<String, dynamic>>> listarLigasStream() {
    try {
      _log.informacion(TextosApp.LOG_BD_LISTAR_LIGAS);

      return _bd
          .collection(ColFirebase.ligas)
          .orderBy(CamposFirebase.creado, descending: true)
          .snapshots();
    } catch (e) {
      _log.error("${TextosApp.LOG_BD_ERROR} $e");
      rethrow;
    }
  }
}
