import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthNotifier() {
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getString('token') != null;
    notifyListeners();
  }

  Future<void> login(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    _isAuthenticated = false;
    notifyListeners();
  }
}
