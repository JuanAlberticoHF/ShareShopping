
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

/// Service para gestionar usuarios en FireStore Database
class FireStoreServiceUsuarios {
  /// Referencia a la colección `usuarios` en Firestore
  final CollectionReference dbUsuarios = FirebaseFirestore.instance.collection('usuarios');

  /// Agrega un nuevo usuario a la colección `usuarios` en Firestore.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario (usado como ID del documento).
  /// - [correo]: Correo electrónico del usuario.
  ///
  /// Crea un documento con los campos `correo`, `fecha_creacion` y `fecha_modificacion`.
  Future<void> addUsuario(String uid, String correo) async {
    final usuarioObj = <String, dynamic>{
      'correo': correo,
      'fecha_creacion': Timestamp.fromDate(DateTime.now()),
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbUsuarios.doc(uid).set(usuarioObj); // Utiliza el UID como ID del documento
  }

  /// Stream para obtener actualizaciones en tiempo real de la colección `usuarios`.
  Stream<QuerySnapshot> getUsuarios() {
    return dbUsuarios.snapshots();
  }

  /// Obtiene un usuario por su UID.
  Future<List<DocumentSnapshot>> getUsuariosSnapshot() {
    return dbUsuarios.get().then((snapshot) => snapshot.docs);
  }

  /// Devuelve el `uid` base a un correo.
  ///
  /// Parámetros:
  /// - [correo]: Identificador único del usuario.
  ///
  /// Lanza una excepción si no se encuentra ningún usuario con ese correo.
  Future<String> getUidByCorreo(String correo) {
    return dbUsuarios
        .where('correo', isEqualTo: correo)
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first.id; // Retorna el UID del primer documento encontrado
          } else {
            throw Exception('No se encontró ningún usuario con ese correo');
          }
        });
  }

  /// Devuelve el correo electrónico de un usuario dado su UID.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario.
  ///
  /// Lanza una excepción si no se encuentra ningún usuario con ese UID.
  Future<String> getCorreoByUid(String uid) {
    return dbUsuarios
        .where('uid', isEqualTo: uid)
        .get()
        .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            return snapshot.docs.first['correo']; // Retorna el correo del primer documento encontrado
          } else {
            throw Exception('No se encontró ningún usuario con ese UID');
          }
        });
  }
}