import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shareshopping/app/pages/authPages/sin_cuenta_page.dart';
import '../../../core/services/auth_service.dart';

class PerfilUsuarioPage extends StatelessWidget {
  const PerfilUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: authServiceNotifier,
        builder: (context, authServiceNotifier, child) {
          return StreamBuilder(
            stream: authServiceNotifier.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black,
                        child: const Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.badge, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              user.uid,
                              style: const TextStyle(fontSize: 15, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.email, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              user.email ?? '',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text('Cerrar sesión'),
                        onTap: () async {
                          await authServiceNotifier.cerrarSesion();
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        tileColor: Colors.red.shade50,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              } else {
                return const SinCuentaPage();
              }
            },
          );
        },
      ),
    );
  }
}