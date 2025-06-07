
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class FireStoreService {
  final CollectionReference dbListados = FirebaseFirestore.instance.collection('listados');

  // CREATE: añadir un nuevo listado
  // Crea un nuevo listado con el nombre proporcionado
  Future<void> addListado(String nombre) async {
    final listadoObj = <String, dynamic>{
      'nombre': nombre,
      'creador': 1, // TODO : Cambiar por el ID del usuario actual
      'fecha_creacion': Timestamp.fromDate(DateTime.now()),
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
      'articulos': [],
    };
    await dbListados.add(listadoObj);
  }

  // READ:
  //Devuelve un Stream de QuerySnapshot
  Stream<QuerySnapshot> getListados() {
    return dbListados.snapshots();
  }
  //Obtener un listado por ID devuelve un Future de DocumentSnapshot
  Future<DocumentSnapshot> getListadoById(String id) {
    return dbListados.doc(id).get();
  }

  Stream<DocumentSnapshot> getListadoStreamById(String id) {
    return dbListados.doc(id).snapshots();
  }

  // UPDATE: actualizar un listado
  // Future<void> updateListado(String id, String titulo, String descripcion) async {
  //   final listadoObj = <String, String>{
  //     'titulo': titulo,
  //     'descripcion': descripcion,
  //     'fechaModificacion': DateTime.now().toIso8601String(),
  //   };
  //   await dbListados.doc(id).update(listadoObj);
  // }
  // updateListadoArticulos():
  Future<void> updateListado(String id, List<dynamic> articulos) async {
    final listadoObj = <String, dynamic>{
      'articulos': articulos,
      'fecha_modificacion': Timestamp.fromDate(DateTime.now()),
    };
    await dbListados.doc(id).update(listadoObj);
  }

  // updateArticuloCheck():
  Future<void> updateArticuloCheck(String id, int index, bool bool) async {
    // Obtiene el listado por ID
    DocumentSnapshot doc = await dbListados.doc(id).get();
    if (doc.exists) {
      // Obtiene los artículos del listado
      List<dynamic> articulos = doc.get('articulos');
      // Actualiza el artículo en la posición index
      if (index < articulos.length) {
        articulos[index]['check'] = bool;
        // Actualiza el listado con los artículos modificados
        await updateListado(id, articulos);
      }
    }
  }

  // Delete: eliminar un listado
  Future<void> deleteListado(String id) async {
    await dbListados.doc(id).delete();
  }

}