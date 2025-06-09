import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/listados_fb.dart';

import '../../core/services/auth_service.dart';

class OpcionesListadoSalir extends StatelessWidget {
  OpcionesListadoSalir({
    super.key,
    required this.idLista,
    required this.nombreLista,
  });

  final String idLista;
  final FireStoreService fireStoreService = FireStoreService();
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
                  leading: const Icon(Icons.output, color: Colors.red),
                  title: const Text('Salir de la lista'),
                  onTap: () {
                    fireStoreService.updateListadoCompartidosRemove(
                      idLista,
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
