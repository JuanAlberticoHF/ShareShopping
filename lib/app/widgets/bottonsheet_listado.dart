import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/listados_service_fb.dart';

import 'bottonsheet_compartir.dart';
import 'editar_nombre_dialog.dart';

class OpcionesListado extends StatelessWidget {
  OpcionesListado({super.key, required this.idLista,required this.nombreLista});

  final String idLista;
  final FireStoreServiceListados fireStoreService = FireStoreServiceListados();
  final String nombreLista;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  "Opciones",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                    EditarNombreDialog.show(
                      context,
                      nombreInicial: nombreLista,
                      onSave: (nuevoNombre) {
                        fireStoreService.updateListadoName(
                          idLista,
                          nuevoNombre,
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.green),
                  title: const Text('Compartir'),
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // Esto permite que el BottomSheet se ajuste al teclado
                      builder: (context) => CompartirLista(
                        idLista: idLista,
                        nombreLista: nombreLista,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar'),
                  onTap: () {
                    fireStoreService.updateListadoOperativo(idLista, false);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
    );
  }
}
