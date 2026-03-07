import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import 'navigation_screen.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final user = authProvider.user;

    // Not logged in - show login screen
    if (user == null) {
      return const LoginScreen();
    }

    // Logged in but email not verified - show verification screen
    if (!user.emailVerified) {
      return const EmailVerificationScreen();
    }

    // Logged in and email verified - show main app
    return const MainNavigationScreen();
  }
}
