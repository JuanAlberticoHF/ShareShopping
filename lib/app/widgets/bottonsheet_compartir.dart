import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/usuarios_service_fb.dart';

import '../../core/services/listados_service_fb.dart';

class CompartirLista extends StatelessWidget {
  final String idLista;
  final String nombreLista;
  final TextEditingController emailController = TextEditingController();
  final FireStoreServiceUsuarios fireStoreServiceUsers = FireStoreServiceUsuarios();
  final FireStoreServiceListados fireStoreService = FireStoreServiceListados();

  CompartirLista({super.key, required this.idLista, required this.nombreLista});

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
                    controller: emailController,
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
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        final uid = await fireStoreServiceUsers
                            .getUidByCorreo(email);
                        if (await fireStoreService.existsUidCompartido(
                          idLista,
                          uid,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'La lista ya está compartida con $email',
                              ),
                            ),
                          );
                        } else if (await fireStoreService.isUidCreador(
                          idLista,
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
                          await fireStoreService.updateListadoCompartidosAdd(
                            idLista,
                            uid,
                          );
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
