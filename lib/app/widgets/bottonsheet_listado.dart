import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/listados_service_fb.dart';

import 'bottonsheet_compartir.dart';
import 'editar_nombre_dialog.dart';

/// Widget que representa las opciones de un listado del usuario (editar, compartir, eliminar)
class OpcionesListado extends StatelessWidget {
  final String _idLista; // Identificador de la lista
  final String _nombreLista; // Nombre de la lista

  OpcionesListado({
    super.key,
    required String idLista,
    required String nombreLista,
  }) : _nombreLista = nombreLista, _idLista = idLista;

  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados _fireStoreServiceListados = FireStoreServiceListados();

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
                // ACCION EDITAR
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                    EditarNombreDialog.show(
                      context,
                      nombreInicial: _nombreLista,
                      onSave: (nuevoNombre) {
                        _fireStoreServiceListados.updateListadoName(
                          _idLista,
                          nuevoNombre,
                        );
                      },
                    );
                  },
                ),
                // ACCION COMPARTIR
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
                        idLista: _idLista,
                        nombreLista: _nombreLista,
                      ),
                    );
                  },
                ),
                // ACCION ELIMINAR
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar'),
                  onTap: () {
                    _fireStoreServiceListados.updateListadoOperativo(_idLista, false);
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
