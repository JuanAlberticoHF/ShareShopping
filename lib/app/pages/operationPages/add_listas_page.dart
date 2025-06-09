import 'package:flutter/material.dart';

import '../../../core/services/listados_service_fb.dart';

class AddListasPage extends StatelessWidget {
  AddListasPage({super.key});

  final TextEditingController _controller = TextEditingController();
  final FireStoreServiceListados fireStoreService = FireStoreServiceListados();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white70),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset('assets/logo.png', height: 100),
                      ),
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
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            String nombreLista = _controller.text;
                            if (nombreLista.isEmpty) {
                              nombreLista = "Nueva lista";
                            }
                            fireStoreService.addListado(nombreLista);
                            _controller.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Crear',
                            style: TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
