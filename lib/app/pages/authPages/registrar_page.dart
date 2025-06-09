import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ShareShopping/core/services/auth_service.dart';
import 'package:ShareShopping/core/services/usuarios_service_fb.dart';

/// Página para registrar un nuevo usuario
class RegistrarPage extends StatefulWidget {
  const RegistrarPage({super.key});

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  final _emailController = TextEditingController(); // Controlador de texto para el campo de correo electrónico
  final _passwordController = TextEditingController(); // Controlador de texto para el campo de contraseña
  final _confirmController = TextEditingController(); // Controlador de texto para el campo de confirmación de contraseña

  /// Servicio para interactuar con la coleccion 'usuarios' en Firestore
  final FireStoreServiceUsuarios fireStoreServiceUsuarios = FireStoreServiceUsuarios();

  /// Registra al usuario en Firebase Auth y posteriormente en Firestore
  void _registrar() async {
    try {
      User? user = await authServiceNotifier.value.crearUsuario(
        _emailController.text,
        _passwordController.text,
      );
      String uid = user!.uid;
      String? email = user.email;

      if (email != null) {
        fireStoreServiceUsuarios.addUsuario(uid, email);
      }

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
      const SnackBar(content: Text('Registro exitoso')),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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
        if (texto == 'Confirmar contraseña' &&
            value != _passwordController.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar'),
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
              children: [
                const SizedBox(height: 70),
                const Icon(
                  Icons.key,
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
                const SizedBox(height: 16.0),
                _textFieldPersonalizado(
                  texto: 'Confirmar contraseña',
                  controller: _confirmController,
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
                      _registrar();
                    }
                  },
                  child: const Text(
                    'Registrarme',
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