
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

  Stream<DocumentSnapshot> getListadoStreamById(String id) {
    return dbListados.doc(id).snapshots();
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

  Future<void> deleteListado(String id) async {
    await dbListados.doc(id).delete();
  }
}