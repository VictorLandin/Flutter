import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyA4lhVKwQIFE_SrQZ4PGshdWLS3vzOvOq4';
  final storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _updateAuthState(user); // Actualizar el estado de autenticación
    });
  }

  void _updateAuthState(User? user) {
    _isAuthenticated = user != null;
    notifyListeners(); // Notificar a los widgets dependientes
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://noticias-trabajo-practicas-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  Future<String?> createUser(String email, String password, String name) async {
    try {
      // Crear el usuario en Firebase Authentication
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String userId = userCredential.user!.uid;

      // Guardar datos del usuario en Realtime Database
      await _db.child('users/$userId').set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Guardar token en el almacenamiento seguro
      final String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        await storage.write(key: 'token', value: token);
      }

      return null; // Éxito
    } catch (e) {
      return 'Error al registrar usuario: ${e.toString()}';
    }
  }

  Future<String?> signInWithEmailOrUsername(String emailOrUsername, String password) async {
    try {
      String email = emailOrUsername;

      // Si no es un correo válido, buscar el correo usando el nombre de usuario
      if (!isValidEmail(emailOrUsername)) {
        final DatabaseEvent snapshot = await _db
            .child('users')
            .orderByChild('name')
            .equalTo(emailOrUsername)
            .once();

        if (snapshot.snapshot.value == null) {
          return 'Usuario no encontrado';
        }

        final Map<String, dynamic> userData = Map<String, dynamic>.from(
            (snapshot.snapshot.value as Map).values.first);
        email = userData['email'];
      }

      // Iniciar sesión con Firebase Authentication
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Guardar token en el almacenamiento seguro
      final String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        await storage.write(key: 'token', value: token);
      }

      return null; // Éxito
    } catch (e) {
      return 'Error al iniciar sesión: ${e.toString()}';
    }
  }

  // Validar si es un correo electrónico válido
  bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

  // Cerrar sesión
  Future<void> logout() async {
    await _auth.signOut();
    await storage.delete(key: 'token');
    _updateAuthState(null); // Actualizar el estado después del logout
  }


  // Leer el token almacenado
  Future<String?> readToken() async {
    return await storage.read(key: 'token');
  }
}
