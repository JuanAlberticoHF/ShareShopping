import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'auth_service.dart';

/// Servicio para gestionar los listados en FireStore Database
class FireStoreServiceListados {
  final CollectionReference dbListados = FirebaseFirestore.instance.collection(
    'listados',
  );

  /// Agrega un nuevo listado a la colección `listados` en Firestore.
  ///
  /// Parámetros:
  /// - [nombre]: Nombre del listado.
  ///
  /// Crea un documento con los campos `nombre`, `creador`, `operativa`, `fecha_creacion`, `fecha_modificacion`, `compartidos` y `articulos`.
  Future<void> addListado(String nombre) async {
    final String? uidUsuarioActivo = authServiceNotifier.value.currentUser?.uid;
    final listadoObj = <String, dynamic>{
      'nombre': nombre,
      'creador': uidUsuarioActivo ?? "1",
      'operativa': true,
      'fecha_creacion': Timestamp.fromDate(DateTime.now()),
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
      'compartidos': [],
      'articulos': [],
    };
    await dbListados.add(listadoObj);
  }

  /// Stream para obtener actualizaciones en tiempo real de la colección `listados`.
  Stream<QuerySnapshot> getListados() {
    return dbListados.snapshots();
  }

  /// Obtiene un listado por su ID.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  Future<DocumentSnapshot> getListadoById(String id) {
    return dbListados.doc(id).get();
  }

  /// Devuelve el UID del creador de un listado dado su ID.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  Future<String> getUidCreadorById(String id) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      return doc.get('creador') as String;
    } else {
      throw Exception("Listado no encontrado");
    }
  }

  /// Stream para obtener los listados creados por un usuario específico.
  ///
  /// Parámetros:
  /// - [creadorUid]: Identificador único del creador del listado.
  Stream<QuerySnapshot> getListadosByCreador(String creadorUid) {
    return dbListados.where('creador', isEqualTo: creadorUid).snapshots();
  }

  /// Devuelve la lista de usuarios que tienen acceso a un listado específico.
  /// ¡No cuenta el creador del listado!.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  Future<List<String>> getUsuariosListado(String id) {
    return dbListados.doc(id).get().then((doc) {
      if (doc.exists) {
        List<dynamic> compartidos = doc.get('compartidos');
        return compartidos.cast<String>();
      } else {
        return [];
      }
    });
  }

  /// Stream para obtener los listados compartidos con un usuario específico.
  ///
  /// Parámetros:
  /// - [uid]: Identificador único del usuario.
  Stream<QuerySnapshot> getListadosByCompartidos(String uid) {
    return dbListados.where('compartidos', arrayContains: uid).snapshots();
  }

  /// Stream para obtener un listado específico por su ID.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  Stream<DocumentSnapshot> getListadoStreamById(String id) {
    return dbListados.doc(id).snapshots();
  }

  /// Devuelve true o false si el UID de un usuario existe en los compartidos
  /// de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [uid]: Identificador único del usuario.
  Future<bool> existsUidCompartido(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      List<dynamic> compartidos = doc.get('compartidos');
      return compartidos.contains(uid);
    }
    return false;
  }

  /// Devuelve true o false si el UID de un usuario es el creador de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [uid]: Identificador único del usuario.
  Future<bool> isUidCreador(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      String creador = doc.get('creador');
      return creador == uid;
    }
    return false;
  }

  /// Actualiza el nombre de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [nombre]: Nuevo nombre del listado.
  Future<void> updateListadoName(String id, String nombre) async {
    final listadoObj = <String, dynamic>{
      'nombre': nombre,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  /// Actualiza los artículos de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [articulos]: Lista de artículos a actualizar.
  Future<void> updateListado(String id, List<dynamic> articulos) async {
    final listadoObj = <String, dynamic>{
      'articulos': articulos,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  /// Actualiza el estado operativo de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [operativa]: Estado operativo del listado (true/false).
  Future<void> updateListadoOperativo(String id, bool operativa) async {
    final listadoObj = <String, dynamic>{
      'operativa': operativa,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  /// Actualiza la lista de usuarios compartidos de un listado.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [compartidos]: Lista de IDs de usuarios que tienen acceso al listado.
  Future<void> updateListadoCompartidos(
    String id,
    List<String> compartidos,
  ) async {
    final listadoObj = <String, dynamic>{
      'compartidos': compartidos,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  /// Actualizado la lista de compartidos de un listado añadiendo un usuario.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [uid]: Identificador único del usuario a añadir.
  Future<void> updateListadoCompartidosAdd(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      List<dynamic> compartidos = doc.get('compartidos');
      if (!compartidos.contains(uid)) {
        compartidos.add(uid);
        await updateListadoCompartidos(id, compartidos.cast<String>());
      }
    }
  }

  /// Actualiza la lista de compartidos de un listado eliminando un usuario.
  ///
  /// Parámetros:
  /// - [id]: Identificador único del listado.
  /// - [uid]: Identificador único del usuario a eliminar.
  Future<void> updateListadoCompartidosRemove(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      List<dynamic> compartidos = doc.get('compartidos');
      if (compartidos.contains(uid)) {
        compartidos.remove(uid);
        await updateListadoCompartidos(id, compartidos.cast<String>());
      }
    }
  }

  /// Elimina un listado de la colección `listados` en Firestore.
  Future<void> deleteListado(String id) async {
    await dbListados.doc(id).delete();
  }
}
