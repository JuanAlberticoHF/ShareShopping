import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';

/// Página para iniciar sesión en la aplicación
class IniciarSesionPage extends StatefulWidget {
  const IniciarSesionPage({super.key});

  @override
  State<IniciarSesionPage> createState() => _IniciarSesionPageState();
}

class _IniciarSesionPageState extends State<IniciarSesionPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _emailController = TextEditingController(); // Controlador de texto para el campo de correo electrónico
  final _passwordController = TextEditingController(); // Controlador de texto para el campo de contraseña

  /// Inicio de sesión en Firebase Auth
  void iniciarSesion() async {
    try {
      await authServiceNotifier.value.iniciarSesion(
        _emailController.text,
        _passwordController.text,
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error desconocido: $e')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inicio de sesion exitoso')),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Crea un campo de texto personalizado para el formulario
  Widget _textFieldPersonalizado({
    required String texto,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: texto,
        border: const OutlineInputBorder(),
      ),
      obscureText: obscure,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo obligatorio';
        }
        if (texto == 'Correo Electrónico' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Correo inválido';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.white70,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.login,
                  size: 100,
                  color: Colors.black87,
                ),
                const SizedBox(height: 24),
                _textFieldPersonalizado(
                  texto: 'Correo Electrónico',
                  controller: _emailController,
                ),
                const SizedBox(height: 16.0),
                _textFieldPersonalizado(
                  texto: 'Contraseña',
                  controller: _passwordController,
                  obscure: true,
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      iniciarSesion();
                    }
                  },
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}