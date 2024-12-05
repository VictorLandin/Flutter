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
      // Verificar si el nombre de usuario ya existe
      final usernameSnapshot = await _db.child('usernames/$name').get();
      if (usernameSnapshot.exists) {
        return 'El nombre de usuario ya está en uso';
      }

      // Crear el usuario en Firebase Authentication
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Guardar datos del usuario
      await _db.child('users/$userId').set({
        'name': name,
        'email': email,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Asociar el nombre de usuario con el userId
      await _db.child('usernames/$name').set(userId);

      return null; // Registro exitoso
    } catch (e) {
      return 'Error al registrar usuario: ${e.toString()}';
    }
  }

  Future<String?> signIn(String emailOrUsername, String password) async {
    try {
      String email = emailOrUsername;

      if (!isValidEmail(emailOrUsername)) {
        // Buscar el userId asociado al nombre de usuario
        final usernameSnapshot = await _db.child('usernames/$emailOrUsername').get();
        if (!usernameSnapshot.exists) {
          return 'Nombre de usuario no encontrado';
        }

        final userId = usernameSnapshot.value as String;

        // Buscar el correo electrónico asociado al userId
        final userSnapshot = await _db.child('users/$userId').get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<String, dynamic>;
          email = userData['email'];
        } else {
          return 'Usuario no encontrado';
        }
      }

      // Intentar iniciar sesión con el correo electrónico obtenido
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null; // Inicio de sesión exitoso
    } catch (e) {
      return 'Error al iniciar sesión: ${e.toString()}';
    }
  }

  bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }

  Future<bool> deleteAccount(String password) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Reautenticar al usuario
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);

        final userId = user.uid;

        // Obtener el nombre de usuario asociado
        final userSnapshot = await _db.child('users/$userId').get();
        if (userSnapshot.exists) {
          final userData = userSnapshot.value as Map<String, dynamic>;
          final username = userData['name'];

          // Eliminar el nombre de usuario del nodo usernames
          await _db.child('usernames/$username').remove();
        }

        // Eliminar los datos del usuario
        await _db.child('users/$userId').remove();

        // Eliminar la cuenta de Firebase Authentication
        await user.delete();

        return true; // Operación exitosa
      }

      return false; // Usuario no autenticado
    } catch (e) {
      debugPrint('Error al eliminar la cuenta: $e');
      return false;
    }
  }
}
