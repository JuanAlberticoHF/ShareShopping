import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../core/services/listados_fb.dart';
import '../../core/services/usuarios_fb.dart';

class OpcionesGestionarCompartir extends StatefulWidget {
  final String idLista;
  final String nombreLista;

  const OpcionesGestionarCompartir({
    super.key,
    required this.idLista,
    required this.nombreLista,
  });

  @override
  State<OpcionesGestionarCompartir> createState() => _OpcionesGestionarCompartirState();
}

class _OpcionesGestionarCompartirState extends State<OpcionesGestionarCompartir> {
  final FireStoreServiceUsers fireStoreServiceUsers = FireStoreServiceUsers();
  final FireStoreService fireStoreService = FireStoreService();

  late Future<List<DocumentSnapshot>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _usuariosFuture = getUsuariosEnListado();
  }

  Future<List<DocumentSnapshot>> getUsuariosEnListado() async {
    final listado = await fireStoreService.getUsuariosListado(widget.idLista);
    final usuarios = await fireStoreServiceUsers.getUsuariosSnapshot();
    return usuarios.where((usuario) => listado.contains(usuario.id)).toList();
  }

  Future<void> eliminarUsuarioDeListado(String userId) async {
    await fireStoreService.updateListadoCompartidosRemove(widget.idLista, userId);
    setState(() {
      _usuariosFuture = getUsuariosEnListado();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado de la lista')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _usuariosFuture,
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
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await eliminarUsuarioDeListado(usuario.id);
                              },
                            ),
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
