import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/services/listados_fb.dart';
import '../../core/services/usuarios_fb.dart';

class OpcionesVisualizarCompartir extends StatefulWidget {
  final String idLista;
  final String nombreLista;

  const OpcionesVisualizarCompartir({
    super.key,
    required this.idLista,
    required this.nombreLista,
  });

  @override
  State<OpcionesVisualizarCompartir> createState() =>
      _OpcionesVisualizarCompartirState();
}

class _OpcionesVisualizarCompartirState
    extends State<OpcionesVisualizarCompartir> {
  final FireStoreServiceUsers fireStoreServiceUsers = FireStoreServiceUsers();
  final FireStoreService fireStoreService = FireStoreService();

  Future<List<DocumentSnapshot>> getUsuariosEnListado() async {
    final listado = await fireStoreService.getUsuariosListado(widget.idLista);
    // Añadimos el creador del listado al listado
    listado.add(await fireStoreService.getUidCreadorById(widget.idLista));
    final usuarios = await fireStoreServiceUsers.getUsuariosSnapshot();
    return usuarios.where((usuario) => listado.contains(usuario.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: getUsuariosEnListado(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final usuarios = snapshot.data ?? [];

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
                    const SizedBox(height: 8),
                    const Text(
                      'Usuarios en la lista',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 72 * 3, // Altura para 3 ListTiles
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: usuarios.length,
                        itemBuilder: (context, index) {
                          final usuario = usuarios[index];
                          return ListTile(
                            title: Text(usuario['correo'] ?? 'Sin correo'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
