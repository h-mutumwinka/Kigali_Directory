import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' as auth;
import '../providers/place_provider.dart';
import 'navigation_screen.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth.AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const LoginScreen();
    }

    if (!user.emailVerified) {
      return const EmailVerificationScreen();
    }

    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaceProvider>(context, listen: false).seedData(user.uid);
    });

    return const MainNavigationScreen();
  }
}
