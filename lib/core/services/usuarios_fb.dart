
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class FireStoreServiceUsers {
  final CollectionReference dbUsuarios = FirebaseFirestore.instance.collection('usuarios');

  // CREATE: añadir un nuevo nuevo usuario
  Future<void> addUsuario(String uid, String correo) async {
    final usuarioObj = <String, dynamic>{
      'correo': correo,
      'fecha_creacion': Timestamp.fromDate(DateTime.now()),
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    // Usar set con el doc(uid) para que el uid sea el identificador del documento
    await dbUsuarios.doc(uid).set(usuarioObj);
  }

  // READ: Obtener usuarios
  Stream<QuerySnapshot> getUsuarios() {
    return dbUsuarios.snapshots();
  }

  Future<List<DocumentSnapshot>> getUsuariosSnapshot() {
    return dbUsuarios.get().then((snapshot) => snapshot.docs);
  }

  Future<String> getUidUsuarioByCorreo(String correo) {
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

  // Future<void> deleteUsuario(String uid) async {
  //   await dbUsuarios.doc(uid).delete();
  // }
}