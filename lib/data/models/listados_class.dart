
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'articulos_class.dart';

class ListadosClass {
  String id ;
  String nombre;
  String creador;
  Timestamp fechaCreacion;
  Timestamp fechaModificacion;
  Articulos articulos;

  ListadosClass({
    required this.id,
    required this.nombre,
    required this.creador,
    required this.fechaCreacion,
    required this.fechaModificacion,
    required this.articulos,
  });

  ListadosClass.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        nombre = data['nombre'],
        creador = data['creador'],
        fechaCreacion = data['fechaCreacion'],
        fechaModificacion = data['fechaModificacion'],
        articulos = Articulos.fromMap(data['articulos']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'creador': creador,
      'fechaCreacion': fechaCreacion,
      'fechaModificacion': fechaModificacion,
      'articulos': articulos.toMap(),
    };
  }

}