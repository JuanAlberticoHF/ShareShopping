import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/listados_service_fb.dart';

import '../../core/services/auth_service.dart';

/// Widget que representa la opcion de un listado compartido para salir
class OpcionesListadoSalir extends StatelessWidget {
  final String _idLista; // Identificador de la lista

  OpcionesListadoSalir({
    super.key,
    required String idLista,
  }) : _idLista = idLista;

  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados _fireStoreService = FireStoreServiceListados();

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
                // ACCION SALIR LISTADO
                ListTile(
                  leading: const Icon(Icons.output, color: Colors.red),
                  title: const Text('Salir de la lista'),
                  onTap: () {
                    _fireStoreService.updateListadoCompartidosRemove(
                      _idLista,
                      authServiceNotifier.value.currentUser!.uid,
                    );
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
