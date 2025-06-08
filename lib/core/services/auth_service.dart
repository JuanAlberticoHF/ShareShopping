
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

ValueNotifier<AuthService> authServiceNotifier = ValueNotifier<AuthService>(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Obtiene el usuario actual
  User? get currentUser => firebaseAuth.currentUser;

  // Cambios de estado de FireBase (conectado/desconectado)

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  // Iniciar sesión con correo electrónico y contraseña
  Future<User?> iniciarSesion(String email, String password) async {

      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
  }

  // Registrar un nuevo usuario con correo electrónico y contraseña
  Future<User?> crearUsuario(String email, String password) async {
    UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Cambiar contraseña del usuario
  Future<void> cambiarCredenciales({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: oldPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await firebaseAuth.signOut();
  }

  // Eliminar cuenta del usuario
  Future<void> eliminarCuenta ({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }
}