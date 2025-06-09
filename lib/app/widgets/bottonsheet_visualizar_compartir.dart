import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/services/listados_service_fb.dart';
import '../../core/services/usuarios_service_fb.dart';

/// Widget para visualizar los usuarios en una lista compartida
class OpcionesVisualizarCompartir extends StatefulWidget {
  final String _idLista; // Identificador de la lista

  const OpcionesVisualizarCompartir({
    super.key,
    required String idLista,
  }) : _idLista = idLista;

  @override
  State<OpcionesVisualizarCompartir> createState() => _OpcionesVisualizarCompartirState();
}

class _OpcionesVisualizarCompartirState extends State<OpcionesVisualizarCompartir> {
  /// Servicio para interactuar con la coleccion 'usuarios' en Firestore
  final FireStoreServiceUsuarios fireStoreServiceUsuarios = FireStoreServiceUsuarios();
  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados fireStoreServiceListados = FireStoreServiceListados();

  /// Obtiene los usuarios que están en el listado compartido junto al creador
  Future<List<DocumentSnapshot>> getUsuariosEnListado() async {
    final listado = await fireStoreServiceListados.getUsuariosListado(widget._idLista);
    listado.add(await fireStoreServiceListados.getUidCreadorById(widget._idLista));
    final usuarios = await fireStoreServiceUsuarios.getUsuariosSnapshot();
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
