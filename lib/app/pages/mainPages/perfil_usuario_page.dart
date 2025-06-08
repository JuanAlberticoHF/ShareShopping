
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shareshopping/app/pages/authPages/sin_cuenta_page.dart';

import '../../../core/services/auth_service.dart';
import '../authPages/cuenta_usuario.dart';

class PerfilUsuarioPage extends StatelessWidget {
  const PerfilUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.white70,
      ),
      backgroundColor: Colors.white70,
      body: ValueListenableBuilder(
          valueListenable: authServiceNotifier,
          builder: (context, authServiceNotifier, child) {
            return StreamBuilder (
              stream: authServiceNotifier.authStateChanges,
              builder: (context, snapshot) {
                Widget widget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  widget = CircularProgressIndicator();
                } else if (snapshot.hasData){
                  // Usuario conectado
                  User data = snapshot.data!;
                  widget = UsuarioLogged(user: data);
                } else {
                  widget = const SinCuentaPage();
                }
                return widget;
              },
            );
          }
      ),
    );
  }
}