
import 'package:flutter/material.dart';

class OpcionesListado extends StatelessWidget{

  const OpcionesListado({super.key, required this.idLista});

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
              Container(
                width: 150,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 8),
              Text("Opciones", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              ListTile( // EDITAR
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Editar'),
                onTap: () { // TODO EDITAR
                  Navigator.pop(context);
                },
              ),
              ListTile( // COMPARTIR
                leading: const Icon(Icons.person_add, color: Colors.green),
                title: const Text('Compartir'),
                onTap: () { // TODO COMPARTIR
                  Navigator.pop(context);
                },
              ),
              ListTile( // ELIMINAR
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Eliminar'),
                onTap: () { // TODO ELIMINAR
                  Navigator.pop(context);
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