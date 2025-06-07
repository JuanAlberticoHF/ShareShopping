
import 'package:flutter/material.dart';

class PerfilUsuarioPage extends StatelessWidget {
  const PerfilUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: Center(
        child: Text(
          'Contenido del perfil de usuario',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}