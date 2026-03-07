import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';
import '../services/mock_user.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService = AuthService();

  User? user;

  AuthProvider() {
    // Only check for current user if Firebase is initialized
    if (Firebase.apps.isNotEmpty) {
      user = _authService.currentUser;
      // Listen to auth state changes
      _authService.authState.listen((User? currentUser) {
        user = currentUser;
        notifyListeners();
      });
    } else {
      // Firebase not initialized - start with no user
      user = null;
      debugPrint('⚠️ Firebase not initialized - starting at login screen');
    }
  }

  // Demo mode: Skip authentication
  void setDemoMode({String? email, String? displayName}) {
    user = MockUser(
      email: email ?? 'demo@kigali.rw',
      displayName: displayName ?? email?.split('@')[0] ?? 'Demo User',
    );
    notifyListeners();
    debugPrint('✅ Demo mode activated - user: ${user?.email}');
  }

  Future signUp(String email, String password) async {

    user = await _authService.signUp(email, password);
    
    // If Firebase signup returns null, return null (caller will handle demo mode)
    if (user == null) {
      debugPrint('⚠️ Firebase signup failed - returning null');
      return null;
    }

    notifyListeners();
    return user;
  }

  Future login(String email, String password) async {

    user = await _authService.login(email, password);
    
    // If Firebase login returns null, return null (caller will handle demo mode)
    if (user == null) {
      debugPrint('⚠️ Firebase login failed - returning null');
      return null;
    }

    notifyListeners();
    return user;
  }

  Future logout() async {

    await _authService.logout();

    user = null;

    notifyListeners();
  }

}