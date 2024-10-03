import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyA4lhVKwQIFE_SrQZ4PGshdWLS3vzOvOq4';
  final storage = const FlutterSecureStorage();

  // Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> createUser(String email, String password, String name) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);

      // Store additional user info in Firestore
      await _db.collection('users').doc(decodedResp['localId']).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      return null; // Success
    } else {
      return decodedResp['error']['message'];
    }
  }

  // Iniciar sesión con correo o nombre de usuario
  Future<String?> signInWithEmailOrUsername(String emailOrUsername, String password) async {
    String email = emailOrUsername;

    // Si es un nombre de usuario, buscamos el correo en Firestore
    if (!isValidEmail(emailOrUsername)) {
      final userDoc = await _db.collection('users')
          .where('username', isEqualTo: emailOrUsername)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        email = userDoc.docs.first.data()['email'];
      } else {
        return 'Usuario no encontrado';
      }
    }

    // Autenticación con Firebase usando correo electrónico
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null; // Success
    } else {
      return decodedResp['error']['message'];
    }
  }

  // Método auxiliar para validar si es un correo
  bool isValidEmail(String input) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(input);
  }


  // Logout the user
  Future logout() async {
    await storage.delete(key: 'token');
  }

  // Read the token
  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
