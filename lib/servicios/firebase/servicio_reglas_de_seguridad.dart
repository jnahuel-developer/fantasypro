/*
  Archivo: servicio_reglas_de_seguridad.dart
  Descripción:
    Contiene texto de ejemplo con reglas de seguridad para Firestore aplicables
    al esquema básico del proyecto. No aplica cambios automáticos, sólo devuelve
    el contenido que se puede pegar en la consola de Firebase.
*/

class ServicioReglasDeSeguridad {
  /// Retorna reglas de ejemplo para Firestore.
  String reglasEjemplo() {
    return r'''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /usuarios/{userId} {
      allow read: if request.auth != null;                // cualquier autenticado puede leer usuarios
      allow write: if request.auth != null && request.auth.uid == userId; // sólo el propio usuario puede actualizar su doc
    }

    match /ligas/{ligaId} {
      allow read: if true; // lectura pública
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && get(/databases/$(database)/documents/usuarios/$(request.auth.uid)).data.rol == 'admin';
    }

    // reglas por defecto
    match /{document=**} {
      allow read: if false;
      allow write: if false;
    }
  }
}
''';
  }
}
