
import 'package:async/async.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'auth_service.dart';

class FireStoreService {
  final CollectionReference dbListados = FirebaseFirestore.instance.collection('listados');

  // CREATE: añadir un nuevo listado
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

  // READ:
  Stream<QuerySnapshot> getListados() {
    return dbListados.snapshots();
  }

  Future<DocumentSnapshot> getListadoById(String id) {
    return dbListados.doc(id).get();
  }

  Stream<QuerySnapshot> getListadosByCreador(String creadorUid) {
    return dbListados.where('creador', isEqualTo: creadorUid).snapshots();
  }

  Stream<QuerySnapshot> getListadosByCreadorCompartidos(String creadorUid) {
    return dbListados.where('creador', isEqualTo: creadorUid)
        .where('compartidos', isNotEqualTo: []).snapshots();
  }

  Stream<QuerySnapshot> getListadosByCreadorNoCompartidos(String creadorUid) {
    return dbListados.where('creador', isEqualTo: creadorUid)
        .where('compartidos', isEqualTo: []).snapshots();
  }

  Stream<List<QueryDocumentSnapshot>> getListadosCreadorOCompartido(String uid) {
    final creadorCompartidos = dbListados
        .where('creador', isEqualTo: uid)
        .where('compartidos', isNotEqualTo: [])
        .snapshots();

    final compartidos = dbListados
        .where('compartidos', arrayContains: uid)
        .snapshots();

    return StreamGroup.merge([
      creadorCompartidos,
      compartidos,
    ]).map((snapshot) => snapshot.docs);
  }

  Stream<QuerySnapshot> getListadosByCompartidos(String uid) {
    return dbListados.where('compartidos', arrayContains: uid).snapshots();
  }

  Stream<DocumentSnapshot> getListadoStreamById(String id) {
    return dbListados.doc(id).snapshots();
  }

  Future<bool> existsUidCompartido(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      List<dynamic> compartidos = doc.get('compartidos');
      return compartidos.contains(uid);
    }
    return false;
  }

  Future<bool> isUidCreador(String id, String uid) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      String creador = doc.get('creador');
      return creador == uid;
    }
    return false;
  }

  // UPDATE: actualizar un listado
  Future<void> updateListadoName(String id, String nombre) async {
    final listadoObj = <String, dynamic>{
      'nombre': nombre,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  Future<void> updateListado(String id, List<dynamic> articulos) async {
    final listadoObj = <String, dynamic>{
      'articulos': articulos,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  Future<void> updateArticuloCheck(String id, int index, bool bool) async {
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      List<dynamic> articulos = doc.get('articulos');
      if (index < articulos.length) {
        articulos[index]['check'] = bool;
        await updateListado(id, articulos);
      }
    }
  }

  Future<void> updateListadoOperativo(String id, bool operativa) async {
    final listadoObj = <String, dynamic>{
      'operativa': operativa,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  Future<void> updateListadoCompartidos(String id, List<String> compartidos) async {
    final listadoObj = <String, dynamic>{
      'compartidos': compartidos,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

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

  // DELETE: eliminar un listado
  Future<void> deleteListado(String id) async {
    await dbListados.doc(id).delete();
  }
}