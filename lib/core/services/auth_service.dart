
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

/// Servicio de autenticación para manejar el inicio de sesión, registro, cambio de contraseña y cierre de sesión
ValueNotifier<AuthService> authServiceNotifier = ValueNotifier<AuthService>(AuthService());

/// Clase que maneja la autenticación de usuarios utilizando Firebase Auth
class AuthService {
  // Instancia de FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Obtiene el usuario actual conectado a Firebase Auth
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream que emite cambios en el estado de autenticación del usuario
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Inicia sesión con correo electrónico y contraseña
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario.
  /// - [password]: Contraseña del usuario.
  Future<User?> iniciarSesion(String email, String password) async {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
  }

  /// Registra un nuevo usuario con correo electrónico y contraseña.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario.
  /// - [password]: Contraseña del usuario.
  Future<User?> crearUsuario(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  /// Cierra la sesión del usuario actual.
  Future<void> cerrarSesion() async {
    await _firebaseAuth.signOut();
  }
}