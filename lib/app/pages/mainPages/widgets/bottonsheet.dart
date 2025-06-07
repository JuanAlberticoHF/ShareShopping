
import 'package:flutter/material.dart';

class opcionesListado extends StatelessWidget{

  const opcionesListado({super.key, required this.idLista});

  final String idLista; // Identificador único de la lista

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        // LISTA DE ACCIONES
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // EDITAR, COMPARTIR, ELIMINAR
            children: <Widget>[
              ListTile( // EDITAR
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar'),
                onTap: () {
                  Navigator.pop(context);
                  print("BottomSheet - Editar: $idLista");
                },
              ),
              ListTile( // COMPARTIR
                leading: const Icon(Icons.person_add, color: Colors.green),
                title: const Text('Compartir'),
                onTap: () {
                  Navigator.pop(context);
                  print("BottomSheet - Compartir: $idLista");
                },
              ),
              ListTile( // ELIMINAR
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar'),
                onTap: () {
                  Navigator.pop(context);
                  print("BottomSheet - Eliminar: $idLista");
                },
              ),
            ],
          ),
        );
      },
      onClosing: () {  },
    );
  }
}