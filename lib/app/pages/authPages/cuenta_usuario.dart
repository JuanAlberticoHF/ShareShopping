
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsuarioLogged extends StatelessWidget {
  const UsuarioLogged({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Usuario conectado:',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            user.uid ?? 'No hay ID de usuario disponible',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Text(
            user.email ?? 'No hay email disponible',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}