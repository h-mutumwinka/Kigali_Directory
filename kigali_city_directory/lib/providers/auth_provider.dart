import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService = AuthService();

  User? user;

  AuthProvider() {
    user = _authService.currentUser;
    _authService.authState.listen((User? currentUser) {
      user = currentUser;
      notifyListeners();
    });
  }

  Future signUp(String email, String password) async {
    user = await _authService.signUp(email, password);
    notifyListeners();
    return user;
  }

  Future login(String email, String password) async {
    user = await _authService.login(email, password);
    notifyListeners();
    return user;
  }

  Future logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }

}