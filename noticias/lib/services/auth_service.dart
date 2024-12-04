import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyA4lhVKwQIFE_SrQZ4PGshdWLS3vzOvOq4';
  final storage = const FlutterSecureStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://noticias-trabajo-practicas-default-rtdb.europe-west1.firebasedatabase.app',
  ).ref();

  User? get currentUser => _auth.currentUser;

  String? _currentUserName;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  String get currentUserName => _currentUserName ?? 'Invitado';

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _updateAuthState(user);
    });
  }

  void _updateAuthState(User? user) async {
    _isAuthenticated = user != null;

    if (_isAuthenticated) {
      final userId = user!.uid;
      final snapshot = await _db.child('users/$userId').get();

      if (snapshot.exists) {
        final userData = snapshot.value as Map;
        _currentUserName = userData['name'] ?? 'Usuario';
      } else {
        _currentUserName = 'Usuario';
      }
    } else {
      _currentUserName = 'Invitado';
    }

    notifyListeners(); // Notifica a los widgets dependientes.
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserName = 'Invitado';
    await _auth.signOut();
    await storage.delete(key: 'token');
    notifyListeners();
  }

  Future<String?> createUser(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;
      await _db.child('users/$userId').set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      return null; // Success
    } catch (e) {
      return 'Error al registrar usuario: ${e.toString()}';
    }
  }

  Future<String?> signInWithEmailOrUsername(String emailOrUsername, String password) async {
    try {
      String email = emailOrUsername;

      if (!isValidEmail(emailOrUsername)) {
        final snapshot = await _db
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

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null; // Success
    } catch (e) {
      return 'Error al iniciar sesión: ${e.toString()}';
    }
  }

  bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }
}
