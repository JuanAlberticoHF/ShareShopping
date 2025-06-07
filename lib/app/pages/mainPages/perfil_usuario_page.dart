
import 'package:flutter/material.dart';

class PerfilUsuarioPage extends StatelessWidget {
  const PerfilUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
      ),
      body: Center(
        child: Text(
          'Página de Perfil do Usuário',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}