import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'navigation_screen.dart';
import 'auth_wrapper.dart';

/// Wrapper that bypasses auth on web for demo purposes
/// On mobile (Android/iOS), uses full authentication
class WebDemoWrapper extends StatelessWidget {
  const WebDemoWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // On web: Skip authentication for demo
    if (kIsWeb) {
      return const MainNavigationScreen();
    }
    
    // On mobile: Use full authentication
    return const AuthWrapper();
  }
}
