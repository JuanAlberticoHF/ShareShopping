import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/usuarios_service_fb.dart';

import '../../core/services/listados_service_fb.dart';

/// Widget para compartir una lista con otros usuarios
class CompartirLista extends StatelessWidget {
  final String _idLista; // Identificador de la lista

  CompartirLista({
    super.key,
    required String idLista,
    required String nombreLista
  }) : _idLista = idLista;

  /// Servicio para interactuar con la coleccion 'usuarios' en Firestore
  final FireStoreServiceUsuarios _fireStoreServiceUsuarios = FireStoreServiceUsuarios();

  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados _fireStoreServiceListados = FireStoreServiceListados();

  // Controlador de texto para el campo de correo electrónico
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: Colors.white,
      onClosing: () {},
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              // <-- Envuelve aquí
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    'COMPARTIR',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Introduce el correo del usuario a compartir',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        final uid = await _fireStoreServiceUsuarios
                            .getUidByCorreo(email);
                        if (await _fireStoreServiceListados.existsUidCompartido(
                          _idLista,
                          uid,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'La lista ya está compartida con $email',
                              ),
                            ),
                          );
                        } else if (await _fireStoreServiceListados.isUidCreador(
                          _idLista,
                          uid,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'No puedes compartir la lista contigo mismo',
                              ),
                            ),
                          );
                          return;
                        } else {
                          await _fireStoreServiceListados
                              .updateListadoCompartidosAdd(_idLista, uid);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lista compartida con $email'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: Text('Compartir', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
