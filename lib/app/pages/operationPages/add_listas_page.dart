import 'package:flutter/material.dart';

import '../../../core/services/listados_fb.dart';


class AddListasPage extends StatelessWidget {
  AddListasPage({super.key});

  final TextEditingController _controller = TextEditingController();
  final FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
      ),
      resizeToAvoidBottomInset: true, // Asegura que el contenido se ajuste cuando aparece el teclado
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Logo aplicación en la parte superior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/logo.png',
              height: 100,
            ),
          ),
          // TextField en la parte superior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nueva lista',
                hintStyle: TextStyle(fontSize: 20),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Spacer(),
          // Botón en la parte inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue, // Color del botón
              ),
              onPressed: () {
                String nombreLista = _controller.text;
                if (nombreLista.isEmpty) {
                  nombreLista = "Nueva Lista";
                }
                fireStoreService.addListado(nombreLista);
                _controller.clear(); // Limpiar el campo de texto después de crear la lista
                Navigator.pop(context);
              },
              child: Text('Crear', style: TextStyle(color: Colors.white, fontSize: 28)),
            ),
          ),
        ],
      ),
    );
  }
}